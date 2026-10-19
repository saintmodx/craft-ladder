-- Craft Ladder: a tab in the auction house window to buy what the ladder needs. Pick a crafting profession and its
-- mode (Skill, Skill + Gold, Gold or Favor: the Merchant's Favor recipes, one craft each; the window's own): a row per
-- step with what it costs there; a click on a step
-- unfolds a row per reagent you're short of, with how many to buy and a button: the first click asks the auction house
-- the exact price, the second buys (the game buys only from a click). With Auctionator, a step's Search button (or a
-- click on a reagent) opens its Shopping tab with a temporary list of what to buy and how many.
local _, ns = ...
local UI = ns.UI
local C = UI.C

local AuctionTab = {}
ns.AuctionTab = AuctionTab

local ROW_H = 34
local INDENT = 22 -- a reagent's row, under its step
local MODES = { { "skill", "Skill", 48 }, { "sell", "Skill + Gold", 78 }, { "gold", "Gold", 48 }, { "favor", "Favor", 52 } }
local FAVOR_TIP = "Merchant's Favor recipes, the supply camps' quartermasters sell them: what one craft of each buys" ..
    " here, what you have counted first (bars smelted from your ore when that's cheaper)."
local panel, rowPool, stepPool, profButtons
local pending -- the purchase waiting for its price or its confirmation: { item, qty, row, total }
local shown -- the ladder drawn: { data, mode, ladder }; drawn again while nothing it depends on changed
local opened -- the keys of the steps whose reagents are shown; nil: the step you're on
local crafts = 1 -- Gold: how many crafts to buy for

local hex = UI.Hex

