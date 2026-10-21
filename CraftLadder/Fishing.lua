-- Craft Ladder: the Fishing ladder. Fishing has no recipes: every fish caught may raise the skill, wherever it's caught.
-- So a step is a stretch of skill and a zone to fish it in: one where fish don't get away (with a lure if that's
-- what it takes), and of those the one whose catch is worth the most at the auction house. Rank-ups come where they
-- can be learned, as in the other ladders. The calculation is pure Lua (tests run it outside the game); the end of
-- the file counts your catches in game, to learn how Forever's skill-ups compare with Classic's.
local _, ns = ...

local Fishing = {}
ns.Fishing = Fishing

local min, max, huge = math.min, math.max, math.huge
local CAST_SECONDS = 20 -- a cast and the wait for a bite, about

-- Chance that a catch raises the skill: every catch below 75, then 25 / (skill - 50) (Classic's rule: 1 in 2 at
-- 100, 1 in 4 at 150, 1 in 10 at 300), times `rate`: how Forever compares, from your own catches; plus Working
-- Overtime's (ns.Ladder.Bonus).
function Fishing.Chance(skill, rate)
    local c = skill < 75 and 1 or 25 / (skill - 50)
    return min(1, c * (rate or 1) + ns.Ladder.Bonus())
end

-- Catches from skill a to b, on average.
function Fishing.Catches(a, b, rate)
    local n = 0
    for s = a, b - 1 do n = n + 1 / Fishing.Chance(s, rate) end
    return n
end

