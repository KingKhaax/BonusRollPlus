local ADDON, ns = ...
local L = ns.L

local WHITE = "Interface\\Buttons\\WHITE8X8"
local F_FRIZ = "Fonts\\FRIZQT__.TTF"
local F_MORPH = "Fonts\\MORPHEUS.TTF"
local LOCALE_FONT = { ruRU = true, koKR = true, zhCN = true, zhTW = true }

local BG, EDGE, ACCENT, SOFT = "#1A1A1A", "#000000", "#1784D1", "#A0A0A0"
local PANEL, DARK, LINE = "#262626", "#0F0F0F", "#3A3A3A"

local CHANGES = {
    {
        v = "0.6.0", d = "13/11/2026",
        en = {
            "Vendor or auction value on every roll (TradeSkillMaster prices when you have it), with a purple * when the item has an appearance you do not own.",
            "New History tab with statistics: rolls joined, rolls won, Need and Greed wins and the last 7 days.",
            "Profiles can also load automatically per specialization.",
            "Optional sound and flashing alerts, and a setting for how many seconds the window stays after the winner is announced.",
            "Designs reduced from 20 to the 10 best finished ones, and the settings window opens faster.",
            "Fixed: when two or more items dropped at once, one of the roll windows could be missing.",
        },
        es = {
            "Valor de venta o de subasta en cada tirada (precios de TradeSkillMaster si lo tienes), con un * morado cuando el objeto tiene una apariencia que no posees.",
            "Nueva pestaña Historial con estadísticas: tiradas en las que has participado, ganadas, con Necesidad y con Codicia, y los últimos 7 días.",
            "Los perfiles también se pueden cargar automáticamente por especialización.",
            "Avisos opcionales de sonido y parpadeo, y un ajuste con los segundos que se queda la ventana tras anunciarse el ganador.",
            "Los diseños pasan de 20 a los 10 mejor acabados, y la ventana de ajustes abre más rápido.",
            "Corregido: cuando caían dos o más objetos a la vez, podía faltar una de las ventanas de tirada.",
        },
    },
    {
        v = "0.5.0", d = "13/11/2026",
        en = {
            "Settings window (/br open, or \"Open settings\" in the game's AddOns options) with 20 window designs and a live preview of each one. The default is still the frosted glass.",
            "Window size, opacity, number of visible windows, rolls list and a lockable position: drag the test windows, lock them and they stay there for future loot.",
            "At most 3 windows at once; the rest wait and appear as soon as one closes.",
            "Item level difference against what you wear, a warning when you cannot use an item, compact rows for rolls waiting their turn, a roll history (/br history) and profiles with export and import.",
            "Padlock on each window and /br lock.",
            "Class icon next to each player's name in the rolls list.",
            "Update notice between players, and every text translated into the 11 languages of the game.",
            "A random World of Warcraft fact in the footer of the settings window, different every time you open it.",
        },
        es = {
            "Ventana de ajustes (/br open, o \"Abrir ajustes\" en las opciones de AddOns del juego) con 20 diseños de ventana y vista previa de cada uno. El predeterminado sigue siendo el cristal esmerilado.",
            "Tamaño de la ventana, opacidad, ventanas visibles, lista de tiradas y posición bloqueable: arrastra las ventanas de prueba, bloquéalas y se quedan ahí para el botín futuro.",
            "Máximo de 3 ventanas a la vez; las demás esperan y aparecen en cuanto se cierra una.",
            "Diferencia de nivel de objeto con lo que llevas puesto, aviso cuando no puedes usar un objeto, filas compactas para las tiradas que esperan turno, historial de tiradas (/br history) y perfiles con exportar e importar.",
            "Candado en cada ventana y /br lock.",
            "Icono de clase junto al nombre de cada jugador en la lista de tiradas.",
            "Aviso de actualización entre jugadores y todos los textos traducidos a los 11 idiomas del juego.",
            "Dato curioso aleatorio de World of Warcraft en el pie de la ventana de ajustes, distinto cada vez que la abres.",
        },
    },
    {
        v = "0.4.0", d = "12/11/2026",
        en = { "First version published on CurseForge." },
        es = { "Primera versión publicada en CurseForge." },
    },
    {
        v = "0.1.0", d = "12/11/2026",
        en = { "First version: the roll window with item level, armor slot and a live list of everyone's rolls." },
        es = { "Primera versión: la ventana de tirada con nivel de objeto, pieza de armadura y lista de tiradas de todos en directo." },
    },
}

local function Hex(h, a)
    local r, g, b = h:match("#?(%x%x)(%x%x)(%x%x)")
    return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, a or 1
