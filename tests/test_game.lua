-- Smoke test of the in-game code: loads the addon in .toc order against tests/wowmock.lua, fed from fixtures, then
-- opens the profession windows, visits a merchant and a trainer and drives the main window and /craft.
--   luajit tests/test_game.lua [Cooking fixture] [First Aid fixture] [-v]
local root = (arg[0]:match("^(.*)[/\\]tests[/\\]") or ".") .. "/"
local fx = dofile(root .. "tests/fixtures/" .. (arg[1] or "yungzug") .. ".lua")
fx.firstaid = dofile(root .. "tests/fixtures/" .. (arg[2] or "yungzug_firstaid") .. ".lua")
fx.fishing = dofile(root .. "tests/fixtures/yungzug_fishing.lua")
fx.blacksmithing = dofile(root .. "tests/fixtures/yungzug_blacksmithing.lua")
-- Engineering: Zug's 38 of 75, without his bags (they'd feed the other tabs' ladders)
fx.engineering = dofile(root .. "tests/fixtures/zug_engineering.lua")
fx.engineering.owned = {}
-- Mining at 70 of 150: Smelt Copper known, Copper Ore and Tin Ore on the auction house
fx.mining = { skill = 70, maxSkill = 150, known = { [2657] = true }, owned = {},
              ah = { [2770] = { fx.scanTs, 10, 15, 500 }, [2771] = { fx.scanTs, 40, 50, 300 } } }
local mock = dofile(root .. "tests/wowmock.lua")
mock.echo = arg[3] == "-v"

local ns = {}
mock.install(fx, ns)
mock.load(root, ns)
-- saved data from before First Aid: one character's Cooking recipes and picks straight under the character
CraftLadderDB = { chars = { ["Player-TEST"] = { known = { [2540] = true }, knownAt = 1, choices = {} } },
                  vendorPrices = { H = { [2678] = 1 } } } -- vendor prices from when a faction shared them
mock.fire("ADDON_LOADED", "CraftLadder")
mock.fire("PLAYER_LOGIN")

local failed = 0
local function expect(what, ok)
    if not ok then failed = failed + 1; io.write("FAIL: ", what, "\n") else io.write("ok   ", what, "\n") end
end
local function said(pattern)
    for _, l in ipairs(mock.output) do if l:find(pattern) then return true end end
