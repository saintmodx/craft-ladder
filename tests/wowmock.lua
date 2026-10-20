-- A small stand-in for the game's API, enough to load Craft Ladder and run its code outside the game.
-- Frames remember size, shown state, text, scripts and children; any other method does nothing, so a test catches
-- script errors in the addon's code but says nothing about how the window looks.
local M = { frames = {}, timers = {}, output = {}, waypoints = {}, window = "cooking", trainer = {} }

local Methods = {}
local Widget = { __index = function(_, k) return Methods[k] or function() end end }

-- Every field the stand-in reads is set here: a missing field would read as a do-nothing method.
local function new(kind, parent, name)
    local w = setmetatable({ kind = kind, shown = true, scripts = {}, children = {}, events = {}, width = 0, height = 0,
                             text = "", level = parent and rawget(parent, "level") + 1 or 0, name = name or false,
                             parent = false, disabled = false, vscroll = 0 }, Widget)
    if parent then
        w.parent = parent
        parent.children[#parent.children + 1] = w
    end
    if name then _G[name] = w end
    return w
end
M.new = new

function Methods:CreateTexture() return new("Texture", self) end
function Methods:CreateFontString() return new("FontString", self) end
function Methods:SetScript(name, fn) self.scripts[name] = fn end
function Methods:GetScript(name) return self.scripts[name] end
function Methods:HookScript(name, fn)
    local old = self.scripts[name]
    self.scripts[name] = function(...) if old then old(...) end fn(...) end
end
function Methods:RegisterEvent(e) self.events[e] = true end
function Methods:UnregisterEvent(e) self.events[e] = nil end
function Methods:UnregisterAllEvents() self.events = {} end
function Methods:IsShown() return self.shown end
function Methods:IsVisible()
    local w = self
    while w do
        if not w.shown then return false end
        w = w.parent
    end
    return true
end
function Methods:Show()
    if not self.shown then
        self.shown = true
        if self.scripts.OnShow then self.scripts.OnShow(self) end
    end
end
function Methods:Hide()
    if self.shown then
        self.shown = false
        if self.scripts.OnHide then self.scripts.OnHide(self) end
    end
end
function Methods:SetShown(v) if v then self:Show() else self:Hide() end end
function Methods:SetParent(p)
    if self.parent == p then return end
    if self.parent then
        for i, c in ipairs(self.parent.children) do
            if c == self then table.remove(self.parent.children, i); break end
        end
    end
    self.parent = p
    if p then p.children[#p.children + 1] = self end
end
function Methods:GetParent() return self.parent end
function Methods:SetSize(w, h) self.width, self.height = w, h end
function Methods:SetWidth(w) self.width = w end
function Methods:SetHeight(h) self.height = h end
function Methods:GetWidth() return self.width end
function Methods:GetHeight() return self.height end
function Methods:GetFrameLevel() return self.level end
function Methods:SetFrameLevel(l) self.level = l end
function Methods:GetPoint() return "CENTER", nil, "CENTER", 0, 0 end
function Methods:SetPoint(...) self.point = { ... } end -- the last anchor, for tests that check a layout
function Methods:IsMouseOver() return false end
function Methods:IsEnabled() return not self.disabled end
function Methods:Enable() self.disabled = false end
function Methods:Disable() self.disabled = true end
function Methods:SetEnabled(on) self.disabled = not on end
function Methods:SetText(t) self.text = t or "" end
function Methods:GetText() return self.text end
function Methods:GetStringHeight() return 14 end
function Methods:GetStringWidth() return #self.text * 6 end
function Methods:SetVerticalScroll(v) self.vscroll = v end
function Methods:GetVerticalScroll() return self.vscroll end
function Methods:SetScrollChild(c) self.scrollChild = c end
function Methods:GetCenter() return 100, 100 end
function Methods:GetLeft() return 300 end
function Methods:GetTop() return 900 end
function Methods:SetScale(s) self.scale = s end
function Methods:GetScale() return rawget(self, "scale") or 1 end
function Methods:GetEffectiveScale() return 1 end
function Methods:SetOwner() self.tipItem, self.tipSpell = nil, nil end
function Methods:SetItemByID(id) self.tipItem = id end
function Methods:SetSpellByID(id) self.tipSpell = id end
function Methods:SetTexture(t) self.texture = t end
function Methods:SetVertexColor(r, g, b, a) self.color = { r, g, b, a } end
function Methods:SetTextColor(r, g, b, a) self.color = { r, g, b, a } end

function M.click(w, button)
    assert(w.scripts.OnClick, "nothing to click")
    w.scripts.OnClick(w, button or "LeftButton")
end

-- Shown children of a frame that have field `key` (pooled rows carry their data in fields).
function M.shownChildren(parent, key)
    local out = {}
    for _, c in ipairs(parent.children) do
        if c.shown and (not key or rawget(c, key) ~= nil) then out[#out + 1] = c end
    end
    return out
end

function M.fire(event, ...)
    for _, f in ipairs(M.frames) do
        if f.events[event] and f.scripts.OnEvent then f.scripts.OnEvent(f, event, ...) end
    end
end

function M.runTimers()
    local n = 0
    while #M.timers > 0 do
        table.remove(M.timers, 1)()
        n = n + 1
        assert(n < 1000, "timers keep adding timers")
    end
end

-- Installs the globals. fx = a Cooking fixture (tests/make_fixture.lua); fx.firstaid, fx.fishing, fx.mining,
-- fx.blacksmithing and fx.engineering = one of those, or none (no Mining, Blacksmithing or Engineering unless given). M.window = the profession whose window is open; M.trainer = the trainer's services
-- { name, skillName, skill, cost }; M.fishingLoot = the loot window shows a catch; M.mainHand = the item in the hand.
function M.install(fx, ns)
    local fa = fx.firstaid or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local fi = fx.fishing or { skill = 78, maxSkill = 150, known = {}, owned = {}, ah = {} }
    fx.mining = fx.mining or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local mi = fx.mining
    fx.blacksmithing = fx.blacksmithing or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local bs = fx.blacksmithing
    local en = fx.engineering or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    fx.tailoring = fx.tailoring or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} } -- a test may give it later
    local ta = fx.tailoring
    fx.enchanting = fx.enchanting or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local ec = fx.enchanting
    fx.alchemy = fx.alchemy or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local al = fx.alchemy
    fx.skinning = fx.skinning or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local sn = fx.skinning
    fx.herbalism = fx.herbalism or { skill = 0, maxSkill = 0, known = {}, owned = {}, ah = {} }
    local hb = fx.herbalism
    function CreateFrame(kind, name, parent)
        local f = new(kind, parent, name)
        M.frames[#M.frames + 1] = f
        return f
    end
    UIParent = new("Frame", nil, "UIParent")
    UIParent:SetSize(1920, 1080) -- the screen, in the UI's units
    GameTooltip = new("GameTooltip", UIParent, "GameTooltip")
    Minimap = new("Minimap", UIParent, "Minimap")
    Minimap:SetSize(140, 140)
    AddonCompartmentFrame = new("Frame", UIParent, "AddonCompartmentFrame")
    M.cursor = { 0, 0 }
    GetCursorPosition = function() return M.cursor[1], M.cursor[2] end
    GetMinimapShape = function() return "ROUND" end
    UISpecialFrames = {}
    STANDARD_TEXT_FONT = "Fonts\\FRIZQT__.TTF"
    tinsert = table.insert
    wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
    M.tickers = {}
    C_Timer = {
        After = function(_, fn) M.timers[#M.timers + 1] = fn end,
        NewTicker = function(_, fn)
            local t = { fn = fn, cancelled = false }
            function t:Cancel() self.cancelled = true end
            M.tickers[#M.tickers + 1] = t
            return t
        end,
    }
    date = os.date
    -- Forever: characters have surnames, and Bagnon keeps their bank under "forever" / "Name Surname"
    WOW_PROJECT_ID = 18
    NUM_TOTAL_EQUIPPED_BAG_SLOTS = 5
    UnitFullName = function() return fx.name, "Test" end
    BrotherBags = { forever = { [fx.name .. " Test"] = fx.bagnon or {} } }
    function print(...)
        local line = table.concat({ ... }, " "):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        M.output[#M.output + 1] = line
        if M.echo then io.write(line, "\n") end
    end
    debugprofilestop = function() return os.clock() * 1000 end
    time = os.time
    SlashCmdList = {}
    IsShiftKeyDown = function() return false end
    IsControlKeyDown = function() return M.ctrl or false end
    UnitFactionGroup = function() return fx.faction == "A" and "Alliance" or "Horde" end
    UnitLevel = function() return fx.level end
    -- a warrior by default; Lockpicking's tests make it a rogue (its skill is in the skill list, not a profession)
    M.class, M.race, M.lockpicking, M.poisons = "WARRIOR", "Orc", { skill = 0, maxSkill = 0 }, { skill = 0, maxSkill = 0 }
    UnitClass = function() return M.class, M.class end
    UnitRace = function() return M.race, M.race end
    GetNumSkillLines = function() return 2 end
    GetSkillLineInfo = function(i)
        local name, s = unpack(i == 1 and { "Lockpicking", M.lockpicking } or { "Poisons", M.poisons })
        return name, false, nil, s.skill, nil, nil, s.maxSkill
    end
    UnitGUID = function() return "Player-TEST" end
    UnitName = function() return fx.name end
    GetRealmName = function() return "Test" end
    -- Forever: fishing, cooking and first aid after the two main professions (Mining, Blacksmithing here) and
    -- archaeology (a third main profession here, Engineering, which no real character has)
    GetProfessions = function()
        return mi.maxSkill > 0 and 1 or nil, bs.maxSkill > 0 and 2 or nil, en.maxSkill > 0 and 3 or nil, 4, 5,
            fa.maxSkill > 0 and 6 or nil, ta.maxSkill > 0 and 7 or nil, ec.maxSkill > 0 and 8 or nil,
            al.maxSkill > 0 and 9 or nil, sn.maxSkill > 0 and 10 or nil,
            hb.maxSkill > 0 and 11 or nil
    end
    GetProfessionInfo = function(i)
        if i == 1 then return "Mining", 136248, mi.skill, mi.maxSkill, 0, 0, 186 end
        if i == 2 then return "Blacksmithing", 136241, bs.skill, bs.maxSkill, 0, 0, 164 end
        if i == 3 then return "Engineering", 136243, en.skill, en.maxSkill, 0, 0, 202 end
        if i == 7 then return "Tailoring", 136249, ta.skill, ta.maxSkill, 0, 0, 197 end
        if i == 8 then return "Enchanting", 136244, ec.skill, ec.maxSkill, 0, 0, 333 end
        if i == 9 then return "Alchemy", 136240, al.skill, al.maxSkill, 0, 0, 171 end
        if i == 10 then return "Skinning", 134366, sn.skill, sn.maxSkill, 0, 0, 393 end
        if i == 11 then return "Herbalism", 136246, hb.skill, hb.maxSkill, 0, 0, 182 end
        if i == 5 then return "Cooking", 133971, fx.skill, fx.maxSkill, 0, 0, 185 end
        if i == 6 then return "First Aid", 135966, fa.skill, fa.maxSkill, 0, 0, 129 end
        return "Fishing", 136245, fi.skill, fi.maxSkill, 0, 0, 356
    end
    C_Spell = { GetSpellName = function(id)
        return ({ [2550] = "Cooking", [3273] = "First Aid", [7620] = "Fishing", [2575] = "Mining",
                  [2018] = "Blacksmithing", [4036] = "Engineering", [3908] = "Tailoring",
                  [7411] = "Enchanting", [2259] = "Alchemy", [8613] = "Skinning", [2366] = "Herbalism" })[id]
    end }
    -- the game may not report recipes as spells: the window must; M.spells = the spells it does report
    -- (specializations)
    M.spells = {}
    IsPlayerSpell = function(id) return M.spells[id] or false end
    M.questsDone, M.questLog = {}, {} -- [quest] = true; [quest] = its index in the quest log
    C_QuestLog = {
        IsQuestFlaggedCompleted = function(q) return M.questsDone[q] or false end,
        GetLogIndexForQuestID = function(q) return M.questLog[q] end,
    }
    C_Item = {
        GetItemCount = function(item) -- no bank seen
            return fx.owned[item] or fa.owned[item] or fi.owned[item] or fx.mining.owned[item] or bs.owned[item]
                or en.owned[item] or 0
        end,
        GetItemIconByID = function() return 134400 end,
    }
    GetInventoryItemID = function() return M.mainHand end
    IsFishingLoot = function() return M.fishingLoot or false end
    C_TradeSkillUI = {
        GetAllRecipeIDs = function()
            local ids = {}
            for id in pairs(ns.ProfessionByKey[M.window].recipes) do ids[#ids + 1] = id end
            return ids
        end,
        GetRecipeInfo = function(id)
            return { learned = fx.known[id] or fa.known[id] or mi.known[id] or bs.known[id] or en.known[id] or false }
        end,
    }
    local items = {}
    for item, e in pairs(en.ah) do items[item] = { e } end -- first: the others' prices win
    for item, e in pairs(fi.ah) do items[item] = { e } end
    for item, e in pairs(mi.ah) do items[item] = { e } end
    for item, e in pairs(bs.ah) do items[item] = { e } end
    for item, e in pairs(fa.ah) do items[item] = { e } end
    for item, e in pairs(fx.ah) do items[item] = { e } end
    AuctionDB = {
        sv = { houses = { [UnitFactionGroup()] = { items = items, scans = { { fx.scanTs, 0, 0 } } } } },
        LastPrice = function(self, item, house)
            local h = self.sv.houses[house].items[item]
            return h and h[#h]
        end,
        PlayerHouse = function() return UnitFactionGroup() end,
        ScanCooldownLeft = function() return M.scanCooldown or 0 end,
    }
    GetMerchantNumItems = function() return 1 end
    GetMerchantItemID = function() return 2678 end                      -- Mild Spices
    GetMerchantItemInfo = function() return "Mild Spices", 0, 10, 5 end -- 10c for 5
    GetNumTrainerServices = function() return #M.trainer end
    GetTrainerServiceInfo = function(i) return M.trainer[i].name, "", "available" end
    GetTrainerServiceSkillReq = function(i) return M.trainer[i].skillName, M.trainer[i].skill, true end
    GetTrainerServiceCost = function(i) return M.trainer[i].cost end
    UiMapPoint = { CreateFromCoordinates = function(map, x, y) return { map = map, x = x, y = y } end }
    C_Map = {
        CanSetUserWaypointOnMap = function() return true end,
        SetUserWaypoint = function(p) M.waypoints[#M.waypoints + 1] = p end,
    }
    C_SuperTrack = { SetSuperTrackedUserWaypoint = function() end }
end

-- Loads the addon's files in .toc order.
function M.load(root, ns)
    local toc = assert(io.open(root .. "CraftLadder/CraftLadder.toc")):read("*a")
    for file in toc:gmatch("\n([%w_\\/]+%.lua)") do
        assert(loadfile(root .. "CraftLadder/" .. file:gsub("\\", "/")))("CraftLadder", ns)
    end
end

return M