end

local function Solid(parent, layer, hex, a, sub)
    local t = parent:CreateTexture(nil, layer, nil, sub or 0)
    t:SetColorTexture(Hex(hex, a))
    return t
end

local function Edges(f, hex, a, layer)
    local t = {}
    for i = 1, 4 do t[i] = Solid(f, layer or "BORDER", hex, a) end
    t[1]:SetPoint("TOPLEFT"); t[1]:SetPoint("TOPRIGHT"); t[1]:SetHeight(1)
    t[2]:SetPoint("BOTTOMLEFT"); t[2]:SetPoint("BOTTOMRIGHT"); t[2]:SetHeight(1)
    t[3]:SetPoint("TOPLEFT"); t[3]:SetPoint("BOTTOMLEFT"); t[3]:SetWidth(1)
    t[4]:SetPoint("TOPRIGHT"); t[4]:SetPoint("BOTTOMRIGHT"); t[4]:SetWidth(1)
    return t
end

local function SetEdges(t, hex, a)
    for i = 1, 4 do t[i]:SetColorTexture(Hex(hex, a)) end
end

local function Font(fs, size, hex, morph)
    local path = "Fonts/ARIALN.TTF"
    if LOCALE_FONT[ns.locale] then path = STANDARD_TEXT_FONT end
    if not fs:SetFont(path, size, "") then fs:SetFont(STANDARD_TEXT_FONT, size, "") end
    fs:SetTextColor(Hex(hex or "#FFFFFF"))
end

local function Label(parent, text, size, hex, morph)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    Font(fs, size, hex, morph)
    fs:SetJustifyH("LEFT")
    fs:SetText(text or "")
    return fs
end

local function MakeButton(parent, text, w, h, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    b.bg = Solid(b, "BACKGROUND", PANEL, 1)
    b.bg:SetAllPoints()
    b.edges = Edges(b, EDGE, 1)
    b.hl = b:CreateTexture(nil, "HIGHLIGHT")
    b.hl:SetColorTexture(Hex(ACCENT, 0.3))
    b.hl:SetAllPoints()
    b.fs = Label(b, text, 12, "#FFFFFF")
    b.fs:SetPoint("CENTER")
    b.fs:SetWidth(w - 8)
    b.fs:SetJustifyH("CENTER")
    b:SetScript("OnClick", onClick)
    function b:SetActive(on)
        self.bg:SetColorTexture(Hex(on and ACCENT or PANEL, 1))
    end
    return b
end

local function MakeCheck(parent, text, get, set)
    local c = CreateFrame("Button", nil, parent)
    c:SetSize(300, 22)
    c.box = CreateFrame("Frame", nil, c)
    c.box:SetSize(16, 16)
    c.box:SetPoint("LEFT", 0, 0)
    Solid(c.box, "BACKGROUND", DARK, 1):SetAllPoints()
    Edges(c.box, EDGE, 1)
    c.mark = Solid(c.box, "ARTWORK", ACCENT, 1)
    c.mark:SetPoint("TOPLEFT", 3, -3)
    c.mark:SetPoint("BOTTOMRIGHT", -3, 3)
    c.fs = Label(c, text, 13, "#E8E8E8")
    c.fs:SetPoint("LEFT", c.box, "RIGHT", 8, 0)
    function c:Refresh() self.mark:SetShown(get() and true or false) end
    c:SetScript("OnClick", function(self)
        set(not get())
        self:Refresh()
    end)
    c:SetScript("OnShow", c.Refresh)
    return c
end

local function MakeSlider(parent, text, min, max, step, get, set, fmt)
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetSize(420, 40)
    holder.fs = Label(holder, text, 13, "#FFFFFF")
    holder.fs:SetPoint("TOPLEFT", 0, 0)
    holder.val = Label(holder, "", 13, ACCENT)
    holder.val:SetPoint("TOPRIGHT", 0, 0)
    holder.val:SetJustifyH("RIGHT")
    local s = CreateFrame("Slider", nil, holder)
    s:SetOrientation("HORIZONTAL")
    s:SetSize(420, 14)
    s:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, -20)
    s:SetMinMaxValues(min, max)
    s:SetValueStep(step)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    local edge = Solid(s, "BACKGROUND", EDGE, 1)
    edge:SetPoint("LEFT")
    edge:SetPoint("RIGHT")
    edge:SetHeight(10)
    local track = Solid(s, "BORDER", DARK, 1)
    track:SetPoint("LEFT", 1, 0)
    track:SetPoint("RIGHT", -1, 0)
    track:SetHeight(8)
    local fill = Solid(s, "ARTWORK", ACCENT, 1)
    fill:SetPoint("LEFT", 2, 0)
    fill:SetHeight(6)
    s:SetThumbTexture(WHITE)
    local thumb = s:GetThumbTexture()
    thumb:SetSize(3, 14)
    thumb:SetVertexColor(Hex("#E8E8E8"))
    s:SetScript("OnValueChanged", function(self, v)
        v = math.floor(v / step + 0.5) * step
        fill:SetWidth(math.max(1, (self:GetWidth() - 4) * (v - min) / (max - min)))
        holder.val:SetText(fmt and fmt(v) or tostring(v))
        if not holder.syncing then set(v) end
    end)
    function holder:Refresh()
        self.syncing = true
        s:SetValue(get())
        self.val:SetText(fmt and fmt(get()) or tostring(get()))
        self.syncing = false
    end
    holder:SetScript("OnShow", holder.Refresh)
    return holder
