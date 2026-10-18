-- Craft Ladder: what the game says about this character: profession skills, level, faction, known recipes and
-- ingredients; and what trainers really ask.
local _, ns = ...

local Player = {}
ns.Player = Player

-- The localized name of a profession: what its Apprentice spell is called.
local function localName(data)
    local spell = data.apprentice
    if not spell then return data.name end -- shortcut: Lockpicking's English name, fine until a localized client
    return (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(spell)) or (GetSpellInfo and GetSpellInfo(spell))
        or data.name
end

-- A profession's recipes by the name the game shows (the client's language, so a Russian trainer's list matches); of
-- two recipes with one name (Season of Discovery's second version), the older one.
local function recipesByName(data)
    local names = {}
    for spell, rec in pairs(data.recipes) do
        local name = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(spell) or rec.name
        if not names[name] or spell < names[name] then names[name] = spell end
    end
    return names
end

-- A profession's skill and its current cap (0, 0 when the character doesn't have it).
function Player.Skill(data)
    if GetProfessions and GetProfessionInfo then
        for i = 1, select("#", GetProfessions()) do
            local index = select(i, GetProfessions())
            if index then
                local _, _, skill, maxSkill, _, _, line = GetProfessionInfo(index)
                if line == data.skillLine then return skill or 0, maxSkill or 0 end
            end
        end
    end
    if GetNumSkillLines and GetSkillLineInfo then
        local name = localName(data)
        for i = 1, GetNumSkillLines() do
            local lineName, isHeader, _, rank, _, _, maxRank = GetSkillLineInfo(i)
            if not isHeader and lineName == name then return rank or 0, maxRank or 0 end
        end
    end
    return 0, 0
end

-- This character's saved data: { prof = { [profession key] = { known, knownAt, choices } }, tab,
-- vendorPrices = { [item] = what a vendor really asked it } }.
function Player.Saved()
    local db = ns.db
    db.chars = db.chars or {}
    local key = (UnitGUID and UnitGUID("player")) or (UnitName("player") .. "-" .. GetRealmName())
    local c = db.chars[key]
    if not c then
        c = {}
        db.chars[key] = c
    end
    c.prof = c.prof or {}
    if c.known then -- from when Cooking was all there was
        c.prof.cooking = { known = c.known, knownAt = c.knownAt, choices = c.choices or {} }
        c.known, c.knownAt, c.choices = nil, nil, nil
    end
    return c
end

-- What this character saved for one profession: { known = { [spell] = true }, knownAt, choices }.
function Player.Prof(data)
    local prof = Player.Saved().prof
    local p = prof[data.key]
    if not p then
        p = { known = {}, choices = {} }
        prof[data.key] = p
    end
    return p
end

-- Known recipes: what the profession's window showed last time, plus what the game reports as learned spells.
function Player.Known(data)
    local known = {}
    for spell in pairs(Player.Prof(data).known) do known[spell] = true end
    if IsPlayerSpell then
        for spell in pairs(data.recipes) do
            if not known[spell] and IsPlayerSpell(spell) then known[spell] = true end
        end
    end
    return known
end

-- This character's bank as Bagnon (its BagBrother part) last saw it: { [item] = count }, or nil without Bagnon.
-- The game itself only knows the bank once you've opened it in this session; Bagnon remembers it.
local function bagnonBank()
    local all = _G.BrotherBags
    if type(all) ~= "table" then return nil end
    local forever = WOW_PROJECT_ID == 18
    local name, surname = UnitFullName("player")
    -- BagBrother's own keys: Forever characters are "Name Surname" under "forever", others under their realm
    local id = (forever and surname and surname ~= "") and (name .. " " .. surname) or name
    local realm = forever and "forever" or (GetNormalizedRealmName and GetNormalizedRealmName())
    local me = realm and type(all[realm]) == "table" and all[realm][id]
    if type(me) ~= "table" then return nil end
    local lastInventoryBag = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4
    local bank = {}
    for bagID, bag in pairs(me) do
        if type(bagID) == "number" and (bagID < 0 or bagID > lastInventoryBag) and type(bag) == "table"
            and type(bag.items) == "table" then
            for _, entry in pairs(bag.items) do
                -- "itemID", "itemID;count" or "itemID:link fields;count"
                local item = type(entry) == "string" and tonumber(entry:match("^(%d+)"))
                if item then bank[item] = (bank[item] or 0) + (tonumber(entry:match(";(%d+)$")) or 1) end
            end
        end
    end
    return bank
