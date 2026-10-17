-- Craft Ladder: the button on the edge of the minimap. Click: the window; right-click: the ladder in chat; drag: move
-- it around the minimap. /craft minimap hides or shows it. It does nothing until clicked, hovered or dragged.
local _, ns = ...
local UI = ns.UI

local Mini = {}
ns.Minimap = Mini

local button

local function settings()
    ns.db.minimap = type(ns.db.minimap) == "table" and ns.db.minimap or { angle = 200, hide = false }
    return ns.db.minimap
end

-- Puts the button on the minimap's edge at its saved angle (a round minimap, or the edge of a square one).
local function position()
    local angle = math.rad(settings().angle or 200)
    local x, y = math.cos(angle), math.sin(angle)
    if GetMinimapShape and GetMinimapShape() == "SQUARE" then
        local d = math.max(math.abs(x), math.abs(y))
        x, y = x / d, y / d
    end
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x * (Minimap:GetWidth() / 2 + 5), y * (Minimap:GetHeight() / 2 + 5))
end

local function onDragUpdate()
    local mx, my = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    local atan2 = math.atan2 or math.atan
    settings().angle = math.deg(atan2(cy / scale - my, cx / scale - mx)) % 360
    position()
end

local function tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Craft Ladder", UI.C.gold[1], UI.C.gold[2], UI.C.gold[3])
    for _, data in ipairs(ns.Professions) do
        local skill, maxSkill = ns.Player.Skill(data)
        GameTooltip:AddDoubleLine(data.name, maxSkill > 0 and ("%d / %d"):format(skill, maxSkill) or "-", 1, 1, 1, 1, 1, 1)
    end
    -- the next step of the profession the window shows (the window's ladder while it's up to date, else one
    -- calculation, only while hovered)
    local data = ns.CurrentProfession()
    local _, maxSkill = ns.Player.Skill(data)
    if maxSkill > 0 then
        local ladder = ns.Window.Cached and ns.Window.Cached(data) or ns.Calculate(data)
        local step = ladder.steps[1]
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(data.name, UI.C.gold[1], UI.C.gold[2], UI.C.gold[3])
        if step and step.hour then
            GameTooltip:AddDoubleLine("Earns most", ("%s, %s an hour"):format(data.zones[step.zone].name,
                ns.Money(step.perHour)), 1, 1, 1, 1, 1, 1)
        elseif step and (step.kind == "fish" or step.kind == "mine") then
            local fish = step.kind == "fish"
            local g = data.gather or {}
            GameTooltip:AddDoubleLine("Now", ("%s in %s to %d"):format(fish and "fish" or (g.verb or "mine"):lower(),
                data.zones[step.zone].name,
                step.to), 1, 1, 1, 1, 1, 1)
            GameTooltip:AddDoubleLine(" ", ("~%d %s, %s"):format(math.ceil(step.crafts), fish and "catches" or (g.many or "nodes"),
                ns.Money(step.cost)), 1, 1, 1, 1, 1, 1)
        elseif step and step.kind == "craft" then
            local rec = data.recipes[step.recipe]
            GameTooltip:AddDoubleLine("Now", ("%s to %d"):format(rec.name, step.to), 1, 1, 1, 1, 1, 1)
            GameTooltip:AddDoubleLine(" ", ("~%d crafts, %s"):format(math.ceil(step.crafts), ns.Money(step.cost)), 1, 1, 1, 1, 1, 1)
        elseif step and step.kind == "food" then
            GameTooltip:AddDoubleLine("Eat", ("%s, %s"):format(data.recipes[step.recipe].name,
                ns.Describe.Buff(step.buff)), 1, 1, 1, 1, 1, 1)
        elseif step and step.kind == "profit" then
            GameTooltip:AddDoubleLine("Earns most", ("%s, +%s a craft"):format(data.recipes[step.recipe].name,
                ns.Money(step.profit)), 1, 1, 1, 1, 1, 1)
        elseif step then
            GameTooltip:AddDoubleLine("Now", (step.rank.how == "level" and "reach level " .. step.rank.charLevel
                or "learn " .. step.rank.name), 1, 1, 1, 1, 1, 1)
        end
        if #ladder.steps > 0 and step.kind ~= "profit" and step.kind ~= "food" and not step.hour then
            GameTooltip:AddDoubleLine(("Up to %d"):format(ladder.to), ns.Money(ladder.cost), 1, 1, 1, 1, 1, 1)
        end
    end
    local source, scanned = ns.Prices.Source()
    if scanned then
        GameTooltip:AddDoubleLine("Prices", ("%s, %s"):format(source, ns.Age(scanned)), 1, 1, 1, 0.7, 0.7, 0.7)
    end
    local nextScan = ns.Describe.NextScan()
    if nextScan then GameTooltip:AddLine(nextScan, 0.7, 0.7, 0.7) end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Click: open or close the window", 0.7, 0.7, 0.7)
    GameTooltip:AddLine("Right-click: the ladder in chat", 0.7, 0.7, 0.7)
    GameTooltip:AddLine("Drag: move the button", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

local function build()
    if button or not Minimap then return end
    button = CreateFrame("Button", "CraftLadderMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(Minimap:GetFrameLevel() + 8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")
    -- the game's usual minimap button look; its size depends on the client like every other minimap button
    local modern = AddonCompartmentFrame ~= nil
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(133971) -- Cooking's chicken leg
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetPoint("TOPLEFT")
    if modern then
        bg:SetSize(24, 24); bg:SetPoint("CENTER")
        icon:SetSize(18, 18); icon:SetPoint("CENTER")
        border:SetSize(50, 50)
    else
        bg:SetSize(20, 20); bg:SetPoint("TOPLEFT", 7, -5)
        icon:SetSize(17, 17); icon:SetPoint("TOPLEFT", 7, -6)
        border:SetSize(53, 53)
    end
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    button:SetScript("OnClick", function(_, mouse)
        if mouse == "RightButton" then ns.PrintLadder() else ns.Window.Toggle() end
    end)
    button:SetScript("OnEnter", tooltip)
    button:SetScript("OnLeave", UI.HideTooltip)
    button:SetScript("OnDragStart", function(self)
        UI.HideTooltip()
        self:SetScript("OnUpdate", onDragUpdate) -- only while dragging
    end)
    button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    button:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
    position()
    button:SetShown(not settings().hide)
end

function Mini.Toggle()
    local s = settings()
    s.hide = not s.hide
    if button then button:SetShown(not s.hide) end
    ns.Chat(s.hide and "minimap button hidden - /craft minimap shows it again." or "minimap button shown.")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    frame:UnregisterEvent("PLAYER_LOGIN")
    build()
end)
