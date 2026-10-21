-- Calculator tests: the skill-up rule, then a real ladder from a fixture (tests/make_fixture.lua).
--   luajit tests/test_ladder.lua [fixture name] [target skill]
local root = (arg[0]:match("^(.*)[/\\]tests[/\\]") or ".") .. "/"
local fixtureName, target = arg[1] or "yungzug", tonumber(arg[2])

local ns = {}
for _, file in ipairs({ "Data/Cooking.lua", "Data/FirstAid.lua", "Data/Fishing.lua", "Data/Mining.lua", "Data/Skinning.lua", "Data/Herbalism.lua", "Data/Lockpicking.lua", "Data/Blacksmithing.lua",
                        "Data/Engineering.lua", "Data/Tailoring.lua", "Data/Enchanting.lua", "Data/Alchemy.lua", "Data/Leatherworking.lua", "Data/Poisons.lua", "Professions.lua", "Ladder.lua", "Fishing.lua", "Mining.lua", "Prices.lua", "Favor.lua", "Data/Camp.lua", "Camp.lua",
                        "Data/Disenchant.lua", "Disenchant.lua" }) do
    assert(loadfile(root .. "CraftLadder/" .. file))("CraftLadder", ns)
end
local Ladder, data = ns.Ladder, ns.COOKING

local failed = 0
local function check(name, got, want)
    if math.abs(got - want) > 1e-9 then
        failed = failed + 1
        print(("FAIL %s: got %s, want %s"):format(name, tostring(got), tostring(want)))
    end
end

-- the skill-up rule (Coyote Steak: orange 50, yellow 90, green 110, grey 130)
local coyote = { 50, 90, 110, 130 }
check("orange is sure", Ladder.Chance(coyote, 60), 1)
check("first yellow point is sure", Ladder.Chance(coyote, 90), 1)
check("green start is half", Ladder.Chance(coyote, 110), 0.5)
check("grey never", Ladder.Chance(coyote, 130), 0)
check("crafts 85-90 orange", Ladder.Crafts(coyote, 85, 90), 5)
check("skipped yellow uses green", Ladder.Chance({ 100, 0, 100, 105 }, 100), 1)
check("orange to grey (campfire)", Ladder.Chance({ 0, 0, 0, 20 }, 19), 1)
Ladder.overtime = 5 -- Working Overtime 5/5: +20% where a skill-up isn't sure or none
check("overtime adds to green", Ladder.Chance(coyote, 110), 0.7)
check("overtime: grey still never", Ladder.Chance(coyote, 130), 0)
check("overtime: never above sure", Ladder.Chance(coyote, 91), 1)
check("overtime: fishing too", ns.Fishing.Chance(150), 0.45)
Ladder.overtime = 0
assert(Ladder.Color(coyote, 89) == "orange" and Ladder.Color(coyote, 90) == "yellow" and Ladder.Color(coyote, 110) == "green")

-- buying from the auction house: 1 listed at 10c and 9 at 12c (lowest 10, median 12, 10 listed), we need all 10.
-- Really 118c; the estimate from the three numbers AuctionDB keeps is 120c.
local q = ns.Prices.Make({ faction = "H", auctionDB = function() return { 0, 10, 12, 10 } end })
check("10 of 1x10c + 9x12c", q(999001, 10, 0), 120)
check("the first one is the lowest price", q(999001, 1, 0), 10.2)
check("buying in two steps costs the same as at once", q(999001, 4, 0) + q(999001, 6, 4), 120)

