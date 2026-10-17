-- Craft Ladder: prices. Craft Ladder doesn't scan the auction house itself; it reads what other addons saved.
-- Order: a vendor of your faction (the price a merchant really asked you beats the built-in one), then AuctionDB's
-- last full scan of your faction's auction house, then Auctionator.
local ADDON, ns = ...

local Prices = {}
ns.Prices = Prices

-- Vendor price per item for a faction ("A"/"H"), or nil when no always-stocked vendor sells it. (Goods sold only in
-- limited stock, like raw fish at fishing vendors, are priced from the auction house.)
function Prices.Vendor(itemID, faction, real)
    local p = real and real[itemID]
    if p then return p, { source = "vendor", real = true } end
    local v = ns.Lookup("vendorPrices", itemID)
    p = v and v[faction]
    if p then return p, { source = "vendor" } end
end

-- Total for the first n items bought. AuctionDB keeps the lowest price, the median (the middle price: half the items
-- listed cost less) and how many are listed, not every listing. So the list is taken as rising evenly from the
-- lowest price (the 1st item) to the median (the middle item): the more you buy, the more each one costs.
local function total(e, n)
    if e.qty and e.qty > 0 and e.median > e.min then
        return n * e.min + (e.median - e.min) * n * n / e.qty
    end
    return n * e.unit
end

-- A price lookup for one calculation. Every item is looked up once and remembered until the next calculation.
--   src = { faction, real = { [item] = vendor price paid },
--           auctionDB = function(item) -> { ts, min, median, qty }, last scan time,
--           auctionator = function(item) -> price, details }
-- Returns two functions:
--   quote(item, n, already, ahOnly) -> copper for buying n more when `already` were bought earlier in the ladder
--     (or nil: no price), and the price entry. ahOnly: only the auction house (for recipe items).
--   lookup(item, ahOnly) -> price entry { source, unit = lowest price per item, min, median, qty, ts, listed }
function Prices.Make(src)
    local memo = {}
    local function lookup(item, ahOnly)
        local key = ahOnly and -item or item
        local m = memo[key]
        if m ~= nil then return m or nil end
        local e
        if not ahOnly then
            local p, d = Prices.Vendor(item, src.faction, src.real)
            if p then e = d; e.unit = p end
        end
        if not e and src.auctionDB then
            local rec, lastScan = src.auctionDB(item)
            if rec and rec[2] and rec[2] > 0 then
                local median = rec[3] and rec[3] > rec[2] and rec[3] or rec[2]
                e = { source = "auctionDB", unit = rec[2], min = rec[2], median = median, qty = rec[4], ts = rec[1],
                      listed = not lastScan or rec[1] >= lastScan }
            end
        end
        if not e and src.auctionator then
            local p, d = src.auctionator(item)
            if p and p > 0 then e = d; e.unit = p end
        end
        memo[key] = e or false
        return e
    end
    local function quote(item, n, already, ahOnly)
        local e = lookup(item, ahOnly)
        if not e then return nil end
        already = already or 0
        return total(e, already + n) - total(e, already), e
    end
    return quote, lookup
end

local AH_CUT = 0.95 -- what an auction leaves you
Prices.AH_CUT = AH_CUT

-- What a vendor pays for an item: the profession's data (data.sell), else what the game says (Cooking and First Aid
-- keep no vendor prices), or nil.
function Prices.VendorSell(data, item)
    local sell = data.sell and data.sell[item]
    if sell then return sell end
    local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    return getInfo and select(11, getInfo(item)) or nil
end

-- What one item is worth to you when you sell it: its auction price after the cut, or what a vendor pays (data.sell),
-- whichever is more; a chest, crate or trunk (data.containers) is worth what's inside. Only what's listed at least
-- 5 times has an auction price: one odd listing (a 99g skull) says nothing about what a catch sells for. values
-- remembers each item's { value, how } for one calculation. Returns the value and how it was priced.
function Prices.Worth(data, quote, values, item)
    local known = values[item]
    if known then return known.value, known.how end
    local v, how = 0, nil
    local box = data.containers and data.containers[item]
    if box then
        values[item] = { value = 0, how = "contents" } -- what's inside never holds the box itself
        v = box.money + box.rest
        for inside, share in pairs(box.items) do v = v + share * Prices.Worth(data, quote, values, inside) end
        how = "contents"
    else
        local price, e = quote(item, 1, 0, true)
        if price and (not e.qty or e.qty >= 5) then v, how = price * AH_CUT, "auction" end
        local sell = data.sell and data.sell[item] or 0
        if sell > v then v, how = sell, "vendor" end
    end
    values[item] = { value = v, how = how }
    return v, how
end

---------------------------------------------------------------------------------------------------------------
-- In game
---------------------------------------------------------------------------------------------------------------

