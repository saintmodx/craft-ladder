-- Craft Ladder: a specialization's steps (the Specialization button beside the ladder's modes): a button for each of
-- the profession's specializations, then its steps: who to talk to, the quests (done, in your log), what they ask for
-- and how many of it you have, the recipes that make it (known, or how to learn them), what to make and what to buy,
-- and what that costs. Spec.lua plans it; UI/Window.lua shows it instead of the ladder and its card, in the list made
-- as wide as the window.
local _, ns = ...
local UI = ns.UI
local C = UI.C

local SpecPanel = {}
ns.SpecPanel = SpecPanel

local hex = UI.Hex
local panel, pools, frame, left, shownGuide
local y, cw -- the layout cursor and the content's width while drawing

local function get(kind)
    local f = pools[kind]:Get(panel.scroll.child)
    f:Fit(cw)
    return f
end

local function place(f, gap)
    f:SetPoint("TOPLEFT", 0, -y)
    y = y + f:GetHeight() + (gap or 0)
end

local function section(text)
    y = y + 8
    local f = get("section")
    f.label:SetText(text)
    place(f, 6)
end

-- A heading that folds what's under it (The recipes), with the game's plus and minus.
local function makeFold(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(100, 26)
    b.fold = b:CreateTexture(nil, "ARTWORK")
    b.fold:SetSize(14, 14)
    b.fold:SetPoint("BOTTOMLEFT", 0, 5)
    b.label = UI.Label(b, 12, C.gold)
    b.label:SetPoint("BOTTOMLEFT", 20, 6)
    b.line = b:CreateTexture(nil, "ARTWORK")
    b.line:SetPoint("BOTTOMLEFT", 0, 1)
    b.line:SetPoint("BOTTOMRIGHT", 0, 1)
    b.line:SetHeight(1)
    b.line:SetColorTexture(C.edge[1], C.edge[2], C.edge[3], 1)
    b:SetScript("OnClick", function(self) self.toggle() end)
    b:SetScript("OnEnter", function(self) UI.Tooltip(self, self.tooltip) end)
    b:SetScript("OnLeave", UI.HideTooltip)
    function b:Fit(width) self:SetWidth(width) end
    return b
end

local function foldSection(text, shut, tooltip, toggle)
    y = y + 8
    local f = get("fold")
    f.label:SetText(text)
    f.fold:SetTexture(shut and "Interface\\Buttons\\UI-PlusButton-Up" or "Interface\\Buttons\\UI-MinusButton-Up")
    f.tooltip, f.toggle = tooltip, toggle
    place(f, 6)
end

local function line(text, color)
    local f = get("line")
    f.text:SetText(text)
    UI.SetColor(f.text, color or C.text)
    f:SetHeight(math.max(14, f.text:GetStringHeight()) + 4)
    place(f, 2)
end

-- An NPC with its map pin, after what you do there: "Take the quest:  Ox  Orgrimmar 80.5, 23.5".
local function npcRow(npc, action, right)
    local f = get("place")
    local name, where = ns.Describe.NPC(npc)
    f.npc, f.npcName, f.spot = npc, name, false -- false, not nil: a test frame reads a nil field as a method
    f.text:SetText(hex(C.gold) .. action .. "|r  " .. name .. (where and (hex(C.muted) .. "  " .. where .. "|r") or ""))
    f.right:SetText(right or "")
    place(f, 2)
end

-- "2 / 4  Moonsteel Broadsword", green once you have them all; under it how to get the rest.
local function itemRow(item, have, need, sub, subColor, cost)
    local f = get("item")
    f.item, f.source = item, sub
    f.icon:SetTexture(UI.ItemIcon(item))
    f.name:SetText(("%s%d / %d|r  %s"):format(hex(have >= need and C.good or C.text), math.floor(math.min(have, need)),
        math.ceil(need), ns.Describe.ItemName(item)))
    f.sub:SetText(sub or "")
    UI.SetColor(f.sub, subColor or C.muted)
    f.cost:SetText(cost and ns.Money(cost) or "")
    place(f, 2)
end

local STATUS = { done = { "done", C.good }, log = { "in your quest log", C.warn } }
local function status(s)
    local st = STATUS[s]
    return st and ("  " .. hex(st[2]) .. st[1] .. "|r") or ""
end

-- What a quest asks that you haven't got, above what the specialization's own quest asks (said at the top): "Needs
-- level 50 (you're 42)."
local function needs(q, state, data, guide)
    local parts = {}
    if q.reqLevel and q.reqLevel > state.level and q.reqLevel > (guide.level or 0) then
        parts[#parts + 1] = ("level %d (you're %d)"):format(q.reqLevel, state.level)
    end
    if q.skill and q.skill > state.skill and q.skill > (guide.skill or 0) then
        parts[#parts + 1] = ("%s %d (you have %d)"):format(data.name, q.skill, state.skill)
    end
    if #parts > 0 then line("Needs " .. table.concat(parts, " and ") .. ".", C.bad) end
end

-- Who gives the quest (several givers on your side: any of them) and who it's handed in to, when that's another NPC.
local function questGivers(data, st)
    local seen, ender = {}, false
    for _, q in ipairs(st.quests) do ender = ender or data.quests[q].ender ~= nil end
    local function once(npc, action, right)
        if npc and not seen[npc] then
            seen[npc] = true
            npcRow(npc, action, right)
        end
    end
    -- one of several givers is enough: the first, "or" the others
    local first = true
    for _, q in ipairs(st.quests) do
        once(data.quests[q].giver, not first and "Or take it here instead:"
            or ender and "Take the quest:" or "Take and hand in the quest:")
        first = false
    end
    for _, q in ipairs(st.quests) do once(data.quests[q].ender, "Hand it in:") end
end

-- An item a quest asks for: how many you have, and the rest made or bought, whichever costs less.
local function questItem(e)
    local short = e.n - e.have
    if short <= 0 then
        itemRow(e.item, e.have, e.n, "you have them all", C.good)
        return
    end
    local buy = e.buy and ("auction house %s"):format(ns.Money(e.buy)) or "none at the auction house"
    if e.how == "make" and not e.make then
        itemRow(e.item, e.have, e.n, ("Make %d; some of its ingredients have no price; %s"):format(short, buy), C.warn)
    elseif e.how == "make" then
        itemRow(e.item, e.have, e.n, ("Make %d for %s; %s"):format(short, ns.Money(e.make), buy), C.good, e.make)
    elseif e.how == "buy" then
        itemRow(e.item, e.have, e.n, ("Buy %d: %s%s"):format(short, buy,
            e.make and (", making them costs " .. ns.Money(e.make)) or ""), C.text, e.buy)
    elseif e.drops then
        local who = {}
        for _, npc in ipairs(e.drops) do
            local name, where = ns.Describe.NPC(npc)
            who[#who + 1] = name .. (where and (" (" .. where .. ")") or "")
        end
        itemRow(e.item, e.have, e.n, "Drops from " .. table.concat(who, ", "), C.warn)
    else
        itemRow(e.item, e.have, e.n, (e.dropsN and ("Drops from %d kinds of creatures; "):format(e.dropsN) or "")
            .. "none at the auction house now", C.warn)
    end
end

-- A recipe a step makes something with: known, or how to learn it (its vendors, the trainers that alone teach it).
local function recipeLine(data, state, r)
    local way, rec = r.way, r.rec
    if way and way.kind == "known" then
        line(rec.name .. ": " .. hex(C.good) .. "you know it|r", C.text)
        return
    end
    local late = rec.learn > state.skill and (hex(C.bad) .. (", learned at %d"):format(rec.learn) .. "|r") or ""
    if not way then
        local drops
        for _, g in ipairs(rec.get) do drops = drops or (g.kind == "drop" and g.npcs) end
        line("Learn " .. rec.name .. ": " .. hex(C.bad) .. (drops and ("its recipe drops from %d kinds of creatures, none at the"
            .. " auction house now"):format(drops) or "no way to learn it for you now") .. "|r" .. late, C.text)
        return
    end
    line("Learn " .. rec.name .. ": " .. ns.Describe.Learn(way, data) .. late, C.text)
    if way.kind == "vendor" then
        for _, v in ipairs(ns.Describe.Vendors(data, r.spell, state.faction)) do
            npcRow(v.npc, "Buy the recipe:", ns.Describe.Price(v.cost or 0, v.costGuess))
        end
    elseif way.kind == "trainer" and rec.trainers then
        for _, npc in ipairs(rec.trainers) do
            local n = data.npcs[npc]
            if n and n.faction:find(state.faction, 1, true) then npcRow(npc, "Learn it from the trainer:") end
        end
    end
    -- a trainer's skill worked out from Classic's: said nowhere else in this view, as every recipe here would say it
    local why = (rec.guess or way.kind ~= "trainer") and ns.Describe.Unconfirmed(rec, way)
    if why then line(why, C.dim) end
end

-- What a quest step still needs: the items, what to make and what to buy.
local function questNeeds(data, st, lookup)
    if #st.items == 0 then return end
    local q = data.quests[st.quest]
    line(("Bring to %s:"):format(q.enderName or q.giverName or "the quest giver"), C.gold)
    for _, e in ipairs(st.items) do questItem(e) end
    local made = {}
    for item, m in pairs(st.made) do
        made[#made + 1] = ("%s%d %s%s"):format(m.mining and "smelt " or "", m.n, ns.Describe.ItemName(item),
            m.have > 0 and (" (besides the " .. m.have .. " you have)") or "")
    end
    if #made > 0 then
        table.sort(made)
        line("Make: " .. table.concat(made, ", "), C.text)
    end
    local mats = {}
    for item, m in pairs(st.mats) do mats[#mats + 1] = item end
    if #mats == 0 then return end
    table.sort(mats, function(a, b) return ns.Describe.ItemName(a) < ns.Describe.ItemName(b) end)
    line("Ingredients:", C.gold)
    for _, item in ipairs(mats) do
        local m = st.mats[item]
        local sub = m.buy > 0 and (("buy %d: "):format(math.ceil(m.buy - 1e-9)) .. ns.Describe.PriceSource(lookup(item)))
            or "you have them all"
        itemRow(item, m.have, m.need, sub, m.buy > 0 and (m.noPrice and C.bad or C.muted) or C.good,
            m.buy > 0 and not m.noPrice and m.cost or nil)
    end
end

local function renderStep(data, state, guide, i, st, lookup)
    if st.kind == "talk" then
        local name = st.npc and ns.Describe.NPC(st.npc) or "the smith"
        section(("%d. Talk to %s"):format(i, name) .. status(st.status))
        if st.status ~= "done" then
            if st.note then line(st.note, C.text) end
            if st.npc then npcRow(st.npc, "Talk to:") end
        end
    elseif st.kind == "pick" then
        section(("%d. Master a weapon: one of them"):format(i) .. status(st.status))
        if st.status == "done" then return end
        for _, o in ipairs(st.options) do
            local q = data.quests[o.quest]
            line(("%s: the quest %s"):format(data.specs[o.spec] or "", q.name) .. status(o.status), C.gold)
            if o.status ~= "done" then
                needs(q, state, data, guide)
                questGivers(data, o)
                for _, e in ipairs(o.items) do questItem(e) end
            end
        end
        if st.note then line(st.note, C.muted) end
    else
        local q = data.quests[st.quest]
        section(("%d. %s"):format(i, q.name) .. status(st.status))
        if st.status == "done" then return end
        needs(q, state, data, guide)
        questGivers(data, st)
        if st.note then line(st.note, C.muted) end
        questNeeds(data, st, lookup)
    end
end

-- The recipes the steps still to do make things with, before the steps: known, or how to learn them.
-- It folds (saved for the profession: prof[key].specRecipesFolded); folded, its heading says how many are left to learn.
local function recipesStep(data, state, plan)
    local toLearn = 0
    for _, r in ipairs(plan.recipes) do
        if not (r.way and (r.way.kind == "known" or r.way.kind == "start")) then toLearn = toLearn + 1 end
    end
    local saved = ns.Player.Prof(data)
    local shut = saved.specRecipesFolded == true
    foldSection("The recipes" .. (toLearn == 0 and status("done") or "")
        .. (shut and toLearn > 0 and (hex(C.muted) .. ("  %d to learn"):format(toLearn) .. "|r") or ""), shut,
        { "The recipes", "Click to fold or open." }, function()
            saved.specRecipesFolded = not shut or nil
            ns.Window.Refresh(true)
        end)
    if shut then return end
    for _, r in ipairs(plan.recipes) do recipeLine(data, state, r) end
end

-- Draws the shown profession's specialization (Window.Refresh calls it in its place of the ladder). Returns the
-- footer's text.
function SpecPanel.Render(ladder, data)
    local state = ladder.state
    local guide = ns.Spec.Guide(data, state.specs)
    local quote, lookup = ns.Prices.ForGame()
    local plan = ns.Spec.Plan(data, guide, state, quote)
    local name = data.specs[guide.spec]
    -- the specializations, left to right: "Weaponsmith", "Gnomish", "Dragonscale"
    local x = 0
    for i, b in ipairs(panel.guides) do
        local g = data.specGuides[i]
        b:SetShown(g ~= nil)
        if g then
            b.data, b.guide = data, g
            b.label:SetText((data.specs[g.spec]:gsub(" Leatherworking$", ""):gsub(" Engineer$", "")))
            b:SetWidth(math.max(70, b.label:GetStringWidth() + 20))
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", x, 0)
            x = x + b:GetWidth() + 4
            b:SetActive(g == guide)
            b.tooltip = { data.specs[g.spec], ("Show the steps to %s."):format(data.specs[g.spec]) }
        end
    end
    for _, p in pairs(pools) do p:ReleaseAll() end
    cw = frame:GetWidth() - left - 12 - 14 - 12 -- the list's and the panel's insets, room for the scroll bar
    y = 0

    section(name .. (plan.have and status("done") or ""))
    if plan.have then
        line("You have this specialization.", C.good)
    else
        local short = state.level < (guide.level or 0) or state.skill < (guide.skill or 0)
        line(("Needs level %d and %s %d; you're level %d with %d."):format(guide.level or 0, data.name,
            guide.skill or 0, state.level, state.skill), short and C.bad or C.good)
    end
    line(("Unlocks %d recipes only this specialization can learn."):format(ns.Spec.Unlocks(data, guide.spec)), C.muted)
    if plan.other then
        line(("You have %s: a character can have only one %s specialization."):format(data.specs[plan.other.spec],
            data.name), C.warn)
    end
    if guide.note then line(guide.note, C.muted) end
    if not plan.have then
        line(("Still to spend: %s, each item made or bought, whichever costs less%s."):format(ns.Money(plan.cost),
            plan.noPrice and (hex(C.bad) .. "; some have no price|r") or ""), C.text)
    end
    if #plan.recipes > 0 then recipesStep(data, state, plan) end
    for i, st in ipairs(plan.steps) do renderStep(data, state, guide, i, st, lookup) end
    panel.scroll:SetContentHeight(y + 8)
    if guide ~= shownGuide then panel.scroll:ScrollToTop() end
    shownGuide = guide
    if plan.have then return ("You have %s"):format(name) end
    return ("To %s: about %s%s"):format(name, ns.Money(plan.cost), plan.noPrice and ", some items unpriced" or "")
end

-- The panel, in the window's list (UI/Window.lua's build calls it): left = where the list starts in the window;
-- zoom = Ctrl + mouse wheel's scaling.
function SpecPanel.Build(f, listLeft, zoom)
    frame, left = f, listLeft
    panel = CreateFrame("Frame", nil, f.list)
    panel:SetPoint("TOPLEFT", 12, -32)
    panel:SetPoint("BOTTOMRIGHT", -6, 8)
    panel.guides = {}
    for i = 1, 3 do -- Leatherworking has three
        panel.guides[i] = UI.Button(panel, "", 90, 20, function(self)
            ns.Player.Prof(self.data).spec = self.guide.spec
            ns.Window.Refresh(true)
        end)
    end
    panel.scroll = UI.Scroll(panel)
    panel.scroll.onCtrlWheel = zoom
    panel.scroll:SetPoint("TOPLEFT", 0, -26)
    panel.scroll:SetPoint("BOTTOMRIGHT", 0, 0)
    pools = {}
    for kind, make in pairs(ns.Cards.Widgets) do pools[kind] = UI.Pool(make) end
    pools.fold = UI.Pool(makeFold)
    panel:Hide()
    f.spec = panel
end
