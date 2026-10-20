-- Loads every profession's data the way WoW does (as addon files with ADDON, ns) and checks their references.
--   luajit tests/check_data.lua
local root = (arg[0]:match("^(.*)[/\\]tests[/\\]") or ".") .. "/"
local ns = {}
for _, file in ipairs({ "Data/Cooking.lua", "Data/FirstAid.lua", "Data/Fishing.lua", "Data/Mining.lua", "Data/Skinning.lua", "Data/Herbalism.lua", "Data/Lockpicking.lua", "Data/Blacksmithing.lua", "Data/Engineering.lua", "Data/Tailoring.lua", "Data/Enchanting.lua", "Data/Alchemy.lua", "Data/Leatherworking.lua", "Data/Poisons.lua", "Data/Camp.lua", "Data/Disenchant.lua", "Professions.lua" }) do
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
        if q.ender and not data.npcs[q.ender] then problem("quest %s: ender %d not in npcs", q.name, q.ender) end
    end
    -- a specialization's steps: their quests, NPCs and items are in the data, both sides have a way through
    local function questStep(g, s)
        local sides = ""
        for _, q in ipairs(s.quests) do
            if not data.quests[q] then problem("%s spec %d: quest %d missing", data.name, g.spec, q) end
            sides = sides .. (data.quests[q] and data.quests[q].faction or "")
        end
        for _, x in ipairs(s.items or {}) do
            if not data.items[x.item] then problem("%s spec %d: item %d has no name", data.name, g.spec, x.item) end
            for _, npc in ipairs(x.drops or {}) do
                if not data.npcs[npc] then problem("%s spec %d: drop %d not in npcs", data.name, g.spec, npc) end
            end
        end
        return sides
    end
    for _, g in ipairs(data.specGuides or {}) do
        if not data.specs[g.spec] then problem("%s spec %d: no name", data.name, g.spec) end
        local sides = ""
        for _, s in ipairs(g.steps) do
            if s.talk then
                for _, npc in ipairs(s.talk) do
                    if not data.npcs[npc] then problem("%s spec %d: NPC %d missing", data.name, g.spec, npc) end
                end
            elseif s.pick then
                for _, o in ipairs(s.pick) do questStep(g, o) end
            else
                sides = questStep(g, s)
            end
        end
        if not (sides:find("A") and sides:find("H")) then problem("%s spec %d: no last quest for a side", data.name, g.spec) end
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

-- disenchanting: each bucket's outcomes make 100%, every material has a name, every crafted item's bucket exists and
-- some profession makes it
local DE, made = ns.DISENCHANT, {}
for _, data in ipairs(ns.Professions) do
    for _, r in pairs(data.recipes) do if r.makes then made[r.makes] = true end end
end
for id, b in pairs(DE.buckets) do
    local sum = 0
    for _, g in ipairs(b.gives) do
        sum = sum + g.chance
        if not DE.names[g.item] or g.min < 1 or g.max < g.min then
            problem("Disenchant bucket %d: item %d", id, g.item)
        end
    end
    -- (what the game gave may hold two materials in one disenchant: 100% or more)
    local off = b.seen and sum < 1 - 1e-6 or not b.seen and math.abs(sum - 1) > 1e-6
    if off or not (b.skill >= 1 and b.skill <= 300) then
        problem("Disenchant bucket %d: %g%%, skill %d", id, sum * 100, b.skill)
    end
end
local deItems = 0
for item, id in pairs(DE.items) do
    deItems = deItems + 1
    if not DE.buckets[id] or not made[item] then problem("Disenchant item %d: bucket %d, not made", item, id) end
end
for lesser, greater in pairs(DE.greater) do
    if not (DE.names[lesser] and DE.names[greater]) then problem("Disenchant: essence %d or %d", lesser, greater) end
end
print(("Disenchant built %s: %d crafted items"):format(DE.built, deItems))

for _, p in ipairs(problems) do print("PROBLEM: " .. p) end
print(#problems == 0 and "OK" or (#problems .. " problems"))
os.exit(#problems == 0 and 0 or 1)