end

local function MakeTestToggle(parent, w, h, onStart)
    local b
    b = MakeButton(parent, L.TEST_BTN, w, h, function()
        if ns.TestActive() then
            ns.EndTest()
        else
            if onStart then onStart() end
            ns.RunTest()
        end
        b:Sync()
    end)
    function b:Sync()
        self.fs:SetText(ns.TestActive() and L.HIDE_TEST_BTN or L.TEST_BTN)
    end
    local waited = 0
    b:SetScript("OnUpdate", function(self, elapsed)
        waited = waited + elapsed
        if waited > 0.3 then
            waited = 0
            self:Sync()
        end
    end)
    b:SetScript("OnShow", b.Sync)
    return b
end

local function MakeScroll(parent, w, h)
    local sf = CreateFrame("ScrollFrame", nil, parent)
    sf:SetSize(w, h)
    local child = CreateFrame("Frame", nil, sf)
    child:SetSize(w, 10)
    sf:SetScrollChild(child)
    local bar = CreateFrame("Slider", nil, parent)
    bar:SetOrientation("VERTICAL")
    bar:SetSize(8, h)
    bar:SetPoint("TOPLEFT", sf, "TOPRIGHT", 4, 0)
    local track = Solid(bar, "BACKGROUND", DARK, 1)
    track:SetAllPoints()
    bar:SetThumbTexture(WHITE)
    bar:GetThumbTexture():SetSize(8, 36)
    bar:GetThumbTexture():SetVertexColor(Hex(ACCENT))
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)
    local range = 0
    bar:SetScript("OnValueChanged", function(_, v) sf:SetVerticalScroll(v) end)
    function sf:Sync(contentH)
        child:SetHeight(contentH)
        range = math.max(0, contentH - h)
        bar:SetMinMaxValues(0, math.max(range, 1))
        bar:SetValue(0)
        bar:SetShown(range > 0)
        sf:SetVerticalScroll(0)
    end
    sf:EnableMouseWheel(true)
    sf:SetScript("OnMouseWheel", function(_, delta)
        bar:SetValue(math.max(0, math.min(range, bar:GetValue() - delta * 48)))
    end)
    sf.bar = bar
    return sf, child
end

local function TitleOf(T)
    if ns.locale:find("^es") then return T.titleES or T.title end
    if T.id == "glass" then return "Frosted Glass" end
    return T.title
end

local win, tabs, tabButtons, previewsBuilt, cells = nil, {}, {}, false, {}

local function RefreshCells()
    local db = ns.GetDB()
    for _, c in ipairs(cells) do
        local on = db.theme == c.T.id
        SetEdges(c.edges, on and ACCENT or LINE, 1)
        c.bg:SetColorTexture(Hex(on and ACCENT or "#FFFFFF", on and 0.16 or 0.04))
        c.badge:SetShown(on)
        c.name:SetTextColor(Hex(on and "#FFFFFF" or SOFT))
    end
end

