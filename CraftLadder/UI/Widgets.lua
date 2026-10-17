-- Craft Ladder: the building blocks of the window. A dark, rounded look with gold headings; the shapes are white
-- textures from Media (tools/make_media.py) tinted with the palette below.
local ADDON, ns = ...

local UI = {}
ns.UI = UI

local MEDIA = "Interface\\AddOns\\" .. ADDON .. "\\Media\\"
UI.MEDIA = MEDIA
local FONT = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
UI.FONT = FONT

local C = {
    bg       = { 0.055, 0.050, 0.047, 0.97 },
    panel    = { 0.090, 0.082, 0.075, 1 },
    panel2   = { 0.125, 0.112, 0.100, 1 },
    hover    = { 0.165, 0.148, 0.130, 1 },
    edge     = { 0.240, 0.205, 0.170, 1 },
    selected = { 0.950, 0.660, 0.250, 1 },
    gold     = { 1.000, 0.820, 0.350, 1 },
    text     = { 0.930, 0.910, 0.880, 1 },
    muted    = { 0.620, 0.580, 0.530, 1 },
    dim      = { 0.420, 0.390, 0.360, 1 },
    warn     = { 1.000, 0.700, 0.250, 1 },
    bad      = { 1.000, 0.380, 0.320, 1 },
    good     = { 0.450, 0.850, 0.400, 1 },
    orange   = { 1.000, 0.500, 0.250, 1 },
    yellow   = { 1.000, 0.950, 0.200, 1 },
    green    = { 0.300, 0.800, 0.300, 1 },
    grey     = { 0.550, 0.550, 0.550, 1 },
    horde    = { 0.780, 0.200, 0.150, 1 },
    alliance = { 0.220, 0.470, 0.880, 1 },
}
UI.C = C

function UI.Hex(color)
    return ("|cff%02x%02x%02x"):format(color[1] * 255, color[2] * 255, color[3] * 255)
end

---------------------------------------------------------------------------------------------------------------
-- Shapes: a texture cut in nine so its corners keep their size at any frame size
---------------------------------------------------------------------------------------------------------------

local Shape = {}
Shape.__index = Shape

-- file: a square texture texSize px wide; corner: px of it kept as the corner; size: that corner on screen;
-- outset: how far beyond the parent's edges it reaches.
function UI.Shape(parent, file, texSize, corner, size, outset, layer, sub)
    local s = setmetatable({ parts = {} }, Shape)
    local f, o = corner / texSize, outset or 0
    local coords = {
        TL = { 0, f, 0, f }, T = { f, 1 - f, 0, f }, TR = { 1 - f, 1, 0, f },
        L = { 0, f, f, 1 - f }, M = { f, 1 - f, f, 1 - f }, R = { 1 - f, 1, f, 1 - f },
        BL = { 0, f, 1 - f, 1 }, B = { f, 1 - f, 1 - f, 1 }, BR = { 1 - f, 1, 1 - f, 1 },
    }
    local p = s.parts
    for key, c in pairs(coords) do
        local t = parent:CreateTexture(nil, layer or "BACKGROUND", nil, sub or 0)
        t:SetTexture(file)
        t:SetTexCoord(c[1], c[2], c[3], c[4])
        p[key] = t
    end
    for _, key in ipairs({ "TL", "TR", "BL", "BR" }) do p[key]:SetSize(size, size) end
    p.TL:SetPoint("TOPLEFT", parent, "TOPLEFT", -o, o)
    p.TR:SetPoint("TOPRIGHT", parent, "TOPRIGHT", o, o)
    p.BL:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", -o, -o)
    p.BR:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", o, -o)
    p.T:SetPoint("TOPLEFT", p.TL, "TOPRIGHT"); p.T:SetPoint("BOTTOMRIGHT", p.TR, "BOTTOMLEFT")
    p.B:SetPoint("TOPLEFT", p.BL, "TOPRIGHT"); p.B:SetPoint("BOTTOMRIGHT", p.BR, "BOTTOMLEFT")
    p.L:SetPoint("TOPLEFT", p.TL, "BOTTOMLEFT"); p.L:SetPoint("BOTTOMRIGHT", p.BL, "TOPRIGHT")
    p.R:SetPoint("TOPLEFT", p.TR, "BOTTOMLEFT"); p.R:SetPoint("BOTTOMRIGHT", p.BR, "TOPRIGHT")
    p.M:SetPoint("TOPLEFT", p.TL, "BOTTOMRIGHT"); p.M:SetPoint("BOTTOMRIGHT", p.BR, "TOPLEFT")
    return s
end

function Shape:SetColor(c, alpha)
    for _, t in pairs(self.parts) do t:SetVertexColor(c[1], c[2], c[3], alpha or c[4] or 1) end
end

