-- Craft Ladder: the main window's step details (right), a card for every kind of step: a recipe (how to learn it,
-- what to buy, the other recipes you could use there), a rank, a fishing or mining zone, Lockpicking's locks, a
-- Merchant's Favor recipe, Gold's sale; and the Craft bar. UI/Window.lua draws the rest and calls Cards.Render with
-- what it shows.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local Window = ns.Window

local Cards = {}
ns.Cards = Cards

-- shared with the window (UI/Window.lua)
local S = Window.Shared
local W, DETAIL_CW, STEP_COLOR, BAG_ICON, RANK_ICON = S.W, S.DETAIL_CW, S.STEP_COLOR, S.BAG_ICON, S.RANK_ICON
local craftsWord, wait, recipeIcon, toolUsers, gather = S.craftsWord, S.wait, S.recipeIcon, S.toolUsers, S.gather
local duration, barsText, useLevel = S.duration, S.barsText, S.useLevel
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
    f.text = UI.Label(f, 11, C.text)
    f.text:SetPoint("TOPLEFT")
    f.text:SetWidth(DETAIL_CW)
    f.text:SetWordWrap(true)
    function f:Fit(cw) self:SetWidth(cw); self.text:SetWidth(cw) end
    return f
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
        UI.Tooltip(self, { self.npcName or "", "Click: put a map pin and the arrow on it." })
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
    b.sub = UI.Label(b, 10, C.muted)
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
    b.sub = UI.Label(b, 10, C.muted)
    b.sub:SetPoint("BOTTOMLEFT", 26, 6)
    b.sub:SetWidth(DETAIL_CW - 26 - 110)
    b.right = UI.Label(b, 11, C.text, nil, "RIGHT")
    b.right:SetPoint("TOPRIGHT", -10, -6)
    b.right2 = UI.Label(b, 10, C.muted, nil, "RIGHT")
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
                { Many .. " that give points", nodeKinds(prof.zones[o.zone], o.from) },
                { Many .. " for this step", "~" .. math.ceil(o.crafts) },
                next(prof.recipes) and { "Smelt on the way", barsText(o.bars) } or nil,
                { "Trainer", ns.Money(o.cost) },
                o.perHour and { "A " .. g.one .. " is worth", ns.Money(o.value) } or nil,
                o.perHour and { "Gold an hour", ns.Money(o.perHour) } or nil,
                not self.chosen and ("Click to %s here for this step."):format(g.verb:lower()) or nil,
            })
            return
        end
        if o.zone then
            UI.Tooltip(self, {
                o.name,
                { "Fish that land", o.landed >= 1 and "all of them" or ("%d%%"):format(o.landed * 100) },
                { "Lure", o.lure and ("%s (+%d)"):format(ns.Describe.ItemName(o.lure), o.lureBonus) or "none needed" },
                { "A catch is worth", ns.Money(o.value) },
                { "Lures for this step", ns.Money(o.cost) },
                not self.chosen and "Click to fish here for this step." or nil,
            })
            return
        end
        local lines = {}
        if o.fromBags then lines[#lines + 1] = ("%s the %d you can make from what you have."):format(Verbs(), o.have) end
        lines[#lines + 1] = { "Skill", ("%d - %d (%s)"):format(o.from, o.to, o.color) }
        lines[#lines + 1] = { "Crafts", "~" .. math.ceil(o.crafts) }
        lines[#lines + 1] = { "Ingredients", o.missing and (hex(C.bad) .. "no price|r") or ns.Money(o.matCost) }
        lines[#lines + 1] = { "Learn", ns.Describe.Learn(o.learn, prof) }
        if o.learn.cost and o.learn.cost > 0 then
            lines[#lines + 1] = { "Recipe", ns.Describe.Price(o.learn.cost, o.learn.guess) }
        end
        if o.back and o.back > 0 then lines[#lines + 1] = { "Selling them brings back", ns.Money(o.back) } end
        if o.cost then lines[#lines + 1] = { "Per skill point", ns.Money(o.perPoint) } end
        if not self.chosen then lines[#lines + 1] = "Click to use this recipe for this step." end
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

-- "11 Copper Ore (buy 6), 11 Tin Ore (buy 6)": what an ingredient that's made is made of, all the way down, and how
-- much of it to buy.
local function madeFrom(make)
    local leaves = {}
    local function walk(parts)
        for item, b in pairs(parts) do
            if b.make then
                walk(b.make.parts)
            else
                local l = leaves[item] or { need = 0, buy = 0 }
                l.need, l.buy = l.need + b.need, l.buy + b.buy
                leaves[item] = l
            end
        end
    end
    walk(make.parts)
    local list = {}
    for item, l in pairs(leaves) do
        local need, buy = math.ceil(l.need - 1e-9), math.ceil(l.buy - 1e-9)
        list[#list + 1] = ("%d %s%s"):format(need, ns.Describe.ItemName(item),
            buy <= 0 and " (you have them)" or buy < need and (" (buy " .. buy .. ")") or "")
    end
    table.sort(list)
    return table.concat(list, ", ")
end

local function itemRow(item, b)
    local f = get("item")
    local e = lookup(item)
    f.item = item
    f.icon:SetTexture(UI.ItemIcon(item))
    local inBank = ladder.state.inBank and ladder.state.inBank[item]
    local have = ""
    if b.have > 0 then
        have = "  (you have " .. math.floor(b.have) ..
            (inBank and (inBank >= b.have and ", in the bank" or (", " .. inBank .. " in the bank")) or "") .. ")"
    end
    f.name:SetText(("%d %s%s"):format(math.ceil(b.need), ns.Describe.ItemName(item),
        hex(C.muted) .. have .. "|r"))
    local source = ns.Describe.PriceSource(e)
    if b.make and b.buy > 0 then
        local what = b.make.mining and "smelt" or prof.verb
        source = ("%s %d yourself from %s"):format(what, math.ceil(b.buy), madeFrom(b.make))
        f.sub:SetText(source:gsub("^%l", string.upper))
        UI.SetColor(f.sub, C.good)
        f.cost:SetText(ns.Money(b.cost))
    elseif b.buy <= 0 then
        f.sub:SetText("you have enough")
        UI.SetColor(f.sub, C.good)
        f.cost:SetText(ns.Money(0))
    elseif not b.cost then
        f.sub:SetText(source)
        UI.SetColor(f.sub, C.bad)
        f.cost:SetText(hex(C.bad) .. "?|r")
    else
        if b.short then
            f.sub:SetText(("only %d listed - you need %d"):format(e.qty, math.ceil(b.buy)))
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
    f.name:SetText(ns.Describe.ItemName(item) .. (cooking and (hex(C.good) .. "  your Cooking uses it|r") or ""))
    f.sub:SetText(("%d%% of catches%s"):format(math.max(1, math.floor(share * 100 + 0.5)),
        v and v.how and (", " .. VALUE_HOW[v.how]) or ""))
    UI.SetColor(f.sub, C.muted)
    f.cost:SetText(v and v.value > 0 and (ns.Money(v.value) .. hex(C.muted) .. " each|r") or (hex(C.dim) .. "no price|r"))
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
        f.name:SetText(o.name .. (o.dangerous and (hex(C.bad) .. ("  creatures level %d+|r"):format(
            o.mobLevel or prof.zones[o.zone].levels[1])) or ""))
        UI.SetColor(f.name, C.text)
        f.sub:SetText(nodeKinds(prof.zones[o.zone], o.from))
        local g = gather()
        if ladder.mode ~= "skill" then
            f.right:SetText(ns.Money(o.perHour) .. hex(C.muted) .. " / hour|r")
            f.right2:SetText(("~%d %s, %s a %s"):format(math.ceil(o.crafts), g.many, ns.Money(o.value), g.one))
        else
            f.right:SetText(("~%d %s"):format(math.ceil(o.crafts), g.many))
            f.right2:SetText(o.cost > 0 and (ns.Money(o.cost) .. " at the trainer") or "")
        end
        f:Paint()
        place(f, 4)
        return
    end
    if o.zone then
        local c = o.landed >= 1 and C.text or C.warn
        f.dot:SetVertexColor(C.alliance[1], C.alliance[2], C.alliance[3])
        f.name:SetText(o.name .. (o.dangerous and (hex(C.bad) .. ("  creatures level %d+|r"):format(
            prof.zones[o.zone].levels[1])) or ""))
        UI.SetColor(f.name, c)
        f.sub:SetText((o.landed >= 1 and "no fish get away" or ("%d%% of casts land a fish"):format(o.landed * 100)) ..
            (o.lure and (", with " .. ns.Describe.ItemName(o.lure)) or ""))
        if ladder.mode ~= "skill" then
            f.right:SetText(ns.Money(o.perHour) .. hex(C.muted) .. " / hour|r")
            f.right2:SetText(ns.Money(o.value) .. " a catch" .. (o.cost > 0 and (", lures " .. ns.Money(o.cost)) or ""))
        else
            f.right:SetText(ns.Money(o.value) .. hex(C.muted) .. " / catch|r")
            f.right2:SetText(o.cost > 0 and (ns.Money(o.cost) .. " for lures") or "")
        end
        f:Paint()
        place(f, 4)
        return
    end
    local c = STEP_COLOR[o.color] or C.text
    f.dot:SetVertexColor(c[1], c[2], c[3])
    f.name:SetText(o.name .. (o.fromBags and (hex(C.good) .. "  with what you have|r") or ""))
    UI.SetColor(f.name, c)
    f.sub:SetText(("%d - %d, ~%d %s, %s"):format(o.from, o.to, math.ceil(o.crafts), craftsWord(),
        prof.doors and (o.fromBags and "from your bags" or "bought at the auction house")
        or ("learn: " .. ns.Describe.Learn(o.learn, prof))))
    f.right:SetText(o.perPoint and (ns.Money(o.perPoint) .. hex(C.muted) .. " / point|r") or (hex(C.bad) .. "no price|r"))
    f.right2:SetText(o.cost and (ns.Money(o.cost) .. " in all" ..
        ((o.back or 0) > 0 and (", " .. ns.Money(o.back) .. " back") or "")) or "")
    f:Paint()
    place(f, 4)
end

-- "orange to 89, yellow 90, green 110, grey 130"
local function colorsText(colors)
    local parts = {}
    local yellow, green, grey = colors[2], colors[3], colors[4]
    parts[#parts + 1] = hex(C.orange) .. "orange|r from " .. colors[1]
    if yellow > 0 then parts[#parts + 1] = hex(C.yellow) .. "yellow|r " .. yellow end
    if green > 0 then parts[#parts + 1] = hex(C.green) .. "green|r " .. green end
    parts[#parts + 1] = hex(C.grey) .. "grey|r " .. grey
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
    line(hex(C.gold) .. "Your pick.|r " .. text, C.text)
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

local function paintCraft(bar)
    local step, rec = bar.step, bar.rec
    local can, why = canMake(step), nil
    if not rec.makes then
        why = "An enchantment: enchant from the profession window, on the item."
    elseif not (step.learn.kind == "known" and not step.learn.earlier or step.learn.kind == "start") then
        why = "Learn the recipe first."
    elseif InCombatLockdown and InCombatLockdown() then
        why = "Not in combat."
    elseif can <= 0 then
        why = "Not enough reagents in your bags."
    end
    bar.button:SetEnabled(why == nil)
    bar.button.tooltip = { "Craft", "Crafts as many as the box says; opens your profession window first if it's "
        .. "closed (the game crafts only with it open)." .. (prof.key == "cooking" and " Cooking needs a fire nearby."
        or "") }
    bar.note:SetText(why and (hex(C.warn) .. why .. "|r")
        or ("Your bags allow %d; the step needs %d."):format(can, bar.need))
end

local function craftClick(bar)
    local T = C_TradeSkillUI
    bar.count:ClearFocus()
    local n = math.floor(tonumber(bar.count:GetText()) or 0)
    if n <= 0 or not (T and T.CraftRecipe) then return end
    if not professionOpen() and T.OpenTradeSkill then T.OpenTradeSkill(prof.skillLine) end
    T.CraftRecipe(bar.step.recipe, n)
end

local function craftBar(step, rec)
    if prof.kind then return end -- gathering and Lockpicking: nothing to craft here
    local bar = frame.detail.craft
    bar.step, bar.rec, bar.need = step, rec, math.ceil(step.crafts)
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", 0, -y)
    bar:Show()
    bar.count:SetText(tostring(math.max(0, math.min(canMake(step), bar.need)))) -- no more than the step needs
    paintCraft(bar)
    y = y + 32
end

-- How to learn the recipe of a step: the vendors that sell it, the quest, the trainer.
local function learnSection(step, rec)
    local state = ladder.state
    section("Learn it")
    local way = step.learn
    if way.kind == "vendor" then
        local vendors = ns.Describe.Vendors(prof, step.recipe, state.faction, ns.db.favor)
        local real = realPrice(rec.item)
        line(("Buy the recipe from %s:"):format(#vendors > 1 and "one of these vendors" or "this vendor"), C.text)
        for i, v in ipairs(vendors) do
            if i > 4 then
                line(("and %d more vendors"):format(#vendors - 4), C.muted)
                break
            end
            placeRow(v.npc, v.favor and ((v.favor == true and "Merchant's" or v.favor) .. " Favor")
                or ns.Describe.Price(real or v.cost, not real and v.costGuess))
        end
    elseif way.kind == "quest" then
        local name, q = ns.Describe.Quest(way.quest)
        line(("Quest reward: %s%s"):format(name, way.reqLevel and way.reqLevel > state.level and
            (" " .. hex(C.bad) .. "(needs level " .. way.reqLevel .. ")|r") or ""), C.text)
        if q and q.giver then placeRow(q.giver, "quest giver") end
    elseif way.kind == "trainer" and rec.trainers then
        line(("Only these trainers teach it, for %s:"):format(ns.Describe.Price(way.cost, way.guess)), C.text)
        local theirs = 0
        for _, npc in ipairs(rec.trainers) do
            local n = prof.npcs[npc]
            if n and n.faction:find(state.faction, 1, true) then
                placeRow(npc, "trainer")
                theirs = theirs + 1
            end
        end
        if theirs == 0 then line("None of them is of your faction.", C.bad) end
    else
        line(ns.Describe.Learn(way, prof):gsub("^%l", string.upper) .. ".",
            way.kind == "known" and not way.earlier and C.good or C.text)
    end
    for _, g in ipairs(rec.get) do -- a holiday's way, never the ladder's: where to get one then
        if g.event and way.kind ~= "known" then
            line(("During %s: %s."):format(g.event, ns.Describe.Learn(g, prof)), C.dim)
        end
    end
    if way.guess then
        line(("The price is an estimate: Craft Ladder learns the real one when you visit the %s."):format(
            way.kind == "trainer" and "trainer" or "vendor"), C.dim)
    end
end

-- What `n` of what a recipe makes sell for: at the auction house (its lowest listing, after the cut) and at a vendor.
-- prefix: "Sells for ", "Each sells for ", "12 sell for ".
local function sellLines(rec, n, prefix)
    if not rec.makes then
        line("An enchantment: nothing to sell.", C.muted)
        return
    end
    local e = lookup(rec.makes, true)
    local ah = e and (e.min or e.unit)
    local vendor = ns.Prices.VendorSell(prof, rec.makes)
    line(ah and ("%s%s at the auction house (after its cut%s)."):format(prefix, ns.Money(n * ah * ns.Prices.AH_CUT),
        e.qty and (", " .. e.qty .. " listed") or "") or "Not on the auction house.", C.muted)
    line(vendor and vendor > 0 and (prefix .. ns.Money(n * vendor) .. " at a vendor.") or "Vendors don't buy it.", C.muted)
end

-- One craft, up top: each ingredient, how many it takes and what they cost at this step's prices (bought, made, or
-- what the ones you have would cost), and what one sells for at the auction house and at a vendor.
local function oneCraft(step, rec)
    local items, total = {}, 0
    for item in pairs(rec.mats) do items[#items + 1] = item end
    table.sort(items)
    local rows = {}
    for _, item in ipairs(items) do
        local b, e = step.buy[item], lookup(item)
        local each = (b and b.buy > 0 and b.cost) and b.cost / b.buy or (e and e.unit)
        total = total and each and total + rec.mats[item] * each
        rows[#rows + 1] = { item = item, each = each, e = e, make = b and b.buy > 0 and b.make }
    end
    section(("One craft%s: %s"):format((rec.yield or 1) > 1 and (" (makes " .. rec.yield .. ")") or "",
        total and ns.Money(total) or "?"))
    for _, r in ipairs(rows) do
        local f = get("item")
        local n = rec.mats[r.item]
        f.item = r.item
        f.icon:SetTexture(UI.ItemIcon(r.item))
        f.name:SetText(("%d %s"):format(n, ns.Describe.ItemName(r.item)))
        local from = r.make and ((r.make.mining and "smelt" or prof.verb) .. " yourself")
            or r.e and (r.e.source == "vendor" and "vendor" or "auction house")
        f.sub:SetText(r.each and ("%s each, %s"):format(ns.Money(r.each), from or "") or "no price")
        UI.SetColor(f.sub, r.make and C.good or r.each and C.muted or C.bad)
        f.cost:SetText(r.each and ns.Money(n * r.each) or (hex(C.bad) .. "?|r"))
        f.source = ns.Describe.PriceSource(r.e)
        place(f, 2)
    end
    sellLines(rec, 1, (rec.yield or 1) > 1 and "Each sells for " or "Sells for ")
end

-- A recipe the quartermasters sell for Merchant's Favor: its price, level and skill against yours, where to buy it,
-- what one craft takes.
local function favorDetail(step)
    local rec, state = prof.recipes[step.recipe], ladder.state
    local have = ns.Favor.Have()
    headline(recipeIcon(rec), rec.name, step.status == "known" and C.good or step.status == "learn" and C.gold or C.bad,
        step.status == "known" and "You know it." or step.status == "learn" and "You can learn it now."
            or step.status == "skill" and ("It needs %d %s (you: %d)."):format(rec.learn, prof.name, state.skill)
            or ("It needs level %d (you: %d)."):format(step.level, state.level),
        colorsText(rec.colors))
    if step.status == "skill" or step.status == "level" then frame.detail.head.icon:SetVertexColor(1, 0.15, 0.15) end
    section("Merchant's Favor")
    line(step.cost and ("Costs %d Merchant's Favor%s."):format(step.cost, have and (" (you have %d)"):format(have) or "")
        or "Its price: open a quartermaster once and Craft Ladder remembers it.", step.cost and C.text or C.muted)
    line(step.level and ("From level %d (you: %d)."):format(step.level, state.level)
        or "Its level: open a quartermaster once and Craft Ladder remembers it.",
        step.level and (step.level > state.level and C.warn or C.text) or C.muted)
    line(("From %d %s (you: %d)."):format(rec.learn, prof.name, state.skill), rec.learn > state.skill and C.warn or C.text)
    local wear, worn = useLevel(rec.makes)
    if wear and wear > 1 then
        line(("%s is %s from level %d (you: %d)."):format(ns.Describe.ItemName(rec.makes), worn and "worn" or "used",
            wear, state.level), wear > state.level and C.warn or C.text)
    end
    local vendors = ns.Describe.Vendors(prof, step.recipe, state.faction, true)
    if #vendors > 0 then section("Quartermaster") end
    for _, v in ipairs(vendors) do placeRow(v.npc, "Merchant's Favor") end
    section("One craft")
    local items = {}
    for item in pairs(rec.mats) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do
        local f = get("item")
        local n, e = rec.mats[item], lookup(item)
        f.item, f.source = item, ns.Describe.PriceSource(e)
        f.icon:SetTexture(UI.ItemIcon(item))
        f.name:SetText(("%d %s"):format(n, ns.Describe.ItemName(item)))
        f.sub:SetText(("you have %d; %s"):format(state.owned[item] or 0, ns.Describe.PriceSource(e)))
        UI.SetColor(f.sub, C.muted)
        f.cost:SetText(e and ns.Money(e.unit * n) or (hex(C.bad) .. "?|r"))
        place(f, 2)
    end
    if step.canMake then line(("Your bags allow %d crafts now."):format(step.canMake), C.good) end
end

-- A recipe's notes: how it's learned isn't confirmed in Forever yet, reputation, specialization.
local function recipeNotes(rec, way)
    local why = ns.Describe.Unconfirmed(rec, way)
    if why then line(why, C.warn) end
    if rec.rep then
        line(("The plan needs %s with %s."):format(STANDING[rec.rep.standing], prof.factions[rec.rep.faction]), C.muted)
    end
    if rec.spec then line(("Only for %s."):format(prof.specs[rec.spec]), C.muted) end
end

local function craftDetail(step)
    local rec = prof.recipes[step.recipe]
    local state = ladder.state
    headline(recipeIcon(rec), rec.name, STEP_COLOR[step.color] or C.text,
        ("Skill %d - %d, about %d crafts, %s%s"):format(step.from, step.to, math.ceil(step.crafts),
            step.missing and (hex(C.bad) .. "some prices missing|r") or ns.Money(step.cost),
            step.back and (", " .. ns.Money(step.back) .. " back") or ""),
        colorsText(rec.colors))
    if step.fromBags then -- first thing: the row's bag icon says only this
        line(("%s %s what you already have: %d crafts%s."):format(BAG_ICON, Verbs(), step.canCook > 0 and step.canCook
            or step.haveMain, step.matCost > 0 and ", plus a few vendor ingredients" or ", nothing to buy"), C.good)
    elseif step.canCook > 0 then
        line(("You can %s %d now with what you have."):format(prof.verb, step.canCook), C.good)
    elseif step.haveMain > 0 then
        line(("You have the main ingredients for %d; the rest is sold by vendors."):format(step.haveMain), C.good)
    end
    craftBar(step, rec)
    learnSection(step, rec)
    recipeNotes(rec, step.learn)
    if step.options[1] then pickedNote(step, "The cheapest here is " .. step.options[1].name .. ".") end -- a tool: none

    if step.late then
        local n, example, what = toolUsers(step.tool)
        line(("Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a" ..
            " cooldown, or learned at 300): make it once you're done."):format(what, n, example), C.warn)
    elseif step.tool then
        local n = toolUsers(step.tool)
        line(("A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."):format(
            n, prof.name, step.to > step.from and "" or " (it gives no skill point any more)"), C.good)
    end
    oneCraft(step, rec)

    if step.keep then
        section("Keep for later") -- before buying: what not to sell
        local kept = {}
        for item in pairs(step.keep) do kept[#kept + 1] = item end
        table.sort(kept)
        for _, item in ipairs(kept) do
            local k = step.keep[item]
            line(("Keep %d %s: the steps at %d - %d use them."):format(math.floor(k.n + 0.5), ns.Describe.ItemName(item),
                k.from, k.to), C.good)
        end
    end

    -- the whole step: what to buy (or make) and what all it makes sell for
    section(("Batch: %s"):format(step.missing and "?" or ns.Money(step.matCost)))
    local items = {}
    for item in pairs(step.buy) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    local made = math.floor(step.crafts * (rec.yield or 1) + 0.5)
    sellLines(rec, made, made .. " sell for ")
    line("Craft counts are estimates: skill-ups are luck once a recipe is yellow.", C.dim)

    if step.sale then
        local sale = step.sale
        section(step.keep and "Sell the rest" or "Sell what you make")
        if sale.ah >= 0.5 then
            line(("%d at the auction house, about %s each after its cut."):format(math.floor(sale.ah + 0.5),
                ns.Money(sale.ahEach)), C.text)
        end
        if sale.vendor >= 0.5 then
            line(("%d to a vendor, %s each."):format(math.floor(sale.vendor + 0.5), ns.Money(sale.vendorEach)), C.text)
        end
        local net = step.cost - sale.total
        line(("About %s back, so this step %s %s."):format(ns.Money(sale.total), net < 0 and "earns" or "costs",
            ns.Money(math.abs(net))), net < 0 and C.good or C.text)
        line(ladder.mode == "skill" and "Skill counts only what vendors pay: that money is sure. Skill + Gold counts" ..
            " the auction house too." or "The auction house counts only when it pays 1.5 times a vendor and 5 or more" ..
            " are listed, and for at most a quarter of what's listed.", C.dim)
    end

    if step.tool then return end
    section((prof.kind == "mining" and ("Or " .. gather().verb:lower() .. ", from %d") or "Recipes you could use from %d"):format(
        step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
    if #step.options <= 1 then line("No other recipe is open to you here.", C.muted) end
end

-- Gold: one recipe, one craft: what to buy (or make), what selling it brings, what's left.
local function profitDetail(step)
    local rec = prof.recipes[step.recipe]
    local sale = step.sale
    headline(UI.ItemIcon(rec.makes), rec.name, step.color ~= "grey" and STEP_COLOR[step.color] or C.text,
        ("One craft%s costs about %s and sells for about %s: %s+%s|r"):format(
            step.made > 1 and (" (makes " .. step.made .. ")") or "", ns.Money(step.cost), ns.Money(sale.total),
            hex(C.good), ns.Money(step.profit)),
        step.vendor and "Sold to a vendor: vendors buy any number." or
            ("%d listed at the auction house now: sell a few at a time."):format(step.listed))
    learnSection(step, rec)
    if step.payback then line(("Learning it pays back after %d crafts."):format(step.payback), C.good) end
    recipeNotes(rec, step.learn)
    if step.cooldown then
        line(("Once in %s: the recipe has a cooldown."):format(wait(step.cooldown)), C.warn)
    end

    oneCraft(step, rec)
    local items, have = {}, {}
    for item in pairs(rec.mats) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do
        local n = ladder.state.owned[item] or 0
        if n > 0 then have[#have + 1] = ("%d %s"):format(n, ns.Describe.ItemName(item)) end
    end
    if #have > 0 then
        line(("You have %s: counted at their price too, since you could sell them."):format(table.concat(have, ", ")),
            C.muted)
    end
    line(step.vendor and "Profit: what a vendor pays, less the ingredients at today's prices. How many you can make," ..
        " the auction house's ingredients decide." or "Profit: at the lowest listing after the auction house's cut," ..
        " with 5 or more listed; it counts only when it pays 1.5 times what a vendor does. How many sell, the auction" ..
        " house doesn't say. Prices change: look again before buying.", C.dim)
end

-- Food: one dish for your class: what eating it raises, the level it asks, its recipe, what one costs to cook or buy.
local function foodDetail(step)
    local rec, state = prof.recipes[step.recipe], ladder.state
    headline(UI.ItemIcon(rec.makes), rec.name, step.later and C.muted or C.gold, ns.Describe.Buff(rec.buff) .. " (Well Fed)",
        step.later and (hex(C.bad) .. ("Needs level %d; you're %d."):format(step.eat, state.level) .. "|r")
            or step.eat > 1 and ("Level %d: you can eat it."):format(step.eat) or "Any level can eat it.")
    if step.learn then
        learnSection(step, rec)
    else
        section("Learn it")
        line(rec.item and "Nobody sells its recipe now: look for it at the auction house."
            or "No way to learn it for you now (a holiday's, or the other side's).", C.bad)
    end
    if step.needSkill then
        line(("Learned at %s %d; you have %d."):format(prof.name, step.needSkill, state.skill), C.bad)
    end
    oneCraft(step, rec)
    section("Or buy it")
    line(step.ah and ("One at the auction house: %s."):format(ns.Money(step.ah))
        or "None listed at the auction house now.", C.text)
    line("What it raises is read from the game's files, not checked in game yet.", C.dim)
end

-- Lockpicking and Poisons: the class quests for your race (or side), with their givers' pins.
local function chainSection()
    local race = UnitRace and select(2, UnitRace("player"))
    local chain = prof.chains[race] or prof.chains[ladder.state.faction]
    section(prof.chainTitle)
    for i, q in ipairs(chain) do
        local name, quest = ns.Describe.Quest(q)
        line(("%d. %s"):format(i, name), C.text)
        if quest and quest.giver then placeRow(quest.giver, "quest giver") end
    end
    line(prof.chainNote, C.dim)
end

local function rankDetail(step)
    local rank = step.rank
    if rank.how == "level" then
        headline(prof.icon, "Reach level " .. rank.charLevel, step.needLevel and C.bad or C.gold,
            ("At skill %d. Your cap is your level x 5: %d at level %d."):format(step.from, rank.cap, rank.charLevel),
            step.needLevel and (hex(C.bad) .. "You're level " .. ladder.state.level .. ".|r")
                or "Your level allows it already.")
        line("Lockpicking can't go past your level x 5: level up before you go on.", C.muted)
        return
    end
    headline(rank.item and UI.ItemIcon(rank.item) or RANK_ICON[rank.how] or prof.icon,
        "Learn " .. rank.name .. (prof.levelCaps and "" or (" " .. prof.name)), C.gold,
        ("At skill %d, raises your cap to %d. %s"):format(step.from, rank.cap, ns.Describe.Price(step.cost, step.guess)),
        step.needLevel and (hex(C.bad) .. "Needs character level " .. step.needLevel .. ".|r") or "")
    section("How")
    if rank.how == "trainer" and rank.trainers then
        line(("Only these trainers teach it%s:"):format(rank.cost and (", for " .. ns.Money(rank.cost)) or ""), C.text)
        for _, npc in ipairs(rank.trainers) do
            local n = prof.npcs[npc]
            if n and n.faction:find(ladder.state.faction, 1, true) then placeRow(npc, "trainer") end
        end
    elseif rank.how == "trainer" then
        line("Any " .. (prof.trainer or prof.name) .. " trainer teaches it" .. (rank.cost and (" for " ..
            ns.Money(rank.cost)) or "") .. ".", C.text)
        if rank.note then line(rank.note, C.muted) end
    elseif rank.how == "book" then
        local real = realPrice(rank.item)
        line(("Buy the %s and read it:"):format(ns.Describe.ItemName(rank.item)), C.text)
        for _, v in ipairs(rank.vendors or {}) do
            if v.faction:find(ladder.state.faction, 1, true) then
                placeRow(v.npc, ns.Describe.Price(real or v.cost, not real and v.costGuess))
            end
        end
    elseif rank.how == "quest" then
        local name, q = ns.Describe.Quest(step.quest)
        if step.startQuest then
            local startName, start = ns.Describe.Quest(step.startQuest)
            line("1. Take the quest " .. startName .. ":", C.text)
            if start and start.giver then placeRow(start.giver, "start") end
            line("2. Bring the ingredients below to " .. (q and q.giverName or "the quest giver") ..
                " for " .. name .. ":", C.text)
            if q and q.giver then placeRow(q.giver, "hand in") end
        else
            line(("Do the quest %s for %s:"):format(name, q and q.giverName or "the quest giver"), C.text)
            if q and q.giver then placeRow(q.giver, "quest giver") end
        end
        if rank.note then line(rank.note, C.muted) end
    end
    if step.buy then
        section("What to bring")
        local items = {}
        for item in pairs(step.buy) do items[#items + 1] = item end
        table.sort(items)
        for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    end
    if prof.chains then chainSection() end
    if rank.fish then
        section("Fish to catch")
        for _, item in ipairs(rank.fish) do
            local where = prof.questFish[item]
            line(("%s: %s, %s (fish bite from %d)"):format(ns.Describe.ItemName(item), where.where,
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
        p.seen and "seen by GatherMate2" or (p.count == 1 and "place known" or "places known")))
    local parts = {}
    for item, share in pairs(pool.fish) do
        if share >= 0.1 then parts[#parts + 1] = ("%s %d%%"):format(ns.Describe.ItemName(item), share * 100 + 0.5) end
    end
    table.sort(parts)
    f.sub:SetText(table.concat(parts, ", "))
    UI.SetColor(f.sub, C.muted)
    f.cost:SetText(ns.Money(worth) .. hex(C.muted) .. " a catch|r")
    f.source = ("%d - %d catches before it's gone"):format(pool.catches[1], pool.catches[2])
    place(f, 2)
end

local function fishDetail(step)
    local zone = prof.zones[step.zone]
    local landed = step.landed >= 1 and "No fish get away here." or
        ("About %d%% of casts land a fish here."):format(step.landed * 100)
    if step.hour then
        headline(UI.ItemIcon(zone.top), "Fish in " .. zone.name, step.landed >= 1 and C.text or C.warn,
            ("An hour at skill %d: about %d catches, %s each"):format(step.from, step.crafts, ns.Money(step.value)),
            landed .. (" An hour's catches are worth about %s%s."):format(ns.Money(step.perHour),
                step.lure and ", lures paid" or ""))
    else
        headline(UI.ItemIcon(zone.top), "Fish in " .. zone.name, step.landed >= 1 and C.text or C.warn,
            ("Skill %d - %d, about %d catches (%s), %s"):format(step.from, step.to, math.ceil(step.crafts),
                duration(ns.Fishing.Minutes(step.casts)),
                step.missing and (hex(C.bad) .. "some prices missing|r") or ns.Money(step.cost)),
            landed .. (" Catches worth about %s (%s an hour)."):format(ns.Money(step.earn), ns.Money(step.perHour)))
        pickedNote(step, "Craft Ladder's choice here is " .. step.options[1].name .. ".")
    end
    if step.dangerous then
        line(("Its creatures are level %d - %d."):format(zone.levels[1], zone.levels[2]), C.warn)
    end

    section("Bring")
    local items = {}
    for item in pairs(step.buy) do items[#items + 1] = item end
    table.sort(items)
    for _, item in ipairs(items) do itemRow(item, step.buy[item]) end
    if step.lure then
        line(("Put %s on your pole: +%d fishing for %d minutes, so no fish get away."):format(
            ns.Describe.ItemName(step.lure), prof.gear.lures[step.lure], prof.gear.lureMinutes), C.muted)
        line("Fishing supplies vendors sell lures, in every capital.", C.dim)
    else
        line("No lure needed: your skill keeps the fish from getting away.", C.good)
    end

    section("What you catch here")
    local uses = cookingFish()
    local fish = {}
    for item, share in pairs(zone.fish) do fish[#fish + 1] = { item = item, share = share } end
    table.sort(fish, function(a, b) return a.share > b.share end)
    for i, f in ipairs(fish) do
        if i > 6 then break end
        fishRow(f.item, f.share, uses[f.item])
    end

    section("Fishing pools here")
    local z = ladder.zones and ladder.zones[step.zone]
    if z and z.pools then
        local list = {}
        for entry, p in pairs(z.pools) do list[#list + 1] = { entry = entry, p = p } end
        table.sort(list, function(a, b) return a.p.count > b.p.count end)
        for _, x in ipairs(list) do poolRow(x.entry, x.p) end
        line(("Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes" ..
            " a catch worth %s on average (%s in open water)."):format(ns.Money(step.value), ns.Money(z.open)), C.dim)
    else
        line("No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them.", C.dim)
    end
    local rate, log = ns.Fishing.Rate()
    if log and log.catches >= 50 then
        line(("Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."):format(
            log.catches, rate * 100 + 0.5), C.dim)
    else
        line(("Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
            " counted 50 of your catches (%d so far)."):format(log and log.catches or 0), C.dim)
    end
    line("Zones and their fish come from Classic's world: Forever may differ.", C.dim)
    if step.hour then return end

    section(("Other zones from %d"):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
    if #step.options <= 1 then line("No other zone is open to you here.", C.muted) end
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
    f.sub:SetText(("about %d in the zone, %s %s each%s"):format(math.max(1, math.floor(n + 0.5)),
        ore % 1 == 0 and ore or ("%.1f"):format(ore), ns.Describe.ItemName(node.item),
        worth and (", worth " .. ns.Money(worth)) or ""))
    UI.SetColor(f.sub, C.muted)
    if skill < node.skill then
        f.cost:SetText(hex(C.bad) .. "needs " .. node.skill .. "|r")
    else
        local color = ns.Ladder.Color(node.colors, skill)
        f.cost:SetText(hex(STEP_COLOR[color]) .. color .. "|r")
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
    f.name:SetText(("%s  %slevel %d%s|r"):format(node.name, hex(high and C.bad or C.muted), node.level,
        node.recorded and ", seen skinned" or ""))
    local worth = step.worth[id]
    f.sub:SetText(("about %d in the zone, needs %d%s"):format(math.max(1, math.floor(n + 0.5)), node.skill,
        worth and (", " .. ns.Money(worth) .. " a skin") or ""))
    UI.SetColor(f.sub, C.muted)
    if step.from < node.skill then
        f.cost:SetText(hex(C.bad) .. "needs " .. node.skill .. "|r")
    else
        local color = ns.Ladder.Color(node.colors, step.from)
        f.cost:SetText(hex(STEP_COLOR[color]) .. color .. "|r")
    end
    f.source = colorsText(node.colors)
    place(f, 2)
end

local function skinDetail(step)
    local zone = prof.zones[step.zone]
    if step.hour then
        headline(UI.ItemIcon(prof.nodes[step.node].item), "Skin in " .. zone.name, step.dangerous and C.warn or C.text,
            ("An hour at skill %d: about %d creatures, %s each"):format(step.from, step.crafts, ns.Money(step.value)),
            ("An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."):format(
                ns.Money(step.perHour)))
    else
        headline(UI.ItemIcon(prof.nodes[step.node].item), "Skin in " .. zone.name, step.dangerous and C.warn or C.text,
            ("Skill %d - %d, about %d creatures%s"):format(step.from, step.to, math.ceil(step.crafts),
                step.cost > 0 and (", trainer " .. ns.Money(step.cost)) or ""),
            ladder.mode == "sell" and ("Worth about %s skinned (%s an hour)."):format(ns.Money(step.earn),
                ns.Money(step.perHour)) or "Skin every creature that still gives a point, of your level or below.")
        pickedNote(step, "Craft Ladder's choice here is " .. step.options[1].name .. ".")
    end
    if step.dangerous then line("Its creatures are well above your level.", C.warn) end

    section("Creatures to skin here")
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
            line(("and %d more"):format(#list - 12), C.muted)
            break
        end
        creatureRow(x.id, x.n, step)
    end
    line("Which creatures can be skinned and what one gives come from Classic; where they are and their levels from" ..
        " QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past 20), the" ..
        " colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts once you've" ..
        " skinned one.", C.dim)
    if ladder.mode ~= "skill" then
        line(("Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an" ..
            " hour here."):format(prof.nodeSeconds, step.crafts / (step.seconds / 3600) + 0.5), C.dim)
    end
    if step.hour then return end

    section(("Other zones, from %d"):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

local function mineDetail(step)
    local zone = prof.zones[step.zone]
    local g = gather()
    if step.hour then
        headline(UI.ItemIcon(prof.nodes[step.node].item), g.verb .. " in " .. zone.name,
            step.dangerous and C.warn or C.text,
            ("An hour at skill %d: about %d %s, %s each"):format(step.from, step.crafts, g.many, ns.Money(step.value)),
            ("An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."):format(
                ns.Money(step.perHour), g.one, zone.levels[1], zone.levels[2]))
    else
        headline(UI.ItemIcon(prof.nodes[step.node].item), g.verb .. " in " .. zone.name,
            step.dangerous and C.warn or C.text,
            ("Skill %d - %d, about %d %s%s"):format(step.from, step.to, math.ceil(step.crafts), g.many,
                step.cost > 0 and (", trainer " .. ns.Money(step.cost)) or ""),
            ladder.mode == "sell" and ("Worth about %s (%s an hour). Creatures level %d - %d."):format(
                ns.Money(step.earn), ns.Money(step.perHour), zone.levels[1], zone.levels[2])
            or ("Creatures level %d - %d. %s every %s that still gives a point."):format(zone.levels[1],
                zone.levels[2], g.verb, g.one))
        pickedNote(step, "Craft Ladder's choice here is " .. step.options[1].name .. ".")
    end
    if step.dangerous then line("Its creatures are well above your level.", C.warn) end

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
        line(("%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a" ..
            " place, from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
            " needs): Forever may differ."):format((g.one:gsub("^%l", string.upper))), C.dim)
        if ladder.mode ~= "skill" then
            line(("Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about" ..
                " %d an hour here."):format(g.one, step.crafts / (step.seconds / 3600) + 0.5), C.dim)
        end
        if step.hour then return end
        section(("Other zones, from %d"):format(step.from))
        for _, o in ipairs(step.options) do optionRow(step, o) end
        return
    end

    if not step.hour then section("Smelt on the way") end
    local smelts = {}
    for spell, n in pairs(step.bars) do smelts[#smelts + 1] = { spell = spell, n = n } end
    table.sort(smelts, function(a, b) return a.n > b.n end)
    for _, x in ipairs(smelts) do
        local fee = step.learns[x.spell]
        line(("%s: about %d bars%s"):format(prof.recipes[x.spell].name, math.ceil(x.n),
            fee and (", learn it from a Mining trainer for " .. ns.Money(fee)) or ""), C.text)
    end
    if #smelts == 0 and not step.hour then line("Nothing you mine here still gives points when smelted.", C.muted) end

    section("Sell ore or bars")
    local ores = {}
    for ore, d in pairs(step.sell) do ores[#ores + 1] = { ore = ore, d = d } end
    table.sort(ores, function(a, b) return a.ore < b.ore end)
    local alloys = {}
    for _, x in ipairs(ores) do
        local d, name = x.d, ns.Describe.ItemName(x.ore)
        if not d.bars then
            line(("%s: %s each. Smelting it needs more skill."):format(name, ns.Money(d.ore)), C.text)
        else
            local barName = ns.Describe.ItemName(prof.recipes[d.recipe].makes)
            local best, advice = d.ore, "sell the ore, smelt it only for the skill-ups"
            if d.bars > best then best, advice = d.bars, "smelt it and sell the bars" end
            local alloyText = ""
            if d.alloy then
                local alloy = prof.recipes[d.alloyRecipe]
                alloys[d.alloyRecipe] = alloy
                alloyText = (", %s as %s"):format(ns.Money(d.alloy), ns.Describe.ItemName(alloy.makes))
                if d.alloy > best then
                    best, advice = d.alloy, ("make %s and sell it"):format(ns.Describe.ItemName(alloy.makes))
                end
            end
            line(("%s: %s as ore, %s as %s%s - %s."):format(name, ns.Money(d.ore), ns.Money(d.bars), barName, alloyText,
                advice), best > d.ore and C.good or C.text)
        end
    end
    for _, alloy in pairs(alloys) do
        local mats = {}
        for item, n in pairs(alloy.mats) do mats[#mats + 1] = ("%d %s"):format(n, ns.Describe.ItemName(item)) end
        table.sort(mats)
        line(("%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer" ..
            " one allows."):format(alloy.name, table.concat(mats, " and "), alloy.count, ns.Describe.ItemName(alloy.makes)),
            C.dim)
    end
    if #ores == 0 then line("Nothing mined here can be smelted.", C.muted) end
    line("Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays.", C.dim)
    if not step.hour then
        line("Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes.",
            C.dim)
    end
    line("Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node needs):" ..
        " Forever may differ.", C.dim)
    if ladder.mode ~= "skill" then
        line(("Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
            " about %d nodes an hour here."):format(step.crafts / (step.seconds / 3600) + 0.5), C.dim)
    end
    if step.hour then return end

    section(("Other zones, or smelting, from %d"):format(step.from))
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
    if skill < need then return hex(C.bad) .. "needs " .. need .. "|r" end
    local color = ns.Ladder.Color(colors, skill)
    return hex(STEP_COLOR[color]) .. color .. "|r"
end

-- A kind of lock in a zone: how many, the skill it needs, its colour for you at the step's start.
local function lockRow(id, n, step)
    local node = prof.nodes[id]
    local f = get("item")
    f.item = false -- a chest has no item: its icon is a box's look-alike
    f.icon:SetTexture(UI.ItemIcon(node.item))
    f.name:SetText(node.name)
    f.sub:SetText((prof.zones[step.zone].dungeon and "%d a run, needs %d" or "about %d in the zone, needs %d"):format(
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
    if rec.source ~= "pickpocket" then return BOX_FROM[rec.source] or "" end
    return rec.levels and ("Pick Pocket humanoids of level %d - %d."):format(rec.levels[1], rec.levels[2])
        or "Pick Pocket humanoids."
end

local function lockDetail(step)
    local zone = prof.zones[step.zone]
    local first = step.mix and step.mix[1]
    headline(UI.ItemIcon(first and first.item or prof.nodes[step.node].item), "Pick locks in " .. zone.name,
        step.dangerous and C.warn or C.text,
        ("Skill %d - %d, about %d locks"):format(step.from, step.to, math.ceil(step.crafts)),
        ("Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one more" ..
            " once it's back."):format(zone.levels[1], zone.levels[2]))
    if step.options[1] then pickedNote(step, "Craft Ladder's choice here is " .. step.options[1].name .. ".") end
    if step.dangerous then line("Its creatures are well above your level.", C.warn) end
    if zone.dungeon then
        section("The door round")
        line("1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes).", C.text)
        line("2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
            " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull.", C.text)
        line("3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
            " an hour.", C.text)
        line("The round is zockify's Forever guide's: about 4 doors a run.", C.dim)
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
        section("Where")
        local named = {} -- one place per name: GatherMate2 doesn't tell a name's kinds apart
        for _, x in ipairs(list) do
            local node, s = prof.nodes[x.id], zone.spots[x.id]
            if s and not named[node.name] then
                named[node.name] = true
                spotRow(zone.map, s[1], s[2], ("Most %ss are around here"):format(node.name))
            end
        end
    end
    line("Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours (yellow" ..
        " 25, green 50, grey 100 above it), are Classic's: Forever may differ.", C.dim)

    section(("Other zones, or boxes, from %d"):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

local function boxDetail(step)
    local rec = prof.recipes[step.recipe]
    local box = next(rec.mats)
    headline(UI.ItemIcon(box), "Pick " .. rec.name, STEP_COLOR[step.color] or C.text,
        ("Skill %d - %d, about %d boxes, %s"):format(step.from, step.to, math.ceil(step.crafts),
            step.missing and (hex(C.bad) .. "some prices missing|r") or ns.Money(step.cost)),
        colorsText(rec.colors))
    if step.options[1] then pickedNote(step, "Craft Ladder's choice here is " .. step.options[1].name .. ".") end
    if step.fromBags then
        line(("Pick the ones in your bags: you have %d."):format(ladder.state.owned[box] or 0), C.good)
    end
    line(boxFrom(rec), C.muted)
    section(("Boxes to buy: %s"):format(step.missing and "?" or ns.Money(step.matCost)))
    for item, b in pairs(step.buy) do itemRow(item, b) end
    line("A box gives one chance at a point, and what's inside is yours.", C.dim)

    section(("Or pick locks in a zone, from %d"):format(step.from))
    for _, o in ipairs(step.options) do optionRow(step, o) end
end

-- Every lock a rogue picks, by skill, and its colour for you; how to start.
local function locksDetail()
    local state = ladder.state
    local skill = state.skill
    headline(prof.icon, "All locks", C.gold, ("Every lock a rogue picks, by the skill it needs; its colour at your %d.")
        :format(skill), "Orange always gives a point, yellow mostly, green sometimes, grey never.")

    section("Chests in the world")
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

    section("Boxes from your bags")
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
        f.name:SetText(("%s  %s%d|r"):format(x.rec.name, hex(C.muted), x.rec.learn))
        f.sub:SetText(boxFrom(x.rec) .. (have > 0 and (" " .. hex(C.good) .. "You have " .. have .. ".|r") or "")
            .. (e and e.source ~= "vendor" and (" " .. ns.Money(e.unit) .. " at the auction house.") or ""))
        UI.SetColor(f.sub, C.muted)
        f.cost:SetText(lockColor(x.rec.colors, x.rec.learn, skill))
        f.source = colorsText(x.rec.colors)
        place(f, 2)
    end

    section("Dungeon doors")
    for _, d in ipairs(prof.doors) do
        line(("%s: %d locked doors, from %d (%s)."):format(d.dungeon, d.doors, d.skill,
            lockColor({ d.skill, d.skill + 25, d.skill + 50, d.skill + 100 }, d.skill, skill)), C.text)
    end

    section("Getting started")
    line(("Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue supplies" ..
        " vendors, 15s). Your cap is your level x 5."):format(ns.Money(prof.learnRank and prof.learnRank.cost
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
    y = 0
    local state = ladder.state
    local step = ladder.steps[selected]
    d.head.step = step
    if step and step.kind == "favor" then
        favorDetail(step)
    elseif selected == 0 and prof.doors then
        locksDetail()
    elseif state.maxSkill == 0 and not prof.levelCaps then -- Lockpicking's ladder starts with learning Pick Lock
        headline(prof.icon, "No " .. prof.name .. " yet", C.gold,
            ("Any %s trainer teaches Apprentice %s."):format(prof.name, prof.name), "")
    elseif not step and ladder.mode == "gold" and prof.resale then
        headline(prof.icon, "Nothing earns now", C.gold,
            "Nothing you can make sells for more than it costs at today's prices.", "")
    elseif not step and ladder.mode == "gold" and prof.kind then
        headline(prof.icon, "Nothing earns now", C.gold,
            "Nothing you can get here has a price yet: Craft Ladder needs auction house prices.", "")
    elseif not step then
        headline(prof.icon, "Nothing to do here", C.gold,
            state.skill >= 300 and ("You've reached 300 %s."):format(prof.name) or "No recipe found for your skill.", "")
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
    else
        craftDetail(step)
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
    pools.item = UI.Pool(makeItem)
    pools.option = UI.Pool(makeOption)
end

-- Draws the card of the step picked in the ladder the window shows.
function Cards.Render(f, l, lk, p, sel)
    frame, ladder, lookup, prof, selected = f, l, lk, p, sel
    renderDetail()
end

Cards.PaintCraft, Cards.CraftClick = paintCraft, craftClick
