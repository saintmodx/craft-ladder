-- Craft Ladder: events, saved settings, which profession is shown, and the /craft (or /chef) command.
local ADDON, ns = ...

local function chat(text) print("|cffffb347Craft Ladder:|r " .. text) end
ns.Chat = chat

local DEFAULTS = { favor = false }

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name == ADDON then
        CraftLadderDB = type(CraftLadderDB) == "table" and CraftLadderDB or {}
        for k, v in pairs(DEFAULTS) do
            if CraftLadderDB[k] == nil then CraftLadderDB[k] = v end
        end
        ns.db = CraftLadderDB
        -- real vendor prices used to be shared by the account or a faction; now each character keeps its own (the old
        -- ones can't say whose reputation discount they carry)
        CraftLadderDB.vendorPrices = nil
        -- quartermasters' prices were briefly saved under favor, the "Merchant's Favor recipes" box's own setting
        if type(CraftLadderDB.favor) == "table" then
            CraftLadderDB.favorPrices, CraftLadderDB.favor = CraftLadderDB.favor, false
        end
        ns.Player.ApplyTrainerNotes()
        ns.Mining.ApplySkinLog(ns.SKINNING) -- creatures you skinned that Classic's data doesn't have
        frame:UnregisterEvent("ADDON_LOADED")
    end
end)

-- the game's coins, as its tooltips and the auction house show money: an icon the height of the text after the amount
local GOLD = "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
local SILVER = "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t"
local COPPER = "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"

