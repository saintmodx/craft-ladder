-- Craft Ladder: prices. Craft Ladder doesn't scan the auction house itself; it reads what other addons saved.
-- Order: a vendor of your faction (the price a merchant really asked you beats the built-in one), then the auction
-- house addon the Settings menu picked (ns.db.prices.source: AuctionDB's last full scan of your faction's auction
-- house, or Auctionator), one of them, not both: two addons' prices are two scan times.
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

-- Total for the first n items bought. AuctionDB keeps the lowest price, the median (half of what's listed costs less)
-- and how many are listed, not every listing. Buying goes at the median unless the Settings menu picked the cheapest
-- listing (src.how = "min", which lookup then stores as the entry's median): the lowest is one auction, often a
-- single cheap one that someone bought minutes after the scan, while a cheap price with real stock behind it pulls
-- the median down with it. (At the whole stock both come to the same money.)
local function total(e, n)
    return n * (e.median or e.unit)
end

-- A price lookup for one calculation. Every item is looked up once and remembered until the next calculation.
--   src = { faction, real = { [item] = vendor price paid },
--           live = function(item) -> what your own search at the auction house saw, newer than the scan,
--           auctionDB = function(item) -> { ts, min, median, qty }, last scan time,
--           auctionator = function(item) -> price, details,
--           how = "median" (the default) or "min": which listed price buying pays }
-- Returns two functions:
--   quote(item, n, already, ahOnly) -> copper for buying n more when `already` were bought earlier in the ladder
--     (or nil: no price), and the price entry. ahOnly: only the auction house (for recipe items).
--   lookup(item, ahOnly) -> price entry { source, unit = lowest price per item, min, median (what buying goes at),
--     qty, ts, listed }
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
        -- a search of your own sees every auction of that item: newer and exact, so it beats the last scan
        if not e and src.live then
            local l = src.live(item)
            if l then
                e = { source = "search", unit = l.min, min = l.min, median = src.how ~= "min" and l.median or l.min,
                      qty = l.qty, ts = l.ts, listed = true, partial = l.partial }
            end
        end
        if not e and src.auctionDB then
            local rec, lastScan = src.auctionDB(item)
            if rec and rec[2] and rec[2] > 0 then
                local median = rec[2]
                if src.how ~= "min" and rec[3] and rec[3] > rec[2] then median = rec[3] end
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
        -- selling goes at the lowest price listed, the one to undercut, not at the median buying pays
        local _, e = quote(item, 1, 0, true)
        local price = e and (e.min or e.unit)
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

-- Your faction's auction house at AuctionDB ("Horde", as its own calls name it) and when it last scanned there, or
-- nil without AuctionDB. Its saved data is keyed by realm and ruleset in front of that name ("eu-forever-pvp Horde"),
-- which only SavedHouse knows how to build: reading sv.houses by the bare name finds nothing.
local function auctionDBHouse()
    local adb = _G.AuctionDB
    if not (adb and adb.LastPrice and adb.sv and adb.sv.houses) then return end
    local house = adb.PlayerHouse and adb:PlayerHouse() or UnitFactionGroup("player")
    local h = adb.SavedHouse and adb:SavedHouse(house) or adb.sv.houses[house]
    local last = h and h.scans and h.scans[#h.scans]
    return house, last and last[1]
end

-- AuctionDB: its own LastPrice for the item at your faction's auction house, and when its last full scan ran
-- (an item missing from that scan wasn't listed any more).
-- Read once per scan: an item's prices are the end of a long history string, and a ladder looks up hundreds.
-- shortcut: a price AuctionDB learns between scans (a live search) shows after the next scan, fine while scans are hourly
local seen, seenScan, seenHouse = {}, nil, nil
local function fromAuctionDB(item)
    local adb = _G.AuctionDB
    local house, scan = auctionDBHouse()
    if not house then return end
    if scan ~= seenScan or house ~= seenHouse then seen, seenScan, seenHouse = {}, scan, house end
    local rec = seen[item]
    if rec == nil then
        rec = adb:LastPrice(item, house) or false
        seen[item] = rec
    end
    if not rec then return end
    return rec, scan
end

-- Auctionator's API says what an item costs, not how many are listed. Its own database keeps that too ("available",
-- the most seen that day), so read it where AuctionDB isn't there to say: with AuctionDB the prices stay its own.
-- Only the count is taken from that day: its prices are the lowest price each of the day's scans saw, so the lowest
-- of them may be hours old (and the highest is no median), while the API gives the last scan's.
-- Set by ForGame, so it isn't looked up for every item of a ladder.
local auctionatorQty = false

local function fromAuctionator(item)
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    if not (api and api.GetAuctionPriceByItemID) then return end
    local ok, p = pcall(api.GetAuctionPriceByItemID, ADDON, item)
    if not ok or not p then return end
    local okAge, age = pcall(api.GetAuctionAgeByItemID, ADDON, item)
    local e = { source = "auctionator", ageDays = okAge and age or nil }
    local db = auctionatorQty and Auctionator.Database
    if db and db.GetPriceHistory then
        local okDays, days = pcall(db.GetPriceHistory, db, tostring(item))
        local day = okDays and days and days[1]
        if day and (day.available or 0) > 0 then e.min, e.median, e.qty = p, p, day.available end
    end
    return p, e
end

local function auctionDBThere()
    local house, scan = auctionDBHouse()
    if not house then return end
    return "AuctionDB", scan
end

local function auctionatorThere()
    if not (Auctionator and Auctionator.API and Auctionator.API.v1) then return end
    -- Auctionator keeps the time of its last scan of either kind (the full one and the browse "summary" one)
    local st = Auctionator.SavedState
    local scan = st and math.max(st.TimeOfLastReplicateScan or 0, st.TimeOfLastBrowseScan or 0, 0)
    return "Auctionator", scan and scan > 0 and scan or nil
end

-- Which auction house data is read: "AuctionDB", "Auctionator" or nil, and when it last scanned. The Settings menu
-- picks one (ns.db.prices.source); the other is read when the picked one isn't installed.
function Prices.Source()
    local first, second = auctionDBThere, auctionatorThere
    if ns.db and ns.db.prices and ns.db.prices.source == "auctionator" then first, second = second, first end
    local name, scan = first()
    if name then return name, scan end
    return second()
end

-- How old Auctionator's prices are, in days (0: today), or nil. It keeps no time of day, only the day it last saw a
-- price for an item, so the age is the freshest of a handful of goods every auction house lists. Asked at most once
-- a minute: the header draws every second.
local STAPLES = { 2589, 2770, 2318, 2447, 4306 } -- Linen Cloth, Copper Ore, Light Leather, Peacebloom, Silk Cloth
local staleDays, askedAt = nil, nil
function Prices.AuctionatorAge()
    local api = Auctionator and Auctionator.API and Auctionator.API.v1
    if not (api and api.GetAuctionAgeByItemID) then return end
    local now = time()
    if askedAt and now - askedAt < 60 then return staleDays end
    askedAt, staleDays = now, nil
    for _, item in ipairs(STAPLES) do
        local ok, days = pcall(api.GetAuctionAgeByItemID, ADDON, item)
        if ok and days and (not staleDays or days < staleDays) then staleDays = days end
    end
    return staleDays
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

-- What your own searches at the auction house saw: ns.db.live[faction][item] = { ts, min, median, qty, partial }.
-- Per faction, as the auction houses are. A search of one item sees every auction of it, so its numbers are better
-- than the last scan's - until a scan passes them, when the row is dropped.
local function liveStore()
    if not ns.db then return end
    ns.db.live = ns.db.live or {}
    local f = playerFaction()
    ns.db.live[f] = ns.db.live[f] or {}
    return ns.db.live[f]
end

-- The lowest price, the median and how many are listed, from a search's rows { price each, how many }. The median is
-- the middle item, not the middle listing: a big cheap lot counts for more than a small one, as AuctionDB counts it.
local function searchStats(units)
    table.sort(units, function(a, b) return a[1] < b[1] end)
    local qty = 0
    for _, u in ipairs(units) do qty = qty + u[2] end
    if qty == 0 then return end
    local seen, median = 0, nil
    for _, u in ipairs(units) do
        seen = seen + u[2]
        if not median and seen >= qty / 2 then median = u[1] end
    end
    return units[1][1], median or units[1][1], qty
end

local liveVersion = 0

-- Counts the searches recorded: what reads live prices (the auction house tab) redraws when it changes.
function Prices.LiveVersion() return liveVersion end

-- Records what a search showed for one item. units = { { price each, how many }, ... }, empty: nothing listed.
-- partial: the auction house hadn't loaded the whole list, so the median is of what it had.
function Prices.Searched(item, units, partial)
    local store = liveStore()
    if not store then return end
    local min, median, qty = searchStats(units)
    local now = GetServerTime and GetServerTime() or time()
    local was = store[item]
    store[item] = min and { ts = now, min = min, median = median, qty = qty, partial = partial or nil } or nil
    local scan = select(2, Prices.Source()) -- rows a scan has passed are dead weight
    for id, e in pairs(store) do if scan and e.ts <= scan then store[id] = nil end end
    -- the same search answers more than once while its pages load: nothing to calculate again when the numbers hold
    if was and min and was.min == min and was.median == median and was.qty == qty then return end
    liveVersion = liveVersion + 1
    if ns.Window then
        if ns.Window.IsShown() then ns.Window.Refresh() else ns.Window.Invalidate() end
    end
end

function Prices.ForGame()
    local source, scan = Prices.Source() -- the addon the Settings menu picked, or the one installed
    auctionatorQty = source ~= "AuctionDB"
    local store = liveStore()
    return Prices.Make({
        faction = playerFaction(),
        real = Prices.Real(),
        live = store and function(item)
            local e = store[item]
            if e and (not scan or e.ts > scan) then return e end
        end or nil,
        auctionDB = source == "AuctionDB" and fromAuctionDB or nil,
        auctionator = source == "Auctionator" and fromAuctionator or nil,
        how = ns.db and ns.db.prices and ns.db.prices.how or nil,
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

-- A search at the auction house, yours or another addon's (Auctionator's Shopping tab, the game's own Buy tab):
-- it sees every auction of that item, so its prices are recorded. Only a search of one item, never the browse list
-- of names, which would fill the table with everything ever typed. Nothing is asked of the auction house here: only
-- what a search already brought is read, so there is no throttling to worry about.
local searches = CreateFrame and CreateFrame("Frame")
if searches then
    for _, e in ipairs({ "COMMODITY_SEARCH_RESULTS_UPDATED", "ITEM_SEARCH_RESULTS_UPDATED" }) do
        pcall(searches.RegisterEvent, searches, e) -- pcall: an event this client lacks
    end
    searches:SetScript("OnEvent", function(_, event, arg)
        local ah = C_AuctionHouse
        if not ah then return end
        local units = {}
        if event == "COMMODITY_SEARCH_RESULTS_UPDATED" then
            if type(arg) ~= "number" or not ah.GetNumCommoditySearchResults then return end
            for i = 1, ah.GetNumCommoditySearchResults(arg) do
                local r = ah.GetCommoditySearchResultInfo(arg, i)
                if r and (r.unitPrice or 0) > 0 then units[#units + 1] = { r.unitPrice, math.max(r.quantity or 1, 1) } end
            end
            local full = not ah.HasFullCommoditySearchResults or ah.HasFullCommoditySearchResults(arg)
            Prices.Searched(arg, units, not full)
        else
            local item = type(arg) == "table" and arg.itemID
            if not item or not ah.GetNumItemSearchResults then return end
            -- rows group auctions of the same price and size here: quantity is how many of them, buyoutAmount what
            -- one asks; an auction without a buyout says no price
            for i = 1, ah.GetNumItemSearchResults(arg) do
                local r = ah.GetItemSearchResultInfo(arg, i)
                if r and (r.buyoutAmount or 0) > 0 then units[#units + 1] = { r.buyoutAmount, math.max(r.quantity or 1, 1) } end
            end
            local full = not ah.HasFullItemSearchResults or ah.HasFullItemSearchResults(arg)
            Prices.Searched(item, units, not full)
        end
    end)
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
                        local c = ns.Player.Me() -- yours, whoever the window shows
                        c.vendorPrices = c.vendorPrices or {}
                        c.vendorPrices[id] = price / math.max(1, stack or 1)
                    end
                end
            end
        end)
    end)
end
