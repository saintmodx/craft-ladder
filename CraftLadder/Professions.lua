-- Craft Ladder: the professions it knows, in tab order. Each one's data (Data/*.lua) gets what the code needs to know
-- about it: the skill line the game reports it as, the Apprentice spell (its name is the profession's name in the
-- player's language), its icon and the verb for crafting it.
local _, ns = ...

ns.Professions = {}
ns.ProfessionByKey = {}

local function add(data, info)
    for k, v in pairs(info) do data[k] = v end
    ns.Professions[#ns.Professions + 1] = data
    ns.ProfessionByKey[data.key] = data
end

-- Cooking and First Aid: what they make is sold, as the main crafts' (resale); Cooking has a Food mode too (food: the
-- dishes worth eating for your class)
add(ns.COOKING, { key = "cooking", name = "Cooking", skillLine = 185, apprentice = 2550, icon = 133971, verb = "cook",
                  secondary = true, resale = true, food = true })
add(ns.FIRSTAID, { key = "firstaid", name = "First Aid", skillLine = 129, apprentice = 3273, icon = 135966, verb = "make",
                   secondary = true, resale = true })
add(ns.FISHING, { key = "fishing", name = "Fishing", skillLine = 356, apprentice = 7620, icon = 136245, verb = "catch",
                  secondary = true,
                  kind = "fishing" })
-- gather: the words for what Mining's ladder gathers (Skinning skins creatures with it)
add(ns.MINING, { key = "mining", name = "Mining", skillLine = 186, apprentice = 2575, icon = 136248, verb = "smelt",
                 kind = "mining", window = "Smelting",
                 gather = { verb = "Mine", one = "node", many = "nodes", here = "Nodes here" } })
add(ns.HERBALISM, { key = "herbalism", name = "Herbalism", skillLine = 182, apprentice = 2366, icon = 136246,
                    verb = "gather", kind = "mining", mergeSteps = true,
                    gather = { verb = "Gather", one = "herb", many = "herbs", here = "Herbs here" } })
add(ns.SKINNING, { key = "skinning", name = "Skinning", skillLine = 393, apprentice = 8613, icon = 134366,
                   verb = "skin", kind = "mining",
                   gather = { verb = "Skin", one = "creature", many = "creatures", here = "Creatures to skin here" } })
-- Lockpicking: rogues only (class), no Apprentice spell (its name is the skill's), the cap is the level x 5
-- (levelCaps), Skill only (skillOnly); chests are nodes, boxes from the bags recipes ("picks")
add(ns.LOCKPICKING, { key = "lockpicking", name = "Lockpicking", skillLine = 633, icon = 136058, verb = "pick",
                      kind = "mining", levelCaps = true, skillOnly = true, class = "ROGUE", trainer = "Rogue",
                      craftWord = "picks", chainTitle = "Your class quests at 16",
                      chainNote = "They lead to the first practice chests and give you Thieves' Tools. Pick Lock" ..
                          " itself is learned from any rogue trainer, quest or not.",
                      gather = { verb = "Pick locks", one = "lock", many = "locks", here = "Locks here" } })
ns.LOCKPICKING.tools = { [5060] = true } -- Thieves' Tools
-- Blacksmithing, Engineering, Tailoring, Leatherworking, Alchemy and Enchanting: what they make is sold (resale; an enchantment makes nothing);
-- bars may be smelted from ore (smelt)
add(ns.BLACKSMITHING, { key = "blacksmithing", name = "Blacksmithing", skillLine = 164, apprentice = 2018, icon = 136241,
                        verb = "make", resale = true, smelt = true })
add(ns.ENGINEERING, { key = "engineering", name = "Engineering", skillLine = 202, apprentice = 4036, icon = 136243,
                      verb = "make", resale = true, smelt = true })
add(ns.TAILORING, { key = "tailoring", name = "Tailoring", skillLine = 197, apprentice = 3908, icon = 136249, verb = "make",
                    resale = true })
add(ns.LEATHERWORKING, { key = "leatherworking", name = "Leatherworking", skillLine = 165, apprentice = 2108,
                         icon = 136247, verb = "make", resale = true })
add(ns.ALCHEMY, { key = "alchemy", name = "Alchemy", skillLine = 171, apprentice = 2259, icon = 136240, verb = "make",
                  resale = true, smelt = true })
add(ns.ENCHANTING, { key = "enchanting", name = "Enchanting", skillLine = 333, apprentice = 7411, icon = 136244,
                     verb = "make", resale = true, smelt = true })
-- Poisons: rogues only, learned from a class quest at 20, the cap is the level x 5 (levelCaps), Skill only; what it
-- makes is kept for the rogue's weapons, not sold
add(ns.POISONS, { key = "poisons", name = "Poisons", skillLine = 40, icon = 136242, verb = "make", levelCaps = true,
                  skillOnly = true, class = "ROGUE", trainer = "Rogue", chainTitle = "Your class quests at 20",
                  chainNote = "The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock:" ..
                      " Lockpicking 70 for the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox" ..
                      " (Classic's numbers, not confirmed in Forever)." })

-- What Fishing uses from your bags: poles and lures.
ns.FISHING.tools = {}
for item in pairs(ns.FISHING.gear.poles) do ns.FISHING.tools[item] = true end
for item in pairs(ns.FISHING.gear.lures) do ns.FISHING.tools[item] = true end

-- What Blacksmithing, Engineering, Alchemy and Enchanting use from your bags besides their reagents: their tools (a
-- hammer, an Arclight Spanner, a Philosopher's Stone, a Runed Copper Rod), and ore and Coal to smelt bars from.
for _, data in ipairs({ ns.BLACKSMITHING, ns.ENGINEERING, ns.ALCHEMY, ns.ENCHANTING }) do
    data.tools = {}
    for _, kind in pairs(data.toolKinds) do
        for _, item in ipairs(kind.items) do data.tools[item] = true end
    end
    for _, rec in pairs(ns.MINING.recipes) do
        for item in pairs(rec.mats) do data.tools[item] = true end
    end
end

-- An NPC, quest or item from whichever profession's data has it (the ids are the game's, so they never clash).
function ns.Lookup(section, id)
    if id == nil then return nil end
    for _, data in ipairs(ns.Professions) do
        local v = data[section][id]
        if v ~= nil then return v end
    end
end

-- A recipe and the profession it belongs to, by its spell.
function ns.FindRecipe(spell)
    for _, data in ipairs(ns.Professions) do
        local rec = data.recipes[spell]
        if rec then return rec, data end
    end
end
