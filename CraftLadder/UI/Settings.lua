-- Craft Ladder: the Settings menu of the main window (the header's Settings button), shown instead of a step's card:
-- which auction house addon the prices are read from, and which of its listed prices buying pays. The settings are
-- the account's (ns.db.prices), the same for every character and profession; changing one calculates the ladders
-- again.
local _, ns = ...
local UI = ns.UI
local C = UI.C
local Window = ns.Window

local Settings = {}
ns.Settings = Settings

local panel

local function saved()
    ns.db.prices = ns.db.prices or {}
    return ns.db.prices
end

-- A group of ticks, one of them picked: the ticked one can't be unticked, clicking another moves the tick. key is
-- the saved key, choices = { { value, label, help } }; the first value is the default (saved as nil).
local function group(title, choices, key, y)
    local fs = UI.Label(panel, 12, C.gold)
    fs:SetPoint("TOPLEFT", 14, y)
    fs:SetText(title)
    y = y - 22
    for _, c in ipairs(choices) do
        local check = UI.Check(panel, c[2], function()
            saved()[key] = c[1] ~= choices[1][1] and c[1] or nil
            Settings.Render()
            Window.Refresh() -- the prices changed: every ladder is out of date
        end)
        check:SetPoint("TOPLEFT", 16, y)
        check.value, check.key = c[1], key
        panel.checks[#panel.checks + 1] = check
        local help = UI.Label(panel, 11, C.muted)
        help:SetPoint("TOPLEFT", 36, y - 20)
        help:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -14, y - 20)
        help:SetWordWrap(true)
        help:SetText(c[3])
        check.help = help
        y = y - 44
    end
    return y - 8
end

function Settings.Build(frame)
    panel = CreateFrame("Frame", nil, frame)
    panel:SetPoint("TOPLEFT", frame.list, "TOPRIGHT", 8, 0)
    panel:SetPoint("BOTTOMRIGHT", -12, 42)
    UI.Panel(panel, C.panel, C.edge, 8)
    panel.checks = {}
    local y = group("Auction house prices from", {
        { "auctionDB", "AuctionDB", "Its last full scan of your faction's auction house: the lowest price, the" ..
            " median and how many are listed." },
        { "auctionator", "Auctionator", "Its last scan. It gives one price per item, so the median is that price." },
    }, "source", -16)
    -- one line, only when the addon picked isn't there: the other one is read instead
    panel.missing = UI.Label(panel, 11, C.warn)
    panel.missing:SetPoint("TOPLEFT", 16, y)
    panel.missing:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -14, y)
    panel.missing:SetWordWrap(true)
    y = group("An ingredient costs", {
        { "median", "The median listed price", "Half of what's listed costs less. The cheapest listing is one" ..
            " auction, often gone minutes after the scan." },
        { "min", "The cheapest listing", "What the ladder cost before: the lowest price of the scan. Cheaper than" ..
            " what you will really pay, unless you are quick." },
    }, "how", y - 22)
    panel.foot = UI.Label(panel, 11, C.muted)
    panel.foot:SetPoint("TOPLEFT", 14, y)
    panel.foot:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -14, y)
    panel.foot:SetWordWrap(true)
    panel.foot:SetText("What you sell is always priced at the cheapest listing, the one you undercut.")
    panel:Hide()
    frame.settings = panel
end

function Settings.Render()
    local p = saved()
    for _, check in ipairs(panel.checks) do
        local picked = p[check.key] or (check.key == "source" and "auctionDB" or "median")
        check:SetChecked(check.value == picked)
    end
    local source = ns.Prices.Source()
    local picked = p.source == "auctionator" and "Auctionator" or "AuctionDB"
    panel.missing:SetText(source ~= picked and (source
        and ("%s isn't installed: %s is read."):format(picked, source)
        or "Neither addon is installed: no auction house prices.") or "")
end