-- Share of casts that land a fish: (effective skill - the zone's base + 5)%, so none get away from base + 95.
function Fishing.Landed(effective, base)
    return max(0, min(1, (effective - base + 5) / 100))
end

-- The best pole this character has: its skill bonus and item (nil: no pole at all).
local function bestPole(data, state)
    local bonus, item
    local function consider(i)
        local b = i and data.gear.poles[i]
        if b and (not bonus or b > bonus) then bonus, item = b, i end
    end
    consider(state.equipped)
    for i in pairs(data.gear.poles) do
        if (state.owned and state.owned[i] or 0) > 0 then consider(i) end
    end
    return bonus, item
end

-- Lures the character has or can buy, weakest first: { item, bonus, price (per lure, nil = only what you have) }.
local function lureList(data, ctx)
    local list = {}
    local perHour = 60 / data.gear.lureMinutes -- priced as an hour's worth: one cheap listing isn't the price of six
    for item, bonus in pairs(data.gear.lures) do
        local hour = ctx.quote(item, perHour, 0)
        local price = hour and hour / perHour
        if price or (ctx.owned[item] or 0) > 0 then list[#list + 1] = { item = item, bonus = bonus, price = price } end
    end
    table.sort(list, function(a, b)
        if a.bonus ~= b.bonus then return a.bonus < b.bonus end
        return (a.price or huge) < (b.price or huge)
    end)
    return list
end

local POOL_SHARE = 1 / 3 -- of your catches from fishing pools, in a zone that has them, if you fish them when you see them

local function lootValue(data, ctx, values, loot)
    local v = 0
    for item, share in pairs(loot) do v = v + share * ns.Prices.Worth(data, ctx.quote, values, item) end
    return v
end

-- The pool of a given name that fits a zone: pools come in tiers (the trunk they hold) that grow with the zone.
local function poolFor(data, name, zone)
    local tiers = data.poolTiers[name]
    if not tiers then return nil end
    local want = zone.base <= -20 and 1 or zone.base <= 55 and 2 or zone.base <= 130 and 3 or 4
    local best, bestGap
    for tier, entry in pairs(tiers) do
        local gap = math.abs(tier - want) + (tier > want and 0.5 or 0) -- a lower tier before a higher one
        if not bestGap or gap < bestGap then best, bestGap = entry, gap end
    end
    return best
end

-- A zone's fishing pools: { [pool] = { count, seen } } from the data, plus the ones GatherMate2 has seen there
-- (seen = true). nil when none is known.
local function zonePools(data, zone, seenPools)
    local pools, names = nil, {}
    for entry, count in pairs(zone.pools or {}) do
        pools = pools or {}
        pools[entry] = { count = count }
        names[data.pools[entry].name] = true
    end
    for name, count in pairs(seenPools and seenPools[zone.map] or {}) do
        local entry = not names[name] and poolFor(data, name, zone)
        if entry then
            pools = pools or {}
            pools[entry] = { count = (pools[entry] and pools[entry].count or 0) + count, seen = true }
        end
    end
    return pools
end

-- What a catch in a zone is worth on average: open water, and with pools a third of the catches from them (the pools
-- weighted by how many there are). Returns that, open water's value, the pools' value and the pools.
local function catchValue(data, ctx, values, zone, seenPools)
    local open = lootValue(data, ctx, values, zone.fish)
    local pools = zonePools(data, zone, seenPools)
    if not pools then return open, open end
    local total, sum = 0, 0
    for entry, p in pairs(pools) do
        total = total + p.count
        sum = sum + p.count * lootValue(data, ctx, values, data.pools[entry].fish)
    end
    local inPools = sum / total
    return (1 - POOL_SHARE) * open + POOL_SHARE * inPools, open, inPools, pools
end

-- Skill: among the zones where fish don't get away, the one needing the cheapest lure (none best), then the most
-- valuable catch. Skill + Gold ("sell"): the most gold per cast, lures paid.
local function rankBy(mode)
    return function(a, b)
        if a.tier ~= b.tier then return a.tier < b.tier end
        if mode ~= "sell" and a.lurePerCast ~= b.lurePerCast then return a.lurePerCast < b.lurePerCast end
        if a.score ~= b.score then return a.score > b.score end
        return a.recipe < b.recipe
    end
end

-- Builds the Fishing ladder. Same arguments and result as Ladder.Build, with:
--   state.equipped = the item in the main hand; opts.rate = skill-ups compared with Classic's rule (1 = the same);
--   opts.mode = "skill" or "sell" (Skill + Gold, see rankBy), or "gold": no ladder, the steps are the zones by what an
--   hour of fishing there earns at your skill (hour = true, crafts = catches an hour); opts.seenPools = { [ui map] = { [pool name] = count } } (GatherMate2).
-- A fishing step: { kind = "fish", from, to, zone (area id), crafts = catches, casts, landed (share of casts that
-- land a fish), lure (item or nil), buy = { [item] = { need, have, buy, cost } } (lures, a pole), cost, value (of
-- a catch), earn (what the catches are worth, lures paid), perHour (gold an hour), options = other zones,
-- chosenByYou }. The result also has earn, minutes, values = { [item] = { value, how } } and zones = { [area] =
-- { open, inPools, pools } } for what it priced.
function Fishing.Build(data, state, quote, opts)
    opts = opts or {}
    local Ladder = ns.Ladder
    local ctx = Ladder.NewContext(data, state, quote, opts)
    local rate = opts.rate or 1
    local castsPerLure = data.gear.lureMinutes * 60 / CAST_SECONDS
    local castsPerHour = 3600 / CAST_SECONDS
    local pole, poleItem = bestPole(data, state)
    local lures = lureList(data, ctx)
    local values, zoneValues, itemValues = {}, {}, {}
    local better = rankBy(opts.mode)
    -- from the range's start when one is picked (ns.Calculate), with the rank that skill needs
    local skill, cap = state.from or state.skill, state.fromCap or state.maxSkill or 0
    local target = state.target or cap
    local result = { from = skill, to = target, steps = {}, cost = 0, crafts = 0, earn = 0, missing = {},
                     values = itemValues, zones = zoneValues }
    local steps = result.steps

    -- No pole: the first step buys the cheapest one.
    local poleToBuy
    if not pole then
        local cheapest
        for item in pairs(data.gear.poles) do
            local p = ctx.quote(item, 1, 0)
            if p and (not cheapest or p < cheapest) then cheapest, poleToBuy = p, item end
        end
    end
    pole = pole or 0

    local function ours(zone) return zone.faction == "C" or zone.faction == ctx.faction end

    -- The lures `casts` casts take, those in your bags used first: what the rest cost and how many in all; no cost
    -- when you can't get enough (you have some, nobody sells them).
    local function lureCost(l, casts)
        local n = math.ceil(casts / castsPerLure)
        local short = max(0, n - (ctx.owned[l.item] or 0))
        if short == 0 then return 0, n end
        if l.price then return short * l.price, n end
    end

    -- One zone as an option for the stretch from `from` to `to` (or for `catches` catches): with the lure that keeps
    -- fish from getting away there for the least gold (none if the skill alone does), or the strongest one when
    -- nothing does.
    local function zoneOption(area, zone, from, to, catches)
        if not ours(zone) then return nil end
        local need = zone.base + 95 - from - pole
        catches = catches or Fishing.Catches(from, to, rate)
        local lure, cost, count
        if need > 0 then
            for _, l in ipairs(lures) do
                local c, n = lureCost(l, catches) -- no fish get away with it: every cast is a catch
                if l.bonus >= need and c and (not cost or c < cost) then lure, cost, count = l, c, n end
            end
            if not lure and lures[#lures] then
                local l = lures[#lures]
                local c, n = lureCost(l, catches / max(0.5, Fishing.Landed(from + pole + l.bonus, zone.base)))
                if c then lure, cost, count = l, c, n end
            end
        end
        local landed = Fishing.Landed(from + pole + (lure and lure.bonus or 0), zone.base)
        if landed < 0.5 then return nil end -- most casts would get away: not worth it
        if not values[area] then
            local v, open, inPools, pools = catchValue(data, ctx, itemValues, zone, opts.seenPools)
            values[area] = v
            zoneValues[area] = { open = open, inPools = inPools, pools = pools }
        end
        local casts = catches / landed
        local lurePerCast = (cost or 0) / casts
        local o = { recipe = area, zone = area, name = zone.name, from = from, to = to, crafts = catches, casts = casts,
                    landed = landed, lure = lure and lure.item, lureBonus = lure and lure.bonus,
                    luresNeeded = count or 0, value = values[area],
                    lurePerCast = lurePerCast, score = landed * values[area] - lurePerCast,
                    tier = landed >= 1 and 1 or 2 }
        o.perHour = castsPerHour * o.score
        if (state.level or 1) < zone.levels[1] - 3 then o.tier, o.dangerous = o.tier + 2, true end
        o.cost = cost or 0
        o.perPoint = o.cost / max(1, to - from)
        o.earn = catches * values[area] - o.cost
        return o
    end

    -- A step fishing a zone's option: its lures (and a pole when you have none) bought.
    local function fishStep(o, shown)
        local mats = {}
        if o.lure then mats[o.lure] = o.luresNeeded end
        if poleToBuy then mats[poleToBuy] = 1 end
        local cost, buy, missing = Ladder.Ingredients(ctx, { mats = mats }, 1)
        return { kind = "fish", from = o.from, to = o.to, zone = o.zone, recipe = o.zone, crafts = o.crafts,
                 casts = o.casts, landed = o.landed, lure = o.lure, buy = buy, cost = cost, missing = missing,
                 value = o.value, options = shown, dangerous = o.dangerous, earn = o.crafts * o.value - cost }
    end

    if opts.mode == "gold" then
        -- an hour of catches (the lures for them), where you're safe first, then by gold an hour
        for area, zone in pairs(data.zones) do
            local o = zoneOption(area, zone, skill, skill, castsPerHour)
            if o and o.perHour > 0 then
                local step = fishStep(o, {})
                step.hour, step.perHour, step.earn = true, o.perHour, o.perHour
                step.crafts, step.casts = castsPerHour * o.landed, castsPerHour -- some get away where landed < 1
                steps[#steps + 1] = step
                for item, b in pairs(step.buy) do
                    if b.buy > 0 and not b.cost then result.missing[item] = true end
                end
            end
        end
        table.sort(steps, function(a, b)
            if (a.dangerous or false) ~= (b.dangerous or false) then return not a.dangerous end
            if a.perHour ~= b.perHour then return a.perHour > b.perHour end
            return a.zone < b.zone
        end)
        result.to = skill
        return result
    end

    local guard = 0
    while skill < target do
        guard = guard + 1
        if guard > 100 then result.stuck = "loop"; break end

        local rank = Ladder.NextRank(data, cap)
        if rank and skill >= rank.learnAt and cap < target then
            local step = Ladder.RankStep(ctx, rank, skill)
            Ladder.Spend(ctx, step.buy or {})
            steps[#steps + 1] = step
            cap = rank.cap
            rank = Ladder.NextRank(data, cap)
        end
        local limit = min(cap, target)
        if skill >= limit then
            result.stuck = "cap"
            break
        end

        -- a stretch ends where a rank can be learned, or where a zone's fish stop getting away (with the
        -- strongest lure, or with none)
        local stop = limit
        if rank and cap < target and rank.learnAt > skill then stop = min(stop, rank.learnAt) end
        local strongest = lures[#lures] and lures[#lures].bonus or 0
        for _, zone in pairs(data.zones) do
            if ours(zone) then
                for _, at in ipairs({ zone.base + 95 - pole - strongest, zone.base + 95 - pole }) do
                    if at > skill and at < stop then stop = at end
                end
            end
        end

        local options = {}
        for area, zone in pairs(data.zones) do
            local o = zoneOption(area, zone, skill, stop)
            if o then options[#options + 1] = o end
        end
        table.sort(options, better)
        local chosen = options[1]
        local wanted = Ladder.ChoiceAt(opts.choices, skill)
        if wanted then
            for _, o in ipairs(options) do
                if o.recipe == wanted.recipe then chosen = o; break end
            end
        end
        if not chosen then
            result.stuck = "no zone"
            break
        end

        local shown = {}
        for i = 1, min(opts.maxOptions or 6, #options) do shown[i] = options[i] end
        local listed = false
        for _, o in ipairs(shown) do listed = listed or o == chosen end
        if not listed then shown[#shown + 1] = chosen end
        local step = fishStep(chosen, shown)
        poleToBuy = nil
        if chosen ~= options[1] then step.chosenByYou = true end
        for item, b in pairs(step.buy) do
            if b.buy > 0 and not b.cost then result.missing[item] = true end
        end
        Ladder.Spend(ctx, step.buy)
        steps[#steps + 1] = step
        skill = stop
    end

    -- one zone with one lure over stretches in a row is one step
    local merged = {}
    for _, s in ipairs(steps) do
        local last = merged[#merged]
        if last and last.kind == "fish" and s.kind == "fish" and last.zone == s.zone and last.lure == s.lure
            and last.to == s.from and (last.chosenByYou or false) == (s.chosenByYou or false) then
            last.to = s.to
            last.crafts, last.casts, last.cost = last.crafts + s.crafts, last.casts + s.casts, last.cost + s.cost
            last.earn = last.earn + s.earn
            last.landed = min(last.landed, s.landed)
            last.missing = last.missing or s.missing
            for item, b in pairs(s.buy) do
                local lb = last.buy[item]
                if lb then
                    lb.need, lb.have, lb.buy = lb.need + b.need, lb.have + b.have, lb.buy + b.buy
                    lb.cost = (lb.cost or b.cost) and (lb.cost or 0) + (b.cost or 0) or nil
                    lb.short = lb.short or b.short
                else
                    last.buy[item] = b
                end
            end
        else
            merged[#merged + 1] = s
        end
    end
    result.steps = merged
    result.minutes = 0
    for _, s in ipairs(merged) do
        result.cost = result.cost + (s.cost or 0)
        result.crafts = result.crafts + (s.crafts or 0)
        if s.kind == "fish" then
            local minutes = s.casts * CAST_SECONDS / 60
            s.perHour = s.earn / max(1e-9, minutes / 60)
            result.minutes = result.minutes + minutes
            result.earn = result.earn + s.earn
        end
    end
    return result
end

-- Minutes the casts of a step take, about.
function Fishing.Minutes(casts) return casts * CAST_SECONDS / 60 end

-- The fishing pools GatherMate2 has recorded where you fished, by map: { [ui map] = { [pool name] = count } }, or
-- nil without GatherMate2. Read like AuctionDB's prices: Craft Ladder records nothing itself.
function Fishing.SeenPools(data)
    local db = _G.GatherMate2FishDB
    if type(db) ~= "table" then return nil end
    local out = {}
    for map, nodes in pairs(db) do
        if type(map) == "number" and type(nodes) == "table" then
            for _, id in pairs(nodes) do
                local name = data.gm2[id]
                if name then
                    out[map] = out[map] or {}
                    out[map][name] = (out[map][name] or 0) + 1
                end
            end
        end
    end
    return out
end

---------------------------------------------------------------------------------------------------------------
-- In game: count catches and skill-ups, to learn how Forever's skill-ups compare with Classic's rule. Each catch
-- adds the Classic chance at that skill to `expected`; each point gained adds to `ups`. Catches at the rank's cap
-- don't count (they can't give a point).
---------------------------------------------------------------------------------------------------------------

-- The rate measured from your catches (1 until there are 50 of them), and the log.
function Fishing.Rate()
    local log = ns.db and ns.db.fishLog
    if log and log.catches >= 50 and log.expected > 0 then
        return max(0.25, min(4, log.ups / log.expected)), log
    end
    return 1, log
end

if CreateFrame then
    local frame = CreateFrame("Frame")
    for _, event in ipairs({ "LOOT_OPENED", "SKILL_LINES_CHANGED", "PLAYER_LOGIN" }) do
        pcall(frame.RegisterEvent, frame, event)
    end
    local last
    frame:SetScript("OnEvent", function(_, event)
        if not (ns.db and ns.FISHING) then return end
        local skill, maxSkill = ns.Player.Skill(ns.FISHING)
        if skill == 0 then return end
        if event == "LOOT_OPENED" then
            if IsFishingLoot and IsFishingLoot() and skill < maxSkill then
                local log = ns.db.fishLog or { catches = 0, ups = 0, expected = 0 }
                log.catches = log.catches + 1
                -- with the perk the catch had, so the rate stays Forever's against Classic's
                ns.Ladder.overtime = ns.Player.Overtime()
                log.expected = log.expected + Fishing.Chance(skill)
                ns.db.fishLog = log
            end
        elseif last and skill > last and skill - last <= 3 and ns.db.fishLog then
            ns.db.fishLog.ups = ns.db.fishLog.ups + (skill - last)
        end
        last = skill
    end)
end