-- Food (Cooking): a warrior eats for Melee and Tank, each group only its stats; what it can eat now first, the highest
-- level first, then the dishes for later by level
local food = Ladder.Food(data, { skill = 300, faction = "H", level = 30, class = "WARRIOR", known = {}, owned = {} }, q, {})
assert(#food.groups == 2 and food.groups[1].name == "Melee" and food.groups[2].name == "Tank", "Food: a warrior's roles")
local prev, dumplings
for i = food.groups[1].from, food.groups[1].to do
    local s = food.steps[i]
    assert((s.buff.str or s.buff.agi or s.buff.ap) and not s.buff.sta and not s.buff.int,
        "Food: Melee counts Strength, Agility and attack power only")
    if prev then
        assert(prev.later and s.later and prev.eat <= s.eat or not prev.later and (s.later or prev.eat >= s.eat),
            ("Food: %s after %s"):format(data.recipes[s.recipe].name, data.recipes[prev.recipe].name))
    end
    if data.recipes[s.recipe].name == "Smoked Desert Dumplings" then dumplings = s end
    prev = s
end
assert(dumplings and dumplings.later and dumplings.buff.str == 20 and dumplings.eat == 45 and dumplings.cost,
    "Food: Smoked Desert Dumplings, +20 Strength at level 45, later for a level 30 warrior")
for i = food.groups[2].from, food.groups[2].to do
    assert(food.steps[i].buff.sta and not food.steps[i].buff.str, "Food: Tank counts Stamina only")
end
assert(#Ladder.Food(data, { skill = 300, faction = "H", level = 30, class = "ROGUE", known = {}, owned = {} }, q, {}).groups
    == 1, "Food: a rogue eats for Melee only")
-- Goretusk Liver Pie's recipe: only Alliance vendors and quests. Left out for the Horde unless at the auction house
local pie, recipeItems = nil, {}
for spell, r in pairs(data.recipes) do
    if r.name == "Goretusk Liver Pie" then pie = spell end
    if r.item then recipeItems[r.item] = true end
end
local function hasPie(faction, listed)
    local qp = ns.Prices.Make({ faction = faction, auctionDB = function(item)
        return (not recipeItems[item] or item == listed) and { 0, 10, 12, 10 } or nil end })
    for _, s in ipairs(Ladder.Food(data, { skill = 300, faction = faction, level = 30, class = "WARRIOR", known = {},
                                           owned = {} }, qp, {}).steps) do
        if s.recipe == pie then return s end
    end
end
assert(pie and not hasPie("H"), "Food: an Alliance recipe isn't the Horde's")
assert(hasPie("A") and hasPie("A").learn.kind == "quest", "... it's the Alliance's, from its quest")
assert(hasPie("H", data.recipes[pie].item).learn.kind == "ah", "... and the Horde's when it's at the auction house")

-- what you own is cooked first: 18 Chunk of Boar Meat at skill 19 -> Roasted Boar Meat 19-37 for nothing, even
-- though buying boar meat for the rest of its orange stretch would cost more than other recipes
local q2 = ns.Prices.Make({ faction = "H", auctionDB = function() return { 0, 100, 100, 1000 } end })
local l2 = Ladder.Build(data, { skill = 19, maxSkill = 75, target = 75, faction = "H", level = 12, known = {},
    owned = { [769] = 18 } }, q2, {})
local s1 = l2.steps[1]
check("own boar meat first: Roasted Boar Meat", s1.recipe, 2540)
check("own boar meat first: up to 37", s1.to, 37)
check("own boar meat first: costs nothing", s1.cost, 0)
check("own boar meat first: 18 can be cooked now", s1.canCook, 18)
assert(s1.fromBags, "own boar meat first: marked as cooking what you have")
-- a pick of the "with what you have" option holds, and so does a pick of the normal one
local l3 = Ladder.Build(data, { skill = 19, maxSkill = 75, target = 75, faction = "H", level = 12, known = {},
    owned = { [769] = 18 } }, q2, { choices = { { from = 19, to = 65, recipe = 2540, bags = false } } })
assert(l3.steps[1].recipe == 2540 and not l3.steps[1].fromBags and l3.steps[1].to > 37, "a pick of the normal option")

-- what the character has, with a recipe it knows, is made first even when another recipe earns more a point (Skill,
-- vendors only): Big Bear Steak from 8 Big Bear Meat at 110 before Lean Venison, which a vendor pays more for
local q5 = ns.Prices.Make({ faction = "A", auctionDB = function() return { 0, 10, 10, 1000 } end })
local function bearAt110(known)
    return Ladder.Build(data, { skill = 110, maxSkill = 150, target = 150, faction = "A", level = 28, known = known,
        owned = { [3730] = 8 } }, q5, { vendorOnly = true }).steps[1]
end
local bear = bearAt110({ [3397] = true })
assert(bear.recipe == 3397 and bear.fromBags and bear.to == 118, "what you have first: Big Bear Steak 110-118")
assert(bearAt110({}).recipe ~= 3397, "... not when its recipe has still to be bought")

-- camps: what a feature gives by level, as its tooltip says; the order a role wants them in, the other side's banner
-- left out, rested experience only below 60
local Camp = ns.Camp
local wheel
for _, f in ipairs(ns.CAMP.features) do if f.name == "Sharpening Wheel" then wheel = f end end
assert(Camp.Gives(wheel, 23) == "+6 Strength" and Camp.Gives(wheel, 24) == "+11 Strength"
    and Camp.Gives(wheel, 60) == "+34 Strength", "camp: the Sharpening Wheel's Strength by level")
assert(#ns.CAMP.fires == 3 and ns.CAMP.fires[1].slots == 3 and ns.CAMP.fires[3].slots == 10, "camp: campfires' slots")
local melee = Camp.Order("Melee", 30, "H")
assert(melee[1].feature.kind == "ap" and melee[2].feature.kind == "str" and melee[1].useful,
    "camp: a melee character wants attack power, then Strength")
local banners, rested, lastUseful = 0, nil, true
for _, o in ipairs(melee) do
    if o.feature.kind == "spi" then banners = banners + 1 end
    if o.feature.kind == "rested" then rested = o end
    assert(lastUseful or not o.useful, "camp: what helps the role first")
    lastUseful = o.useful
end
assert(banners == 1 and rested and rested.useful, "camp: one banner (the Horde's); rested experience below 60")
local healer = Camp.Order("Healer", 60, "A")
for _, o in ipairs(healer) do
    if o.feature.kind == "rested" then assert(not o.useful, "camp: no rested experience at 60") end
    if o.feature.kind == "spi" then assert(o.feature.faction == "A", "camp: the Alliance's banner") end
end
assert(healer[1].feature.kind == "mp5", "camp: a healer wants mana first")

-- First Aid: a rank quest for each faction, and a book whose real price beats the estimate
local fa = ns.FIRSTAID
local q3 = ns.Prices.Make({ faction = "A", auctionDB = function() return { 0, 50, 50, 1000 } end })
local l4 = Ladder.Build(fa, { skill = 225, maxSkill = 225, target = 300, faction = "A", level = 40, known = {}, owned = {} }, q3, {})
check("Artisan First Aid: the Alliance quest", l4.steps[1].quest, 6624)
local l5 = Ladder.Build(fa, { skill = 125, maxSkill = 150, target = 300, faction = "H", level = 40, known = {}, owned = {} }, q3,
    { realPrices = { [16084] = 9000 } })
local expert
for _, s in ipairs(l5.steps) do if s.kind == "rank" and s.rank.name == "Expert" then expert = s end end
check("Expert First Aid: the price the vendor asked", expert and expert.cost or -1, 9000)
assert(expert and not expert.guess, "a real price isn't a guess")

-- Fishing: Classic's skill-up rule, fish that get away, and lures in the bags used first
local F = ns.Fishing
check("catches 125-150 (one point in (skill - 50) / 25)", F.Catches(125, 150), 87)
check("no fish get away at the zone's base + 95", F.Landed(225, 130), 1)
check("none land at base - 5", F.Landed(125, 130), 0)
local qv = ns.Prices.Make({ faction = "H" }) -- vendor prices only: an Aquadynamic Fish Attractor is 2s 50c
local function swamp(owned)
    local l = F.Build(ns.FISHING, { skill = 125, maxSkill = 225, target = 300, faction = "H", level = 40,
        owned = owned }, qv, { maxOptions = 100 })
    for _, o in ipairs(l.steps[1].options) do if o.zone == 8 then return o end end
end
local o0, o1 = swamp({ [6256] = 1 }), swamp({ [6256] = 1, [6533] = 1 })
check("Swamp of Sorrows at 125: 3 Aquadynamic for 87 catches", o0.luresNeeded, 3)
check("... 7s 50c of them", o0.cost, 750)
check("one in the bags: 2 to buy", o1.cost, 500)
assert(o1.lurePerCast > 0, "a lure you have one of isn't free for the whole stretch")
-- Gold: no ladder, the zones by what an hour there earns at your skill (vendor prices only here)
local fg = F.Build(ns.FISHING, { skill = 300, maxSkill = 300, target = 300, faction = "H", level = 60, owned = {} }, qv,
    { mode = "gold" })
assert(#fg.steps > 3 and fg.steps[1].hour and fg.steps[1].kind == "fish", "Fishing Gold: a list of zones")
for i, s in ipairs(fg.steps) do
    assert(s.perHour > 0 and s.from == 300 and s.to == 300, "Fishing Gold: each earns at 300, no ladder")
    assert(i == 1 or fg.steps[i - 1].perHour >= s.perHour or s.dangerous, "Fishing Gold: the best first")
end

-- Mining: a node's own point plus the bars its ore makes; zones of your side; the ore in your bags smelted first
local M, mining = ns.Mining, ns.MINING
local copper = { [2770] = mining.recipes[2657] }
check("a copper vein at 1: its point and 3 orange Copper Bars", M.NodePoints(mining.nodes[201], 1, copper), 4)
check("a tin vein at 64: can't be mined yet", M.NodePoints(mining.nodes[202], 64, copper), 0)
check("a copper vein at 100: grey, and so are its bars", M.NodePoints(mining.nodes[201], 100, copper), 0)
local qm = ns.Prices.Make({ faction = "H", auctionDB = function(item)
    return ({ [2770] = { 0, 10, 15, 500 }, [2771] = { 0, 40, 50, 300 }, [2840] = { 0, 30, 35, 500 } })[item] end })
local function mine(state, opts)
    local s = { skill = 1, maxSkill = 75, target = 300, faction = "H", level = 60, known = {}, owned = {} }
    for k, v in pairs(state or {}) do s[k] = v end
    return M.Build(mining, s, qm, opts or {})
end
local lm = mine()
local sides = true
for _, s in ipairs(lm.steps) do
    if s.kind == "mine" and mining.zones[s.zone].faction == "A" then sides = false end
end
assert(sides, "Mining: a Horde ladder never sends you to an Alliance zone")
assert(lm.steps[1].kind == "mine" and lm.steps[#lm.steps].to == 300 and not lm.stuck, "Mining: mines from 1 to 300")
check("Mining: Smelt Copper comes with Apprentice (no fee)", lm.steps[1].learns[2657] or 0, 0)
local journeyman
for _, s in ipairs(lm.steps) do if s.kind == "rank" and s.rank.name == "Journeyman" then journeyman = s end end
check("Mining: Journeyman at 50, 5s", journeyman and journeyman.cost or -1, 500)
local bags = mine({ owned = { [2770] = 10 } }).steps[1]
assert(bags.kind == "craft" and bags.fromBags and bags.recipe == 2657 and bags.cost == 0,
    "Mining: 10 Copper Ore in the bags are smelted first")
local first = lm.steps[1]
local otherZone
for _, o in ipairs(first.options) do if o.zone and o.zone ~= first.zone then otherZone = o end end
local picked = mine({}, { choices = { { from = 1, to = first.to, recipe = otherZone.zone } } }).steps[1]
assert(picked.zone == otherZone.zone and picked.chosenByYou and picked.to == first.to, "Mining: a zone picked holds")
local smeltOpt
for _, o in ipairs(first.options) do if o.kind == "smelt" then smeltOpt = o end end
assert(smeltOpt, "Mining: buying ore and smelting is offered")
local bought = mine({}, { choices = { { from = 1, to = smeltOpt.to, recipe = smeltOpt.recipe } } }).steps[1]
assert(bought.kind == "craft" and bought.recipe == smeltOpt.recipe and bought.buy[2770].cost > 0,
    "Mining: picking it buys the ore")
-- a step ends where a kind of node or a smelting recipe opens: another zone may be better from there
local opensAt = {}
for _, n in pairs(mining.nodes) do opensAt[n.skill] = true end
for _, r in pairs(mining.recipes) do opensAt[r.learn] = true end
for _, s in ipairs(lm.steps) do
    for at = s.from + 1, s.to - 1 do
        assert(not (s.kind == "mine" and opensAt[at]), ("Mining: %d-%d hides what opens at %d"):format(s.from, s.to, at))
    end
end
-- a level 28 character still sees zones above their level, marked
local low = mine({ skill = 100, maxSkill = 150, level = 28 })
local risky = false
for _, s in ipairs(low.steps) do
    for _, o in ipairs(s.options or {}) do risky = risky or o.dangerous == true end
    assert(not s.dangerous, "Mining: Craft Ladder doesn't pick a zone above your level")
end
assert(risky, "Mining: zones above your level are shown as options")
-- Gold: copper sells for more as bars (30c) than as ore (10c); every node you can mine counts, grey ones too
local lg = mine({}, { mode = "sell" })
local g1 = lg.steps[1]
check("Gold: Copper Ore as ore, after the cut (the first one listed: 10.01c)", g1.sell[2770].ore, 10.01 * 0.95)
check("Gold: ... and as Copper Bar (30.01c)", g1.sell[2770].bars, 30.01 * 0.95)
assert(g1.perHour > 0 and g1.earn > 0 and lg.perHour > 0, "Gold: what you mine earns gold an hour")
assert(lg.nodes > lm.nodes, "Gold: grey nodes are mined too, so it takes more nodes")
-- Gold (the list): the zones by what an hour there earns at your skill now, where you're safe first; Copper Ore sells
-- best as bars, and a node is worth its ore that way
local zl = mine({ skill = 60, maxSkill = 75, level = 20 }, { mode = "gold" })
assert(#zl.steps > 3 and zl.steps[1].hour and not zl.steps[1].dangerous, "Mining Gold: a list of zones, a safe one first")
local seenRisky = false
for i, s in ipairs(zl.steps) do
    assert(s.kind == "mine" and s.from == 60 and s.perHour > 0 and s.crafts > 0, "Mining Gold: each zone earns at 60")
    assert(not seenRisky or s.dangerous, "Mining Gold: zones above your level come after the safe ones")
    seenRisky = seenRisky or s.dangerous == true
    local prev = zl.steps[i - 1]
    assert(not prev or prev.dangerous ~= s.dangerous or prev.perHour >= s.perHour, "Mining Gold: the best first")
end
local z1 = zl.steps[1]
check("Mining Gold: gold an hour is a node's worth times nodes an hour", z1.perHour, z1.value * z1.crafts)
assert(z1.sell[2770] and z1.sell[2770].bars > z1.sell[2770].ore, "Mining Gold: copper sells as bars")
-- Bronze: where a zone has copper and tin, the bars are made into Bronze on the way, and Bronze is priced
local hills = mine({ skill = 70, maxSkill = 150 }, { choices = { { from = 70, to = 75, recipe = 1424 } } }).steps[1]
assert(hills.zone == 1424 and (hills.bars[2659] or 0) > 0 and hills.learns[2659] == 200,
    "Bronze: Hillsbrad's copper and tin make Bronze Bars on the way (Smelt Bronze learned for 2s)")
assert(hills.sell[2770].alloyRecipe == 2659 and hills.sell[2771].alloy, "Bronze: copper and tin priced as Bronze too")
-- a step that joins stretches counts its other zones over all of it
local long
for _, s in ipairs(lm.steps) do
    if s.kind == "mine" and s.to - s.from >= 25 then long = s end
end
local covered = true
for _, o in ipairs(long.options) do covered = covered and (not o.zone or o.to == long.to) end
assert(covered, ("the zones offered for %d-%d are counted to %d"):format(long.from, long.to, long.to))

-- Skinning (Mining's ladder over creatures): the skill a creature needs from its level; a creature well above your
-- level only in a dangerous option; a creature new in Forever joins once the game records skinning one
check("Skinning: level 8 needs 1", M.SkinSkill(8), 1)
check("... level 15 needs 50", M.SkinSkill(15), 50)
check("... level 40 needs 200", M.SkinSkill(40), 200)
local sk = ns.SKINNING
local qs = ns.Prices.Make({ faction = "H", auctionDB = function() return { 0, 50, 50, 500 } end })
local function skin(level, skill)
    return M.Build(sk, { skill = skill, maxSkill = 300, target = 300, faction = "H", level = level, known = {}, owned = {} },
        qs, {})
end
local young = skin(15, 100)
local warned = false
assert(young.steps[1].kind == "mine" and not young.steps[1].dangerous, "Skinning: a level 15 at 100 skins creatures of their level")
for _, s in ipairs(young.steps) do
    for _, o in ipairs(s.options or {}) do
        warned = warned or (o.dangerous and o.mobLevel and o.mobLevel > 17)
        assert(not s.dangerous or o.dangerous or not o.zone,
            "Skinning: creatures well above your level are picked only when no zone of your level gives points")
    end
end
assert(warned, "... they're shown, marked, with their level")
assert(skin(60, 1).steps[#skin(60, 1).steps].to == 300, "Skinning: a level 60 skins from 1 to 300")
local newMob, cand = next(sk.candidates)
ns.db = { skinLog = { [newMob] = { skins = 2, items = { [2318] = 3 } } } }
M.ApplySkinLog(sk)
local mapOf = next(cand.zones)
assert(sk.nodes[newMob] and sk.nodes[newMob].recorded and sk.nodes[newMob].loot[2318] == 1.5
    and sk.zones[mapOf].nodes[newMob] == cand.zones[mapOf], "Skinning: a recorded creature joins the ladder where it lives")
sk.nodes[newMob] = nil
for _, z in pairs(sk.zones) do z.nodes[newMob] = nil end
ns.db = nil

-- Herbalism (Mining's ladder over herbs): a rarer herb gives itself (CMaNGOS's reference loot), and one zone over
-- stretches in a row is one step, though herbs open every few points
local hb = ns.HERBALISM
local sungrass
for _, node in pairs(hb.nodes) do if node.name == "Sungrass" then sungrass = node end end
assert(sungrass and (sungrass.loot[8838] or 0) > 1, "Herbalism: picking Sungrass gives Sungrass")
local lh = M.Build(hb, { skill = 1, maxSkill = 75, target = 300, faction = "H", level = 60, known = {}, owned = {} }, qs, {})
assert(lh.steps[#lh.steps].to == 300, "Herbalism: a level 60 picks herbs from 1 to 300")
for i = 2, #lh.steps do
    local a, b = lh.steps[i - 1], lh.steps[i]
    assert(not (a.kind == "mine" and b.kind == "mine" and a.zone == b.zone), "Herbalism: one zone in a row is one step")
end
local hg = M.Build(hb, { skill = 150, maxSkill = 225, target = 300, faction = "H", level = 40, known = {}, owned = {} },
    qs, { mode = "gold" })
assert(#hg.steps > 3 and hg.steps[1].hour and hg.steps[1].perHour > 0, "Herbalism Gold: zones by gold an hour")
-- what a zone gives, by item (the row's icon and names): the biggest share first, the shares add up to 1
for _, l in ipairs({ lm, zl, lh, hg }) do
    local s
    for _, x in ipairs(l.steps) do if x.kind == "mine" then s = s or x end end
    local sum = 0
    for i, x in ipairs(s.mix) do
        sum = sum + x.share
        assert(i == 1 or s.mix[i - 1].share >= x.share, "mix: the biggest share first")
    end
    check("mix: the shares add up to 1", sum, 1)
end
local sg = M.Build(sk, { skill = 150, maxSkill = 225, target = 300, faction = "H", level = 25, known = {}, owned = {} },
    qs, { mode = "gold" })
local safeFirst = sg.steps[1] and not sg.steps[1].dangerous
assert(safeFirst and sg.steps[1].crafts < 3600 / sk.nodeSeconds, "Skinning Gold: a zone of your level first, " ..
    sk.nodeSeconds .. " s a creature and the ride to the next")
-- a lone creature in a big zone (a riding wolf by its vendor) doesn't make the zone worth an hour of skinning
local lone = M.Build(sk, { skill = 1, maxSkill = 75, target = 300, faction = "H", level = 28, known = {}, owned = {} },
    qs, { mode = "gold" })
for _, s in ipairs(lone.steps) do
    local spawns = 0
    for id, n in pairs(sk.zones[s.zone].nodes) do if sk.nodes[id].skill <= 1 then spawns = spawns + n end end
    assert(spawns >= 3 or s.crafts < 30, "Skinning Gold: " .. sk.zones[s.zone].name .. "'s lone creature, " ..
        math.floor(s.crafts) .. " an hour")
end

-- Lockpicking (Mining's ladder over locked chests, boxes from the bags as recipes): the cap is the level x 5, so its
-- ranks are levels; Pick Lock first when it isn't learned
local lp = ns.LOCKPICKING
local r28 = M.LevelRanks(lp, { level = 28, maxSkill = 140 })
assert(r28[1].name == "Level 30" and r28[1].learnAt == 140 and r28[1].cap == 150 and r28[2].learnAt == 150
    and r28[#r28].cap == 300, "Lockpicking: a level 28 at cap 140 needs level 30 for 150, then every 5 levels to 300")
local r10 = M.LevelRanks(lp, { level = 10, maxSkill = 0 })
assert(r10[1].name == "Pick Lock" and r10[1].cap == 80 and r10[1].charLevel == 16 and r10[2].learnAt == 80
    and r10[2].cap == 100, "Lockpicking: not learned at 10: Pick Lock at 16 (cap 80), then level 20 for 100")
local function lockLadder(state, opts)
    local s = { skill = 1, maxSkill = 300, target = 300, faction = "H", level = 60, known = {}, owned = {} }
    for k, v in pairs(state or {}) do s[k] = v end
    lp.ranks = M.LevelRanks(lp, s)
    return M.Build(lp, s, qs, opts or {})
end
local l60 = lockLadder()
local first, doors, end300 = nil, false, l60.steps[#l60.steps].to == 300
for _, s in ipairs(l60.steps) do
    if s.kind == "mine" then
        first = first or s
        doors = doors or lp.zones[s.zone].dungeon == true
        assert(lp.zones[s.zone].faction ~= "A", "Lockpicking: a Horde rogue picks no Alliance zone's locks")
    end
end
assert(end300 and first.zone == 1413 and doors, "Lockpicking: a level 60 orc starts on the Barrens' strongboxes and" ..
    " ends at Blackrock Depths' doors, at 300")
local l28 = lockLadder({ skill = 100, maxSkill = 140, level = 28 })
local gates = 0
for _, s in ipairs(l28.steps) do
    if s.kind == "rank" then
        gates = gates + 1
        assert(s.rank.how == "level" and s.needLevel == s.rank.charLevel, "Lockpicking: a gate above your level is red")
    end
end
check("Lockpicking: a level 28 passes 7 gates on the way to 300 (30, 35, ..., 60)", gates, 7)
local bag = lockLadder({ skill = 30, maxSkill = 140, level = 28, owned = { [4633] = 10 } }).steps[1]
assert(bag.kind == "craft" and bag.recipe == -4633 and bag.fromBags, "Lockpicking: the Heavy Bronze Lockboxes in the" ..
    " bags are picked first")
lp.ranks = { lp.learnRank }

-- Poisons (the crafting ladder, the cap the level x 5): a recipe a rogue trainer teaches at a level is learned only
-- once the ladder plans for that level (past a "Reach level N" gate)
local po = ns.POISONS
local function poisons(state)
    local s = { skill = 1, maxSkill = 300, target = 300, faction = "H", level = 60, known = {}, owned = {} }
    for k, v in pairs(state or {}) do s[k] = v end
    po.ranks = M.LevelRanks(po, s)
    return Ladder.Build(po, s, qs, {})
end
local fresh = poisons({ skill = 0, maxSkill = 0, level = 20 })
assert(fresh.steps[1].kind == "rank" and fresh.steps[1].rank.name == "Poisons" and fresh.steps[1].rank.cap == 100,
    "Poisons: learned from the class quest at 20, cap 100")
local planned = 20
for _, s in ipairs(fresh.steps) do
    if s.kind == "rank" and s.rank.how == "level" then planned = s.rank.charLevel end
    if s.kind == "craft" and s.learn.level then
        assert(s.learn.level <= planned, ("Poisons: %s (level %d) at %d, planned for level %d"):format(
            po.recipes[s.recipe].name, s.learn.level, s.from, planned))
    end
end
assert(fresh.steps[#fresh.steps].to == 300, "Poisons: a level 20 rogue's ladder goes to 300 through the gates")
po.ranks = { po.learnRank }

-- Blacksmithing: plans that need a reputation or a specialization, selling what you make, bars smelted when that's
-- cheaper, grinding stones kept for later, the hammer bought once
local bs = ns.BLACKSMITHING
local bsPrices = { [276955] = { 0, 5000, 5000, 3 }, -- Plans: Azure Skyforged Chain (Nightclaw Druids, Friendly)
                   [2841] = { 0, 100, 100, 500 }, [2770] = { 0, 5, 5, 500 }, [2771] = { 0, 10, 10, 500 }, -- Bronze, ores
                   [2836] = { 0, 20, 20, 500 }, -- Coarse Stone
                   [11610] = { 0, 90000, 90000, 2 } } -- Plans: Dark Iron Pulverizer (Weaponsmith)
local qb = ns.Prices.Make({ faction = "H", auctionDB = function(item) return bsPrices[item] end })
local function bsCtx(state, opts)
    local s = { skill = 50, maxSkill = 150, target = 300, faction = "H", level = 40, known = {}, owned = {} }
    for k, v in pairs(state or {}) do s[k] = v end
    return Ladder.NewContext(bs, s, qb, opts or {})
end
local azure = bs.recipes[1301448]
assert(not Ladder.LearnWay(bsCtx(), 1301448, azure), "a plan that needs Friendly with the Nightclaw Druids, without it")
assert(Ladder.LearnWay(bsCtx({}, { standing = function(f) return f == 2758 and 4 or nil end }), 1301448, azure).npc == 254151,
    "... and at Friendly: bought from Vayn Moongaze (AllTheThings), for less than the auction house asks")
assert(not Ladder.LearnWay(bsCtx(), 15292, bs.recipes[15292]), "Dark Iron Pulverizer needs Weaponsmith")
assert(Ladder.LearnWay(bsCtx({ specs = { [9787] = true } }), 15292, bs.recipes[15292]), "... a Weaponsmith may learn it")
-- selling 19 of something a vendor pays 25s for and 40 are listed at the auction house from 1g
local sellCtx = { sell = { [999002] = 2500 },
                  quote = function(_, _, _, ah) return ah and 10000, { min = 10000, qty = 40 } end }
local sale = Ladder.Resale(sellCtx, 999002, 19, {})
check("selling: a quarter of the 40 listed at the auction house", sale.ah, 10)
check("... after its cut", sale.ahEach, 9500)
check("... the other 9 to a vendor", sale.total, 10 * 9500 + 9 * 2500)
check("... less what earlier steps put there", Ladder.Resale(sellCtx, 999002, 19, { [999002] = 8 }).ah, 2)
check("the Skill ladder: only vendors buy", Ladder.Resale({ sell = sellCtx.sell, quote = sellCtx.quote, vendorOnly = true },
    999002, 19, {}).ah, 0)
sellCtx.quote = function(_, _, _, ah) return ah and 3000, { min = 3000, qty = 40 } end
check("the auction house paying less than 1.5x a vendor: all to a vendor", Ladder.Resale(sellCtx, 999002, 19, {}).ah, 0)
-- 10 Bronze Bars: 1s at the auction house, or smelted from 5c Copper Ore and 10c Tin Ore with Mining 119
local smelt = { smelt = { skill = 119, recipes = ns.MINING.recipes } }
local _, bronze = Ladder.Ingredients(bsCtx({}, smelt), { mats = { [2841] = 10 } }, 1)
assert(bronze[2841].make and bronze[2841].make.mining and bronze[2841].make.parts[2840].make,
    "Bronze Bars smelted from Copper and Tin Bars, smelted from ore")
check("... 5 Smelt Bronze (2 bars each)", bronze[2841].make.crafts, 5)
check("... for 5 Copper Ore and 5 Tin Ore", bronze[2841].cost, 5 * 5 + 5 * 10)
local _, noMining = Ladder.Ingredients(bsCtx(), { mats = { [2841] = 10 } }, 1)
assert(not noMining[2841].make and noMining[2841].cost == 1000, "without Mining, Bronze Bars are bought")
-- two stretches of one recipe joined into one step: what the bars are smelted from adds up all the way to the ore
do
    local function bronzeStep(opts)
        local cost, buy = Ladder.Ingredients(bsCtx({}, opts), { mats = { [2841] = 10 } }, 1)
        return { from = 0, to = 1, crafts = 1, matCost = cost, cost = cost, buy = buy }
    end
    local joined = bronzeStep(smelt)
    Ladder.MergeCraft(joined, bronzeStep(smelt))
    check("joined: 10 Smelt Bronze", joined.buy[2841].make.crafts, 10)
    check("... from 10 Copper Bars", joined.buy[2841].make.parts[2840].make.crafts, 10)
    check("... smelted from 10 Copper Ore", joined.buy[2841].make.parts[2840].make.parts[2770].need, 10)
    -- a stretch that smelts the bars joined with one that buys them, in either order: 10 smelted, the other 10 bought
    for _, first in ipairs({ smelt, {} }) do
        local mixed = bronzeStep(first)
        Ladder.MergeCraft(mixed, bronzeStep(first == smelt and {} or smelt))
        check("mixed: 20 Bronze Bars", mixed.buy[2841].buy, 20)
        check("... 10 of them smelted", mixed.buy[2841].make.made, 10)
        check("... from 5 Copper Ore and 5 Tin Ore, the other 10 at 1s", mixed.buy[2841].cost, 5 * 5 + 5 * 10 + 1000)
    end
end
-- how many crafts what you have covers: 6 crafts of 2 Bronze Bars and a Strong Flux (a vendor's, taken as had), with 4
-- bars in the bags and ore for 4 more (2 Copper and 2 Tin, 2 bars a smelt): 8 of the 12 bars, 4 crafts
do
    local rec = { mats = { [2841] = 2, [3466] = 1 } }
    local ctx = bsCtx({ owned = { [2841] = 4, [2770] = 2, [2771] = 2 } }, smelt)
    local _, buy = Ladder.Ingredients(ctx, rec, 6)
    check("ready: 4 of 6 crafts, bars smelted from your ore counted",
        Ladder.Ready(ctx, rec, { crafts = 6, buy = buy }), 4)
    _, buy = Ladder.Ingredients(bsCtx({ owned = { [2841] = 20 } }), rec, 6)
    check("... all 6 with 20 bars", Ladder.Ready(ctx, rec, { crafts = 6, buy = buy }), 6)
    _, buy = Ladder.Ingredients(ctx, { mats = { [3466] = 1 } }, 6)
    assert(Ladder.Ready(ctx, { mats = { [3466] = 1 } }, { crafts = 6, buy = buy }) == nil,
        "... nothing to say when vendors sell every ingredient")
end
-- Coarse Grinding Stones made in one step are there for later ones; the first step that needs a hammer buys one
local ctx = bsCtx({ known = { [3326] = true } })
local stones = Ladder.CraftStep(ctx, bs, { recipe = 3326, color = "orange" }, 50, 55, {}, nil)
check("5 Coarse Grinding Stones kept for later", ctx.owned[3478], stones.crafts)
assert(not stones.sale, "... not sold")
local hammerRecipe
for spell, r in pairs(bs.recipes) do
    if r.tools and r.learn <= 50 and r.get[1] and r.get[1].kind == "trainer" and not hammerRecipe then hammerRecipe = spell end
end
local s1 = Ladder.CraftStep(ctx, bs, { recipe = hammerRecipe, color = "orange" }, 50, 51, {}, nil)
local s2 = Ladder.CraftStep(ctx, bs, { recipe = hammerRecipe, color = "orange" }, 51, 52, {}, nil)
assert(s1.buy[5956] and not s2.buy[5956], "a Blacksmith Hammer bought once, before the first recipe that needs one")

-- Engineering: tools only a recipe makes get a step of their own as soon as they can be made; specializations by
-- trainer; what a step makes for later steps is noted, and what no later step uses is sold
local eng = ns.ENGINEERING
local function spellNamed(d, name)
    for spell, r in pairs(d.recipes) do if r.name == name then return spell, r end end
end
local SPANNER, ADJUSTOR = 14, 15
local engPrices = { [2840] = { 0, 10, 10, 5000 }, [2835] = { 0, 1, 1, 5000 }, [2589] = { 0, 5, 5, 5000 }, -- bar, stone, linen
                    [4360] = { 0, 50, 50, 400 }, [6219] = { 0, 300, 300, 50 } } -- Rough Copper Bomb, Arclight Spanner
local qe = ns.Prices.Make({ faction = "H", auctionDB = function(item) return engPrices[item] end })
local function engBuild(state, opts)
    local s = { skill = 30, maxSkill = 75, target = 75, faction = "H", level = 20, owned = {},
                known = { [3918] = true, [3922] = true, [3923] = true } }
    for k, v in pairs(state or {}) do s[k] = v end
    return Ladder.Build(eng, s, qe, opts or {})
end
-- a holiday's quest (the Lunar Festival's rockets) is never the ladder's way to a recipe; its schematic listed at the
-- auction house is
local function rocketCtx(price)
    local s = { skill = 125, maxSkill = 150, target = 300, faction = "H", level = 30, known = {}, owned = {} }
    return Ladder.NewContext(eng, s, ns.Prices.Make({ faction = "H",
        auctionDB = function(item) return item == 21724 and price or nil end }), {})
end
assert(not Ladder.LearnWay(rocketCtx(nil), 26416, eng.recipes[26416]), "Small Blue Rocket: a Lunar Festival quest only")
assert(Ladder.LearnWay(rocketCtx({ 0, 2000, 2000, 3 }), 26416, eng.recipes[26416]).kind == "ah",
    "... or its schematic at the auction house")
local picks = { choices = { { from = 30, to = 52, recipe = 3922 }, { from = 52, to = 75, recipe = 3923 } } }
local le = engBuild({}, picks)
local spannerStep, boltSteps = nil, {}
for _, s in ipairs(le.steps) do
    if s.tool == SPANNER then spannerStep = s end
    if s.recipe == 3922 then boltSteps[#boltSteps + 1] = s end
end
assert(spannerStep and spannerStep.from == 50 and spannerStep.to == 51 and spannerStep.crafts == 1,
    "Engineering: an Arclight Spanner made once at 50, its point counted")
assert(not spannerStep.sale, "... and kept, not sold")
local spanners = 0
for _, s in ipairs(engBuild({ owned = { [2840] = 100 } }).steps) do
    if s.recipe == 7430 then spanners = spanners + 1 end
end
check("Engineering: the spanner's recipe isn't crafted again, for skill or to sell", spanners, 1)
local keep = boltSteps[1] and boltSteps[1].keep and boltSteps[1].keep[4359]
assert(keep and keep.from >= 52 and keep.n > 0, "Engineering: Handful of Copper Bolts kept for the Rough Copper Bombs")
local noTool = true
for _, s in ipairs(engBuild({ owned = { [6219] = 1 } }, picks).steps) do noTool = noTool and not s.tool end
assert(noTool, "Engineering: no spanner step with one in the bags")
local knife = Ladder.NewContext(eng, { skill = 100, faction = "H", owned = { [260811] = 1 } }, qe, {})
assert(knife.hasTool[SPANNER] and knife.hasTool[ADJUSTOR] and knife.hasTool[162],
    "Engineering: a Gnomish Army Knife is a spanner, a micro-adjustor and a hammer")
local scope, scopeRec = spellNamed(eng, "Crude Scope")
local ectx = Ladder.NewContext(eng, { skill = 60, faction = "H", known = { [scope] = true }, owned = {} }, qe, {})
assert(not Ladder.Option(ectx, scope, scopeRec, 60, 75), "Engineering: Crude Scope needs an Arclight Spanner")
ectx.hasTool[SPANNER] = true
assert(Ladder.Option(ectx, scope, scopeRec, 60, 75), "... and with one it's an option")
local sapper, sapperRec = spellNamed(eng, "Goblin Sapper Charge")
assert(sapperRec.spec == 20222 and not Ladder.LearnWay(ectx, sapper, sapperRec),
    "Engineering: Goblin Sapper Charge needs Goblin Engineering (its trainers teach only goblin engineers)")

-- Tailoring: a second version of a recipe that nothing teaches (Season of Discovery's) is left out, as AllTheThings
-- doesn't list it; one with a cooldown isn't for leveling; a recipe everyone knows from the start makes what later
-- ones need (bolts from cloth)
local tl = ns.TAILORING
local twinVest, firstVest
for spell, r in pairs(tl.recipes) do
    if r.name == "Earthen Vest" then if r.twin then twinVest = spell else firstVest = spell end end
end
local tctx = Ladder.NewContext(tl, { skill = 200, faction = "H", known = {}, owned = {} }, qe, {})
assert(not twinVest and not tl.recipes[439100], "Tailoring: the second Earthen Vest is left out")
assert(Ladder.LearnWay(tctx, firstVest, tl.recipes[firstVest]).kind == "trainer", "... the first one is, by trainers")
local moon, moonRec = spellNamed(tl, "Mooncloth")
assert(moonRec.cooldown and not Ladder.Option(tctx, moon, moonRec, 260, 300), "Tailoring: Mooncloth (a cooldown) isn't for leveling")
local tq = ns.Prices.Make({ faction = "H", auctionDB = function(item)
    return ({ [2589] = { 0, 10, 10, 5000 }, [2996] = { 0, 100, 100, 500 } })[item] end }) -- Linen Cloth, its bolt
local _, bolts = Ladder.Ingredients(Ladder.NewContext(tl, { skill = 1, faction = "H", known = {}, owned = {} }, tq, {}),
    { mats = { [2996] = 3 } }, 1)
assert(bolts[2996].make, "Tailoring: Bolts of Linen Cloth made from Linen Cloth (a recipe known from the start)")

-- the supply camps' quartermasters sell plans for Merchant's Favor: not for gold, and only with the setting on
local belt, beltRec = spellNamed(bs, "Acolyte's Chain Belt")
assert(not Ladder.LearnWay(bsCtx(), belt, beltRec), "a plan sold only for Merchant's Favor, the setting off: not learnable")
local favorWay = Ladder.LearnWay(bsCtx({}, { favor = true }), belt, beltRec)
assert(favorWay and favorWay.favor and favorWay.cost == 0,
    "... the setting on: for Merchant's Favor (its price seen at the quartermaster, or true), no gold")

-- Alchemy: the Philosopher's Stone serves only transmutes (a cooldown) and flasks (learned at 300), none for leveling:
-- it's made once the ladder is done, not when it can first be made
local alch = ns.ALCHEMY
local qa = ns.Prices.Make({ faction = "H", auctionDB = function() return { 0, 100, 100, 5000 } end })
local la = Ladder.Build(alch, { skill = 220, maxSkill = 225, target = 300, faction = "H", level = 60, known = {}, owned = {} },
    qa, {})
local stoneAt = {}
for i, s in ipairs(la.steps) do if s.tool then stoneAt[#stoneAt + 1] = i end end
assert(#stoneAt == 1 and stoneAt[1] == #la.steps and la.steps[#la.steps].late,
    "Alchemy: the Philosopher's Stone is the last step, after the ladder")

-- Leatherworking: Dragonscale Gauntlets, taught only by the Dragonscale trainers, needs Dragonscale Leatherworking
local lwg, lwgRec = spellNamed(ns.LEATHERWORKING, "Dragonscale Gauntlets")
assert(lwgRec.spec == 10656 and not Ladder.LearnWay(Ladder.NewContext(ns.LEATHERWORKING, { skill = 220, faction = "H",
    known = {}, owned = {} }, qe, {}), lwg, lwgRec), "Leatherworking: Dragonscale Gauntlets needs Dragonscale Leatherworking")

-- Enchanting: an enchantment makes no item (its spell's icon stands for it), so nothing is sold and Gold leaves it out
local en = ns.ENCHANTING
local ench, enchRec = spellNamed(en, "Enchant Bracer - Minor Stamina")
assert(not enchRec.makes and enchRec.icon, "Enchanting: an enchantment makes no item, its spell's icon stands for it")
local enchStep = Ladder.CraftStep(Ladder.NewContext(en, { skill = 60, faction = "H", known = { [ench] = true }, owned = {} },
    qe, {}), en, { recipe = ench, color = "orange" }, 60, 61, {}, nil)
assert(not enchStep.sale, "... nothing to sell")
local _, superInt = spellNamed(en, "Enchant Chest - Superior Intellect")
assert(superInt.trainers and #superInt.trainers == 1 and en.npcs[superInt.trainers[1]].name == "Annora",
    "Enchanting: a recipe from 230 is taught by Annora alone, and says so")
for _, r in ipairs(Ladder.Profits(en, { skill = 300, faction = "H", known = {}, owned = {} }, qe, {}).steps) do
    assert(en.recipes[r.recipe].makes, "... and Gold lists only what makes an item")
end

-- Gold: what one craft earns, what you own at its price, when learning a recipe pays back
local goldPrices = { [2835] = { 0, 10, 10, 5000 }, [2862] = { 0, 100, 100, 40 }, -- Rough Stone, Rough Sharpening Stone
                     [2836] = { 0, 20, 20, 5000 }, [2863] = { 0, 300, 300, 20 } } -- Coarse Stone, Coarse Sharpening Stone
local qg = ns.Prices.Make({ faction = "H", auctionDB = function(item) return goldPrices[item] end })
local function gold(owned)
    local rows = {}
    local list = Ladder.Profits(bs, { skill = 50, maxSkill = 150, faction = "H", level = 40, known = {}, owned = owned or {} },
        qg, {})
    for i, r in ipairs(list.steps) do
        rows[r.recipe] = r
        assert(i == 1 or r.profit <= list.steps[i - 1].profit, "Gold: the best first")
    end
    return rows
end
local g = gold()
local roughStone, coarseStone = g[2660], g[2665]
check("Gold: one Rough Sharpening Stone", roughStone.made, 1)
check("... sold at the auction house (40 listed)", roughStone.sale.ah, 1)
check("... profit: what it sells for less the stone", roughStone.profit, roughStone.sale.total - roughStone.matCost)
check("Gold: Coarse Sharpening Stone's profit per craft, its 90c trainer fee aside", coarseStone.profit,
    coarseStone.sale.total - coarseStone.matCost)
check("... the fee pays back after so many crafts", coarseStone.payback, math.ceil(90 / coarseStone.profit))
check("Gold: the stone in your bags counts at its price", gold({ [2835] = 100 })[2660].matCost, roughStone.matCost)
-- Gold's two groups: what a vendor pays more for than it costs, then what earns at the auction house. A: 20c of
-- ingredients, a vendor pays 50c, the auction house 2s (both); B: a vendor pays 30c, the auction house 35c (not 1.5
-- times as much: only the vendor); C: a vendor pays 10c, the auction house 1s (only the auction house)
local made = function(item) return { learn = 1, colors = { 1, 10, 20, 30 }, mats = { [900009] = 1 }, makes = item,
                                     get = { { kind = "start" } } } end
local twoGroups = { recipes = { [1] = made(900001), [2] = made(900002), [3] = made(900003) },
                    sell = { [900001] = 50, [900002] = 30, [900003] = 10 } }
for i, r in pairs(twoGroups.recipes) do r.name = "recipe " .. i end
local q2g = ns.Prices.Make({ faction = "H", auctionDB = function(item)
    return ({ [900009] = { 0, 20, 20, 5000 }, [900001] = { 0, 200, 200, 20 }, [900002] = { 0, 35, 35, 20 },
              [900003] = { 0, 100, 100, 20 } })[item] end })
local groups = Ladder.Profits(twoGroups, { skill = 5, faction = "H", known = {}, owned = {} }, q2g, {})
local order = {}
for _, r in ipairs(groups.steps) do order[#order + 1] = r.recipe .. (r.vendor and "v" or "a") end
check("Gold: two at a vendor (A and B), then two at the auction house (A and C)", groups.vendorRows, 2)
assert(groups.steps[1].color == "orange", "Gold: a row says the recipe's colour at your skill (orange at 5)")
assert(table.concat(order, " ") == "1v 2v 1a 3a", "... in this order, the best first in each: " .. table.concat(order, " "))

-- Merchant's Favor recipes: known (and how many the bags allow), learnable now, skill or level too low; by skill
local fv = ns.Favor.Recipes({ recipes = {
        [1] = { name = "A", learn = 50, mats = { [10] = 2 }, get = { { kind = "vendor", favor = true } } },
        [2] = { name = "B", learn = 80, mats = {}, get = { { kind = "vendor", favor = 30, favorLevel = 18 } } },
        [3] = { name = "C", learn = 200, item = 33, mats = {}, get = { { kind = "vendor", favor = true } } },
        [4] = { name = "D", learn = 90, item = 44, mats = {}, get = { { kind = "vendor", favor = true } } },
        [5] = { name = "E", learn = 10, mats = {}, get = { { kind = "trainer", cost = 100 } } } } },
    { skill = 100, level = 20, known = { [1] = true } }, { [10] = 7 }, { [44] = { cost = 45, level = 30 } })
local fvs = {}
for _, s in ipairs(fv) do fvs[#fvs + 1] = s.recipe .. ":" .. s.status end
assert(table.concat(fvs, " ") == "1:known 2:learn 4:level 3:skill" and fv[1].canMake == 3 and fv[2].cost == 30
    and fv[2].level == 18 and fv[3].cost == 45 and fv[3].level == 30 and fv[4].cost == nil,
    "favor recipes (the data's price and level, or what this account saw): " .. table.concat(fvs, " "))

;(function() -- a function of its own: the main chunk has 200 locals, Lua's most
    -- Disenchanting: one disenchant's average and spread (75%: 4-6 of a 10c dust, else a 1s shard), and what a batch of
    -- 10 gives at least 9 times out of 10
    local Disenchant, DE = ns.Disenchant, ns.DISENCHANT
    local deMean, deSpread = Disenchant.Value({ gives = { { item = 1, chance = 0.75, min = 4, max = 6 },
                                                          { item = 2, chance = 0.25, min = 1, max = 1 } } },
        function(item) return item == 1 and 10 or 100 end)
    check("Disenchant: one disenchant's average", deMean, 0.75 * 5 * 10 + 0.25 * 100)
    check("... its spread", deSpread, math.sqrt(0.75 * 100 * (16 + 25 + 36) / 3 + 0.25 * 10000 - deMean ^ 2))
    check("... 10 of them, 9 times out of 10", Disenchant.Sure(deMean, deSpread, 10),
        10 * deMean - 1.2816 * math.sqrt(10) * deSpread)
    -- 3 Lesser Magic Essences (1s listed) make a Greater one (6s): a lesser is worth a third of a greater, a greater no
    -- less than what it's listed for
    local deWorth = Disenchant.Worth(ns.Prices.Make({ faction = "H", auctionDB = function(item)
        return ({ [10938] = { 0, 100, 100, 50 }, [10939] = { 0, 600, 600, 50 } })[item] end }))
    check("... a lesser essence: a third of a greater, after the cut", deWorth(10938), 600 * 0.95 / 3)
    check("... a greater essence: its own price, after the cut", deWorth(10939), 600 * 0.95)
    -- Ho: Enchanting 150 and Tailoring 103, today's prices from both snapshots. Only what's worth more disenchanted
    -- than sold: what Ho has first (what making it cost doesn't count), then what to make (at a loss last), then what
    -- Enchanting can't disenchant yet
    local hoT = dofile(root .. "tests/fixtures/ho_tailoring.lua")
    local hoE = dofile(root .. "tests/fixtures/ho_enchanting.lua")
    local qho = ns.Prices.Make({ faction = "H", auctionDB = function(item)
        return hoT.ah[item] or hoE.ah[item], hoT.scanTs end })
    local function hoRows(enchanting, bags)
        return Disenchant.Build(en, { skill = enchanting, faction = "H", known = hoE.known, owned = {} }, qho,
            { crafts = { { data = ns.TAILORING, state = { skill = 103, faction = "H", level = 20, known = hoT.known,
                                                         owned = hoT.owned } } }, bags = bags })
    end
    local function named(list, name)
        for _, r in ipairs(list.steps) do
            if ns.TAILORING.recipes[r.recipe].name == name then return r end
        end
    end
    local ho = hoRows(150)
    assert(ho.known == 13 and ho.bags == 0 and ho.now == #ho.steps and #ho.steps > 0,
        ("Disenchant: Ho's rows (%d of %d known)"):format(#ho.steps, ho.known))
    for i, r in ipairs(ho.steps) do
        local rec = ns.TAILORING.recipes[r.recipe]
        assert(r.data == ns.TAILORING and DE.items[rec.makes] == r.bucket and hoT.known[r.recipe],
            "... a Tailoring recipe Ho knows, its item's bucket")
        assert(r.each > r.sale.each and r.profit == r.back - r.cost and r.cost == r.matCost and not r.needSkill,
            "... worth more disenchanted than sold: " .. rec.name)
        assert(i == 1 or r.profit <= ho.steps[i - 1].profit, "... the best first")
    end
    -- Novice Arcanist's Sash, a blue of level 15: a bucket Forever added, a green's of its level and one more of each
    -- (2-3 Strange Dust): a vendor pays more than its average disenchant at Ho's prices, so it isn't here
    local sashSpell, sashRec = spellNamed(ns.TAILORING, "Novice Arcanist's Sash")
    local sashBucket = DE.items[sashRec.makes]
    local sashTable = DE.buckets[sashBucket]
    assert(sashTable.guess and sashTable.gives[2].item == 10940 and sashTable.gives[2].min == 2
        and sashTable.gives[2].max == 3 and hoT.known[sashSpell] and not named(ho, "Novice Arcanist's Sash"),
        "Disenchant: a blue of level 15 gives 2-3 Strange Dust, worth less than a vendor pays for it")
    assert(not named(ho, "White Woolen Dress"), "... White Woolen Dress sells for more: not here")
    -- the bags: two Double-stitched Woolen Shoulders (worth more disenchanted than sold) and a soulbound Novice
    -- Arcanist's Sash (a vendor pays more): the shoulders first, gaining over selling; the sash to a vendor; the
    -- shoulders no longer among what to make
    local shoulders = ns.TAILORING.recipes[3848].makes
    local function bag(item, count, bound)
        return { item = item, count = count, bound = bound, bucket = DE.items[item],
                 sell = ns.TAILORING.sell[item] or 0 }
    end
    local withBags = hoRows(150, { bag(sashRec.makes, 1, true), bag(shoulders, 2, false) })
    local first, second = withBags.steps[1], withBags.steps[2]
    assert(withBags.bags == 2 and first.kind == "bag" and first.item == shoulders and first.disenchant
        and Disenchant.Verdict(first) == "disenchant", "Disenchant: the bags first, what to disenchant first")
    check("... what disenchanting both gains over selling them", first.gain, 2 * (first.each - first.sale.each))
    assert(second.item == sashRec.makes and second.bound and not second.disenchant and second.sale.how == "vendor"
        and second.sale.each == ns.TAILORING.sell[sashRec.makes] and Disenchant.Verdict(second) == "sell to a vendor",
        "... a soulbound sash: a vendor's price, sold")
    check("... the shoulders aren't among what to make", #withBags.steps, #ho.steps + 1)
    -- what the game gave replaces a bucket's table from 5 disenchants: 4 sashes that gave a Small Glimmering Shard
    -- leave it, the 5th (3 Strange Dust) makes it theirs: the shard 4 in 5, the dust 1 in 5; worth more than a vendor
    -- pays now
    local log = {}
    for i, got in ipairs({ "10978:1", "10978:1", "10978:1", "10978:1", "10940:3" }) do
        log[i] = ("%d %d %s"):format(sashRec.makes, 1792000000 + i, got)
    end
    local function bucketOf(item) return DE.items[item] end
    local four = Disenchant.Seen({ log[1], log[2], log[3], log[4] }, bucketOf)
    assert(four[sashBucket].n == 4 and Disenchant.Table(sashBucket, four) == sashTable
        and four[sashBucket].mats[10978].total == 4, "Disenchant: 4 recorded, the data's table still")
    local five = Disenchant.Seen(log, bucketOf)
    local own = Disenchant.Table(sashBucket, five)
    assert(own.seen == 5 and own.gives[1].item == 10978 and own.gives[1].min == 1 and own.gives[2].item == 10940
        and own.gives[2].min == 3 and own.gives[2].max == 3 and own.skill == sashTable.skill, "... 5: what they gave")
    check("... the shard in 4 of 5", own.gives[1].chance, 0.8)
    local withSeen = Disenchant.Build(en, { skill = 150, faction = "H", known = hoE.known, owned = {} }, qho,
        { crafts = { { data = ns.TAILORING, state = { skill = 103, faction = "H", level = 20, known = hoT.known,
                                                     owned = hoT.owned } } }, seen = five })
    local sashSeen = named(withSeen, "Novice Arcanist's Sash")
    assert(sashSeen and sashSeen.de.seen == 5 and sashSeen.seen.n == 5, "... and the ladder prices it so")
    local hoLow = hoRows(1)
    for i, r in ipairs(hoLow.steps) do
        assert((i > hoLow.now) == (DE.buckets[r.bucket].skill > 1) and (r.needSkill or 1) == DE.buckets[r.bucket].skill,
            "Disenchant: at Enchanting 1 what asks more comes last, with the skill it asks")
    end
    check("... the same rows", #hoLow.steps, #ho.steps)
end)()

-- a real ladder
local fx = dofile(root .. "tests/fixtures/" .. fixtureName .. ".lua")
data = ns.ProfessionByKey[fx.profession or "cooking"]
local quote, lookup = ns.Prices.Make({
    faction = fx.faction,
    auctionDB = function(item) return fx.ah[item], fx.scanTs end,
})
local t0 = os.clock()
local build = data.kind == "fishing" and ns.Fishing.Build or data.kind == "mining" and ns.Mining.Build or Ladder.Build
local ladder = build(data, { skill = fx.skill, maxSkill = fx.maxSkill, target = target or fx.maxSkill,
    faction = fx.faction, level = fx.level, known = fx.known, owned = fx.owned }, quote,
    { smelt = data.smelt and { skill = fx.mining or 0, recipes = ns.MINING.recipes } or nil,
      vendorOnly = data.resale or nil }) -- as the game's default: Skill, only vendors buy
local ms = (os.clock() - t0) * 1000
-- a recipe a step learns is known in later steps only as learned earlier in the ladder, at that step's skill
for _, s in ipairs(ladder.steps) do
    if s.kind == "craft" and s.learn and s.learn.kind == "known" then
        assert((fx.known or {})[s.recipe] or type(s.learn.earlier) == "number" and s.learn.earlier < s.from,
            ("%s at %d: known only from an earlier step"):format(data.recipes[s.recipe].name, s.from))
    end
end

local function money(c)
    if not c then return "?" end
    c = math.floor(c + 0.5)
    local g, s, k = math.floor(c / 10000), math.floor(c / 100) % 100, c % 100
    return (g > 0 and g .. "g " or "") .. ((g > 0 or s > 0) and s .. "s " or "") .. k .. "c"
end
local function itemName(i) return ns.Lookup("items", i) or ("item " .. i) end
local function learnText(w)
    if not w then return "" end
    if w.kind == "known" then return w.earlier and ("learned at " .. tostring(w.earlier)) or "known" end
    if w.kind == "owned" then return "recipe in your bags" end
    if w.kind == "start" then return "known from the start" end
    if w.kind == "trainer" then return "trainer " .. money(w.cost) .. (w.guess and " (guess)" or "") end
    if w.kind == "vendor" then
        return ("vendor %s %s%s%s"):format(data.npcs[w.npc] and data.npcs[w.npc].name or w.npc,
            w.favor and (w.favor .. " favor") or money(w.cost), w.limited and " (limited)" or "", w.guess and " (estimate)" or "")
    end
    if w.kind == "quest" then return "quest " .. (data.quests[w.quest] and data.quests[w.quest].name or w.quest) end
    if w.kind == "ah" then return "auction house " .. money(w.cost) end
    return w.kind
end

print(("%s (%s, level %d) %s %d -> %d, calculated in %.1f ms"):format(fx.name, fx.faction, fx.level, data.name,
    ladder.from, ladder.to, ms))
for _, s in ipairs(ladder.steps) do
    if s.kind == "rank" then
        print(("  at %3d  LEARN %s (cap %d): %s%s  %s"):format(s.from, s.rank.name, s.rank.cap, s.rank.how,
            s.needLevel and (" - needs level " .. s.needLevel) or "", money(s.cost)))
        for item, b in pairs(s.buy or {}) do
            local d = lookup(item)
            print(("             quest needs %d %s: %s%s"):format(b.need, data.items[item] or item, money(b.cost),
                d and d.qty and (" [" .. d.qty .. " listed" .. (b.short and ", NOT ENOUGH" or "") .. "]") or ""))
        end
    elseif s.kind == "fish" then
        local zone = data.zones[s.zone]
        local bring = {}
        for item, b in pairs(s.buy) do
            bring[#bring + 1] = ("%d %s%s: %s"):format(b.need, data.items[item], b.have > 0 and (" (have " .. b.have .. ")") or "",
                money(b.cost or 0))
        end
        print(("  %3d-%3d  fish in %-22s ~%4d catches, %3d%% land, %-9s worth %s/catch  %s%s"):format(s.from, s.to,
            zone.name, math.ceil(s.crafts), math.floor(s.landed * 100 + 0.5), money(s.cost), money(s.value),
            table.concat(bring, "; "), s.chosenByYou and "  [YOUR PICK]" or ""))
        for i, o in ipairs(s.options) do
            if i > 1 or o.zone ~= s.zone then
                print(("             or %-22s %3d%% land%s, worth %s/catch%s"):format(o.name, math.floor(o.landed * 100 + 0.5),
                    o.lure and (" with " .. data.items[o.lure]) or "", money(o.value), o.dangerous and " (DANGEROUS)" or ""))
            end
        end
    elseif s.kind == "mine" then
        local bars = {}
        for spell, n in pairs(s.bars) do bars[#bars + 1] = ("%d %s"):format(n + 0.5, data.recipes[spell].name) end
        print(("  %3d-%3d  mine in %-22s ~%4d nodes, trainer %-8s smelt: %s%s"):format(s.from, s.to,
            data.zones[s.zone].name, math.ceil(s.crafts), money(s.cost), table.concat(bars, ", "),
            s.chosenByYou and "  [YOUR PICK]" or ""))
        for i, o in ipairs(s.options) do
            if i > 1 or o.recipe ~= s.recipe then
                print(("             or %-26s %s"):format(o.name, o.zone and ("~%d nodes"):format(o.crafts) or
                    (("%d-%d, %s/point"):format(o.from, o.to, o.perPoint and money(o.perPoint) or "?"))))
            end
        end
    else
        local rec = data.recipes[s.recipe]
        print(("  %3d-%3d  %-28s %-6s ~%3d crafts  %-12s learn: %s%s%s"):format(s.from, s.to, rec.name, s.color,
            math.ceil(s.crafts), money(s.cost), learnText(s.learn), s.missing and "  [NO PRICE: " .. data.items[s.missing] .. "]" or "",
            s.fromBags and "  [WITH WHAT YOU HAVE]" or ""))
        local parts = {}
        for item, b in pairs(s.buy) do
            local d = lookup(item)
            if b.make then
                local made = {}
                for part, pb in pairs(b.make.parts) do
                    made[#made + 1] = ("%d %s%s"):format(math.ceil(pb.need), itemName(part),
                        pb.make and " (made too)" or "")
                end
                parts[#parts + 1] = ("%d %s%s: MAKE (%s) %s from %s"):format(math.ceil(b.need), itemName(item),
                    b.have > 0 and (" (have " .. math.floor(b.have) .. ")") or "",
                    b.make.mining and "smelt" or "craft", money(b.cost), table.concat(made, ", "))
            else
            parts[#parts + 1] = ("%d %s%s: %s%s%s"):format(math.ceil(b.need), itemName(item),
                b.have > 0 and (" (have " .. math.floor(b.have) .. ")") or "",
                b.buy <= 0 and "you have enough" or money(b.cost),
                b.buy > 0 and b.cost and (" = " .. money(b.cost / b.buy) .. " each") or "",
                d and d.qty and (" [" .. d.qty .. " listed" .. (b.short and ", NOT ENOUGH" or "") .. (d.listed and "" or ", not in last scan") .. "]") or
                (d and d.source == "vendor" and " [vendor]" or ""))
            end
        end
        print("             buy: " .. table.concat(parts, "; ") .. (s.tool and "  [TOOL, KEPT]" or ""))
        for item, k in pairs(s.keep or {}) do
            print(("             keep: %d %s for %d-%d"):format(math.floor(k.n + 0.5), itemName(item), k.from, k.to))
        end
        if s.sale then
            print(("             sell: %d at the AH (%s each), %d to a vendor (%s each) = %s back"):format(
                math.floor(s.sale.ah + 0.5), money(s.sale.ahEach), math.floor(s.sale.vendor + 0.5),
                money(s.sale.vendorEach), money(s.sale.total)))
        end
        for i, o in ipairs(s.options) do
            if i > 1 or o.recipe ~= s.recipe then
                print(("             or %-26s %-6s %3d-%3d  %s/point%s"):format(o.name, o.color, o.from, o.to,
                    o.perPoint and money(o.perPoint) or "?", o.missing and (" (no price: " .. (data.items[o.missing] or o.missing) .. ")") or
                    (" learn: " .. learnText(o.learn))))
            end
        end
    end
end
print(("TOTAL %s%s, ~%d %s%s"):format(money(ladder.cost),
    (ladder.back or 0) > 0 and (", " .. money(ladder.back) .. " back from sales") or "",
    math.ceil(ladder.nodes or ladder.crafts), ladder.nodes and "nodes" or "crafts",
    ladder.stuck and (" - STOPPED: " .. ladder.stuck) or ""))
if data.resale then -- Skill + Gold: the same counting the auction house; Gold: what earns most now
    local sell = Ladder.Build(data, { skill = fx.skill, maxSkill = fx.maxSkill, target = target or fx.maxSkill,
        faction = fx.faction, level = fx.level, known = fx.known, owned = fx.owned }, quote,
        { smelt = { skill = fx.mining or 0, recipes = ns.MINING.recipes } })
    print(("SKILL + GOLD: %s, %s back from sales"):format(money(sell.cost), money(sell.back)))
    local list = Ladder.Profits(data, { skill = fx.skill, maxSkill = fx.maxSkill, faction = fx.faction, level = fx.level,
        known = fx.known, owned = fx.owned }, quote, { smelt = { skill = fx.mining or 0, recipes = ns.MINING.recipes } })
    print(("GOLD at %d: %d recipes earn"):format(fx.skill, #list.steps))
    for i = 1, math.min(10, #list.steps) do
        local r = list.steps[i]
        print(("  +%-12s %-28s x%-3d costs %-12s sells %-12s %-12s%s"):format(money(r.profit),
            data.recipes[r.recipe].name, r.made, money(r.cost), money(r.back),
            r.vendor and "AT A VENDOR" or (r.listed .. " listed"), r.payback and
            (" learn: " .. learnText(r.learn) .. ", pays back after " .. r.payback) or ""))
    end
end
if data.kind then -- gathering, Gold: the zones by gold an hour at your skill now
    local list = build(data, { skill = fx.skill, maxSkill = fx.maxSkill, faction = fx.faction, level = fx.level,
        known = fx.known, owned = fx.owned }, quote, { mode = "gold" })
    print(("GOLD at %d: %d zones"):format(fx.skill, #list.steps))
    for i = 1, math.min(10, #list.steps) do
        local z = list.steps[i]
        print(("  %-12s an hour  %-28s ~%3d an hour, %-10s each%s"):format(money(z.perHour), data.zones[z.zone].name,
            z.crafts + 0.5, money(z.value), z.dangerous and "  DANGEROUS" or ""))
    end
end
print(failed == 0 and "rule tests OK" or (failed .. " rule tests FAILED"))
os.exit(failed == 0 and 0 or 1)
