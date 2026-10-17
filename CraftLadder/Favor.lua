-- Craft Ladder: Merchant's Favor recipes. Forever's supply-camp quartermasters sell recipes for Merchant's Favor; the
-- client doesn't say how much, or from which level, so a visit to one records both (CraftLadderDB.favorPrices; favor
-- itself is the "Merchant's Favor recipes" box). Pure Lua
-- (the tests run it) except the recording at the bottom.
local _, ns = ...

local Favor = {}
ns.Favor = Favor

Favor.CURRENCY = 3402 -- Merchant's Favor

-- The Favor price and the level to buy it that a recipe's data knows (seen at a quartermaster, or AllTheThings'),
-- else nil.
local function dataCost(rec)
    for _, g in ipairs(rec.get or {}) do
        if g.kind == "vendor" and g.favor then return tonumber(g.favor), g.favorLevel end
    end
end

-- A profession's recipes the quartermasters sell, with where the character stands on each:
-- state = { skill, level, known = { [spell] = true } }, owned = { [item] = count }, records = { [recipe item] = { cost,
-- level } } (seen at a quartermaster). Returns steps (kind "favor"), by the skill they're learned at:
-- { recipe, cost (Favor, nil = not seen yet), level (nil = not seen), status = "known" | "learn" | "skill" | "level",
--   canMake (known: crafts the bags allow) }.
function Favor.Recipes(data, state, owned, records)
    local steps = {}
    for spell, rec in pairs(data.recipes) do
        local sold
        for _, g in ipairs(rec.get or {}) do sold = sold or (g.kind == "vendor" and g.favor ~= nil) end
        if sold then
            local seen = rec.item and records[rec.item] or {}
            local cost, level = dataCost(rec)
            cost, level = seen.cost or cost, seen.level or level -- what this account saw beats the data
            local status = state.known[spell] and "known"
                or (level and level > state.level) and "level"
                or rec.learn > state.skill and "skill" or "learn"
            local canMake
            if status == "known" then
                canMake = math.huge
                for item, n in pairs(rec.mats) do canMake = math.min(canMake, math.floor((owned[item] or 0) / n)) end
                if canMake == math.huge then canMake = 0 end
            end
            steps[#steps + 1] = { kind = "favor", recipe = spell, cost = cost, level = level,
                                  status = status, canMake = canMake, from = rec.learn, to = rec.learn, crafts = 0 }
        end
    end
    table.sort(steps, function(a, b)
        local ra, rb = data.recipes[a.recipe], data.recipes[b.recipe]
        if ra.learn ~= rb.learn then return ra.learn < rb.learn end
        return ra.name < rb.name
    end)
    return steps
end

-- How many recipes a profession sells for Favor (the window shows its Favor button only when there are some).
function Favor.Count(data)
    local n = 0
    for _, rec in pairs(data.recipes) do
        for _, g in ipairs(rec.get or {}) do
            if g.kind == "vendor" and g.favor ~= nil then n = n + 1; break end
        end
    end
    return n
end

-- The character's Merchant's Favor, or nil when the game doesn't say.
function Favor.Have()
    local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(Favor.CURRENCY)
    return info and info.quantity
end

---------------------------------------------------------------------------------------------------------------
-- In game: at a merchant, every item it sells for Merchant's Favor is recorded (recipes the data didn't know are sold so
-- too): its price, the level its tooltip asks ("Requires Level 30"), its name and the merchant (npc).
---------------------------------------------------------------------------------------------------------------

local LEVEL = ITEM_MIN_LEVEL and "^" .. ITEM_MIN_LEVEL:gsub("%%d", "(%%d+)") .. "$" or "^Requires Level (%d+)$"

local function record()
    local db = ns.db
    if not (db and GetMerchantNumItems and GetMerchantItemID and GetMerchantItemCostInfo and GetMerchantItemCostItem) then
        return
    end
    local guid = UnitGUID and UnitGUID("npc")
    local npc = guid and tonumber(guid:match("^%a+%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
    for i = 1, GetMerchantNumItems() do
        local id = GetMerchantItemID(i)
        local cost
        for k = 1, id and GetMerchantItemCostInfo(i) or 0 do
            local _, value, link = GetMerchantItemCostItem(i, k)
            if link and link:find("currency:" .. Favor.CURRENCY, 1, true) then cost = value end
        end
        -- everything sold for favor, by name too: a pattern the client's item data lacks (Forever's new leather
        -- sets) can be told only that way
        if cost then
            local level
            local tip = C_TooltipInfo and C_TooltipInfo.GetMerchantItem and C_TooltipInfo.GetMerchantItem(i)
            for _, line in ipairs(tip and tip.lines or {}) do
                level = level or tonumber((line.leftText or ""):match(LEVEL))
            end
            local info = C_MerchantFrame and C_MerchantFrame.GetItemInfo and C_MerchantFrame.GetItemInfo(i)
            local name = info and info.name or (GetMerchantItemInfo and (GetMerchantItemInfo(i)))
            db.favorPrices = db.favorPrices or {}
            db.favorPrices[id] = { cost = cost, level = level, npc = npc, name = name, at = time() }
        end
    end
end

if CreateFrame then
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("MERCHANT_SHOW")
    frame:SetScript("OnEvent", function() C_Timer.After(0.3, record) end) -- the merchant's list fills in a moment
end
