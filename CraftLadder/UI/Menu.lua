-- Craft Ladder: the main window's menu (left): the character's professions by group (main, secondary, a rogue's
-- class skills), each with its skill (the bar: the way to 300); at the bottom, Camp (the buffs a campfire gives).
-- UI/Window.lua builds it and draws it again.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local Window = ns.Window

local Menu = {}
ns.Menu = Menu

local MENU_W = Window.Shared.MENU_W

local MENU_GROUPS = {
    { title = "PROFESSIONS", has = function(d) return not d.secondary and not d.class end },
    { title = "SECONDARY", has = function(d) return d.secondary end },
    { title = "CLASS", has = function(d) return d.class ~= nil end }, -- a rogue's Lockpicking and Poisons
}
local ENTRY_BAR = 36 -- leaves room for "141 / 225" inside the entry

local function paintEntry(e)
    if e.active then
        e:SetPanelColors(C.hover, C.selected)
    else
        e:SetPanelColors(e:IsMouseOver() and C.hover or C.panel2, e:IsMouseOver() and C.hover or C.panel2)
    end
    UI.SetColor(e.name, e.active and C.gold or C.text)
end

local function makeMenuEntry(parent, data)
    local e = CreateFrame("Button", nil, parent)
    e:SetSize(MENU_W - 12, 40)
    UI.Panel(e, C.panel2, C.panel2, 6, -4)
    e.icon = e:CreateTexture(nil, "ARTWORK")
    e.icon:SetSize(24, 24)
    e.icon:SetPoint("LEFT", 8, 0)
    e.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    e.icon:SetTexture(data.icon)
    e.name = UI.Label(e, 12)
    e.name:SetPoint("TOPLEFT", e.icon, "TOPRIGHT", 8, 2)
    e.name:SetText(data.name)
    e.bar = e:CreateTexture(nil, "ARTWORK")
    e.bar:SetSize(ENTRY_BAR, 4)
    e.bar:SetPoint("BOTTOMLEFT", e.icon, "BOTTOMRIGHT", 8, 2)
    e.bar:SetColorTexture(C.edge[1], C.edge[2], C.edge[3], 1)
    e.fill = e:CreateTexture(nil, "OVERLAY")
    e.fill:SetHeight(4)
    e.fill:SetPoint("LEFT", e.bar, "LEFT")
    e.fill:SetColorTexture(C.gold[1], C.gold[2], C.gold[3], 1)
    e.skill = UI.Label(e, 10, C.muted)
    e.skill:SetPoint("LEFT", e.bar, "RIGHT", 5, 0)
    e.data = data
    e.tooltip = { data.name, ("Show the %s ladder."):format(data.name) }
    e:SetScript("OnEnter", function(self)
        paintEntry(self)
        UI.Tooltip(self, self.tooltip)
    end)
    e:SetScript("OnLeave", function(self)
        paintEntry(self)
        UI.HideTooltip()
    end)
    e:SetScript("OnClick", function()
        ns.SetProfession(data)
        Window.Refresh(true) -- a profession looked at before: drawn again
    end)
    return e
end

-- Shows the professions the character has (a rogue's class skills even before learning them), by group, the one
-- shown picked. Returns how many it shows.
function Menu.Render(frame, prof)
    local menu, class = frame.menu, UnitClass and select(2, UnitClass("player"))
    for _, h in ipairs(menu.heads) do h:Hide() end
    for _, e in ipairs(menu.entries) do e:Hide() end
    local y, n = -10, 0
    for g, group in ipairs(MENU_GROUPS) do
        local first = true
        for _, e in ipairs(menu.entries) do
            local skill, maxSkill = ns.Player.Skill(e.data)
            if group.has(e.data) and (maxSkill > 0 or e.data.class ~= nil and e.data.class == class) then
                if first then
                    menu.heads[g]:SetPoint("TOPLEFT", 12, y)
                    menu.heads[g]:Show()
                    y, first = y - 16, false
                end
                e:SetPoint("TOPLEFT", 6, y)
                e:Show()
                e.skill:SetText(maxSkill > 0 and ("%d / %d"):format(skill, maxSkill) or "not learned")
                e.fill:SetWidth(math.max(1, ENTRY_BAR * math.min(skill, 300) / 300))
                e.fill:SetShown(skill > 0)
                e.active = e.data == prof
                paintEntry(e)
                y, n = y - 44, n + 1
            end
        end
        if not first then y = y - 8 end
    end
    menu.camp.active = ns.Player.Saved().tab == "camp"
    paintEntry(menu.camp)
    return n
end

-- The menu (left) in the window: an entry per profession, a heading per group (Menu.Render shows the character's).
function Menu.Build(frame)
    local menu = CreateFrame("Frame", nil, frame)
    menu:SetPoint("TOPLEFT", 12, -66)
    menu:SetPoint("BOTTOMLEFT", 12, 42)
    menu:SetWidth(MENU_W)
    UI.Panel(menu, C.panel, C.edge, 8)
    menu.entries, menu.heads = {}, {}
    for i, data in ipairs(ns.Professions) do menu.entries[i] = makeMenuEntry(menu, data) end
    for i, group in ipairs(MENU_GROUPS) do
        menu.heads[i] = UI.Label(menu, 10, C.dim)
        menu.heads[i]:SetText(group.title)
    end
    -- Camp, at the bottom: no skill, its own view
    local camp = makeMenuEntry(menu, { name = "Camp", icon = ns.UI.ItemIcon(ns.CAMP.fires[1].item) })
    camp:SetPoint("BOTTOMLEFT", 6, 6)
    camp.bar:Hide()
    camp.fill:Hide()
    camp.skill:SetText("")
    camp.name:ClearAllPoints()
    camp.name:SetPoint("LEFT", camp.icon, "RIGHT", 8, 0)
    camp.tooltip = { "Camp", "What each camp feature gives around a campfire, in the order your role wants them, and"
        .. " how to get it." }
    camp:SetScript("OnClick", function()
        ns.Player.Saved().tab = "camp"
        Window.Refresh(true)
    end)
    menu.camp = camp
    frame.menu = menu
end
