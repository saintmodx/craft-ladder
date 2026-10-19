-- Craft Ladder: the ladder calculator. Pure Lua with no game calls, so tests run it outside the game.
--
-- From the current skill it builds steps: at each skill it rates every recipe the character can get, picks the
-- cheapest orange/yellow one (greens are shown as alternatives, never picked by default) and uses it until it turns
-- green. A step also ends where a new recipe unlocks, so a cheaper one can take over, and rank-ups are added where
-- they can be learned.
local _, ns = ...

local Ladder = {}
ns.Ladder = Ladder

local min, max, huge = math.min, math.max, math.huge

-- Skill where a recipe turns yellow, green and grey. A colour the data has as 0 is skipped, so the next one counts.
local function thresholds(colors)
    local yellow, green, grey = colors[2], colors[3], colors[4]
    local firstGreen = green > 0 and green or grey
    local firstYellow = yellow > 0 and yellow or firstGreen
    return firstYellow, firstGreen, grey
end

function Ladder.Color(colors, skill)
    local yellow, green, grey = thresholds(colors)
    if skill >= grey then return "grey" end
    if skill >= green then return "green" end
    if skill >= yellow then return "yellow" end
    return "orange"
end

-- Chance that one craft gives a skill point: sure while orange, then falling in a straight line to 0 at grey
-- (the usual Classic rule; real crafting is luck, so craft counts are estimates).
function Ladder.Chance(colors, skill)
    local yellow, _, grey = thresholds(colors)
    if skill >= grey then return 0 end
    if skill < yellow then return 1 end
    return (grey - skill) / (grey - yellow)
end

-- Expected crafts to go from skill a to skill b with one recipe.
function Ladder.Crafts(colors, a, b)
    local n = 0
    for s = a, b - 1 do
        local c = Ladder.Chance(colors, s)
        if c <= 0 then return huge end
        n = n + 1 / c
    end
    return n
end

local function hasFaction(f, faction) return f and f:find(faction, 1, true) ~= nil end

-- The cheapest way this character can get a recipe: { kind, cost = copper, guess, ... }, or nil when it can't.
-- Quests count as free (they cost a trip, not gold); Merchant's Favor recipes only when the setting allows them.
-- A price a vendor really asked (opts.realPrices) beats the one in the data; guess = the price is an estimate.
-- skill: the skill it's learned at; a trainer that teaches it later than its plan does (g.skill) waits till then.
local function learnWay(ctx, spell, rec, skill)
    if ctx.known[spell] then return { kind = "known", cost = 0 } end
    -- learned in an earlier step of this ladder (at that skill; true: Mining's smelting), not by the character yet
    if ctx.learned[spell] then return { kind = "known", cost = 0, earlier = ctx.learned[spell] } end
    if rec.event then return nil end -- a holiday's recipe (Winter Veil): not there the rest of the year
    if rec.spec and not ctx.specs[rec.spec] then return nil end -- Armorsmith, Weaponsmith...
    if rec.rep and (ctx.standing(rec.rep.faction) or -1) < rec.rep.standing then return nil end
    if rec.item and (ctx.owned[rec.item] or 0) > 0 then return { kind = "owned", cost = 0, item = rec.item } end
    local best
    local function consider(way)
        if not best or way.cost < best.cost then best = way end
    end
    for _, g in ipairs(rec.get) do
        if g.event then -- a holiday's vendor or quest (the Lunar Festival's rockets): not there the rest of the year
        elseif g.kind == "start" then
            consider({ kind = "start", cost = 0 })
        elseif g.kind == "trainer" and (g.level or 0) <= ctx.planLevel -- level: Poisons' recipes need one
            and not (skill and g.skill and skill < g.skill) then
            consider({ kind = "trainer", cost = g.cost or 0, guess = g.costGuess, level = g.level })
        elseif g.kind == "vendor" and hasFaction(g.faction, ctx.faction) and not g.otherCost then
            if not g.favor then
                local real = rec.item and ctx.real[rec.item]
                consider({ kind = "vendor", cost = real or g.cost or 0, guess = not real and g.costGuess or nil,
                           npc = g.npc })
            elseif ctx.opts.favor then
                consider({ kind = "vendor", cost = g.cost or 0, favor = g.favor, npc = g.npc })
            end
        elseif g.kind == "quest" and hasFaction(g.faction, ctx.faction) then
            consider({ kind = "quest", cost = 0, quest = g.quest, reqLevel = g.reqLevel, classic = g.classic })
        end
    end
    if rec.item then
        local p = ctx.quote(rec.item, 1, 0, true)
        if p then consider({ kind = "ah", cost = p, item = rec.item }) end
    end
    return best
end

-- what's made from what's made, at most: an EZ-Thro Fireproof Fuse from a Silver Contact from Silver Bars from ore
local MAKE_DEPTH = 3

-- Whether the character has (or can buy) the tools a recipe needs: one only a recipe makes (an Arclight Spanner)
-- counts once the ladder has made it.
local function hasTools(ctx, rec)
    for _, kind in ipairs(rec.tools or {}) do
        local tk = ctx.toolKinds[kind]
        if tk and not tk.buy and not ctx.hasTool[kind] then return false end
    end
    return true
end