local function BuildDesigns(tab)
    local hint = Label(tab, L.DESIGN_HINT, 14, "#4DA8F0")
    hint:SetPoint("TOPLEFT", 2, -2)
    hint:SetWidth(584)
    hint:SetWordWrap(true)
    local testBtn = MakeTestToggle(tab, 220, 22)
    testBtn:SetPoint("TOPRIGHT", 0, -22)
    local sf, child = MakeScroll(tab, 584, 404)
    sf:SetPoint("TOPLEFT", 0, -54)
    tab.sf, tab.child = sf, child
    local scale = 0.56
    local rows = math.ceil(#ns.ThemeList / 3)
    sf:Sync(rows * 198 + 8)
    local function BuildNext(i)
        local T = ns.ThemeList[i]
        if not T then return end
        local col, row = (i - 1) % 3, math.floor((i - 1) / 3)
        local c = CreateFrame("Button", nil, child)
        c:SetSize(186, 192)
        c:SetPoint("TOPLEFT", child, "TOPLEFT", 4 + col * 194, -(4 + row * 198))
        c.T = T
        c.bg = Solid(c, "BACKGROUND", "#FFFFFF", 0.04)
        c.bg:SetAllPoints()
        c.edges = Edges(c, LINE, 1)
        local pv = ns.BuildPreview(T, c)
        pv:SetScale(scale)
        pv:SetPoint("TOPLEFT", c, "TOPLEFT", 9 / scale, -6 / scale)
        c.name = Label(c, ((ns.ThemeNames[ns.locale] or ns.ThemeNames.enUS)[i] or T.title) .. (i == 1 and ("\n|cff1784D1(" .. L.DEFAULT_TAG .. ")|r") or ""), 13, SOFT)
        c.name:SetPoint("TOP", c, "TOP", 0, -158)
        c.name:SetWidth(176)
        c.name:SetJustifyH("CENTER")
        local top = CreateFrame("Frame", nil, c)
        top:SetAllPoints()
        top:SetFrameLevel(pv:GetFrameLevel() + 40)
        c.badge = CreateFrame("Frame", nil, top)
        c.badge:SetSize(70, 18)
        c.badge:SetPoint("TOPLEFT", 6, -6)
        Solid(c.badge, "BACKGROUND", DARK, 1):SetAllPoints()
        Edges(c.badge, ACCENT, 1)
        local bt = Label(c.badge, L.SELECTED, 11, ACCENT)
        bt:SetPoint("CENTER")
        bt:SetJustifyH("CENTER")
        c:SetScript("OnClick", function()
            ns.ApplyTheme(T.id)
            RefreshCells()
        end)
        c:SetScript("OnEnter", function(self) if ns.GetDB().theme ~= T.id then SetEdges(self.edges, ACCENT, 0.6) end end)
        c:SetScript("OnLeave", function() RefreshCells() end)
        cells[#cells + 1] = c
        RefreshCells()
    end
    tab.BuildAll = function()
        if previewsBuilt then return end
        previewsBuilt = true
        local built = 0
        local function Step()
            for _ = 1, 3 do
                built = built + 1
                if ns.ThemeList[built] then BuildNext(built) end
            end
            if built < #ns.ThemeList then C_Timer.After(0, Step) end
        end
        Step()
    end
end

local function BuildSettings(tab)
    local db = ns.GetDB
    local y = 0
    local function Place(w, gap)
        w:SetPoint("TOPLEFT", tab, "TOPLEFT", 8, -y)
        y = y + (gap or 42)
    end
    tab.widgets = {}
    local function Add(w, gap)
        Place(w, gap)
        tab.widgets[#tab.widgets + 1] = w
        return w
    end
    Add(MakeSlider(tab, L.SCALE, 0.5, 1.5, 0.05,
        function() return db().scale end,
        function(v) ns.SetScale(v) end,
        function(v) return string.format("%d%%", math.floor(v * 100 + 0.5)) end))
    Add(MakeSlider(tab, L.OPACITY, 0.3, 1, 0.05,
        function() return db().alpha end,
        function(v) ns.SetAlpha(v) end,
        function(v) return string.format("%d%%", math.floor(v * 100 + 0.5)) end))
    Add(MakeSlider(tab, L.MAX_WINDOWS, 1, 5, 1,
        function() return db().maxVisible end,
        function(v) ns.SetMaxVisible(v) end))
    Add(MakeSlider(tab, L.CLOSE_DELAY, 0, 15, 1,
        function() return db().closeDelay end,
        function(v) ns.SetCloseDelay(v) end,
        function(v) return string.format("%ds", v) end))
    Add(MakeCheck(tab, L.SHOW_ROLLS,
        function() return db().showRolls end,
        function(v) ns.SetShowRolls(v) end), 24)
    local lock
    lock = Add(MakeCheck(tab, L.LOCK,
        function() return db().locked end,
        function(v) ns.SetLocked(v) end), 24)
    Add(MakeCheck(tab, L.SHOW_UPGRADE,
        function() return db().showUpgrade end,
        function(v) ns.SetShowUpgrade(v) end), 24)
    Add(MakeCheck(tab, L.COMPACT_ROWS,
        function() return db().compact end,
        function(v) ns.SetCompact(v) end), 24)
    Add(MakeCheck(tab, L.SHOW_VALUE,
        function() return db().showValue end,
        function(v) ns.SetOption("showValue", v) end), 24)
    Add(MakeCheck(tab, L.SOUND_ALERT,
        function() return db().sound end,
        function(v) ns.SetOption("sound", v) end), 24)
    Add(MakeCheck(tab, L.FLASH_ALERT,
        function() return db().flash end,
        function(v) ns.SetOption("flash", v) end), 34)
    local b1 = MakeTestToggle(tab, 230, 26, function()
        ns.SetLocked(false)
        lock:Refresh()
    end)
    local b3 = MakeButton(tab, L.RESET_POS, 150, 26, function() ns.ResetPosition() end)
    local b4 = MakeButton(tab, L.HISTORY_BTN, 170, 26, function() ns.PrintHistory(10) end)
    b1:SetPoint("TOPLEFT", 8, -y)
    b3:SetPoint("LEFT", b1, "RIGHT", 8, 0)
    b4:SetPoint("LEFT", b3, "RIGHT", 8, 0)
    y = y + 36
    local hint = Label(tab, L.MOVE_HINT, 12, SOFT)
    hint:SetPoint("TOPLEFT", 8, -y)
    hint:SetWidth(560)
    hint:SetWordWrap(true)
    y = y + 44
    local reset = MakeButton(tab, L.RESET_ALL, 200, 26, function()
        local d, def = ns.GetDB(), ns.GetDefaults()
        for k, v in pairs(def) do d[k] = v end
        ns.ResetPosition()
        ns.SetScale(d.scale)
        ns.SetAlpha(d.alpha)
        ns.SetLocked(false)
        ns.SetShowRolls(true)
        ns.SetMaxVisible(d.maxVisible)
        ns.SetCompact(d.compact)
        ns.SetShowUpgrade(d.showUpgrade)
        ns.SetOption("showValue", d.showValue)
        ns.ApplyTheme(d.theme)
        for _, w in ipairs(tab.widgets) do w:Refresh() end
        RefreshCells()
    end)
    reset:SetPoint("TOPLEFT", 8, -y)
    tab.Refresh = function()
        for _, w in ipairs(tab.widgets) do w:Refresh() end
    end
end

local function RefreshAllTabs()
    if tabs[2] and tabs[2].Refresh then tabs[2].Refresh() end
    RefreshCells()
end

local function BuildProfiles(tab)
    local P = ns.Profiles
    local entries, index = { false }, 1
    local status

    local function Rebuild()
        entries = { false }
        for _, name in ipairs(P.Names()) do entries[#entries + 1] = name end
        local active = ns.GetDB().activeProfile
        index = 1
        for i, name in ipairs(entries) do
            if name == active then index = i end
        end
    end

    local function Say(text, hex)
        status:SetText(text or "")
        status:SetTextColor(Hex(hex or "#4FE3C1"))
    end

    local nameText
    local useCheck, specCheck
    local function Refresh()
        Rebuild()
        nameText:SetText(entries[index] or L.PROFILE_NONE)
        useCheck:Refresh()
        if specCheck then specCheck:Refresh() end
        tab.update:SetAlpha(entries[index] and 1 or 0.4)
        tab.delete:SetAlpha(entries[index] and 1 or 0.4)
    end

    local function Select(i)
        if i < 1 then i = #entries elseif i > #entries then i = 1 end
        index = i
        local name = entries[index]
        if name and P.Load(name) then
            Say(string.format(L.PROFILE_LOADED, name))
            RefreshAllTabs()
        end
        nameText:SetText(name or L.PROFILE_NONE)
        useCheck:Refresh()
        if specCheck then specCheck:Refresh() end
        tab.update:SetAlpha(name and 1 or 0.4)
        tab.delete:SetAlpha(name and 1 or 0.4)
    end

    local title = Label(tab, L.PROFILE_LABEL, 14, "#FFFFFF")
    title:SetPoint("TOPLEFT", 8, -4)
    local prev = MakeButton(tab, "<", 30, 26, function() Select(index - 1) end)
    prev:SetPoint("TOPLEFT", 8, -28)
    local box = CreateFrame("Frame", nil, tab)
    box:SetSize(360, 26)
    box:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    Solid(box, "BACKGROUND", DARK, 1):SetAllPoints()
    Edges(box, EDGE, 1)
    nameText = Label(box, "", 14, ACCENT)
    nameText:SetPoint("CENTER")
    nameText:SetWidth(340)
    nameText:SetJustifyH("CENTER")
    local nextb = MakeButton(tab, ">", 30, 26, function() Select(index + 1) end)
    nextb:SetPoint("LEFT", box, "RIGHT", 6, 0)

    local save = MakeButton(tab, L.PROFILE_NEW, 190, 26, function()
        local name = P.Save(P.NewName())
        Refresh()
        Say(string.format(L.PROFILE_SAVED, name))
    end)
    save:SetPoint("TOPLEFT", 8, -74)
    tab.update = MakeButton(tab, L.PROFILE_UPDATE, 170, 26, function()
        local name = entries[index]
        if name then
            P.Save(name)
            Say(string.format(L.PROFILE_SAVED, name))
        end
    end)
    tab.update:SetPoint("LEFT", save, "RIGHT", 8, 0)
    tab.delete = MakeButton(tab, L.PROFILE_DELETE, 140, 26, function()
        local name = entries[index]
        if name then
            P.Delete(name)
            Refresh()
            Say(string.format(L.PROFILE_DELETED, name))
        end
    end)
    tab.delete:SetPoint("LEFT", tab.update, "RIGHT", 8, 0)

    useCheck = MakeCheck(tab, L.PROFILE_THISCHAR,
        function()
            local name = entries[index]
            return name and P.AssignedHere() == name
        end,
        function(v)
            local name = entries[index]
            if name then P.UseOnThisCharacter(v and name or nil) end
        end)
    useCheck:SetSize(560, 22)
    useCheck:SetPoint("TOPLEFT", 8, -122)
    specCheck = MakeCheck(tab, L.PROFILE_THISSPEC,
        function()
            local name = entries[index]
            return name and P.AssignedForSpec() == name
        end,
        function(v)
            local name = entries[index]
            if name then P.UseOnThisSpec(v and name or nil) end
        end)
    specCheck:SetSize(560, 22)
    specCheck:SetPoint("TOPLEFT", 8, -148)
    specCheck:SetShown(P.SpecAvailable())

    local dlg
    local function Dialog(mode)
        if not dlg then
            dlg = CreateFrame("Frame", nil, win)
            dlg:SetSize(560, 210)
            dlg:SetPoint("CENTER", win, "CENTER", 0, 0)
            dlg:SetFrameLevel(win:GetFrameLevel() + 60)
            dlg:EnableMouse(true)
            Solid(dlg, "BACKGROUND", BG, 1):SetAllPoints()
            Edges(dlg, EDGE, 1)
            local ring = CreateFrame("Frame", nil, dlg)
            ring:SetPoint("TOPLEFT", -1, 1)
            ring:SetPoint("BOTTOMRIGHT", 1, -1)
            Edges(ring, LINE, 1)
            dlg.help = Label(dlg, "", 14, "#FFFFFF")
            dlg.help:SetPoint("TOPLEFT", 22, -18)
            dlg.help:SetWidth(516)
            local back = CreateFrame("Frame", nil, dlg)
            back:SetPoint("TOPLEFT", 20, -48)
            back:SetSize(520, 96)
            Solid(back, "BACKGROUND", DARK, 1):SetAllPoints()
            Edges(back, EDGE, 1)
            local eb = CreateFrame("EditBox", nil, dlg)
            eb:SetMultiLine(true)
            eb:SetAutoFocus(false)
            eb:SetSize(508, 88)
            eb:SetPoint("TOPLEFT", back, "TOPLEFT", 6, -4)
            eb:SetTextInsets(2, 2, 2, 2)
            eb:SetFont(LOCALE_FONT[ns.locale] and STANDARD_TEXT_FONT or "Fonts/ARIALN.TTF", 13, "")
            eb:SetTextColor(Hex("#E8E8E8"))
            eb:SetScript("OnEscapePressed", function() dlg:Hide() end)
            dlg.edit = eb
            dlg.msg = Label(dlg, "", 13, "#FF5555")
            dlg.msg:SetPoint("TOPLEFT", 22, -152)
            dlg.msg:SetWidth(516)
            dlg.close = MakeButton(dlg, L.CLOSE, 120, 26, function() dlg:Hide() end)
            dlg.close:SetPoint("BOTTOMRIGHT", -20, 14)
            dlg.go = MakeButton(dlg, L.PROFILE_IMPORT, 140, 26, function()
                local name = P.Import(dlg.edit:GetText())
                if name then
                    dlg:Hide()
                    Refresh()
                    RefreshAllTabs()
                    Say(L.IMPORT_OK)
                else
                    dlg.msg:SetText(L.IMPORT_BAD)
                end
            end)
            dlg.go:SetPoint("RIGHT", dlg.close, "LEFT", -8, 0)
        end
        dlg.msg:SetText("")
        if mode == "export" then
            dlg.help:SetText(L.EXPORT_HELP)
            dlg.edit:SetText(P.Export())
            dlg.go:Hide()
        else
            dlg.help:SetText(L.IMPORT_HELP)
            dlg.edit:SetText("")
            dlg.go:Show()
        end
        dlg:Show()
        dlg.edit:SetFocus()
        if mode == "export" then dlg.edit:HighlightText() end
    end

    local exp = MakeButton(tab, L.PROFILE_EXPORT, 150, 26, function() Dialog("export") end)
    exp:SetPoint("TOPLEFT", 8, -190)
    local imp = MakeButton(tab, L.PROFILE_IMPORT, 150, 26, function() Dialog("import") end)
    imp:SetPoint("LEFT", exp, "RIGHT", 8, 0)

    status = Label(tab, "", 13, "#4FE3C1")
    status:SetPoint("TOPLEFT", 8, -238)
    status:SetWidth(560)
    tab.Refresh = Refresh
end

local function BuildHistory(tab)
    local lines = {}
    for i = 1, 4 do
        lines[i] = Label(tab, "", 14, i == 1 and "#FFFFFF" or "#E8E8E8")
        lines[i]:SetPoint("TOPLEFT", 8, -(4 + (i - 1) * 22))
        lines[i]:SetWidth(560)
    end
    local sf, child = MakeScroll(tab, 584, 280)
    sf:SetPoint("TOPLEFT", 0, -104)
    local list = Label(child, "", 13, "#FFFFFF")
    list:SetPoint("TOPLEFT", 4, -4)
    list:SetWidth(560)
    list:SetWordWrap(true)
    list:SetSpacing(4)
    local show = MakeButton(tab, L.HISTORY_BTN, 220, 26, function() ns.PrintHistory(10) end)
    show:SetPoint("BOTTOMLEFT", 8, 4)
    local clear = MakeButton(tab, L.HISTORY_CLEAR_BTN, 170, 26, function()
        ns.ClearHistory()
        tab.Refresh()
    end)
    clear:SetPoint("LEFT", show, "RIGHT", 8, 0)
    tab.Refresh = function()
        local rolled, won, needWon, greedWon, week = ns.GetStats()
        local pct = rolled > 0 and math.floor(won / rolled * 100 + 0.5) or 0
        lines[1]:SetText(string.format(L.STATS_ROLLED, rolled))
        lines[2]:SetText(string.format(L.STATS_WON, won, pct))
        lines[3]:SetText(string.format(L.STATS_KINDS, needWon, greedWon))
        lines[4]:SetText(string.format(L.STATS_WEEK, week))
        local entries = ns.GetHistoryLines(30)
        list:SetText(#entries > 0 and table.concat(entries, "\n") or L.HISTORY_EMPTY)
        sf:Sync(list:GetStringHeight() + 16)
    end
end

local function BuildAbout(tab)
    local sf, child = MakeScroll(tab, 584, 440)
    sf:SetPoint("TOPLEFT", 0, 0)
    local es = ns.locale:find("^es") ~= nil
    local lines = {
        "|cffFFFFFFBonusRoll Plus|r",
        L.VERSION_LABEL .. " " .. ns.MyVersion(),
        "|cff1784D1" .. L.ABOUT_BY .. "|r",
        L.ABOUT_RIGHTS,
        "",
        "|cffFFFFFF" .. L.CHANGELOG_TITLE .. "|r",
        "",
    }
    for _, c in ipairs(CHANGES) do
        lines[#lines + 1] = "|cff1784D1" .. L.VERSION_LABEL .. " " .. c.v .. "|r  (" .. c.d .. ")"
        local tr = ns.ChangelogL and ns.ChangelogL[c.v] and ns.ChangelogL[c.v][ns.locale]
        for _, item in ipairs(tr or (es and c.es or c.en)) do lines[#lines + 1] = "- " .. item end
        lines[#lines + 1] = ""
    end
    local fs = Label(child, table.concat(lines, "\n"), 13, "#FFFFFF")
    fs:SetPoint("TOPLEFT", 4, -4)
    fs:SetWidth(560)
    fs:SetWordWrap(true)
    fs:SetSpacing(3)
    sf:Sync(fs:GetStringHeight() + 20)
end

local function ShowTab(i)
    for n, t in ipairs(tabs) do
        t:SetShown(n == i)
        tabButtons[n]:SetActive(n == i)
    end
    if i == 1 and tabs[1].BuildAll then tabs[1].BuildAll(); RefreshCells() end
    if i == 2 and tabs[2].Refresh then tabs[2].Refresh() end
    if i == 3 and tabs[3].Refresh then tabs[3].Refresh() end
    if i == 4 and tabs[4].Refresh then tabs[4].Refresh() end
end

local function Build()
    win = CreateFrame("Frame", "BonusRollPlusSettings", UIParent)
    win:SetSize(640, 600)
    win:SetPoint("CENTER")
    win:SetFrameStrata("DIALOG")
    win:SetToplevel(true)
    win:SetMovable(true)
    win:SetClampedToScreen(true)
    win:EnableMouse(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", function(self) self:StartMoving() end)
    win:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    Solid(win, "BACKGROUND", BG, 1, -8):SetAllPoints()
    Edges(win, EDGE, 1)
    local ring = CreateFrame("Frame", nil, win)
    ring:SetPoint("TOPLEFT", -1, 1)
    ring:SetPoint("BOTTOMRIGHT", 1, -1)
    Edges(ring, LINE, 1)
    local headLine = Solid(win, "BORDER", EDGE, 1)
    headLine:SetPoint("TOPLEFT", 1, -44)
    headLine:SetPoint("TOPRIGHT", -1, -44)
    headLine:SetHeight(1)
    local title = Label(win, L.SET_TITLE, 18, "#FFFFFF")
    title:SetPoint("TOPLEFT", 18, -14)
    local close = MakeButton(win, "X", 24, 22, function() win:Hide() end)
    close:SetPoint("TOPRIGHT", -10, -10)
    local names = { L.TAB_DESIGNS, L.TAB_SETTINGS, L.TAB_PROFILES, L.TAB_HISTORY, L.TAB_ABOUT }
    local area = CreateFrame("Frame", nil, win)
    area:SetPoint("TOPLEFT", 18, -84)
    area:SetPoint("BOTTOMRIGHT", -34, 56)
    for i = 1, 5 do
        local b = MakeButton(win, names[i], 120, 26, function() ShowTab(i) end)
        b:SetPoint("TOPLEFT", 18 + (i - 1) * 124, -48)
        tabButtons[i] = b
        local t = CreateFrame("Frame", nil, area)
        t:SetAllPoints()
        tabs[i] = t
    end
    BuildDesigns(tabs[1])
    BuildSettings(tabs[2])
    BuildProfiles(tabs[3])
    BuildHistory(tabs[4])
    BuildAbout(tabs[5])
    local foot = Label(win, "", 14, "#E8B04A")
    foot:SetPoint("BOTTOM", 0, 12)
    foot:SetWidth(600)
    foot:SetJustifyH("CENTER")
    foot:SetWordWrap(true)
    local lastFact
    local function NewFact()
        local list = ns.Facts
        if not list or #list == 0 then return end
        local n = math.random(#list)
        if n == lastFact and #list > 1 then n = n % #list + 1 end
        lastFact = n
        local text
        if ns.locale:find("^es") then
            text = list[n][1]
        else
            local tr = ns.FactsL and ns.FactsL[ns.locale]
            text = tr and tr[n] or list[n][2]
        end
        foot:SetText("|cff4FE3C1" .. L.FACT_PREFIX .. "|r " .. text)
    end
    win:SetScript("OnShow", function()
        ShowTab(1)
        NewFact()
    end)
    ShowTab(1)
    NewFact()
    tinsert(UISpecialFrames, "BonusRollPlusSettings")
end

function ns.OpenSettings()
    if not win then Build() end
    win:Show()
    win:Raise()
end

local reg = CreateFrame("Frame")
reg:RegisterEvent("PLAYER_LOGIN")
reg:SetScript("OnEvent", function(_, event)
    if event ~= "PLAYER_LOGIN" then return end
    local panel = CreateFrame("Frame")
    panel.name = "BonusRoll Plus"
    local t = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    t:SetPoint("TOPLEFT", 16, -16)
    t:SetText("BonusRoll Plus")
    local by = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    by:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -8)
    by:SetText(L.ABOUT_BY .. "  ·  " .. L.VERSION_LABEL .. " " .. ns.MyVersion())
    local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    btn:SetSize(200, 26)
    btn:SetPoint("TOPLEFT", by, "BOTTOMLEFT", 0, -16)
    btn:SetText(L.OPEN_SETTINGS)
    btn:SetScript("OnClick", function()
        if HideUIPanel and SettingsPanel and SettingsPanel:IsShown() then HideUIPanel(SettingsPanel) end
        ns.OpenSettings()
    end)
    pcall(function()
        if Settings and Settings.RegisterCanvasLayoutCategory then
            local cat = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
            Settings.RegisterAddOnCategory(cat)
        elseif InterfaceOptions_AddCategory then
            InterfaceOptions_AddCategory(panel)
        end
    end)
end)