function Shape:SetShown(shown)
    for _, t in pairs(self.parts) do t:SetShown(shown and true or false) end
end

-- A rounded panel: a 1-unit edge around a fill. radius = corner size on screen.
function UI.Panel(frame, fill, edge, radius, sub)
    radius, sub = radius or 6, sub or -6
    frame.edgeShape = UI.Shape(frame, MEDIA .. "round", 64, 16, radius + 1, 1, "BACKGROUND", sub)
    frame.fillShape = UI.Shape(frame, MEDIA .. "round", 64, 16, radius, 0, "BACKGROUND", sub + 1)
    frame.edgeShape:SetColor(edge or C.edge)
    frame.fillShape:SetColor(fill or C.panel)
    function frame:SetPanelColors(f, e)
        if f then self.fillShape:SetColor(f) end
        if e then self.edgeShape:SetColor(e) end
    end
    return frame
end

function UI.Shadow(frame, spread)
    local s = UI.Shape(frame, MEDIA .. "shadow", 64, 32, 32, spread or 14, "BACKGROUND", -8)
    s:SetColor({ 0, 0, 0, 1 })
    return s
end

---------------------------------------------------------------------------------------------------------------
-- Text
---------------------------------------------------------------------------------------------------------------

function UI.Label(parent, size, color, layer, justify)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFont(FONT, size or 12, "")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 0.85)
    local c = color or C.text
    fs:SetTextColor(c[1], c[2], c[3], c[4] or 1)
    fs:SetJustifyH(justify or "LEFT")
    fs:SetWordWrap(false)
    return fs
end

function UI.SetColor(fs, c) fs:SetTextColor(c[1], c[2], c[3], c[4] or 1) end

---------------------------------------------------------------------------------------------------------------
-- Tooltips
---------------------------------------------------------------------------------------------------------------

-- Shows `lines` (strings, or { left, right } pairs) next to `owner`. The first line is the title.
function UI.Tooltip(owner, lines, anchor)
    GameTooltip:SetOwner(owner, anchor or "ANCHOR_RIGHT")
    for i, line in ipairs(lines) do
        if type(line) == "table" then
            GameTooltip:AddDoubleLine(line[1], line[2], 0.93, 0.91, 0.88, 1, 1, 1)
        elseif i == 1 then
            GameTooltip:AddLine(line, C.gold[1], C.gold[2], C.gold[3])
        else
            GameTooltip:AddLine(line, 0.93, 0.91, 0.88, true)
        end
    end
    GameTooltip:Show()
end

function UI.HideTooltip() GameTooltip:Hide() end

-- The game's own tooltip of an item (or of a spell, for a recipe that makes no item), with Craft Ladder's lines
-- under it: strings, or { left, right } pairs.
function UI.ItemTooltip(owner, item, spell, extra, anchor)
    GameTooltip:SetOwner(owner, anchor or "ANCHOR_RIGHT")
    if item then
        GameTooltip:SetItemByID(item)
    elseif spell then
        GameTooltip:SetSpellByID(spell)
    end
    if extra and #extra > 0 then
        GameTooltip:AddLine(" ")
        for _, line in ipairs(extra) do
            if type(line) == "table" then
                GameTooltip:AddDoubleLine(line[1], line[2], C.muted[1], C.muted[2], C.muted[3], 1, 1, 1)
            else
                GameTooltip:AddLine(line, C.muted[1], C.muted[2], C.muted[3], true)
            end
        end
    end
    GameTooltip:Show()
end

-- Shift-click: the item's link into the chat box.
function UI.LinkItem(item)
    if not (item and ChatEdit_InsertLink) then return end
    local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local link = getInfo and select(2, getInfo(item))
    if link then ChatEdit_InsertLink(link) end
end

---------------------------------------------------------------------------------------------------------------
-- Buttons
---------------------------------------------------------------------------------------------------------------

-- A rounded button with a label. onClick(self, mouseButton).
function UI.Button(parent, text, w, h, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    UI.Panel(b, C.panel2, C.edge, 5, -4)
    b.label = UI.Label(b, 11, C.text)
    b.label:SetPoint("CENTER")
    b.label:SetText(text)
    b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    function b:Paint()
        if not self:IsEnabled() then
            self:SetPanelColors(C.panel, C.edge)
            UI.SetColor(self.label, C.dim)
        elseif self.active then
            self:SetPanelColors(C.hover, C.selected)
            UI.SetColor(self.label, C.gold)
        else
            self:SetPanelColors(self:IsMouseOver() and C.hover or C.panel2, C.edge)
            UI.SetColor(self.label, self:IsMouseOver() and C.gold or C.text)
        end
    end
    function b:SetActive(v) self.active = v; self:Paint() end
    b:SetScript("OnEnter", function(self)
        self:Paint()
        if self.tooltip then UI.Tooltip(self, self.tooltip) end
    end)
    b:SetScript("OnLeave", function(self) self:Paint(); UI.HideTooltip() end)
    b:SetScript("OnEnable", b.Paint)
    b:SetScript("OnDisable", b.Paint)
    if onClick then b:SetScript("OnClick", onClick) end
    b:Paint()
    return b
end

-- A small square button showing one of the Media glyphs (close, pin).
function UI.IconButton(parent, glyph, size, color, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(size, size)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.icon:SetTexture(MEDIA .. glyph)
    local c = color or C.muted
    b.icon:SetVertexColor(c[1], c[2], c[3])
    b:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(C.gold[1], C.gold[2], C.gold[3])
        if self.tooltip then UI.Tooltip(self, self.tooltip) end
    end)
    b:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(c[1], c[2], c[3])
        UI.HideTooltip()
    end)
    if onClick then b:SetScript("OnClick", onClick) end
    return b