-- Who can make an item for this character now, or nil: a recipe of the profession that it knows (or the ladder has
-- learned, or every one knows from the start: Bolt of Linen Cloth) and can make at its skill now with its tools
-- (Coarse Grinding Stone), or a smelting recipe its Mining allows (bars).
local function maker(ctx, item)
    local m = ctx.makers[item]
    if not m then return nil end
    if m.mining then return ctx.mining >= m.rec.learn and m or nil end
    return (ctx.known[m.spell] or ctx.learned[m.spell] or m.start) and ctx.skill >= m.rec.learn and hasTools(ctx, m.rec)
        and m or nil
end

-- Gold for the ingredients of `crafts` crafts: what the character owns is used first, the rest is bought on top of
-- what earlier steps already bought (each more item costs a little more at the auction house), or made when making
-- it (its own ingredients bought or made the same way) costs less.
-- Returns cost, buy list { [item] = { need, have, buy, cost, short, make } } and the first ingredient with no price.
-- short = more than the auction house had listed; make = { spell, crafts, made, parts = a buy list of what it's made
-- of, mining = smelted } when it's made, not bought: `made` of `buy` are made, the rest bought (a step that joins
-- stretches may make it in one and buy it in another).
local function ingredients(ctx, rec, crafts, depth)
    depth = depth or 0
    local cost, buy, missing = 0, {}, nil
    for item, n in pairs(rec.mats) do
        local need = crafts * n
        local have = min(ctx.owned[item] or 0, need)
        local b = { need = need, have = have, buy = need - have }
        if b.buy > 0 then
            local already = ctx.bought[item] or 0
            local c, e = ctx.quote(item, b.buy, already)
            local m = depth < MAKE_DEPTH and maker(ctx, item)
            if m then
                local runs = b.buy / (m.rec.yield or m.rec.count or 1)
                local mc, parts, partMissing = ingredients(ctx, m.rec, runs, depth + 1)
                if not partMissing and (not c or mc < c) then
                    c, e = mc, nil
                    b.make = { spell = m.spell, crafts = runs, made = b.buy, parts = parts, mining = m.mining }
                end
            end
            if c then
                cost, b.cost = cost + c, c
                b.short = e and e.qty and already + b.buy > e.qty or nil
            else
                missing = missing or item
            end
        end
        buy[item] = b
    end
    return cost, buy, missing
end

-- A step uses `n` of an item the character owns: what it had at the start goes first, then what earlier steps made
-- (the oldest first), and each of those is logged for the "keep them for later" notes.
local function useOwned(ctx, item, n, step)
    local start = min(n, ctx.initial[item] or 0)
    ctx.initial[item] = (ctx.initial[item] or 0) - start
    n = n - start
    for _, batch in ipairs(ctx.batches[item] or {}) do
        if n <= 0 then break end
        local k = min(n, batch.left)
        if k > 0 then
            batch.left, n = batch.left - k, n - k
            ctx.uses[#ctx.uses + 1] = { made = batch.step, by = step, item = item, n = k }
        end
    end
end

-- After a step is chosen: what it used is gone, what it bought counts for the next purchase (what it made, the
-- ingredients it was made of). `step` (the step that uses them) is for the notes on what to keep; Fishing and Mining
-- leave it out.
local function spend(ctx, buy, step)
    for item, b in pairs(buy) do
        ctx.owned[item] = (ctx.owned[item] or 0) - b.have
        if step and b.have > 0 then useOwned(ctx, item, b.have, step) end
        if b.make then
            spend(ctx, b.make.parts, step)
        else
            ctx.bought[item] = (ctx.bought[item] or 0) + b.buy
        end
    end
end

local AH_CUT, AH_OVER_VENDOR = 0.95, 1.5

-- What selling `made` of an item brings back: at the auction house (after its cut) when that pays at least 1.5 times
-- what a vendor does and at least 5 are listed, for at most a quarter of what's listed (less what earlier steps put
-- there: `sold`); the rest at a vendor. ctx.vendorOnly (the Sure cost ladder): only vendors, whose money is sure.
-- Returns { ah, ahEach, vendor, vendorEach, total }.
local function resale(ctx, item, made, sold)
    local vendorEach, ahEach, ah = ctx.sell[item] or 0, 0, 0
    local _, e = ctx.quote(item, 1, 0, true)
    local each = e and (e.min or e.unit)
    if not ctx.vendorOnly and each and e.qty and e.qty >= 5 and each * AH_CUT >= AH_OVER_VENDOR * vendorEach then
        ahEach = each * AH_CUT
        ah = min(made, max(0, max(1, math.floor(e.qty / 4)) - (sold[item] or 0)))
    end
    return { ah = ah, ahEach = ahEach, vendor = made - ah, vendorEach = vendorEach,
             total = ah * ahEach + (made - ah) * vendorEach }
end

-- A sale joins what a step already sells.
local function addSale(step, sale)
    local ls = step.sale
    if ls then
        ls.ah, ls.vendor, ls.total = ls.ah + sale.ah, ls.vendor + sale.vendor, ls.total + sale.total
    else
        step.sale = sale
    end
    step.back = (step.back or 0) + sale.total
end

-- What the crafts of a recipe bring back when sold (0 where the profession's things aren't sold, or the ladder keeps
-- them for later recipes: a grinding stone).
local function backFor(ctx, rec, crafts)
    if not ctx.resale or not rec.makes or ctx.makers[rec.makes] then return 0 end -- an enchantment makes nothing
    return resale(ctx, rec.makes, crafts * (rec.yield or 1), ctx.sold).total
end

