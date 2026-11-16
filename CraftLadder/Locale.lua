-- Craft Ladder: which language the addon speaks. The game's own words (item, recipe and zone names) come from the
-- client and are in its language whatever is picked here; this is only about Craft Ladder's own.
-- ns.L[text] gives the picked language's version of an English string, or the English one when there is none, so
-- the code reads as it did and an untranslated string still shows.
local _, ns = ...

-- The languages offered, in the order the Settings menu lists them, each written in its own language.
ns.Languages = {
    { code = "enUS", name = "English" },
    { code = "deDE", name = "Deutsch" },
    { code = "esES", name = "Español" },
    { code = "frFR", name = "Français" },
    { code = "itIT", name = "Italiano" },
    { code = "ptBR", name = "Português" },
    { code = "ruRU", name = "Русский" },
    { code = "ukUA", name = "Українська" },
    { code = "koKR", name = "한국어" },
    { code = "zhCN", name = "简体中文" },
}

-- Client locales Craft Ladder has no file of its own for: the closest one it does have. The game has no Ukrainian
-- client at all, so ukUA is only ever picked by hand in Settings.
local ALIAS = { enGB = "enUS", esMX = "esES", zhTW = "zhCN" }

-- The language the addon speaks: the one picked in Settings, else the client's when Craft Ladder has it, else
-- English. (ns.db isn't there until the saved data loads, so this is asked every time, not kept.)
function ns.Language()
    local picked = ns.db and ns.db.locale
    picked = ALIAS[picked] or picked
    if picked and ns.Locales[picked] then return picked end
    local client = GetLocale and GetLocale()
    client = ALIAS[client] or client
    if client and ns.Locales[client] then return client end
    return "enUS"
end

ns.L = setmetatable({}, {
    __index = function(_, text)
        local words = ns.Locales[ns.Language()]
        return words and words[text] or text
    end,
})
