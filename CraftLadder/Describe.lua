-- Craft Ladder: words for what the ladder found (shared by the window and the chat printout), and map pins.
local _, ns = ...

local D = {}
ns.Describe = D

-- The zone a map id names, from the game.
local function zoneName(map)
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return info and info.name
end

-- "Derak Nightfall", "Hillsbrad Foothills 63, 19.4"
function D.NPC(npc)
    local n = ns.Lookup("npcs", npc)
    if not n then return tostring(npc), nil end
    local zone = n.zone or zoneName(n.map)
    local where = zone and n.x and ("%s %s, %s"):format(zone, n.x, n.y) or zone
    return n.name or tostring(npc), where
end

function D.Quest(quest)
    local q = ns.Lookup("quests", quest)
    return q and q.name or tostring(quest), q
end

function D.ItemName(item)
    return ns.Lookup("items", item) or (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(item))
        or ("item " .. tostring(item))
end

-- What a dish raises (Cooking's food): "+20 Strength, +10 Stamina", in this order.
local BUFFS = { { "str", "Strength" }, { "agi", "Agility" }, { "sta", "Stamina" }, { "int", "Intellect" },
                { "spi", "Spirit" }, { "ap", "attack power" }, { "rap", "ranged attack power" },
                { "spell", "spell damage" }, { "heal", "healing" } }
function D.Buff(buff)
    local out = {}
    for _, b in ipairs(BUFFS) do
        if buff[b[1]] then out[#out + 1] = ("+%d %s"):format(buff[b[1]], b[2]) end
    end
    return table.concat(out, ", ")
end

-- A price, or "about" a price when it's an estimate.
function D.Price(copper, guess)
    return (guess and "about " or "") .. ns.Money(copper)
end

-- One line for how a recipe is learned (the ladder's learn way). data = the recipe's profession.
function D.Learn(way, data)
    if not way then return "" end
    local k = way.kind
    if k == "known" and way.earlier then -- the ladder learns it in an earlier step: the character doesn't know it yet
        return type(way.earlier) == "number" and ("learned at %d, earlier in the ladder"):format(way.earlier)
            or "learned earlier in the ladder"
    end
    if k == "known" then return "you know it" end
    if k == "owned" then return "the recipe is in your bags" end
    if k == "start" then return "known from the start" end
    if k == "trainer" then
        return (data and ((data.trainer or data.name) .. " trainer") or "trainer") .. ", " .. D.Price(way.cost, way.guess)
            .. (way.level and (", from level " .. way.level) or "")
    end
    if k == "vendor" then
        -- favor = true: for Merchant's Favor, how much unknown (the crafting professions' quartermasters)
        local price = way.favor and ((way.favor == true and "" or (way.favor .. " ")) .. "Merchant's Favor")
            or D.Price(way.cost, way.guess)
        return ("%s, %s"):format(D.NPC(way.npc), price)
    end
    if k == "quest" then return "quest " .. D.Quest(way.quest) end
    if k == "ah" then return "auction house, " .. ns.Money(way.cost) end
    return k
end

-- Why the way to learn a recipe isn't confirmed in Forever yet, or nil: a guessed trainer, a trainer's skill worked
-- out from Classic's, a Classic quest's reward, Classic data. Nothing to confirm once you have the recipe.
function D.Unconfirmed(rec, way)
    if not way or way.kind == "known" or way.kind == "owned" or way.kind == "start" then return nil end
    if rec.guess then
        return ("Nothing says who teaches it: Craft Ladder takes a trainer at %d. Open a trainer once and it will know.")
            :format(rec.learn)
    end
    if way.kind == "trainer" and rec.classicSkill then
        return ("The trainer's skill (%d) is worked out from Classic's (%d), not seen in Forever yet.")
            :format(rec.learn, rec.classicSkill)
    end
    if way.kind == "quest" and way.classic then
        return "This quest teaches it in Classic; not confirmed in Forever yet."
    end
    if rec.data == "classic" then return "How to get this recipe comes from Classic data: Forever may differ." end
end

-- Every vendor of your faction that sells a recipe, cheapest first: { { npc, cost, favor }, ... }.
function D.Vendors(data, spell, faction, favorOK)
    local rec = data.recipes[spell]
    local list = {}
    for _, g in ipairs(rec and rec.get or {}) do
        if g.kind == "vendor" and g.faction and g.faction:find(faction, 1, true) and not g.otherCost
            and (favorOK or not g.favor) then
            list[#list + 1] = g
        end
    end
    table.sort(list, function(a, b)
        local fa, fb = tonumber(a.favor) or (a.favor and 1 or 0), tonumber(b.favor) or (b.favor and 1 or 0)
        if fa ~= fb then return fa < fb end
        return (a.cost or 0) < (b.cost or 0)
    end)
    return list
end

-- Where an ingredient's price came from: "vendor, 36c each" / "auction house, 9c-10c each, 1018 listed".
function D.PriceSource(e)
    if not e then return "no price: not in your last auction house scan" end
    if e.source == "vendor" then
        return (e.real and "vendor (what you paid), " or "vendor, ") .. ns.Money(e.unit) .. " each"
    end
    if e.source == "auctionDB" then
        local each = e.median > e.min and (ns.Money(e.min) .. " - " .. ns.Money(e.median)) or ns.Money(e.min)
        return ("auction house, %s each, %d listed%s"):format(each, e.qty or 0, e.listed and "" or ", not in the last scan")
    end
    if e.source == "auctionator" then return "auction house (Auctionator), " .. ns.Money(e.unit) .. " each" end
    return ""
end

-- "Next AuctionDB scan in 7:12" / "... when you open the auction house" / "AuctionDB is scanning...", or nil.
function D.NextScan()
    local state, left = ns.Prices.NextScan()
    if state == "scanning" then return "AuctionDB is scanning...", "busy" end
    if state ~= "wait" then return nil end
    if left <= 0 then return "Next AuctionDB scan: when you open the auction house", "ready" end
    return ("Next AuctionDB scan in %d:%02d"):format(math.floor(left / 60), left % 60), "wait"
end

-- Puts a map pin (and the game's arrow) on an NPC. Falls back to telling where it is.
function ns.Waypoint(npc)
    local n = ns.Lookup("npcs", npc)
    local name, where = D.NPC(npc)
    if not (n and n.map and n.x and n.y) then
        ns.Chat(("no map position for %s."):format(name))
        return
    end
    ns.PinAt(n.map, n.x, n.y, name, where)
end

-- A map pin and the arrow at x, y (map %) of a ui map, said in chat as "name, where".
function ns.PinAt(map, x, y, name, where)
    local canSet = C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates and
        (not C_Map.CanSetUserWaypointOnMap or C_Map.CanSetUserWaypointOnMap(map))
    if canSet and pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(map, x / 100, y / 100)) then
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
        end
        ns.Chat(("map pin set on %s, %s."):format(name, where))
    else
        ns.Chat(("%s is in %s (the game can't pin this map)."):format(name, where or "an unknown place"))
    end
end
