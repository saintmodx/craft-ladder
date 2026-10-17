-- Craft Ladder: the Mining ladder (and Skinning's: a creature is a node, its spawns the places; Lockpicking's: a
-- locked chest is a node, a box from the bags a recipe). Mining levels from
-- the nodes you mine (one chance at a point per node) and from smelting their ore. A step is a stretch of skill and a zone to mine it in: the one where you reach the most points
-- for the least walking (Skill), or earn the most an hour on the way (Skill + Gold), counting the bars you smelt from
-- the ore. Gold has no ladder: the zones by what an hour there earns at your skill now.
-- Buying ore (or bars) and smelting it is offered at each step with its price; Craft Ladder picks mining unless you
-- pick that. Ore already in your bags is smelted first, as other ladders use what you have first. Pure Lua (tests run
-- it outside the game).
local _, ns = ...

local Mining = {}
ns.Mining = Mining

local min, max, huge, sqrt = math.min, math.max, math.huge, math.sqrt
local ZONE_OPTIONS, DANGER_OPTIONS, SMELT_OPTIONS = 4, 2, 2 -- shown per step
-- Gold an hour, about: mining and looting a node takes MINE_SECONDS; a third of a zone's node places have a node up at
-- a time; you ride between them at MOUNT_SPEED (metres a second, a 60% mount), the route about 0.7 x the square root
-- of the space per node (the usual estimate for a round of random points).
local MINE_SECONDS, UP_SHARE, MOUNT_SPEED, ROUTE = 15, 1 / 3, 9, 0.7