local function playerFaction()
    return UnitFactionGroup("player") == "Alliance" and "A" or "H"
end

-- AuctionDB: its own LastPrice for the item at your faction's auction house, and when its last full scan ran
-- (an item missing from that scan wasn't listed any more).
-- Read once per scan: an item's prices are the end of a long history string, and a ladder looks up hundreds.
-- shortcut: a price AuctionDB learns between scans (a live search) shows after the next scan, fine while scans are hourly
local seen, seenScan, seenHouse = {}, nil, nil
local function fromAuctionDB(item)
    local adb = _G.AuctionDB
    if not (adb and adb.LastPrice and adb.sv and adb.sv.houses) then return end
    local house = adb.PlayerHouse and adb:PlayerHouse() or UnitFactionGroup("player")
    local h = adb.sv.houses[house]
    local scans = h and h.scans
    local last = scans and scans[#scans]
    local scan = last and last[1]
    if scan ~= seenScan or house ~= seenHouse then seen, seenScan, seenHouse = {}, scan, house end
    local rec = seen[item]
    if rec == nil then
        rec = adb:LastPrice(item, house) or false
        seen[item] = rec
    end
    if not rec then return end
    return rec, scan
end

local function fromAuctionator(item)
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    if not (api and api.GetAuctionPriceByItemID) then return end
    local ok, p = pcall(api.GetAuctionPriceByItemID, ADDON, item)
    if not ok or not p then return end
    local okAge, age = pcall(api.GetAuctionAgeByItemID, ADDON, item)
    return p, { source = "auctionator", ageDays = okAge and age or nil }
end

-- Which auction house data is there: "AuctionDB", "Auctionator" or nil, and when AuctionDB last scanned.
function Prices.Source()
    local adb = _G.AuctionDB
    if adb and adb.LastPrice and adb.sv and adb.sv.houses then
        local house = adb.PlayerHouse and adb:PlayerHouse() or UnitFactionGroup("player")
        local h = adb.sv.houses[house]
        local last = h and h.scans and h.scans[#h.scans]
        return "AuctionDB", last and last[1]
    end
    if Auctionator and Auctionator.API and Auctionator.API.v1 then return "Auctionator" end
end

-- AuctionDB's next full scan, as its own "AHDB Scan" button counts it: "scanning", or "wait" and the seconds until
-- it may scan again (0: the next time you open the auction house). nil without AuctionDB.
function Prices.NextScan()
    local adb = _G.AuctionDB
    if not (adb and adb.ScanCooldownLeft) then return nil end
    if adb.scanState then return "scanning" end
    local ok, left = pcall(adb.ScanCooldownLeft, adb)
    if ok and type(left) == "number" then return "wait", left end
end

-- What vendors really asked this character: { [item] = copper each }, or nil. Kept per character: a reputation
-- discount is one character's, and the other side's vendors may not sell the item at all.
function Prices.Real()
    return ns.db and ns.Player.Saved().vendorPrices
end

function Prices.ForGame()
    return Prices.Make({
        faction = playerFaction(),
        real = Prices.Real(),
        auctionDB = fromAuctionDB,
        auctionator = fromAuctionator,
    })
end

-- Items whose real price is worth remembering: ingredients vendors sell, and the books that teach recipes and ranks.
local function worthRemembering()
    local items = {}
    for _, data in ipairs(ns.Professions) do
        for item in pairs(data.vendorPrices) do items[item] = true end
        for _, rec in pairs(data.recipes) do if rec.item then items[rec.item] = true end end
        for _, rank in ipairs(data.ranks) do if rank.item then items[rank.item] = true end end
    end
    return items
end

-- Remember what merchants really charge for them (reputation discounts included).
local merchant = CreateFrame and CreateFrame("Frame")
if merchant then
    merchant:RegisterEvent("MERCHANT_SHOW")
    merchant:SetScript("OnEvent", function()
        C_Timer.After(0.3, function()
            local db = ns.db
            if not (db and GetMerchantNumItems and GetMerchantItemID) then return end
            local wanted = worthRemembering()
            for i = 1, GetMerchantNumItems() do
                local id = GetMerchantItemID(i)
                if id and wanted[id] then
                    local price, stack
                    if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
                        local info = C_MerchantFrame.GetItemInfo(i)
                        price, stack = info and info.price, info and info.stackCount
                    elseif GetMerchantItemInfo then
                        local _, _, p, q = GetMerchantItemInfo(i)
                        price, stack = p, q
                    end
                    if price and price > 0 then
                        local c = ns.Player.Saved()
                        c.vendorPrices = c.vendorPrices or {}
                        c.vendorPrices[id] = price / math.max(1, stack or 1)
                    end
                end
            end
        end)
    end)
end