end
local function strip(s) return (s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")) end
local function char() return CraftLadderDB.chars["Player-TEST"] end

expect("old saved recipes move under Cooking", ns.Player.Prof(ns.COOKING).known[2540] and char().known == nil)
expect("vendor prices shared by a faction are dropped", CraftLadderDB.vendorPrices == nil)
expect("money below zero", strip(ns.Money(-73)) == "-73c" and strip(ns.Money(-10526)) == "-1g 5s 26c")
ns.Player.Prof(ns.COOKING).known = {}

-- before the Cooking window was opened
SlashCmdList.CRAFTLADDER("chat cooking")
expect("chat printout asks to open the Cooking window", said("Open your Cooking window"))

-- the Cooking window: three events, one read a second later
mock.fire("TRADE_SKILL_SHOW"); mock.fire("TRADE_SKILL_LIST_UPDATE"); mock.fire("TRADE_SKILL_LIST_UPDATE")
expect("the Cooking window is read once for three events", #mock.timers == 1)
mock.runTimers()
local function count(t) local n = 0 for _ in pairs(t) do n = n + 1 end return n end
expect("6 known Cooking recipes saved", count(char().prof.cooking.known) == 6)

-- the First Aid window
mock.window = "firstaid"
mock.fire("TRADE_SKILL_SHOW"); mock.runTimers()
-- (Yungzug knows 6, one of them the First Aid Kit for camping: in the data since it gives skill, 1.60.1.70425)
expect("6 known First Aid recipes saved, Cooking's kept", count(char().prof.firstaid.known) == 6
    and count(char().prof.cooking.known) == 6)

-- a merchant visit records what it really charges
mock.fire("MERCHANT_SHOW"); mock.runTimers()
expect("Mild Spices: real price 2c each, for this character", char().vendorPrices[2678] == 2)
-- another character's price of Rhapsody Malt (an Alliance one: only Alliance vendors sell it) stays theirs
CraftLadderDB.chars["Player-OTHER"] = { prof = {}, vendorPrices = { [2894] = 45 } }
local _, lookupNow = ns.Prices.ForGame()
local malt = lookupNow(2894)
expect("another character's vendor price isn't yours", not (malt and malt.source == "vendor"))
CraftLadderDB.chars["Player-OTHER"] = nil
SlashCmdList.CRAFTLADDER("help")
local listsAll = true
for _, data in ipairs(ns.Professions) do listsAll = listsAll and said("/craft " .. data.name:lower()) end
expect("/craft's help names every profession", listsAll and said("/craft first aid"))

-- the window, on Cooking
SlashCmdList.CRAFTLADDER("cooking")
local frame = CraftLadderFrame
expect("/craft cooking opens the window", frame and frame:IsShown())
local function rows() return mock.shownChildren(frame.list.scroll.child, "index") end
local function tab(key) -- a profession's entry in the menu
    for _, t in ipairs(frame.menu.entries) do if t.data.key == key then return t end end
end
local function options() return mock.shownChildren(frame.detail.scroll.child, "option") end
local function places() return mock.shownChildren(frame.detail.scroll.child, "npc") end
local function items() return mock.shownChildren(frame.detail.scroll.child, "item") end
-- a crafting step's card, as every crafting profession shows it: Learn it, One craft, ..., Batch
local function craftCard()
    local names = {}
    for _, f in ipairs(mock.shownChildren(frame.detail.scroll.child, "label")) do
        names[#names + 1] = strip(f.label.text):gsub(":.*", "")
    end
    local text = table.concat(names, " | ")
    return text:find("^Learn it | One craft") ~= nil and text:find("Batch") ~= nil, text
end
local function headings() return mock.shownChildren(frame.list.scroll.child, "fold") end
-- a recipe row's icon of where it's learned: the game's NPC dialog icons (none once known)
local WAY_ICONS = { trainer = "TrainerGossipIcon", vendor = "VendorGossipIcon", ah = "auctioneerGossipIcon",
                    quest = "AvailableQuestIcon", owned = "INV_Scroll_03" }
local function wayShown(row)
    for kind, file in pairs(WAY_ICONS) do if strip(row.sub.text):find(file, 1, true) then return kind end end
end
local function clickFirstCraft()
    for _, r in ipairs(mock.shownChildren(frame.list.scroll.child, "index")) do
        if r.step.kind == "craft" then mock.click(r); return true end
    end
end
local function lines()
    local out = {}
    for _, c in ipairs(frame.detail.scroll.child.children) do
        local t = rawget(c, "text")
        if c.shown and type(t) == "table" then out[#out + 1] = strip(t.text) end
    end
    return table.concat(out, "\n")
end
expect("title says Craft Ladder", frame.title.text == "Craft Ladder")
local function shownTabs()
    local n = 0
    for _, tab in ipairs(frame.menu.entries) do if tab:IsShown() then n = n + 1 end end
    return n
end
expect("the menu: an entry per profession the character has (no Tailoring), Cooking picked", shownTabs() == 6
    and not tab("tailoring"):IsShown() and tab("cooking").active and not tab("firstaid").active)
local heads = {}
for _, h in ipairs(frame.menu.heads) do if h:IsShown() then heads[#heads + 1] = h.text end end
expect("... main professions first, then the secondary ones (no Class group for a warrior)",
    table.concat(heads, ",") == "PROFESSIONS,SECONDARY")
expect("... each with its skill", strip(tab("cooking").skill.text):find("^%d+ / %d+$"))
-- a character with no profession at all (and none opened): the idle screen instead of the ladder
local skillOf, picked = ns.Player.Skill, char().tab
ns.Player.Skill = function() return 0, 0 end
char().tab = nil
ns.Window.Refresh()
expect("no profession: \"Your hands are idle, adventurer.\", no ladder, an empty menu", frame.idle:IsShown()
    and not frame.list:IsShown() and strip(frame.idle.title.text) == "Your hands are idle, adventurer."
    and shownTabs() == 0)
ns.Player.Skill, char().tab = skillOf, picked
ns.Window.Refresh()
expect("... with a profession again: the ladder back", not frame.idle:IsShown() and frame.list:IsShown())
expect("the ladder goes to 300", rows()[#rows()].step.to == 300)
-- (Strider Stew from the Strider Meat in the bags: a vendor pays more for the stews than the apples cost)
expect("first step is Strider Stew, 85 - 90", strip(rows()[1].name.text) == "Strider Stew"
    and strip(rows()[1].sub.text):find("^85 %- 90"))
expect("details show the first step", strip(frame.detail.head.title.text) == "Strider Stew")
local withIcon, rightIcons = 0, true
for _, r in ipairs(rows()) do
    if r.step.learn then
        local want = WAY_ICONS[r.step.learn.kind] and r.step.learn.kind or nil
        rightIcons = rightIcons and wayShown(r) == want
        if want then withIcon = withIcon + 1 end
    end
end
expect("Skill: each recipe's row shows where it's learned (trainer, vendor, ...), a known one nothing",
    withIcon > 0 and rightIcons)
expect("first step lists its options", #options() >= 2)
-- (two ingredients: once for one craft, up top, and once for the batch)
expect("first step's ingredients are listed, for one craft and for the step", #items() == 4
    and strip(items()[1].sub.text):find(" each"))
expect("Cooking: the crafting card (Learn it, One craft, Batch)", craftCard())
-- the Craft bar: the button crafts the count, opening the profession window first when it's closed
local bar = frame.detail.craft
expect("Craft bar on a crafting step: a count no more than the step needs", bar:IsShown()
    and tonumber(bar.count.text) <= bar.need)
local opened, crafted
C_TradeSkillUI.OpenTradeSkill = function(line) opened = line end
C_TradeSkillUI.CraftRecipe = function(id, n) crafted = { id, n } end
bar.step.learn, bar.step.canCook = { kind = "known", cost = 0 }, 40
mock.fire("PLAYER_REGEN_ENABLED") -- repaints the bar
bar.count:SetText("2")
mock.click(bar.button)
expect("... window closed: \"Craft\" opens it and crafts in the same click", strip(bar.button.label.text) == "Craft"
    and bar.button:IsEnabled() and opened == 185 and crafted and crafted[2] == 2)
opened, crafted = nil, nil
local recipeInfo = C_TradeSkillUI.GetRecipeInfo
ProfessionsFrame = CreateFrame("Frame")
ProfessionsFrame:Show()
C_TradeSkillUI.GetBaseProfessionInfo = function() return { professionID = 185 } end
C_TradeSkillUI.GetRecipeInfo = function() return { learned = true, numAvailable = 7 } end
mock.fire("PLAYER_REGEN_ENABLED")
bar.count:SetText("3")
mock.click(bar.button)
expect("... window open: \"Craft\" crafts as many as the box says", strip(bar.button.label.text) == "Craft"
    and crafted and crafted[1] == bar.step.recipe and crafted[2] == 3
    and strip(bar.note.text) == ("Your bags allow 7; the step needs %d."):format(bar.need))
bar.step.learn = { kind = "vendor", cost = 100 }
mock.fire("PLAYER_REGEN_ENABLED")
expect("... a recipe not learned yet: off, and says why", not bar.button:IsEnabled()
    and strip(bar.note.text) == "Learn the recipe first.")
ProfessionsFrame:Hide()
C_TradeSkillUI.GetRecipeInfo, C_TradeSkillUI.GetBaseProfessionInfo = recipeInfo, nil
expect("no 'open the Cooking window' note now", not frame.list.note:IsShown())
expect("footer shows the total, and what selling the dishes brings back", strip(frame.total.text):find("^Spend")
    and strip(frame.total.text):find("back from sales"))
expect("footer shows the price source", strip(frame.prices.text):find("AuctionDB"))

-- a bigger window: the details get wider; Ctrl + wheel scales it; right-click on the corner resets both
frame:SetSize(1100, 760)
frame.grip.scripts.OnMouseDown(frame.grip, "LeftButton")
frame.grip.scripts.OnMouseUp(frame.grip, "LeftButton")
expect("dragging the corner saves the size", CraftLadderDB.windowSize[1] == 1100 and CraftLadderDB.windowSize[2] == 760)
expect("the details fill the wider window", frame.detail.head.width == 1100 - 580 and items()[1].width == 1100 - 580)
mock.ctrl = true
frame.detail.scroll.scripts.OnMouseWheel(frame.detail.scroll, 1)
mock.ctrl = false
expect("Ctrl + wheel: 105%, saved", math.abs(frame:GetScale() - 1.05) < 1e-9 and math.abs(CraftLadderDB.windowScale - 1.05) < 1e-9)
frame.detail.scroll.scripts.OnMouseWheel(frame.detail.scroll, -1)
expect("the wheel alone scrolls and leaves the scale", math.abs(frame:GetScale() - 1.05) < 1e-9)
frame.grip.scripts.OnEnter(frame.grip); frame.grip.scripts.OnLeave(frame.grip)
mock.click(frame.grip, "RightButton")
expect("right-click on the corner: normal size and scale", frame.width == 1038 and frame:GetScale() == 1
    and CraftLadderDB.windowSize == nil and items()[1].width == 820 - 362)
-- a size and scale from a bigger screen (a laptop after a 4K monitor): the window fits the screen, its corner on it
frame:SetScale(1.3)
frame:SetSize(1344, 1083)
UIParent:SetSize(1366, 768)
frame:Hide()
frame:Show()
expect("a window bigger than the screen shrinks to fit it when opened", frame:GetScale() == 1.3
    and frame.width * 1.3 <= 1366 and frame.height * 1.3 <= 768 + 1e-9)
mock.ctrl = true
for _ = 1, 10 do frame.detail.scroll.scripts.OnMouseWheel(frame.detail.scroll, 1) end
mock.ctrl = false
expect("... Ctrl + wheel stops where 1038 x 560 still fits", frame:GetScale() * 560 <= 768 + 1e-9
    and frame.height * frame:GetScale() <= 768 + 1e-9)
UIParent:SetSize(1920, 1080)
mock.click(frame.grip, "RightButton")

-- the game's own tooltips of the dishes
local function hover(w) w.scripts.OnEnter(w); local item = rawget(GameTooltip, "tipItem"); w.scripts.OnLeave(w); return item end
local dish = ns.COOKING.recipes[rows()[1].step.recipe].makes
expect("hovering a ladder step shows its dish", dish and hover(rows()[1]) == dish)
expect("hovering the step's headline shows its dish", hover(frame.detail.head.hit) == dish)
local opt = options()[2]
expect("hovering a recipe option shows its dish", hover(opt) == ns.COOKING.recipes[opt.option.recipe].makes)
expect("hovering an ingredient shows it", hover(items()[1]) == items()[1].item)

-- a vendor's recipe, with map pins
mock.click(rows()[4])
expect("click shows Crispy Lizard Tail", strip(frame.detail.head.title.text) == "Crispy Lizard Tail")
expect("Horde vendors listed with pins", #places() >= 1)
mock.click(places()[1])
expect("clicking a vendor sets a map pin", #mock.waypoints == 1 and mock.waypoints[1].map ~= nil)

-- pick another recipe for step 2, then go back
mock.click(rows()[2])
local other
for _, o in ipairs(options()) do if not o.chosen then other = o; break end end
mock.click(other)
expect("picking another recipe changes step 2", strip(rows()[2].name.text) == other.option.name)
expect("the pick is saved under Cooking", #char().prof.cooking.choices == 1)
mock.click(rows()[2])
expect("'back to cheapest' shows on a pick", frame.detail.back:IsShown())
mock.click(frame.detail.back)
expect("back to cheapest", strip(rows()[2].name.text) == "Strider Stew" and #char().prof.cooking.choices == 0)

-- the rank-ups on the way to 300
local function rankRows()
    local out = {}
    for _, r in ipairs(rows()) do if strip(r.name.text):find("^Learn ") then out[#out + 1] = r end end
    return out
end
expect("two rank-ups to 300", #rankRows() == 2)
expect("hovering 'Learn Expert' shows the Expert Cookbook", hover(rankRows()[1]) == 16072)
mock.click(rankRows()[1])
expect("Expert: the book's vendor with a pin", strip(frame.detail.head.title.text) == "Learn Expert Cooking" and #places() == 1)
mock.click(rankRows()[2])
expect("Artisan: two quest NPCs and three ingredients", #places() == 2 and #items() == 3)
expect("Artisan: needs level 35", strip(frame.detail.head.line2.text):find("level 35"))

-- Food: Cooking's fourth mode, a group per role of a warrior (Melee, Tank)
local foodButton = frame.list.modes[4]
expect("Cooking: a Food mode", foodButton:IsShown())
mock.click(foodButton)
expect("Food: saved, active, its dishes listed", char().prof.cooking.mode == "food" and foodButton.active and #rows() > 0)
-- a dish's name in its skill-up colour at your skill: orange, grey (no point) white, above your skill red
local C, cookSkill = ns.UI.C, ns.Player.Skill(ns.COOKING)
local function sameColor(fs, c) return fs.color[1] == c[1] and fs.color[2] == c[2] and fs.color[3] == c[3] end
local orangeRow, greyRow, redRow
for _, r in ipairs(rows()) do
    local color = ns.Ladder.Color(ns.COOKING.recipes[r.step.recipe].colors, cookSkill)
    if r.step.needSkill then redRow = redRow or r
    elseif color == "orange" then orangeRow = orangeRow or r
    elseif color == "grey" then greyRow = greyRow or r end
end
expect("... a dish's name in its skill-up colour: orange, grey white, above your skill red", orangeRow and greyRow
    and redRow and sameColor(orangeRow.name, C.orange) and sameColor(greyRow.name, C.text)
    and sameColor(redRow.name, C.bad))
mock.click(orangeRow)
expect("... its card: the buff and the level first, then where it turns yellow, green and grey",
    strip(frame.detail.head.line1.text):find("%(Well Fed%)%. ") and strip(frame.detail.head.line2.text):find("^orange from %d+")
    and strip(frame.detail.head.line2.text):find("grey %d+$") and sameColor(frame.detail.head.title, C.orange))
local roles = {}
for _, h in ipairs(headings()) do roles[#roles + 1] = strip(h.title.text) end
expect("... a group per role: Melee and Tank for a warrior", table.concat(roles, ",") == "Melee,Tank")
mock.click(headings()[1])
expect("... a role folds, and stays folded", char().prof.cooking.foodFolded.Melee and rows()[1].step.role == "Tank")
mock.click(headings()[1])
expect("... and opens again", not char().prof.cooking.foodFolded.Melee and rows()[1].step.role == "Melee")
local aboveSkill
for _, r in ipairs(rows()) do if r.step.needSkill and r.step.learn then aboveSkill = aboveSkill or r end end
expect("... a dish above your skill still says where its recipe is learned", aboveSkill
    and strip(aboveSkill.sub.text):find("|T", 1, true) and strip(aboveSkill.sub.text):find("skill %d+"))
mock.click(rows()[1])
expect("... a dish's card says what it raises", strip(frame.detail.head.line1.text):find("Well Fed"))
mock.class = "ROGUE"
ns.Window.Refresh()
expect("... a rogue's one role: the plain list, no heading", #headings() == 0 and #rows() > 0
    and rows()[1].step.role == "Melee")
mock.class = "WARRIOR"
ns.Window.Refresh()
char().prof.cooking.mode = nil
ns.Window.Refresh()

-- Merchant's Favor recipes
mock.click(frame.favor)
expect("favor setting saved", CraftLadderDB.favor == true)
mock.click(frame.favor)

-- the First Aid tab
mock.click(tab("firstaid"))
expect("First Aid tab: active, remembered", tab("firstaid").active and char().tab == "firstaid")
expect("First Aid: no Food mode", not frame.list.modes[4]:IsShown())
local laterRow
for _, r in ipairs(rows()) do if r.step.learn and r.step.learn.earlier then laterRow = laterRow or r end end
mock.click(laterRow)
expect("First Aid: a recipe an earlier step learns says so, not \"you know it\"; it can't be crafted yet",
    ns.Describe.Learn(laterRow.step.learn):find("earlier in the ladder")
    and strip(frame.detail.craft.note.text) == "Learn the recipe first.")
laterRow.step.canCook, laterRow.step.fromBags = 3, nil
mock.click(laterRow)
expect("... with its reagents in the bags: you have them, not 'you can make them now'",
    lines():find("You have the reagents for 3%.") and not lines():find("now with what you have"))
expect("First Aid tab: header", strip(frame.subtitle.text) == "First Aid 133 / 150, the ladder to 300")
expect("First Aid: the crafting card (Learn it, One craft, Batch)", clickFirstCraft() and craftCard())
mock.click(rows()[1])
expect("First Aid: Expert can be learned now", strip(rows()[1].name.text) == "Learn Expert")
mock.click(rows()[1])
expect("Expert First Aid: Balai Lok'Wein's book, 1g (the client's price)",
    strip(frame.detail.head.title.text) == "Learn Expert First Aid" and #places() == 1
    and strip(places()[1].right.text) == "1g 0s 0c")
expect("then Heavy Wool Bandage from your own wool", strip(rows()[2].name.text) == "Heavy Wool Bandage"
    and rows()[2].step.cost == 0)
mock.click(rankRows()[2])
expect("Artisan First Aid: the Horde quest at Doctor Gregory Victor",
    strip(frame.detail.head.title.text) == "Learn Artisan First Aid" and #places() == 1 and places()[1].npc == 12920)
mock.click(rows()[2])
local guessShown = false
for _, o in ipairs(options()) do
    if o.option.recipe == 1244433 and strip(o.sub.text):find("about") then guessShown = true end
end
expect("Healing Potion's trainer fee shows as an estimate", guessShown)

-- a First Aid trainer tells the real skill and fee; an Alchemy trainer's Healing Potion isn't First Aid's
mock.trainer = { { name = "Healing Potion", skillName = "First Aid", skill = 125, cost = 900 },
                 { name = "Healing Potion", skillName = "Alchemy", skill = 55, cost = 100 },
                 { name = "First Aid", skillName = "First Aid", skill = 50, cost = 550 } } -- the Journeyman rank
mock.fire("TRAINER_SHOW"); mock.runTimers()
local hp = ns.FIRSTAID.recipes[1244433]
expect("trainer: Healing Potion learned at 125 for 9s, no longer a guess",
    CraftLadderDB.trainer[1244433].skill == 125 and hp.learn == 125 and not hp.guess and hp.get[1].cost == 900
    and not hp.get[1].costGuess)
expect("... and Journeyman's fee: 5s 50c, recorded and used", CraftLadderDB.rankFees[3274].cost == 550
    and ns.FIRSTAID.ranks[2].cost == 550 and not CraftLadderDB.trainer[3274])

-- the Fishing tab: zones instead of recipes
local function caughtNames()
    local out = {}
    for _, f in ipairs(items()) do out[#out + 1] = strip(f.name.text) end
    return table.concat(out, "\n")
end
mock.click(tab("fishing"))
expect("Fishing tab: header", strip(frame.subtitle.text) == "Fishing 78 / 150, the ladder to 300")
expect("Fishing: the Barrens first, no getaways", strip(rows()[1].name.text) == "Fish in The Barrens"
    and strip(frame.detail.head.line2.text):find("^No fish get away here%. Catches worth about"))
expect("Fishing: Skill mode by default, the switch shown", frame.list.modes[1].active and frame.list.modes[1]:IsShown())
expect("Fishing: the Barrens' pools, with what a catch from them is worth", lines():find("Fish pools when you see them")
    and caughtNames():find("Floating Wreckage  5 places known"))
expect("Fishing: no Merchant's Favor box", not frame.favor:IsShown())
local caught = {}
for _, f in ipairs(items()) do caught[#caught + 1] = strip(f.name.text) .. " " .. strip(f.cost.text) end
caught = table.concat(caught, "\n")
expect("Fishing: what you catch, with prices and what Cooking uses",
    caught:find("Raw Rainbow Fin Albacore  your Cooking uses it %d+c each") and caught:find("Oily Blackmouth 5s"))
expect("Fishing: other zones to pick from", #options() >= 3)
rows()[1].scripts.OnEnter(rows()[1]); rows()[1].scripts.OnLeave(rows()[1])
expect("hovering a fishing step works", true)
local zoneOpt
for _, o in ipairs(options()) do if not o.chosen then zoneOpt = o; break end end
zoneOpt.scripts.OnEnter(zoneOpt); zoneOpt.scripts.OnLeave(zoneOpt)
mock.click(zoneOpt)
expect("picking another zone", strip(rows()[1].name.text) == "Fish in " .. zoneOpt.option.name
    and #char().prof.fishing.choices == 1)
mock.click(rows()[1])
mock.click(frame.detail.back)
expect("back to Craft Ladder's zone", strip(rows()[1].name.text) == "Fish in The Barrens"
    and #char().prof.fishing.choices == 0)
-- 125-225 joins three stretches (fish stop getting away elsewhere at 150 and 200): a zone picked there holds for all
mock.click(rows()[3])
local durotar
for _, o in ipairs(options()) do if o.option.zone == 14 then durotar = o end end
mock.click(durotar)
expect("a zone picked for 125-225 holds for all of it", strip(rows()[3].name.text) == "Fish in Durotar"
    and strip(rows()[3].sub.text):find("^125 %- 225"))
mock.click(rows()[3])
mock.click(frame.detail.back)
local fishRanks = rankRows()
expect("Fishing: Expert and Artisan on the way", #fishRanks == 2)
expect("hovering 'Learn Expert' shows the Expert Fishing book", hover(fishRanks[1]) == 16083)
mock.click(fishRanks[1])
expect("Expert Fishing: Old Man Heming with a pin, 1g", #places() == 1 and places()[1].npc == 2626
    and strip(places()[1].right.text) == "1g 0s 0c")
mock.click(rankRows()[2])
expect("Artisan Fishing: Nat Pagle, his four fish", #places() == 1 and places()[1].npc == 12919
    and lines():find("Feralas Ahi: Verdantis River") and strip(frame.detail.head.line2.text):find("level 35"))
mock.output = {}
SlashCmdList.CRAFTLADDER("chat fishing")
expect("chat printout of the Fishing ladder", said("fish in The Barrens") and said("catches"))

-- Skill + Gold: the same zones without getaways, ranked by gold an hour; the rows show what the catches are worth
expect("Fishing: Skill, Skill + Gold and Gold", frame.list.modes[2]:IsShown() and frame.list.modes[3]:IsShown())
mock.click(frame.list.modes[3])
expect("Skill + Gold: saved, active", char().prof.fishing.mode == "sell" and frame.list.modes[3].active)
expect("Skill + Gold: rows show what the catches earn", strip(rows()[1].cost.text):find("^%+"))
mock.click(rows()[1])
expect("Skill + Gold: zones show gold an hour", strip(options()[1].right.text):find("/ hour$"))
expect("Skill + Gold: footer says what you'd catch", strip(frame.total.text):find("^Spend .* catch about"))
-- Gold: no ladder, the zones by what an hour there earns at your skill
mock.click(frame.list.modes[2])
expect("Gold: saved, a list of zones", char().prof.fishing.mode == "gold" and rows()[1].step.hour
    and strip(rows()[1].sub.text):find("^an hour: ~%d+ catches") and strip(rows()[1].cost.text):find("^%+"))
mock.click(rows()[1])
expect("Gold: the zone's card, an hour at your skill, no other zones",
    strip(frame.detail.head.line1.text):find("^An hour at skill 78") and #options() == 0)
expect("Gold: the footer", strip(frame.total.text):find("zones at skill 78; the best"))
mock.output = {}
SlashCmdList.CRAFTLADDER("chat fishing")
expect("Gold: in chat", said("an hour") and said("zones by gold an hour"))
-- a pool GatherMate2 saw in Durotar counts there
GatherMate2FishDB = { [1411] = { [1] = 101, [2] = 101, [3] = 107 } }
mock.click(frame.list.modes[2])
local l = ns.Calculate(ns.FISHING)
expect("GatherMate2's pools in Durotar count", l.zones[14] and l.zones[14].pools
    and l.zones[14].pools[ns.FISHING.poolTiers["Floating Wreckage"][2]].seen)
GatherMate2FishDB = nil
mock.click(frame.list.modes[1])
expect("back to Skill mode", char().prof.fishing.mode == "skill")

-- catches counted: 60 catches, 15 points -> skill-ups at about the measured rate
mock.fishingLoot = true
for i = 1, 60 do
    mock.fire("LOOT_OPENED")
    if i % 4 == 0 then
        fx.fishing.skill = fx.fishing.skill + 1
        mock.fire("SKILL_LINES_CHANGED")
    end
end
mock.fishingLoot = false
local rate, log = ns.Fishing.Rate()
expect("60 catches and 15 points counted", log.catches == 60 and log.ups == 15)
expect("the measured rate replaces Classic's", rate ~= 1 and lines():find("from your 60 catches") == nil)
mock.click(tab("fishing"))
expect("the details say the rate is measured", lines():find("from your 60 catches"))
fx.fishing.skill = 78
mock.click(tab("firstaid"))

-- the Mining tab: zones to mine, the ore smelted on the way, buying ore and smelting it as an option
mock.click(tab("mining"))
expect("Mining tab: header", strip(frame.subtitle.text) == "Mining 70 / 150, the ladder to 300")
expect("Mining: asks to open the Smelting window", frame.list.note:IsShown()
    and strip(frame.list.note.text):find("Open your Smelting window"))
local firstMine = rows()[1].step
expect("Mining: the first step mines a zone of your side", firstMine.kind == "mine"
    and ns.MINING.zones[firstMine.zone].faction ~= "A" and strip(rows()[1].name.text):find("^Mine in "))
expect("Mining: the zone's nodes and the tin smelted on the way", #items() >= 2 and lines():find("Smelt Tin: about"))
expect("Mining: no Merchant's Favor box, nodes in the footer", not frame.favor:IsShown()
    and strip(frame.total.text):find("about %d+ nodes"))
rows()[1].scripts.OnEnter(rows()[1]); rows()[1].scripts.OnLeave(rows()[1])
expect("hovering a mining step works", true)
local mineOpt, smeltOpt
for _, o in ipairs(options()) do
    if o.option.kind == "mine" and not o.chosen then mineOpt = mineOpt or o end
    if o.option.kind == "smelt" then smeltOpt = smeltOpt or o end
end
expect("Mining: other zones and smelting to pick from", mineOpt and smeltOpt)
mineOpt.scripts.OnEnter(mineOpt); mineOpt.scripts.OnLeave(mineOpt)
smeltOpt.scripts.OnEnter(smeltOpt); smeltOpt.scripts.OnLeave(smeltOpt)
mock.click(mineOpt)
expect("picking another zone holds for the whole step", strip(rows()[1].name.text) == "Mine in " .. mineOpt.option.name
    and rows()[1].step.to == firstMine.to)
mock.click(rows()[1])
mock.click(frame.detail.back)
local again
for _, o in ipairs(options()) do if o.option.kind == "smelt" then again = again or o end end
mock.click(again)
expect("picking smelting: a smelting step that buys ore", rows()[1].step.kind == "craft"
    and strip(frame.detail.head.title.text) == again.option.name and #items() >= 1)
mock.click(frame.detail.back)
expect("back to mining", rows()[1].step.kind == "mine" and #char().prof.mining.choices == 0)
-- zones above your level are offered, marked red
local risky
for _, s in ipairs(rows()) do
    if s.step.kind == "mine" then
        mock.click(s)
        for _, o in ipairs(options()) do if o.option.dangerous then risky = o end end
        if risky then break end
    end
end
expect("Mining: a zone above your level is offered, marked", risky and strip(risky.name.text):find("creatures level %d+%+"))
-- Gold: gold an hour, ore or bars
expect("Mining: Skill, Skill + Gold and Gold", frame.list.modes[1]:IsShown() and frame.list.modes[2]:IsShown()
    and frame.list.modes[3].tooltip[2]:find("Grey nodes are mined too")
    and strip(frame.list.modes[1].label.text) == "Skill" and strip(frame.list.modes[3].label.text) == "Skill + Gold")
mock.click(frame.list.modes[3])
expect("Mining Skill + Gold: saved, rows show what you mine is worth", char().prof.mining.mode == "sell"
    and strip(rows()[1].cost.text):find("^%+"))
mock.click(rows()[1])
expect("Mining Skill + Gold: zones by gold an hour", strip(options()[1].right.text):find("/ hour$"))
expect("Mining Skill + Gold: ore or bars, and the assumption", lines():find("Tin Ore: .* as ore, .* as Tin Bar")
    and lines():find("Gold an hour assumes"))
expect("Mining Skill + Gold: the footer", strip(frame.total.text):find("^Spend .* mine about .* an hour"))
mock.click(frame.list.modes[2])
expect("Mining Gold: zones by gold an hour at your skill", char().prof.mining.mode == "gold"
    and rows()[1].step.hour and strip(rows()[1].sub.text):find("Ore %d+%%"))
mock.click(rows()[1])
expect("Mining Gold: the zone's card sells ore or bars, smelts nothing on the way",
    strip(frame.detail.head.line1.text):find("^An hour at skill") and lines():find("as ore")
    and not lines():find("Smelting gives skill%-ups") and #options() == 0)
mock.click(frame.list.modes[1])
mock.output = {}
SlashCmdList.CRAFTLADDER("chat mining")
expect("chat printout of the Mining ladder", said("mine in ") and said("nodes"))
local miniTip = CraftLadderMinimapButton
miniTip.scripts.OnEnter(miniTip); miniTip.scripts.OnLeave(miniTip)
expect("the minimap tooltip shows the Mining step", true)
mock.click(tab("firstaid"))

-- the Blacksmithing tab: Yungzug at 141 of 150, Mining 119
mock.click(tab("blacksmithing"))
expect("Blacksmithing tab: header", strip(frame.subtitle.text) == "Blacksmithing 141 / 150, the ladder to 300")
expect("Blacksmithing: Expert first", strip(rows()[1].name.text) == "Learn Expert")
expect("... the crafting modes: Sure cost, AH sales and Gold, named in their tooltips",
    strip(frame.list.modes[1].label.text) == "Sure cost" and strip(frame.list.modes[3].label.text) == "AH sales"
    and strip(frame.list.modes[2].label.text) == "Gold" and frame.list.modes[3].tooltip[1] == "AH sales")
expect("... what a step costs: red, with a minus", rows()[1].cost.text:sub(1, 11) == ns.UI.Hex(ns.UI.C.bad) .. "-")
mock.click(rows()[1])
expect("Expert Blacksmithing: only some trainers, the Horde's with pins", lines():find("Only these trainers teach it")
    and #places() == 2)
mock.click(rows()[2])
local made, smelted = false, false
for _, f in ipairs(items()) do
    local sub = strip(f.sub.text)
    made = made or sub:find("yourself from") ~= nil
    smelted = smelted or sub:find("^Smelt %d+ yourself from") ~= nil
end
expect("Blacksmithing: bars smelted from ore with your Mining", smelted and made)
expect("Blacksmithing: what selling it brings back", lines():find("back, so this step"))
expect("... and what one sells for, at the auction house and at a vendor", lines():find("ells for .+ at a vendor%."))
local sections = mock.shownChildren(frame.detail.scroll.child, "label")
expect("... Learn it first, then One craft", sections[1] and strip(sections[1].label.text) == "Learn it"
    and strip(sections[2].label.text):find("^One craft"))
local batch
for _, f in ipairs(sections) do if strip(f.label.text):find("^Batch: ") then batch = f end end
expect("... the Batch with its price, and what it all sells for", batch and lines():find("%d+ sell for .+ at a vendor%."))
expect("Blacksmithing: the footer counts the sales; the Merchant's Favor box (its quartermasters sell plans for it)",
    strip(frame.total.text):find("back from sales") and frame.favor:IsShown())
mock.output = {}
SlashCmdList.CRAFTLADDER("chat blacksmithing")
expect("chat printout of the Blacksmithing ladder", said("sell:") and said("back from sales"))
-- the Specialization button: the steps to Weaponsmith or Armorsmith instead of the ladder and its card
local function specLabels()
    local out = {}
    for _, f in ipairs(mock.shownChildren(frame.spec.scroll.child, "label")) do out[#out + 1] = strip(f.label.text) end
    return out
end
local function specLabel(start) -- the heading that starts so
    for _, l in ipairs(specLabels()) do if l:sub(1, #start) == start then return l end end
    return ""
end
local function specItems() return mock.shownChildren(frame.spec.scroll.child, "item") end
local function specItem(name)
    for _, f in ipairs(specItems()) do if strip(f.name.text):find(name, 1, true) then return f end end
end
local function specText()
    local out = {}
    for _, f in ipairs(mock.shownChildren(frame.spec.scroll.child, "text")) do
        if type(f.text) == "table" then out[#out + 1] = strip(f.text.text) end -- a line or a pin's
    end
    return table.concat(out, "\n")
end
expect("Blacksmithing: a Specialization button beside the modes", frame.list.spec:IsShown())
mock.click(frame.list.spec)
local labels = specLabels()
expect("... its steps instead of the ladder and its card, the button lit and no mode", frame.spec:IsShown()
    and not frame.list.scroll:IsShown() and not frame.detail:IsShown() and frame.list.spec.active
    and not frame.list.modes[1].active)
expect("... Weaponsmith first, the Horde's steps: Krathok, then Borgosh's quest, then a mastery",
    labels[1] == "Weaponsmith" and labels[3] == "1. Talk to Krathok Moltenfist"
    and labels[4] == "2. The Way of the Weaponsmith" and labels[5]:find("^3%. Master a weapon"))
expect("... what the quest asks, none had yet; level 40 and skill 200 needed",
    specItem("Moonsteel Broadsword") and strip(specItem("Moonsteel Broadsword").name.text):find("^0 / 4")
    and specText():find("Needs level 40 and Blacksmithing 200; you're level 28 with 141%."))
expect("... the recipes, the ingredients and what it all costs, in the footer too", labels[2] == "The recipes"
    and specText():find("Ingredients:") and strip(frame.total.text):find("^To Weaponsmith: about "))
-- the recipes fold, and stay folded (saved); open again
local function recipesHead()
    for _, f in ipairs(mock.shownChildren(frame.spec.scroll.child, "fold")) do
        if rawget(f, "toggle") then return f end
    end
end
local learnLines = select(2, specText():gsub("\nLearn ", ""))
mock.click(recipesHead())
expect("... the recipes fold: no recipe lines, how many to learn in the heading, saved",
    ns.Player.Prof(ns.BLACKSMITHING).specRecipesFolded == true and not specText():find("\nLearn ")
    and specLabel("The recipes"):find("%d+ to learn$") and learnLines > 0)
frame:Hide(); frame:Show()
expect("... still folded once the window opens again", not specText():find("\nLearn "))
mock.click(recipesHead())
expect("... and open again", ns.Player.Prof(ns.BLACKSMITHING).specRecipesFolded == nil
    and select(2, specText():gsub("\nLearn ", "")) == learnLines)
-- two broadswords in the bags; the quest in the log, then done (the talk before it too)
fx.blacksmithing.owned[3853] = 2
mock.questLog[5302] = 1
mock.fire("BAG_UPDATE_DELAYED"); mock.fire("QUEST_ACCEPTED", 1, 5302); mock.runTimers()
expect("... 2 of 4 broadswords; the quest in your log, so you talked to Krathok",
    strip(specItem("Moonsteel Broadsword").name.text):find("^2 / 4") and specLabel("2."):find("in your quest log$")
    and specLabel("1."):find("done$"))
mock.questsDone[5302], mock.questLog[5302] = true, nil
mock.fire("QUEST_TURNED_IN", 5302); mock.runTimers()
expect("... handed in: done, nothing left to bring or learn", specLabel("2."):find("done$") and not specItem("Moonsteel")
    and specLabel("The recipes") == "")
-- Armorsmith: picked and remembered; Hank the Hammer's quests are the Alliance's
mock.click(frame.spec.guides[2])
labels = specLabels()
expect("Armorsmith picked: remembered, the Horde's chain (Aturk, Ox), no Hank the Hammer",
    ns.Player.Prof(ns.BLACKSMITHING).spec == 9788 and labels[1] == "Armorsmith"
    and specText():find("Aturk the Anvil") and not specText():find("Hank the Hammer  "))
local galvan = false
for _, l in ipairs(labels) do galvan = galvan or l:find("The Mithril Order") ~= nil end
expect("... through Galvan to the last quest", galvan and labels[#labels]:find("The Art of the Armorsmith"))
-- a character with the specialization
mock.spells[9787] = true
mock.fire("LEARNED_SPELL_IN_TAB", 9787); mock.runTimers()
mock.click(frame.spec.guides[1])
expect("Weaponsmith learned: every step done but the mastery", specLabels()[1]:find("done$")
    and specLabel("2."):find("done$") and not specLabel("3."):find("done$")
    and strip(frame.total.text) == "You have Weaponsmith")
mock.spells[9787] = nil
fx.blacksmithing.owned[3853], mock.questsDone[5302] = nil, nil
-- the window opens again on the steps; a mode goes back to the ladder
frame:Hide(); frame:Show()
expect("... opened again: the steps still", frame.spec:IsShown())
mock.click(frame.list.modes[1])
expect("... a mode: back to the ladder and its card", not frame.spec:IsShown() and frame.list.scroll:IsShown()
    and frame.detail:IsShown() and frame.list.modes[1].active and not ns.Player.Prof(ns.BLACKSMITHING).specView)
-- the Merchant's Favor recipes: the bar over the list switches to them, with where you stand on each (with the
-- "Merchant's Favor recipes" box ticked: its setting shares the saved data, not the prices)
CraftLadderDB.favor = true
local calculate, calculations = ns.Calculate, 0
ns.Calculate = function(...) calculations = calculations + 1; return calculate(...) end
mock.click(frame.list.favor)
local toFavor = calculations
local favorRows = rows()
expect("Favor bar: the quartermaster's recipes instead of the ladder", #favorRows > 0
    and favorRows[1].step.kind == "favor" and strip(frame.list.favor.label.text) == "Back to your ladder"
    and strip(frame.total.text):find("^%d+ Merchant's Favor recipes, %d+ you can learn now"))
mock.click(favorRows[1])
expect("... a recipe's card: its price (the data's, seen at a quartermaster, or to be seen), level and skill",
    strip(frame.detail.head.title.text) == ns.BLACKSMITHING.recipes[favorRows[1].step.recipe].name
    and lines():find(favorRows[1].step.cost and "Costs %d+ Merchant's Favor" or "Its price: open a quartermaster once")
    and lines():find("From %d+ Blacksmithing %(you: %d+%)"))
-- its ingredients as the Skill ladder plans them: the bars you have, the rest smelted from your ore, what to buy
fx.blacksmithing.owned[2841], fx.mining.owned[2770], fx.mining.owned[2771] = 6, 20, 1
ns.Window.Refresh()
for _, r in ipairs(rows()) do if r.step.recipe == 1252260 then mock.click(r) end end -- Acolyte's Gloves: 10 Bronze Bar
local bars
for _, f in ipairs(items()) do if f.item == 2841 then bars = f end end
expect("... one craft as the ladder plans it: 6 Bronze Bar yours, 4 smelted from your ore (2 a smelt), 1 Tin Ore to buy",
    strip(frame.detail.head.title.text) == "Acolyte's Gloves" and bars
    and strip(bars.name.text):find("^10 .+%(you have 6%)$")
    and strip(bars.sub.text):find("^Smelt 4 yourself from ") and strip(bars.sub.text):find("2 [^,]+ %(you have them%)")
    and strip(bars.sub.text):find("2 [^,]+ %(buy 1%)"))
expect("... and the Craft bar, as on the Skill ladder's cards", frame.detail.craft.shown
    and strip(frame.detail.craft.note.text):find(ns.Player.Known(ns.BLACKSMITHING)[1252260] and "^Your bags allow %d+%.$"
        or "Learn the recipe first%."))
fx.blacksmithing.owned[2841], fx.mining.owned[2770], fx.mining.owned[2771] = nil, nil, nil
ns.Window.Refresh()
-- at the quartermaster: its price in favor and the level its tooltip asks are remembered
local favorRec = ns.BLACKSMITHING.recipes[favorRows[1].step.recipe]
local itemID, costInfo, costItem = GetMerchantItemID, GetMerchantItemCostInfo, GetMerchantItemCostItem
GetMerchantItemID = function() return favorRec.item end
GetMerchantItemCostInfo = function() return 1 end
GetMerchantItemCostItem = function() return 0, 45, "|cffffffff|Hcurrency:3402|h[Merchant's Favor]|h|r" end
C_TooltipInfo = { GetMerchantItem = function() return { lines = { { leftText = "Requires Level 30" } } } end }
mock.fire("MERCHANT_SHOW"); mock.runTimers()
GetMerchantItemID, GetMerchantItemCostInfo, GetMerchantItemCostItem, C_TooltipInfo = itemID, costInfo, costItem, nil
char().vendorPrices[favorRec.item] = nil
expect("... a quartermaster's recipe: 45 favor, from level 30, remembered (the Favor box's setting untouched)",
    CraftLadderDB.favorPrices and CraftLadderDB.favorPrices[favorRec.item].cost == 45
    and CraftLadderDB.favorPrices[favorRec.item].level == 30 and type(CraftLadderDB.favor) == "boolean")
-- one the data doesn't know is sold for favor is remembered too, with who sells it
local plainRec
for _, rec in pairs(ns.BLACKSMITHING.recipes) do
    local favored = false
    for _, g in ipairs(rec.get) do favored = favored or g.favor ~= nil end
    if rec.item and not favored and not plainRec then plainRec = rec end
end
GetMerchantItemID = function() return plainRec.item end
GetMerchantItemCostInfo = function() return 1 end
GetMerchantItemCostItem = function() return 0, 60, "|cffffffff|Hcurrency:3402|h[Merchant's Favor]|h|r" end
local unitGUID = UnitGUID
UnitGUID = function(unit) return unit == "npc" and "Creature-0-5250-0-1-248197-0000AB12CD" or unitGUID(unit) end
mock.fire("MERCHANT_SHOW"); mock.runTimers()
GetMerchantItemID, GetMerchantItemCostInfo, GetMerchantItemCostItem, UnitGUID = itemID, costInfo, costItem, unitGUID
expect("... and one the data didn't know is sold for favor, with its name and the quartermaster who sells it",
    CraftLadderDB.favorPrices[plainRec.item] and CraftLadderDB.favorPrices[plainRec.item].cost == 60
    and CraftLadderDB.favorPrices[plainRec.item].npc == 248197
    and CraftLadderDB.favorPrices[plainRec.item].name == "Mild Spices") -- the mock merchant's one name
CraftLadderDB.favorPrices[plainRec.item] = nil
ns.Window.Refresh()
expect("... and shown", strip(rows()[1].cost.text) == "45 favor")
C_Item.GetItemInfo = function() return "Gear", nil, 2, 30, 25, nil, nil, nil, "INVTYPE_HAND" end
ns.Window.Refresh()
mock.click(rows()[1])
expect("... the level to wear what it makes, in the row and the card", strip(rows()[1].sub.text):find("^lvl 25 %- ")
    and lines():find("is worn from level 25 %(you: %d+%)"))
-- an item the game never loads: looked at again a second later, 5 times at most
C_Item.GetItemInfo = function() return nil end
mock.runTimers()
mock.click(frame.list.favor); mock.click(frame.list.favor) -- back to the ladder and to the list: counted anew
local refresh, refreshes = ns.Window.Refresh, 0
ns.Window.Refresh = function(...) refreshes = refreshes + 1; return refresh(...) end
mock.runTimers()
ns.Window.Refresh = refresh
expect("... an item the game never loads: looked at 5 times more, then no more", refreshes == 5)
C_Item.GetItemInfo = nil
local beforeBack = calculations
mock.click(frame.list.favor)
expect("... the bar again: back to the ladder", rows()[1].step.kind ~= "favor")
expect("... switching there and back didn't calculate the ladder again", toFavor == 0 and calculations == beforeBack)
ns.Calculate = calculate
CraftLadderDB.favor = false
-- a Blacksmithing trainer: a guessed recipe it doesn't list (though it lists recipes that ask more) leaves the
-- ladder; one past what it lists stays a guess; one it lists gets its real skill
local function spellNamed(name)
    for spell, rec in pairs(ns.BLACKSMITHING.recipes) do if rec.name == name then return spell, rec end end
end
local war, warRec = spellNamed("Shining Mithril Helm")
local hammer, hammerRec = spellNamed("Arcanite Blacksmith Hammer")
expect("two guessed recipes", warRec.guess and hammerRec.guess)
-- a specialization's trainer lists only its own recipes: it says nothing of the guessed ones below them
mock.trainer = { { name = "Dark Iron Pulverizer", skillName = "Blacksmithing", skill = 265, cost = 50000 } }
mock.fire("TRAINER_SHOW"); mock.runTimers()
expect("a Weaponsmith trainer drops no guessed recipe", not warRec.notAtTrainer and CraftLadderDB.trainer[war] == nil)
mock.trainer = { { name = "Ornate Mithril Helm", skillName = "Blacksmithing", skill = 225, cost = 5000 } }
mock.fire("TRAINER_SHOW"); mock.runTimers()
expect("trainer: Shining Mithril Helm isn't taught here: dropped, and remembered",
    warRec.notAtTrainer and CraftLadderDB.trainer[war].notAtTrainer)
expect("trainer: Arcanite Blacksmith Hammer, past what it lists, stays a guess", hammerRec.guess
    and not hammerRec.notAtTrainer and CraftLadderDB.trainer[hammer] == nil)
-- a Russian client: the trainer lists recipes by the game's names, not ours
local spellName = C_Spell.GetSpellName
C_Spell.GetSpellName = function(id) return id == hammer and "Арканитовый молот кузнеца" or spellName(id) end
mock.trainer = { { name = "Арканитовый молот кузнеца", skillName = "Blacksmithing", skill = 265, cost = 6000 } }
mock.fire("TRAINER_SHOW"); mock.runTimers()
C_Spell.GetSpellName = spellName
expect("a Russian trainer: Arcanite Blacksmith Hammer learned at 265, no longer a guess", hammerRec.learn == 265
    and not hammerRec.guess and CraftLadderDB.trainer[hammer].cost == 6000)
expect("a dropped recipe can't be learned", ns.Ladder.LearnWay(ns.Ladder.NewContext(ns.BLACKSMITHING,
    { faction = "H", known = {} }, function() end, {}), war, warRec) == nil)
-- a trainer that teaches a recipe later than its pattern does waits till then (Slippers: pattern 140, trainer 150)
local slip, slipRec
for spell, rec in pairs(ns.TAILORING.recipes) do if rec.name == "Gilded Slippers" then slip, slipRec = spell, rec end end
local tailor = ns.Ladder.NewContext(ns.TAILORING, { faction = "H", known = {} }, function() end, {})
local at150 = ns.Ladder.LearnWay(tailor, slip, slipRec, 150)
expect("Slippers: no trainer at 140, the trainer at 150", ns.Ladder.LearnWay(tailor, slip, slipRec, 140) == nil
    and at150 and at150.kind == "trainer")
-- what isn't confirmed in Forever yet: a Classic quest's reward; nothing once you know the recipe
local helm, helmRec = spellNamed("Ornate Mithril Helm")
local smith = ns.Ladder.NewContext(ns.BLACKSMITHING, { faction = "H", known = {} }, function() end, {})
local helmWay = ns.Ladder.LearnWay(smith, helm, helmRec, 210)
expect("Ornate Mithril Helm: a Classic quest, unconfirmed", helmWay and helmWay.kind == "quest"
    and (ns.Describe.Unconfirmed(helmRec, helmWay) or ""):find("Classic"))
expect("... nothing to confirm once you know it", ns.Describe.Unconfirmed(helmRec, { kind = "known" }) == nil)
mock.trainer = {}
mock.click(tab("firstaid"))

-- the Engineering tab: the Arclight Spanner gets a step of its own; bolts made before the bombs are kept for them
mock.click(tab("engineering"))
expect("Engineering tab: header", strip(frame.subtitle.text) == "Engineering 38 / 75, the ladder to 300")
local spannerRow, keepRow
for _, r in ipairs(rows()) do
    if r.step.tool then spannerRow = spannerRow or r end
    if r.step.keep then keepRow = keepRow or r end
end
expect("Engineering: a step that makes the Arclight Spanner", spannerRow and strip(spannerRow.name.text) == "Arclight Spanner"
    and strip(spannerRow.sub.text):find("make one and keep it"))
mock.click(spannerRow)
expect("... its details say what it's for, and offer no other recipe", lines():find("A tool: %d+ Engineering recipes need it")
    and #options() == 0)
mock.click(keepRow)
expect("Engineering: what a step makes for later ones, to keep", lines():find("Keep %d+ .+: the steps at %d+ %- %d+ use them"))
mock.output = {}
SlashCmdList.CRAFTLADDER("chat engineering")
expect("chat printout of the Engineering ladder: the tool and what to keep", said("a tool: keep it") and said("keep %d+ "))
-- Skill: only vendors buy what you make; Skill + Gold: the auction house too
local function soldAtAH()
    for _, r in ipairs(rows()) do
        if r.step.sale and r.step.sale.ah > 0 then return true end
    end
    return false
end
expect("Engineering: Skill, Skill + Gold and Gold", frame.list.modes[1]:IsShown() and frame.list.modes[2]:IsShown()
    and frame.list.modes[3]:IsShown() and frame.list.modes[1].active)
expect("Engineering Skill: nothing sold at the auction house", not soldAtAH())
mock.click(frame.list.modes[3])
expect("Engineering Skill + Gold: the auction house buys some", frame.list.modes[3].active and soldAtAH())
-- Gold: what earns most now, the best first; at 300 the tab opens on it
mock.click(frame.list.modes[2])
local ahRow
for _, r in ipairs(rows()) do if not r.step.vendor then ahRow = ahRow or r end end
expect("Engineering Gold: what earns at the auction house, the best first", ahRow and ahRow.step.kind == "profit"
    and strip(ahRow.cost.text):find("^%+") and ahRow.step.color)
local toLearn
for _, r in ipairs(rows()) do if r.step.kind == "profit" and r.step.learn.cost > 0 then toLearn = toLearn or r end end
expect("... a recipe still to learn: the icon of where, no words to cut off", toLearn
    and strip(toLearn.sub.text):find(WAY_ICONS[toLearn.step.learn.kind], 1, true)
    and not strip(toLearn.sub.text):find("learn it"))
mock.click(ahRow)
expect("... its details: one craft, what selling it brings", lines():find("How many sell, the auction house doesn't say")
    and #items() > 0 and lines():find("ells for .+ at the auction house %(after its cut, %d+ listed%)"))
local goldHeads = headings()
local vendorGroup = false
for _, r in ipairs(rows()) do vendorGroup = vendorGroup or r.step.vendor == true end
expect("... the vendor heading only when something sells to a vendor, then the auction house's",
    strip(goldHeads[1].title.text) == (vendorGroup and "Sell to a vendor" or "Sell at the auction house"))
expect("... the footer: what sells at the auction house (and to a vendor, if anything)",
    strip(frame.total.text):find("%d+ at the auction house; the best %+")
    and (strip(frame.total.text):find("sell to a vendor") ~= nil) == vendorGroup)
mock.output = {}
SlashCmdList.CRAFTLADDER("chat engineering")
expect("... and in chat", said("sell to a vendor for more than they cost") and said("Sell at the auction house:"))
mock.click(frame.list.modes[1])
ns.Player.Prof(ns.ENGINEERING).mode = nil
fx.engineering.skill, fx.engineering.maxSkill = 300, 300
mock.click(tab("firstaid")); mock.click(tab("engineering"))
expect("Engineering at 300: Gold first", frame.list.modes[2].active and not frame.list.modes[1].active)
fx.engineering.skill, fx.engineering.maxSkill = 38, 75
mock.click(tab("firstaid"))

-- a profession the character hasn't got: shown (to plan it), but not in the menu
SlashCmdList.CRAFTLADDER("tailoring")
expect("/craft tailoring: its ladder, no menu entry", not tab("tailoring"):IsShown()
    and strip(frame.subtitle.text) == "No Tailoring yet" and #rows() > 0)
mock.click(tab("firstaid"))
-- Tailoring at 103 of 150 (Ho's): the same card and modes as the other crafting professions that sell
fx.tailoring.skill, fx.tailoring.maxSkill = 103, 150
SlashCmdList.CRAFTLADDER("tailoring")
expect("Tailoring: the crafting card (Learn it, One craft, Batch)", clickFirstCraft() and craftCard())
expect("... Skill, Skill + Gold and Gold", frame.list.modes[1]:IsShown() and frame.list.modes[2]:IsShown()
    and frame.list.modes[3]:IsShown())
mock.click(frame.list.modes[2])
local goldRow = rows()[1]
if goldRow then mock.click(goldRow) end
local goldCard = mock.shownChildren(frame.detail.scroll.child, "label")
expect("... Gold: Learn it first, then One craft", goldRow and goldRow.step.kind == "profit"
    and strip(goldCard[1].label.text) == "Learn it" and strip(goldCard[2].label.text):find("^One craft"))
-- what sells to a vendor for more than it costs comes first, under a heading that folds
local function vendorShown()
    for _, r in ipairs(rows()) do if r.step.vendor then return true end end
    return false
end
local vendorHead = headings()[1]
expect("... Gold: \"Sell to a vendor\" first, then \"Sell at the auction house\"", vendorHead
    and strip(vendorHead.title.text) == "Sell to a vendor" and rows()[1].step.vendor and vendorShown()
    and strip(headings()[2].title.text) == "Sell at the auction house")
mock.click(vendorHead)
expect("... the vendor group folds, and stays folded", not vendorShown() and char().prof.tailoring.vendorFolded)
mock.click(headings()[1])
expect("... and opens again", vendorShown() and not char().prof.tailoring.vendorFolded)
mock.click(frame.list.modes[1])
fx.tailoring.skill, fx.tailoring.maxSkill = 0, 0
-- Enchanting at 60 of 75: an enchantment's card says there's nothing to sell
fx.enchanting.skill, fx.enchanting.maxSkill = 60, 75
SlashCmdList.CRAFTLADDER("enchanting")
local enchRow
for _, r in ipairs(rows()) do
    if r.step.kind == "craft" and not ns.ENCHANTING.recipes[r.step.recipe].makes then enchRow = enchRow or r end
end
if enchRow then mock.click(enchRow) end
expect("Enchanting: an enchantment's card: Learn it, One craft, Batch, nothing to sell", enchRow and craftCard()
    and lines():find("An enchantment: nothing to sell%."))
-- at 230 of 300: a recipe only Annora teaches names her
fx.enchanting.skill, fx.enchanting.maxSkill = 230, 300
SlashCmdList.CRAFTLADDER("enchanting")
local annoraRow
for _, r in ipairs(rows()) do
    local rec = r.step.kind == "craft" and ns.ENCHANTING.recipes[r.step.recipe]
    if rec and rec.trainers and r.step.learn.kind == "trainer" then annoraRow = annoraRow or r end
end
if annoraRow then mock.click(annoraRow) end
expect("Enchanting: a recipe few trainers teach names them", annoraRow and lines():find("Only these trainers teach it")
    and #places() >= 1)
fx.enchanting.skill, fx.enchanting.maxSkill = 0, 0
-- Alchemy at 290 of 300: the Philosopher's Stone comes after the ladder, "needed for transmutes and more"
fx.alchemy.skill, fx.alchemy.maxSkill = 290, 300
SlashCmdList.CRAFTLADDER("alchemy")
local lastRow = rows()[#rows()]
expect("Alchemy: the Philosopher's Stone last, needed for transmutes", lastRow and lastRow.step.late
    and strip(lastRow.sub.text):find("needed for transmutes"))
mock.click(lastRow)
expect("... its card says none of its recipes is for leveling", lines():find("None of them is for leveling"))
fx.alchemy.skill, fx.alchemy.maxSkill = 0, 0
-- Enchanting's Disenchant mode (Ho: Enchanting 150, Tailoring 103, prices from both snapshots): what's worth more
-- disenchanted than sold, what you have first; every disenchant recorded
local function hoDisenchant(on)
    local hoT = dofile(root .. "tests/fixtures/ho_tailoring.lua")
    local hoE = dofile(root .. "tests/fixtures/ho_enchanting.lua")
    local house = AuctionDB.sv.houses[UnitFactionGroup()]
    for _, ah in ipairs({ hoT.ah, hoE.ah }) do
        for item, e in pairs(ah) do
            if on and not house.items[item] then house.items[item] = { e, ho = true }
            elseif not on and house.items[item] and house.items[item].ho then house.items[item] = nil end
        end
    end
    house.scans[1][1] = fx.scanTs + (on and 1 or 0) -- the addon reads prices again
    fx.enchanting.skill, fx.enchanting.maxSkill = on and 150 or 0, on and 150 or 0
    fx.tailoring.skill, fx.tailoring.maxSkill = on and 103 or 0, on and 150 or 0
    ns.Player.Prof(ns.TAILORING).known = on and hoT.known or {}
    ns.Player.Prof(ns.ENCHANTING).mode = on and "disenchant" or nil
    ns.Window.Invalidate()
end
do
    hoDisenchant(true)
    ns.Player.Prof(ns.ENCHANTING).mode = nil
    SlashCmdList.CRAFTLADDER("enchanting")
    local deButton = frame.list.modes[5]
    expect("Enchanting: a Disenchant mode", deButton:IsShown() and strip(deButton.label.text) == "Disenchant (beta)")
    mock.click(deButton)
    local deRows = rows()
    local made = #deRows
    local loss = deRows[made]
    expect("... Disenchant: Ho's Tailoring, under \"Make and disenchant\", the best first, red at a loss",
        deButton.active and made >= 2 and deRows[1].step.kind == "disenchant"
        and strip(headings()[1].title.text) == "Make and disenchant" and loss.step.profit < 0
        and strip(loss.cost.text):find("^%-") and deRows[1].step.profit >= loss.step.profit
        and strip(deRows[1].sub.text):find("^Tailoring, disenchanted ~"))
    loss.scripts.OnEnter(loss)
    mock.click(loss)
    expect("... its card: what one disenchant gives, a batch, the Craft bar, one craft", frame.detail.craft:IsShown()
        and lines():find("10 disenchanted: about .+, at least .+ 9 times out of 10") and #items() > 2
        and lines():find("Making it costs more than disenchanting brings"))
    expect("... the footer", strip(frame.total.text):find("^In your bags 0 to disenchant, 0 to sell; %d+ worth making"))
    -- the bags: Linen Cloth (nothing to disenchant), two Double-stitched Woolen Shoulders, a green sword no recipe
    -- makes (what the game says of it): "In your bags" first, the shoulders no longer among what to make
    local shoulders, sword, locked = ns.TAILORING.recipes[3848].makes, 15210, false
    local bagItems = { 2589, shoulders, shoulders, sword }
    C_Container = { GetContainerNumSlots = function(bag) return bag == 0 and #bagItems or 0 end,
                    GetContainerItemInfo = function(_, slot)
                        return { itemID = bagItems[slot], stackCount = 1, isBound = false,
                                 isLocked = locked and slot == 2 } end }
    C_Item.GetItemInfo = function(item)
        if item == sword then return "Raider Shortsword", "", 2, 20, 15, "", "", 1, "INVTYPE_WEAPON", 0, 500, 2, 7 end
        return "x", "", 1, 5, 1, "", "", 20, "", 0, item == shoulders and 381 or 1, 7, 0
    end
    fx.tailoring.owned[shoulders], fx.tailoring.owned[sword] = 2, 1 -- the game's count of them
    mock.fire("BAG_UPDATE_DELAYED"); mock.runTimers()
    deRows = rows()
    local bagRows = {}
    for _, r in ipairs(deRows) do if r.step.kind == "bag" then bagRows[r.step.item] = r end end
    expect("... the bags first, under their own heading, the shoulders a row of 2, the sword too",
        strip(headings()[1].title.text) == "In your bags" and deRows[1].step.kind == "bag" and #deRows == made + 1
        and bagRows[shoulders] and bagRows[shoulders].step.count == 2 and bagRows[sword] and not bagRows[2589]
        and strip(bagRows[shoulders].sub.text):find("^disenchant: ~"))
    bagRows[shoulders].scripts.OnEnter(bagRows[shoulders])
    mock.click(bagRows[shoulders])
    expect("... its card: yours disenchanted, or sold, no Craft bar", not frame.detail.craft:IsShown()
        and lines():find("Your 2 disenchanted: about") and lines():find("each at a vendor"))
    mock.output = {}
    SlashCmdList.CRAFTLADDER("chat enchanting")
    expect("... and in chat", said("In your bags:") and said("Make and disenchant:")
        and said("in your bags %d+ to disenchant, %d+ to sell; worth more disenchanted than sold: " .. (made - 1)
            .. " to make"))
    -- a disenchant: the item the game locked while casting, what the loot window gave
    GetTime = function() return 1000 end
    locked = true
    local loot = { { 10940, 3 }, { 10998, 1 } }
    GetNumLootItems = function() return #loot end
    GetLootSlotLink = function(i) return ("|cffffffff|Hitem:%d::::::::|h[x]|h|r"):format(loot[i][1]) end
    GetLootSlotInfo = function(i) return 134400, "x", loot[i][2] end
    mock.fire("UNIT_SPELLCAST_START", "player", "Cast-9", 13262)
    mock.fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-9", 13262)
    mock.fire("LOOT_OPENED")
    mock.fire("LOOT_OPENED") -- another loot window: not a disenchant's
    expect("Disenchanting: what it gave is recorded, once", CraftLadderDB.disenchantLog
        and #CraftLadderDB.disenchantLog == 1
        and CraftLadderDB.disenchantLog[1]:find(("^%d %%d+ 10940:3 10998:1$"):format(shoulders)))
    C_Container, GetNumLootItems, GetLootSlotLink, GetLootSlotInfo, C_Item.GetItemInfo = nil, nil, nil, nil, nil
    fx.tailoring.owned[shoulders], fx.tailoring.owned[sword] = nil, nil
    hoDisenchant(false)
    mock.click(tab("firstaid"))
end
mock.click(tab("firstaid"))

-- Skinning at 100 of 150, a level 28: where to skin, the creatures there; skinning a creature new in Forever records it
fx.skinning.skill, fx.skinning.maxSkill = 100, 150
SlashCmdList.CRAFTLADDER("skinning")
expect("Skinning tab: rows to skin in a zone", rows()[1] and strip(rows()[1].name.text):find("^Skin in ")
    and strip(rows()[1].sub.text):find("^%d+ %- %d+: .*Leather") and strip(rows()[1].cost.text):find("creatures$"))
expect("... a gathering profession's modes keep their names after a crafting one's",
    strip(frame.list.modes[1].label.text) == "Skill" and strip(frame.list.modes[3].label.text) == "Skill + Gold")
mock.click(rows()[1])
expect("... its card lists the creatures there, with their level", lines():find("Which creatures can be skinned")
    and #items() > 0 and strip(items()[1].name.text):find("level %d+"))
mock.click(frame.list.modes[2])
expect("Skinning Gold: zones by gold an hour", rows()[1] and rows()[1].step.hour
    and strip(rows()[1].sub.text):find("Leather %d+%%"))
mock.click(rows()[1])
expect("... its card: an hour at your skill, the ride counted", strip(frame.detail.head.line1.text):find("^An hour at skill 100")
    and lines():find("a 60%% mount between them") and #items() > 0 and #options() == 0)
mock.click(frame.list.modes[1])
mock.output = {}
SlashCmdList.CRAFTLADDER("chat skinning")
expect("... and in chat", said("skin in "))
local newMob, cand = next(ns.SKINNING.candidates)
GetTime = function() return 1000 end
GetNumLootItems = function() return 1 end
GetLootSourceInfo = function() return ("Creature-0-1-2-3-%d-0000ABCD"):format(newMob) end
GetLootSlotLink = function() return "|cffffffff|Hitem:2318::::::::|h[Light Leather]|h|r" end
GetLootSlotInfo = function() return 134400, "Light Leather", 2 end
mock.fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-1", 8613)
mock.fire("LOOT_OPENED")
expect("Skinning: a creature new in Forever, skinned, is recorded and joins the ladder",
    CraftLadderDB.skinLog[newMob] and CraftLadderDB.skinLog[newMob].skins == 1 and ns.SKINNING.nodes[newMob]
    and ns.SKINNING.nodes[newMob].recorded)
-- a vein mined (twice: one record) and where: kept for measuring how often each kind takes a shared spot
GetLootSourceInfo = function() return "GameObject-0-1-2-3-1733-0000BEEF" end
C_Map.GetBestMapForUnit = function() return 1418 end
C_Map.GetPlayerMapPosition = function() return { GetXY = function() return 0.45671, 0.12344 end } end
for _ = 1, 2 do
    mock.fire("UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-2", 2575)
    mock.fire("LOOT_OPENED")
end
expect("Mining: a gathered vein is recorded once, with where it was", CraftLadderDB.gatherLog
    and #CraftLadderDB.gatherLog == 1 and CraftLadderDB.gatherLog[1]:find("^mining 1733 1418 0%.4567 0%.1234 %d+$"))
fx.skinning.skill, fx.skinning.maxSkill = 0, 0
-- Herbalism at 100 of 150: where to gather, the herbs there, nothing to smelt
fx.herbalism.skill, fx.herbalism.maxSkill = 100, 150
SlashCmdList.CRAFTLADDER("herbalism")
expect("Herbalism tab: rows to gather in a zone", rows()[1] and strip(rows()[1].name.text):find("^Gather in ")
    and strip(rows()[1].cost.text):find("herbs$"))
mock.click(rows()[1])
expect("... its card lists the herbs there, nothing about smelting", #items() > 0
    and lines():find("Herb places come from GatherMate2") and not lines():find("smelt"))
expect("Herbalism: its own words in the mode tips", frame.list.modes[3].tooltip[2]:find("herb"))
mock.click(frame.list.modes[2])
mock.click(rows()[1])
expect("Herbalism Gold: a zone's card, an hour of herbs", strip(frame.detail.head.line1.text):find("herbs")
    and lines():find("Gold an hour assumes 15 s a herb"))
mock.click(frame.list.modes[1])
fx.herbalism.skill, fx.herbalism.maxSkill = 0, 0
-- Lockpicking: a level 28 orc rogue at 100 of 140: every lock first, zones of chests, a level gate at the cap
expect("Lockpicking: not in a warrior's menu", not tab("lockpicking"):IsShown())
mock.class = "ROGUE"
mock.lockpicking.skill, mock.lockpicking.maxSkill = 100, 140
SlashCmdList.CRAFTLADDER("lockpicking")
expect("Lockpicking tab: All locks first, then a zone", strip(rows()[1].name.text) == "All locks"
    and strip(rows()[2].name.text):find("^Pick locks in ") and strip(rows()[2].cost.text):find("locks$"))
expect("... no mode buttons", not frame.list.modes[1]:IsShown() and not frame.list.modes[2]:IsShown())
local gate
for _, r in ipairs(rows()) do if strip(r.name.text) == "Reach level 30" then gate = r end end
expect("... a level gate at the cap: level 30 for 150", gate and strip(gate.sub.text) == "at 140, raises your cap to 150")
mock.click(gate)
expect("... its card says the cap is the level x 5", strip(frame.detail.head.line1.text):find("level x 5"))
mock.click(rows()[1])
expect("All locks: chests, boxes, doors and the orc's class quests", #items() > 25
    and lines():find("Blackrock Depths: 13 locked doors") and lines():find("To Orgrimmar!")
    and lines():find("Plundering the Plunderers") and #places() >= 4)
rows()[1].scripts.OnEnter(rows()[1]); rows()[1].scripts.OnLeave(rows()[1])
mock.click(rows()[2])
expect("a zone's card: its locks, where they are, other zones", strip(frame.detail.head.title.text):find("^Pick locks in ")
    and #items() > 0 and lines():find("Chest places") and #options() > 1)
local pins = #mock.waypoints
mock.click(places()[1])
expect("... a click on where they are pins it", #mock.waypoints == pins + 1)
mock.output = {}
SlashCmdList.CRAFTLADDER("chat lockpicking")
expect("... and in chat", said("pick locks in ") and said("reach level 30"))
-- not learned yet, level 28: Learn Pick Lock first (a rogue sees the tab anyway), with Thieves' Tools and the quests
mock.lockpicking.skill, mock.lockpicking.maxSkill = 0, 0
mock.fire("SKILL_LINES_CHANGED")
mock.click(tab("firstaid"))
local classShown = false
for _, h in ipairs(frame.menu.heads) do classShown = classShown or h:IsShown() and h.text == "CLASS" end
expect("... a rogue's menu has it without the skill, in the Class group", tab("lockpicking"):IsShown() and classShown
    and strip(tab("lockpicking").skill.text) == "not learned")
mock.click(tab("lockpicking"))
expect("Learn Pick Lock first", strip(rows()[2].name.text) == "Learn Pick Lock")
mock.click(rows()[2])
expect("... from any rogue trainer, Thieves' Tools to bring, the class quests", lines():find("Any Rogue trainer")
    and #items() == 1 and lines():find("Zando'zan"))
-- Poisons: a level 28 rogue at 100 of 140: crafting steps, gates at the cap, recipes from a rogue trainer at a level
mock.poisons.skill, mock.poisons.maxSkill = 100, 140
mock.click(tab("poisons"))
expect("Poisons tab: no mode buttons, a gate at the cap", not frame.list.modes[1]:IsShown()
    and (function()
        for _, r in ipairs(rows()) do if strip(r.name.text) == "Reach level 30" then return true end end
    end)())
local learned
for _, r in ipairs(rows()) do
    if r.step.kind == "craft" and r.step.learn.kind == "trainer" then learned = learned or r end
end
mock.click(learned)
expect("... a recipe from a rogue trainer, from its level", lines():find("Rogue trainer, .*, from level %d+"))
-- not learned yet: the class quest at 20 (Horde: Hinott's Assistance), its chain, the Lockpicking it needs
mock.poisons.skill, mock.poisons.maxSkill = 0, 0
mock.fire("SKILL_LINES_CHANGED")
mock.click(tab("firstaid"))
mock.click(tab("poisons"))
expect("Learn Poisons first", strip(rows()[1].name.text) == "Learn Poisons")
mock.click(rows()[1])
expect("... the quest and the chain to it", lines():find("Hinott's Assistance") and lines():find("The Shattered Salute")
    and lines():find("Lockpicking 70"))
mock.class = "WARRIOR"
mock.click(tab("firstaid"))

-- crafting while the window is open: one recalculation 2 seconds after a burst of events
local calcs = 0
local real = ns.Calculate
ns.Calculate = function(...) calcs = calcs + 1; return real(...) end
mock.fire("CHAT_MSG_SKILL"); mock.fire("BAG_UPDATE_DELAYED"); mock.fire("SKILL_LINES_CHANGED")
mock.runTimers()
expect("one recalculation for a burst of events", calcs == 1)

-- closed: nothing listens
SlashCmdList.CRAFTLADDER("")
expect("/craft closes it", not frame:IsShown())
calcs = 0
mock.fire("CHAT_MSG_SKILL"); mock.runTimers()
expect("no work while closed", calcs == 0)
SlashCmdList.CRAFTLADDER("")
expect("reopening shows First Aid again", tab("firstaid").active)
SlashCmdList.CRAFTLADDER("")

-- the minimap button
local mini = CraftLadderMinimapButton
expect("minimap button made at login, shown", mini and mini:IsShown())
mini.scripts.OnEnter(mini); mini.scripts.OnLeave(mini)
mock.click(mini)
expect("minimap click opens the window", frame:IsShown())
mock.click(mini)
expect("minimap click again closes it", not frame:IsShown())
mock.output = {}
mock.click(mini, "RightButton")
expect("minimap right-click prints the ladder of the profession shown", said("First Aid 133") and said("total"))
mock.cursor = { 100, 200 } -- straight above the minimap's centre (100, 100)
mini.scripts.OnDragStart(mini)
expect("dragging updates while moving", mini.scripts.OnUpdate ~= nil)
mini.scripts.OnUpdate(mini)
mini.scripts.OnDragStop(mini)
expect("dragging saves the angle (90 = top)", math.abs(CraftLadderDB.minimap.angle - 90) < 0.01)
expect("no updates once dropped", mini.scripts.OnUpdate == nil)
SlashCmdList.CRAFTLADDER("minimap")
expect("/craft minimap hides it", not mini:IsShown() and CraftLadderDB.minimap.hide == true)
SlashCmdList.CRAFTLADDER("minimap")
expect("/craft minimap shows it again", mini:IsShown())

-- the bank as Bagnon saw it, cooked first; and AuctionDB's next scan
BrotherBags.forever[fx.name .. " Test"] = { [0] = { items = { "117;3" } }, [6] = { items = { "6289;5" } } }
mock.scanCooldown = 432
SlashCmdList.CRAFTLADDER("cooking")
expect("5 Raw Longjaw Mud Snapper from Bagnon's bank count", ns.Player.State(ns.COOKING).owned[6289] == 5)
expect("bags aren't counted twice from Bagnon", (ns.Player.State(ns.COOKING).owned[117] or 0) == 0)
mock.fire("BANKFRAME_OPENED") -- the game counts the bank now; Bagnon's copy is saved only when it closes
expect("the bank open: only the game's count of it (the fish just taken out aren't counted twice)",
    ns.Player.State(ns.COOKING).owned[6289] == nil)
mock.fire("BANKFRAME_CLOSED")
expect("... closed: Bagnon's copy counts again", ns.Player.State(ns.COOKING).owned[6289] == 5)
-- (Strider Stew from the bags' meat pays better: the bank's fish are an option of the first step)
mock.click(rows()[1])
local bankFish
for _, o in ipairs(options()) do
    if o.option.name == "Longjaw Mud Snapper" and o.option.fromBags then bankFish = o end
end
expect("the bank's fish: an option to cook them first", bankFish ~= nil)
mock.click(bankFish)
expect("... picked: the ladder cooks them first", strip(rows()[1].name.text) == "Longjaw Mud Snapper"
    and strip(rows()[1].sub.text):find("INV_Misc_Bag", 1, true) and rows()[1].step.to == 90)
expect("... under its cost: all ready, what you have covers it", strip(rows()[1].ready.text) == "all ready"
    and not strip(rows()[1].sub.text):find(" now"))
mock.click(rows()[1])
local bagLine
for _, c in ipairs(frame.detail.scroll.child.children) do
    local t = rawget(c, "text")
    if c.shown and type(t) == "table" and strip(t.text):find("what you already have: %d+ crafts") then bagLine = c end
end
expect("... its card says so first, right under the title", bagLine and bagLine.point[3] == -58)
expect("its ingredient says it's in the bank", strip(items()[2].name.text):find("in the bank"))
-- the row you looked at stays picked: closing the window, another tab
mock.click(rows()[2])
local picked = frame.detail.head.step.from
frame:Hide(); frame:Show()
expect("the row you looked at is still picked when the window opens again", picked ~= rows()[1].step.from
    and frame.detail.head.step.from == picked)
mock.click(tab("firstaid")); mock.click(tab("cooking"))
expect("... and after another tab", frame.detail.head.step.from == picked)
expect("footer: next AuctionDB scan in 7:12", strip(frame.nextScan.text) == "Next AuctionDB scan in 7:12")
local ticker = mock.tickers[#mock.tickers]
mock.scanCooldown = 0
ticker.fn()
expect("the countdown ticks without a recalculation", strip(frame.nextScan.text):find("when you open"))
-- AuctionDB scans again while the window is open: the ladder calculated again with its prices, once
do
    local scans, calc, n = AuctionDB.sv.houses[UnitFactionGroup()].scans, ns.Calculate, 0
    ns.Calculate = function(...) n = n + 1; return calc(...) end
    ticker.fn()
    local before = n
    scans[#scans + 1] = { fx.scanTs + 900, 0, 0 }
    ticker.fn(); ticker.fn()
    expect("a new AuctionDB scan: the ladder calculated again, once; none before it", before == 0 and n == 1)
    scans[#scans] = nil
    ns.Calculate = calc
end
SlashCmdList.CRAFTLADDER("")
expect("closing stops the countdown", ticker.cancelled)
BrotherBags.forever[fx.name .. " Test"] = {}
mock.fire("BAG_UPDATE_DELAYED") -- the bank seen again: the bags changed, as the game says

-- Skill, Skill + Gold and back: the mode calculated before is drawn again
SlashCmdList.CRAFTLADDER("") -- open
mock.click(tab("blacksmithing"))
local calc3, calcs3 = ns.Calculate, 0
ns.Calculate = function(...) calcs3 = calcs3 + 1; return calc3(...) end
local skillMode, sellMode = frame.list.modes[1], frame.list.modes[3]
mock.click(sellMode)
local afterSell = calcs3
mock.click(skillMode); mock.click(sellMode); mock.click(skillMode)
expect("modes: back to one already calculated, no calculation", frame:IsShown() and afterSell <= 1 and calcs3 == afterSell)
ns.Calculate = calc3
mock.click(tab("cooking"))
SlashCmdList.CRAFTLADDER("") -- closed again

-- opened again with nothing changed: drawn from the last ladder, not calculated again; bags changed in other items
-- than the profession's: the same
SlashCmdList.CRAFTLADDER("") -- open (calculated if something changed meanwhile), then closed again
SlashCmdList.CRAFTLADDER("")
local calc2, calcs2 = ns.Calculate, 0
ns.Calculate = function(...) calcs2 = calcs2 + 1; return calc2(...) end
mock.fire("BAG_UPDATE_DELAYED")
SlashCmdList.CRAFTLADDER("")
expect("reopened with nothing that matters changed: no calculation", frame:IsShown() and calcs2 == 0)
SlashCmdList.CRAFTLADDER("")
mock.fire("PLAYER_LEVEL_UP")
SlashCmdList.CRAFTLADDER("")
expect("... a level up while it was closed: calculated once on opening", frame:IsShown() and calcs2 == 1)
ns.Calculate = calc2
SlashCmdList.CRAFTLADDER("")

-- at 150 of 150 the ladder goes on with the Expert rank-up
fx.skill = 150
mock.fire("SKILL_LINES_CHANGED") -- while the window is closed: noted, calculated when it opens
SlashCmdList.CRAFTLADDER("")
expect("at the rank's cap: Learn Expert comes first", strip(rows()[1].name.text) == "Learn Expert")
SlashCmdList.CRAFTLADDER("")

-- done: 300
fx.skill, fx.maxSkill = 300, 300
mock.fire("SKILL_LINES_CHANGED")
SlashCmdList.CRAFTLADDER("")
expect("at 300: Gold, what pays to cook", frame.list.modes[2].active and #rows() > 0)
SlashCmdList.CRAFTLADDER("")

-- no First Aid at all
fx.firstaid.skill, fx.firstaid.maxSkill = 0, 0
SlashCmdList.CRAFTLADDER("first aid")
expect("no First Aid: says how to learn it", strip(frame.detail.head.title.text) == "No First Aid yet"
    and strip(frame.subtitle.text) == "No First Aid yet")

SlashCmdList.CRAFTLADDER("status")
expect("status reports both professions and the calculation time", said("First Aid: data") and said("Last calculation"))
expect("status counts the guessed recipes", said("guessed as a trainer's"))
expect("/chef still works", SLASH_CRAFTLADDER2 == "/chef")

-- the auction house tab: what the step needs, bought there: the price asked first, then bought on the second click
hooksecurefunc = hooksecurefunc or function(t, name, f)
    local old = t[name]
    t[name] = function(...) local r = old(...); f(...); return r end
end
AuctionHouseFrame = CreateFrame("Frame")
AuctionHouseFrame.Tabs = { CreateFrame("Button") }
AuctionHouseFrame.SetDisplayMode = function() end
local started, confirmed
C_AuctionHouse = { IsThrottledMessageSystemReady = function() return true end,
                   StartCommoditiesPurchase = function(item, n) started = { item, n } end,
                   ConfirmCommoditiesPurchase = function(item, n) confirmed = { item, n } end }
char().ahProf = "blacksmithing"
mock.fire("AUCTION_HOUSE_SHOW")
local ahPanel = ns.AuctionTab.panel
mock.click(ahPanel.tab)
local ahRows = mock.shownChildren(ahPanel.scroll.child, "item")
expect("auction house tab: Blacksmithing's step, a row per reagent to buy with how many", ahPanel:IsShown()
    and strip(ahPanel.heading.text):find("^Blacksmithing: ") and #ahRows > 0 and tonumber(ahRows[1].count.text) > 0)
local ahRow = ahRows[1]
ahRow.count:SetText("5")
mock.click(ahRow.button)
expect("... Buy asks the price of 5", started and started[1] == ahRow.item and started[2] == 5 and not confirmed)
mock.fire("COMMODITY_PRICE_UPDATED", 120, 600)
expect("... then says the total; the other rows wait", strip(ahRow.button.label.text) == "Confirm 6s 0c"
    and (not ahRows[2] or not ahRows[2].button:IsEnabled()))
mock.click(ahRow.button)
mock.fire("COMMODITY_PURCHASE_SUCCEEDED")
expect("... the second click buys them", confirmed and confirmed[1] == ahRow.item and confirmed[2] == 5
    and strip(ahPanel.status.text):find("^Bought 5 "))
local searched
Auctionator = { API = { v1 = { MultiSearchAdvanced = function(id, terms) searched = { id, terms } end } } }
C_Item.GetItemNameByID = function(item) return ns.Lookup("items", item) end
mock.click(ahPanel.tab)
local ahSteps = mock.shownChildren(ahPanel.scroll.child, "entry")
local ahStep = ahSteps[#ahSteps]
local before = #mock.shownChildren(ahPanel.scroll.child, "item")
expect("... a row per step, none for the whole ladder; a + / - and a Search button on one with something to buy",
    #ahSteps > 1 and ahSteps[1].entry.step and #ahStep.entry.rows > 0 and ahStep.fold:IsShown()
    and ahStep.search:IsShown())
mock.click(ahStep)
local after = #mock.shownChildren(ahPanel.scroll.child, "item")
expect("... a click on a step unfolds or folds its reagents, and searches nothing", not searched
    and math.abs(after - before) == #ahStep.entry.rows)
if after < before then mock.click(ahStep) end -- it was open: open again
local ahNeeds = mock.shownChildren(ahPanel.scroll.child, "item")
mock.click(ahStep.search)
expect("... its Search button: Auctionator's list of what it buys, exact names and how many", searched
    and searched[1] == "CraftLadder" and #searched[2] == #ahStep.entry.rows and searched[2][1].isExact
    and searched[2][1].searchString == ns.Lookup("items", ahStep.entry.rows[1].item)
    and searched[2][1].quantity == ahStep.entry.rows[1].buy)
ahNeeds[1].count:SetText("7")
mock.click(ahNeeds[1])
expect("... a reagent's click searches only it, as many as its box says", #searched[2] == 1
    and searched[2][1].quantity == 7)
-- a rank whose quest asks for items (Expert Cooking's): a row of its own
local calculate = ns.Calculate
ns.Calculate = function(d)
    local ladder, lookup, ms = calculate(d)
    table.insert(ladder.steps, 1, { kind = "rank", from = 125, to = 125, cost = 0,
                                    rank = { name = "Expert Blacksmithing", cap = 225, how = "quest" },
                                    buy = { [2840] = { need = 4, have = 0, buy = 4 } } })
    return ladder, lookup, ms
end
ns.Window.Invalidate()
ns.AuctionTab.Refresh()
local rankRow = mock.shownChildren(ahPanel.scroll.child, "entry")[1]
mock.click(rankRow)
expect("... a rank that asks for items: its row says what it teaches, and folds", rankRow.entry.step.kind == "rank"
    and strip(rankRow.name.text) == "Learn Expert Blacksmithing")
-- a step that smelts 10 of its Bronze Bars and buys the other 10 (stretches joined): the ore and the bought bars
ns.Calculate = function(d)
    local ladder, lookup, ms = calculate(d)
    if d ~= ns.BLACKSMITHING then return ladder, lookup, ms end
    local craft, mixed = nil, {}
    for _, s in ipairs(ladder.steps) do craft = craft or s.kind == "craft" and s end
    for k, v in pairs(craft) do mixed[k] = v end
    mixed.recipe, mixed.buy = 2668, { [2841] = { need = 20, have = 0, buy = 20, cost = 1075, make = { spell = 2659,
        crafts = 5, made = 10, mining = true, parts = {
            [2840] = { need = 5, have = 0, buy = 5, cost = 25, make = { spell = 2657, crafts = 5, made = 5, mining = true,
                                                                         parts = { [2770] = { need = 5, have = 0, buy = 5, cost = 25 } } } },
            [3576] = { need = 5, have = 0, buy = 5, cost = 50 } } } } }
    mixed.crafts, mixed.ready = 10, 3.6 -- what you have covers 3.6 of its 10 crafts
    table.insert(ladder.steps, 1, mixed)
    return ladder, lookup, ms
end
ns.Window.Invalidate()
ns.AuctionTab.Refresh()
local mixedRows = {}
for _, e in ipairs(mock.shownChildren(ahPanel.scroll.child, "entry")[1].entry.rows) do mixedRows[e.item] = e.buy end
expect("... a step that smelts some bars and buys the rest: the ore, the Tin Bars and the 10 bars it buys",
    mixedRows[2770] == 5 and mixedRows[3576] == 5 and mixedRows[2841] == 10 and not mixedRows[2840])
local wasTab = char().tab
mock.click(tab("blacksmithing"))
mock.click(rows()[1])
local mixedBars
for _, f in ipairs(items()) do if f.item == 2841 then mixedBars = f end end
expect("... its card: 10 smelted from the ore, the other 10 bought", frame:IsShown() and mixedBars
    and strip(mixedBars.sub.text) == "Smelt 10 yourself from 5 Copper Ore, 5 Tin Bar, buy the other 10")
expect("... its row: 3 of its 10 crafts ready, under the cost", strip(rows()[1].ready.text) == "3 ready")
ns.Calculate = calculate
ns.Window.Invalidate()
mock.click(tab(wasTab))
-- one recipe on both sides of a rank learned there (which buys nothing here): one row, what it buys added up
do
    ns.Calculate = function(d)
        local ladder, lookup, ms = calculate(d)
        if d ~= ns.BLACKSMITHING then return ladder, lookup, ms end
        local craft
        for _, s in ipairs(ladder.steps) do craft = craft or s.kind == "craft" and s end
        local function piece(from, to, bars)
            local p = {}
            for k, v in pairs(craft) do p[k] = v end
            p.recipe, p.from, p.to, p.crafts, p.tool = 2668, from, to, to - from, nil
            p.buy = { [2841] = { need = bars, have = 0, buy = bars, cost = bars * 100 } }
            return p
        end
        table.insert(ladder.steps, 1, piece(1, 5, 6))
        table.insert(ladder.steps, 2, { kind = "rank", from = 5, to = 5, cost = 0,
                                        rank = { name = "Journeyman Blacksmithing", cap = 150, how = "trainer" } })
        table.insert(ladder.steps, 3, piece(5, 10, 12))
        return ladder, lookup, ms
    end
    ns.Window.Invalidate()
    ns.AuctionTab.Refresh()
    local joined, split
    for _, r in ipairs(mock.shownChildren(ahPanel.scroll.child, "entry")) do
        if r.entry.key == "2668:1" then joined = r elseif r.entry.key == "2668:5" then split = r end
    end
    expect("... one recipe on both sides of a rank learned there: one row, 1 - 10, its bars added up", joined
        and not split and strip(joined.sub.text) == "1 - 10, ~9 crafts" and joined.entry.rows[1].buy == 18)
    ns.Calculate = calculate
    ns.Window.Invalidate()
end
mock.click(ahPanel.modes[3])
local bsProf = ns.Player.Prof(ns.ProfessionByKey.blacksmithing)
expect("... Gold: the window's mode switched too, the Crafts box shown", bsProf.mode == "gold"
    and ahPanel.crafts:IsShown() and strip(ahPanel.heading.text):find("of 1 craft$"))
local goldStep = mock.shownChildren(ahPanel.scroll.child, "entry")[1]
local oneCraft = goldStep and goldStep.entry.rows[1]
ahPanel.crafts:SetText("3")
ahPanel.crafts.scripts.OnEditFocusLost(ahPanel.crafts)
local threeCrafts
for _, e in ipairs(mock.shownChildren(ahPanel.scroll.child, "entry")[1].entry.rows) do
    if oneCraft and e.item == oneCraft.item then threeCrafts = e end
end
expect("... Crafts 3: the ingredients of 3 crafts", strip(ahPanel.heading.text):find("of 3 crafts$")
    and oneCraft and threeCrafts.buy > oneCraft.buy)
-- Favor: the window's Merchant's Favor recipes, a row per recipe with what one craft of it buys here
mock.click(ahPanel.modes[4])
local favorSteps, gloves = mock.shownChildren(ahPanel.scroll.child, "entry"), nil
for _, r in ipairs(favorSteps) do if r.entry.step.recipe == 1252260 then gloves = r end end -- Acolyte's Gloves
expect("... Favor: the window's Merchant's Favor recipes too, a row per recipe, its status, one craft, no Crafts box",
    ahPanel.modes[4]:IsShown() and ahPanel.modes[4].active and not ahPanel.modes[3].active and bsProf.favorView
    and #favorSteps == ns.Favor.Count(ns.ProfessionByKey.blacksmithing) and not ahPanel.crafts:IsShown()
    and strip(ahPanel.heading.text):find("Merchant's Favor recipes, what one craft of each buys$")
    and gloves and strip(gloves.sub.text):find("skill 80") and #gloves.entry.rows > 0)
mock.click(ahPanel.modes[1])
expect("... and Skill: the window's ladder again", not bsProf.favorView and bsProf.mode == "skill"
    and not ahPanel.modes[4].active and mock.shownChildren(ahPanel.scroll.child, "entry")[1].entry.step.kind ~= "favor")
-- AuctionDB scans again while the tab is open: its ladder calculated again with its prices, once
do
    local scans, calc, n = AuctionDB.sv.houses[UnitFactionGroup()].scans, ns.Calculate, 0
    ns.Calculate = function(...) n = n + 1; return calc(...) end
    ahPanel.ticker.fn()
    local before = n
    scans[#scans + 1] = { fx.scanTs + 900, 0, 0 }
    ahPanel.ticker.fn(); ahPanel.ticker.fn()
    expect("... a new AuctionDB scan: calculated again, once; none before it", before == 0 and n == 1)
    scans[#scans] = nil
    ns.Calculate = calc
end
bsProf.mode = nil
-- Disenchant (Enchanting's): what to make, its ingredients; what you have isn't here (nothing to buy)
hoDisenchant(true)
char().ahProf = "enchanting"
ns.AuctionTab.Refresh()
local deSteps = mock.shownChildren(ahPanel.scroll.child, "entry")
expect("... Disenchant: Enchanting's mode button, the Crafts box, a row per thing to make with what it buys",
    ahPanel.modes[5]:IsShown() and ahPanel.modes[5].active and ahPanel.crafts:IsShown() and #deSteps >= 2
    and strip(ahPanel.heading.text):find("^Enchanting: what's worth more disenchanted") and deSteps[1].entry.step.data
    and strip(deSteps[1].sub.text):find("a craft, Tailoring, disenchanted$") and #deSteps[1].entry.rows > 0)
hoDisenchant(false)
char().ahProf = "blacksmithing"
Auctionator = nil

-- Camp: the menu's entry shows its panel instead of the ladder, the class's role (a warrior: Melee and Tank), a row
-- per feature in the role's order with what it gives and how to get it; a profession's entry brings the ladder back
mock.class = "WARRIOR"
mock.click(frame.menu.camp)
local campRows = mock.shownChildren(frame.camp.scroll.child, "item")
expect("Camp: its panel instead of the ladder, the menu's entry picked", frame.camp:IsShown()
    and not frame.list:IsShown() and not frame.detail:IsShown() and frame.menu.camp.active)
expect("... a warrior's roles: Melee and Tank, Melee picked", frame.camp.roles[1]:IsShown()
    and strip(frame.camp.roles[1].label.text) == "Melee" and frame.camp.roles[1].active
    and strip(frame.camp.roles[2].label.text) == "Tank" and not frame.camp.roles[3]:IsShown())
expect("... Melee: attack power first, what it gives and how to get it", #campRows > 10
    and strip(campRows[1].name.text) == "Lodestone" and strip(campRows[1].gives.text):find("melee Attack Power")
    and strip(campRows[1].source.text):find("^Mining") and strip(campRows[1].price.text):find("^make "))
local textW, wide = campRows[1].gives.width, frame:GetWidth()
expect("... a row as tall as its four lines, each wrapped to the same width", campRows[1].height == 6 + 4 + 4 * 15
    and campRows[1].more.width == textW and campRows[1].name.width == textW)
frame:SetWidth(wide + 200)
ns.Window.Refresh(true)
campRows = mock.shownChildren(frame.camp.scroll.child, "item")
expect("... a wider window: the text wraps 200 wider", campRows[1].gives.width == textW + 200
    and frame.camp.intro.width > 0)
frame:SetWidth(wide)
ns.Window.Refresh(true)
mock.click(frame.camp.roles[2])
campRows = mock.shownChildren(frame.camp.scroll.child, "item")
expect("... Tank: Stamina first, the pick saved", strip(campRows[1].name.text) == "First Aid Kit"
    and ns.Player.Saved().camp.role == "Tank")
mock.click(frame.camp.fires[3])
expect("... the Expert Campfire picked", frame.camp.fires[3].active and ns.Player.Saved().camp.fire == 3)
ns.Player.Saved().camp = nil
mock.click(tab("cooking"))
expect("... a profession's entry: its ladder again", not frame.camp:IsShown() and frame.list:IsShown()
    and not frame.menu.camp.active)

-- a recipe learned from a scroll: known at once, without opening the profession's window
local wasKnown = ns.Player.Known(ns.COOKING)[3397]
mock.fire("NEW_RECIPE_LEARNED", 3397)
expect("a recipe just learned is known before the window is opened", not wasKnown
    and ns.Player.Known(ns.COOKING)[3397] and ns.Player.Prof(ns.COOKING).known[3397])
ns.Player.Prof(ns.COOKING).known[3397] = nil

print(failed == 0 and "game smoke test OK" or (failed .. " checks FAILED"))
io.write(failed == 0 and "game smoke test OK\n" or (failed .. " checks FAILED\n"))
os.exit(failed == 0 and 0 or 1)
