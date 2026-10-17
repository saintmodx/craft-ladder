-- Craft Ladder: camps (WoW Forever). A campfire holds a few camp features; sitting or crafting near it for a while
-- gives each one's buff. For the character's role: the features in the order they help it, what each gives at its
-- level (as the game's tooltip says), and how to get it: the profession that makes it, whether you know the recipe,
-- how many you have, what its ingredients and the auction house cost. Data/Camp.lua is the client's.
local _, ns = ...

local Camp = {}
ns.Camp = Camp

-- What each role wants from a camp, best first (a guess, see ASSUMPTIONS.md); a feature not listed doesn't help it.
-- Rested experience helps everyone below the top level, the reagent bot everyone, after the role's own.
local WANTS = {
    Melee = { "ap", "str", "crit", "stats", "sta", "armor" },
    Ranged = { "crit", "stats", "mp5", "int", "sta", "armor" },
    Tank = { "sta", "armor", "stats", "str", "ap", "crit" },
    Caster = { "int", "crit", "mp5", "spi", "stats", "sta" },
    Healer = { "mp5", "int", "spi", "stats", "crit", "sta" },
}
local MAX_LEVEL = 60

-- The roles a class camps for: Food's (a hybrid has several).
function Camp.Roles(class)
    return ns.Ladder.ROLES[class] or { "Melee" }
end

-- What a feature gives at `level`, as its tooltip says then.
function Camp.Gives(f, level)
    for _, g in ipairs(f.gives) do
        if level <= g[1] then return g[2] end
    end
    return f.gives[#f.gives][2]
end

-- The features in the order `role` wants them, then what doesn't help it: { feature, useful } each. A banner of the
-- other side is left out (faction: "A" or "H").
function Camp.Order(role, level, faction)
    local rank = {}
    for i, kind in ipairs(WANTS[role] or {}) do rank[kind] = i end
    if level < MAX_LEVEL then rank.rested = 50 end
    rank.vendor = 51
    local out = {}
    for _, f in ipairs(ns.CAMP.features) do
        if not f.faction or f.faction == faction then out[#out + 1] = { feature = f, useful = rank[f.kind] ~= nil } end
    end
    table.sort(out, function(a, b)
        local ra, rb = rank[a.feature.kind] or 99, rank[b.feature.kind] or 99
        if ra ~= rb then return ra < rb end
        return a.feature.name < b.feature.name
    end)
    return out
end

-- The best campfire this character can make or has (its index in ns.CAMP.fires), else the basic one.
function Camp.BestFire(known)
    local best = 1
    for i, fire in ipairs(ns.CAMP.fires) do
        if known(fire) or (C_Item.GetItemCount(fire.item, true) or 0) > 0 then best = i end
    end
    return best
end

-- Whether this character knows the recipe that makes a camp item. byProf remembers each profession's known recipes
-- for one drawing (reading them asks the game about every recipe).
function Camp.Knows(e, byProf)
    local prof = ns.ProfessionByKey[e.prof or ""]
    if prof and prof.recipes[e.maker] then
        byProf[prof] = byProf[prof] or ns.Player.Known(prof)
        return byProf[prof][e.maker] == true
    end
    return IsPlayerSpell ~= nil and e.maker ~= nil and IsPlayerSpell(e.maker) -- a gathering profession's
end

-- How to get a camp item: { prof (its profession), has (the character has it), skill (the skill its recipe asks, when
-- the data knows), known, owned, cost (its ingredients, nil when one has no price), ah (one at the auction house) }.
function Camp.Source(e, lookup, byProf)
    local prof = ns.ProfessionByKey[e.prof or ""]
    local cap = prof and select(2, ns.Player.Skill(prof)) or 0
    local rec = prof and prof.recipes[e.maker]
    local cost = 0
    for item, n in pairs(e.mats or {}) do
        local p = lookup(item)
        cost = cost and p and cost + p.unit * n or nil
    end
    local ah = lookup(e.item, true)
    return { prof = prof, has = cap > 0, skill = rec and rec.learn, known = Camp.Knows(e, byProf),
             owned = C_Item.GetItemCount(e.item, true) or 0, cost = cost, ah = ah and ah.unit }
end

function Camp.ItemName(item)
    return ns.CAMP.items[item] or ns.Describe.ItemName(item)
end
