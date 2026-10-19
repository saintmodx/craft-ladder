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

-- 10526 -> "1g 5s 26c" (coloured), -73 -> "-73c"
function ns.Money(copper)
    if not copper then return "|cff999999?|r" end
    copper = math.floor(copper + 0.5)
    local sign = copper < 0 and "-" or ""
    copper = math.abs(copper)
    local g, s, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = g .. "|cffffd700g|r" end
    if g > 0 or s > 0 then parts[#parts + 1] = s .. "|cffc7c7cfs|r" end
    parts[#parts + 1] = c .. "|cffeda55fc|r"
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

-- The mode a profession's ladder is planned in: a crafting profession that sells: Skill (only vendors buy what it
-- makes), Skill + Gold ("sell": the auction house too) or Gold (what earns most now, the default at 300 until you pick
-- another); a gathering one: Skill, Skill + Gold (level where it earns most) or Gold (the zones by gold an hour, the
-- default at 300). skill: the character's (looked up when not given).
function ns.LadderMode(data, skill)
    skill = skill or (ns.Player.Skill(data))
    return data.skillOnly and "skill" or ns.Player.Prof(data).mode
        or ((data.resale or data.kind) and skill >= 300 and "gold") or "skill"
end

-- Builds the ladder of one profession (the shown one by default) for this character. Returns the ladder, the price
-- lookup and how long it took (ms).
function ns.Calculate(data)
    data = data or ns.CurrentProfession()
    local start = debugprofilestop()
    local state = ns.Player.State(data)
    local quote, lookup = ns.Prices.ForGame()
    local saved = ns.Player.Prof(data)
    -- recipes you picked: forget the ones for stretches you've levelled past
    local choices = type(saved.choices) == "table" and saved.choices or {}
    if next(choices) and not choices[1] then choices = {} end -- an older format
    for i = #choices, 1, -1 do
        if choices[i].to <= state.skill then table.remove(choices, i) end
    end
    saved.choices = choices
    local fishing = data.kind == "fishing"
    local mode = ns.LadderMode(data, state.skill)
    if data.levelCaps then data.ranks = ns.Mining.LevelRanks(data, state) end -- Lockpicking: the cap is the level x 5
    local build = fishing and ns.Fishing.Build or data.kind == "mining" and ns.Mining.Build
        or data.resale and mode == "gold" and ns.Ladder.Profits or data.food and mode == "food" and ns.Ladder.Food
        or ns.Ladder.Build
    local opts = { favor = ns.db.favor, choices = choices, realPrices = ns.Prices.Real(),
                   rate = fishing and (ns.Fishing.Rate()) or nil, mode = mode,
                   seenPools = fishing and ns.Fishing.SeenPools(data) or nil,
                   smelt = data.smelt and { skill = (ns.Player.Skill(ns.MINING)), recipes = ns.MINING.recipes } or nil,
                   standing = ns.Player.Standing,
                   vendorOnly = data.resale and mode == "skill" or nil }
    local ladder = build(data, state, quote, opts)
    ladder.mode = mode
    ladder.state, ladder.data = state, data
    ladder.quote, ladder.opts = quote, opts -- the Merchant's Favor recipes plan their ingredients as the ladder does
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
-- Chat printout (/craft chat)
---------------------------------------------------------------------------------------------------------------

local COLORS = { orange = "|cffff8040", yellow = "|cffffff00", green = "|cff40c040", grey = "|cff808080" }

local function at(npc)
    local name, where = ns.Describe.NPC(npc)
    return name .. (where and (" (" .. where .. ")") or "")
end

local function buyText(lookup, buy)
    local parts = {}
    for item, b in pairs(buy) do
        local text = ("%d %s"):format(math.ceil(b.need), ns.Describe.ItemName(item))
        if b.have > 0 then text = text .. (" (you have %d)"):format(math.floor(b.have)) end
        if b.make and b.buy > 0 then
            local verb, bought = b.make.mining and "smelt" or "make", b.buy - b.make.made
            text = text .. ": " .. (bought > 1e-9 and ("%s %d yourself, buy %d"):format(verb, math.ceil(b.make.made),
                math.ceil(bought - 1e-9)) or (verb .. " yourself")) .. ", " .. ns.Money(b.cost)
        elseif b.buy > 0 then
            local e = lookup(item)
            if b.cost then
                text = text .. ": " .. ns.Money(b.cost)
                if e and e.source == "vendor" then text = text .. " at a vendor" end
                if b.short then text = text .. (" |cffff4040only %d listed|r"):format(e.qty) end
            else
                text = text .. ": |cffff4040no price|r"
            end
        end
        parts[#parts + 1] = text
    end
    return table.concat(parts, "; ")
end

local function rankHow(step, data)
    local rank = step.rank
    if rank.how == "book" then
        return "buy the " .. ns.Describe.ItemName(rank.item) .. (step.vendor and (" from " .. at(step.vendor)) or "")
    elseif rank.how == "quest" then
        local name, q = ns.Describe.Quest(step.quest)
        if step.startQuest then
            local startName, start = ns.Describe.Quest(step.startQuest)
            return "quest " .. name .. " - start with " .. startName ..
                (start and start.giver and (" from " .. at(start.giver)) or "")
        end
        return "quest " .. name .. (q and q.giver and (" from " .. at(q.giver)) or "")
    end
    return "any " .. data.name .. " trainer"
end

local function printLadder(data)
    local ladder, lookup, ms = ns.Calculate(data)
    data = ladder.data
    local state = ladder.state
    if state.maxSkill == 0 then
        chat(("you don't have %s yet - any %s trainer teaches it."):format(data.name, data.name))
        return
    end
    local source, scanned = ns.Prices.Source()
    chat(("%s %d -> %d. Prices: %s%s. (%.1f ms)"):format(data.name, ladder.from, ladder.to,
        source or "none - only vendor prices", scanned and (", scanned " .. ns.Age(scanned)) or "", ms))
    if not next(ns.Player.Prof(data).known) then
        chat(("|cffffd200Open your %s window once so Craft Ladder sees which recipes you know.|r"):format(data.name))
    end
    for i, s in ipairs(ladder.steps) do
        if s.hour then
            local g = data.gather or {}
            print(("  %s%s in %s|r: about %s an hour, ~%d %s an hour, %s a %s"):format(s.dangerous and COLORS.orange or "",
                s.kind == "fish" and "fish" or (g.verb or "mine"):lower(), data.zones[s.zone].name, ns.Money(s.perHour),
                s.crafts + 0.5, s.kind == "fish" and "catches" or (g.many or "nodes"), ns.Money(s.value),
                s.kind == "fish" and "catch" or (g.one or "node")))
        elseif s.kind == "rank" and s.rank.how == "level" then
            print(("  |cffffd200at %d: reach level %d|r (your cap, the level x 5, is then %d)%s"):format(s.from,
                s.rank.charLevel, s.rank.cap, s.needLevel and (" |cffff4040you're level " .. ladder.state.level .. "|r")
                or ""))
        elseif s.kind == "rank" then
            print(("  |cffffd200at %d: learn %s|r (up to %d) - %s, %s%s"):format(s.from, s.rank.name, s.rank.cap,
                rankHow(s, data), ns.Describe.Price(s.cost, s.guess),
                s.needLevel and (" |cffff4040needs level " .. s.needLevel .. "|r") or ""))
            if s.buy then print("      bring: " .. buyText(lookup, s.buy)) end
        elseif s.kind == "fish" then
            print(("  %d-%d fish in %s ~%d catches (~%d min), %s%s"):format(s.from, s.to, data.zones[s.zone].name,
                math.ceil(s.crafts), ns.Fishing.Minutes(s.casts) + 0.5, ns.Money(s.cost),
                s.landed < 1 and (" |cffff8040%d%% land|r"):format(s.landed * 100) or ""))
            if next(s.buy) then print("      bring: " .. buyText(lookup, s.buy)) end
        elseif s.kind == "food" then
            if #ladder.groups > 1 and (i == 1 or ladder.steps[i - 1].role ~= s.role) then -- a heading per role
                print(("  |cffffd200%s:|r"):format(s.role))
            end
            print(("  %s%s|r: %s, level %d - %s%s"):format(s.later and "|cff999999" or "", data.recipes[s.recipe].name,
                ns.Describe.Buff(s.buff), s.eat, s.cost and ("cook one for " .. ns.Money(s.cost)) or "no price",
                s.ah and (", buy one for " .. ns.Money(s.ah)) or ""))
        elseif s.kind == "profit" then
            if s.vendor and i == 1 then print("  |cffffd200Sell to a vendor:|r") end
            if i == ladder.vendorRows + 1 then print("  |cffffd200Sell at the auction house:|r") end
            print(("  %s%s|r%s: one craft costs %s, sells for about %s - |cff40c040+%s|r (%s)%s"):format(
                s.color ~= "grey" and COLORS[s.color] or "", data.recipes[s.recipe].name, s.made > 1 and (" x" .. s.made) or "", ns.Money(s.cost), ns.Money(s.back),
                ns.Money(s.profit), s.vendor and "at a vendor" or (s.listed .. " listed"), s.payback and
                (", learn it for %s: pays back after %d %s"):format(ns.Money(s.learn.cost), s.payback,
                    s.payback == 1 and "craft" or "crafts") or ""))
        elseif s.kind == "mine" then
            local bars = {}
            for spell, n in pairs(s.bars) do bars[#bars + 1] = ("%d %s"):format(n + 0.5, data.recipes[spell].name) end
            local g = data.gather or {}
            print(("  %d-%d %s in %s ~%d %s, %s%s"):format(s.from, s.to, (g.verb or "mine"):lower(), data.zones[s.zone].name,
                math.ceil(s.crafts), g.many or "nodes",
                ns.Money(s.cost), #bars > 0 and (" - smelt on the way: " .. table.concat(bars, ", ")) or ""))
        else
            local rec = data.recipes[s.recipe]
            local learn = ns.Describe.Learn(s.learn, data)
            if s.learn.kind == "vendor" then
                learn = "buy from " .. at(s.learn.npc) .. ", " .. ns.Describe.Price(s.learn.cost, s.learn.guess)
            end
            print(("  %d-%d %s%s|r ~%d crafts, %s - %s%s"):format(s.from, s.to, COLORS[s.color] or "", rec.name,
                math.ceil(s.crafts), ns.Money(s.cost), learn,
                ns.Describe.Unconfirmed(rec, s.learn) and " |cff999999(unconfirmed)|r" or ""))
            print("      " .. buyText(lookup, s.buy) .. (s.tool and " - a tool: keep it" or ""))
            for item, k in pairs(s.keep or {}) do
                print(("      keep %d %s for %d-%d"):format(k.n + 0.5, ns.Describe.ItemName(item), k.from, k.to))
            end
            if s.sale then
                print(("      sell: %d at the auction house, %d to a vendor - about %s back"):format(s.sale.ah + 0.5,
                    s.sale.vendor + 0.5, ns.Money(s.sale.total)))
            end
        end
    end
    if ladder.mode == "food" then
        chat(("food for your class, %d dishes (grey: above your level)."):format(#ladder.steps))
        return
    elseif ladder.steps[1] and ladder.steps[1].kind == "profit" then
        chat(("%d sell to a vendor for more than they cost, %d earn at the auction house (per craft, at today's" ..
            " prices)."):format(ladder.vendorRows, #ladder.steps - ladder.vendorRows))
        return
    elseif data.resale and ladder.mode == "gold" then
        chat("nothing you can make earns at today's prices.")
        return
    elseif ladder.mode == "gold" then
        chat(#ladder.steps > 0 and ("%d zones by gold an hour at %d, at today's prices."):format(#ladder.steps,
            ladder.from) or "nothing you can gather here has a price.")
        return
    end
    chat(("total %s%s, ~%d %s%s"):format(ns.Money(ladder.cost),
        (ladder.back or 0) > 0 and (", about " .. ns.Money(ladder.back) .. " back from sales") or "",
        math.ceil(ladder.nodes or ladder.crafts),
        ladder.minutes and "catches" or ladder.nodes and (data.gather and data.gather.many or "nodes") or "crafts",
        ladder.stuck and ladder.stuck ~= "cap" and (" |cffff4040- stopped: " .. ladder.stuck .. "|r") or ""))
end
ns.PrintLadder = printLadder

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
    local chatFor = msg:match("^chat%s*(.*)$")
    if msg == "" then
        ns.Window.Toggle()
    elseif chatFor then
        printLadder(professionNamed(chatFor))
    elseif msg == "status" then
        status()
    elseif msg == "minimap" then
        ns.Minimap.Toggle()
    elseif professionNamed(msg) then
        ns.SetProfession(professionNamed(msg))
        ns.Window.Open()
    else
        local names = {}
        for _, data in ipairs(ns.Professions) do names[#names + 1] = "/craft " .. data.name:lower() end
        chat("/craft - open or close the window; " .. table.concat(names, ", ") .. " - open it on that profession;" ..
            " /craft chat - the ladder in chat; /craft minimap - hide or show the minimap button; /craft status." ..
            " /chef works too.")
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