-- The crafting professions the character has (the window's own first, if it's one).
local function professions()
    local list = {}
    for _, data in ipairs(ns.Professions) do
        local _, cap = ns.Player.Skill(data)
        if not data.kind and cap > 0 then list[#list + 1] = data end
    end
    return list
end

local function picked(list)
    local key = ns.Player.Saved().ahProf
    for _, data in ipairs(list) do if data.key == key then return data end end
    local shownProf = ns.CurrentProfession()
    for _, data in ipairs(list) do if data == shownProf then return data end end
    return list[1]
end

local function stepKey(step) return (step.recipe or step.kind) .. ":" .. step.from end

-- The item's name in the client's language, what the auction house searches; nil until the game has loaded it (asked
-- for here).
local function gameName(item)
    local name = C_Item.GetItemNameByID and C_Item.GetItemNameByID(item)
    if not name and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(item) end
    return name
end

-- What a buy list takes from the auction house, for `times` crafts: made intermediates followed into what they're
-- made of (and the ones of them bought, when a step makes some and buys the rest), vendors' goods left out. Adds to
-- acc = { [item] = { buy, need, have } }.
local function shopping(acc, buy, faction, times)
    for item, b in pairs(buy or {}) do
        local made = b.make and b.make.made or 0
        if made > 0 then shopping(acc, b.make.parts, faction, times) end
        local bought = b.buy - made
        if bought > 1e-9 and not ns.Prices.Vendor(item, faction, ns.Prices.Real()) then
            local e = acc[item] or { buy = 0, need = 0, have = 0 }
            e.buy, e.need, e.have = e.buy + bought * times, e.need + (b.need - made) * times, math.max(e.have, b.have)
            acc[item] = e
        end
    end
end

-- What some steps take from the auction house, a row per item: { item, buy, need, have }, a recipe bought there too.
-- Gold prices its rows as if nothing were owned: what the bags have is taken off here.
-- shortcut: Gold takes off only what's bought (ore), not a made intermediate in the bags (bars); upgrade if it misleads.
local function needs(ladder, steps, times)
    local acc = {}
    for _, s in ipairs(steps) do
        if s.buy then
            shopping(acc, s.buy, ladder.state.faction, times)
            if s.learn and s.learn.kind == "ah" then acc[s.learn.item] = { buy = 1, need = 1, have = 0 } end
        end
    end
    local owned = ladder.mode == "gold" and not ladder.favor and ladder.state.owned or {}
    local rows = {}
    for item, e in pairs(acc) do
        local buy = math.ceil(e.buy - (owned[item] or 0))
        if buy > 0 then rows[#rows + 1] = { item = item, buy = buy, need = e.need, have = owned[item] or e.have } end
    end
    table.sort(rows, function(a, b) return a.item < b.item end)
    return rows
end

-- What the rows cost at the auction house's last prices, and whether one has none.
local function cost(rows, lookup)
    local total, unpriced = 0, false
    for _, e in ipairs(rows) do
        local p = lookup(e.item, true)
        if p then total = total + p.unit * e.buy else unpriced = true end
    end
    return total, unpriced
end

local function status(text, color)
    panel.status:SetText(text and ((color and hex(color) or "") .. text .. "|r") or "")
end

local function auctionator()
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    return api and api.MultiSearchAdvanced and api
end

-- Auctionator's Shopping tab, with a temporary list ("CraftLadder (temporary)") of the rows' items and how many.
local function search(rows)
    local api = auctionator()
    if not api or #rows == 0 then return end
    local terms = {}
    for _, e in ipairs(rows) do
        local name = gameName(e.item)
        if not name then
            status("The items' names are still loading: click again.", C.warn)
            return
        end
        terms[#terms + 1] = { searchString = name, isExact = true, quantity = e.buy }
    end
    local ok, err = pcall(api.MultiSearchAdvanced, "CraftLadder", terms)
    if not ok then status("Auctionator: " .. tostring(err), C.bad) end
end

local function paintRow(r)
    local busy = pending and pending.row ~= r
    if pending and pending.row == r and pending.total then
        r.button.label:SetText("Confirm " .. ns.Money(pending.total))
    elseif pending and pending.row == r then
        r.button.label:SetText("Asking...")
    else
        r.button.label:SetText("Buy")
    end
    r.button:SetEnabled(not busy and not (pending and pending.row == r and not pending.total))
end

local function paintAll()
    for _, r in ipairs(rowPool.used) do paintRow(r) end
end

local function buyClick(r)
    local A = C_AuctionHouse
    if not A then return end
    if pending and pending.row == r and pending.total then -- the second click: buy
        A.ConfirmCommoditiesPurchase(pending.item, pending.qty)
        status(("Buying %d %s..."):format(pending.qty, ns.Describe.ItemName(pending.item)))
        return
    end
    local qty = math.floor(tonumber(r.count:GetText()) or 0)
    if qty <= 0 then return end
    if A.IsThrottledMessageSystemReady and not A.IsThrottledMessageSystemReady() then
        status("The auction house is busy: try again in a moment.", C.warn)
        return
    end
    r.count:ClearFocus()
    pending = { item = r.item, qty = qty, row = r }
    A.StartCommoditiesPurchase(r.item, qty)
    status(("Asking the price of %d %s..."):format(qty, ns.Describe.ItemName(r.item)))
    paintAll()
end

local function numberBox(parent)
    local box = CreateFrame("EditBox", nil, parent)
    box:SetSize(52, 22)
    UI.Panel(box, C.panel, C.edge, 5, -4)
    box:SetFont(UI.FONT, 12, "")
    box:SetTextColor(C.text[1], C.text[2], C.text[3])
    box:SetJustifyH("CENTER")
    box:SetNumeric(true)
    box:SetMaxLetters(4)
    box:SetAutoFocus(false)
    box:SetScript("OnEscapePressed", box.ClearFocus)
    box:SetScript("OnEnterPressed", box.ClearFocus)
    return box
end

-- A reagent's row: a click on it (not on its button) searches it with Auctionator, as many as its box says.
local function makeRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H - 2)
    UI.Panel(r, C.panel2, C.panel2, 5, -4)
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(24, 24)
    r.icon:SetPoint("LEFT", 6, 0)
    r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    r.name = UI.Label(r, 12)
    r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, 1)
    r.sub = UI.Label(r, 10, C.muted)
    r.sub:SetPoint("BOTTOMLEFT", r.icon, "BOTTOMRIGHT", 8, -1)
    r.button = UI.Button(r, "Buy", 130, 22, function() buyClick(r) end)
    r.button:SetPoint("RIGHT", -6, 0)
    r.count = numberBox(r)
    r.count:SetPoint("RIGHT", r.button, "LEFT", -6, 0)
    r.price = UI.Label(r, 11, C.text, nil, "RIGHT")
    r.price:SetPoint("RIGHT", r.count, "LEFT", -10, 0)
    r:SetScript("OnEnter", function(self) UI.ItemTooltip(self, self.item) end)
    r:SetScript("OnLeave", UI.HideTooltip)
    r:SetScript("OnClick", function(self)
        search({ { item = self.item, buy = math.floor(tonumber(self.count:GetText()) or 0) } })
    end)
    return r
end

local function paintStep(r)
    local on = opened[r.entry.key]
    r:SetPanelColors((on or r:IsMouseOver()) and C.hover or C.panel2, on and C.selected or C.panel2)
end

-- A step's row: a click (or its + / -) unfolds or folds its reagents; its Search button searches them all with
-- Auctionator.
local function makeStep(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H - 2)
    UI.Panel(r, C.panel2, C.panel2, 5, -4)
    r.fold = r:CreateTexture(nil, "ARTWORK")
    r.fold:SetSize(14, 14)
    r.fold:SetPoint("LEFT", 8, 0)
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(24, 24)
    r.icon:SetPoint("LEFT", r.fold, "RIGHT", 6, 0)
    r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    r.name = UI.Label(r, 12)
    r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, 1)
    r.sub = UI.Label(r, 10, C.muted)
    r.sub:SetPoint("BOTTOMLEFT", r.icon, "BOTTOMRIGHT", 8, -1)
    r.search = UI.Button(r, "Search", 70, 22, function() search(r.entry.rows) end)
    r.search:SetPoint("RIGHT", -6, 0)
    r.search.tooltip = { "Search", "Auctionator's Shopping tab with what this step buys, and how many." }
    r.cost = UI.Label(r, 11, C.text, nil, "RIGHT")
    r.cost:SetPoint("RIGHT", r.search, "LEFT", -10, 0)
    r:SetScript("OnEnter", paintStep)
    r:SetScript("OnLeave", paintStep)
    r:SetScript("OnClick", function(self)
        if #self.entry.rows == 0 then return end
        opened[self.entry.key] = not opened[self.entry.key] or nil
        AuctionTab.Refresh(true)
    end)
    return r
