-- Craft Ladder: the main window. It's built the first time it opens. It keeps the ladders it has calculated (each
-- profession, each mode) and draws one again while nothing it depends on has changed (skill, level, recipes, prices,
-- that profession's items in the bags), so switching back and opening again cost nothing.
--   header:   title, your skill in the profession shown (the ladder always goes to 300)
--   menu:     the character's professions (main, secondary, a rogue's class skills), each with its skill (UI/Menu.lua)
--   bar:      1-300 with the rank caps, the skill you have (gold), the ladder's steps and "you are here"
--   left:     the ladder, one line per step (click one to see it); or the recipes the supply camps' quartermasters
--             sell for Merchant's Favor (the bar over the list switches)
--   right:    the step you picked: how to learn it, what to buy, the other recipes you could use there (UI/Cards.lua)
--   footer:   total cost, Merchant's Favor recipes on/off, how old the prices are
local _, ns = ...
local UI = ns.UI
local C = UI.C

local Window = {}
ns.Window = Window

local W, H = 1008, 560 -- the smallest the window gets; drag its corner to make it bigger
local MAX_W, MAX_H = 1600, 1200
local MIN_SCALE, MAX_SCALE = 1, 1.5 -- Ctrl + mouse wheel
local LIST_W = 330
local MENU_W = 150
local LEFT = 12 + MENU_W + 8 -- where the skill bar, the ladder and the footer start, right of the menu
local DETAIL_CW = W - LEFT - LIST_W - 8 - 12 - 22 - 8 -- width of the step details' content at the smallest size
local RANK_NAMES = { { 0, 75, "Apprentice" }, { 75, 150, "Journeyman" }, { 150, 225, "Expert" }, { 225, 300, "Artisan" } }
local MODE_TIPS = { -- the mode switch by profession: Skill | Skill + Gold | Gold
    lockpicking = {}, -- Skill only
    fishing = { skill = "Fish where nothing gets away, spending as little as possible on lures.",
                sell = "Level up where nothing gets away and the catch earns the most an hour, fishing pools and" ..
                    " chests counted.",
                gold = "No ladder: the zones where an hour of fishing earns the most at your skill now, lures paid," ..
                    " fishing pools and chests counted." },
    skinning = { skill = "Skin where you reach the next points with the fewest creatures, the ones that still give a" ..
                     " point, of your level or below.",
                 sell = "Level up where every creature you can skin is worth the most an hour (leather, hides," ..
                     " scales). Grey ones are skinned too, so it takes more of them.",
                 gold = "No ladder: the zones where an hour of skinning earns the most at your skill now, every" ..
                     " creature you can skin counted, grey ones too." },
    herbalism = { skill = "Gather where you reach the next points with the least riding, the herbs that still give a" ..
                      " point.",
                  sell = "Level up where every herb you can gather earns the most an hour. Grey ones are gathered" ..
                      " too, so it takes more herbs.",
                  gold = "No ladder: the zones where an hour of gathering earns the most at your skill now, every herb" ..
                      " you can gather counted, grey ones too." },
    mining = { skill = "Mine where you reach the next points with the least riding, the nodes that still give a point.",
               sell = "Level up where every node you can mine earns the most an hour (ore or bars, whichever sells" ..
                   " for more, stone and gems counted). Grey nodes are mined too, so it takes more nodes.",
               gold = "No ladder: the zones where an hour of mining earns the most at your skill now (ore or bars," ..
                   " whichever sells for more, stone and gems counted), grey nodes too." },
    craft = { skill = "Level up for the least gold. What you make is sold only to vendors: that money is sure.",
              sell = "Level up counting what the auction house pays for what you make (a quarter of what's listed at" ..
                  " most): cheaper if it sells, dearer if it doesn't.",
              gold = "What you can make now that earns the most per craft, ingredients at their price (the ones you" ..
                  " have too). How many sell the auction house doesn't say: you see how many are listed." },
}
local FOOD_TIP = "No ladder: the dishes worth eating for your class, a group per role, by what eating one raises" ..
    " (Well Fed). The ones you can eat now first, the best first; grey ones need a higher level."
local STEP_COLOR = { orange = C.orange, yellow = C.yellow, green = C.green, grey = C.grey }
local BAG_ICON = "|TInterface\\Icons\\INV_Misc_Bag_08:14:14|t" -- a step made from what you have
-- Where a step's recipe is learned, as the game shows that NPC in its dialogs (a recipe in your bags: its scroll);
-- none once it's known or every character starts with it.
local LEARN_ICONS = {
    trainer = "Interface\\GossipFrame\\TrainerGossipIcon", vendor = "Interface\\GossipFrame\\VendorGossipIcon",
    ah = "Interface\\GossipFrame\\auctioneerGossipIcon", quest = "Interface\\GossipFrame\\AvailableQuestIcon",
    owned = "Interface\\Icons\\INV_Scroll_03",
}
local function learnIcon(learn)
    local path = learn and LEARN_ICONS[learn.kind]
    return path and (" |T" .. path .. ":14:14|t") or ""
end

local frame
local ladder, lookup
local prof -- the profession shown (its data)
local selected = 1
local shownProf -- the profession the list showed last (nil: the window was just opened)
-- The ladders calculated: [profession key .. ":" .. mode] = { ladder, lookup, version, bags }. version counts the
-- changes that matter to every ladder (skill, level, recipes, prices, a setting); bags counts the bag changes, which
-- matter to a ladder only when its profession's items changed (checked when it's drawn again).
local cache = {}
local version, bagsVersion = 0, 0

local function hex(c) return UI.Hex(c) end

-- "crafts" (Lockpicking: "picks", of boxes from the bags)
local function craftsWord() return prof.craftWord or "crafts" end
local LOCKS = { kind = "locks" } -- Lockpicking's first row: every lock, by skill

-- "4 days", "12 hours": how long a recipe with a cooldown waits between crafts.
local function wait(seconds)
    local hours = math.floor(seconds / 3600 + 0.5)
    return hours >= 48 and ("%d days"):format(math.floor(hours / 24 + 0.5)) or ("%d hours"):format(hours)
end

-- A recipe's icon: the item it makes, or for an enchantment its spell's.
local function recipeIcon(rec)
    return rec.makes and UI.ItemIcon(rec.makes) or rec.icon or prof.icon
end

-- The recipes that need a tool kind: how many, one of them, and what they are ("transmutes" when some transmute).
local function toolUsers(kind)
    local n, example, transmutes = 0, nil, 0
    for _, r in pairs(prof.recipes) do
        for _, k in ipairs(r.tools or {}) do
            if k == kind then
                n = n + 1
                example = (not example or r.name < example) and r.name or example
                if r.name:find("^Transmute") then transmutes = transmutes + 1 end
            end
        end
    end
    return n, example, transmutes == 0 and "recipes past leveling" or transmutes == n and "transmutes"
        or "transmutes and more"
end

-- What Mining's ladder gathers in the profession shown: { verb, one, many, here } ("Mine", "node", ... or Skinning's).
local function gather()
    return prof.gather or { verb = "Mine", one = "node", many = "nodes", here = "Nodes here" }
end

---------------------------------------------------------------------------------------------------------------
-- Picking a recipe for a step, and the target
---------------------------------------------------------------------------------------------------------------