-- One recipe as an option at skill `skill`: it runs until it changes colour tier (orange/yellow until green,
-- green until grey) or hits `limit`. Its cost per point spreads the learning cost over that whole stretch.
-- perPoint is what the player sees; score is what options are sorted by: the same, except that a recipe the ladder
-- buys later anyway (ctx.sunk) doesn't count its price here, since it's paid either way.
local function priced(ctx, o, way)
    if not o.missing then
        o.cost = o.matCost + way.cost
        o.perPoint = (o.cost - o.back) / (o.to - o.from)
        o.score = (o.matCost - o.back + (ctx.sunk[o.recipe] and 0 or way.cost)) / (o.to - o.from)
    else
        o.tier = 3 -- no price for an ingredient: shown, but after every priced option
    end
    return o
end

-- How many crafts what the character owns covers. main: counting only the ingredients no vendor of their faction
-- sells (meat, fish, eggs: what you'd hunt or buy at the auction house); all: counting every ingredient.
local function haveCrafts(ctx, rec)
    local main, all, hasMain = huge, huge, false
    for item, n in pairs(rec.mats) do
        local c = math.floor((ctx.owned[item] or 0) / n)
        all = min(all, c)
        local v = ctx.vendor[item]
        if not (v and v[ctx.faction]) then
            hasMain = true
            main = min(main, c)
        end
    end
    return hasMain and main or 0, all == huge and 0 or all
end

-- How much of a buy list's entry what the character owns covers, 0 to 1: what it has, and what's made of its own (bars
-- smelted from its ore). nil: a good its vendors sell, taken as had.
local function ownShare(ctx, item, b)
    local v = ctx.vendor[item]
    if v and v[ctx.faction] then return nil end
    local made = 0
    if b.make then
        local share = 1
        for part, pb in pairs(b.make.parts) do share = min(share, ownShare(ctx, part, pb) or 1) end
        made = b.make.made * share
    end
    return b.need > 0 and min(1, (b.have + made) / b.need) or 1
end

-- How many of a step's crafts what the character owns covers as the plan uses it (what an earlier step takes is
-- gone), the ingredients its vendors sell taken as had. nil: the recipe needs nothing else.
local function readyCrafts(ctx, rec, step)
    local share
    for item in pairs(rec.mats) do
        local s = step.buy[item] and ownShare(ctx, item, step.buy[item])
        if s then share = min(share or 1, s) end
    end
    return share and share * step.crafts
end

-- The highest skill `crafts` crafts reach from `skill` on average, no further than `limit`.
local function reach(colors, skill, crafts, limit)
    local used, s = 0, skill
    while s < limit do
        local c = Ladder.Chance(colors, s)
        if c <= 0 or used + 1 / c > crafts + 1e-9 then break end
        used = used + 1 / c
        s = s + 1
    end
    return s
end

-- Returns the recipe's option, and a second one when the character owns its main ingredients: using what they
-- have first is nearly free, so it mustn't be averaged in with what the rest of the stretch would cost.
local function option(ctx, spell, rec, skill, limit)
    -- a tool's recipe (Arclight Spanner) is made once, in a step of its own, never for skill-ups or to sell; one with a
    -- cooldown (Mooncloth: once in 4 days) isn't for leveling
    if rec.learn > skill or rec.cooldown or ctx.toolRecipes[spell] or not hasTools(ctx, rec) then return nil end
    local color = Ladder.Color(rec.colors, skill)
    if color == "grey" then return nil end
    local way = learnWay(ctx, spell, rec, skill)
    if not way then return nil end
    local _, green, grey = thresholds(rec.colors)
    local tierEnd = min(color == "green" and grey or green, limit)
    if tierEnd <= skill then return nil end
    local crafts = Ladder.Crafts(rec.colors, skill, tierEnd)
    if crafts == huge then return nil end
    local tier = color == "green" and 2 or 1
    local matCost, _, missing = ingredients(ctx, rec, crafts)
    local o = priced(ctx, { recipe = spell, name = rec.name, color = color, from = skill, to = tierEnd,
                            crafts = crafts, learn = way, matCost = matCost, missing = missing, tier = tier,
                            back = backFor(ctx, rec, crafts) }, way)

    local have = haveCrafts(ctx, rec)
    if have < 1 then return o end
    local to = reach(rec.colors, skill, have, tierEnd)
    if to <= skill or to >= tierEnd then return o end -- not one point, or the whole stretch: o says it already
    local bc = Ladder.Crafts(rec.colors, skill, to)
    local bCost, _, bMissing = ingredients(ctx, rec, bc)
    local b = priced(ctx, { recipe = spell, name = rec.name, color = color, from = skill, to = to, crafts = bc,
                            learn = way, matCost = bCost, missing = bMissing, tier = tier, fromBags = true, have = have,
                            back = backFor(ctx, rec, bc) }, way)
    return o, b
end