end

-- While the bank is open the game counts it as items move; Bagnon saves its copy only when the bank closes, so until
-- then that copy still has what was just taken out to the bags (counted twice).
local bankOpen = false
local bankFrame = CreateFrame("Frame")
bankFrame:RegisterEvent("BANKFRAME_OPENED")
bankFrame:RegisterEvent("BANKFRAME_CLOSED")
bankFrame:SetScript("OnEvent", function(_, event) bankOpen = event == "BANKFRAME_OPENED" end)

-- How many of each of a profession's items the character has: bags, plus the bank as the game or Bagnon knows it
-- (whichever saw more; only the game's while the bank is open). Returns owned, and inBank = the bank's part of it.
function Player.Owned(data)
    local count = (C_Item and C_Item.GetItemCount) or GetItemCount
    local owned, inBank = {}, {}
    if not count then return owned, inBank end
    local saved = not bankOpen and bagnonBank()
    local function add(item)
        if owned[item] == nil then
            local bags = count(item, false) or 0
            local bank = math.max((count(item, true) or 0) - bags, saved and saved[item] or 0)
            owned[item] = bags + bank > 0 and bags + bank or false
            if bank > 0 then inBank[item] = bank end
        end
    end
    for _, rec in pairs(data.recipes) do
        for item in pairs(rec.mats) do add(item) end
        if rec.item then add(rec.item) end
    end
    for _, rank in ipairs(data.ranks) do
        for item in pairs(rank.mats or {}) do add(item) end
    end
    for item in pairs(data.tools or {}) do add(item) end
    for item, n in pairs(owned) do
        if not n then owned[item] = nil end -- false only marked "looked at, none"
    end
    return owned, inBank
end

-- Your standing with a faction: 0 (Hated) .. 7 (Exalted), or nil when the game doesn't say.
function Player.Standing(faction)
    if C_Reputation and C_Reputation.GetFactionDataByID then
        local f = C_Reputation.GetFactionDataByID(faction)
        if f and f.reaction then return f.reaction - 1 end
    end
    if GetFactionInfoByID then
        local _, _, standing = GetFactionInfoByID(faction)
        if standing then return standing - 1 end
    end
end

-- The ladder always goes to 300: the professions end there, and planning only to the rank's cap would miss recipes
-- bought for later anyway.
function Player.State(data)
    local skill, maxSkill = Player.Skill(data)
    local owned, inBank = Player.Owned(data)
    local specs = {} -- Armorsmith, Weaponsmith... the ones this character has
    for spell in pairs(data.specs or {}) do
        if IsPlayerSpell and IsPlayerSpell(spell) then specs[spell] = true end
    end
    return {
        specs = specs,
        skill = skill, maxSkill = maxSkill, target = 300,
        faction = UnitFactionGroup("player") == "Alliance" and "A" or "H",
        level = UnitLevel("player"), class = select(2, UnitClass("player")), -- "WARRIOR": Cooking's food for it
        known = Player.Known(data), owned = owned, inBank = inBank,
        equipped = GetInventoryItemID and GetInventoryItemID("player", INVSLOT_MAINHAND or 16) or nil,
    }
end

---------------------------------------------------------------------------------------------------------------
-- Reading a profession's window. It lists every recipe, learned or not; only learned ones are kept. Reading is
-- cheap, but the list updates often while crafting, so it's read at most once per second.
---------------------------------------------------------------------------------------------------------------

-- The profession most of `spells` belong to.
local function whose(spells)
    local best, bestN = nil, 0
    for _, data in ipairs(ns.Professions) do
        local n = 0
        for spell in pairs(spells) do if data.recipes[spell] then n = n + 1 end end
        if n > bestN then best, bestN = data, n end
    end
    return best
end

local function readModern()
    local T = C_TradeSkillUI
    if (T.IsTradeSkillLinked and T.IsTradeSkillLinked()) or (T.IsTradeSkillGuild and T.IsTradeSkillGuild()) then return end
    local ids = T.GetAllRecipeIDs and T.GetAllRecipeIDs()
    if not ids then return end
    local listed = {}
    for _, id in ipairs(ids) do listed[id] = true end
    local data = whose(listed)
    if not data then return end
    local known = {}
    for id in pairs(listed) do
        if data.recipes[id] then
            local info = T.GetRecipeInfo(id)
            if info and info.learned then known[id] = true end
        end
    end
    return data, known
end

local function readClassic()
    if not (GetNumTradeSkills and GetTradeSkillInfo) then return end
    local byName = {}
    for _, data in ipairs(ns.Professions) do
        for name, spell in pairs(recipesByName(data)) do
            if not byName[name] or spell < byName[name] then byName[name] = spell end
        end
    end
    local known = {}
    for i = 1, GetNumTradeSkills() do
        local name, kind = GetTradeSkillInfo(i)
        if name and kind ~= "header" and kind ~= "subheader" and byName[name] then known[byName[name]] = true end
    end
    local data = whose(known)
    if not data then return end
    for spell in pairs(known) do
        if not data.recipes[spell] then known[spell] = nil end
    end
    return data, known
end

local pending = false
local function readWindow()
    pending = false
    if not ns.db then return end
    local data, known
    if C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs then data, known = readModern() else data, known = readClassic() end
    if data and next(known) then
        local p = Player.Prof(data)
        p.known = known
        p.knownAt = time()
        if ns.OnKnownChanged then ns.OnKnownChanged(data) end
    end
end

local frame = CreateFrame("Frame")
for _, event in ipairs({ "TRADE_SKILL_SHOW", "TRADE_SKILL_LIST_UPDATE" }) do frame:RegisterEvent(event) end
frame:SetScript("OnEvent", function()
    if pending then return end
    pending = true
    C_Timer.After(1, readWindow)
end)

-- A recipe just learned (from a scroll, at a trainer): known at once, not only once the profession's window is opened
-- again (the game may not report recipes as spells).
local learnedFrame = CreateFrame("Frame")
pcall(learnedFrame.RegisterEvent, learnedFrame, "NEW_RECIPE_LEARNED") -- pcall: a client without it
learnedFrame:SetScript("OnEvent", function(_, _, spell)
    if not ns.db then return end
    for _, data in ipairs(ns.Professions) do
        if data.recipes and data.recipes[spell] then
            Player.Prof(data).known[spell] = true
            if ns.OnKnownChanged then ns.OnKnownChanged(data) end
        end
    end
end)

---------------------------------------------------------------------------------------------------------------
-- Trainers: the skill each recipe really needs and its fee. Some recipes' data is a guess (no source says from which
-- skill a trainer teaches them, or that one does at all); one visit to a trainer replaces the guess for good. A
-- guessed recipe the trainer doesn't list, though it lists recipes of that skill or higher, isn't taught by trainers:
-- it's dropped from the ladder (notAtTrainer).
---------------------------------------------------------------------------------------------------------------