end

-- The ladder drawn, calculated again unless `cached` and it's the same profession and mode. Favor, as the window
-- shows it: its "Merchant's Favor recipes" bar is on (and the profession has some).
local function ladderFor(data, cached)
    local favor = ns.Player.Prof(data).favorView and ns.Favor.Count(data) > 0
    local mode = favor and "favor" or ns.LadderMode(data)
    local same = shown and shown.data == data and shown.mode == mode
    if not same then opened = nil end -- another profession or mode: the step you're on
    if not (same and cached) then
        local ladder = ns.Window.Cached(data) or ns.Calculate(data)
        shown = { data = data, mode = mode, ladder = favor and ns.Favor.Ladder(ladder, ns.db.favorPrices or {}) or ladder }
    end
    return shown.ladder
end

local function fillStep(r, e, data, lookup, gold)
    local s = e.step
    r.entry = e
    paintStep(r)
    r.fold:SetShown(#e.rows > 0)
    r.fold:SetTexture(opened[e.key] and "Interface\\Buttons\\UI-MinusButton-Up"
        or "Interface\\Buttons\\UI-PlusButton-Up")
    r.search:SetShown(#e.rows > 0 and auctionator() ~= nil)
    if s.kind == "rank" then -- a rank whose quest asks for items (Expert Cooking's)
        r.icon:SetTexture(s.rank.item and UI.ItemIcon(s.rank.item) or ns.Window.Shared.RANK_ICON[s.rank.how]
            or data.icon)
        r.name:SetText("Learn " .. s.rank.name)
        UI.SetColor(r.name, C.gold)
        r.sub:SetText(("at %d, raises your cap to %d"):format(s.from, s.rank.cap))
        return
    end
    local rec = data.recipes[s.recipe]
    r.icon:SetTexture(rec.makes and UI.ItemIcon(rec.makes) or rec.icon or data.icon)
    r.name:SetText(rec.name)
    UI.SetColor(r.name, s.color ~= "grey" and ns.Window.Shared.STEP_COLOR[s.color] or C.text)
    if s.kind == "favor" then -- coloured as the window's list: known, learn now, not yet
        UI.SetColor(r.name, s.status == "known" and C.good or s.status == "learn" and C.gold or C.bad)
        r.sub:SetText(ns.Window.Shared.favorSub(s, rec, shown.ladder.state))
    elseif gold then
        r.sub:SetText(("%s+%s|r a craft, %s"):format(hex(C.good), ns.Money(s.profit),
            s.vendor and "sold to a vendor" or (s.listed .. " listed")))
    elseif s.to > s.from then
        r.sub:SetText(("%d - %d, ~%d %s"):format(s.from, s.to, math.ceil(s.crafts), data.craftWord or "crafts"))
    else
        r.sub:SetText(("at %d, make one and keep it"):format(s.from))
    end
    local total, unpriced = cost(e.rows, lookup)
    r.cost:SetText(#e.rows == 0 and (hex(C.good) .. "nothing to buy|r")
        or ns.Money(total) .. (unpriced and (" " .. hex(C.bad) .. "+ ?|r") or ""))
end

local function fillRow(r, e, lookup)
    r.item = e.item
    r.icon:SetTexture(UI.ItemIcon(e.item))
    r.name:SetText(ns.Describe.ItemName(e.item))
    r.sub:SetText(("need %d, you have %d"):format(math.ceil(e.need), e.have))
    local p = lookup(e.item, true)
    r.price:SetText(p and (ns.Money(p.unit) .. " each") or (hex(C.bad) .. "not listed|r"))
    r.count:SetText(tostring(e.buy))
    paintRow(r)
end

-- Redraws the tab: the professions, the modes, the steps and the open ones' reagents. cached: the ladder already
-- drawn, while it's the same profession and mode.
function AuctionTab.Refresh(cached)
    if not (panel and panel:IsShown()) then return end
    local list = professions()
    local data = picked(list)
    for i, b in ipairs(profButtons) do
        local d = list[i]
        b:SetShown(d ~= nil)
        if d then
            b.data = d
            b.label:SetText(d.name)
            b:SetWidth(b.label:GetStringWidth() + 18)
            b:SetActive(d == data)
        end
    end
    rowPool:ReleaseAll()
    stepPool:ReleaseAll()
    pending = nil
    local tips = data and data.resale and ns.Window.Shared.MODE_TIPS.craft
    local lastMode
    for _, b in ipairs(panel.modes) do
        b:SetShown(tips ~= nil and (b.mode ~= "favor" or ns.Favor.Count(data) > 0))
        if b:IsShown() then lastMode = b end
    end
    panel.heading:ClearAllPoints()
    panel.heading:SetPoint("TOPLEFT", lastMode or panel, lastMode and "TOPRIGHT" or "TOPLEFT", lastMode and 12 or 14,
        lastMode and -2 or -42)
    panel.crafts:Hide()
    panel.craftsLabel:Hide()
    if not data then
        panel.heading:SetText("No crafting profession: nothing to buy for one.")
        panel.scroll:SetContentHeight(1)
        return
    end
    local ladder = ladderFor(data, cached)
    local gold = ladder.mode == "gold" and not ladder.favor
    for _, b in ipairs(panel.modes) do
        b:SetActive(b.mode == shown.mode)
        b.tooltip = tips and { b.name, tips[b.mode] or FAVOR_TIP }
    end
    panel.crafts:SetShown(gold)
    panel.craftsLabel:SetShown(gold)
    panel.crafts:SetText(tostring(crafts))
    local entries = {}
    for _, s in ipairs(ladder.steps) do
        local last = entries[#entries]
        if s.buy and last and s.kind == "craft" and last.step.kind == "craft" and s.recipe == last.step.recipe
            and s.from == last.step.to and not s.tool and not last.step.tool then
            -- one recipe on, split in the ladder by a rank learned there (no row here) or by what you have: one row
            local step = {}
            for k, v in pairs(last.step) do step[k] = v end
            step.to, step.crafts = s.to, step.crafts + s.crafts
            last.step = step
            last.steps[#last.steps + 1] = s
            last.rows = needs(ladder, last.steps, gold and crafts or 1)
        elseif s.buy then
            entries[#entries + 1] = { step = s, steps = { s }, key = stepKey(s),
                                      rows = needs(ladder, { s }, gold and crafts or 1) }
        end
    end
    -- at first the step the window shows is open, or the first with something to buy
    if not opened then
        local wProf, wStep = ns.Window.Selected()
        local wKey = wProf == data and wStep and wStep.buy and stepKey(wStep)
        local first
        for _, e in ipairs(entries) do
            local selected = false
            for _, s in ipairs(e.steps) do selected = selected or stepKey(s) == wKey end
            if #e.rows > 0 and (not first or selected) then first = e.key end
        end
        opened = first and { [first] = true } or {}
    end
    panel.heading:SetText(#entries == 0 and ("%s: nothing to buy"):format(data.name)
        or ladder.favor and ("%s: Merchant's Favor recipes, what one craft of each buys"):format(data.name)
        or gold and ("%s: what earns the most now, the ingredients of %d %s"):format(data.name, crafts,
            crafts == 1 and "craft" or "crafts")
        or ("%s: what each step buys at the auction house"):format(data.name))
    local _, lookup = ns.Prices.ForGame()
    local y = 0
    for _, e in ipairs(entries) do
        local r = stepPool:Get(panel.scroll.child)
        r:SetPoint("TOPLEFT", 0, -y)
        r:SetPoint("RIGHT", panel.scroll.child, "RIGHT", -8, 0)
        fillStep(r, e, data, lookup, gold)
        y = y + ROW_H
        for _, row in ipairs(e.rows) do gameName(row.item) end -- loaded by the time you click
        if opened[e.key] then
            for _, row in ipairs(e.rows) do
                local rr = rowPool:Get(panel.scroll.child)
                rr:SetPoint("TOPLEFT", INDENT, -y)
                rr:SetPoint("RIGHT", panel.scroll.child, "RIGHT", -8, 0)
                fillRow(rr, row, lookup)
                y = y + ROW_H
            end
        end
    end
    panel.scroll:SetContentHeight(math.max(y, 1))
end

local function build_panel(parent)
    panel = CreateFrame("Frame", nil, parent)
    panel:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -60)
    panel:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, 28)
    UI.Panel(panel, C.bg, C.edge, 8)
    profButtons = {}
    for i = 1, 6 do
        local b = UI.Button(panel, "", 90, 22, function(self)
            ns.Player.Saved().ahProf = self.data.key
            AuctionTab.Refresh()
        end)
        b:SetPoint("TOPLEFT", i == 1 and panel or profButtons[i - 1], i == 1 and "TOPLEFT" or "TOPRIGHT", i == 1 and 12 or 6,
            i == 1 and -10 or 0)
        profButtons[i] = b
    end
    -- the mode, the window's own: switched here, it's switched there (Favor: its "Merchant's Favor recipes" bar)
    panel.modes = {}
    for i, m in ipairs(MODES) do
        local b = UI.Button(panel, m[2], m[3], 18, function(self)
            local p = ns.Player.Prof(picked(professions()))
            if self.mode == "favor" then
                p.favorView = true
            else
                p.mode, p.favorView = self.mode, nil
            end
            ns.Window.Refresh(true) -- calculated there first when the window shows it: drawn here from its cache
            AuctionTab.Refresh(true)
        end)
        b.mode, b.name = m[1], m[2]
        b:SetPoint("TOPLEFT", i == 1 and panel or panel.modes[i - 1], i == 1 and "TOPLEFT" or "TOPRIGHT",
            i == 1 and 14 or 4, i == 1 and -40 or 0)
        panel.modes[i] = b
    end
    panel.crafts = numberBox(panel)
    panel.crafts:SetPoint("TOPRIGHT", -14, -10)
    local function setCrafts(self)
        local n = math.max(1, math.floor(tonumber(self:GetText()) or 1))
        if n ~= crafts then
            crafts = n
            AuctionTab.Refresh(true)
        end
        self:SetText(tostring(crafts))
    end
    panel.crafts:SetScript("OnEditFocusLost", setCrafts) -- Enter clears the focus
    panel.craftsLabel = UI.Label(panel, 12, C.muted)
    panel.craftsLabel:SetPoint("RIGHT", panel.crafts, "LEFT", -8, 0)
    panel.craftsLabel:SetText("Crafts")
    panel.heading = UI.Label(panel, 13, C.gold)
    panel.status = UI.Label(panel, 11, C.muted)
    panel.status:SetPoint("BOTTOMLEFT", 14, 10)
    panel.scroll = UI.Scroll(panel)
    panel.scroll:SetPoint("TOPLEFT", 10, -66)
    panel.scroll:SetPoint("BOTTOMRIGHT", -10, 30)
    rowPool = UI.Pool(makeRow)
    stepPool = UI.Pool(makeStep)
    AuctionTab.panel = panel
    panel:SetScript("OnShow", function()
        status(auctionator() and "A click on a step or a reagent searches it in Auctionator's Shopping tab." or nil)
        AuctionTab.Refresh()
    end)
    panel:Hide()
end

-- The tab: through LibAHTab (Auctionator's) when it's there, so add-ons' tabs don't overlap; else one of our own
-- beside Blizzard's (Buy, Sell, Auctions).
local function attach()
    local ah = AuctionHouseFrame
    if panel or not ah then return end
    build_panel(ah)
    local lib = LibStub and LibStub:GetLibrary("LibAHTab-1-0", true)
    if lib then
        lib:CreateTab("CraftLadder", panel, "Craft Ladder", "Craft Ladder")
    elseif ah.SetDisplayMode and ah.Tabs and #ah.Tabs > 0 then
        -- the template joins the parent's Tabs: give it a host of its own, anchored after Blizzard's last tab
        local host = CreateFrame("Frame", nil, ah)
        host:SetSize(1, 1)
        host:SetPoint("CENTER", ah.Tabs[#ah.Tabs], "RIGHT", 6, 0)
        local tab = CreateFrame("Button", "CraftLadderAHTab", host, "AuctionHouseFrameDisplayModeTabTemplate")
        tab:SetText("Craft Ladder")
        if PanelTemplates_TabResize then PanelTemplates_TabResize(tab, 20, nil, 70) end
        tab:SetPoint("LEFT", host, "CENTER", 0, 0)
        if PanelTemplates_DeselectTab then PanelTemplates_DeselectTab(tab) end
        hooksecurefunc(ah, "SetDisplayMode", function()
            panel:Hide()
            if PanelTemplates_DeselectTab then PanelTemplates_DeselectTab(tab) end
        end)
        tab:SetScript("OnClick", function()
            ah:SetDisplayMode({})
            ah.displayMode = nil
            for _, native in ipairs(ah.Tabs) do if PanelTemplates_DeselectTab then PanelTemplates_DeselectTab(native) end end
            if PanelTemplates_SelectTab then PanelTemplates_SelectTab(tab) end
            panel:Show()
        end)
        panel.tab = tab
    end
end

local events = CreateFrame("Frame")
for _, e in ipairs({ "AUCTION_HOUSE_SHOW", "COMMODITY_PRICE_UPDATED", "COMMODITY_PRICE_UNAVAILABLE",
                     "COMMODITY_PURCHASE_SUCCEEDED", "COMMODITY_PURCHASE_FAILED", "AUCTION_HOUSE_CLOSED",
                     "BAG_UPDATE_DELAYED" }) do
    pcall(events.RegisterEvent, events, e)
end
events:SetScript("OnEvent", function(_, event, a, b)
    if event == "AUCTION_HOUSE_SHOW" then
        attach()
    elseif event == "COMMODITY_PRICE_UPDATED" and pending then -- unit price, total
        pending.total = b
        status(("%d %s for %s (%s each): click Confirm to buy."):format(pending.qty, ns.Describe.ItemName(pending.item),
            ns.Money(b), ns.Money(a)))
        paintAll()
    elseif event == "COMMODITY_PRICE_UNAVAILABLE" and pending then
        status(("No price for %s: not enough listed, or not sold that way (try the Buy tab)."):format(
            ns.Describe.ItemName(pending.item)), C.bad)
        pending = nil
        paintAll()
    elseif event == "COMMODITY_PURCHASE_SUCCEEDED" and pending then
        status(("Bought %d %s."):format(pending.qty, ns.Describe.ItemName(pending.item)), C.good)
        pending = nil
        paintAll()
    elseif event == "COMMODITY_PURCHASE_FAILED" and pending then
        status("The purchase failed (the price may have changed): ask again.", C.bad)
        pending = nil
        paintAll()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        pending = nil
    elseif event == "BAG_UPDATE_DELAYED" and not pending and panel and panel:IsShown() then
        AuctionTab.Refresh() -- what you bought is now in your bags
    end
end)