-- Made from what the character has, with a recipe it knows (or has in its bags): first in its colour, whatever else
-- earns a point (the user's rule).
local function fromWhatYouHave(o)
    return o.fromBags and (o.learn.kind == "known" or o.learn.kind == "owned" or o.learn.kind == "start") or false
end

local function better(a, b)
    if a.tier ~= b.tier then return a.tier < b.tier end
    if fromWhatYouHave(a) ~= fromWhatYouHave(b) then return fromWhatYouHave(a) end
    if a.tier == 3 then return a.crafts / (a.to - a.from) < b.crafts / (b.to - b.from) end
    if a.score ~= b.score then return a.score < b.score end
    if a.recipe ~= b.recipe then return a.recipe < b.recipe end
    return (a.fromBags and 1 or 0) > (b.fromBags and 1 or 0)
end

-- The pick the player made for the stretch that holds `skill`, if any: { from, to, recipe, bags }. A pick covers
-- the whole stretch it was made for, so it still holds after a few skill-ups.
local function choiceAt(choices, skill)
    for _, c in ipairs(choices or {}) do
        if skill >= c.from and skill < c.to then return c end
    end
end

-- The next rank this character needs after `cap`, or nil.
local function nextRank(data, cap)
    for _, rank in ipairs(data.ranks) do
        if rank.cap > cap then return rank end
    end
end

local function rankStep(ctx, rank, skill)
    local step = { kind = "rank", from = skill, to = skill, rank = rank, cost = 0 }
    if rank.how == "book" then
        local best
        for _, v in ipairs(rank.vendors or {}) do
            if hasFaction(v.faction, ctx.faction) and (not best or (v.cost or 0) < (best.cost or 0)) then best = v end
        end
        step.vendor = best and best.npc
        local real = rank.item and ctx.real[rank.item]
        step.cost = real or best and best.cost or rank.cost or 0
        step.guess = not real and best and best.costGuess or nil
    elseif rank.how == "trainer" or rank.how == "quest" then
        step.cost = rank.cost or 0 -- a quest's cost: what's paid after it (Nat Pagle's fee for Artisan Fishing)
    end
    if rank.mats then
        local cost, buy, missing = ingredients(ctx, { mats = rank.mats }, 1)
        step.cost, step.buy, step.missing = step.cost + cost, buy, missing
    end
    if rank.startQuests then step.startQuest = rank.startQuests[ctx.faction] end
    -- one quest for everyone, or one per faction
    if rank.quest then step.quest = type(rank.quest) == "table" and rank.quest[ctx.faction] or rank.quest end
    if rank.charLevel and ctx.level < rank.charLevel then step.needLevel = rank.charLevel end
    return step
end

-- Builds the ladder.
--   data  = a profession's data (ns.COOKING, ns.FIRSTAID)
--   state = { skill, maxSkill (current rank cap, 0 = no Cooking), target, faction = "A"/"H", level,
--             known = { [spell] = true }, owned = { [item] = count } }
--   quote = function(item, n, already, ahOnly) -> copper for buying n more after `already`, or nil (see Prices.Make)
--   opts  = { favor, maxOptions (6), realPrices = { [item] = what a vendor asked },
--             choices = { { from, to, recipe, bags }, ... } recipes the player picked for those stretches
--             (bags: the "with what you have" option of that recipe) }
-- Returns { from, to, steps = { ... }, cost, crafts, missing = { [item] = true }, stuck = reason or nil }.
-- A craft step also carries canCook (crafts the character can do right now with what they own) and haveMain (the
-- same, counting only the ingredients vendors don't sell); ready: how many of its crafts what they own covers as the
-- plan uses it, made ingredients too (see readyCrafts); fromBags marks a step that uses what they own; guess marks
-- a recipe whose learning skill is an estimate.
--   opts.smelt = { skill = the character's Mining, recipes = Mining's smelting recipes }: bars it can smelt are made
--   from ore when that's cheaper; opts.standing = function(faction) -> 0 (Hated) .. 7 (Exalted), for plans that
--   need reputation; state.specs = { [spell] = true } the specializations it has. A profession whose data says
--   resale counts what selling its crafts brings back (see resale; opts.vendorOnly: only what vendors pay); a tool a
--   recipe needs that vendors sell (a hammer) is bought if the character hasn't one.
local function newContext(data, state, quote, opts, sunk)
    local ctx = { faction = state.faction, level = state.level or 1, planLevel = state.level or 1,
                  known = state.known or {}, learned = {},
                  owned = {}, bought = {}, quote = quote, opts = opts, vendor = data.vendorPrices or {}, sunk = sunk or {},
                  real = opts.realPrices or {}, skill = state.skill or 0, makers = {}, specs = state.specs or {},
                  standing = opts.standing or function() end, sold = {}, sell = data.sell or {}, resale = data.resale,
                  mining = opts.smelt and opts.smelt.skill or 0, toolKinds = data.toolKinds or {}, vendorOnly = opts.vendorOnly,
                  initial = {}, batches = {}, uses = {} }
    for item, n in pairs(state.owned or {}) do ctx.owned[item], ctx.initial[item] = n, n end
    -- what the profession makes for its own recipes (grinding stones), and the bars Mining smelts
    local used = {}
    for _, rec in pairs(data.recipes) do
        for item in pairs(rec.mats) do used[item] = true end
    end
    for spell, rec in pairs(data.recipes) do
        if used[rec.makes] and not rec.cooldown then
            local start = false
            for _, g in ipairs(rec.get) do start = start or g.kind == "start" end
            ctx.makers[rec.makes] = { spell = spell, rec = rec, start = start }
        end
    end
    for spell, rec in pairs(opts.smelt and opts.smelt.recipes or {}) do
        if not ctx.makers[rec.makes] then ctx.makers[rec.makes] = { spell = spell, rec = rec, mining = true } end
    end
    ctx.hasTool = {} -- [tool kind] = true: the character has one (in its bags or in hand)
    ctx.toolRecipes = {} -- [spell] = true: makes a tool only a recipe makes
    -- [tool kind] = true: no recipe that needs it is for leveling (a cooldown, or learned at 300: Philosopher's Stone,
    -- for transmutes and flasks), so it's made once the ladder is done
    ctx.lateTools = {}
    local leveling = {}
    for _, rec in pairs(data.recipes) do
        for _, kind in ipairs(rec.tools or {}) do
            leveling[kind] = leveling[kind] or (not rec.cooldown and rec.learn < 300)
        end
    end
    for kind, useful in pairs(leveling) do ctx.lateTools[kind] = not useful or nil end
    for kind, tk in pairs(ctx.toolKinds) do
        if tk.make and not tk.buy then ctx.toolRecipes[tk.make] = true end
        for _, item in ipairs(tk.items) do
            if (ctx.owned[item] or 0) > 0 or state.equipped == item then ctx.hasTool[kind] = true end
        end
    end
    return ctx
end

-- Buy list `from` joins buy list `into`: counts and costs add up (a total stays unpriced once any part of it is), and
-- so do what made ingredients are made of, all the way down (Bronze Bars from Copper Bars from Copper Ore). What one
-- list makes and the other buys stays apart: make.made counts only the made ones.
local function mergeBuy(into, from)
    for item, b in pairs(from) do
        local lb = into[item]
        if not lb then
            into[item] = b
        else
            local pricedSoFar = lb.buy == 0 or lb.cost ~= nil
            lb.need, lb.have, lb.buy = lb.need + b.need, lb.have + b.have, lb.buy + b.buy
            if b.buy > 0 then
                lb.cost = (pricedSoFar and b.cost) and (lb.cost or 0) + b.cost or nil
            end
            lb.short = lb.short or b.short
            if b.make and lb.make then
                lb.make.crafts, lb.make.made = lb.make.crafts + b.make.crafts, lb.make.made + b.make.made
                mergeBuy(lb.make.parts, b.make.parts)
            elseif b.make then
                lb.make = b.make
            end
        end
    end
end

-- The next stretch `s` of the same recipe joins step `last`: skill, crafts, costs and what to buy add up.
local function mergeCraft(last, s)
    last.to = s.to
    last.crafts = last.crafts + s.crafts
    last.matCost = last.matCost + s.matCost
    last.cost = last.cost + s.cost
    last.missing = last.missing or s.missing
    if s.sale then addSale(last, s.sale) end
    mergeBuy(last.buy, s.buy)
end

-- A craft step for the stretch from `skill` to `to` with the chosen option (what Mining.lua shares too). chosen.tool
-- (a tool kind): one craft that makes the tool, kept.
local function craftStep(ctx, data, chosen, skill, to, shown, first)
    local rec = data.recipes[chosen.recipe]
    local crafts = chosen.tool and 1 or Ladder.Crafts(rec.colors, skill, to)
    local haveMain, canCook = haveCrafts(ctx, rec)
    local cost, buy, missing = ingredients(ctx, rec, crafts)
    local way = learnWay(ctx, chosen.recipe, rec, skill)
    local step = { kind = "craft", from = skill, to = to, recipe = chosen.recipe, color = chosen.color,
                   crafts = crafts, buy = buy, matCost = cost, learn = way, missing = missing,
                   cost = cost + way.cost, options = shown, fromBags = chosen.fromBags,
                   haveMain = haveMain, canCook = canCook, guess = rec.guess }
    if chosen ~= first then step.chosenByYou = true end
    step.tool = chosen.tool
    for _, kind in ipairs(rec.tools or {}) do
        local tk = data.toolKinds[kind]
        if tk.buy and not ctx.hasTool[kind] then
            local tc, tb = ingredients(ctx, { mats = { [tk.buy] = 1 } }, 1)
            buy[tk.buy], step.cost, step.matCost = tb[tk.buy], step.cost + tc, step.matCost + tc
            ctx.hasTool[kind] = true
        end
    end
    spend(ctx, buy, step)
    ctx.learned[chosen.recipe] = ctx.learned[chosen.recipe] or skill
    local made = crafts * (rec.yield or 1)
    if chosen.tool then
        ctx.hasTool[chosen.tool] = true
    elseif ctx.makers[rec.makes] then
        ctx.owned[rec.makes] = (ctx.owned[rec.makes] or 0) + made -- a grinding stone for later
        ctx.batches[rec.makes] = ctx.batches[rec.makes] or {}
        table.insert(ctx.batches[rec.makes], { step = step, left = made })
    elseif ctx.resale and rec.makes then
        addSale(step, resale(ctx, rec.makes, made, ctx.sold))
        ctx.sold[rec.makes] = (ctx.sold[rec.makes] or 0) + step.sale.ah
    end
    return step
end

-- A tool only a recipe makes (an Arclight Spanner), due as soon as its recipe can be learned, whether or not the
-- ladder uses it yet: the profession needs it sooner or later. late: the tools only recipes with a cooldown need
-- (made after the ladder) instead. Returns { kind, spell, rec } or nil.
local function toolDue(ctx, data, skill, late)
    local due
    for kind, tk in pairs(ctx.toolKinds) do
        local rec = (ctx.lateTools[kind] or false) == (late or false) and not tk.buy and tk.make and not ctx.hasTool[kind]
            and data.recipes[tk.make]
        if rec and rec.learn <= skill and hasTools(ctx, rec) and learnWay(ctx, tk.make, rec, skill)
            and (not due or rec.learn < due.rec.learn) then
            due = { kind = kind, spell = tk.make, rec = rec }
        end
    end
    return due
end

local function buildOnce(data, state, quote, opts, sunk)
    local ctx = newContext(data, state, quote, opts, sunk)
    local skill, cap = state.skill, state.maxSkill or 0
    local target = state.target or cap
    local result = { from = skill, to = target, steps = {}, cost = 0, crafts = 0, missing = {} }
    local steps = result.steps
    local maxOptions = opts.maxOptions or 6

    local guard = 0
    while skill < target do
        guard = guard + 1
        if guard > 400 then result.stuck = "loop"; break end

        local rank = nextRank(data, cap)
        if rank and skill >= rank.learnAt and cap < target then
            local step = rankStep(ctx, rank, skill)
            spend(ctx, step.buy or {}, step)
            steps[#steps + 1] = step
            cap = rank.cap
            skill = max(skill, 1) -- learning it gives 1
            -- past a "Reach level N" gate (the cap is the level x 5) the ladder plans for level N at least
            if rank.how == "level" then ctx.planLevel = max(ctx.planLevel, rank.charLevel) end
            rank = nextRank(data, cap)
        end
        local limit = min(cap, target)
        if skill >= limit then
            result.stuck = "cap"
            break
        end

        ctx.skill = skill
        local tool = toolDue(ctx, data, skill)
        if tool then
            -- one craft, its point counted only while it's sure (orange, or the first yellow point)
            local chosen = { recipe = tool.spell, color = Ladder.Color(tool.rec.colors, skill), tool = tool.kind }
            local to = Ladder.Chance(tool.rec.colors, skill) >= 1 and skill + 1 or skill
            local step = craftStep(ctx, data, chosen, skill, to, {}, chosen)
            for item, b in pairs(step.buy) do
                if b.buy > 0 and not b.cost then result.missing[item] = true end
            end
            steps[#steps + 1] = step
            skill = to
        else
            -- where to look again: the next skill a recipe unlocks, or a rank can be learned
            local stop = limit
            if rank and cap < target and rank.learnAt > skill then stop = min(stop, rank.learnAt) end
            local options = {}
            for spell, rec in pairs(data.recipes) do
                if rec.learn > skill then
                    if rec.learn < stop and not rec.cooldown and hasTools(ctx, rec) and learnWay(ctx, spell, rec) then
                        stop = rec.learn
                    end
                else
                    local o, b = option(ctx, spell, rec, skill, limit)
                    if o then options[#options + 1] = o end
                    if b then options[#options + 1] = b end
                end
            end
            table.sort(options, better)

            local chosen = options[1]
            local wanted = choiceAt(opts.choices, skill)
            if wanted then
                local sameRecipe
                for _, o in ipairs(options) do
                    if o.recipe == wanted.recipe then
                        if (o.fromBags or false) == (wanted.bags or false) then sameRecipe = o; break end
                        sameRecipe = sameRecipe or o -- the other option of that recipe, if the picked one is gone
                    end
                end
                chosen = sameRecipe or chosen
            end
            if not chosen then
                result.stuck = "no recipe"
                break
            end
            local shown = {}
            for i = 1, min(maxOptions, #options) do shown[i] = options[i] end
            local listed = false
            for _, o in ipairs(shown) do listed = listed or o == chosen end
            if not listed then shown[#shown + 1] = chosen end

            local to = min(chosen.to, stop)
            ctx.skill = skill
            local step = craftStep(ctx, data, chosen, skill, to, shown, options[1])
            for item, b in pairs(step.buy) do
                if b.buy > 0 and not b.cost then result.missing[item] = true end
            end
            steps[#steps + 1] = step
            skill = to
        end
    end

    -- the tools only recipes with a cooldown need (Philosopher's Stone), once the ladder is done
    local late = toolDue(ctx, data, skill, true)
    while late do
        ctx.skill = skill
        local chosen = { recipe = late.spell, color = Ladder.Color(late.rec.colors, skill), tool = late.kind }
        local step = craftStep(ctx, data, chosen, skill, skill, {}, chosen)
        step.late = true
        for item, b in pairs(step.buy) do
            if b.buy > 0 and not b.cost then result.missing[item] = true end
        end
        steps[#steps + 1] = step
        late = toolDue(ctx, data, skill, true)
    end

    -- one recipe over several stretches in a row is one step (but cooking what you have stays its own step, and so
    -- does making a tool)
    local merged, into = {}, {}
    for _, s in ipairs(steps) do
        local last = merged[#merged]
        if last and last.kind == "craft" and s.kind == "craft" and last.recipe == s.recipe and last.to == s.from
            and (last.fromBags or false) == (s.fromBags or false) and not last.tool and not s.tool then
            mergeCraft(last, s)
            into[s] = last
        else
            merged[#merged + 1] = s
            into[s] = s
        end
    end
    -- what a step makes for later steps: keep = { [item] = { n, from, to } } (from-to: the skill the steps that use
    -- it span); what none uses is sold
    for _, u in ipairs(ctx.uses) do
        local made, by = into[u.made], into[u.by]
        if made and by and made ~= by then
            made.keep = made.keep or {}
            local k = made.keep[u.item]
            if not k then
                k = { n = 0, from = by.from, to = by.to }
                made.keep[u.item] = k
            end
            k.n, k.from, k.to = k.n + u.n, min(k.from, by.from), max(k.to, by.to)
        end
    end
    for item, batches in pairs(ctx.batches) do
        for _, batch in ipairs(batches) do
            if ctx.resale and batch.left >= 1 and into[batch.step] then
                local sale = resale(ctx, item, batch.left, ctx.sold)
                ctx.sold[item] = (ctx.sold[item] or 0) + sale.ah
                addSale(into[batch.step], sale)
            end
        end
    end
    result.steps = merged
    result.paid, result.back = {}, 0
    for _, s in ipairs(merged) do
        result.cost = result.cost + (s.cost or 0)
        result.back = result.back + (s.back or 0)
        result.crafts = result.crafts + (s.crafts or 0)
        if s.kind == "craft" and s.learn.cost > 0 then result.paid[s.recipe] = true end
        if s.kind == "craft" then s.ready = readyCrafts(ctx, data.recipes[s.recipe], s) end
    end
    return result
end

local function count(t) local n = 0 for _ in pairs(t) do n = n + 1 end return n end

local function sameSet(a, b)
    for k in pairs(a) do if not b[k] then return false end end
    for k in pairs(b) do if not a[k] then return false end end
    return true
end

-- Better ladder: one that reaches the target, then fewer ingredients without a price, then cheaper.
local function cheaper(a, b)
    local sa, sb = a.stuck == "no recipe" and 1 or 0, b.stuck == "no recipe" and 1 or 0
    if sa ~= sb then return sa < sb end
    local ma, mb = count(a.missing), count(b.missing)
    if ma ~= mb then return ma < mb end
    return a.cost - a.back < b.cost - b.back - 0.5
end

function Ladder.Build(data, state, quote, opts)
    opts = opts or {}
    -- Picking step by step spreads a recipe's price over the step that uses it, so a recipe that costs a lot to
    -- learn looks dear even when a later step buys it anyway. So: build once, then again with the recipes that
    -- ladder bought counted as paid (at most twice more, until the same recipes come out), and keep the cheapest.
    local best = buildOnce(data, state, quote, opts, {})
    local sunk = best.paid
    for _ = 1, 2 do
        if not next(sunk) then break end
        local r = buildOnce(data, state, quote, opts, sunk)
        -- at the same cost the later build wins: it orders the options knowing which recipes get bought anyway
        if not cheaper(best, r) then best = r end
        if sameSet(r.paid, sunk) then break end
        sunk = r.paid
    end
    return best
end

-- Gold: what the character can make now (at its skill, with its tools), by what one craft earns, in two groups:
--   - what a vendor pays more for than its ingredients cost (vendors buy any number: no auction house needed);
--   - what earns at the auction house: only what's listed 5 or more times and pays 1.5 times what a vendor does (the
--     resale rule). How many sell the auction house doesn't say (AuctionDB knows what's listed, not what sold), so the
--     player decides how many to make.
-- An item can be in both when the auction house pays more. Ingredients are bought or made, whichever costs less, and
-- what the character owns counts at its price too: it could sell it instead. A recipe it doesn't know yet says after
-- how many crafts it pays back.
-- Returns { from, to, mode = "gold", steps = the vendor rows then the auction house rows, best first in each,
-- vendorRows = how many of them are first }; a row: { kind = "profit", recipe, crafts = 1, made, buy, matCost, learn,
-- sale, profit, cost, back, listed, payback = crafts that pay the recipe back, cooldown, vendor = in the first group,
-- color = the recipe's colour at the character's skill (grey: no skill-up) }.
function Ladder.Profits(data, state, quote, opts)
    local ctx = newContext(data, state, quote, opts or {})
    local owned = ctx.owned
    ctx.owned = {} -- priced as if bought
    ctx.skill = state.skill or 0
    local vendorRows, ahRows = {}, {}
    local function add(list, spell, rec, way, made, matCost, buy, sale, listed)
        local profit = sale.total - matCost
        list[#list + 1] = { kind = "profit", recipe = spell, from = ctx.skill, to = ctx.skill, crafts = 1, made = made,
                            buy = buy, matCost = matCost, learn = way, sale = sale, profit = profit, cost = matCost,
                            back = sale.total, listed = listed, cooldown = rec.cooldown, vendor = list == vendorRows or nil,
                            color = Ladder.Color(rec.colors, ctx.skill),
                            payback = way.cost > 0 and math.ceil(way.cost / profit) or nil }
    end
    for spell, rec in pairs(data.recipes) do
        local way = rec.makes and rec.learn <= ctx.skill and not ctx.toolRecipes[spell] and hasTools(ctx, rec)
            and learnWay(ctx, spell, rec, ctx.skill) -- an enchantment makes nothing to sell
        if way and way.cost > 0 and rec.item and (owned[rec.item] or 0) > 0 then
            way = { kind = "owned", cost = 0, item = rec.item }
        end
        local matCost, buy, missing
        if way then matCost, buy, missing = ingredients(ctx, rec, 1) end
        if way and not missing then
            local made, vendorEach = rec.yield or 1, ctx.sell[rec.makes] or 0
            local _, e = quote(rec.makes, 1, 0, true)
            if vendorEach * made > matCost then
                add(vendorRows, spell, rec, way, made, matCost, buy,
                    { ah = 0, ahEach = 0, vendor = made, vendorEach = vendorEach, total = vendorEach * made }, e and e.qty)
            end
            if e and e.qty and e.qty >= 5 then
                local sale = resale(ctx, rec.makes, made, {})
                if sale.ah > 0 and sale.total > matCost then add(ahRows, spell, rec, way, made, matCost, buy, sale, e.qty) end
            end
        end
    end
    local function best(a, b)
        if a.profit ~= b.profit then return a.profit > b.profit end
        return a.recipe < b.recipe
    end
    table.sort(vendorRows, best)
    table.sort(ahRows, best)
    for _, r in ipairs(ahRows) do vendorRows[#vendorRows + 1] = r end
    return { from = ctx.skill, to = ctx.skill, mode = "gold", steps = vendorRows, vendorRows = #vendorRows - #ahRows,
             cost = 0, back = 0, crafts = 0, missing = {} }
end

-- Food (Cooking): the roles a class eats for (a hybrid has several), and what each role's food raises.
local ROLES = { WARRIOR = { "Melee", "Tank" }, ROGUE = { "Melee" }, HUNTER = { "Ranged" }, MAGE = { "Caster" },
                WARLOCK = { "Caster" }, PRIEST = { "Healer", "Caster" }, DRUID = { "Melee", "Tank", "Caster", "Healer" },
                PALADIN = { "Melee", "Tank", "Healer" }, SHAMAN = { "Melee", "Caster", "Healer" } }
local ROLE_STATS = { Melee = { "str", "agi", "ap" }, Ranged = { "agi", "rap" }, Tank = { "sta" },
                     Caster = { "int", "spi", "spell" }, Healer = { "int", "spi", "heal" } }

-- Whether only the other side sells or rewards a recipe (an Alliance vendor or quest for a Horde character): no drop,
-- trainer or vendor of the character's side.
local function otherSide(rec, faction)
    local theirs = false
    for _, g in ipairs(rec.get) do
        if g.kind ~= "vendor" and g.kind ~= "quest" or hasFaction(g.faction or "AH", faction) then return false end
        theirs = true
    end
    return theirs
end

-- Food: the dishes worth eating for the character's class, a group per role, by what eating one raises (rec.buff,
-- only the role's stats). The ones it can eat now come first, the highest level first (food gets better with level),
-- then the ones for later by level. A dish whose recipe only the other side sells or rewards is left out, unless the
-- recipe is at the auction house or in the bags. Returns { mode = "food", steps, groups = { { name = role, from,
-- to } } }; a row:
-- { kind = "food", recipe, role, buff, eat = the level it asks, later = above the character's level, learn = the way
-- to its recipe, whatever the skill (nil: none for this character now), needSkill = the skill it asks when above the
-- character's, cost = one dish from bought ingredients (nil: one has no price), buy = one craft's buy list, ah = one
-- dish at the auction house }.
function Ladder.Food(data, state, quote, opts)
    local ctx = newContext(data, state, quote, opts or {})
    ctx.owned = {} -- priced as if bought
    ctx.skill = state.skill or 0
    local steps, groups = {}, {}
    local function better(a, b)
        if (a.later or false) ~= (b.later or false) then return not a.later end
        if a.eat ~= b.eat then return (a.eat > b.eat) ~= (a.later or false) end
        return a.recipe < b.recipe
    end
    for _, role in ipairs(ROLES[state.class] or { "Melee", "Ranged", "Tank", "Caster", "Healer" }) do
        local rows = {}
        for spell, rec in pairs(data.recipes) do
            local buff
            for _, stat in ipairs(ROLE_STATS[role]) do
                if rec.buff and rec.buff[stat] then
                    buff = buff or {}
                    buff[stat] = rec.buff[stat]
                end
            end
            local learn = buff and learnWay(ctx, spell, rec)
            if buff and (learn or not otherSide(rec, ctx.faction)) then
                local matCost, buy, missing = ingredients(ctx, rec, 1)
                rows[#rows + 1] = { kind = "food", recipe = spell, role = role, buff = buff, eat = rec.eat or 0,
                                    later = (rec.eat or 0) > (state.level or 60) or nil, from = ctx.skill, to = ctx.skill,
                                    learn = learn,
                                    needSkill = rec.learn > ctx.skill and rec.learn or nil,
                                    cost = not missing and matCost / (rec.yield or 1) or nil, buy = buy,
                                    ah = (quote(rec.makes, 1, 0, true)) }
            end
        end
        table.sort(rows, better)
        groups[#groups + 1] = { name = role, from = #steps + 1, to = #steps + #rows }
        for _, r in ipairs(rows) do steps[#steps + 1] = r end
    end
    return { from = ctx.skill, to = ctx.skill, mode = "food", steps = steps, groups = groups, cost = 0, back = 0,
             crafts = 0, missing = {} }
end

-- The parts other ladders share (Fishing.lua, Mining.lua): rank-ups, buying with what you own used first, the
-- player's picks, and recipes as options and steps.
Ladder.ROLES = ROLES -- Camp.lua's too
Ladder.NewContext = newContext
Ladder.NextRank = nextRank
Ladder.RankStep = rankStep
Ladder.Ingredients = ingredients
Ladder.Spend = spend
Ladder.ChoiceAt = choiceAt
Ladder.LearnWay = learnWay
Ladder.Option = option
Ladder.CraftStep = craftStep
Ladder.MergeCraft = mergeCraft
Ladder.Ready = readyCrafts
Ladder.Resale = resale