-- Puts what trainers said into the data: the recipe's skill, its fee, and that a trainer teaches it at all (or not);
-- a rank's fee.
function Player.ApplyTrainerNotes()
    for _, data in ipairs(ns.Professions) do
        for _, rank in ipairs(data.ranks) do
            local seen = rank.spell and ns.db and ns.db.rankFees and ns.db.rankFees[rank.spell]
            if seen then rank.cost = seen.cost end
        end
    end
    for spell, note in pairs(ns.db and ns.db.trainer or {}) do
        local rec = ns.FindRecipe(spell)
        if rec and note.notAtTrainer then
            local get = {}
            for _, g in ipairs(rec.get) do
                if not (g.kind == "trainer" and g.costGuess) then get[#get + 1] = g end
            end
            rec.get, rec.notAtTrainer = get, true
        elseif rec then
            rec.notAtTrainer = nil -- a trainer lists it after all
            if note.skill then
                rec.learn, rec.colors[1], rec.guess = note.skill, note.skill, nil
            end
            local trainer
            for _, g in ipairs(rec.get) do
                if g.kind == "trainer" then trainer = g end
            end
            if not trainer then
                trainer = { kind = "trainer" }
                table.insert(rec.get, trainer)
            end
            if note.cost then trainer.cost, trainer.costGuess = note.cost, nil end
        end
    end
end

local function readTrainer()
    if not (ns.db and GetNumTrainerServices and GetTrainerServiceInfo and GetTrainerServiceSkillReq) then return end
    local byName, profOf = {}, {}
    for _, data in ipairs(ns.Professions) do
        byName[localName(data)], profOf[localName(data)] = recipesByName(data), data -- the trainer's is the older one
    end
    local notes = ns.db.trainer or {}
    local changed = false
    local listed = {} -- [profession data] = { spells = { [spell] = true }, top = the highest skill a listed recipe asks }
    for i = 1, GetNumTrainerServices() do
        local name = GetTrainerServiceInfo(i)
        local skillName, skillRank = GetTrainerServiceSkillReq(i)
        -- the skill a service asks for names its profession: an Alchemy trainer's Healing Potion isn't First Aid's
        local spell = name and skillName and byName[skillName] and byName[skillName][name]
        if spell then
            local cost = GetTrainerServiceCost and GetTrainerServiceCost(i)
            local note = { skill = tonumber(skillRank), cost = tonumber(cost), at = time() }
            local old = notes[spell]
            if not old or old.skill ~= note.skill or old.cost ~= note.cost then changed = true end
            notes[spell] = note
            local l = listed[profOf[skillName]] or { spells = {}, top = 0 }
            -- a specialization's recipe doesn't count: its trainer (Armorsmith, Dragonscale) lists only its own
            local spec = profOf[skillName].recipes[spell].spec
            l.spells[spell], l.top = true, math.max(l.top, not spec and note.skill or 0)
            listed[profOf[skillName]] = l
        end
        -- a rank (Journeyman, Expert, Artisan) is named as its profession; the skill it asks tells which
        local data = not spell and name and name == skillName and profOf[skillName]
        for _, rank in ipairs(data and data.ranks or {}) do
            local fee = GetTrainerServiceCost and tonumber(GetTrainerServiceCost(i))
            if rank.how == "trainer" and rank.spell and rank.learnAt == tonumber(skillRank) and fee then
                ns.db.rankFees = ns.db.rankFees or {}
                if not ns.db.rankFees[rank.spell] or ns.db.rankFees[rank.spell].cost ~= fee then changed = true end
                ns.db.rankFees[rank.spell] = { cost = fee, at = time() }
            end
        end
    end
    -- guessed recipes this trainer would list if it taught them: only when it shows what you can't learn yet too
    local showsAll = not GetTrainerServiceTypeFilter
        or (GetTrainerServiceTypeFilter("available") and GetTrainerServiceTypeFilter("unavailable"))
    for data, l in pairs(showsAll and listed or {}) do
        for spell, rec in pairs(data.recipes) do
            if rec.guess and not l.spells[spell] and rec.learn <= l.top and not (notes[spell] or {}).notAtTrainer then
                notes[spell] = { notAtTrainer = true, at = time() }
                changed = true
            end
        end
    end
    ns.db.trainer = notes
    if changed then
        Player.ApplyTrainerNotes()
        if ns.OnKnownChanged then ns.OnKnownChanged() end
    end
end

local trainer = CreateFrame("Frame")
for _, event in ipairs({ "TRAINER_SHOW", "TRAINER_UPDATE" }) do pcall(trainer.RegisterEvent, trainer, event) end
local trainerPending = false
trainer:SetScript("OnEvent", function()
    if trainerPending then return end
    trainerPending = true
    C_Timer.After(0.5, function()
        trainerPending = false
        readTrainer()
    end)
end)
