-- Craft Ladder: the Settings menu of the main window (the header's Settings button), shown instead of a step's card:
-- which auction house addon the prices are read from, and which of its listed prices buying pays. The settings are
-- the account's (ns.db.prices), the same for every character and profession; changing one calculates the ladders
-- again.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local L = ns.L
local Window = ns.Window

local Settings = {}
ns.Settings = Settings

local panel

local function saved()
    ns.db.prices = ns.db.prices or {}
    return ns.db.prices
end

-- The two groups of ticks, in English: Settings.Render puts them on the screen in the language picked, so the
-- language can change without a /reload. { value, label, help }; the first value is the default (saved as nil).
local SOURCES = {
    { "auctionDB", "AuctionDB", "Its last full scan of your faction's auction house: the lowest price, the"
        .. " median and how many are listed." },
    { "auctionator", "Auctionator", "Its last scan. It gives one price per item, so the median is that price." },
}
local HOWS = {
    { "median", "The median listed price", "Half of what's listed costs less. The cheapest listing is one"
        .. " auction, often gone minutes after the scan." },
    { "min", "The cheapest listing", "What the ladder cost before: the lowest price of the scan. Cheaper"
        .. " than what you will really pay, unless you are quick." },
}
local LANGUAGE_TIP = "Craft Ladder's own words. Item, recipe and zone names come from your game client, in its"
    .. " language. A few buttons take a /reload to change."
local FOOT = "What you sell is always priced at the cheapest listing, the one you undercut."

-- A group of ticks, one of them picked: the ticked one can't be unticked, clicking another moves the tick. key is
-- the saved key. Only the widgets are made here; Render puts the words in and places them.
local function group(title, choices, key)
    local g = { title = title, label = UI.Label(panel, 12, C.gold), checks = {} }
    for _, c in ipairs(choices) do
        local check = UI.Check(panel, c[2], function()
            saved()[key] = c[1] ~= choices[1][1] and c[1] or nil
            Settings.Render()
            Window.Refresh() -- the prices changed: every ladder is out of date
        end)
        check.value, check.key, check.word, check.helpWord = c[1], key, c[2], c[3]
        check.help = UI.Label(panel, 11, C.muted)
        check.help:SetWordWrap(true)
        g.checks[#g.checks + 1] = check
        panel.checks[#panel.checks + 1] = check
    end
    panel.groups[#panel.groups + 1] = g
    return g
end

function Settings.Build(frame)
    panel = CreateFrame("Frame", nil, frame)
    panel:SetPoint("TOPLEFT", frame.list, "TOPRIGHT", 8, 0)
    panel:SetPoint("BOTTOMRIGHT", -12, 42)
    UI.Panel(panel, C.panel, C.edge, 8)
    panel.checks, panel.groups = {}, {}
    group("Auction house prices from", SOURCES, "source")
    -- one line, only when the addon picked isn't there: the other one is read instead
    panel.missing = UI.Label(panel, 11, C.warn)
    panel.missing:SetWordWrap(true)
    group("An ingredient costs", HOWS, "how")
    -- the language Craft Ladder speaks, at the bottom: each one written in its own language. Item, recipe and zone
    -- names come from the client whatever is picked here.
    panel.lang = UI.Label(panel, 12, C.gold)
    local choices = {}
    for _, l in ipairs(ns.Languages) do choices[#choices + 1] = { l.code, l.name } end
    panel.language = UI.Dropdown(panel, 150, 20, choices, function(code)
        ns.db.locale = code ~= "enUS" and code or nil
        Settings.Render()
        Window.Refresh() -- every word on the screen may change
    end)
    panel.foot = UI.Label(panel, 11, C.muted)
    panel.foot:SetWordWrap(true)
    panel:Hide()
    frame.settings = panel
end

-- Down the panel, each row under the one above it: a help line wraps to two or three lines in a language whose
-- words are longer than English's, so every row is placed by the height its text really takes.
local function layout()
    local full = panel:GetWidth() or 300 -- the panel is as wide as the window leaves it
    local function put(fs, left, y, width)
        fs:ClearAllPoints()
        fs:SetWidth(width or math.max(160, full - left - 14))
        fs:SetPoint("TOPLEFT", left, y)
        if (fs:GetText() or "") == "" then return y end -- the warning line, when there is nothing to warn about
        return y - math.max(14, fs:GetStringHeight())
    end
    local y = -16
    for i, g in ipairs(panel.groups) do
        y = put(g.label, 14, y) - 8
        for _, check in ipairs(g.checks) do
            check:ClearAllPoints()
            check:SetPoint("TOPLEFT", 16, y)
            y = put(check.help, 36, y - 20) - 10
        end
        if i == 1 then y = put(panel.missing, 16, y) - 8 end -- between the groups, usually empty
        y = y - 14
    end
    panel.lang:ClearAllPoints()
    panel.lang:SetPoint("TOPLEFT", 14, y)
    y = y - 22
    panel.language:ClearAllPoints()
    panel.language:SetPoint("TOPLEFT", 16, y)
    y = y - 32
    put(panel.foot, 14, y)
end

function Settings.Render()
    local p = saved()
    -- the words first: the language may have changed a moment ago, in this very panel
    for _, g in ipairs(panel.groups) do g.label:SetText(L[g.title]) end
    panel.lang:SetText(L["Language"])
    panel.language.tooltip = { L["Language"], L[LANGUAGE_TIP] }
    panel.foot:SetText(L[FOOT])
    panel.language:SetPicked(ns.Language())
    for _, check in ipairs(panel.checks) do
        check.label:SetText(L[check.word])
        check.help:SetText(L[check.helpWord])
        local picked = p[check.key] or (check.key == "source" and "auctionDB" or "median")
        check:SetChecked(check.value == picked)
    end
    local source = ns.Prices.Source()
    local picked = p.source == "auctionator" and "Auctionator" or "AuctionDB"
    panel.missing:SetText(source ~= picked and (source
        and L["%s isn't installed: %s is read."]:format(picked, source)
        or L["Neither addon is installed: no auction house prices."]) or "")
    layout() -- last: it measures the words that were just set
end
