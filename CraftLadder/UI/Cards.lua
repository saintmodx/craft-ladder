-- Craft Ladder: the main window's step details (right), a card for every kind of step: a recipe (how to learn it,
-- what to buy, the other recipes you could use there), a rank, a fishing or mining zone, Lockpicking's locks, a
-- Merchant's Favor recipe, Gold's sale; and the Craft bar. UI/Window.lua draws the rest and calls Cards.Render with
-- what it shows.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local L = ns.L
local Window = ns.Window

local Cards = {}
ns.Cards = Cards

-- shared with the window (UI/Window.lua)
local S = Window.Shared
local W, DETAIL_CW, STEP_COLOR, BAG_ICON, RANK_ICON = S.W, S.DETAIL_CW, S.STEP_COLOR, S.BAG_ICON, S.RANK_ICON
local craftsWord, wait, recipeIcon, toolUsers, gather = S.craftsWord, S.wait, S.recipeIcon, S.toolUsers, S.gather
local duration, barsText, useLevel, signed = S.duration, S.barsText, S.useLevel, S.signed
local hex = UI.Hex
local CW = DETAIL_CW -- ... and now: the details take what a bigger window adds
local STANDING = { [0] = "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }

-- what the window shows, as Cards.Render was given it
local frame, ladder, lookup, prof, selected

-- "Cooks" / "Makes"
local function Verbs() return (prof.verb:gsub("^%l", string.upper)) .. "s" end

-- What a vendor really asked for an item, if you've been there.
local function realPrice(item)
    local real = ns.Prices.Real()
    return item and real and real[item]
end

-- Picking a recipe for a step: the choice saved for its stretch of skill.
local function choose(step, option)
    local saved = ns.Player.Prof(prof)
    local to = math.max(step.to, option.to)
    local keep = {}
    for _, c in ipairs(saved.choices or {}) do
        if c.to <= step.from or c.from >= to then keep[#keep + 1] = c end
    end
    if option ~= step.options[1] then
        -- a fishing or mining step joins stretches with the same zone; its options are its first stretch's, a zone
        -- picked there is for all of it
        local pickTo = option.zone and to or option.to
        keep[#keep + 1] = { from = step.from, to = pickTo, recipe = option.recipe, bags = option.fromBags or nil }
    end
    saved.choices = keep
    Window.Refresh()
end

-- The kinds of node in a zone that give a point at `skill`, most first: "Tin Vein, Silver Vein".
local function nodeKinds(zone, skill)
    local list = {}
    for id, n in pairs(zone.nodes) do
        local node = prof.nodes[id]
        if skill >= node.skill and ns.Ladder.Chance(node.colors, skill) > 0 then list[#list + 1] = { name = node.name, n = n } end
    end
    table.sort(list, function(a, b) return a.n > b.n end)
    for i, x in ipairs(list) do list[i] = x.name end
    return table.concat(list, ", ", 1, math.min(3, #list))
end

local pools = {}

local function makeSection(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(DETAIL_CW, 26)
    f.label = UI.Label(f, 12, C.gold)
    f.label:SetPoint("BOTTOMLEFT", 0, 6)
    f.line = f:CreateTexture(nil, "ARTWORK")
    f.line:SetPoint("BOTTOMLEFT", 0, 1)
    f.line:SetPoint("BOTTOMRIGHT", 0, 1)
    f.line:SetHeight(1)
    f.line:SetColorTexture(C.edge[1], C.edge[2], C.edge[3], 1)
    function f:Fit(cw) self:SetWidth(cw) end
    return f
end

local function makeLine(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(DETAIL_CW, 16)
    f.text = UI.Label(f, 12, C.text)
    f.text:SetPoint("TOPLEFT")
    f.text:SetWidth(DETAIL_CW)
    f.text:SetWordWrap(true)
    function f:Fit(cw) self:SetWidth(cw); self.text:SetWidth(cw) end
    return f
end

-- The last line of a long list: unfolds the rest, folds it again
local expanded = {} -- [a list's key] = showing all of it (until /reload)

local function makeMore(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(DETAIL_CW, 18)
    b.fold = b:CreateTexture(nil, "ARTWORK")
    b.fold:SetSize(12, 12)
    b.fold:SetPoint("LEFT", 2, 0)
    b.text = UI.Label(b, 11, C.muted)
    b.text:SetPoint("LEFT", b.fold, "RIGHT", 6, 0)
    b:SetScript("OnEnter", function(self) UI.SetColor(self.text, C.gold) end)
    b:SetScript("OnLeave", function(self) UI.SetColor(self.text, C.muted) end)
    b:SetScript("OnClick", function(self)
        expanded[self.key] = not expanded[self.key] or nil
        Window.Refresh(true)
    end)
    function b:Fit(cw) self:SetWidth(cw) end
    return b
end

local function makePlace(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(DETAIL_CW, 22)
    b.pin = b:CreateTexture(nil, "ARTWORK")
    b.pin:SetSize(14, 14)
    b.pin:SetPoint("LEFT", 2, 0)
    b.pin:SetTexture(UI.MEDIA .. "pin")
    b.pin:SetVertexColor(C.muted[1], C.muted[2], C.muted[3])
    b.text = UI.Label(b, 11, C.text)
    b.text:SetPoint("LEFT", b.pin, "RIGHT", 6, 0)
    b.text:SetWidth(DETAIL_CW - 110)
    b.right = UI.Label(b, 11, C.text, nil, "RIGHT")
    b.right:SetPoint("RIGHT", -4, 0)
    b:SetScript("OnEnter", function(self)
        self.pin:SetVertexColor(C.gold[1], C.gold[2], C.gold[3])
        UI.Tooltip(self, { self.npcName or "", L["Click: put a map pin and the arrow on it."] })
    end)
    b:SetScript("OnLeave", function(self)
        self.pin:SetVertexColor(C.muted[1], C.muted[2], C.muted[3])
        UI.HideTooltip()
    end)
    b:SetScript("OnClick", function(self)
        if self.spot then ns.PinAt(unpack(self.spot)) else ns.Waypoint(self.npc) end
    end)
    function b:Fit(cw) self:SetWidth(cw); self.text:SetWidth(cw - 110) end
    return b
end

local function makeItem(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(DETAIL_CW, 36)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(26, 26)
    b.icon:SetPoint("LEFT", 0, 0)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    b.name = UI.Label(b, 12, C.text)
    b.name:SetPoint("TOPLEFT", b.icon, "TOPRIGHT", 8, 0)
    b.name:SetWidth(DETAIL_CW - 34 - 90)
    b.sub = UI.Label(b, 11, C.muted)
    b.sub:SetPoint("BOTTOMLEFT", b.icon, "BOTTOMRIGHT", 8, 0)
    b.sub:SetWidth(DETAIL_CW - 34 - 90)
    b.cost = UI.Label(b, 11, C.text, nil, "RIGHT")
    b.cost:SetPoint("RIGHT", -4, 0)
    b:SetScript("OnEnter", function(self) UI.ItemTooltip(self, self.item, nil, { self.source }) end)
    b:SetScript("OnLeave", UI.HideTooltip)
    b:SetScript("OnClick", function(self)
        if IsShiftKeyDown() then UI.LinkItem(self.item) end
    end)
    function b:Fit(cw) self:SetWidth(cw); self.name:SetWidth(cw - 34 - 90); self.sub:SetWidth(cw - 34 - 90) end
    return b
end

local function makeOption(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(DETAIL_CW, 38)
    UI.Panel(b, C.panel2, C.panel2, 6, -4)
    b.dot = b:CreateTexture(nil, "ARTWORK")
    b.dot:SetSize(8, 8)
    b.dot:SetPoint("LEFT", 10, 0)
    b.dot:SetTexture(UI.MEDIA .. "round")
    b.name = UI.Label(b, 12)
    b.name:SetPoint("TOPLEFT", 26, -6)
    b.name:SetWidth(DETAIL_CW - 26 - 110)
    b.sub = UI.Label(b, 11, C.muted)
    b.sub:SetPoint("BOTTOMLEFT", 26, 6)
    b.sub:SetWidth(DETAIL_CW - 26 - 110)
    b.right = UI.Label(b, 11, C.text, nil, "RIGHT")
    b.right:SetPoint("TOPRIGHT", -10, -6)
    b.right2 = UI.Label(b, 11, C.muted, nil, "RIGHT")
    b.right2:SetPoint("BOTTOMRIGHT", -10, 6)
    b.tick = b:CreateTexture(nil, "OVERLAY")
    b.tick:SetSize(14, 14)
    b.tick:SetPoint("RIGHT", b.right, "LEFT", -6, 0)
    b.tick:SetTexture(UI.MEDIA .. "check")
    b.tick:SetVertexColor(C.gold[1], C.gold[2], C.gold[3])
    function b:Paint()
        if self.chosen then
            self:SetPanelColors(C.hover, C.selected)
        else
            self:SetPanelColors(self:IsMouseOver() and C.hover or C.panel2, self:IsMouseOver() and C.edge or C.panel2)
        end
    end
    b:SetScript("OnEnter", function(self)
        self:Paint()
        local o = self.option
        if o.kind == "mine" then
            local g = gather()
            local Many = g.many:gsub("^%l", string.upper)
            UI.Tooltip(self, {
                o.name,
                { (L["%s that give points"]):format(Many), nodeKinds(prof.zones[o.zone], o.from) },
                { (L["%s for this step"]):format(Many), "~" .. math.ceil(o.crafts) },
                next(prof.recipes) and { L["Smelt on the way"], barsText(o.bars) } or nil,
                { L["Trainer"], ns.Money(o.cost) },
                o.perHour and { (L["A %s is worth"]):format(g.one), ns.Money(o.value) } or nil,
                o.perHour and { L["Gold an hour"], ns.Money(o.perHour) } or nil,
                not self.chosen and (L["Click to %s here for this step."]):format(g.verb:lower()) or nil,
            })
            return
        end
        if o.zone then
            UI.Tooltip(self, {
                o.name,
                { L["Fish that land"], o.landed >= 1 and L["all of them"] or ("%d%%"):format(o.landed * 100) },
                { L["Lure"], o.lure and ("%s (+%d)"):format(ns.Describe.ItemName(o.lure), o.lureBonus) or L["none needed"] },
                { L["A catch is worth"], ns.Money(o.value) },
                { L["Lures for this step"], ns.Money(o.cost) },
                not self.chosen and L["Click to fish here for this step."] or nil,
            })
            return
        end
        local lines = {}
        if o.fromBags then lines[#lines + 1] = (L["%s the %d you can make from what you have."]):format(Verbs(), o.have) end
        lines[#lines + 1] = { L["Skill"], ("%d - %d (%s)"):format(o.from, o.to, L[o.color]) }
        lines[#lines + 1] = { L["Crafts"], "~" .. math.ceil(o.crafts) }
        lines[#lines + 1] = { L["Ingredients"], o.missing and (hex(C.bad) .. L["no price"] .. "|r")
        or ns.Money(o.matCost) }
        lines[#lines + 1] = { L["Learn"], ns.Describe.Learn(o.learn, prof) }
        if o.learn.cost and o.learn.cost > 0 then
            lines[#lines + 1] = { L["Recipe"], ns.Describe.Price(o.learn.cost, o.learn.guess) }
        end
        if o.back and o.back > 0 then lines[#lines + 1] = { L["Selling them brings back"], ns.Money(o.back) } end
        if o.cost then lines[#lines + 1] = { L["Per skill point"], ns.Money(o.perPoint) } end
        if not self.chosen then lines[#lines + 1] = L["Click to use this recipe for this step."] end
        UI.ItemTooltip(self, prof.recipes[o.recipe].makes, o.recipe, lines)
    end)
    b:SetScript("OnLeave", function(self) self:Paint(); UI.HideTooltip() end)
    b:SetScript("OnClick", function(self)
        if IsShiftKeyDown() then
            if not self.option.zone then UI.LinkItem(prof.recipes[self.option.recipe].makes) end
        elseif not self.chosen then
            choose(self.step, self.option)
        end
    end)
    function b:Fit(cw) self:SetWidth(cw); self.name:SetWidth(cw - 26 - 110); self.sub:SetWidth(cw - 26 - 110) end
    return b
end

local y -- layout cursor while drawing the details

-- A widget for the details, as wide as they are now.
local function get(kind)
    local f = pools[kind]:Get(frame.detail.scroll.child)
    f:Fit(CW)
    return f
end

local function place(f, gap)
    f:SetPoint("TOPLEFT", 0, -y)
    y = y + f:GetHeight() + (gap or 0)
end

local function section(text)
    y = y + 8
    local f = get("section")
    f.label:SetText(text)
    place(f, 6)
end

local function line(text, color)
    local f = get("line")
    f.text:SetText(text)
    UI.SetColor(f.text, color or C.text)
    f:SetHeight(math.max(14, f.text:GetStringHeight()) + 4)
    place(f, 2)
end

local function placeRow(npc, right)
    local f = get("place")
    local name, where = ns.Describe.NPC(npc)
    f.npc, f.npcName, f.spot = npc, name, false -- false, not nil: a test frame reads a nil field as a method
    f.text:SetText(name .. (where and (hex(C.muted) .. "  " .. where .. "|r") or ""))
    f.right:SetText(right or "")
    place(f, 2)
end

-- A list too long for a card: only its first `cap` rows, drawn by `row`, with a line that unfolds the rest. `key`
-- tells one list from another, `what` is what they are ("vendors"). Folded again by /reload.
local function foldedRows(key, list, cap, what, row)
    local open = expanded[key]
    for i, x in ipairs(list) do
        if i > cap and not open then break end
        row(x)
    end
    if #list <= cap then return end
    local f = get("more")
    f.key = key
    f.fold:SetTexture(open and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up")
    f.text:SetText(open and (L["all %d %s"]):format(#list, L[what])
        or (L["and %d more %s"]):format(#list - cap, L[what]))
    UI.SetColor(f.text, C.muted)
    place(f, 2)
end

-- "11 Copper Ore (buy 6), 11 Tin Ore (buy 6)": what an ingredient that's made is made of, all the way down, and how
-- much of it to buy (a part made in some stretches and bought in others: the bought ones too).
local function madeFrom(make)
    local leaves = {}
    local function walk(parts)
        for item, b in pairs(parts) do
            local bought = b.make and b.buy - b.make.made
            if b.make then walk(b.make.parts) end
            if not b.make or bought > 1e-9 then
                local l = leaves[item] or { need = 0, buy = 0 }
                l.need, l.buy = l.need + (bought or b.need), l.buy + (bought or b.buy)
                leaves[item] = l
            end
        end
    end
    walk(make.parts)
    local list = {}
    for item, l in pairs(leaves) do
        local need, buy = math.ceil(l.need - 1e-9), math.ceil(l.buy - 1e-9)
        list[#list + 1] = ("%d %s%s"):format(need, ns.Describe.ItemName(item),
            buy <= 0 and L[" (you have them)"] or buy < need and (" (buy " .. buy .. ")") or "")
    end
    table.sort(list)
    return table.concat(list, ", ")
end

-- An item's name in its quality's colour, as the game's tooltips show it; plain while the game doesn't know the item
-- yet, and for common ones (white).
local function qualityName(item)
    local q = C_Item and C_Item.GetItemQualityByID and C_Item.GetItemQualityByID(item)
    local c = q and q ~= 1 and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q]
    local name = ns.Describe.ItemName(item)
    return c and (hex({ c.r, c.g, c.b }) .. name .. "|r") or name
end

local function itemRow(item, b)
    local f = get("item")
    local e = lookup(item)
    f.item = item
    f.icon:SetTexture(UI.ItemIcon(item))
    local inBank = ladder.state.inBank and ladder.state.inBank[item]
    local have = ""
    if b.have > 0 then
        have = (L["  (you have %d%s)"]):format(math.floor(b.have),
            inBank and (inBank >= b.have and L[", in the bank"] or (L[", %d in the bank"]):format(inBank)) or "")
    end
    f.name:SetText(("%d %s%s"):format(math.ceil(b.need), qualityName(item),
        hex(C.muted) .. have .. "|r"))
    local source = ns.Describe.PriceSource(e)
    if b.make and b.buy > 0 then
        local what = b.make.mining and L["smelt"] or prof.verb
        local bought = b.buy - b.make.made
        source = (L["%s %d yourself from %s%s"]):format(what, math.ceil(b.make.made), madeFrom(b.make),
            bought > 1e-9 and (L[", buy the other %d"]):format(math.ceil(bought - 1e-9)) or "")
        f.sub:SetText(source:gsub("^%l", string.upper))
        UI.SetColor(f.sub, C.good)
        f.cost:SetText(ns.Money(b.cost))
    elseif b.buy <= 0 then
        f.sub:SetText(L["you have enough"])
        UI.SetColor(f.sub, C.good)
        f.cost:SetText(ns.Money(0))
    elseif not b.cost then
        f.sub:SetText(source)
        UI.SetColor(f.sub, C.bad)
        f.cost:SetText(hex(C.bad) .. "?|r")
    else
        if b.short then
            f.sub:SetText((L["only %d listed - you need %d"]):format(e.qty, math.ceil(b.buy)))
            UI.SetColor(f.sub, C.bad)
        else
            f.sub:SetText(source)
            UI.SetColor(f.sub, C.muted)
        end
        f.cost:SetText(ns.Money(b.cost))
    end
    f.source = source
    place(f, 2)
end

local VALUE_HOW = { auction = "at the auction house, after its cut", vendor = "at a vendor",
                    contents = "what's inside, on average" }

-- A fish (or chest) a zone gives: its share of the catches, what it's worth (the ladder priced it: auction house,
-- vendor or what's inside), and whether your Cooking can use it.
local function fishRow(item, share, cooking)
    local f = get("item")
    local v = ladder.values and ladder.values[item]
    f.item = item
    f.icon:SetTexture(UI.ItemIcon(item))
    f.name:SetText(qualityName(item) .. (cooking and (hex(C.good) .. L["  your Cooking uses it"] .. "|r") or ""))
    f.sub:SetText((L["%d%% of catches%s"]):format(math.max(1, math.floor(share * 100 + 0.5)),
        v and v.how and (", " .. L[VALUE_HOW[v.how]]) or ""))
    UI.SetColor(f.sub, C.muted)
    f.cost:SetText(v and v.value > 0 and (ns.Money(v.value) .. hex(C.muted) .. L[" each"] .. "|r") or (hex(C.dim) .. L["no price"] .. "|r"))
    f.source = ns.Describe.PriceSource(lookup(item, true))
    place(f, 2)
end

local function optionRow(step, o)
    local f = get("option")
    f.step, f.option = step, o
    f.chosen = o.recipe == step.recipe and (o.fromBags or false) == (step.fromBags or false)
    f.tick:SetShown(f.chosen)
    if o.kind == "mine" then
        f.dot:SetVertexColor(C.alliance[1], C.alliance[2], C.alliance[3])
        f.name:SetText(o.name .. (o.dangerous and (hex(C.bad) .. (L["  creatures level %d+|r"]):format(
            o.mobLevel or prof.zones[o.zone].levels[1])) or ""))
        UI.SetColor(f.name, C.text)
        f.sub:SetText(nodeKinds(prof.zones[o.zone], o.from))
        local g = gather()
        if ladder.mode ~= "skill" then
            f.right:SetText(ns.Money(o.perHour) .. hex(C.muted) .. L[" / hour"] .. "|r")
            f.right2:SetText((L["~%d %s, %s a %s"]):format(math.ceil(o.crafts), g.many, ns.Money(o.value), g.one))
        else
            f.right:SetText(("~%d %s"):format(math.ceil(o.crafts), g.many))
            f.right2:SetText(o.cost > 0 and (L["%s at the trainer"]):format(ns.Money(o.cost)) or "")
        end
        f:Paint()
        place(f, 4)
        return
    end
    if o.zone then
        local c = o.landed >= 1 and C.text or C.warn
        f.dot:SetVertexColor(C.alliance[1], C.alliance[2], C.alliance[3])
        f.name:SetText(o.name .. (o.dangerous and (hex(C.bad) .. (L["  creatures level %d+|r"]):format(
            prof.zones[o.zone].levels[1])) or ""))
        UI.SetColor(f.name, c)
        f.sub:SetText((o.landed >= 1 and L["no fish get away"] or (L["%d%% of casts land a fish"]):format(o.landed * 100)) ..
            (o.lure and (L[", with %s"]):format(ns.Describe.ItemName(o.lure)) or ""))
        if ladder.mode ~= "skill" then
            f.right:SetText(ns.Money(o.perHour) .. hex(C.muted) .. L[" / hour"] .. "|r")
            f.right2:SetText((L["%s a catch%s"]):format(ns.Money(o.value),
                o.cost > 0 and (L[", lures %s"]):format(ns.Money(o.cost)) or ""))
        else
            f.right:SetText(ns.Money(o.value) .. hex(C.muted) .. L[" / catch"] .. "|r")
            f.right2:SetText(o.cost > 0 and (L["%s for lures"]):format(ns.Money(o.cost)) or "")
        end
        f:Paint()
        place(f, 4)
        return
    end
    local c = STEP_COLOR[o.color] or C.text
    f.dot:SetVertexColor(c[1], c[2], c[3])
    f.name:SetText(o.name .. (o.fromBags and (hex(C.good) .. L["  with what you have"] .. "|r") or ""))
    UI.SetColor(f.name, c)
    -- a recipe you have: green, nothing to learn; else how to learn it
    local have = (o.learn.kind == "known" and not o.learn.earlier) or o.learn.kind == "start"
    f.sub:SetText(("%d - %d, ~%d %s, %s"):format(o.from, o.to, math.ceil(o.crafts), craftsWord(),
        prof.doors and (o.fromBags and L["from your bags"] or L["bought at the auction house"])
        or have and (hex(C.good) .. ns.Describe.Learn(o.learn, prof) .. "|r")
        or (L["learn: %s"]):format(ns.Describe.Learn(o.learn, prof))))
    -- as the ladder's rows: what a point earns (+, green) or costs (-, red)
    f.right:SetText(o.perPoint and (signed(-o.perPoint) .. hex(C.muted) .. L[" / point"] .. "|r")
        or (hex(C.bad) .. L["no price"] .. "|r"))
    f.right2:SetText(o.cost and (L["%s in all%s"]):format(ns.Money(o.cost),
        (o.back or 0) > 0 and (L[", %s back"]):format(ns.Money(o.back)) or "") or "")
    f:Paint()
    place(f, 4)
end

-- "orange to 89, yellow 90, green 110, grey 130"
local function colorsText(colors)
    local parts = {}
    local yellow, green, grey = colors[2], colors[3], colors[4]
    parts[#parts + 1] = hex(C.orange) .. L["orange"] .. "|r " .. (L["from %d"]):format(colors[1])
    if yellow > 0 then parts[#parts + 1] = hex(C.yellow) .. L["yellow"] .. "|r " .. yellow end
    if green > 0 then parts[#parts + 1] = hex(C.green) .. L["green"] .. "|r " .. green end
    parts[#parts + 1] = hex(C.grey) .. L["grey"] .. "|r " .. grey
    return table.concat(parts, ", ")
end

local function headline(icon, title, titleColor, line1, line2)
    local h = frame.detail.head
    h.icon:SetTexture(icon)
    h.icon:SetVertexColor(1, 1, 1)
    h.title:SetText(title)
    UI.SetColor(h.title, titleColor)
    h.line1:SetText(line1 or "")
    h.line2:SetText(line2 or "")
    h:Show()
    y = 58
end

-- A step whose recipe (or zone) you picked: say so, with a button back to Craft Ladder's choice.
local function pickedNote(step, text)
    if not step.chosenByYou then return end
    local back = frame.detail.back
    back:SetParent(frame.detail.scroll.child)
    back:ClearAllPoints()
    back:SetPoint("TOPRIGHT", 0, -y)
    back.step = step
    back:Show()
    line(hex(C.gold) .. L["Your pick."] .. "|r " .. text, C.text)
    y = y + 6
end

-- The Craft bar near the top of a crafting step's card (under what your bags make): how many, and a button that crafts
-- that many. The game crafts only from a click and with the profession window open; opening it in the same click is
-- enough (seen in game), but closing it at once stops after the first craft, so the window is left open.
local function professionOpen()
    local T = C_TradeSkillUI
    local shown = (ProfessionsFrame and ProfessionsFrame:IsShown()) or (TradeSkillFrame and TradeSkillFrame:IsShown())
    local info = shown and T and T.GetBaseProfessionInfo and T.GetBaseProfessionInfo()
    return info and info.professionID == prof.skillLine or false
end

-- How many crafts the bags allow now: the game's count once the window is open, else the ladder's.
local function canMake(step)
    local T = C_TradeSkillUI
    local info = professionOpen() and T and T.GetRecipeInfo and T.GetRecipeInfo(step.recipe)
    return info and info.numAvailable or step.canCook or 0
end

-- The character has the recipe (or every character starts with it), so the Craft button can make it.
local function learned(step)
    return step.learn.kind == "known" and not step.learn.earlier or step.learn.kind == "start"
end

local function paintCraft(bar)
    local step, rec = bar.step, bar.rec
    local can, why = canMake(step), nil
    if not rec.makes then
        why = L["An enchantment: enchant from the profession window, on the item."]
    elseif not learned(step) then
        why = L["Learn the recipe first."]
    elseif InCombatLockdown and InCombatLockdown() then
        why = L["Not in combat."]
    elseif can <= 0 then
        why = L["Not enough reagents in your bags."]
    end
    bar.button:SetEnabled(why == nil)
    bar.button.tooltip = { L["Craft"], L["Crafts as many as the box says; opens your profession window first if it's "
        .. "closed (the game crafts only with it open)."] .. (prof.key == "cooking"
        and L[" Cooking needs a fire nearby."] or "") }
    bar.note:SetText(why and (hex(C.warn) .. why .. "|r")
        or (L["Your bags allow %d"]):format(can) .. ((step.kind == "favor" or step.kind == "disenchant"
            or step.kind == "profit") and "."
            or (L["; the step needs %d."]):format(bar.need)))
end

local function craftClick(bar)
    local T = C_TradeSkillUI
    bar.count:ClearFocus()
    local n = math.floor(tonumber(bar.count:GetText()) or 0)
    if n <= 0 or not (T and T.CraftRecipe) then return end
    if professionOpen() then return T.CraftRecipe(bar.step.recipe, n) end
    -- the window opens later than this click, and the game crafts nothing before its recipes are there: crafted
    -- then (craftWhenOpen), once, if that's within 10 s
    bar.pending = { recipe = bar.step.recipe, n = n, line = prof.skillLine, at = GetTime() }
    if T.OpenTradeSkill then T.OpenTradeSkill(prof.skillLine) end
    bar.note:SetText((L["Opening your %s window: crafting once it's ready."]):format(prof.window or prof.name))
end

-- The profession window's events: the craft a click asked for while it was closed, once its recipes are there.
local function craftWhenOpen(bar)
    local p, T = bar.pending, C_TradeSkillUI
    if not p then return end
    if GetTime() - p.at > 10 then bar.pending = false; return end -- the window never came: forget it
    local info = T.GetBaseProfessionInfo and T.GetBaseProfessionInfo()
    if info and info.professionID == p.line and T.GetRecipeInfo and T.GetRecipeInfo(p.recipe) then
        bar.pending = false
        T.CraftRecipe(p.recipe, p.n)
    end
end

local function craftBar(step, rec)
    if prof.kind or ns.Player.viewing then return end -- gathering and Lockpicking: nothing to craft here; nor for
                                                      -- another character
    local bar = frame.detail.craft
    bar.step, bar.rec, bar.need = step, rec, math.ceil(step.crafts)
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", 0, -y)
    bar:Show()
    -- no more than the step needs; Profit's rows are one craft each: as many as the bags allow
    local n = step.kind == "profit" and canMake(step) or math.min(canMake(step), bar.need)
    bar.count:SetText(tostring(math.max(0, n)))
    paintCraft(bar)
    y = y + 32
end

-- How to learn the recipe of a step: the vendors that sell it, the quest, the trainer.
local function learnSection(step, rec)
    local state = ladder.state
    section(L["Learn it"])
    local way = step.learn
    if way.kind == "vendor" then
        local vendors = ns.Describe.Vendors(prof, step.recipe, state.faction, ns.db.favor)
        local real = realPrice(rec.item)
        line((L["Buy the recipe from %s:"]):format(#vendors > 1 and L["one of these vendors"] or L["this vendor"]), C.text)
        foldedRows("vendors:" .. step.recipe, vendors, 4, "vendors", function(v)
            placeRow(v.npc, v.favor and (L["%s Favor"]):format(v.favor == true and L["Merchant's"] or v.favor)
                or ns.Describe.Price(real or v.cost, not real and v.costGuess))
        end)
    elseif way.kind == "quest" then
        local name, q = ns.Describe.Quest(way.quest)
        line((L["Quest reward: %s%s"]):format(name, way.reqLevel and way.reqLevel > state.level and
            (" " .. hex(C.bad) .. (L["(needs level %d)"]):format(way.reqLevel) .. "|r") or ""), C.text)
        if q and q.giver then placeRow(q.giver, L["quest giver"]) end
    elseif way.kind == "trainer" and rec.trainers then
        line((L["Only these trainers teach it, for %s:"]):format(ns.Describe.Price(way.cost, way.guess)), C.text)
        local theirs = {}
        for _, npc in ipairs(rec.trainers) do
            local n = prof.npcs[npc]
            if n and n.faction:find(state.faction, 1, true) then theirs[#theirs + 1] = npc end
        end
        foldedRows("trainers:" .. step.recipe, theirs, 4, "trainers", function(npc) placeRow(npc, L["trainer"]) end)
        if #theirs == 0 then line(L["None of them is of your faction."], C.bad) end
    else
        line(ns.Describe.Learn(way, prof):gsub("^%l", string.upper) .. ".",
            way.kind == "known" and not way.earlier and C.good or C.text)
    end
    if way.alt then -- the other way to get it: the ladder counts the cheaper one, you may prefer the other
        line(way.alt.kind == "ah" and (L["Or buy it at the auction house: %s."]):format(ns.Money(way.alt.cost))
            or (L["Or %s."]):format(ns.Describe.Learn(way.alt, prof)), C.muted)
    end
    for _, g in ipairs(rec.get) do -- a holiday's way, never the ladder's: where to get one then
        if g.event and way.kind ~= "known" then
            line((L["During %s: %s."]):format(g.event, ns.Describe.Learn(g, prof)), C.muted)
        end
    end
    if way.guess then
        line((L["The price is an estimate: Craft Ladder learns the real one when you visit the %s."]):format(
            way.kind == "trainer" and L["trainer"] or L["vendor"]), C.muted)
    end
end

-- What `n` of what a recipe makes sell for: at the auction house (its lowest listing, after the cut) and at a vendor.
-- prefix: "Sells for ", "Each sells for ", "12 sell for ".
local function sellLines(rec, n, prefix)
    if not rec.makes then
        line(L["An enchantment: nothing to sell."], C.muted)
        return
    end
    local e = lookup(rec.makes, true)
    local ah = e and (e.min or e.unit)
    local vendor = ns.Prices.VendorSell(prof, rec.makes)
    line(ah and (L["%s%s at the auction house (after its cut%s)."]):format(prefix, ns.Money(n * ah * ns.Prices.AH_CUT),
        e.qty and (L[", %d listed"]):format(e.qty) or "") or L["Not on the auction house."], C.muted)
    line(vendor and vendor > 0 and (L["%s%s at a vendor."]):format(prefix, ns.Money(n * vendor))
        or L["Vendors don't buy it."], C.muted)
end

-- What one craft costs at today's prices with empty bags: every ingredient bought, or made when that's cheaper.
-- A ladder step uses what you own first, so its own numbers say nothing about what the craft is worth (an ingredient
-- all taken from the bags cost it nothing, and it never looked at making one). Gold prices every recipe this way
-- (Ladder.Profits empties its context's bags); the ladder's cards ask for the same.
local function marketBuy(rec)
    if not (ladder.quote and ladder.state) then return nil end
    local ctx = ns.Ladder.NewContext(prof, ladder.state, ladder.quote, ladder.opts or {})
    ctx.owned = {} -- priced as if bought
    local _, buy = ns.Ladder.Ingredients(ctx, rec, 1)
    return buy
end

-- The ingredients of a recipe you already have, after the One craft prices: where the plan's cheaper number comes
-- from. `text` takes them as its one %s.
local function ownedNote(rec, text)
    local items, have = {}, {}
    for item in pairs(rec.mats) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do
        local n = (ladder.state.owned or {})[item] or 0
        if n > 0 then have[#have + 1] = ("%d %s"):format(n, ns.Describe.ItemName(item)) end
    end
    if #have > 0 then line(text:format(table.concat(have, ", ")), C.muted) end
end

-- One craft, up top: each ingredient, how many it takes and what they cost (bought, or made when that's cheaper),
-- and what one sells for at the auction house and at a vendor. `buy` prices them instead of the step's own plan.
local function oneCraft(step, rec, buy)
    buy = buy or step.buy
    local items, total = {}, 0
    for item in pairs(rec.mats) do items[#items + 1] = item end
    table.sort(items)
    local rows = {}
    for _, item in ipairs(items) do
        local b, e = buy[item], lookup(item)
        local each = (b and b.buy > 0 and b.cost) and b.cost / b.buy or (e and e.unit)
        total = total and each and total + rec.mats[item] * each
        rows[#rows + 1] = { item = item, each = each, e = e, make = b and b.buy > 0 and b.make,
                            bought = b and b.make and b.buy - b.make.made > 1e-9 }
    end
    section((L["One craft%s: %s"]):format((rec.yield or 1) > 1 and (L[" (makes %d)"]):format(rec.yield) or "",
        total and ns.Money(total) or "?"))
    for _, r in ipairs(rows) do
        local f = get("item")
        local n = rec.mats[r.item]
        f.item = r.item
        f.icon:SetTexture(UI.ItemIcon(r.item))
        f.name:SetText(("%d %s"):format(n, qualityName(r.item)))
        local where = r.e and (r.e.source == "vendor" and L["vendor"] or L["auction house"])
        local from = r.make and (L["%s yourself%s"]):format(r.make.mining and L["smelt"] or prof.verb,
            r.bought and where and (L[" and %s"]):format(where) or "") or where
        f.sub:SetText(r.each and (L["%s each, %s"]):format(ns.Money(r.each), from or "") or L["no price"])
        UI.SetColor(f.sub, r.make and C.good or r.each and C.muted or C.bad)
        f.cost:SetText(r.each and ns.Money(n * r.each) or (hex(C.bad) .. "?|r"))
        f.source = ns.Describe.PriceSource(r.e)
        place(f, 2)
    end
    sellLines(rec, 1, (rec.yield or 1) > 1 and L["Each sells for "] or L["Sells for "])
end

-- A recipe the quartermasters sell for Merchant's Favor: its price, level and skill against yours, where to buy it,
-- what one craft takes as the ladder plans it (Favor.Ladder). What it makes is soulbound: nothing to sell.
local function favorDetail(step)
    local rec, state = prof.recipes[step.recipe], ladder.state
    local have = ns.Favor.Have()
    headline(recipeIcon(rec), ns.Describe.RecipeName(step.recipe, rec), step.status == "known" and C.good or step.status == "learn" and C.gold or C.bad,
        step.status == "known" and L["You know it."] or step.status == "learn" and L["You can learn it now."]
            or step.status == "skill" and (L["It needs %d %s (you: %d)."]):format(rec.learn, prof.name, state.skill)
            or (L["It needs level %d (you: %d)."]):format(step.level, state.level),
        colorsText(rec.colors))
    if step.status == "skill" or step.status == "level" then frame.detail.head.icon:SetVertexColor(1, 0.15, 0.15) end
    craftBar({ kind = "favor", recipe = step.recipe, crafts = 1, canCook = step.canMake or 0,
               learn = { kind = step.status == "known" and "known" or "favor" } }, rec)
    section(L["Merchant's Favor"])
    line(step.cost and (L["Costs %d Merchant's Favor%s."]):format(step.cost, have and (L[" (you have %d)"]):format(have) or "")
        or L["Its price: open a quartermaster once and Craft Ladder remembers it."], step.cost and C.text or C.muted)
    line(step.level and (L["From level %d (you: %d)."]):format(step.level, state.level)
        or L["Its level: open a quartermaster once and Craft Ladder remembers it."],
        step.level and (step.level > state.level and C.warn or C.text) or C.muted)
    line((L["From %d %s (you: %d)."]):format(rec.learn, prof.name, state.skill), rec.learn > state.skill and C.warn or C.text)
    local wear, worn = useLevel(rec.makes)
    if wear and wear > 1 then
        line((L["%s is %s from level %d (you: %d)."]):format(ns.Describe.ItemName(rec.makes), worn and L["worn"] or L["used"],
            wear, state.level), wear > state.level and C.warn or C.text)
    end
    local vendors = ns.Describe.Vendors(prof, step.recipe, state.faction, true)
    if #vendors > 0 then section(L["Quartermaster"]) end
    for _, v in ipairs(vendors) do placeRow(v.npc, L["Merchant's Favor"]) end
    section((L["One craft: %s"]):format(step.matCost and ns.Money(step.matCost) or "?"))
    local items = {}
    for item in pairs(step.buy) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
end

-- A recipe's notes: how it's learned isn't confirmed in Forever yet, reputation, specialization.
local function recipeNotes(rec, way)
    local why = ns.Describe.Unconfirmed(rec, way)
    if why then line(why, C.warn) end
    if rec.rep then
        line((L["The plan needs %s with %s."]):format(L[STANDING[rec.rep.standing]], prof.factions[rec.rep.faction]), C.muted)
    end
    if rec.spec then line((L["Only for %s."]):format(prof.specs[rec.spec]), C.muted) end
end

local function craftDetail(step)
    local rec = prof.recipes[step.recipe]
    local state = ladder.state
    headline(recipeIcon(rec), ns.Describe.RecipeName(step.recipe, rec), STEP_COLOR[step.color] or C.text,
        (L["Skill %d - %d, about %d crafts, %s%s"]):format(step.from, step.to, math.ceil(step.crafts),
            step.missing and (hex(C.bad) .. L["some prices missing"] .. "|r") or ns.Money(step.cost),
            step.back and (L[", %s back"]):format(ns.Money(step.back)) or ""),
        colorsText(rec.colors))
    if step.fromBags then -- first thing: the row's bag icon says only this
        line((L["%s %s what you already have: %d crafts%s."]):format(BAG_ICON, Verbs(), step.canCook > 0 and step.canCook
            or step.haveMain, step.matCost > 0 and L[", plus a few vendor ingredients"] or L[", nothing to buy"]), C.good)
    elseif step.canCook > 0 then
        line(learned(step) and (L["You can %s %d now with what you have."]):format(prof.verb, step.canCook)
            or (L["You have the reagents for %d."]):format(step.canCook), C.good)
    elseif (step.ready or 0) >= 1 then -- as the row's "ready": bars from your ore count too
        line((L["You have the main ingredients for %d; the rest is sold by vendors."]):format(
            math.floor(step.ready + 1e-9)), C.good)
    end
    craftBar(step, rec)
    learnSection(step, rec)
    recipeNotes(rec, step.learn)
    if step.options[1] then pickedNote(step, (L["The cheapest here is %s."]):format(step.options[1].name)) end -- a tool: none

    if step.late then
        local n, example, what = toolUsers(step.tool)
        line((L["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a" ..
            " cooldown, or learned at 300): make it once you're done."]):format(what, n, example), C.warn)
    elseif step.tool then
        local n = toolUsers(step.tool)
        line((L["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."]):format(
            n, prof.name, step.to > step.from and "" or L[" (it gives no skill point any more)"]), C.good)
    end
    oneCraft(step, rec, marketBuy(rec))
    ownedNote(rec, L["You have %s: the step takes them from your bags, so it pays less than that."])

    if step.keep then
        section(L["Keep for later"]) -- before buying: what not to sell
        local kept = {}
        for item in pairs(step.keep) do kept[#kept + 1] = item end
        table.sort(kept)
        for _, item in ipairs(kept) do
            local k = step.keep[item]
            line((L["Keep %d %s: the steps at %d - %d use them."]):format(math.floor(k.n + 0.5), ns.Describe.ItemName(item),
                k.from, k.to), C.good)
        end
    end

    -- the whole step: what to buy (or make) and what all it makes sell for
    section((L["Batch: %s"]):format(step.missing and "?" or ns.Money(step.matCost)))
    local items = {}
    for item in pairs(step.buy) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    local made = math.floor(step.crafts * (rec.yield or 1) + 0.5)
    sellLines(rec, made, (L["%d sell for "]):format(made))
    line(L["Craft counts are estimates: skill-ups are luck once a recipe is yellow."], C.muted)

    if step.sale then
        local sale = step.sale
        section(step.keep and L["Sell the rest"] or L["Sell what you make"])
        if sale.ah >= 0.5 then
            line((L["%d at the auction house, about %s each after its cut."]):format(math.floor(sale.ah + 0.5),
                ns.Money(sale.ahEach)), C.text)
        end
        if sale.vendor >= 0.5 then
            line((L["%d to a vendor, %s each."]):format(math.floor(sale.vendor + 0.5), ns.Money(sale.vendorEach)), C.text)
        end
        local net = step.cost - sale.total
        line((L["About %s back, so this step %s %s."]):format(ns.Money(sale.total), net < 0 and L["earns"] or L["costs"],
            ns.Money(math.abs(net))), net < 0 and C.good or C.text)
        line(ladder.mode == "skill" and L["Vendor sales counts only what vendors pay: that money is sure. AH sales counts" ..
            " the auction house too."] or L["The auction house counts only when it pays 1.5 times a vendor and 5 or more" ..
            " are listed, and for at most a quarter of what's listed."], C.muted)
    end

    if step.tool then return end
    section(prof.kind == "mining" and (L["Or %s, from %d"]):format(gather().verb:lower(), step.from)
        or (L["Recipes you could use from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
    if #step.options <= 1 then line(L["No other recipe is open to you here."], C.muted) end
end

-- Gold: one recipe, one craft: what to buy (or make), what selling it brings, what's left.
local function profitDetail(step)
    local rec = prof.recipes[step.recipe]
    local sale = step.sale
    headline(UI.ItemIcon(rec.makes), ns.Describe.RecipeName(step.recipe, rec), step.needSkill and C.bad
            or step.color ~= "grey" and STEP_COLOR[step.color] or C.text,
        (L["One craft%s costs about %s and sells for about %s: %s+%s|r"]):format(
            step.made > 1 and (L[" (makes %d)"]):format(step.made) or "", ns.Money(step.cost), ns.Money(sale.total),
            hex(C.good), ns.Money(step.profit)),
        step.vendor and L["Sold to a vendor: vendors buy any number."] or
            (L["%d listed at the auction house now: sell a few at a time."]):format(step.listed))
    if step.needSkill then
        line((L["Making it needs %s %d, and yours is %d%s. It's here to level towards."]):format(prof.name,
            step.needSkill, ladder.state.skill, step.needLevel and ((L["; the rank that lifts your cap to it asks" ..
                " level %d, and you're %d"]):format(step.needLevel, ladder.state.level)) or ""), C.bad)
    end
    line(colorsText(rec.colors), C.muted) -- where it turns yellow, green and grey
    craftBar(step, rec)
    learnSection(step, rec)
    if step.payback then line((L["Learning it pays back after %d %s."]):format(step.payback, step.payback == 1 and L["craft"] or L["crafts"]), C.good) end
    recipeNotes(rec, step.learn)
    if step.cooldown then
        line((L["Once in %s: the recipe has a cooldown."]):format(wait(step.cooldown)), C.warn)
    end

    oneCraft(step, rec)
    ownedNote(rec, L["You have %s: counted at their price too, since you could sell them."])
    line(step.vendor and L["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make," ..
        " the auction house's ingredients decide."] or L["Profit: at the lowest listing after the auction house's cut," ..
        " with 5 or more listed, or however few when you searched it yourself; it counts only when it pays 1.5 times" ..
        " what a vendor does. How many sell, the auction house doesn't say. Prices change: look again before buying."],
        C.muted)
end

-- What disenchanting gives (Disenchant mode, a bag's item or a recipe's): one disenchant's outcomes, what n bring, and
-- where the numbers come from.
local function disenchanting(step, n, yours)
    local bucket, s, SEEN = step.de, step.seen, ns.Disenchant.SEEN
    section((L["Disenchant one: about %s"]):format(ns.Money(step.each)))
    for _, g in ipairs(bucket.gives) do
        local f, worth = get("item"), ladder.worth(g.item)
        f.item = g.item
        f.icon:SetTexture(UI.ItemIcon(g.item))
        f.name:SetText(("%s %s"):format(g.min == g.max and g.min or (g.min .. "-" .. g.max), qualityName(g.item)))
        f.sub:SetText((L["%d%% of disenchants, %s each"]):format(math.floor(g.chance * 100 + 0.5), ns.Money(worth)))
        UI.SetColor(f.sub, C.muted)
        f.cost:SetText(ns.Money(g.chance * (g.min + g.max) / 2 * worth)) -- its part of the average
        f.source = ns.Describe.PriceSource(lookup(g.item, true))
        place(f, 2)
    end
    if n > 1 then -- (for one, the outcomes above say it)
        line((L["%s%d disenchanted: about %s, at least %s 9 times out of 10."]):format(yours and L["Your "] or "", n,
            ns.Money(n * step.each), ns.Money(ns.Disenchant.Sure(step.each, step.spread, n))), C.text)
    end
    if bucket.byItem then
        line((L["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
            " kind."]):format(bucket.seen), C.good)
    elseif bucket.seen then
        line((L["What it gives: from %d disenchants of items like it, recorded in game."]):format(bucket.seen), C.good)
    elseif s then -- yours so far, before they replace the table
        local got = {}
        for mat, m in pairs(s.mats) do got[#got + 1] = ("%d %s"):format(m.total, ns.Describe.ItemName(mat)) end
        table.sort(got)
        line((L["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."]):format(s.n,
            table.concat(got, ", "), SEEN), C.muted)
    end
    if bucket.guess then
        line(L["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its" ..
            " level, one more of each."], C.warn)
    end
    line((L["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make a" ..
        " greater one."]):format(bucket.seen and "" or (L[", from Classic's table (not checked in Forever yet): from %d" ..
        " of your disenchants of items like it, what you got replaces it"]):format(SEEN)), C.muted)
end

-- Disenchant: what another profession makes, made and disenchanted: what one disenchant gives, what a batch brings,
-- what one craft takes and what selling it instead brings. prof is the recipe's profession here (so the Craft bar
-- makes it); Cards.Render sets it back.
local function disenchantDetail(step)
    local rec, skill = prof.recipes[step.recipe], ladder.from -- the account's best Enchanting: an item can be mailed
    local result = (step.profit >= 0 and hex(C.good) .. "+" or hex(C.bad) .. "-") .. ns.Money(math.abs(step.profit))
        .. "|r"
    headline(UI.ItemIcon(rec.makes), ns.Describe.RecipeName(step.recipe, rec),
        step.needSkill and C.dim or step.color ~= "grey" and STEP_COLOR[step.color] or C.text,
        (L["One craft%s costs about %s; disenchanted, about %s on average: %s"]):format(
            step.made > 1 and (L[" (makes %d)"]):format(step.made) or "", ns.Money(step.cost), ns.Money(step.back), result),
        step.needSkill and (hex(C.bad) .. (L["Disenchanting it needs Enchanting %d; the best of yours is %d."]):format(
            step.needSkill, skill) .. "|r") or (L["A %s recipe %s knows."]):format(prof.name, step.who or L["you"]))
    if step.live then craftBar(step, rec) end -- only your own character can craft it from here
    disenchanting(step, ns.Disenchant.BATCH)
    if step.profit < 0 then
        line(L["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."],
            C.warn)
    end
    oneCraft(step, rec)
end

-- Disenchant: an item a character of yours holds: disenchant it or sell it, whichever brings more on average.
local function bagDetail(step)
    local e = lookup(step.item, true)
    local ah = e and (e.min or e.unit)
    local vendor = ns.DISENCHANT.sell[step.item] or ns.Prices.VendorSell(prof, step.item)
    headline(UI.ItemIcon(step.item), ns.Describe.ItemName(step.item), step.disenchant and C.good or C.text,
        (L["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."]):format(
            ns.Disenchant.Verdict(step), step.count, step.who or L["your"], step.where or L["bags"],
            ns.Money(step.each * step.count), ns.Money(step.sale.each * step.count)),
        step.needSkill and (hex(C.bad) .. (L["Disenchanting it needs Enchanting %d; the best of yours is %d."]):format(
            step.needSkill, ladder.from) .. "|r") or (step.bound and L["Soulbound: no auction house."] or ""))
    if step.alt and step.alt.name ~= step.who then
        line((L["%s has the most Enchanting of yours, %d: mail it there."]):format(step.alt.name, step.alt.skill), C.muted)
    end
    disenchanting(step, step.count, true)
    section(L["Or sell it"])
    line(step.bound and L["Soulbound: the auction house won't take it."] or ah and (L["%s each at the auction house" ..
        " (after its cut%s)."]):format(ns.Money(ah * ns.Prices.AH_CUT),
        e.qty and (L[", %d listed"]):format(e.qty) or "") or L["Not on the auction house."], C.muted)
    line(vendor and vendor > 0 and (L["%s each at a vendor."]):format(ns.Money(vendor))
        or L["Vendors don't buy it."], C.muted)
    line(L["The auction house counts with 5 or more listed, or however few when you searched it yourself." ..
        " What made it doesn't count: it's made."], C.muted)
end

-- Disenchant: an item the auction house lists for less than disenchanting it brings: what buying one gains on average
-- and how often, what it breaks into, the listing; with Auctionator, a button that searches it.
local function auctionDetail(step)
    headline(UI.ItemIcon(step.item), ns.Describe.ItemName(step.item), step.needSkill and C.dim or C.text,
        (L["Buy one for %s; disenchanted, about %s on average: %s"]):format(ns.Money(step.price), ns.Money(step.each),
            signed(step.gain)),
        step.needSkill and (hex(C.bad) .. (L["Disenchanting it needs Enchanting %d; the best of yours is %d:" ..
            " no character of yours can.|r"]):format(step.needSkill, ladder.from))
            or step.alt and (L["%s has the most Enchanting of yours, %d: mail it there."]):format(step.alt.name,
                step.alt.skill) or "")
    line((L["One disenchant brings more than it cost %d%% of the time."]):format(math.floor(step.chance * 100 + 0.5)),
        step.chance >= 0.5 and C.good or C.warn)
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    if api and api.MultiSearchAdvanced and not ns.Player.viewing then
        local b = frame.detail.search
        b.item = step.item
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", 0, -y)
        b:Show()
        y = y + 30
    end
    disenchanting(step, 1)
    section(L["Buy it"])
    line((L["The cheapest listing: %s. %s."]):format(ns.Money(step.price),
        (ns.Describe.PriceSource(lookup(step.item, true)):gsub("^%l", string.upper))), C.text)
    line((ns.DISENCHANT.classic[step.item] and L["Its level and quality are Classic's: Forever's client doesn't list it." ..
        " "] or "") .. L["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may" ..
        " have sold since the scan."], C.muted)
end

-- The card's Search button: Auctionator's Shopping tab with the item, once the game has its name (the auction house
-- must be open).
function Cards.Search(item)
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    local name = C_Item.GetItemNameByID and C_Item.GetItemNameByID(item)
    if not name and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(item) end
    if api and name then pcall(api.MultiSearchAdvanced, "CraftLadder", { { searchString = name, isExact = true } }) end
end

-- Food: one dish for your class: what eating it raises, the level it asks, its skill-up colours, its recipe, what one
-- costs to cook or buy.
local function foodDetail(step)
    local rec, state = prof.recipes[step.recipe], ladder.state
    headline(UI.ItemIcon(rec.makes), ns.Describe.RecipeName(step.recipe, rec), S.foodColor(step, rec, state.skill),
        ns.Describe.Buff(rec.buff) .. L[" (Well Fed). "] ..
            (step.later and (hex(C.bad) .. (L["Needs level %d; you're %d."]):format(step.eat, state.level) .. "|r")
                or step.eat > 1 and (L["Level %d: you can eat it."]):format(step.eat) or L["Any level can eat it."]),
        colorsText(rec.colors))
    if step.learn then
        learnSection(step, rec)
    else
        section(L["Learn it"])
        line(rec.item and L["Nobody sells its recipe now: look for it at the auction house."]
            or L["No way to learn it for you now (a holiday's, or the other side's)."], C.bad)
    end
    if step.needSkill then
        line((L["Learned at %s %d; you have %d."]):format(prof.name, step.needSkill, state.skill), C.bad)
    end
    oneCraft(step, rec, marketBuy(rec))
    ownedNote(rec, L["You have %s: cooking it takes them from your bags, so it costs you less than that."])
    section(L["Or buy it"])
    line(step.ah and (L["One at the auction house: %s."]):format(ns.Money(step.ah))
        or L["None listed at the auction house now."], C.text)
    line(L["What it raises is read from the game's files, not checked in game yet."], C.muted)
end

-- Lockpicking and Poisons: the class quests for your race (or side), with their givers' pins.
local function chainSection()
    local me = ns.Player.Snap()
    local race = me and me.race or UnitRace and select(2, UnitRace("player"))
    local chain = prof.chains[race] or prof.chains[ladder.state.faction]
    section(L[prof.chainTitle])
    for i, q in ipairs(chain) do
        local name, quest = ns.Describe.Quest(q)
        line(("%d. %s"):format(i, name), C.text)
        if quest and quest.giver then placeRow(quest.giver, L["quest giver"]) end
    end
    line(L[prof.chainNote], C.muted)
end

local function rankDetail(step)
    local rank = step.rank
    if rank.how == "level" then
        headline(prof.icon, (L["Reach level %d"]):format(rank.charLevel), step.needLevel and C.bad or C.gold,
            (L["At skill %d. Your cap is your level x 5: %d at level %d."]):format(step.from, rank.cap, rank.charLevel),
            step.needLevel and (hex(C.bad) .. (L["You're level %d."]):format(ladder.state.level) .. "|r")
                or L["Your level allows it already."])
        line(L["Lockpicking can't go past your level x 5: level up before you go on."], C.muted)
        return
    end
    headline(rank.item and UI.ItemIcon(rank.item) or RANK_ICON[rank.how] or prof.icon,
        (L["Learn %s%s"]):format(rank.name, prof.levelCaps and "" or (" " .. prof.name)), C.gold,
        (L["At skill %d, raises your cap to %d. %s"]):format(step.from, rank.cap, ns.Describe.Price(step.cost, step.guess)),
        step.needLevel and (hex(C.bad) .. (L["Needs character level %d."]):format(step.needLevel) .. "|r") or "")
    section(L["How"])
    if rank.how == "trainer" and rank.trainers then
        line((L["Only these trainers teach it%s:"]):format(
            rank.cost and (L[", for %s"]):format(ns.Money(rank.cost)) or ""), C.text)
        for _, npc in ipairs(rank.trainers) do
            local n = prof.npcs[npc]
            if n and n.faction:find(ladder.state.faction, 1, true) then placeRow(npc, L["trainer"]) end
        end
    elseif rank.how == "trainer" then
        line((L["Any %s trainer teaches it%s."]):format(prof.trainer or prof.name,
            rank.cost and (L[" for %s"]):format(ns.Money(rank.cost)) or ""), C.text)
        if rank.note then line(L[rank.note], C.muted) end
    elseif rank.how == "book" then
        local real = realPrice(rank.item)
        line((L["Buy the %s and read it:"]):format(ns.Describe.ItemName(rank.item)), C.text)
        for _, v in ipairs(rank.vendors or {}) do
            if v.faction:find(ladder.state.faction, 1, true) then
                placeRow(v.npc, ns.Describe.Price(real or v.cost, not real and v.costGuess))
            end
        end
        if step.ahCost then
            if not step.vendorCost then -- nobody on your side sells it: the auction house is the way
                line((L["At the auction house: %s."]):format(ns.Money(step.ahCost)), C.text)
            else
                line((L["Or buy it at the auction house: %s.%s"]):format(ns.Money(step.ahCost),
                    step.fromAH and L[" Cheaper than the vendor, so the ladder counts this one."] or ""), C.muted)
            end
        end
    elseif rank.how == "quest" then
        local name, q = ns.Describe.Quest(step.quest)
        if step.startQuest then
            local startName, start = ns.Describe.Quest(step.startQuest)
            line((L["1. Take the quest %s:"]):format(startName), C.text)
            if start and start.giver then placeRow(start.giver, L["start"]) end
            line((L["2. Bring the ingredients below to %s for %s:"]):format(
                q and q.giverName or L["the quest giver"], name), C.text)
            if q and q.giver then placeRow(q.giver, L["hand in"]) end
        else
            line((L["Do the quest %s for %s:"]):format(name, q and q.giverName or L["the quest giver"]), C.text)
            if q and q.giver then placeRow(q.giver, L["quest giver"]) end
        end
        if rank.note then line(L[rank.note], C.muted) end
    end
    if step.buy then
        section(L["What to bring"])
        local items = {}
        for item in pairs(step.buy) do items[#items + 1] = item end
        table.sort(items)
        for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    end
    if prof.chains then chainSection() end
    if rank.fish then
        section(L["Fish to catch"])
        for _, item in ipairs(rank.fish) do
            local where = prof.questFish[item]
            line((L["%s: %s, %s (fish bite from %d)"]):format(ns.Describe.ItemName(item), where.where,
                prof.zones[where.zone].name, math.max(1, where.base - 5)), C.text)
        end
    end
end

-- The fish of a zone your Cooking can still use: ingredients of Cooking recipes that aren't grey for you yet.
local function cookingFish()
    local cooking = ns.COOKING
    local skill = ns.Player.Skill(cooking)
    local out = {}
    for _, rec in pairs(cooking.recipes) do
        if ns.Ladder.Color(rec.colors, skill) ~= "grey" then
            for item in pairs(rec.mats) do out[item] = true end
        end
    end
    return out
end

-- A fishing pool: how many are known here and from where, what one catch from it gives and is worth.
local function poolRow(entry, p)
    local pool = prof.pools[entry]
    local f = get("item")
    local main, mainShare, worth = nil, 0, 0
    for item, share in pairs(pool.fish) do
        if share > mainShare then main, mainShare = item, share end
        local v = ladder.values[item]
        worth = worth + share * (v and v.value or 0)
    end
    f.item = main
    f.icon:SetTexture(UI.ItemIcon(main))
    f.name:SetText(("%s  %s%d %s|r"):format(pool.name, hex(C.muted), p.count,
        p.seen and L["seen by GatherMate2"] or (p.count == 1 and L["place known"] or L["places known"])))
    local parts = {}
    for item, share in pairs(pool.fish) do
        if share >= 0.1 then parts[#parts + 1] = ("%s %d%%"):format(ns.Describe.ItemName(item), share * 100 + 0.5) end
    end
    table.sort(parts)
    f.sub:SetText(table.concat(parts, ", "))
    UI.SetColor(f.sub, C.muted)
    f.cost:SetText(ns.Money(worth) .. hex(C.muted) .. L[" a catch"] .. "|r")
    f.source = (L["%d - %d catches before it's gone"]):format(pool.catches[1], pool.catches[2])
    place(f, 2)
end

local function fishDetail(step)
    local zone = prof.zones[step.zone]
    local landed = step.landed >= 1 and L["No fish get away here."] or
        (L["About %d%% of casts land a fish here."]):format(step.landed * 100)
    if step.hour then
        headline(UI.ItemIcon(zone.top), (L["Fish in %s"]):format(zone.name), step.landed >= 1 and C.text or C.warn,
            (L["An hour at skill %d: about %d catches, %s each"]):format(step.from, step.crafts, ns.Money(step.value)),
            landed .. (L[" An hour's catches are worth about %s%s."]):format(ns.Money(step.perHour),
                step.lure and L[", lures paid"] or ""))
    else
        headline(UI.ItemIcon(zone.top), (L["Fish in %s"]):format(zone.name), step.landed >= 1 and C.text or C.warn,
            (L["Skill %d - %d, about %d catches (%s), %s"]):format(step.from, step.to, math.ceil(step.crafts),
                duration(ns.Fishing.Minutes(step.casts)),
                step.missing and (hex(C.bad) .. L["some prices missing"] .. "|r") or ns.Money(step.cost)),
            landed .. (L[" Catches worth about %s (%s an hour)."]):format(ns.Money(step.earn), ns.Money(step.perHour)))
        pickedNote(step, (L["Craft Ladder's choice here is %s."]):format(step.options[1].name))
    end
    if step.dangerous then
        line((L["Its creatures are level %d - %d."]):format(zone.levels[1], zone.levels[2]), C.warn)
    end

    section(L["Bring"])
    local items = {}
    for item in pairs(step.buy) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    if step.lure then
        line((L["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."]):format(
            ns.Describe.ItemName(step.lure), prof.gear.lures[step.lure], prof.gear.lureMinutes), C.muted)
        line(L["Fishing supplies vendors sell lures, in every capital."], C.muted)
    else
        line(L["No lure needed: your skill keeps the fish from getting away."], C.good)
    end

    section(L["What you catch here"])
    local uses = cookingFish()
    local fish = {}
    for item, share in pairs(zone.fish) do fish[#fish + 1] = { item = item, share = share } end
    table.sort(fish, function(a, b) return a.share > b.share end)
    for i, f in ipairs(fish) do
        if i > 6 then break end
        fishRow(f.item, f.share, uses[f.item])
    end

    section(L["Fishing pools here"])
    local z = ladder.zones and ladder.zones[step.zone]
    if z and z.pools then
        local list = {}
        for entry, p in pairs(z.pools) do list[#list + 1] = { entry = entry, p = p } end
        table.sort(list, function(a, b) return a.p.count > b.p.count end)
        for _, x in ipairs(list) do poolRow(x.entry, x.p) end
        line((L["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes" ..
            " a catch worth %s on average (%s in open water)."]):format(ns.Money(step.value), ns.Money(z.open)), C.muted)
    else
        line(L["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."], C.muted)
    end
    local rate, log = ns.Fishing.Rate()
    if log and log.catches >= 50 then
        line((L["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."]):format(
            log.catches, rate * 100 + 0.5), C.muted)
    else
        line((L["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
            " counted 50 of your catches (%d so far)."]):format(log and log.catches or 0), C.muted)
    end
    line(L["Zones and their fish come from Classic's world: Forever may differ."], C.muted)
    if step.hour then return end

    section((L["Other zones from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
    if #step.options <= 1 then line(L["No other zone is open to you here."], C.muted) end
end

-- A kind of node in the zone you mine: about how many, its ore, what one is worth, and its colour for you at the
-- step's start.
local function nodeRow(id, n, step)
    local node = prof.nodes[id]
    local f = get("item")
    local ore = node.ore[node.item] or node.loot[node.item] or 0 -- its ore (a herb: itself)
    f.item = node.item
    f.icon:SetTexture(UI.ItemIcon(node.item))
    f.name:SetText(node.name)
    local worth, skill = step.worth[id], step.from
    f.sub:SetText((L["about %d in the zone, %s %s each%s"]):format(math.max(1, math.floor(n + 0.5)),
        ore % 1 == 0 and ore or ("%.1f"):format(ore), ns.Describe.ItemName(node.item),
        worth and (L[", worth %s"]):format(ns.Money(worth)) or ""))
    UI.SetColor(f.sub, C.muted)
    if skill < node.skill then
        f.cost:SetText(hex(C.bad) .. (L["needs %d"]):format(node.skill) .. "|r")
    else
        local color = ns.Ladder.Color(node.colors, skill)
        f.cost:SetText(hex(STEP_COLOR[color]) .. L[color] .. "|r")
    end
    f.source = colorsText(node.colors)
    place(f, 2)
end

-- A creature you skin in the zone: about how many, its level, the skill it needs, what one skin is worth, its colour.
local function creatureRow(id, n, step)
    local node = prof.nodes[id]
    local f = get("item")
    f.item = node.item
    f.icon:SetTexture(UI.ItemIcon(node.item))
    local high = node.level > (ladder.state.level or 1) + 2
    f.name:SetText((L["%s  %slevel %d%s|r"]):format(node.name, hex(high and C.bad or C.muted), node.level,
        node.recorded and L[", seen skinned"] or ""))
    local worth = step.worth[id]
    f.sub:SetText((L["about %d in the zone, needs %d%s"]):format(math.max(1, math.floor(n + 0.5)), node.skill,
        worth and (L[", %s a skin"]):format(ns.Money(worth)) or ""))
    UI.SetColor(f.sub, C.muted)
    if step.from < node.skill then
        f.cost:SetText(hex(C.bad) .. (L["needs %d"]):format(node.skill) .. "|r")
    else
        local color = ns.Ladder.Color(node.colors, step.from)
        f.cost:SetText(hex(STEP_COLOR[color]) .. L[color] .. "|r")
    end
    f.source = colorsText(node.colors)
    place(f, 2)
end

local function skinDetail(step)
    local zone = prof.zones[step.zone]
    if step.hour then
        headline(UI.ItemIcon(prof.nodes[step.node].item), (L["Skin in %s"]):format(zone.name),
            step.dangerous and C.warn or C.text,
            (L["An hour at skill %d: about %d creatures, %s each"]):format(step.from, step.crafts, ns.Money(step.value)),
            (L["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."]):format(
                ns.Money(step.perHour)))
    else
        headline(UI.ItemIcon(prof.nodes[step.node].item), (L["Skin in %s"]):format(zone.name),
            step.dangerous and C.warn or C.text,
            (L["Skill %d - %d, about %d creatures%s"]):format(step.from, step.to, math.ceil(step.crafts),
                step.cost > 0 and (L[", trainer %s"]):format(ns.Money(step.cost)) or ""),
            ladder.mode == "sell" and (L["Worth about %s skinned (%s an hour)."]):format(ns.Money(step.earn),
                ns.Money(step.perHour)) or L["Skin every creature that still gives a point, of your level or below."])
        pickedNote(step, (L["Craft Ladder's choice here is %s."]):format(step.options[1].name))
    end
    if step.dangerous then line(L["Its creatures are well above your level."], C.warn) end

    section(L["Creatures to skin here"])
    -- the ones you can skin by the step's end, those that still give a point first, most spawns first
    local list = {}
    for id, n in pairs(zone.nodes) do
        local node = prof.nodes[id]
        if node and node.skill <= step.to then
            list[#list + 1] = { id = id, n = n, useful = ns.Ladder.Chance(node.colors, step.from) > 0 }
        end
    end
    table.sort(list, function(a, b)
        if step.hour then -- Gold: the ones that earn the most first
            local wa, wb = a.n * (step.worth[a.id] or 0), b.n * (step.worth[b.id] or 0)
            if wa ~= wb then return wa > wb end
        elseif a.useful ~= b.useful then
            return a.useful
        end
        return a.n > b.n
    end)
    for i, x in ipairs(list) do
        if i > 12 then
            line((L["and %d more"]):format(#list - 12), C.muted)
            break
        end
        creatureRow(x.id, x.n, step)
    end
    line(L["Which creatures can be skinned and what one gives come from Classic; where they are and their levels from" ..
        " QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past 20), the" ..
        " colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts once you've" ..
        " skinned one."], C.muted)
    if ladder.mode ~= "skill" then
        line((L["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an" ..
            " hour here."]):format(prof.nodeSeconds, step.crafts / (step.seconds / 3600) + 0.5), C.muted)
    end
    if step.hour then return end

    section((L["Other zones, from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

local function mineDetail(step)
    local zone = prof.zones[step.zone]
    local g = gather()
    if step.hour then
        headline(UI.ItemIcon(prof.nodes[step.node].item), (L["%s in %s"]):format(g.verb, zone.name),
            step.dangerous and C.warn or C.text,
            (L["An hour at skill %d: about %d %s, %s each"]):format(step.from, step.crafts, g.many, ns.Money(step.value)),
            (L["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."]):format(
                ns.Money(step.perHour), g.one, zone.levels[1], zone.levels[2]))
    else
        headline(UI.ItemIcon(prof.nodes[step.node].item), (L["%s in %s"]):format(g.verb, zone.name),
            step.dangerous and C.warn or C.text,
            (L["Skill %d - %d, about %d %s%s"]):format(step.from, step.to, math.ceil(step.crafts), g.many,
                step.cost > 0 and (L[", trainer %s"]):format(ns.Money(step.cost)) or ""),
            ladder.mode == "sell" and (L["Worth about %s (%s an hour). Creatures level %d - %d."]):format(
                ns.Money(step.earn), ns.Money(step.perHour), zone.levels[1], zone.levels[2])
            or (L["Creatures level %d - %d. %s every %s that still gives a point."]):format(zone.levels[1],
                zone.levels[2], g.verb, g.one))
        pickedNote(step, (L["Craft Ladder's choice here is %s."]):format(step.options[1].name))
    end
    if step.dangerous then line(L["Its creatures are well above your level."], C.warn) end

    section(g.here)
    -- Gold: the ones that earn the most first; else the ones that still give a point at the step's start first
    local list = {}
    for id, n in pairs(zone.nodes) do
        local node = prof.nodes[id]
        list[#list + 1] = { id = id, n = n, earns = n * (step.worth[id] or 0),
                            useful = step.from >= node.skill and ns.Ladder.Chance(node.colors, step.from) > 0 }
    end
    table.sort(list, function(a, b)
        if step.hour and a.earns ~= b.earns then return a.earns > b.earns end
        if not step.hour and a.useful ~= b.useful then return a.useful end
        return a.n > b.n
    end)
    for _, x in ipairs(list) do nodeRow(x.id, x.n, step) end

    if not next(prof.recipes) then -- Herbalism: nothing to smelt
        line((L["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a" ..
            " place, from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
            " needs): Forever may differ."]):format((g.one:gsub("^%l", string.upper))), C.muted)
        if ladder.mode ~= "skill" then
            line((L["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about" ..
                " %d an hour here."]):format(g.one, step.crafts / (step.seconds / 3600) + 0.5), C.muted)
        end
        if step.hour then return end
        section((L["Other zones, from %d"]):format(step.from))
        for _, o in ipairs(step.options) do optionRow(step, o) end
        return
    end

    if not step.hour then section(L["Smelt on the way"]) end
    local smelts = {}
    for spell, n in pairs(step.bars) do smelts[#smelts + 1] = { spell = spell, n = n } end
    table.sort(smelts, function(a, b) return a.n > b.n end)
    for _, x in ipairs(smelts) do
        local fee = step.learns[x.spell]
        line((L["%s: about %d bars%s"]):format(ns.Describe.RecipeName(x.spell, prof.recipes[x.spell]), math.ceil(x.n),
            fee and (L[", learn it from a Mining trainer for %s"]):format(ns.Money(fee)) or ""), C.text)
    end
    if #smelts == 0 and not step.hour then line(L["Nothing you mine here still gives points when smelted."], C.muted) end

    section(L["Sell ore or bars"])
    local ores = {}
    for ore, d in pairs(step.sell) do ores[#ores + 1] = { ore = ore, d = d } end
    table.sort(ores, function(a, b) return a.ore < b.ore end)
    local alloys = {}
    for _, x in ipairs(ores) do
        local d, name = x.d, ns.Describe.ItemName(x.ore)
        if not d.bars then
            line((L["%s: %s each. Smelting it needs more skill."]):format(name, ns.Money(d.ore)), C.text)
        else
            local barName = ns.Describe.ItemName(prof.recipes[d.recipe].makes)
            local best, advice = d.ore, L["sell the ore, smelt it only for the skill-ups"]
            if d.bars > best then best, advice = d.bars, L["smelt it and sell the bars"] end
            local alloyText = ""
            if d.alloy then
                local alloy = prof.recipes[d.alloyRecipe]
                alloys[d.alloyRecipe] = alloy
                alloyText = (L[", %s as %s"]):format(ns.Money(d.alloy), ns.Describe.ItemName(alloy.makes))
                if d.alloy > best then
                    best, advice = d.alloy, (L["make %s and sell it"]):format(ns.Describe.ItemName(alloy.makes))
                end
            end
            line((L["%s: %s as ore, %s as %s%s - %s."]):format(name, ns.Money(d.ore), ns.Money(d.bars), barName, alloyText,
                advice), best > d.ore and C.good or C.text)
        end
    end
    for _, alloy in pairs(alloys) do
        local mats = {}
        for item, n in pairs(alloy.mats) do mats[#mats + 1] = ("%d %s"):format(n, ns.Describe.ItemName(item)) end
        table.sort(mats)
        line((L["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer" ..
            " one allows."]):format(alloy.name, table.concat(mats, L[" and "]), alloy.count, ns.Describe.ItemName(alloy.makes)),
            C.muted)
    end
    if #ores == 0 then line(L["Nothing mined here can be smelted."], C.muted) end
    line(L["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."], C.muted)
    if not step.hour then
        line(L["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."],
            C.muted)
    end
    line(L["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node needs):" ..
        " Forever may differ."], C.muted)
    if ladder.mode ~= "skill" then
        line((L["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
            " about %d nodes an hour here."]):format(step.crafts / (step.seconds / 3600) + 0.5), C.muted)
    end
    if step.hour then return end

    section((L["Other zones, or smelting, from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

---------------------------------------------------------------------------------------------------------------
-- Lockpicking: a zone's chests, a box from the bags, and every lock by skill
---------------------------------------------------------------------------------------------------------------

-- A place on a zone's map (a pin and the arrow on a click): where most of a kind of chest are.
local function spotRow(map, x, y, text)
    local f = get("place")
    f.npc, f.npcName, f.spot = false, text, { map, x, y, text, prof.zones[map] and prof.zones[map].name }
    f.text:SetText(text)
    f.right:SetText(("%.0f, %.0f"):format(x, y))
    place(f, 2)
end

-- "orange", "grey", or "needs 110": a lock's colour for you at `skill`.
local function lockColor(colors, need, skill)
    if skill < need then return hex(C.bad) .. (L["needs %d"]):format(need) .. "|r" end
    local color = ns.Ladder.Color(colors, skill)
    return hex(STEP_COLOR[color]) .. L[color] .. "|r"
end

-- A kind of lock in a zone: how many, the skill it needs, its colour for you at the step's start.
local function lockRow(id, n, step)
    local node = prof.nodes[id]
    local f = get("item")
    f.item = false -- a chest has no item: its icon is a box's look-alike
    f.icon:SetTexture(UI.ItemIcon(node.item))
    f.name:SetText(node.name)
    f.sub:SetText((prof.zones[step.zone].dungeon and L["%d a run, needs %d"] or L["about %d in the zone, needs %d"]):format(
        math.max(1, math.floor(n + 0.5)), node.skill))
    UI.SetColor(f.sub, C.muted)
    f.cost:SetText(lockColor(node.colors, node.skill, step.from))
    f.source = colorsText(node.colors)
    place(f, 2)
end

-- Where a box picked from the bags comes from.
local BOX_FROM = { drop = "Humanoids drop it; the auction house sells it.", fishing = "Fished up from pools.",
                   engineering = "Engineers make it." }
local function boxFrom(rec)
    if rec.source ~= "pickpocket" then
        local from = BOX_FROM[rec.source]
        return from and L[from] or ""
    end
    return rec.levels and (L["Pick Pocket humanoids of level %d - %d."]):format(rec.levels[1], rec.levels[2])
        or L["Pick Pocket humanoids."]
end

local function lockDetail(step)
    local zone = prof.zones[step.zone]
    local first = step.mix and step.mix[1]
    headline(UI.ItemIcon(first and first.item or prof.nodes[step.node].item),
        (L["Pick locks in %s"]):format(zone.name),
        step.dangerous and C.warn or C.text,
        (L["Skill %d - %d, about %d locks"]):format(step.from, step.to, math.ceil(step.crafts)),
        (L["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one more" ..
            " once it's back."]):format(zone.levels[1], zone.levels[2]))
    if step.options[1] then pickedNote(step, (L["Craft Ladder's choice here is %s."]):format(step.options[1].name)) end
    if step.dangerous then line(L["Its creatures are well above your level."], C.warn) end
    if zone.dungeon then
        section(L["The door round"])
        line(L["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."], C.text)
        line(L["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
            " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."], C.text)
        line(L["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
            " an hour."], C.text)
        line(L["The round is zockify's Forever guide's: about 4 doors a run."], C.muted)
    end

    section(gather().here)
    local list = {}
    for id, n in pairs(zone.nodes) do list[#list + 1] = { id = id, n = n, skill = prof.nodes[id].skill } end
    table.sort(list, function(a, b)
        if a.skill ~= b.skill then return a.skill < b.skill end
        return a.id < b.id
    end)
    for _, x in ipairs(list) do lockRow(x.id, x.n, step) end
    if zone.spots then
        section(L["Where"])
        local named = {} -- one place per name: GatherMate2 doesn't tell a name's kinds apart
        for _, x in ipairs(list) do
            local node, s = prof.nodes[x.id], zone.spots[x.id]
            if s and not named[node.name] then
                named[node.name] = true
                spotRow(zone.map, s[1], s[2], (L["Most %ss are around here"]):format(node.name))
            end
        end
    end
    line(L["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours (yellow" ..
        " 25, green 50, grey 100 above it), are Classic's: Forever may differ."], C.muted)

    section((L["Other zones, or boxes, from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

local function boxDetail(step)
    local rec = prof.recipes[step.recipe]
    local box = next(rec.mats)
    headline(UI.ItemIcon(box), (L["Pick %s"]):format(ns.Describe.RecipeName(step.recipe, rec)),
        STEP_COLOR[step.color] or C.text,
        (L["Skill %d - %d, about %d boxes, %s"]):format(step.from, step.to, math.ceil(step.crafts),
            step.missing and (hex(C.bad) .. L["some prices missing"] .. "|r") or ns.Money(step.cost)),
        colorsText(rec.colors))
    if step.options[1] then pickedNote(step, (L["Craft Ladder's choice here is %s."]):format(step.options[1].name)) end
    if step.fromBags then
        line((L["Pick the ones in your bags: you have %d."]):format(ladder.state.owned[box] or 0), C.good)
    end
    line(boxFrom(rec), C.muted)
    section((L["Boxes to buy: %s"]):format(step.missing and "?" or ns.Money(step.matCost)))
    for item, b in pairs(step.buy) do itemRow(item, b) end
    line(L["A box gives one chance at a point, and what's inside is yours."], C.muted)

    section((L["Or pick locks in a zone, from %d"]):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

-- Every lock a rogue picks, by skill, and its colour for you; how to start.
local function locksDetail()
    local state = ladder.state
    local skill = state.skill
    headline(prof.icon, L["All locks"], C.gold, (L["Every lock a rogue picks, by the skill it needs; its colour at your %d."])
        :format(skill), L["Orange always gives a point, yellow mostly, green sometimes, grey never."])

    section(L["Chests in the world"])
    local where = {} -- [kind] = { zone names }
    for _, zone in pairs(prof.zones) do
        for id in pairs(zone.nodes) do
            where[id] = where[id] or {}
            table.insert(where[id], zone.name)
        end
    end
    local chests = {}
    for id, node in pairs(prof.nodes) do chests[#chests + 1] = { id = id, node = node } end
    table.sort(chests, function(a, b)
        if a.node.skill ~= b.node.skill then return a.node.skill < b.node.skill end
        return a.node.name < b.node.name
    end)
    for _, x in ipairs(chests) do
        local f = get("item")
        f.item = false
        f.icon:SetTexture(UI.ItemIcon(x.node.item))
        f.name:SetText(("%s  %s%d|r"):format(x.node.name, hex(C.muted), x.node.skill))
        table.sort(where[x.id] or {})
        f.sub:SetText(table.concat(where[x.id] or {}, ", "))
        UI.SetColor(f.sub, C.muted)
        f.cost:SetText(lockColor(x.node.colors, x.node.skill, skill))
        f.source = colorsText(x.node.colors)
        place(f, 2)
    end

    section(L["Boxes from your bags"])
    local boxes = {}
    for key, rec in pairs(prof.recipes) do boxes[#boxes + 1] = { key = key, rec = rec } end
    table.sort(boxes, function(a, b)
        if a.rec.learn ~= b.rec.learn then return a.rec.learn < b.rec.learn end
        return a.rec.name < b.rec.name
    end)
    for _, x in ipairs(boxes) do
        local box, f = next(x.rec.mats), get("item")
        local e, have = lookup(box), state.owned[box] or 0
        f.item = box
        f.icon:SetTexture(UI.ItemIcon(box))
        f.name:SetText(("%s  %s%d|r"):format(ns.Describe.RecipeName(x.key, x.rec), hex(C.muted), x.rec.learn))
        f.sub:SetText(boxFrom(x.rec)
            .. (have > 0 and (" " .. hex(C.good) .. (L["You have %d."]):format(have) .. "|r") or "")
            .. (e and e.source ~= "vendor" and (L[" %s at the auction house."]):format(ns.Money(e.unit)) or ""))
        UI.SetColor(f.sub, C.muted)
        f.cost:SetText(lockColor(x.rec.colors, x.rec.learn, skill))
        f.source = colorsText(x.rec.colors)
        place(f, 2)
    end

    section(L["Dungeon doors"])
    for _, d in ipairs(prof.doors) do
        line((L["%s: %d locked doors, from %d (%s)."]):format(d.dungeon, d.doors, d.skill,
            lockColor({ d.skill, d.skill + 25, d.skill + 50, d.skill + 100 }, d.skill, skill)), C.text)
    end

    section(L["Getting started"])
    line((L["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue supplies" ..
        " vendors, 15s). Your cap is your level x 5."]):format(ns.Money(prof.learnRank and prof.learnRank.cost
        or prof.ranks[1].cost or 0)), C.text)
    chainSection()
end

local function renderDetail()
    local d = frame.detail
    CW = math.max(DETAIL_CW, frame:GetWidth() - (W - DETAIL_CW))
    d.head:Fit(CW)
    for _, p in pairs(pools) do p:ReleaseAll() end
    d.head:Hide()
    d.back:Hide()
    d.craft:Hide()
    d.search:Hide()
    y = 0
    local state = ladder.state
    local step = ladder.steps[selected]
    d.head.step = step
    if step and step.kind == "favor" then
        favorDetail(step)
    elseif selected == 0 and prof.doors then
        locksDetail()
    -- Lockpicking's ladder starts with learning Pick Lock; the account's Disenchant doesn't: its rows stand without
    -- an Enchanting of your own, each saying what it would need
    elseif state.maxSkill == 0 and not prof.levelCaps and not ladder.account then
        headline(prof.icon, (L["No %s yet"]):format(prof.name), C.gold,
            (L["Any %s trainer teaches Apprentice %s."]):format(prof.name, prof.name), "")
    elseif not step and ladder.account then
        headline(prof.icon, L["Nothing to disenchant"], C.gold, L["No character of yours holds anything to" ..
            " disenchant, and "] .. (ladder.known == 0 and L["none of the recipes they know makes something to disenchant: open a" ..
                " crafting profession's window once so Craft Ladder knows its recipes."] or L["nothing they can make is" ..
                " worth more disenchanted than sold at today's prices."]), "")
    elseif not step and ladder.mode == "gold" and prof.resale then
        headline(prof.icon, L["Nothing earns now"], C.gold,
            L["Nothing you can make sells for more than it costs at today's prices."], "")
    elseif not step and ladder.mode == "gold" and prof.kind then
        headline(prof.icon, L["Nothing earns now"], C.gold,
            L["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."], "")
    elseif not step then
        headline(prof.icon, L["Nothing to do here"], C.gold,
            state.skill >= state.target and (L["You've reached %d %s."]):format(state.target, prof.name)
                or L["No recipe found for your skill."], "")
    elseif step.kind == "rank" then
        rankDetail(step)
    elseif step.kind == "fish" then
        fishDetail(step)
    elseif step.kind == "mine" and prof.doors then
        lockDetail(step)
    elseif step.kind == "craft" and prof.doors then
        boxDetail(step)
    elseif step.kind == "mine" and prof.key == "skinning" then
        skinDetail(step)
    elseif step.kind == "mine" then
        mineDetail(step)
    elseif step.kind == "food" then
        foodDetail(step)
    elseif step.kind == "profit" then
        profitDetail(step)
    elseif step.kind == "disenchant" then
        prof = step.data
        disenchantDetail(step)
    elseif step.kind == "bag" then
        bagDetail(step)
    elseif step.kind == "auction" then
        auctionDetail(step)
    else
        craftDetail(step)
    end
    -- the steps whose counts come from the chance of a skill-up: Working Overtime in the headline, seen without
    -- scrolling (a recipe's after its colours, a zone's after its count)
    if step and state.overtime > 0 and not step.hour
        and (step.kind == "craft" or step.kind == "mine" or step.kind == "fish") then
        local fs = step.kind == "craft" and d.head.line2 or d.head.line1
        fs:SetText(fs:GetText() .. (L[", Working Overtime %d/5: +%d%%"]):format(state.overtime, 4 * state.overtime))
    end
    d.scroll:SetContentHeight(y + 8)
    d.scroll:ScrollToTop()
end

-- The card's widget pools, in the window's details (built once, with the window).
function Cards.Build(f)
    frame = f
    pools.section = UI.Pool(makeSection)
    pools.line = UI.Pool(makeLine)
    pools.place = UI.Pool(makePlace)
    pools.more = UI.Pool(makeMore)
    pools.item = UI.Pool(makeItem)
    pools.option = UI.Pool(makeOption)
end

-- Draws the card of the step picked in the ladder the window shows.
function Cards.Render(f, l, lk, p, sel)
    frame, ladder, lookup, prof, selected = f, l, lk, p, sel
    renderDetail()
end

Cards.PaintCraft, Cards.CraftClick, Cards.CraftWhenOpen = paintCraft, craftClick, craftWhenOpen
-- the card's widgets, for the specialization's steps (UI/SpecPanel.lua): each made with its parent, Fit(width) after
Cards.Widgets = { section = makeSection, line = makeLine, place = makePlace, item = makeItem }
