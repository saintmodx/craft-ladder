-- Loads every profession's data the way WoW does (as addon files with ADDON, ns) and checks their references.
--   luajit tests/check_data.lua
local root = (arg[0]:match("^(.*)[/\\]tests[/\\]") or ".") .. "/"
local ns = {}
for _, file in ipairs({ "Data/Cooking.lua", "Data/FirstAid.lua", "Data/Fishing.lua", "Data/Mining.lua", "Data/Skinning.lua", "Data/Herbalism.lua", "Data/Lockpicking.lua", "Data/Blacksmithing.lua", "Data/Engineering.lua", "Data/Tailoring.lua", "Data/Enchanting.lua", "Data/Alchemy.lua", "Data/Leatherworking.lua", "Data/Poisons.lua", "Data/Camp.lua", "Professions.lua" }) do
    assert(loadfile(root .. "CraftLadder/" .. file))("CraftLadder", ns)
end

local problems = {}
local function problem(...) problems[#problems + 1] = string.format(...) end

for _, data in ipairs(ns.Professions) do
    local recipes = 0
    for _, r in pairs(data.recipes) do
        recipes = recipes + 1
        if #r.colors ~= 4 then problem("%s: colors has %d values", r.name, #r.colors) end
        for item in pairs(r.mats) do
            if not data.items[item] then problem("%s: ingredient %d has no name", r.name, item) end
        end
        for _, g in ipairs(r.get) do
            if g.kind == "vendor" and not data.npcs[g.npc] then problem("%s: vendor %d not in npcs", r.name, g.npc) end
            if g.kind == "quest" and not data.quests[g.quest] then problem("%s: quest %d not in quests", r.name, g.quest) end
        end
    end
    for _, rank in ipairs(data.ranks) do
        local quests = type(rank.quest) == "table" and rank.quest or { rank.quest }
        for _, q in pairs(quests) do
            if not data.quests[q] then problem("%s rank %s: quest %d missing", data.name, rank.name, q) end
        end
        for _, v in ipairs(rank.vendors or {}) do
            if not data.npcs[v.npc] then problem("%s rank %s: vendor %d missing", data.name, rank.name, v.npc) end
        end
    end
    for _, q in pairs(data.quests) do
        if q.giver and not data.npcs[q.giver] then problem("quest %s: giver %d not in npcs", q.name, q.giver) end
    end
    print(("%s built %s: %d recipes, %d ranks"):format(data.name, data.built, recipes, #data.ranks))
end

-- Mining: a pick stores a zone's map id or a recipe's spell in the same field, so they must never be the same number
local mining = ns.MINING
for map, z in pairs(mining.zones) do
    if mining.recipes[map] then problem("Mining: zone %s has a recipe's id", z.name) end
    for id in pairs(z.nodes) do
        if not mining.nodes[id] then problem("Mining %s: node %d unknown", z.name, id) end
    end
end
for _, n in pairs(mining.nodes) do
    for item in pairs(n.ore) do
        if not mining.items[item] then problem("Mining %s: ore %d has no name", n.name, item) end
    end
end

-- camps: every feature says what it gives up to 60, and every camp item's profession and ingredients are known
local function campItem(e, what)
    if not ns.ProfessionByKey[e.prof or ""] then
        problem("Camp %s %s: profession %s unknown", what, e.name, tostring(e.prof))
    end
    if not e.maker or not next(e.mats or {}) then problem("Camp %s %s: no recipe or ingredients", what, e.name) end
    for item in pairs(e.mats or {}) do
        if not ns.CAMP.items[item] then problem("Camp %s %s: ingredient %d has no name", what, e.name, item) end
    end
end
for _, f in ipairs(ns.CAMP.fires) do
    campItem(f, "campfire")
    if not (f.slots and f.slots > 0) then problem("Camp campfire %s: no slots", f.name) end
end
for _, f in ipairs(ns.CAMP.features) do
    campItem(f, "feature")
    if not f.kind or f.gives[#f.gives][1] ~= 60 then problem("Camp feature %s: no kind, or not up to 60", f.name) end
    for _, u in ipairs(f.upgrades or {}) do campItem(u, "upgrade") end
end
for _, f in ipairs(ns.CAMP.others) do campItem(f, "feature") end

for _, p in ipairs(problems) do print("PROBLEM: " .. p) end
print(#problems == 0 and "OK" or (#problems .. " problems"))
os.exit(#problems == 0 and 0 or 1)
