-- Snapshot one character's state in one profession and today's AuctionDB prices into tests/fixtures/<name>.lua, so
-- the calculator tests run on real numbers that don't change every time the auction house is scanned.
--   luajit tests/make_fixture.lua <SavedVariables folder> <character GUID> <fixture name> [profession key] [skill/cap]
-- (skill/cap: for a profession the character hasn't got, e.g. 1/75 to plan Blacksmithing from the start)
-- Reads Mastercraft's saved character data (skill, level, known recipes, bags and bank) and AuctionDB's scans.
local svDir, guid, name, key, start = arg[1], arg[2], arg[3], arg[4] or "cooking", arg[5]
assert(svDir and guid and name,
    "usage: luajit tests/make_fixture.lua <SavedVariables folder> <character GUID> <name> [profession]")
local root = (arg[0]:match("^(.*)[/\\]tests[/\\]") or ".") .. "/"

local ns = {}
for _, file in ipairs({ "Data/Cooking.lua", "Data/FirstAid.lua", "Data/Fishing.lua", "Data/Mining.lua", "Data/Skinning.lua", "Data/Herbalism.lua", "Data/Lockpicking.lua", "Data/Blacksmithing.lua", "Data/Engineering.lua", "Data/Tailoring.lua", "Data/Enchanting.lua", "Data/Alchemy.lua", "Data/Leatherworking.lua", "Data/Poisons.lua", "Professions.lua" }) do
    assert(loadfile(root .. "CraftLadder/" .. file))("CraftLadder", ns)
end
local data = assert(ns.ProfessionByKey[key], "no profession " .. key)
dofile(svDir .. "/Mastercraft.lua")

local char = assert(MastercraftDB.chars[guid], "character not in Mastercraft's saved data")
local fx = { made = os.date("%Y-%m-%d"), name = char.name, level = char.level, profession = key,
             faction = char.faction == "Alliance" and "A" or "H", known = {}, owned = {}, ah = {} }
for _, p in ipairs(char.professions) do
    if p.name == data.name then fx.skill, fx.maxSkill = p.skill, p.max end
end
if not fx.skill and start then fx.skill, fx.maxSkill = start:match("^(%d+)/(%d+)$") end
fx.skill, fx.maxSkill = assert(tonumber(fx.skill), "the character hasn't got " .. data.name .. ": give skill/cap"),
    tonumber(fx.maxSkill)
for _, p in ipairs(char.professions) do
    if data.smelt and p.name == "Mining" then fx.mining = p.skill end -- the bars it can smelt
end
for _, r in ipairs(((MastercraftDB.recipes[guid] or {})[data.name] or {}).list or {}) do
    if r.learned then fx.known[r.id] = true end
end
if not next(fx.known) and loadfile(svDir .. "/CraftLadder.lua") then -- what Craft Ladder itself saw in the window
    dofile(svDir .. "/CraftLadder.lua")
    local prof = ((CraftLadderDB.chars or {})[guid] or {}).prof or {}
    for spell in pairs((prof[key] or {}).known or {}) do fx.known[spell] = true end
end

-- every item the calculator can ask about: ingredients, recipe items, rank-up items and mats; for Fishing its poles
-- and lures and the fish
local wanted = {}
for _, r in pairs(data.recipes) do
    for item in pairs(r.mats) do wanted[item] = true end
    if r.item then wanted[r.item] = true end
    if data.resale and r.makes then wanted[r.makes] = true end -- what selling it brings back
end
for _, rank in ipairs(data.ranks) do
    for item in pairs(rank.mats or {}) do wanted[item] = true end
end
for item in pairs(data.tools or {}) do wanted[item] = true end
for _, zone in pairs(data.zones or {}) do
    for item in pairs(zone.fish or {}) do wanted[item] = true end
end
for _, node in pairs(data.nodes or {}) do -- Mining's and Skinning's: what a node or a creature gives
    for item in pairs(node.loot or {}) do wanted[item] = true end
end

local inv = MastercraftDB.inv[guid] or {}
for _, place in ipairs({ "bags", "bank", "mail" }) do
    for item, n in pairs(inv[place] or {}) do
        if wanted[item] then fx.owned[item] = (fx.owned[item] or 0) + n end
    end
end

-- AuctionDB's saved file grew past what one Lua chunk may hold (65536 constants): read its scans line by line, keeping
-- each item's last scan for the character's house. Lines: `[key] = {`, `{` (a list entry), `123,`, `},`. Since v2.3
-- an item is one line, its scans as text: `[123] = "ts,min,median,qty ts,...",` (recent ones under "items", older days
-- under "daily": ts,min,median,qty,scans).
local function readHouse(path, faction)
    local house, stack, entry = { items = {}, scans = {} }, {}, nil
    local want = '"' .. faction .. '"'
    for line in io.lines(path) do
        line = line:match("^%s*(.-)%s*$")
        local key = line:match("^%[(.-)%] = {$")
        local id, text = line:match('^%[(%d+)%] = "(.-)",?$')
        if id and #stack == 4 and stack[3] == want and (stack[4] == '"items"' or stack[4] == '"daily"') then
            local ts, lo, med, qty = text:match("(%d+),(%d+),(%d+),(%d+)[%d,]*$")
            local item = tonumber(id)
            if ts and (stack[4] == '"items"' or not house.items[item]) then
                house.items[item] = { { tonumber(ts), tonumber(lo), tonumber(med), tonumber(qty) } }
            end
        elseif key or line == "{" or line:match("= {$") then
            stack[#stack + 1] = key or "#"
            if line == "{" then entry = {} end
        elseif line:match("^},?$") then
            local top = table.remove(stack)
            if top == "#" and entry and stack[3] == want then
                if stack[4] == '"items"' and #stack == 5 then house.items[tonumber(stack[5])] = { entry } end
                if stack[4] == '"scans"' and #stack == 4 then house.scans[#house.scans + 1] = entry end
            end
            entry = nil
        elseif entry then
            entry[#entry + 1] = tonumber(line:match("^(%-?[%d.]+),?$"))
        end
    end
    return house
end
local house = readHouse(svDir .. "/AuctionDB.lua", char.faction)
fx.scanTs = house.scans[#house.scans][1]
for item in pairs(wanted) do
    local hist = house.items[item]
    if hist then fx.ah[item] = hist[#hist] end -- { ts, min, median, qty }
end

-- write it sorted, so a new snapshot gives a readable diff
local function sortedKeys(t) local k = {} for x in pairs(t) do k[#k + 1] = x end table.sort(k) return k end
local out = { "-- Generated by tests/make_fixture.lua on " .. fx.made .. " - " .. fx.name .. ", " .. data.name .. " " ..
                  fx.skill .. "/" .. fx.maxSkill,
              "return {",
              ("  name = %q, level = %d, faction = %q, profession = %q, skill = %d, maxSkill = %d, scanTs = %d,"):format(
                  fx.name, fx.level, fx.faction, key, fx.skill, fx.maxSkill, fx.scanTs) }
if fx.mining then out[#out + 1] = ("  mining = %d,"):format(fx.mining) end
out[#out + 1] = "  known = { " .. (function()
    local s = {} for _, k in ipairs(sortedKeys(fx.known)) do s[#s + 1] = ("[%d] = true"):format(k) end return table.concat(s, ", ")
end)() .. " },"
out[#out + 1] = "  owned = { " .. (function()
    local s = {} for _, k in ipairs(sortedKeys(fx.owned)) do s[#s + 1] = ("[%d] = %d"):format(k, fx.owned[k]) end return table.concat(s, ", ")
end)() .. " },"
out[#out + 1] = "  -- [item] = { scan time, lowest unit price, median unit price, quantity listed }"
out[#out + 1] = "  ah = {"
for _, k in ipairs(sortedKeys(fx.ah)) do
    local e = fx.ah[k]
    out[#out + 1] = ("    [%d] = { %d, %d, %d, %d }, -- %s"):format(k, e[1], e[2], e[3], e[4], ns.Lookup("items", k) or "?")
end
out[#out + 1] = "  },"
out[#out + 1] = "}"
local path = root .. "tests/fixtures/" .. name .. ".lua"
local f = assert(io.open(path, "w"))
f:write(table.concat(out, "\n"), "\n")
f:close()
local n = 0 for _ in pairs(fx.ah) do n = n + 1 end
print(("wrote %s: %s level %d, %s %d/%d, %d recipes known, %d priced items"):format(path, fx.name, fx.level,
    data.name, fx.skill, fx.maxSkill, #sortedKeys(fx.known), n))