end

-- A checkbox with a label. onChange(checked).
function UI.Check(parent, text, onChange)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(16, 16)
    UI.Panel(b, C.panel2, C.edge, 4, -4)
    b.tick = b:CreateTexture(nil, "ARTWORK")
    b.tick:SetPoint("CENTER")
    b.tick:SetSize(14, 14)
    b.tick:SetTexture(MEDIA .. "check")
    b.tick:SetVertexColor(C.gold[1], C.gold[2], C.gold[3])
    b.label = UI.Label(b, 11, C.muted)
    b.label:SetPoint("LEFT", b, "RIGHT", 6, 0)
    b.label:SetText(text)
    function b:SetChecked(v) self.checked = v and true or false; self.tick:SetShown(self.checked) end
    b:SetScript("OnClick", function(self)
        self:SetChecked(not self.checked)
        if onChange then onChange(self.checked) end
    end)
    b:SetScript("OnEnter", function(self) if self.tooltip then UI.Tooltip(self, self.tooltip) end end)
    b:SetScript("OnLeave", UI.HideTooltip)
    b:SetChecked(false)
    return b
end

---------------------------------------------------------------------------------------------------------------
-- A scroll area: mouse wheel, a thin bar that shows only when the content is taller than the view
---------------------------------------------------------------------------------------------------------------

function UI.Scroll(parent)
    local sf = CreateFrame("ScrollFrame", nil, parent)
    local child = CreateFrame("Frame", nil, sf)
    child:SetSize(1, 1)
    sf:SetScrollChild(child)
    sf.child = child
    sf.bar = sf:CreateTexture(nil, "OVERLAY")
    sf.bar:SetWidth(3)
    sf.bar:SetColorTexture(C.edge[1], C.edge[2], C.edge[3], 1)
    local function update()
        local view, content = sf:GetHeight(), child:GetHeight()
        local max = math.max(0, content - view)
        local pos = math.min(sf:GetVerticalScroll(), max)
        sf:SetVerticalScroll(pos)
        if max <= 0 or view <= 0 then sf.bar:Hide(); return end
        local h = math.max(20, view * view / content)
        sf.bar:SetHeight(h)
        sf.bar:ClearAllPoints()
        sf.bar:SetPoint("TOPRIGHT", sf, "TOPRIGHT", 0, -(view - h) * pos / max)
        sf.bar:Show()
    end
    sf:EnableMouseWheel(true)
    sf:SetScript("OnMouseWheel", function(self, delta)
        if self.onCtrlWheel and self.onCtrlWheel(delta) then return end -- Ctrl + wheel scales the window instead
        self:SetVerticalScroll(math.max(0, self:GetVerticalScroll() - delta * 40))
        update()
    end)
    sf:SetScript("OnSizeChanged", function(self, w) child:SetWidth(w); update() end)
    function sf:SetContentHeight(h) child:SetHeight(math.max(1, h)); update() end
    function sf:ScrollToTop() self:SetVerticalScroll(0); update() end
    return sf
end

---------------------------------------------------------------------------------------------------------------
-- Pools: widgets are made once and reused on every redraw
---------------------------------------------------------------------------------------------------------------

function UI.Pool(make)
    local pool = { free = {}, used = {} }
    function pool:Get(parent)
        local w = table.remove(self.free) or make(parent)
        self.used[#self.used + 1] = w
        w:SetParent(parent)
        w:ClearAllPoints()
        w:Show()
        return w
    end
    function pool:ReleaseAll()
        for i = #self.used, 1, -1 do
            local w = self.used[i]
            w:Hide()
            self.free[#self.free + 1] = w
            self.used[i] = nil
        end
    end
    return pool
end

-- Item icon from the game's local item data (no server request).
function UI.ItemIcon(item)
    if not item then return 134400 end -- question mark
    local icon = C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(item)
    if not icon then
        local instant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
        icon = instant and select(5, instant(item))
    end
    return icon or 134400
end