local function backToCheapest(step)
    local saved = ns.Player.Prof(prof)
    local keep = {}
    for _, c in ipairs(saved.choices or {}) do
        if c.to <= step.from or c.from >= step.to then keep[#keep + 1] = c end
    end
    saved.choices = keep
    Window.Refresh()
end

---------------------------------------------------------------------------------------------------------------
-- The ladder list (left)
---------------------------------------------------------------------------------------------------------------

local rowPool
local renderDetail

-- The item a step is about: the one it makes, the book a rank-up needs, the fish caught most where you fish, or the
-- ore of the nodes that give the most points where you mine.
local function stepItem(step)
    if not step then return end
    if step.kind == "rank" then return step.rank.item end
    if step.kind == "fish" then return prof.zones[step.zone].top end
    if step.kind == "locks" or step.kind == "mine" and prof.nodes[step.node].lock then return end -- a chest: no item
    if step.kind == "mine" then return prof.nodes[step.node].item end
    local rec = prof.recipes[step.recipe]
    return rec.makes or prof.doors and next(rec.mats) -- a box you pick: the box
end

-- "~40 min", "~6.5 h"
local function duration(minutes)
    if minutes < 90 then return ("~%d min"):format(math.max(1, math.floor(minutes + 0.5))) end
    return ("~%.1f h"):format(minutes / 60)
end

-- "44 Copper Bar, 19 Tin Bar": what a mining step (or a zone option) smelts on the way, most first.
local function barsText(bars)
    local list = {}
    for spell, n in pairs(bars) do list[#list + 1] = { spell = spell, n = n } end
    table.sort(list, function(a, b) return a.n > b.n end)
    for i, x in ipairs(list) do
        list[i] = ("%d %s"):format(math.ceil(x.n), ns.Describe.ItemName(prof.recipes[x.spell].makes))
    end
    return #list > 0 and table.concat(list, ", ") or "nothing"
end

-- What a gathering step gives (step.mix): "Iron Ore, Gold Ore" (what gives the points), or with shares for Gold
-- (what earns): "Light Leather 64%, Ruined Leather Scraps 34%".
local function mixText(step)
    local parts = {}
    for _, x in ipairs(step.mix or {}) do
        if #parts == (step.hour and 3 or 2) or x.share < 0.05 then break end
        parts[#parts + 1] = ns.Describe.ItemName(x.item) .. (step.hour and (" %d%%"):format(x.share * 100 + 0.5) or "")
    end
    return table.concat(parts, ", ")
end

-- The game's tooltip of the dish (or book), with the step under it.
local function stepTooltip(owner, step)
    if not step then return end
    if step.kind == "favor" then
        UI.ItemTooltip(owner, prof.recipes[step.recipe].makes, step.recipe)
        return
    end
    if step.kind == "locks" then
        UI.Tooltip(owner, { "All locks", "Every lock a rogue picks, by the skill it needs, and its colour for you." })
        return
    end
    if step.kind == "rank" and step.rank.how == "level" then
        UI.Tooltip(owner, { "Reach level " .. step.rank.charLevel, ("At %d your cap is the level x 5: %d at level %d.")
            :format(step.from, step.rank.cap, step.rank.charLevel) })
        return
    end
    if step.kind == "rank" then
        local lines = {
            { "Learn " .. step.rank.name, ("at %d, cap %d"):format(step.from, step.rank.cap) },
            { "Cost", ns.Describe.Price(step.cost, step.guess) },
        }
        if step.needLevel then lines[#lines + 1] = hex(C.bad) .. "Needs character level " .. step.needLevel .. "|r" end
        if step.rank.item then
            UI.ItemTooltip(owner, step.rank.item, nil, lines)
        else
            table.insert(lines, 1, "Learn " .. step.rank.name .. " " .. prof.name)
            UI.Tooltip(owner, lines)
        end
        return
    end
    if step.kind == "mine" then
        local g = gather()
        UI.Tooltip(owner, {
            g.verb .. " in " .. prof.zones[step.zone].name,
            { "Skill", ("%d - %d"):format(step.from, step.to) },
            { (g.many:gsub("^%l", string.upper)), "~" .. math.ceil(step.crafts) },
            next(prof.recipes) and { "Smelt on the way", barsText(step.bars) } or nil,
            { "Trainer", ns.Money(step.cost) },
        })
        return
    end
    if step.kind == "fish" then
        UI.Tooltip(owner, {
            "Fish in " .. prof.zones[step.zone].name,
            { "Skill", ("%d - %d"):format(step.from, step.to) },
            { "Catches", ("~%d (%s)"):format(math.ceil(step.crafts), duration(ns.Fishing.Minutes(step.casts))) },
            { "Lure", step.lure and ns.Describe.ItemName(step.lure) or "none" },
            { "Cost", step.missing and (hex(C.bad) .. "no price|r") or ns.Money(step.cost) },
        })
        return
    end
    local rec = prof.recipes[step.recipe]
    if step.kind == "food" then
        UI.ItemTooltip(owner, rec.makes, step.recipe, {
            { "Raises", ns.Describe.Buff(step.buff) },
            { "Cook one", step.cost and ns.Money(step.cost) or "no price" },
            { "Buy one", step.ah and ns.Money(step.ah) or "not listed" },
        })
        return
    end
    if step.kind == "profit" then
        UI.ItemTooltip(owner, rec.makes, step.recipe, {
            { "One craft", ns.Money(step.cost) .. (step.made > 1 and (", makes " .. step.made) or "") },
            { "Sells for", ns.Money(step.back) },
            { "Profit", hex(C.good) .. "+" .. ns.Money(step.profit) .. "|r" },
            { "Listed", step.listed },
        })
        return
    end
    UI.ItemTooltip(owner, rec.makes, step.recipe, {
        { "Skill", ("%d - %d, ~%d %s"):format(step.from, step.to, math.ceil(step.crafts), craftsWord()) },
        { "Cost", step.missing and (hex(C.bad) .. "no price|r") or ns.Money(step.cost) },
        { "Learn", ns.Describe.Learn(step.learn, prof) },
    })
end

-- A row's identity, saved per profession so the row you looked at stays picked when the window closes, you look at
-- another tab, or a recalculation moves it: its kind and recipe or zone (from the bags or not), or a rank's name,
-- and which of the ladder's steps like it it is ("craft:2545:bags#1").
local function stepKey(index)
    local function base(step)
        if step.kind == "rank" then return "rank:" .. step.rank.name end
        return step.kind .. ":" .. tostring(step.recipe or step.zone) .. (step.fromBags and ":bags" or "")
    end
    if index == 0 then return "locks" end
    local key, n = base(ladder.steps[index]), 0
    for i = 1, index do
        if base(ladder.steps[i]) == key then n = n + 1 end
    end
    return key .. "#" .. n
end

-- The row the profession's saved step is at now (0: Lockpicking's every-lock row), or nil.
local function savedRow()
    local key = ns.Player.Prof(prof).row
    if key == "locks" and prof.doors then return 0 end
    for i in ipairs(ladder.steps) do
        if stepKey(i) == key then return i end
    end
end

local function paintRow(row)
    if row.index == selected then
        row:SetPanelColors(C.hover, C.selected)
    elseif row:IsMouseOver() then
        row:SetPanelColors(C.hover, C.hover)
    else
        row:SetPanelColors(C.panel2, C.panel2)
    end
end

local function makeRow(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(LIST_W - 26, 42)
    UI.Panel(b, C.panel2, C.panel2, 6, -4)
    b.accent = b:CreateTexture(nil, "ARTWORK")
    b.accent:SetPoint("TOPLEFT", 1, -7)
    b.accent:SetPoint("BOTTOMLEFT", 1, 7)
    b.accent:SetWidth(3)
    b.accent:SetColorTexture(C.gold[1], C.gold[2], C.gold[3], 1)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(26, 26)
    b.icon:SetPoint("LEFT", 10, 0)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    b.name = UI.Label(b, 12)
    b.name:SetPoint("TOPLEFT", b.icon, "TOPRIGHT", 8, 1)
    b.name:SetWidth(LIST_W - 26 - 44 - 72)
    b.sub = UI.Label(b, 10, C.muted)
    b.sub:SetPoint("BOTTOMLEFT", b.icon, "BOTTOMRIGHT", 8, -1)
    b.sub:SetWidth(LIST_W - 26 - 44 - 72)
    b.cost = UI.Label(b, 11, C.text, nil, "RIGHT")
    b.cost:SetPoint("RIGHT", -10, 0)
    b:SetScript("OnEnter", function(self)
        paintRow(self)
        stepTooltip(self, self.step)
    end)
    b:SetScript("OnLeave", function(self)
        paintRow(self)
        UI.HideTooltip()
    end)
    b:SetScript("OnClick", function(self)
        if IsShiftKeyDown() then
            UI.LinkItem(stepItem(self.step))
            return
        end
        selected = self.index
        ns.Player.Prof(prof).row = stepKey(self.index)
        for _, r in ipairs(rowPool.used) do paintRow(r) end
        renderDetail()
    end)
    return b
end

-- A heading over a group of rows (Gold: what sells to a vendor, what sells at the auction house). One that folds shows
-- a + or - and opens or closes on a click.
local headPool
local function makeListHead(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(LIST_W - 26, 22)
    b.fold = b:CreateTexture(nil, "ARTWORK")
    b.fold:SetSize(14, 14)
    b.fold:SetPoint("LEFT", 4, 0)
    b.title = UI.Label(b, 11, C.gold)
    b.title:SetPoint("LEFT", 22, 0)
    b.count = UI.Label(b, 11, C.muted, nil, "RIGHT")
    b.count:SetPoint("RIGHT", -10, 0)
    b:SetScript("OnClick", function(self) if self.toggle then self.toggle() end end)
    b:SetScript("OnEnter", function(self) UI.Tooltip(self, self.tooltip) end)
    b:SetScript("OnLeave", function() UI.HideTooltip() end)
    return b
end

local RANK_ICON = { book = 133741, quest = 132049 } -- a book, a quest scroll (a trainer: the profession's icon)

-- The level an item asks to wear (or use) it, and whether it's worn; nil while the game hasn't loaded it (asked for:
-- it loads in a moment).
local function useLevel(item)
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    if not (item and getInfo) then return end
    local name, _, _, _, minLevel, _, _, _, equipLoc = getInfo(item)
    if not name then
        if C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(item) end
        return
    end
    return minLevel or 0, equipLoc ~= nil and equipLoc ~= ""
end

-- A Merchant's Favor recipe's line under its name (the auction house tab's too): the level to wear what it makes (red
-- above yours), then known, learn now, or the skill or level it waits for.
local function favorSub(step, rec, state)
    local wear = useLevel(rec.makes)
    return (wear and wear > 1 and ("%slvl %d|r - "):format(wear > state.level and hex(C.bad) or "", wear) or "")
        .. (step.status == "known" and (step.canMake > 0 and ("known, make %d now"):format(step.canMake) or "known")
            or step.status == "learn" and ("learn now (skill %d)"):format(rec.learn)
            or step.status == "skill" and ("skill %d (you %d)"):format(rec.learn, state.skill)
            or ("level %d (you %d)"):format(step.level, state.level))
end

-- A dish's colour in Food (the row's name, the card's title): its skill-up colour at your skill, as Gold's rows (grey,
-- no skill-up: white); red while your skill can't learn it yet.
local function foodColor(step, rec, skill)
    local color = ns.Ladder.Color(rec.colors, skill)
    return step.needSkill and C.bad or color ~= "grey" and STEP_COLOR[color] or C.text
end

local function fillRow(row, step, index)
    row.index, row.step = index, step
    row.icon:SetVertexColor(1, 1, 1) -- a pooled row may have been a red one
    row.accent:SetShown(index == 1)
    if step.kind == "locks" then
        row.icon:SetTexture(prof.icon)
        row.name:SetText("All locks")
        UI.SetColor(row.name, C.gold)
        row.sub:SetText("chests, boxes and doors by skill")
        row.cost:SetText("")
        paintRow(row)
        return
    elseif step.kind == "rank" and step.rank.how == "level" then
        row.icon:SetTexture(prof.icon)
        row.name:SetText("Reach level " .. step.rank.charLevel)
        UI.SetColor(row.name, step.needLevel and C.bad or C.gold)
        row.sub:SetText(("at %d, raises your cap to %d"):format(step.from, step.rank.cap))
    elseif step.kind == "rank" then
        row.icon:SetTexture(step.rank.item and UI.ItemIcon(step.rank.item) or RANK_ICON[step.rank.how] or prof.icon)
        row.name:SetText("Learn " .. step.rank.name)
        UI.SetColor(row.name, C.gold)
        row.sub:SetText(("at %d, raises your cap to %d%s"):format(step.from, step.rank.cap,
            step.needLevel and (" - " .. hex(C.bad) .. "needs level " .. step.needLevel .. "|r") or ""))
    elseif step.kind == "fish" then
        local zone = prof.zones[step.zone]
        row.icon:SetTexture(UI.ItemIcon(zone.top))
        row.name:SetText("Fish in " .. zone.name)
        UI.SetColor(row.name, step.landed >= 1 and C.text or C.warn)
        local extra = step.lure and (" - " .. ns.Describe.ItemName(step.lure)) or ""
        if step.chosenByYou then extra = extra .. " - " .. hex(C.gold) .. "your pick|r" end
        if step.hour then
            row.sub:SetText(("an hour: ~%d catches, %s each%s%s"):format(step.crafts, ns.Money(step.value), extra,
                step.dangerous and (" - " .. hex(C.bad) .. "creatures level " .. zone.levels[1] .. "+|r") or ""))
        else
            row.sub:SetText(("%d - %d, ~%d catches%s"):format(step.from, step.to, math.ceil(step.crafts), extra))
        end
    elseif step.kind == "favor" then
        local rec, state = prof.recipes[step.recipe], ladder.state
        local blocked = step.status == "skill" or step.status == "level" -- red, as the game shows what you can't use
        row.icon:SetTexture(recipeIcon(rec))
        if blocked then row.icon:SetVertexColor(1, 0.15, 0.15) end
        row.name:SetText(rec.name)
        UI.SetColor(row.name, step.status == "known" and C.good or step.status == "learn" and C.gold or C.bad)
        row.sub:SetText(favorSub(step, rec, state))
    elseif step.kind == "food" then
        local rec = prof.recipes[step.recipe]
        row.icon:SetTexture(UI.ItemIcon(rec.makes))
        row.name:SetText(rec.name)
        UI.SetColor(row.name, foodColor(step, rec, ladder.state.skill)) -- a dish for later says so in red: "lvl N"
        row.sub:SetText(("%s%s%s%s"):format(step.eat > 1 and ("%slvl %d|r - "):format(step.later and hex(C.bad) or "",
            step.eat) or "", ns.Describe.Buff(step.buff), learnIcon(step.learn),
            step.needSkill and (" - " .. hex(C.bad) .. "skill " .. step.needSkill .. "|r") or ""))
    elseif step.kind == "profit" then
        local rec = prof.recipes[step.recipe]
        row.icon:SetTexture(UI.ItemIcon(rec.makes))
        row.name:SetText(rec.name)
        UI.SetColor(row.name, step.color ~= "grey" and STEP_COLOR[step.color] or C.text) -- grey: no skill-up, white
        row.sub:SetText(("%s%s, %s%s%s%s"):format(step.made > 1 and ("makes " .. step.made .. ", ") or "",
            ns.Money(step.back / step.made) .. " each", step.vendor and "at a vendor" or (step.listed .. " listed"),
            learnIcon(step.learn), -- a recipe to learn first: its card says how
            step.cooldown and (" - " .. hex(C.warn) .. "once in " .. wait(step.cooldown) .. "|r") or "",
            ns.Describe.Unconfirmed(rec, step.learn) and (" - " .. hex(C.warn) .. "unconfirmed|r") or ""))
    elseif step.kind == "mine" then
        -- the item that gives the most points (Gold: earns the most), then what else counts
        row.icon:SetTexture(UI.ItemIcon(step.mix and step.mix[1] and step.mix[1].item or prof.nodes[step.node].item))
        row.name:SetText(gather().verb .. " in " .. prof.zones[step.zone].name)
        UI.SetColor(row.name, step.dangerous and C.warn or C.text)
        if step.hour then
            row.sub:SetText(mixText(step))
        else
            row.sub:SetText(("%d - %d%s: %s"):format(step.from, step.to,
                step.chosenByYou and (" " .. hex(C.gold) .. "your pick|r") or "", mixText(step)))
        end
    else
        local rec = prof.recipes[step.recipe]
        row.icon:SetTexture(recipeIcon(rec))
        row.name:SetText(rec.name)
        UI.SetColor(row.name, STEP_COLOR[step.color] or C.text)
        local way = learnIcon(step.learn) -- first, so a long line cuts off the words, not the icons
        local extra = way
        if step.fromBags then
            extra = extra .. " " .. BAG_ICON -- made from what you have: the card says so first thing
        elseif index == 1 and step.canCook > 0 then
            extra = extra .. " - " .. hex(C.good) .. step.canCook .. " now|r"
        end
        if step.keep then extra = extra .. " - " .. hex(C.good) .. "keep them|r" end
        if step.chosenByYou then extra = extra .. " - " .. hex(C.gold) .. "your pick|r" end
        if ns.Describe.Unconfirmed(rec, step.learn) then extra = extra .. " - " .. hex(C.warn) .. "unconfirmed|r" end
        if step.late then
            local _, _, what = toolUsers(step.tool)
            row.sub:SetText(("after %d%s, %sneeded for %s|r"):format(step.from, way, hex(C.warn), what))
        elseif step.tool then
            row.sub:SetText(("%s%s, %smake one and keep it|r"):format(step.to > step.from and
                ("%d - %d"):format(step.from, step.to) or ("at " .. step.from), way, hex(C.good)))
        else
            row.sub:SetText(("%d - %d, ~%d %s%s"):format(step.from, step.to, math.ceil(step.crafts), craftsWord(), extra))
        end
    end
    if (step.kind == "fish" or step.kind == "mine") and ladder.mode ~= "skill" then
        -- what the catches are worth, lures paid (less than nothing when the lures cost more); Gold: in an hour
        row.cost:SetText((step.earn >= 0 and (hex(C.good) .. "+|r") or "") .. ns.Money(step.earn))
    elseif step.kind == "mine" then -- Skill: how many (a trainer's fee is in the step's card)
        row.cost:SetText(("~%d %s"):format(math.ceil(step.crafts), gather().many))
    elseif step.kind == "favor" then
        row.cost:SetText(step.cost and (step.cost .. " favor") or (hex(C.muted) .. "? favor|r"))
    elseif step.kind == "food" then -- one dish, cooked from bought ingredients
        row.cost:SetText(step.cost and ns.Money(step.cost) or (hex(C.bad) .. "no price|r"))
    elseif step.kind == "fish" and step.cost == 0 and not step.missing then
        row.cost:SetText("") -- no lures to buy
    else
        local net = step.cost - (step.back or 0)
        row.cost:SetText(step.missing and (hex(C.bad) .. "no price|r")
            or (step.back and net < 0) and (hex(C.good) .. "+" .. ns.Money(-net) .. "|r") or ns.Money(net))
    end
    paintRow(row)
end

local function renderList()
    local list = frame.list
    rowPool:ReleaseAll()
    local notes = {}
    if ladder.state.maxSkill > 0 and next(prof.recipes) and not next(ns.Player.Prof(prof).known) then
        notes[#notes + 1] = ("Open your %s window once so Craft Ladder knows which recipes you have."):format(
            prof.window or prof.name)
    end
    if ladder.stuck == "no recipe" or ladder.stuck == "no zone" then
        notes[#notes + 1] = ("No %s found past %d with what Craft Ladder knows."):format(
            ladder.stuck == "no zone" and "zone" or "recipe",
            ladder.steps[#ladder.steps] and ladder.steps[#ladder.steps].to or ladder.from)
    end
    list.note:SetText(table.concat(notes, "\n"))
    list.note:SetShown(#notes > 0)
    -- the bar that switches to the Merchant's Favor recipes and back (a profession whose quartermaster sells some)
    local favorCount = ns.Favor.Count(prof)
    list.favor:SetShown(favorCount > 0)
    list.favor.label:SetText(ladder.favor and "Back to your ladder" or ("Merchant's Favor recipes (%d)"):format(favorCount))
    list.favor:SetActive(ladder.favor or false)
    local bar = favorCount > 0 and 26 or 0
    list.note:SetPoint("TOPLEFT", 12, -32 - bar)
    local top = bar + (#notes > 0 and (list.note:GetStringHeight() + 10) or 0)
    list.scroll:SetPoint("TOPLEFT", 8, -32 - top)

    local y = 2 -- a row's edge reaches 1px outside it: room for the first one's
    if prof.doors then -- Lockpicking: every lock, by skill, first (selected 0)
        local row = rowPool:Get(list.scroll.child)
        row:SetPoint("TOPLEFT", 2, -y)
        fillRow(row, LOCKS, 0)
        y = y + 44
    end
    -- Gold: what sells to a vendor first (it folds), then what sells at the auction house; each heading shows, empty
    -- or not
    headPool:ReleaseAll()
    local vendorRows = ladder.vendorRows
    local folded = vendorRows and vendorRows > 0 and ns.Player.Prof(prof).vendorFolded
    if folded and selected <= vendorRows and #ladder.steps > vendorRows then selected = vendorRows + 1 end
    -- Food: a group per role, each folds; a class with one role (a rogue) gets the plain list
    local roles = ladder.groups and #ladder.groups > 1 and ladder.groups
    local shutRoles = ns.Player.Prof(prof).foodFolded or {}
    for _, g in ipairs(roles or {}) do -- the picked row in a folded group gives way to the first one shown
        if selected >= g.from and selected <= g.to and shutRoles[g.name] then
            for _, o in ipairs(ladder.groups) do
                if not shutRoles[o.name] and o.to >= o.from then selected = o.from break end
            end
        end
    end
    local function heading(text, count, tooltip, toggle, shut)
        local h = headPool:Get(list.scroll.child)
        h:SetPoint("TOPLEFT", 2, -y)
        h.title:SetText(text)
        UI.SetColor(h.title, count and C.gold or C.muted)
        h.count:SetText(count or "")
        h.fold:SetShown(toggle ~= nil)
        h.fold:SetTexture(shut and "Interface\\Buttons\\UI-PlusButton-Up" or "Interface\\Buttons\\UI-MinusButton-Up")
        h.toggle, h.tooltip = toggle, tooltip
        y = y + 24
    end
    local function rows(from, to)
        for i = from, to do
            local row = rowPool:Get(list.scroll.child)
            row:SetPoint("TOPLEFT", 2, -y)
            fillRow(row, ladder.steps[i], i)
            y = y + 44
        end
    end
    if roles then
        for _, g in ipairs(roles) do
            heading(g.name, g.to - g.from + 1, { g.name, "Dishes for this role, by what eating one raises. Click to" ..
                " fold or open." }, function()
                local saved = ns.Player.Prof(prof)
                saved.foodFolded = saved.foodFolded or {}
                saved.foodFolded[g.name] = not saved.foodFolded[g.name] or nil
                Window.Refresh(true) -- only the view changes
            end, shutRoles[g.name])
            if not shutRoles[g.name] then rows(g.from, g.to) end
        end
    elseif vendorRows then
        local nothing = { "Nothing here", "Nothing earns this way at today's prices." }
        if vendorRows > 0 then -- nothing a vendor pays more for: no group at all
            heading("Sell to a vendor", vendorRows, { "Sell to a vendor", "These cost less to make than a vendor" ..
                " pays: vendors buy any number, no auction house needed. Click to fold or open." }, function()
                local saved = ns.Player.Prof(prof)
                saved.vendorFolded = not saved.vendorFolded or nil
                Window.Refresh(true) -- only the view changes
            end, folded)
            if not folded then rows(1, vendorRows) end
        end
        heading("Sell at the auction house", #ladder.steps - vendorRows, { "Sell at the auction house", "These earn" ..
            " more at the auction house: 5 or more listed, and it pays 1.5 times what a vendor does. How many sell," ..
            " the auction house doesn't say." })
        if #ladder.steps == vendorRows then heading("nothing at today's prices", nil, nothing) end
        rows(vendorRows + 1, #ladder.steps)
    else
        rows(1, #ladder.steps)
    end
    list.scroll:SetContentHeight(y + 2)
end

---------------------------------------------------------------------------------------------------------------
-- The step details (right) are UI/Cards.lua's, the menu (left) UI/Menu.lua's: what they share with the window
---------------------------------------------------------------------------------------------------------------

Window.Shared = { W = W, DETAIL_CW = DETAIL_CW, MENU_W = MENU_W, STEP_COLOR = STEP_COLOR, BAG_ICON = BAG_ICON,
                  RANK_ICON = RANK_ICON, craftsWord = craftsWord, wait = wait, recipeIcon = recipeIcon,
                  toolUsers = toolUsers, gather = gather, duration = duration, barsText = barsText,
                  useLevel = useLevel, favorSub = favorSub, foodColor = foodColor, MODE_TIPS = MODE_TIPS }

renderDetail = function() ns.Cards.Render(frame, ladder, lookup, prof, selected) end

---------------------------------------------------------------------------------------------------------------
-- Header, skill bar and footer
---------------------------------------------------------------------------------------------------------------

local function renderHeader()
    local state = ladder.state
    frame.subtitle:SetText(state.maxSkill > 0 and ("%s %d / %d, the ladder to 300"):format(prof.name, state.skill,
        state.maxSkill) or ("No %s yet"):format(prof.name))
    local tips, x = MODE_TIPS[prof.key] or MODE_TIPS[prof.kind or (prof.resale and "craft")] or {}, 12
    for _, i in ipairs({ 1, 3, 2, 4 }) do -- left to right: Skill, Skill + Gold, Gold, Food (Cooking)
        local b = frame.list.modes[i]
        local tip = b.mode == "food" and (prof.food and FOOD_TIP or nil) or tips[b.mode]
        b:SetShown(tip ~= nil)
        if tip then
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", x, -8)
            x = x + b:GetWidth() + 4
            b:SetActive(b.mode == ladder.mode)
            b.tooltip = { b.name, tip }
        end
    end
end

local function renderBar()
    local bar, state = frame.bar, ladder.state
    local width = bar:GetWidth()
    if width <= 0 then width = frame:GetWidth() - LEFT - 24 end
    local function x(skill) return math.max(0, math.min(1, skill / 300)) * width end
    for i, r in ipairs(RANK_NAMES) do
        local tick = bar.ticks[i]
        if tick then
            tick:ClearAllPoints()
            tick:SetPoint("CENTER", bar, "LEFT", x(r[1]), 0)
        end
        if tick then tick:SetShown(not prof.levelCaps) end
        bar.rankText[i]:ClearAllPoints()
        bar.rankText[i]:SetPoint("TOP", bar, "BOTTOMLEFT", x((r[1] + r[2]) / 2), -4)
        bar.rankText[i]:SetShown(not prof.levelCaps) -- Lockpicking's cap is the level x 5, not a rank
    end
    bar.fill:SetWidth(math.max(10, x(state.skill)))
    bar.fill:SetShown(state.skill > 0)
    bar.segPool:ReleaseAll()
    for _, step in ipairs(ladder.steps) do
        if step.kind ~= "rank" and step.kind ~= "profit" and step.kind ~= "food" and not step.hour then
            local seg = bar.segPool:Get(bar)
            local c = step.kind == "craft" and (STEP_COLOR[step.color] or C.text) or C.alliance
            seg.tex:SetColorTexture(c[1], c[2], c[3], 0.9)
            seg:SetPoint("LEFT", bar, "LEFT", x(step.from) + 1, 0)
            seg:SetSize(math.max(2, x(step.to) - x(step.from) - 2), 4)
        end
    end
    -- "you are here" reads to the left of its marker, or to the right near the start of the bar
    local hx = x(state.skill)
    bar.pointer:ClearAllPoints()
    bar.pointer:SetPoint("BOTTOM", bar, "TOPLEFT", hx, 3)
    bar.here:SetText(("you are here: %d"):format(state.skill))
    bar.here:ClearAllPoints()
    if hx < 120 then
        bar.here:SetPoint("BOTTOMLEFT", bar.pointer, "TOPLEFT", -2, 1)
    else
        bar.here:SetPoint("BOTTOMRIGHT", bar.pointer, "TOPRIGHT", 2, 1)
    end
    for i, r in ipairs(RANK_NAMES) do
        local fs = bar.rankText[i]
        local current = state.skill >= r[1] and state.skill < r[2] or (r[2] == 300 and state.skill >= 300)
        UI.SetColor(fs, current and C.gold or C.dim)
    end
end

-- Where the prices come from, how old they are and when AuctionDB may scan next (redrawn every second while open).
local function renderPrices()
    local source, scanned = ns.Prices.Source()
    if not source then
        frame.prices:SetText(hex(C.bad) .. "No auction house prices: AuctionDB or Auctionator needed|r")
    elseif scanned then
        local age = time() - scanned
        local c = age > 3 * 86400 and C.bad or age > 86400 and C.warn or C.muted
        frame.prices:SetText(hex(c) .. ("Prices: %s, scanned %s (%s)|r"):format(source, date("%H:%M", scanned), ns.Age(scanned)))
    else
        frame.prices:SetText(hex(C.muted) .. "Prices: " .. source .. "|r")
    end
    local text, state = ns.Describe.NextScan()
    frame.nextScan:SetText(text and (hex(state == "wait" and C.muted or C.good) .. text .. "|r") or "")
end

local function renderFooter()
    local text = ""
    if ladder.favor then
        local learn, have = 0, ns.Favor.Have()
        for _, s in ipairs(ladder.steps) do if s.status == "learn" then learn = learn + 1 end end
        text = ("%d Merchant's Favor recipes, %d you can learn now%s"):format(#ladder.steps, learn,
            have and ("; you have %d favor"):format(have) or "")
    elseif ladder.mode == "food" then
        text = ("%d dishes for your class; the cost is one dish from bought ingredients"):format(#ladder.steps)
    elseif #ladder.steps > 0 and ladder.steps[1].hour then
        text = ("%d zones at skill %d; the best about %s an hour"):format(#ladder.steps,
            ladder.from, ns.Money(ladder.steps[1].perHour))
    elseif #ladder.steps > 0 and ladder.minutes and ladder.mode == "sell" then
        text = ("Spend %s, catch about %s worth (%s, %s an hour)"):format(ns.Money(ladder.cost), ns.Money(ladder.earn),
            duration(ladder.minutes), ns.Money(ladder.earn / math.max(1e-9, ladder.minutes / 60)))
    elseif #ladder.steps > 0 and ladder.nodes and ladder.mode == "sell" then
        text = ("Spend %s, %s about %s worth (%s an hour), about %d %s"):format(ns.Money(ladder.cost),
            gather().verb:lower(), ns.Money(ladder.earn), ns.Money(ladder.perHour or 0), math.ceil(ladder.nodes),
            gather().many)
    elseif #ladder.steps > 0 and ladder.steps[1].kind == "profit" then
        local best = 0
        for _, s in ipairs(ladder.steps) do best = math.max(best, s.profit) end
        text = ("%s%d at the auction house; the best +%s a craft"):format(ladder.vendorRows > 0
            and (ladder.vendorRows .. " sell to a vendor, ") or "", #ladder.steps - ladder.vendorRows, ns.Money(best))
    elseif #ladder.steps > 0 and ladder.nodes then
        text = ("Total %s, about %d %s%s"):format(ns.Money(ladder.cost), math.ceil(ladder.nodes), gather().many,
            ladder.crafts > 0 and (", %d %s"):format(math.ceil(ladder.crafts), prof.doors and "boxes" or "smelts")
            or "")
    elseif #ladder.steps > 0 and ladder.minutes then
        text = ("Total %s, about %d catches (%s)"):format(ns.Money(ladder.cost), math.ceil(ladder.crafts),
            duration(ladder.minutes))
    elseif #ladder.steps > 0 and (ladder.back or 0) > 0 then
        text = ("Spend %s, about %s back from sales, about %d crafts"):format(ns.Money(ladder.cost), ns.Money(ladder.back),
            math.ceil(ladder.crafts))
    elseif #ladder.steps > 0 then
        text = ("Total %s, about %d crafts"):format(ns.Money(ladder.cost), math.ceil(ladder.crafts))
    end
    frame.total:SetText(text)
    renderPrices()
    frame.favor:SetChecked(ns.db.favor)
    if prof.hasFavor == nil then -- only a profession with recipes sold for Merchant's Favor shows the box
        prof.hasFavor = false
        for _, rec in pairs(prof.recipes) do
            for _, g in ipairs(rec.get) do prof.hasFavor = prof.hasFavor or g.favor ~= nil end
        end
    end
    frame.favor:SetShown(prof.hasFavor)
end

---------------------------------------------------------------------------------------------------------------
-- Building the window
---------------------------------------------------------------------------------------------------------------

local function buildBar()
    local bar = CreateFrame("Frame", nil, frame)
    bar:SetPoint("TOPLEFT", LEFT + 12, -92)
    bar:SetPoint("TOPRIGHT", -24, -92)
    bar:SetHeight(10)
    UI.Panel(bar, C.panel2, C.edge, 5, -4)
    bar.fill = CreateFrame("Frame", nil, bar)
    bar.fill:SetPoint("TOPLEFT")
    bar.fill:SetPoint("BOTTOMLEFT")
    UI.Panel(bar.fill, C.gold, C.gold, 5, -2)
    bar.segPool = UI.Pool(function(parent)
        local f = CreateFrame("Frame", nil, parent)
        f.tex = f:CreateTexture(nil, "ARTWORK")
        f.tex:SetAllPoints()
        return f
    end)
    -- markers go on a layer above the fill and the step segments
    local top = CreateFrame("Frame", nil, bar)
    top:SetAllPoints()
    top:SetFrameLevel(bar:GetFrameLevel() + 5)
    bar.rankText, bar.ticks = {}, {}
    for i, r in ipairs(RANK_NAMES) do
        if r[1] > 0 then
            local tick = top:CreateTexture(nil, "OVERLAY")
            tick:SetColorTexture(0, 0, 0, 0.8)
            tick:SetSize(2, 14)
            bar.ticks[i] = tick
        end
        local fs = UI.Label(top, 10, C.dim, nil, "CENTER")
        fs:SetText(("%s  %d - %d"):format(r[3], r[1], r[2]))
        bar.rankText[i] = fs
    end
    bar.pointer = top:CreateTexture(nil, "OVERLAY")
    bar.pointer:SetSize(12, 12)
    bar.pointer:SetTexture(UI.MEDIA .. "pointer")
    bar.pointer:SetVertexColor(C.gold[1], C.gold[2], C.gold[3])
    bar.here = UI.Label(top, 11, C.gold)
    frame.bar = bar
end

local function savePosition()
    local point, _, relative, x, y = frame:GetPoint(1)
    ns.db.windowPos = { point, x, y, relative }
end

-- The details and the bar laid out again for the window's size now.
local function relayout()
    if not frame:IsShown() then return end
    if frame.camp:IsShown() then
        ns.CampPanel.Render(frame) -- its rows' text wraps to the new width
    elseif ladder then
        renderBar()
        renderDetail()
    end
end

-- The window no bigger than the screen at its scale, so its corner (drag it, right-click it) stays on the screen: a
-- size or scale saved on a bigger screen shrinks to fit (the saved one stays for that screen).
local function fitScreen()
    local sw, sh = UIParent:GetWidth(), UIParent:GetHeight()
    local scale = math.max(MIN_SCALE, math.min(frame:GetScale(), sw / W, sh / H))
    if scale ~= frame:GetScale() then frame:SetScale(scale) end
    local mw, mh = math.max(W, math.min(MAX_W, sw / scale)), math.max(H, math.min(MAX_H, sh / scale))
    if frame.SetResizeBounds then
        frame:SetResizeBounds(W, H, mw, mh)
    elseif frame.SetMaxResize then
        frame:SetMaxResize(mw, mh)
    end
    frame:SetSize(math.min(mw, frame:GetWidth()), math.min(mh, frame:GetHeight()))
end

-- Ctrl + mouse wheel: everything bigger or smaller, keeping the window's top left corner where it is.
local function setScale(scale)
    scale = math.max(MIN_SCALE, math.min(MAX_SCALE, UIParent:GetWidth() / W, UIParent:GetHeight() / H,
        math.floor(scale * 20 + 0.5) / 20))
    local old = frame:GetScale()
    if math.abs(scale - old) < 0.001 then return end
    local left, top = frame:GetLeft(), frame:GetTop()
    frame:SetScale(scale)
    if left and top then
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left * old / scale, top * old / scale)
    end
    ns.db.windowScale = scale
    savePosition()
    fitScreen()
    relayout()
end

local function zoom(delta)
    if IsControlKeyDown and IsControlKeyDown() then
        setScale(frame:GetScale() + delta * 0.05)
        return true
    end
end

-- The corner: drag it to make the window bigger; right-click it for the normal size and scale.
local function buildGrip()
    local grip = CreateFrame("Button", nil, frame)
    grip:SetSize(14, 14)
    grip:SetPoint("BOTTOMRIGHT", -3, 3)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:RegisterForClicks("RightButtonUp")
    grip:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            UI.HideTooltip()
            frame.sizing = true
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    grip:SetScript("OnMouseUp", function()
        if not frame.sizing then return end
        frame.sizing = false
        frame:StopMovingOrSizing()
        ns.db.windowSize = { frame:GetWidth(), frame:GetHeight() }
        savePosition()
        relayout()
    end)
    grip:SetScript("OnClick", function(_, button)
        if button ~= "RightButton" then return end
        setScale(1)
        frame:SetSize(W, H)
        ns.db.windowSize = nil
        relayout()
    end)
    grip:SetScript("OnEnter", function(self)
        UI.Tooltip(self, { "Window size", "Drag: make the window bigger.",
            ("Ctrl + mouse wheel: bigger or smaller text (now %d%%)."):format(frame:GetScale() * 100 + 0.5),
            "Right-click: back to the normal size." })
    end)
    grip:SetScript("OnLeave", UI.HideTooltip)
    frame.grip = grip
end

-- Can a cached ladder be drawn again: nothing changed since, and the bags hold the same of its profession's items?
local function fresh(entry)
    if not entry or entry.version ~= version then return false end
    if entry.bags ~= bagsVersion then
        local now, was = ns.Player.Owned(entry.ladder.data), entry.ladder.state.owned or {}
        for item, n in pairs(now) do if was[item] ~= n then return false end end
        for item in pairs(was) do if not now[item] then return false end end
        entry.bags = bagsVersion
    end
    return true
end

local function build()
    frame = CreateFrame("Frame", "CraftLadderFrame", UIParent)
    frame:SetSize(W, H)
    frame:SetFrameStrata("HIGH")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    if frame.SetResizeBounds then
        frame:SetResizeBounds(W, H, MAX_W, MAX_H)
    elseif frame.SetMinResize then
        frame:SetMinResize(W, H)
        frame:SetMaxResize(MAX_W, MAX_H)
    end
    frame.favorReload, frame.favorRounds = false, 0 -- Merchant's Favor's look again at items not loaded (Window.Refresh)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        savePosition()
    end)
    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(_, delta) zoom(delta) end)
    frame:SetScript("OnSizeChanged", function()
        if ladder and frame:IsShown() then renderBar() end -- the details follow once the corner is let go
    end)
    frame:Hide()
    frame:SetScale(math.max(MIN_SCALE, math.min(MAX_SCALE, ns.db.windowScale or 1)))
    local size = ns.db.windowSize
    if size then frame:SetSize(math.max(W, math.min(MAX_W, size[1])), math.max(H, math.min(MAX_H, size[2]))) end
    local pos = ns.db.windowPos
    if pos then frame:SetPoint(pos[1], UIParent, pos[4] or pos[1], pos[2], pos[3]) else frame:SetPoint("CENTER") end
    tinsert(UISpecialFrames, "CraftLadderFrame") -- Escape closes it
    UI.Shadow(frame, 16)
    UI.Panel(frame, C.bg, C.edge, 10, -7)

    -- header
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(34, 34)
    icon:SetPoint("TOPLEFT", 16, -14)
    icon:SetTexture(UI.MEDIA .. "logo") -- whatever is shown: the menu and the subtitle say which
    frame.title = UI.Label(frame, 17, C.gold)
    frame.title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -1)
    frame.title:SetText("Craft Ladder")
    frame.subtitle = UI.Label(frame, 11, C.muted)
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -4)
    local close = UI.IconButton(frame, "close", 20, C.muted, function() frame:Hide() end)
    close:SetPoint("TOPRIGHT", -12, -14)
    close.tooltip = { "Close", "Escape closes it too." }
    ns.Menu.Build(frame) -- the menu (left)
    -- a character with no profession at all: this instead of the ladder
    local idle = CreateFrame("Frame", nil, frame)
    idle:SetPoint("TOPLEFT", LEFT, -66)
    idle:SetPoint("BOTTOMRIGHT", -12, 42)
    UI.Panel(idle, C.panel, C.edge, 8)
    idle.title = UI.Label(idle, 17, C.gold, nil, "CENTER")
    idle.title:SetPoint("CENTER", 0, 12)
    idle.title:SetText("Your hands are idle, adventurer.")
    idle.sub = UI.Label(idle, 12, C.muted, nil, "CENTER")
    idle.sub:SetPoint("TOP", idle.title, "BOTTOM", 0, -8)
    idle.sub:SetText("The trainers are waiting: learn a profession.")
    idle:Hide()
    frame.idle = idle
    ns.CampPanel.Build(frame, LEFT) -- the menu's Camp: this instead of the ladder
    local accent = frame:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("TOPLEFT", 16, -58)
    accent:SetPoint("TOPRIGHT", -16, -58)
    accent:SetHeight(1)
    local fc = UnitFactionGroup("player") == "Alliance" and C.alliance or C.horde
    accent:SetColorTexture(fc[1], fc[2], fc[3], 0.7)

    buildBar()

    -- the ladder (left)
    local list = CreateFrame("Frame", nil, frame)
    list:SetPoint("TOPLEFT", LEFT, -130)
    list:SetPoint("BOTTOMLEFT", LEFT, 42)
    list:SetWidth(LIST_W)
    UI.Panel(list, C.panel, C.edge, 8)
    -- plan for the skill, or for gold (placed by renderHeader: the professions have different ones)
    list.modes = {}
    for i, m in ipairs({ { "skill", "Skill", 48 }, { "gold", "Gold", 48 }, { "sell", "Skill + Gold", 78 },
                         { "food", "Food", 48 } }) do
        local b = UI.Button(list, m[2], m[3], 18, function()
            ns.Player.Prof(prof).mode = m[1]
            ns.Player.Prof(prof).favorView = nil
            Window.Refresh(true) -- back to a mode already calculated: drawn again
        end)
        b.mode, b.name = m[1], m[2]
        list.modes[i] = b
    end
    list.favor = UI.Button(list, "", LIST_W - 24, 20, function()
        local p = ns.Player.Prof(prof)
        p.favorView = not p.favorView or nil
        Window.Refresh(true) -- only the view changes: the ladder needn't be calculated again
    end)
    list.favor:SetPoint("TOPLEFT", 12, -30)
    list.favor.tooltip = { "Merchant's Favor recipes", "What the supply camps' quartermaster sells for Merchant's Favor:" ..
        " its price and level (seen at a quartermaster), your skill, what you know and can make." }
    list.note = UI.Label(list, 11, C.warn)
    list.note:SetPoint("TOPLEFT", 12, -32)
    list.note:SetWidth(LIST_W - 24)
    list.note:SetWordWrap(true)
    list.scroll = UI.Scroll(list)
    list.scroll.onCtrlWheel = zoom
    list.scroll:SetPoint("TOPLEFT", 8, -32)
    list.scroll:SetPoint("BOTTOMRIGHT", -6, 8)
    frame.list = list
    rowPool = UI.Pool(makeRow)
    headPool = UI.Pool(makeListHead)

    -- the step details (right)
    local detail = CreateFrame("Frame", nil, frame)
    detail:SetPoint("TOPLEFT", list, "TOPRIGHT", 8, 0)
    detail:SetPoint("BOTTOMRIGHT", -12, 42)
    UI.Panel(detail, C.panel, C.edge, 8)
    detail.scroll = UI.Scroll(detail)
    detail.scroll.onCtrlWheel = zoom
    detail.scroll:SetPoint("TOPLEFT", 14, -12)
    detail.scroll:SetPoint("BOTTOMRIGHT", -8, 10)
    local head = CreateFrame("Frame", nil, detail.scroll.child)
    head:SetSize(DETAIL_CW, 54)
    head:SetPoint("TOPLEFT")
    head.icon = head:CreateTexture(nil, "ARTWORK")
    head.icon:SetSize(40, 40)
    head.icon:SetPoint("TOPLEFT", 0, -2)
    head.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    head.title = UI.Label(head, 15)
    head.title:SetPoint("TOPLEFT", head.icon, "TOPRIGHT", 10, 0)
    head.title:SetWidth(DETAIL_CW - 50)
    head.line1 = UI.Label(head, 11, C.text)
    head.line1:SetPoint("TOPLEFT", head.title, "BOTTOMLEFT", 0, -5)
    head.line1:SetWidth(DETAIL_CW - 50)
    head.line2 = UI.Label(head, 11, C.muted)
    head.line2:SetPoint("TOPLEFT", head.line1, "BOTTOMLEFT", 0, -4)
    head.line2:SetWidth(DETAIL_CW - 50)
    -- hovering the headline shows the dish's (or book's) own tooltip; Shift-click links it
    head.hit = CreateFrame("Button", nil, head)
    head.hit:SetPoint("TOPLEFT")
    head.hit:SetSize(DETAIL_CW, 44)
    head.hit:SetScript("OnEnter", function(self)
        local step = head.step
        local item = stepItem(step)
        if item or (step and step.recipe) then UI.ItemTooltip(self, item, step.recipe) end
    end)
    head.hit:SetScript("OnLeave", UI.HideTooltip)
    function head:Fit(cw)
        self:SetWidth(cw)
        self.hit:SetWidth(cw)
        for _, fs in ipairs({ self.title, self.line1, self.line2 }) do fs:SetWidth(cw - 50) end
    end
    head.hit:SetScript("OnClick", function()
        if IsShiftKeyDown() then UI.LinkItem(stepItem(head.step)) end
    end)
    detail.head = head
    detail.back = UI.Button(detail.scroll.child, "Back to cheapest", 120, 20, function(self) backToCheapest(self.step) end)
    detail.back.tooltip = { "Back to cheapest", "Use the cheapest recipe for this step again." }
    local craft = CreateFrame("Frame", nil, detail.scroll.child)
    craft:SetSize(DETAIL_CW, 24)
    craft.count = CreateFrame("EditBox", nil, craft)
    craft.count:SetSize(46, 22)
    craft.count:SetPoint("LEFT", 2, 0) -- its edge is drawn 1 px outside it: at 0 the scroll frame cuts the left one off
    UI.Panel(craft.count, C.panel2, C.edge, 5, -4)
    craft.count:SetFont(UI.FONT, 12, "")
    craft.count:SetTextColor(C.text[1], C.text[2], C.text[3])
    craft.count:SetJustifyH("CENTER")
    craft.count:SetNumeric(true)
    craft.count:SetMaxLetters(3)
    craft.count:SetAutoFocus(false)
    craft.count:SetScript("OnEscapePressed", craft.count.ClearFocus)
    craft.count:SetScript("OnEnterPressed", craft.count.ClearFocus)
    craft.button = UI.Button(craft, "Craft", 130, 22, function() ns.Cards.CraftClick(craft) end)
    craft.button:SetPoint("LEFT", craft.count, "RIGHT", 6, 0)
    craft.note = UI.Label(craft, 11, C.muted)
    craft.note:SetPoint("LEFT", craft.button, "RIGHT", 10, 0)
    craft:Hide()
    detail.craft = craft
    frame.detail = detail
    ns.Cards.Build(frame)

    -- footer
    frame.total = UI.Label(frame, 12, C.text)
    frame.total:SetPoint("BOTTOMLEFT", LEFT + 6, 9)
    frame.total:SetWidth(LIST_W - 8) -- under the list, up to two lines: the Merchant's Favor box is right of it
    frame.total:SetWordWrap(true)
    frame.total:SetJustifyH("LEFT")
    frame.favor = UI.Check(frame, "Merchant's Favor recipes", function(checked)
        ns.db.favor = checked
        Window.Refresh()
    end)
    frame.favor:SetPoint("BOTTOMLEFT", LEFT + LIST_W + 10, 14)
    frame.favor.tooltip = { "Merchant's Favor recipes", "Also use recipes bought with Merchant's Favor." }
    frame.prices = UI.Label(frame, 11, C.muted, nil, "RIGHT")
    frame.prices:SetPoint("BOTTOMRIGHT", -18, 22)
    frame.nextScan = UI.Label(frame, 10, C.muted, nil, "RIGHT")
    frame.nextScan:SetPoint("BOTTOMRIGHT", -18, 9)
    buildGrip()

    -- the Craft bar follows the profession window, its recipe list and combat, only while the window is open
    local craftEvents = CreateFrame("Frame", nil, frame)
    local CRAFT_WATCH = { "TRADE_SKILL_SHOW", "TRADE_SKILL_CLOSE", "TRADE_SKILL_LIST_UPDATE", "PLAYER_REGEN_DISABLED",
                          "PLAYER_REGEN_ENABLED" }
    craftEvents:SetScript("OnEvent", function()
        if frame.detail.craft:IsShown() and ladder then ns.Cards.PaintCraft(frame.detail.craft) end
    end)
    -- what the ladders depend on: counted (every cached ladder is then out of date, or for the bags maybe); while the
    -- window is open the shown one is drawn again, at most every 2 s (calculated again only if it's out of date)
    local events = CreateFrame("Frame", nil, frame)
    local WATCH = { "SKILL_LINES_CHANGED", "CHAT_MSG_SKILL", "BAG_UPDATE_DELAYED", "AUCTION_HOUSE_CLOSED",
                    "MERCHANT_CLOSED", "PLAYER_LEVEL_UP", "NEW_RECIPE_LEARNED", "UPDATE_FACTION" }
    for _, e in ipairs(WATCH) do pcall(events.RegisterEvent, events, e) end -- pcall: an event this client lacks
    local pending = false
    events:SetScript("OnEvent", function(_, event)
        if event == "BAG_UPDATE_DELAYED" then bagsVersion = bagsVersion + 1 else version = version + 1 end
        if pending or not frame:IsShown() then return end
        pending = true
        C_Timer.After(2, function()
            pending = false
            if frame:IsShown() then Window.Refresh(true) end
        end)
    end)
    frame:SetScript("OnShow", function()
        fitScreen()
        for _, e in ipairs(CRAFT_WATCH) do pcall(craftEvents.RegisterEvent, craftEvents, e) end
        shownProf = nil -- opening shows the row you looked at last, else the step you're on
        Window.Refresh(true)
        -- the scan countdown: two lines of text a second, nothing recalculated
        frame.ticker = C_Timer.NewTicker(1, function() if ladder then renderPrices() end end)
    end)
    frame:SetScript("OnHide", function()
        craftEvents:UnregisterAllEvents()
        if frame.ticker then frame.ticker:Cancel(); frame.ticker = nil end
        UI.HideTooltip()
    end)
end

---------------------------------------------------------------------------------------------------------------

-- Redraws, only while the window is open: the shown profession's ladder in its mode, from the cache while it's up to
-- date, else calculated. cached: draw from the cache if it can (a view, a mode or a profession picked, the window
-- opened again); without it every cached ladder is out of date (a recipe picked, a setting changed).
function Window.Refresh(cached)
    if not (frame and frame:IsShown()) then return end
    if not cached then version = version + 1 end
    -- the menu's Camp: its panel instead of the ladder, nothing calculated
    local camp = ns.Player.Saved().tab == "camp"
    frame.camp:SetShown(camp)
    if camp then
        for _, f in ipairs({ frame.bar, frame.list, frame.detail, frame.total, frame.prices, frame.nextScan, frame.idle,
                             frame.favor }) do
            f:Hide()
        end
        ns.Menu.Render(frame, nil)
        ns.CampPanel.Render(frame)
        return
    end
    local ms
    local data = ns.CurrentProfession()
    local key = data.key .. ":" .. ns.LadderMode(data)
    if fresh(cache[key]) then
        ladder, lookup = cache[key].ladder, cache[key].lookup
    else
        ladder, lookup, ms = ns.Calculate(data)
        cache[key] = { ladder = ladder, lookup = lookup, version = version, bags = bagsVersion }
    end
    if not ns.Player.Prof(ladder.data).favorView then frame.favorRounds = 0 end
    if ns.Player.Prof(ladder.data).favorView and ns.Favor.Count(ladder.data) > 0 then
        ladder = ns.Favor.Ladder(ladder, ns.db.favorPrices or {})
        -- the levels to wear what they make come from the game's item data: again once it has loaded them (5 times
        -- at most)
        frame.favorRounds = (frame.favorRounds or 0) + 1
        for _, s in ipairs(ladder.steps) do
            local makes = ladder.data.recipes[s.recipe].makes
            if makes and not useLevel(makes) and not frame.favorReload and frame.favorRounds <= 5 then
                frame.favorReload = true
                C_Timer.After(1, function()
                    frame.favorReload = false
                    if frame:IsShown() then Window.Refresh(true) end
                end)
            end
        end
    end
    prof = ladder.data
    ns.lastCalcMs = ms or ns.lastCalcMs
    -- the row you looked at; gone (levelled past) on opening or another tab: the step you're on; gone otherwise (you
    -- picked another recipe for it): the same place
    local row = savedRow()
    if row then selected = row elseif prof ~= shownProf then selected = 1 end
    shownProf = prof
    if selected > #ladder.steps then selected = math.max(1, #ladder.steps) end
    -- no profession and none opened (/craft <profession> opens one to plan): the idle screen
    local idle = ns.Menu.Render(frame, prof) == 0 and not ns.Player.Saved().tab
    frame.idle:SetShown(idle)
    for _, f in ipairs({ frame.bar, frame.list, frame.detail, frame.total, frame.prices, frame.nextScan }) do
        f:SetShown(not idle)
    end
    if idle then
        frame.subtitle:SetText("No profession yet")
        frame.favor:Hide()
        return
    end
    renderHeader()
    renderBar()
    renderList()
    renderDetail()
    renderFooter()
end

function Window.Toggle()
    if not frame then build() end
    frame:SetShown(not frame:IsShown())
end

function Window.Open()
    if not frame then build() end
    if frame:IsShown() then Window.Refresh() else frame:Show() end
end

function Window.IsShown() return frame and frame:IsShown() end

-- Something every ladder depends on changed while the window was closed (new recipes read, a trainer's real skills).
function Window.Invalidate() version = version + 1 end

-- A profession's ladder in its mode while it's still up to date (the minimap's tooltip uses it), or nil.
function Window.Cached(data)
    local entry = cache[data.key .. ":" .. ns.LadderMode(data)]
    return fresh(entry) and entry.ladder or nil
end

-- The profession the window shows and the step picked in it (the auction house tab buys for that step), or nil.
function Window.Selected()
    if not (frame and ladder) then return end
    return prof, ladder.steps[selected]
end