-- 10526 -> "1g 5s 26c" (with coin icons), -73 -> "-73c"
function ns.Money(copper)
    if not copper then return "|cff999999?|r" end
    copper = math.floor(copper + 0.5)
    local sign = copper < 0 and "-" or ""
    copper = math.abs(copper)
    local g, s, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = g .. GOLD end
    if g > 0 or s > 0 then parts[#parts + 1] = s .. SILVER end
    parts[#parts + 1] = c .. COPPER
    return sign .. table.concat(parts, " ")
end

-- "3h ago", "2d ago"
function ns.Age(ts)
    if not ts then return "never" end
    local s = math.max(0, time() - ts)
    if s < 3600 then return math.floor(s / 60) .. "m ago" end
    if s < 86400 then return math.floor(s / 3600) .. "h ago" end
    return math.floor(s / 86400) .. "d ago"
end

-- The profession the window shows for this character: the one picked last, else the first one they're levelling.
function ns.CurrentProfession()
    local picked = ns.ProfessionByKey[ns.Player.Saved().tab or ""]
    if picked then return picked end
    for _, data in ipairs(ns.Professions) do
        local skill, maxSkill = ns.Player.Skill(data)
        if maxSkill > 0 and skill < 300 then return data end
    end
    return ns.Professions[1]
end

function ns.SetProfession(data)
    ns.Player.Saved().tab = data.key
end

-- The mode a profession's ladder is planned in: a crafting profession that sells: Vendor sales ("skill": only vendors buy
-- what it makes), AH sales ("sell": the auction house too) or Profit ("gold": what earns most now, the default at 300
-- until you pick another); a gathering one: Skill, AH sales (level where it earns most) or Profit (the zones by gold
-- an hour, the default at 300). skill: the character's (looked up when not given).
function ns.LadderMode(data, skill)
    skill = skill or (ns.Player.Skill(data))
    local mode = ns.Player.Prof(data).mode
    -- at 300 there's nothing left to level, so Vendor sales and AH sales are hidden: a mode picked earlier isn't kept
    if skill >= 300 and (mode == "skill" or mode == "sell") then mode = nil end
    return data.skillOnly and "skill" or mode
        or ((data.resale or data.kind) and skill >= 300 and "gold") or "skill"
end

local function smeltFor(data)
    return data.smelt and { skill = (ns.Player.Skill(ns.MINING)), recipes = ns.MINING.recipes } or nil
end

-- The Disenchant view looks at what a character's crafting professions make: each one's data, its state and the bars
-- it may smelt. The shown character's (Player.viewing), so the caller sets that first.
local function craftingProfessions()
    local list = {}
    for _, data in ipairs(ns.Professions) do
        if data.resale and not data.secondary and select(2, ns.Player.Skill(data)) > 0 then
            list[#list + 1] = { data = data, state = ns.Player.State(data), smelt = smeltFor(data) }
        end
    end
    return list
end

-- The recipe each ladder's first step is on, per profession, mode and picked range, for this session only: it keeps
-- the step the player is crafting from being swapped under them by a craft or a new scan (Ladder.Build's opts.sticky).
-- Yours only: another character's view is read-only, and nothing is crafted there.
local onNow = {}

-- Builds the ladder of one profession (the shown one by default) for this character. Returns the ladder, the price
-- lookup and how long it took (ms).
function ns.Calculate(data)
    data = data or ns.CurrentProfession()
    local start = debugprofilestop()
    local state = ns.Player.State(data)
    ns.Ladder.overtime = state.overtime
    local quote, lookup = ns.Prices.ForGame()
    local saved = ns.Player.Prof(data)
    -- recipes you picked: forget the ones for stretches you've levelled past
    local choices = type(saved.choices) == "table" and saved.choices or {}
    if next(choices) and not choices[1] then choices = {} end -- an older format
    for i = #choices, 1, -1 do
        if choices[i].to <= state.skill then table.remove(choices, i) end
    end
    saved.choices = choices
    -- the range picked (the window's From / To, until Reset): planned from its start as if you had reached it, with
    -- the rank that skill needs (Lockpicking's From is always yours: its cap is the level's)
    local range = saved.range
    if range then
        state.target = range.to or 300
        if range.from and range.from > state.skill and not data.levelCaps then
            state.from, state.fromCap = range.from, state.maxSkill
            for _, r in ipairs(data.ranks) do
                if r.cap >= range.from then state.fromCap = math.max(state.maxSkill, r.cap); break end
            end
        end
    end
    local fishing = data.kind == "fishing"
    local mode = ns.LadderMode(data, state.skill)
    if data.levelCaps then data.ranks = ns.Mining.LevelRanks(data, state) end -- Lockpicking: the cap is the level x 5
    local build = fishing and ns.Fishing.Build or data.kind == "mining" and ns.Mining.Build
        or data.resale and mode == "gold" and ns.Ladder.Profits or data.food and mode == "food" and ns.Ladder.Food
        or ns.Ladder.Build
    local stickyKey = not ns.Player.viewing
        and table.concat({ data.key, mode, tostring(range and range.from), tostring(range and range.to) }, ":")
    local opts = { favor = ns.db.favor, choices = choices, realPrices = ns.Prices.Real(),
                   sticky = stickyKey and onNow[stickyKey] or nil,
                   rate = fishing and (ns.Fishing.Rate()) or nil, mode = mode,
                   seenPools = fishing and ns.Fishing.SeenPools(data) or nil,
                   smelt = smeltFor(data),
                   standing = ns.Player.Standing,
                   vendorOnly = data.resale and mode == "skill" or nil }
    local ladder = build(data, state, quote, opts)
    if stickyKey then -- the step being crafted now, for the next calculation (a tool is made once: it isn't one)
        onNow[stickyKey] = nil
        for _, s in ipairs(ladder.steps or {}) do
            if s.kind == "craft" and not s.tool then onNow[stickyKey] = s.recipe; break end
        end
    end
    ladder.mode = mode
    ladder.state, ladder.data = state, data
    ladder.quote, ladder.opts = quote, opts -- the Merchant's Favor recipes plan their ingredients as the ladder does
    return ladder, lookup, debugprofilestop() - start
end

-- The menu's Disenchant view: the whole account's, so it reads every character (through Player.viewing) and hands
-- Disenchant.Account what it found, which then does the arithmetic. Returns what ns.Calculate does.
function ns.CalculateDisenchant()
    local start = debugprofilestop()
    local was = ns.Player.viewing
    ns.Player.viewing = nil
    local quote, lookup = ns.Prices.ForGame()
    local chars, bags = {}, nil
    for i, c in ipairs(ns.Player.Chars()) do
        ns.Player.viewing = i > 1 and c.guid or nil
        chars[#chars + 1] = { name = c.me.name, live = i == 1 or nil, bags = i > 1 and c.me.bags or nil,
                              bank = ns.Player.Bank(c.me, i == 1), crafts = craftingProfessions() }
        if i == 1 then bags = ns.Disenchant.Bags() end -- yours from the game: it knows what's bound
    end
    ns.Player.viewing = nil
    local opts = { chars = chars, bags = bags, bucketOf = ns.Disenchant.BucketOf, auction = true,
                   realPrices = ns.Prices.Real(), standing = ns.Player.Standing,
                   enchanters = ns.Disenchant.Enchanters(ns.ENCHANTING) }
    opts.seen, opts.seenItems = ns.Disenchant.Seen(ns.db.disenchantLog, ns.Disenchant.BucketOf)
    local ladder = ns.Disenchant.Account(quote, opts)
    -- the cards and the menu ask a profession for its name, icon and recipes: Enchanting's, whoever is shown
    ladder.data, ladder.state = ns.ENCHANTING, ns.Player.State(ns.ENCHANTING)
    ladder.quote, ladder.opts = quote, opts
    ns.Player.viewing = was
    return ladder, lookup, debugprofilestop() - start
end

-- A profession's window showed new recipes, or a trainer told the real skills: the ladder changes.
function ns.OnKnownChanged()
    if ns.Window and ns.Window.IsShown() then
        ns.Window.Refresh()
    elseif ns.Window and ns.Window.Invalidate then
        ns.Window.Invalidate() -- calculated again when it opens
    end
end

---------------------------------------------------------------------------------------------------------------
-- The /craft command
---------------------------------------------------------------------------------------------------------------

local function status()
    local source, scanned = ns.Prices.Source()
    for _, data in ipairs(ns.Professions) do
        local n, known = 0, 0
        for _ in pairs(data.recipes) do n = n + 1 end
        for _ in pairs(ns.Player.Known(data)) do known = known + 1 end
        local skill, maxSkill = ns.Player.Skill(data)
        local guessed, dropped = 0, 0
        for _, rec in pairs(data.recipes) do
            if rec.guess then guessed = guessed + 1 end
            if rec.notAtTrainer then dropped = dropped + 1 end
        end
        chat(("%s: data %s, %d recipes; skill %d/%d, %d recipes known.%s"):format(data.name, data.built, n, skill,
            maxSkill, known, guessed > 0 and (" %d recipes guessed as a trainer's (%d not at your trainer)."):format(
                guessed, dropped) or ""))
    end
    chat(("Prices: %s%s.%s"):format(source or "none", scanned and (" (scanned " .. ns.Age(scanned) .. ")") or "",
        ns.lastCalcMs and (" Last calculation: %.1f ms."):format(ns.lastCalcMs) or ""))
end

-- "first aid", "firstaid", "cooking" -> that profession's data
local function professionNamed(text)
    text = text:gsub("%s+", "")
    for _, data in ipairs(ns.Professions) do
        if data.key == text or data.name:lower():gsub("%s+", "") == text then return data end
    end
end

SLASH_CRAFTLADDER1 = "/craft"
SLASH_CRAFTLADDER2 = "/chef"
SlashCmdList.CRAFTLADDER = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "" then
        ns.Window.Toggle()
    elseif msg == "status" then
        status()
    elseif msg == "minimap" then
        ns.Minimap.Toggle()
    elseif msg == "disenchant" then
        ns.Player.viewing = nil -- the view is the account's: yourself again
        ns.Player.Me().tab = "disenchant"
        ns.Window.Open()
    elseif professionNamed(msg) then
        ns.SetProfession(professionNamed(msg))
        ns.Window.Open()
    else
        local names = {}
        for _, data in ipairs(ns.Professions) do names[#names + 1] = "/craft " .. data.name:lower() end
        chat("/craft - open or close the window; " .. table.concat(names, ", ") .. " - open it on that profession;" ..
            " /craft disenchant - what's worth disenchanting on your account; /craft minimap - hide or show the" ..
            " minimap button; /craft status. /chef works too.")
    end
end

function CraftLadder_OnCompartmentClick()
    ns.Window.Toggle()
end

function CraftLadder_OnCompartmentEnter(_, button)
    GameTooltip:SetOwner(button or UIParent, "ANCHOR_LEFT")
    GameTooltip:AddLine("Craft Ladder", 1, 0.82, 0.35)
    GameTooltip:AddLine("The cheapest way to level Cooking, First Aid and the crafting professions, and where to level" ..
        " the gathering ones.", 1, 1, 1)
    GameTooltip:AddLine("Click to open or close.", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

function CraftLadder_OnCompartmentLeave()
    GameTooltip:Hide()
end
