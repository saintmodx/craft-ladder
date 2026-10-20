-- Craft Ladder: disenchanting. Enchanting's Disenchant mode: what the character's crafting professions make with the
-- recipes they know that's worth more disenchanted than sold (Data/Disenchant.lua: what each kind of item gives,
-- Classic's table). The calculation is pure Lua with no game calls, as Ladder.lua's. And in game every disenchant is
-- recorded, so the builder can check Classic's table against Forever.
local _, ns = ...

local Disenchant = {}
ns.Disenchant = Disenchant

local DE = ns.DISENCHANT
local Ladder = ns.Ladder
local LESSER = {} -- [greater essence] = the lesser one, 3 of which make it
for lesser, greater in pairs(DE.greater) do LESSER[greater] = lesser end

local Z90 = 1.2816 -- 9 times out of 10 a normal curve stays above its average less this many spreads
Disenchant.BATCH = 10 -- the batch the card's "9 times out of 10" is for
Disenchant.SPELL = 13262
Disenchant.SEEN = 5 -- recorded disenchants of a bucket from which they replace its table (the user's number)

-- The bucket an item falls in, as tools/build_disenchant.py has it, or nil: a crafted item's from the data, any
-- other's from what the game says of it (nil until the game has loaded it). A game call: not for Build.
function Disenchant.BucketOf(item)
    if DE.items[item] then return DE.items[item] end
    local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    if not getInfo then return end
    local _, _, quality, level, _, _, _, _, equipLoc, _, _, classID, subclassID = getInfo(item)
    if not (level and (classID == 2 or classID == 4)) then return end
    -- a shield or an off-hand item counts as a weapon (CMaNGOS's)
    local class = (classID == 2 or subclassID == 6 or equipLoc == "INVTYPE_HOLDABLE") and "weapon" or "armor"
    for id, b in pairs(DE.buckets) do
        if b.class == class and b.quality == quality and level >= b.levels[1] and level <= b.levels[2] then
            return id
        end
    end
end

-- What the bags hold that can be disenchanted (weapons and armor, green to epic, the game's flag aside), one entry per
-- item: { item, count, bound = soulbound (no auction house), bucket, sell = what a vendor pays }. A game call.
function Disenchant.Bags()
    local C, getInfo = C_Container, (C_Item and C_Item.GetItemInfo) or GetItemInfo
    if not (C and C.GetContainerNumSlots and C.GetContainerItemInfo and getInfo) then return {} end
    local byItem, list = {}, {}
    for bag = 0, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4 do
        for slot = 1, C.GetContainerNumSlots(bag) or 0 do
            local info = C.GetContainerItemInfo(bag, slot)
            local item = info and info.itemID
            local id = item and not DE.noDisenchant[item] and Disenchant.BucketOf(item)
            if id then
                local e = byItem[item]
                if not e then
                    e = { item = item, count = 0, bound = false, bucket = id, sell = select(11, getInfo(item)) or 0 }
                    byItem[item], list[#list + 1] = e, e
                end
                e.count, e.bound = e.count + (info.stackCount or 1), e.bound or info.isBound or false
            end
        end
    end
    return list
end

-- What the game gave, by bucket, from disenchantLog's lines ("item time material:count ..."): { [bucket] = { n =
-- disenchants, mats = { [material] = { k = the disenchants it came in, min, max, total } } } }. bucketOf(item) -> its
-- bucket, or nil (it's skipped).
function Disenchant.Seen(log, bucketOf)
    local seen = {}
    for _, line in ipairs(log or {}) do
        local item, got = line:match("^(%d+) %d+ (.+)$")
        local id = item and bucketOf(tonumber(item))
        if id then
            local s = seen[id] or { n = 0, mats = {} }
            s.n = s.n + 1
            for mat, n in got:gmatch("(%d+):(%d+)") do
                mat, n = tonumber(mat), tonumber(n)
                local m = s.mats[mat] or { k = 0, min = n, max = n, total = 0 }
                m.k, m.min, m.max, m.total = m.k + 1, math.min(m.min, n), math.max(m.max, n), m.total + n
                s.mats[mat] = m
            end
            seen[id] = s
        end
    end
    return seen
end

-- What a bucket gives: from the player's own disenchants once there are SEEN of them (each material's share of the
-- disenchants it came in, the fewest and the most of it, as the builder does with what it's given), else the data's.
function Disenchant.Table(id, seen)
    local b, s = DE.buckets[id], seen and seen[id]
    if not (s and s.n >= Disenchant.SEEN) then return b end
    local gives = {}
    for mat, m in pairs(s.mats) do gives[#gives + 1] = { item = mat, chance = m.k / s.n, min = m.min, max = m.max } end
    table.sort(gives, function(x, y)
        if x.chance ~= y.chance then return x.chance > y.chance end
        return x.item < y.item
    end)
    return { class = b.class, quality = b.quality, levels = b.levels, skill = b.skill, gives = gives, seen = s.n }
end

-- What each material is worth to the character, for one calculation: what it sells for (Prices.Worth: the auction
-- house after its cut, with 5 or more listed, else what a vendor pays), or what it makes: 3 lesser essences make a
-- greater one and a greater one splits into 3 lesser, whichever is more.
function Disenchant.Worth(quote)
    local values = {}
    local function own(item) return (ns.Prices.Worth(DE, quote, values, item)) end
    return function(item)
        local v = own(item)
        if DE.greater[item] then v = math.max(v, own(DE.greater[item]) / 3) end
        if LESSER[item] then v = math.max(v, own(LESSER[item]) * 3) end
        return v
    end
end

-- What one disenchant of a bucket brings with each material at worth(item): its average and its spread (standard
-- deviation). One of the bucket's outcomes drops, any count from its min to its max as likely.
function Disenchant.Value(bucket, worth)
    local mean, square = 0, 0
    for _, g in ipairs(bucket.gives) do
        local v, n, sum, sumSq = worth(g.item), g.max - g.min + 1, 0, 0
        for k = g.min, g.max do sum, sumSq = sum + k, sumSq + k * k end
        mean = mean + g.chance * v * sum / n
        square = square + g.chance * v * v * sumSq / n
    end
    return mean, math.sqrt(math.max(0, square - mean * mean))
end

-- What n disenchants bring at least, 9 times out of 10: a normal curve's estimate, never below nothing.
function Disenchant.Sure(mean, spread, n)
    return math.max(0, n * mean - Z90 * math.sqrt(n) * spread)
end

-- What to do with a bag's item (Build's row), in words.
function Disenchant.Verdict(row)
    return row.disenchant and "disenchant" or row.sale.how == "auction" and "sell at the auction house"
        or row.sale.how == "vendor" and "sell to a vendor" or "keep (nobody buys it)"
end

-- The character knows the recipe, or every character starts with it.
local function knows(ctx, spell, rec)
    if ctx.known[spell] then return true end
    for _, g in ipairs(rec.get) do
        if g.kind == "start" then return true end
    end
    return false
end

-- Disenchant mode, in three groups (the user's logic):
--   - what the bags hold that can be disenchanted, whatever made it: disenchant it or sell it (the auction house,
--     not when it's soulbound, or a vendor), whichever brings more on average; what disenchanting gains over selling
--     first, then what sells for the most;
--   - what the character's crafting professions make with the recipes they know (at their skill, with their tools)
--     that's worth more disenchanted than sold (what sells for more is Gold's, the user's rule), and isn't in the bags:
--     by what disenchanting brings less what making it costs (at a loss last);
--   - of those, what Enchanting's skill can't disenchant yet.
--   data, state = Enchanting's; opts.crafts = { { data, state, smelt }, ... } the character's crafting professions
--   (Enchanting too), each with the bars it may smelt (see Ladder.Build's opts.smelt); opts.bags = what the bags hold
--   (Disenchant.Bags); opts.seen = what the game gave (Disenchant.Seen)
-- Ingredients are bought or made, whichever costs less, what the character owns at its price too (as Gold).
-- Returns { mode = "disenchant", steps, bags = how many rows are the bags', now = how many Enchanting can disenchant
-- now or sell (those first), known = how many known recipes make something to disenchant, worth = what each material
-- is worth }. Every row has each = what one disenchant brings on average, spread = of one disenchant, sale = { each,
-- how } what selling one brings ("auction", "vendor" or nil: nothing), bucket, de = what it gives (Disenchant.Table),
-- seen = what the game gave of the bucket (opts.seen's), needSkill = the Enchanting it asks when above the
-- character's. A bag's row: { kind = "bag", item, count, bound, disenchant = disenchanting brings more (and the skill
-- allows it), gain = what disenchanting them all brings over selling them (below 0: selling brings more) }. A
-- recipe's: { kind = "disenchant", recipe, data = its profession, made, buy, matCost, cost = what making it costs
-- (every ingredient priced), back = what disenchanting what it makes brings, profit = back - cost, color = its
-- skill-up colour at its profession's skill, learn, crafts = 1, canCook = crafts the bags allow }.
function Disenchant.Build(data, state, quote, opts)
    local worth, skill = Disenchant.Worth(quote), state.skill or 0
    local bags, now, later, known, bagged = {}, {}, {}, 0, {}
    local function common(row, id)
        row.de, row.seen, row.bucket = Disenchant.Table(id, opts.seen), opts.seen and opts.seen[id], id
        row.each, row.spread = Disenchant.Value(row.de, worth)
        row.needSkill = row.de.skill > skill and row.de.skill or nil
        row.from, row.to = skill, skill
        return row
    end
    for _, b in ipairs(opts.bags or {}) do
        bagged[b.item] = true
        local row = common({ kind = "bag", item = b.item, count = b.count, bound = b.bound }, b.bucket)
        local sold, how = b.sell, b.sell > 0 and "vendor" or nil -- soulbound: only a vendor
        if not b.bound then sold, how = ns.Prices.Worth({ sell = { [b.item] = b.sell } }, quote, {}, b.item) end
        row.sale = { each = sold, how = how }
        row.disenchant = not row.needSkill and row.each > sold
        row.gain = (row.each - sold) * b.count
        bags[#bags + 1] = row
    end
    for _, c in ipairs(opts.crafts or {}) do
        local ctx = Ladder.NewContext(c.data, c.state, quote, { realPrices = opts.realPrices, standing = opts.standing,
                                                                 smelt = c.smelt })
        local mats, values = ctx.owned, {}
        ctx.owned = {} -- priced as if bought
        ctx.skill = c.state.skill or 0
        for spell, rec in pairs(c.data.recipes) do
            local id = rec.makes and DE.items[rec.makes]
            if id and rec.learn <= ctx.skill and knows(ctx, spell, rec) and not ctx.toolRecipes[spell]
                and Ladder.HasTools(ctx, rec) then
                known = known + 1
                local matCost, buy, missing = Ladder.Ingredients(ctx, rec, 1)
                local row = common({ kind = "disenchant", recipe = spell, data = c.data, crafts = 1,
                                     made = rec.yield or 1, buy = buy, matCost = matCost, cost = matCost,
                                     color = Ladder.Color(rec.colors, ctx.skill),
                                     learn = { kind = "known", cost = 0 } }, id)
                local sold, how = ns.Prices.Worth(c.data, quote, values, rec.makes)
                if row.each > sold and not missing and not bagged[rec.makes] then
                    row.sale, row.back = { each = sold, how = how }, row.each * row.made
                    row.profit = row.back - row.cost
                    row.canCook = math.huge
                    for item, n in pairs(rec.mats) do
                        row.canCook = math.min(row.canCook, math.floor((mats[item] or 0) / n))
                    end
                    table.insert(row.needSkill and later or now, row)
                end
            end
        end
    end
    table.sort(bags, function(a, b)
        if a.disenchant ~= b.disenchant then return a.disenchant end
        if a.disenchant and a.gain ~= b.gain then return a.gain > b.gain end
        local sa, sb = a.sale.each * a.count, b.sale.each * b.count
        if sa ~= sb then return sa > sb end
        return a.item < b.item
    end)
    local function best(a, b)
        if a.profit ~= b.profit then return a.profit > b.profit end
        return a.recipe < b.recipe
    end
    table.sort(now, best)
    table.sort(later, function(a, b)
        if a.needSkill ~= b.needSkill then return a.needSkill < b.needSkill end
        return best(a, b)
    end)
    local steps = bags
    for _, r in ipairs(now) do steps[#steps + 1] = r end
    for _, r in ipairs(later) do steps[#steps + 1] = r end
    return { from = skill, to = skill, mode = "disenchant", steps = steps, bags = #steps - #now - #later,
             now = #steps - #later, known = known, worth = worth, cost = 0, back = 0, crafts = 0, missing = {} }
end

---------------------------------------------------------------------------------------------------------------
-- In game: every disenchant is recorded (CraftLadderDB.disenchantLog: "item time material:count ..." lines), so the
-- builder can compare what Forever gives with Classic's table (tools/seen_in_game.py, tools/build_disenchant.py).
-- The item is the one the game locks in the bags while Disenchant is cast on it; failing that, the loot's source.
---------------------------------------------------------------------------------------------------------------

-- The one item locked in the bags (Disenchant's target while it's cast), or nil (none, or more than one).
local function lockedItem()
    local C = C_Container
    if not (C and C.GetContainerNumSlots and C.GetContainerItemInfo) then return end
    local found
    for bag = 0, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4 do
        for slot = 1, C.GetContainerNumSlots(bag) or 0 do
            local info = C.GetContainerItemInfo(bag, slot)
            if info and info.isLocked then
                if found then return end
                found = info.itemID
            end
        end
    end
    return found
end

if CreateFrame then
    local frame = CreateFrame("Frame")
    for _, event in ipairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_SUCCEEDED", "LOOT_OPENED" }) do
        pcall(frame.RegisterEvent, frame, event)
    end
    local target, at -- the item being disenchanted, and when the cast ended
    frame:SetScript("OnEvent", function(_, event, unit, _, spell)
        if not ns.db then return end
        if event == "UNIT_SPELLCAST_START" then
            if unit == "player" and spell == Disenchant.SPELL then target, at = lockedItem(), nil end
            return
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            if unit == "player" and spell == Disenchant.SPELL then at = GetTime() end
            return
        end
        if not (at and GetTime() - at < 5 and GetNumLootItems) then return end
        at = nil
        local item = target
        if not item and GetLootSourceInfo and C_Item and C_Item.GetItemIDByGUID then
            local guid = GetLootSourceInfo(1)
            item = guid and guid:find("^Item%-") and C_Item.GetItemIDByGUID(guid) or nil
        end
        local got = {}
        for slot = 1, GetNumLootItems() do
            local link = GetLootSlotLink and GetLootSlotLink(slot)
            local mat = link and tonumber(link:match("item:(%d+)"))
            if mat then got[#got + 1] = ("%d:%d"):format(mat, select(3, GetLootSlotInfo(slot)) or 1) end
        end
        if not item or #got == 0 then return end
        local log = ns.db.disenchantLog or {}
        log[#log + 1] = ("%d %d %s"):format(item, time(), table.concat(got, " "))
        ns.db.disenchantLog = log
        if ns.OnKnownChanged then ns.OnKnownChanged() end -- what it gave may change Disenchant's numbers
    end)
end
