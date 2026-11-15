-- Craft Ladder: Buy or craft. For every recipe of a profession, what one craft's ingredients cost at today's prices
-- against what the thing itself costs to buy: meant for the materials a player keeps remaking (leather, bars, cloth,
-- bolts, oils). What's in your bags doesn't make a craft free here, both sides are prices, so the answer doesn't
-- change every time you buy something. Pure Lua (the tests run it).
local _, ns = ...

local BuyCraft = {}
ns.BuyCraft = BuyCraft

local counts = setmetatable({}, { __mode = "k" })

-- How many recipes of a profession make something to compare (an enchantment makes nothing): the bar's count.
function BuyCraft.Count(data)
    local n = counts[data]
    if not n then
        n = 0
        for _, rec in pairs(data.recipes or {}) do if rec.makes then n = n + 1 end end
        counts[data] = n
    end
    return n
end

-- A row per recipe that makes something, with both prices: cost = one craft's ingredients (a half-finished material
-- made instead of bought when that's cheaper, as the ladder plans it), price = what buying what it makes costs.
-- diff = cost - price: below zero, making is cheaper. Either is nil without a price, and those rows sort last.
-- base: what ns.Calculate returned (data, state, quote, opts).
function BuyCraft.Rows(base)
    local data, state = base.data, base.state
    local ctx = ns.Ladder.NewContext(data, state, base.quote, base.opts)
    ctx.owned = {} -- priced as if nothing were owned: what the bags hold is a note on the row, not a discount
    local rows = {}
    for spell, rec in pairs(data.recipes or {}) do
        if rec.makes then
            local made = rec.yield or 1
            local cost, buy, missing = ns.Ladder.Ingredients(ctx, rec, 1)
            local price, e = ctx.quote(rec.makes, made, 0)
            local known = ctx.known[spell] or nil
            local row = { kind = "buycraft", recipe = spell, known = known, from = rec.learn, to = rec.learn,
                          crafts = 1, made = made, buy = buy, missing = missing,
                          cost = not missing and cost or nil, price = price, listed = e and e.qty,
                          source = e and e.source, color = ns.Ladder.Color(rec.colors, ctx.skill),
                          needSkill = rec.learn > ctx.skill and rec.learn or nil,
                          learn = ns.Ladder.LearnWay(ctx, spell, rec) or { kind = "none", cost = 0 },
                          canCook = select(2, ns.Ladder.HaveCrafts({ owned = state.owned or {},
                              vendor = data.vendorPrices or {}, faction = state.faction }, rec)),
                          owned = (state.owned or {})[rec.makes],
                          find = ns.Describe.Searchable(rec) }
            if row.cost and row.price then
                row.diff = row.cost - row.price
                row.each = row.diff / made
            end
            rows[#rows + 1] = row
        end
    end
    table.sort(rows, function(a, b)
        if (a.diff ~= nil) ~= (b.diff ~= nil) then return a.diff ~= nil end -- what has no price goes last
        if a.from ~= b.from then return a.from < b.from end
        local an, bn = data.recipes[a.recipe].name, data.recipes[b.recipe].name
        if an ~= bn then return an < bn end
        return a.recipe < b.recipe
    end)
    return rows
end

-- The rows as the window shows them: what the skill boxes and the search box leave, the recipes you know in one
-- folding group and the rest in another, each by the skill it's learned at. opts = { from, to, find }.
function BuyCraft.Ladder(base, rows, opts)
    opts = opts or {}
    local data = base.data
    local from, to = opts.from or 0, opts.to or 300
    local find = opts.find ~= "" and opts.find and opts.find:lower() or nil
    local steps, groups = {}, {}
    for _, want in ipairs({ true, false }) do
        local first = #steps + 1
        for _, row in ipairs(rows) do
            local shown = (row.known or false) == want and row.from >= from and row.from <= to
                and (not find or row.find:find(find, 1, true) ~= nil)
            if shown then steps[#steps + 1] = row end
        end
        groups[#groups + 1] = { key = want and "known" or "unknown", from = first, to = #steps,
                                name = want and "Recipes you know" or "Not known yet",
                                tip = want and "What you can make now, by the skill it's learned at. Click to fold" ..
                                    " or open." or "The rest of the profession's recipes: what each would cost to" ..
                                    " make, and how to learn it. Click to fold or open." }
    end
    return { data = data, state = base.state, mode = base.mode, buy = true, steps = steps, groups = groups,
             foldKey = "buyFolded", quote = base.quote, opts = base.opts,
             cost = 0, back = 0, crafts = 0, missing = {} }
end
