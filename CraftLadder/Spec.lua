-- Craft Ladder: specializations (Weaponsmith, Gnomish Engineer, Dragonscale Leatherworking...): the steps to one, from
-- the profession's data (specGuides, built by tools/build_crafting.py), and where this character is on them: the
-- quests done or in its log, the items they ask for (bags and bank), the recipes that make them (known, or how to learn
-- them) and what's still missing, made or bought, whichever costs less. UI/SpecPanel.lua draws it.
local _, ns = ...

local Spec = {}
ns.Spec = Spec

local function hasFaction(f, faction) return f ~= nil and f:find(faction, 1, true) ~= nil end

-- Whether the game says a quest is done, or in the quest log now (the shown character's, Player.lua).
local function questDone(q) return ns.Player.QuestDone(q) end
local function inLog(q) return ns.Player.QuestInLog(q) end

-- The guide shown for a profession: the one picked last, else the specialization the character has, else the first.
function Spec.Guide(data, specs)
    local guides = data.specGuides or {}
    local picked = ns.Player.Prof(data).spec
    for _, g in ipairs(guides) do if g.spec == picked then return g end end
    for _, g in ipairs(guides) do if specs[g.spec] then return g end end
    return guides[1]
end

-- How many recipes only that specialization can learn.
function Spec.Unlocks(data, spec)
    local n = 0
    for _, rec in pairs(data.recipes) do if rec.spec == spec then n = n + 1 end end
    return n
end

-- The recipe of the profession that makes an item (the one learned first), or nil.
local function recipeFor(data, item)
    local spell, best
    for s, rec in pairs(data.recipes) do
        if rec.makes == item and not rec.twin and (not best or rec.learn < best.learn) then spell, best = s, rec end
    end
    return spell, best
end

-- The quests of a step on your side, and the one done or in the log (several givers: any of them).
local function sideQuests(data, quests, faction)
    local out = {}
    for _, q in ipairs(quests) do
        local info = data.quests[q]
        if info and hasFaction(info.faction, faction) then out[#out + 1] = q end
    end
    return out
end

local function questState(quests)
    for _, q in ipairs(quests) do if questDone(q) then return "done", q end end
    for _, q in ipairs(quests) do if inLog(q) then return "log", q end end
end

-- What a made item's ingredients (a buy list, Ladder.Ingredients') come to, all the way down: the items made on the way
-- (step.made[item] = { n = how many to make, have, mining = smelted }) and the rest, had or bought (step.mats[item] =
-- { need, have, buy, cost, noPrice }); the recipes used go on `recipes`.
local function walk(list, step, recipes)
    for item, b in pairs(list) do
        if b.make then -- one buy list makes all it doesn't have, or buys it all
            local m = step.made[item] or { n = 0, have = 0, mining = b.make.mining }
            m.n, m.have = m.n + b.make.made, m.have + b.have
            step.made[item] = m
            if not b.make.mining then recipes[#recipes + 1] = b.make.spell end
            walk(b.make.parts, step, recipes)
        else
            local m = step.mats[item] or { need = 0, have = 0, buy = 0, cost = 0 }
            m.need, m.have, m.buy = m.need + b.need, m.have + b.have, m.buy + b.buy
            if b.buy > 0 and b.cost then m.cost = m.cost + b.cost elseif b.buy > 0 then m.noPrice = true end
            step.mats[item] = m
        end
    end
end

-- The recipes the steps make things with, each once, with how to learn the ones you don't know (nil: no way for you
-- now); what learning them costs is the plan's.
local function addRecipe(plan, spell)
    if plan.seen[spell] then return end
    plan.seen[spell] = true
    local ctx, rec = plan.ctx, plan.data.recipes[spell]
    local way = ctx.known[spell] and { kind = "known", cost = 0 } or plan.ways[spell]
    if way == nil then way = ns.Ladder.LearnWay(ctx, spell, rec) or false end
    plan.recipes[#plan.recipes + 1] = { spell = spell, rec = rec, way = way or nil }
    if way then plan.learnCost = plan.learnCost + way.cost else plan.noPrice = true end
end

-- One item a quest asks for: what you have, and the rest bought or made, whichever costs less (the recipe's price
-- counted when you don't know it yet); made when nobody sells it, even with an ingredient no one sells either. Spends
-- what it uses, so the next item and step see what's left.
local function planItem(plan, step, x)
    local ctx, item = plan.ctx, x.item
    local have = math.min(ctx.owned[item] or 0, x.n)
    ctx.owned[item] = (ctx.owned[item] or 0) - have
    local e = { item = item, n = x.n, have = have, drops = x.drops, dropsN = x.dropsN }
    step.items[#step.items + 1] = e
    local n = x.n - have
    if n <= 0 then return end
    e.buy = ctx.quote(item, n, ctx.bought[item])
    local spell, rec = recipeFor(plan.data, item)
    local list, matCost, missing
    if rec then
        local crafts = math.ceil(n / (rec.yield or 1) - 1e-9)
        matCost, list, missing = ns.Ladder.Ingredients(ctx, rec, crafts)
        local way = ctx.known[spell] and { cost = 0 } or plan.ways[spell] or ns.Ladder.LearnWay(ctx, spell, rec)
        if not missing then e.make = matCost + (way and not plan.seen[spell] and way.cost or 0) end
        e.spell = spell
    end
    if rec and (e.make and (not e.buy or e.make <= e.buy) or not e.buy) then
        e.how = "make"
        ns.Ladder.Spend(ctx, list)
        local m = step.made[item] or { n = 0, have = 0 }
        m.n, m.have = m.n + n, m.have + have
        step.made[item] = m
        addRecipe(plan, spell)
        local recipes = {}
        walk(list, step, recipes)
        for _, s in ipairs(recipes) do addRecipe(plan, s) end
        step.cost = step.cost + matCost
        step.noPrice = step.noPrice or missing ~= nil
    elseif e.buy then
        e.how = "buy"
        ctx.bought[item] = (ctx.bought[item] or 0) + n
        step.cost = step.cost + e.buy
    else
        step.noPrice = true
    end
end

local function newStep(kind)
    return { kind = kind, items = {}, made = {}, mats = {}, cost = 0 }
end

-- A step of quests: its state, and when it isn't done yet, what its quest asks for.
local function questStep(plan, s, done)
    local step = newStep("quest")
    step.quests = sideQuests(plan.data, s.quests, plan.state.faction)
    if #step.quests == 0 then return nil end -- the other side's (Hank the Hammer's for a Horde character)
    step.status, step.quest = questState(step.quests)
    if done then step.status = "done" end
    step.quest = step.quest or step.quests[1]
    step.note, step.spec = s.note, s.spec
    if s.spec and plan.state.specs[s.spec] then step.status = "done" end
    if step.status ~= "done" then
        for _, x in ipairs(s.items or {}) do planItem(plan, step, x) end
    end
    return step
end

-- Where the character is on a specialization's steps: Spec.Plan(data, guide, state, quote) ->
-- { guide, have = it has the specialization, other = the one of the profession it has instead, steps, recipes =
-- { spell, rec, way } the steps make things with, cost (the steps' and the recipes' to learn), noPrice }.
-- A step: { kind = "talk" | "quest" | "pick", status = "done" | "log" | nil, ... }; a quest step's items
-- { item, n, have, buy, make, how = "make" | "buy" | nil (no price) }, made ([item] = { n, have, mining }), mats
-- ([item] = { need, have, buy, cost, noPrice }), cost; a pick step's options (quest steps). The masteries' quests
-- (pick) don't count in the cost: they come after.
function Spec.Plan(data, guide, state, quote)
    local s = {}
    for k, v in pairs(state) do s[k] = v end
    s.skill = 300 -- planned as if you could make everything already: the steps say what each asks
    local opts = { favor = ns.db and ns.db.favor, realPrices = ns.Prices.Real and ns.Prices.Real() or {},
                   smelt = data.smelt and { skill = (ns.Player.Skill(ns.MINING)), recipes = ns.MINING.recipes } or nil,
                   standing = ns.Player.Standing }
    local ctx = ns.Ladder.NewContext(data, s, quote, opts)
    local plan = { guide = guide, data = data, state = state, ctx = ctx, ways = {}, seen = {}, recipes = {},
                   learnCost = 0, steps = {}, cost = 0, have = state.specs[guide.spec] == true }
    -- what's made of what's made (grinding stones, tubes, blasting powder) counts the recipes you could learn
    -- shortcut: learning one isn't weighed against buying what it makes (its price is counted once it's used), fine
    -- while they're trainers' recipes for a few silver
    for _, m in pairs(ctx.makers) do
        if not m.mining and not ctx.known[m.spell] and plan.ways[m.spell] == nil then
            plan.ways[m.spell] = ns.Ladder.LearnWay(ctx, m.spell, m.rec) or false
        end
    end
    for spell, way in pairs(plan.ways) do
        if way then ctx.learned[spell] = true end
    end
    for _, g in ipairs(data.specGuides or {}) do
        if g ~= guide and state.specs[g.spec] then plan.other = g end
    end
    for _, step in ipairs(guide.steps) do
        local st
        if step.talk then
            st = newStep("talk")
            for _, npc in ipairs(step.talk) do
                local n = data.npcs[npc]
                if n and hasFaction(n.faction, state.faction) then st.npc = npc end
            end
            st.note = step.note
        elseif step.pick then
            st = newStep("pick")
            st.options, st.note = {}, step.note
            for _, o in ipairs(step.pick) do
                local opt = questStep(plan, o)
                if opt then st.options[#st.options + 1] = opt end
                if state.specs[o.spec] then st.status = "done" end
            end
        else
            st = questStep(plan, step, plan.have)
            if st then plan.cost = plan.cost + st.cost end
            plan.noPrice = plan.noPrice or (st and st.noPrice)
        end
        if st then plan.steps[#plan.steps + 1] = st end
    end
    plan.cost = plan.cost + plan.learnCost
    table.sort(plan.recipes, function(a, b)
        if a.rec.learn ~= b.rec.learn then return a.rec.learn < b.rec.learn end
        return a.rec.name < b.rec.name
    end)
    -- talking to the smith can't be seen: it's done once a later quest is taken
    local later = plan.have
    for i = #plan.steps, 1, -1 do
        local st = plan.steps[i]
        if st.kind == "talk" and later then st.status = "done" end
        if st.kind == "quest" and st.status then later = true end
    end
    return plan
end
