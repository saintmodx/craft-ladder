-- Craft Ladder: the Camp view of the main window (the menu's Camp entry), one wide panel instead of the ladder and
-- its card: your role and campfire at the top, then a row per camp feature in the order your role wants them (what it
-- gives at your level, the class buff it doesn't stack with, how to get it, what stands for it), a line where the
-- campfire is full, then what doesn't help your role and the features with no buff. Camp.lua decides; this draws.
local _, ns = ...
local UI = ns.UI
local C = UI.C

local CampPanel = {}
ns.CampPanel = CampPanel

local ROW_H, HEAD_H = 66, 24
local panel, rowPool, headPool, panelLeft

local hex = UI.Hex

local function saved()
    local s = ns.Player.Saved()
    s.camp = s.camp or {}
    return s.camp
end

-- "Blacksmithing (skill 1): you know it, 2 in your bags, needs 1 Copper Bar and 1 Coarse Stone"
local function sourceText(e, src)
    local parts = {}
    local prof = src.prof and src.prof.name or "No profession"
    parts[1] = prof .. (src.skill and (" (skill " .. src.skill .. ")") or "") .. ": "
        .. (src.known and (hex(C.good) .. "you know it|r") or src.has and "you can learn it"
            or (hex(C.warn) .. "not your profession|r"))
    if src.owned > 0 then parts[#parts + 1] = hex(C.good) .. src.owned .. " in your bags|r" end
    local mats = {}
    for item, n in pairs(e.mats or {}) do mats[#mats + 1] = n .. " " .. ns.Camp.ItemName(item) end
    table.sort(mats)
    if #mats > 0 then parts[#parts + 1] = "needs " .. table.concat(mats, ", ") end
    return table.concat(parts, ", ")
end

local function priceText(src)
    local lines = {}
    lines[1] = "make " .. (src.cost and ns.Money(src.cost) or (hex(C.bad) .. "no price|r"))
    lines[2] = "AH " .. (src.ah and ns.Money(src.ah) or (hex(C.muted) .. "not listed|r"))
    return table.concat(lines, "\n")
end

local function makeRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H - 4)
    UI.Panel(r, C.panel2, C.panel2, 6, -4)
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(34, 34)
    r.icon:SetPoint("TOPLEFT", 10, -8)
    r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    r.price = UI.Label(r, 11, C.text, nil, "RIGHT")
    r.price:SetPoint("TOPRIGHT", -12, -8)
    r.price:SetWidth(130)
    r.price:SetWordWrap(true) -- two lines: make, AH
    -- the name, then what it gives, how to get it and what stands for it, each wrapped under the one above
    local function line(size, color, above)
        local fs = UI.Label(r, size, color)
        if above then
            fs:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -1)
        else
            fs:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 10, 2)
        end
        fs:SetWordWrap(above ~= nil)
        return fs
    end
    r.name = line(13, C.text)
    r.gives = line(12, C.good, r.name)
    r.source = line(11, C.muted, r.gives)
    r.more = line(10, C.muted, r.source)
    r:SetScript("OnEnter", function(self)
        self:SetPanelColors(C.hover, C.hover)
        UI.ItemTooltip(self, self.item, nil, self.extra)
    end)
    r:SetScript("OnLeave", function(self)
        self:SetPanelColors(C.panel2, C.panel2)
        UI.HideTooltip()
    end)
    r:SetScript("OnClick", function(self)
        if IsShiftKeyDown() then UI.LinkItem(self.item) end
    end)
    return r
end

local function makeHead(parent)
    local h = CreateFrame("Frame", nil, parent)
    h:SetHeight(HEAD_H)
    h.text = UI.Label(h, 11, C.gold)
    h.text:SetPoint("LEFT", 8, 0)
    return h
end

-- One row: a feature (or a feature with no buff, f.gives nil) and how to get it.
local function fillRow(r, f, useful, level, lookup, byProf)
    local src = ns.Camp.Source(f, lookup, byProf)
    r.item = f.item
    r.icon:SetTexture(UI.ItemIcon(f.item))
    r.icon:SetDesaturated(not useful)
    r.name:SetText(f.name)
    UI.SetColor(r.name, useful and C.text or C.muted)
    if f.gives then
        r.gives:SetText(ns.Camp.Gives(f, level)
            .. (f.exclusive and (hex(C.muted) .. "  (not with " .. f.exclusive .. ")|r") or ""))
    else
        r.gives:SetText(f.adds or "")
    end
    UI.SetColor(r.gives, useful and C.good or C.muted)
    r.source:SetText(sourceText(f, src))
    r.price:SetText(priceText(src))
    -- what stands for it: the same buff, and what each adds; their recipes in the tooltip
    local more, extra = {}, {}
    for _, u in ipairs(f.upgrades or {}) do
        more[#more + 1] = u.name .. (u.adds ~= "" and (" (" .. u.adds:lower() .. ")") or "")
        local us = ns.Camp.Source(u, lookup, byProf)
        extra[#extra + 1] = { u.name, sourceText(u, us) }
    end
    r.more:SetText(#more > 0 and ("Or, the same buff and more: " .. table.concat(more, "; ")) or "")
    r.extra = extra
end

-- The row as tall as its text wrapped to `w`, never shorter than its icon and price need.
local function fitRow(r, w)
    local h = 6 + 4 -- above the name, below the last line
    for _, fs in ipairs({ r.name, r.gives, r.source, r.more }) do
        fs:SetWidth(w)
        if (fs:GetText() or "") ~= "" then h = h + fs:GetStringHeight() + 1 end
    end
    r:SetHeight(math.max(ROW_H - 4, h))
end

-- Draws the Camp view; Window.Refresh calls it while the menu's Camp entry is picked.
function CampPanel.Render(frame)
    local s = saved()
    local class = UnitClass and select(2, UnitClass("player")) or "WARRIOR"
    local roles = ns.Camp.Roles(class)
    local role = s.role
    local ok = false
    for _, r in ipairs(roles) do ok = ok or r == role end
    if not ok then role = roles[1] end
    local level = UnitLevel and UnitLevel("player") or 1
    local faction = UnitFactionGroup("player") == "Alliance" and "A" or "H"
    local _, lookup = ns.Prices.ForGame()
    local byProf = {}
    local fireIndex = s.fire or ns.Camp.BestFire(function(fire) return ns.Camp.Knows(fire, byProf) end)
    local fire = ns.CAMP.fires[fireIndex] or ns.CAMP.fires[1]

    frame.subtitle:SetText(("Camp: the buffs a campfire gives, for a level %d %s"):format(level, role))
    -- the role (a class with one has no choice) and the campfire
    for i, b in ipairs(panel.roles) do
        b:SetShown(#roles > 1 and roles[i] ~= nil)
        if roles[i] then
            b.role = roles[i]
            b.label:SetText(roles[i])
            b:SetActive(roles[i] == role)
        end
    end
    panel.roleLabel:SetShown(#roles > 1)
    for i, b in ipairs(panel.fires) do
        local f = ns.CAMP.fires[i]
        local src = ns.Camp.Source(f, lookup, byProf)
        b:SetActive(f == fire)
        b.tooltip = { f.name, ("Holds %d camp features. %s; %s."):format(f.slots, sourceText(f, src),
            (priceText(src):gsub("\n", ", "))) }
    end

    -- the text as wide as the window is now (Window.lua draws this again once its corner is let go)
    local panelW = frame:GetWidth() - panelLeft - 12
    panel.intro:SetWidth(panelW - 28)
    local top = 12 + panel.intro:GetStringHeight() + 20
    panel.roleLabel:SetPoint("TOPLEFT", 14, -top)
    panel.fireLabel:SetPoint("TOPLEFT", 330, -top)
    panel.scroll:SetPoint("TOPLEFT", 8, -(top + 28))
    local textW = panelW - 14 - 8 - 206 -- the scroll's and the row's insets, the icon and the price

    rowPool:ReleaseAll()
    headPool:ReleaseAll()
    local y = 0
    local function head(text)
        local h = headPool:Get(panel.scroll.child)
        h:SetPoint("TOPLEFT", 0, -y)
        h:SetPoint("RIGHT", panel.scroll.child, "RIGHT", -8, 0)
        h.text:SetText(text)
        y = y + HEAD_H
    end
    local function row(f, useful)
        local r = rowPool:Get(panel.scroll.child)
        r:SetPoint("TOPLEFT", 0, -y)
        r:SetPoint("RIGHT", panel.scroll.child, "RIGHT", -8, 0)
        fillRow(r, f, useful, level, lookup, byProf)
        fitRow(r, textW)
        y = y + r:GetHeight() + 4
    end
    local order = ns.Camp.Order(role, level, faction)
    local placed, shownMissing = 0, false
    for _, o in ipairs(order) do
        if o.useful and placed == fire.slots then
            head(("A %s holds %d: the ones above. Then:"):format(fire.name, fire.slots))
        end
        if not o.useful and not shownMissing then
            head(("Doesn't help a %s"):format(role))
            shownMissing = true
        end
        if o.useful then placed = placed + 1 end
        row(o.feature, o.useful)
    end
    head("Camp features with no buff")
    for _, f in ipairs(ns.CAMP.others) do row(f, true) end
    panel.scroll:SetContentHeight(y)
end

-- The panel, where the ladder and its card are (Window.lua's build calls it).
function CampPanel.Build(frame, left)
    panel, panelLeft = CreateFrame("Frame", nil, frame), left
    panel:SetPoint("TOPLEFT", left, -66)
    panel:SetPoint("BOTTOMRIGHT", -12, 42)
    UI.Panel(panel, C.panel, C.edge, 8)
    panel.intro = UI.Label(panel, 11, C.muted)
    panel.intro:SetPoint("TOPLEFT", 14, -12)
    panel.intro:SetWordWrap(true)
    panel.intro:SetText("Build a campfire, place camp features around it and sit or craft nearby for a while: each"
        .. " feature gives everyone there its buff. A campfire holds only so many: here they are in the order your"
        .. " role wants them.")
    panel.roleLabel = UI.Label(panel, 11, C.text)
    panel.roleLabel:SetPoint("TOPLEFT", 14, -46)
    panel.roleLabel:SetText("Role:")
    panel.roles = {}
    for i = 1, 4 do -- a druid has four
        local b = UI.Button(panel, "", 70, 20, function(self)
            saved().role = self.role
            CampPanel.Render(frame)
        end)
        b:SetPoint("LEFT", i == 1 and panel.roleLabel or panel.roles[i - 1], "RIGHT", i == 1 and 8 or 4, 0)
        panel.roles[i] = b
    end
    local fireLabel = UI.Label(panel, 11, C.text)
    fireLabel:SetPoint("TOPLEFT", 330, -46)
    fireLabel:SetText("Campfire:")
    panel.fireLabel = fireLabel
    panel.fires = {}
    for i, f in ipairs(ns.CAMP.fires) do
        local b = UI.Button(panel, ("%s (%d)"):format((f.name:gsub(" Campfire", "")), f.slots), 110, 20, function()
            saved().fire = i
            CampPanel.Render(frame)
        end)
        b:SetPoint("LEFT", i == 1 and fireLabel or panel.fires[i - 1], "RIGHT", i == 1 and 8 or 4, 0)
        panel.fires[i] = b
    end
    panel.scroll = UI.Scroll(panel)
    panel.scroll:SetPoint("TOPLEFT", 8, -74)
    panel.scroll:SetPoint("BOTTOMRIGHT", -6, 8)
    rowPool = UI.Pool(makeRow)
    headPool = UI.Pool(makeHead)
    panel:Hide()
    frame.camp = panel
end
