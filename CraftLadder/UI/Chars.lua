-- Craft Ladder: the account's characters on this realm and side, a button each left of the main window (you first).
-- A click shows that character's professions and ladders as its last session left them (Player.Snapshot): to read,
-- not to craft from, until you click yourself again. UI/Window.lua builds it and draws it again.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local Window = ns.Window

local Chars = {}
ns.Chars = Chars

local SIZE = 40
local CLASS_ICONS = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"

local function paint(b)
    if b.active then
        b:SetPanelColors(C.hover, C.selected)
    else
        b:SetPanelColors(b:IsMouseOver() and C.hover or C.panel2, b:IsMouseOver() and C.edge or C.panel2)
    end
end

local function makeButton(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(SIZE, SIZE)
    UI.Panel(b, C.panel2, C.panel2, 6, -4)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 5, -5)
    b.icon:SetPoint("BOTTOMRIGHT", -5, 5)
    b.icon:SetTexture(CLASS_ICONS)
    b:SetScript("OnEnter", function(self)
        paint(self)
        UI.Tooltip(self, self.tooltip, "ANCHOR_LEFT")
    end)
    b:SetScript("OnLeave", function(self)
        paint(self)
        UI.HideTooltip()
    end)
    b:SetScript("OnClick", function(self)
        ns.Player.viewing = self.guid ~= self.own and self.guid or nil
        Window.Refresh(true) -- its ladders are cached by character: drawn again when looked at before
    end)
    return b
end

-- A button per character, when there's more than you; the shown one picked.
function Chars.Render(frame)
    local col = frame.chars
    for _, b in ipairs(col.buttons) do b:Hide() end
    local list = ns.Player.Chars()
    if #list < 2 then return end
    for i, c in ipairs(list) do
        local b = col.buttons[i]
        if not b then
            b = makeButton(col)
            col.buttons[i] = b
        end
        b:SetPoint("TOPLEFT", 0, -(i - 1) * (SIZE + 6))
        b.guid, b.own = c.guid, list[1].guid
        local coords = CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[c.me.class]
        if coords then b.icon:SetTexCoord(unpack(coords)) end
        b.active = c.guid == (ns.Player.viewing or b.own)
        local class = LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[c.me.class] or c.me.class
        b.tooltip = { c.me.name, ("Level %d %s"):format(c.me.level or 0, class),
                      i == 1 and "Playing now" or ("Last seen " .. ns.Age(c.me.seen)) }
        paint(b)
        b:Show()
    end
end

-- The column left of the window, under its top edge.
function Chars.Build(frame)
    local col = CreateFrame("Frame", nil, frame)
    col:SetPoint("TOPRIGHT", frame, "TOPLEFT", -6, -14)
    col:SetSize(SIZE, 1)
    col.buttons = {}
    frame.chars = col
end