-- Points one node gives at `skill` on average: its own chance (Classic's colours, the same rule as recipes), plus
-- the bars its ore makes times their chance. smelt = { [ore] = recipe } (recipes with one reagent).
function Mining.NodePoints(node, skill, smelt)
    if skill < node.skill then return 0 end
    local p = ns.Ladder.Chance(node.colors, skill)
    for ore, per in pairs(node.ore) do
        local rec = smelt[ore]
        if rec and skill >= rec.learn then p = p + per / rec.mats[ore] * ns.Ladder.Chance(rec.colors, skill) end
    end
    return p
end

-- Seconds one node takes in a zone of `size` km² with `places` node places you can mine, about (see MINE_SECONDS).
-- A creature (data.nodeSeconds: kill, loot, skin) instead of a node: its spawns are all up, the ride the same.
function Mining.SecondsPerNode(size, places, data)
    local handle, up = MINE_SECONDS, UP_SHARE
    if data and data.nodeSeconds then handle, up = data.nodeSeconds, 1 end
    return handle + ROUTE * sqrt(size * 1e6 / (places * up)) / MOUNT_SPEED
end

-- Zones first (where you're safe before where you aren't), then smelting what you have (when it's free it goes
-- first), then buying and smelting. Zones: least walking for the stretch (Skill) or most gold an hour (Skill + Gold);
-- smelting: cheapest per point.
local function rankBy(mode)
    return function(a, b)
        if a.tier ~= b.tier then return a.tier < b.tier end
        if a.zone and b.zone then
            if mode == "sell" and a.perHour ~= b.perHour then return a.perHour > b.perHour end
            if a.time ~= b.time then return a.time < b.time end
        end
        local pa, pb = a.perPoint or huge, b.perPoint or huge
        if pa ~= pb then return pa < pb end
        if a.recipe ~= b.recipe then return a.recipe < b.recipe end
        return (a.fromBags and 1 or 0) > (b.fromBags and 1 or 0)
    end
end

-- Builds the Mining ladder. Same arguments and result as Ladder.Build, with opts.mode = "skill", "sell" (Skill + Gold)
-- or "gold" (no ladder: the steps are the zones by gold an hour at your skill, see zoneEarn). A mining
-- step: { kind = "mine", from, to, zone (ui map), crafts = nodes to mine, bars = { [recipe] = bars smelted on the
-- way }, learns = { [recipe] = fee }, cost (the fees), node = the kind that gives the most points there, time
-- (walking, only to compare zones), worth = { [node kind] = what one is worth }, sell = { [ore] = { ore, bars,
-- recipe } } (what an ore is worth sold as it is and as bars), earn (what you mine is worth, fees paid), perHour,
-- mix = { { item, share } } (what gives the points at its start, by item, the most first; Gold: what earns, by item),
-- dangerous, options, chosenByYou }. Skill mines the nodes that still give a point; Skill + Gold every node it can.
-- Smelting steps are craft steps, as in Ladder.Build. The result also has nodes, earn, perHour and values (items
-- priced: { [item] = { value, how } }).
function Mining.Build(data, state, quote, opts)
    opts = opts or {}
    local Ladder = ns.Ladder
    local ctx = Ladder.NewContext(data, state, quote, opts)
    local gold = opts.mode == "sell" -- Skill + Gold: what you mine is worth counts
    local skill, cap = state.skill, state.maxSkill or 0
    local target = state.target or cap
    local values = {}
    local result = { from = skill, to = target, steps = {}, cost = 0, crafts = 0, nodes = 0, earn = 0, missing = {},
                     values = values }
    local steps = result.steps

    local smelt, smeltSpell = {}, {}
    for spell, rec in pairs(data.recipes) do
        local ore = next(rec.mats)
        if next(rec.mats, ore) == nil then smelt[ore], smeltSpell[ore] = rec, spell end
    end
    -- alloys: recipes that make a bar from other bars (Bronze from Copper and Tin Bars), by the ore they take:
    -- { [recipe] = { rec, ores = { [ore] = ore one craft takes } } }
    local barOre = {}
    for ore, rec in pairs(smelt) do
        if rec.makes then barOre[rec.makes] = ore end -- a lockbox you pick makes nothing
    end
    local alloys = {}
    for spell, rec in pairs(data.recipes) do
        if next(rec.mats, next(rec.mats)) ~= nil then
            local ores = {}
            for bar, n in pairs(rec.mats) do
                local ore = barOre[bar]
                if not ore then ores = nil; break end
                ores[ore] = n * smelt[ore].mats[ore] / smelt[ore].count
            end
            if ores then alloys[spell] = { rec = rec, ores = ores } end
        end
    end
    -- An alloy you can make at skill k from a zone's ore (`present` = { [ore] = true }): its recipe and its bars'
    -- are open to you, and the zone has every ore it takes.
    local function alloyReady(a, k, present)
        if k < a.rec.learn then return false end
        for ore in pairs(a.ores) do
            if k < smelt[ore].learn or not present[ore] then return false end
        end
        return true
    end
    -- where a kind of node or a smelting recipe opens: a step ends there, as another zone may be better from there
    -- (creatures to skin open every few points, and herbs (data.mergeSteps) come in many kinds: they don't break steps)
    local opens, creatures = {}, false
    for _, node in pairs(data.nodes) do
        if node.level then creatures = true elseif not data.mergeSteps then opens[node.skill] = true end
    end
    -- a creature well above the character's level is only skinned in a dangerous option
    -- the level the ladder plans for: yours, and past a "Reach level N" gate (Lockpicking) at least N
    local level = state.level or 1
    local function tooHigh(node) return node.level and node.level > level + 2 end
    for _, rec in pairs(data.recipes) do opens[rec.learn] = true end

    local function worth(item) return ns.Prices.Worth(data, quote, values, item) end

    -- An ore sold as it is and as bars (once you can smelt it): { ore, bars, recipe }.
    local function oreDeal(ore, k)
        local deal = { ore = worth(ore) }
        local rec = smelt[ore]
        if rec and k >= rec.learn then
            deal.bars, deal.recipe = rec.count / rec.mats[ore] * worth(rec.makes), smeltSpell[ore]
        end
        return deal
    end

    -- The most one ore sells for by itself: as ore or as bars.
    local function bestAlone(ore, k)
        local d = oreDeal(ore, k)
        return max(d.ore, d.bars or 0)
    end

    -- What one craft of an alloy earns over selling its ore the best way alone (0 when that's better).
    local function alloyGain(a, k)
        local alone = 0
        for ore, n in pairs(a.ores) do alone = alone + n * bestAlone(ore, k) end
        return max(0, a.rec.count * worth(a.rec.makes) - alone)
    end

    -- What one node is worth at skill k: what it gives, its ore sold the better way.
    -- shortcut: the points from smelting count even where ore sells for more than bars; fine while bars sell better
    local function nodeWorth(node, k)
        local v = 0
        for item, n in pairs(node.loot) do
            if node.ore[item] then
                v = v + n * bestAlone(item, k)
            else
                v = v + n * worth(item)
            end
        end
        return v
    end

    local function ours(zone) return zone.faction == "C" or zone.faction == ctx.faction end

    -- The ore of the nodes you can mine in a zone at skill k: { [ore] = true }.
    local function zoneOres(zone, k)
        local present = {}
        for id in pairs(zone.nodes) do
            local node = data.nodes[id]
            if k >= node.skill then
                for ore in pairs(node.ore) do present[ore] = true end
            end
        end
        return present
    end

    -- { [item] = weight } as a list { { item, share, name } }, the biggest share first (name: a lock's, whose item is
    -- only its icon).
    local function mixOf(weights, names)
        local list, total = {}, 0
        for item, w in pairs(weights) do
            if w > 0 then
                list[#list + 1], total = { item = item, share = w, name = names and names[item] }, total + w
            end
        end
        table.sort(list, function(a, b)
            if a.share ~= b.share then return a.share > b.share end
            return a.item < b.item
        end)
        for _, x in ipairs(list) do x.share = x.share / total end
        return list
    end

    -- What gives the points in a zone at skill k, by the item a kind gives most (its ore, its herb, its leather).
    local function pointsMix(zone, k, risky)
        local w, names = {}, {}
        for id, n in pairs(zone.nodes) do
            local node = data.nodes[id]
            local p = (risky or not tooHigh(node)) and Mining.NodePoints(node, k, smelt) or 0
            if p > 0 then w[node.item] = (w[node.item] or 0) + n * p end
            if node.lock then names[node.item] = node.name end
        end
        return mixOf(w, names)
    end

    -- What a zone's nodes are worth at skill k: { [node kind] = what one is worth }, and its ores sold the ways you
    -- can: { [ore] = oreDeal, with alloy (what one ore is worth made into one, with the others it takes) }.
    local function zoneSale(zone, k)
        local kinds, sell = {}, {}
        for id in pairs(zone.nodes) do
            local node = data.nodes[id]
            if k >= node.skill then
                kinds[id] = nodeWorth(node, k)
                for ore in pairs(node.ore) do
                    if smelt[ore] then sell[ore] = oreDeal(ore, k) end
                end
            end
        end
        local present = zoneOres(zone, k)
        for spell, a in pairs(alloys) do
            if alloyReady(a, k, present) then
                local ores = 0
                for _, n in pairs(a.ores) do ores = ores + n end
                for o in pairs(a.ores) do
                    sell[o].alloy, sell[o].alloyRecipe = a.rec.count * worth(a.rec.makes) / ores, spell
                end
            end
        end
        return kinds, sell
    end

    -- Gold: an hour in a zone at skill k, gathering every node you can there (grey ones too, their ore sold the better
    -- way, alloys made where the zone has their ores). An option of kind "mine" with hour = true: crafts = nodes an
    -- hour, value (a node), perHour, worth and sell (as a step's); nil when nothing you can gather there is priced.
    -- risky: creatures well above your level count too (the option is then dangerous).
    local function zoneEarn(map, zone, k, risky)
        if not ours(zone) then return nil end
        local places, value, ore, best, bestValue, lowest, byItem = 0, 0, {}, nil, 0, nil, {}
        for id, n in pairs(zone.nodes) do
            local node = data.nodes[id]
            if k >= node.skill and (risky or not tooHigh(node)) then
                local v = n * nodeWorth(node, k)
                places, value = places + n, value + v
                for item, q in pairs(node.loot) do -- as nodeWorth: ore sold the better way
                    byItem[item] = (byItem[item] or 0) + n * q * (node.ore[item] and bestAlone(item, k) or worth(item))
                end
                for o, per in pairs(node.ore) do ore[o] = (ore[o] or 0) + n * per end
                if not best or v > bestValue then best, bestValue = id, v end
                if node.level then lowest = min(lowest or huge, node.level) end
            end
        end
        if value <= 0 then return nil end
        local present = zoneOres(zone, k)
        for _, a in pairs(alloys) do
            if alloyReady(a, k, present) then
                local c = huge -- crafts the scarcest of its ores allows
                for o, n in pairs(a.ores) do c = min(c, (ore[o] or 0) / n) end
                value = value + c * alloyGain(a, k)
            end
        end
        local perNode = Mining.SecondsPerNode(zone.size, places, data)
        local o = { kind = "mine", hour = true, recipe = map, zone = map, name = zone.name, from = k, to = k,
                    crafts = 3600 / perNode, seconds = 3600, value = value / places, node = best, cost = 0,
                    bars = {}, learns = {}, buy = {}, options = {}, mobLevel = lowest }
        o.perHour = o.value * o.crafts
        o.earn = o.perHour
        o.worth, o.sell = zoneSale(zone, k)
        o.mix = mixOf(byItem)
        if risky or not creatures and level < zone.levels[1] - 3 then o.dangerous = true end
        return o
    end

    -- One zone as an option for the stretch from `from` to `to`. Skill: mining every node that still gives a point,
    -- or whose ore makes an alloy that does (grey copper for Bronze); Gold: every node you can mine (a grey one gives
    -- no point, but its ore still sells). The ore is smelted on the way, and made into alloys where it can be.
    -- risky: creatures well above your level count too (the option is then dangerous).
    local function zoneOption(map, zone, from, to, risky)
        if not ours(zone) then return nil end
        local function counts(node) return risky or not tooHigh(node) end
        local kindWorth, gain = {}, {}
        if gold then
            for id in pairs(zone.nodes) do
                local node = data.nodes[id]
                if from >= node.skill and counts(node) then kindWorth[id] = nodeWorth(node, from) end
            end
            local present = zoneOres(zone, from)
            for spell, a in pairs(alloys) do
                if alloyReady(a, from, present) then gain[spell] = alloyGain(a, from) end
            end
        end
        local nodes, time, seconds, earn, bars, best, bestPoints, lowest = 0, 0, 0, 0, {}, nil, 0, nil
        local present
        for k = from, to - 1 do
            if k == from or opens[k] then present = zoneOres(zone, k) end -- it changes where a kind of node opens
            local ready, feeding = {}, {}
            for spell, a in pairs(alloys) do
                if alloyReady(a, k, present) then
                    ready[spell] = Ladder.Chance(a.rec.colors, k)
                    if ready[spell] > 0 then
                        for ore in pairs(a.ores) do feeding[ore] = true end
                    end
                end
            end
            local places, points, mineable, value, mined, ore = 0, 0, 0, 0, 0, {}
            for id, n in pairs(zone.nodes) do
                local node = data.nodes[id]
                local p = counts(node) and Mining.NodePoints(node, k, smelt) or 0
                local useful = p > 0
                if useful and node.level then lowest = min(lowest or huge, node.level) end
                if k >= node.skill and counts(node) then
                    for o in pairs(node.ore) do useful = useful or feeding[o] == true end
                end
                if useful then places, points = places + n, points + n * p end
                if kindWorth[id] then mineable, value = mineable + n, value + n * kindWorth[id] end
                if (gold and kindWorth[id]) or (not gold and useful) then
                    mined = mined + n
                    for o, per in pairs(node.ore) do ore[o] = (ore[o] or 0) + n * per end
                end
                if k == from and n * p > bestPoints then best, bestPoints = id, n * p end
            end
            -- alloys: as many crafts as the scarcest of their ores allows
            local crafts = {}
            for spell, chance in pairs(ready) do
                local c = huge
                for o, n in pairs(alloys[spell].ores) do c = min(c, (ore[o] or 0) / n) end
                crafts[spell] = c
                points = points + c * chance
                if gain[spell] then value = value + c * gain[spell] end
            end
            if points <= 0 then return nil end
            local perPoint = mined / points -- nodes for this point
            nodes = nodes + perPoint
            time = time + perPoint * sqrt(zone.size / places) -- the walk to a node grows with the space between them
            if gold then
                seconds = seconds + perPoint * Mining.SecondsPerNode(zone.size, mineable, data)
                earn = earn + perPoint * value / mineable
            end
            -- the bars smelted on the way (by recipes that give points): per node mined, times nodes for this point
            for o, amount in pairs(ore) do
                local rec = smelt[o]
                if rec and k >= rec.learn and Ladder.Chance(rec.colors, k) > 0 then
                    local spell = smeltSpell[o]
                    bars[spell] = (bars[spell] or 0) + perPoint * amount / mined / rec.mats[o] * rec.count
                end
            end
            for spell, c in pairs(crafts) do
                if ready[spell] > 0 then
                    bars[spell] = (bars[spell] or 0) + perPoint * c / mined * alloys[spell].rec.count
                end
            end
        end
        -- the recipes it uses, and the ones an alloy's bars need
        local uses = {}
        for spell in pairs(bars) do
            uses[spell] = true
            for o in pairs(alloys[spell] and alloys[spell].ores or {}) do uses[smeltSpell[o]] = true end
        end
        local learns, fees = {}, 0
        for spell in pairs(uses) do
            local way = Ladder.LearnWay(ctx, spell, data.recipes[spell])
            if way and way.cost > 0 then learns[spell], fees = way.cost, fees + way.cost end
        end
        local o = { kind = "mine", recipe = map, zone = map, name = zone.name, from = from, to = to, crafts = nodes,
                    time = time, bars = bars, learns = learns, cost = fees, perPoint = fees / (to - from),
                    node = best, tier = 1 }
        if gold then
            -- ranked by what the nodes earn: a recipe's fee is paid once wherever it's first used
            o.seconds, o.earn = seconds, earn - fees
            o.perHour = earn / (seconds / 3600)
            o.value = earn / nodes
        end
        if creatures then
            o.mobLevel = lowest -- the lowest level of the creatures it skins
            if risky then o.tier, o.dangerous = 2, true end
        elseif level < zone.levels[1] - 3 then
            o.tier, o.dangerous = 2, true
        end
        return o
    end

    if opts.mode == "gold" then
        for map, zone in pairs(data.zones) do
            local o = zoneEarn(map, zone, skill) or creatures and zoneEarn(map, zone, skill, true)
            if o then steps[#steps + 1] = o end
        end
        -- where you're safe first, then by gold an hour
        table.sort(steps, function(a, b)
            if (a.dangerous or false) ~= (b.dangerous or false) then return not a.dangerous end
            if a.perHour ~= b.perHour then return a.perHour > b.perHour end
            return a.zone < b.zone
        end)
        result.to = skill
        return result
    end

    local better = rankBy(opts.mode)
    local guard = 0
    while skill < target do
        guard = guard + 1
        if guard > 300 then result.stuck = "loop"; break end

        local rank = Ladder.NextRank(data, cap)
        if rank and skill >= rank.learnAt and cap < target then
            local step = Ladder.RankStep(ctx, rank, skill)
            steps[#steps + 1] = step
            cap = rank.cap
            skill = max(skill, 1) -- learning it gives 1
            if rank.how == "level" then level = max(level, rank.charLevel) end
            rank = Ladder.NextRank(data, cap)
        end
        local limit = min(cap, target)
        if skill >= limit then
            result.stuck = "cap"
            break
        end

        -- a stretch ends where a rank can be learned, or where a node or a smelting recipe changes colour
        local stop = limit
        if rank and cap < target and rank.learnAt > skill then stop = min(stop, rank.learnAt) end
        local function cut(at) if at > skill and at < stop then stop = at end end
        for _, node in pairs(data.nodes) do
            for _, at in ipairs(node.colors) do cut(at) end
        end
        for _, rec in pairs(data.recipes) do
            cut(rec.learn)
            for _, at in ipairs(rec.colors) do cut(at) end
        end

        local options = {}
        for map, zone in pairs(data.zones) do
            -- creatures: the ones of your level, else (marked dangerous) the ones above it too
            local o = zoneOption(map, zone, skill, stop) or creatures and zoneOption(map, zone, skill, stop, true)
            if o then options[#options + 1] = o end
        end
        for spell, rec in pairs(data.recipes) do
            local o, b = Ladder.Option(ctx, spell, rec, skill, limit)
            for _, x in ipairs({ o, b }) do
                x.kind = "smelt"
                -- smelting what you have costs nothing when no ingredient is missing: before mining
                x.tier = (x.fromBags and not x.missing and x.cost == 0) and 0 or 2 + x.tier
                options[#options + 1] = x
            end
        end
        table.sort(options, better)

        local chosen = options[1]
        local wanted = Ladder.ChoiceAt(opts.choices, skill)
        if wanted then
            for _, o in ipairs(options) do
                if o.recipe == wanted.recipe and (o.fromBags or false) == (wanted.bags or false) then chosen = o; break end
            end
        end
        if not chosen then
            result.stuck = "no zone"
            break
        end

        -- shown: the best zones where you're safe, the best where you aren't yet, the best ways to smelt, and the pick
        local shown, safe, danger, smelts = {}, 0, 0, 0
        for _, o in ipairs(options) do
            if o.zone and not o.dangerous and safe < ZONE_OPTIONS then
                safe = safe + 1
                shown[#shown + 1] = o
            elseif o.dangerous and danger < DANGER_OPTIONS then
                danger = danger + 1
                shown[#shown + 1] = o
            elseif not o.zone and smelts < SMELT_OPTIONS then
                smelts = smelts + 1
                shown[#shown + 1] = o
            end
        end
        local listed = false
        for _, o in ipairs(shown) do listed = listed or o == chosen end
        if not listed then shown[#shown + 1] = chosen end

        local step
        if chosen.zone then
            -- own copies: merging steps adds to them, and the option keeps saying what its stretch alone takes
            local bars, learns = {}, {}
            for k, v in pairs(chosen.bars) do bars[k] = v end
            for k, v in pairs(chosen.learns) do learns[k] = v end
            local kinds, sell = zoneSale(data.zones[chosen.zone], skill)
            step = { kind = "mine", from = skill, to = stop, zone = chosen.zone, recipe = chosen.zone,
                     crafts = chosen.crafts, time = chosen.time, bars = bars, learns = learns,
                     cost = chosen.cost, node = chosen.node, dangerous = chosen.dangerous, options = shown, buy = {},
                     worth = kinds, sell = sell, seconds = chosen.seconds, earn = chosen.earn,
                     mix = pointsMix(data.zones[chosen.zone], skill, chosen.dangerous) }
            if chosen ~= options[1] then step.chosenByYou = true end
            for spell in pairs(chosen.learns) do ctx.learned[spell] = true end
        else
            step = Ladder.CraftStep(ctx, data, chosen, skill, min(chosen.to, stop), shown, options[1])
            for item, b in pairs(step.buy) do
                if b.buy > 0 and not b.cost then result.missing[item] = true end
            end
        end
        steps[#steps + 1] = step
        skill = step.to
    end

    -- one zone (or one recipe) over stretches in a row is one step, until a kind of node or a recipe opens
    local merged = {}
    for _, s in ipairs(steps) do
        local last = merged[#merged]
        if last and last.kind == "mine" and s.kind == "mine" and last.zone == s.zone and last.to == s.from
            and not opens[s.from] and (last.chosenByYou or false) == (s.chosenByYou or false) then
            last.to = s.to
            last.crafts, last.time, last.cost = last.crafts + s.crafts, last.time + s.time, last.cost + s.cost
            if gold then last.seconds, last.earn = last.seconds + s.seconds, last.earn + s.earn end
            for spell, n in pairs(s.bars) do last.bars[spell] = (last.bars[spell] or 0) + n end
            for spell, fee in pairs(s.learns) do last.learns[spell] = fee end
        elseif last and last.kind == "craft" and s.kind == "craft" and last.recipe == s.recipe and last.to == s.from
            and (last.fromBags or false) == (s.fromBags or false) then
            Ladder.MergeCraft(last, s)
        else
            merged[#merged + 1] = s
        end
    end
    result.steps = merged
    -- a step that joins stretches: its zones counted again over all of it, as the step is (fees as they were)
    for _, s in ipairs(merged) do
        if s.kind == "mine" then
            for _, o in ipairs(s.options) do
                local whole = o.zone and o.to < s.to and zoneOption(o.zone, data.zones[o.zone], s.from, s.to, o.dangerous)
                if whole then
                    o.to, o.crafts, o.time, o.bars = s.to, whole.crafts, whole.time, whole.bars
                    if gold then
                        o.seconds, o.perHour, o.value = whole.seconds, whole.perHour, whole.value
                        o.earn = whole.earn + whole.cost - o.cost
                    end
                end
            end
        end
    end
    local seconds = 0
    for _, s in ipairs(merged) do
        result.cost = result.cost + (s.cost or 0)
        if s.kind == "mine" then
            result.nodes = result.nodes + s.crafts
            if gold then
                s.perHour = (s.earn + s.cost) / (s.seconds / 3600) -- as its options: what the nodes earn, fees aside
                result.earn, seconds = result.earn + s.earn, seconds + s.seconds
            end
        end
        if s.kind == "craft" then result.crafts = result.crafts + s.crafts end
    end
    if gold and seconds > 0 then result.perHour = result.earn / (seconds / 3600) end
    return result
end

-- Lockpicking (data.levelCaps): its cap is the character's level x 5, so its ranks are levels. Pick Lock first when
-- it isn't learned (data.ranks[1]: at 16 at least, the cap of your level), then every 5 levels up to 60, each raising
-- the cap by 25 ("Reach level N", learned when the skill reaches the cap before it).
function Mining.LevelRanks(data, state)
    data.learnRank = data.learnRank or data.ranks[1]
    local ranks, cap = {}, state.maxSkill or 0
    if cap == 0 then
        local r = {}
        for k, v in pairs(data.learnRank) do r[k] = v end
        r.cap = max(state.level or 1, r.charLevel) * 5
        ranks[1], cap = r, r.cap
    end
    for level = (math.floor(cap / 25) + 1) * 5, 60, 5 do
        ranks[#ranks + 1] = { name = "Level " .. level, how = "level", cap = level * 5, learnAt = cap,
                              charLevel = level }
        cap = level * 5
    end
    return ranks
end

---------------------------------------------------------------------------------------------------------------
-- In game (Skinning): a creature you skin that Classic's data doesn't have (most are new in Forever) is recorded
-- (CraftLadderDB.skinLog: { [creature] = { skins, items = { [item] = count } } }) and joins the ladder, its places and
-- levels from the data's candidates.
---------------------------------------------------------------------------------------------------------------

-- The skill a creature needs, from its level: Classic's rule, as tools/build_skinning.py has it.
function Mining.SkinSkill(level)
    if level <= 10 then return 1 end
    if level <= 20 then return (level - 10) * 10 end
    return level * 5
end

-- Makes the recorded creatures nodes of Skinning's data (once each).
function Mining.ApplySkinLog(data)
    local log = ns.db and ns.db.skinLog
    if not (log and data and data.candidates) then return end
    for npc, e in pairs(log) do
        local c = data.candidates[npc]
        if c and not data.nodes[npc] and (e.skins or 0) > 0 then
            local level = math.floor((c.levels[1] + c.levels[2]) / 2)
            local skill = Mining.SkinSkill(level)
            local base = skill == 1 and 0 or skill
            local loot, item, most = {}, nil, 0
            for it, n in pairs(e.items or {}) do
                loot[it] = n / e.skins
                if n > most then item, most = it, n end
            end
            if item then
                data.nodes[npc] = { name = c.name, level = level, levels = c.levels, skill = skill,
                                    colors = { skill, base + 25, base + 50, base + 100 }, loot = loot, ore = {},
                                    item = item, recorded = true }
                for map, n in pairs(c.zones) do
                    if data.zones[map] then data.zones[map].nodes[npc] = n end
                end
            end
        end
    end
end

if CreateFrame then
    local frame = CreateFrame("Frame")
    for _, event in ipairs({ "UNIT_SPELLCAST_SUCCEEDED", "LOOT_OPENED" }) do pcall(frame.RegisterEvent, frame, event) end
    local skinning -- when the player last finished casting Skinning
    frame:SetScript("OnEvent", function(_, event, unit, _, spell)
        local data = ns.SKINNING
        if not (ns.db and data) then return end
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            local name = C_Spell and C_Spell.GetSpellName
            if unit == "player" and name and spell and name(spell) == name(data.apprentice) then skinning = GetTime() end
            return
        end
        if not (skinning and GetTime() - skinning < 5 and GetNumLootItems) then return end
        skinning = nil
        local log, seen = ns.db.skinLog or {}, {}
        for slot = 1, GetNumLootItems() do
            local guid = GetLootSourceInfo and GetLootSourceInfo(slot)
            local npc = guid and tonumber(guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-"))
            local link = GetLootSlotLink and GetLootSlotLink(slot)
            local item = link and tonumber(link:match("item:(%d+)"))
            if npc and item and not data.nodes[npc] then
                local e = log[npc] or { skins = 0, items = {} }
                if not seen[guid] then
                    seen[guid] = true
                    e.skins = e.skins + 1
                end
                e.items[item] = (e.items[item] or 0) + (select(3, GetLootSlotInfo(slot)) or 1)
                log[npc] = e
            end
        end
        ns.db.skinLog = log
        Mining.ApplySkinLog(data)
    end)
end

---------------------------------------------------------------------------------------------------------------
-- In game (Mining, Herbalism): every node you gather is recorded with where you stood (CraftLadderDB.gatherLog:
-- "profession entry map x y time" lines), so the builders can measure how often each kind takes a spawn spot it
-- shares with others (tools/seen_in_game.py). A vein mined twice counts once.
---------------------------------------------------------------------------------------------------------------

if CreateFrame then
    local frame = CreateFrame("Frame")
    for _, event in ipairs({ "UNIT_SPELLCAST_SUCCEEDED", "LOOT_OPENED" }) do pcall(frame.RegisterEvent, frame, event) end
    local gathering, at -- the profession whose gathering the player last finished casting, and when
    local done = {} -- the nodes recorded this session, by GUID
    frame:SetScript("OnEvent", function(_, event, unit, _, spell)
        if not ns.db then return end
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            local name = C_Spell and C_Spell.GetSpellName
            if unit ~= "player" or not (name and spell) then return end
            for _, data in ipairs({ ns.MINING, ns.HERBALISM }) do
                if data and name(spell) == name(data.apprentice) then gathering, at = data.key, GetTime() end
            end
            return
        end
        if not (gathering and GetTime() - at < 5 and GetLootSourceInfo and C_Map and C_Map.GetBestMapForUnit) then return end
        local key = gathering
        gathering = nil
        local guid = GetLootSourceInfo(1)
        local entry = guid and tonumber(guid:match("^GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)%-"))
        local map = C_Map.GetBestMapForUnit("player")
        local pos = map and C_Map.GetPlayerMapPosition(map, "player")
        if not (entry and pos) or done[guid] then return end
        done[guid] = true
        local x, y = pos:GetXY()
        local log = ns.db.gatherLog or {}
        log[#log + 1] = ("%s %d %d %.4f %.4f %d"):format(key, entry, map, x, y, time())
        ns.db.gatherLog = log
    end)
end
