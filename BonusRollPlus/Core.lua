local ADDON, ns = ...

local DEFAULTS = { scale = 1, showRolls = true, style = "skeuo", v = 2 }
local db

local MEDIA = "Interface\\AddOns\\BonusRollPlus\\Media\\"
local F_FRIZ = "Fonts\\FRIZQT__.TTF"
local F_MORPH = "Fonts\\MORPHEUS.TTF"
local F_ARIAL = "Fonts\\ARIALN.TTF"
local F_SKURRI = "Fonts\\SKURRI.TTF"
local F_ANTON = MEDIA .. "Anton-Regular.ttf"
local F_PIXEL = MEDIA .. "PressStart2P-Regular.ttf"
local WHITE = "Interface\\Buttons\\WHITE8X8"
local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local PARCH = "Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal"
local MARBLE = "Interface\\FrameGeneral\\UI-Background-Marble"
local TOOLEDGE = "Interface\\Tooltips\\UI-Tooltip-Border"
local BARTEX = "Interface\\TargetingFrame\\UI-StatusBar"
local GLOW = "Interface\\Buttons\\UI-ActionButton-Border"
local LEADER = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
local SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark"

local ES = GetLocale and GetLocale():sub(1, 2) == "es"
local TITLE = ES and "Tiradas" or "Rolls"

local KINDS = {
    { key = "need", roll = 1, label = NEED or "Need", atlas = "lootroll-toast-icon-need-up", file = "Interface\\Buttons\\UI-GroupLoot-Dice-Up", wax = { 0.78, 0.17, 0.13 } },
    { key = "greed", roll = 2, label = GREED or "Greed", atlas = "lootroll-toast-icon-greed-up", file = "Interface\\Buttons\\UI-GroupLoot-Coin-Up", wax = { 0.82, 0.62, 0.17 } },
    { key = "de", roll = 3, label = ROLL_DISENCHANT or "Disenchant", atlas = "lootroll-toast-icon-disenchant-up", file = "Interface\\Buttons\\UI-GroupLoot-DE-Up", wax = { 0.5, 0.3, 0.7 } },
    { key = "pass", roll = 0, label = PASS or "Pass", atlas = "lootroll-toast-icon-pass-up", file = "Interface\\Buttons\\UI-GroupLoot-Pass-Up", wax = { 0.33, 0.29, 0.26 } },
}
local KIND = {}
for _, k in ipairs(KINDS) do KIND[k.key] = k end
KIND.wait = { key = "wait", atlas = KIND.need.atlas, file = KIND.need.file }

local RANK = { need = 1, de = 2, greed = 3, pass = 4, wait = 5 }

local SPECS = {
    { "LOOT_ROLL_ROLLED_NEED", "rolled", "need", { "value", "link", "player" } },
    { "LOOT_ROLL_ROLLED_GREED", "rolled", "greed", { "value", "link", "player" } },
    { "LOOT_ROLL_ROLLED_DE", "rolled", "de", { "value", "link", "player" } },
    { "LOOT_ROLL_NEED_SELF", "chose", "need", { "link" }, true },
    { "LOOT_ROLL_GREED_SELF", "chose", "greed", { "link" }, true },
    { "LOOT_ROLL_DISENCHANT_SELF", "chose", "de", { "link" }, true },
    { "LOOT_ROLL_PASSED_SELF", "chose", "pass", { "link" }, true },
    { "LOOT_ROLL_NEED", "chose", "need", { "player", "link" } },
    { "LOOT_ROLL_GREED", "chose", "greed", { "player", "link" } },
    { "LOOT_ROLL_DISENCHANT", "chose", "de", { "player", "link" } },
    { "LOOT_ROLL_PASSED", "chose", "pass", { "player", "link" } },
    { "LOOT_ROLL_YOU_WON", "won", nil, { "link" }, true },
    { "LOOT_ROLL_WON", "won", nil, { "player", "link" } },
}

local function Escape(s)
    return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"):gsub("\1", "%%%%"))
end

local function Compile(fmt)
    if type(fmt) ~= "string" then return end
    fmt = fmt:gsub("%%%%", "\1")
    local parts, order, pos, n = { "^" }, {}, 1, 0
    while pos <= #fmt do
        local s, e, num, kind = fmt:find("%%(%d*)%$?([sd])", pos)
        if not s then
            parts[#parts + 1] = Escape(fmt:sub(pos))
            break
        end
        parts[#parts + 1] = Escape(fmt:sub(pos, s - 1))
        n = n + 1
        order[n] = tonumber(num) or n
        parts[#parts + 1] = kind == "d" and "(%d+)" or "(.-)"
        pos = e + 1
    end
    parts[#parts + 1] = "$"
    return table.concat(parts), order
end

local function Match(entry, text)
    local caps = { text:match(entry.pat) }
    if #caps == 0 then return end
    local out = {}
    for i, v in ipairs(caps) do out[entry.order[i]] = v end
    return out
end

local compiled
local function Compiled()
    if compiled then return compiled end
    compiled = {}
    for _, s in ipairs(SPECS) do
        local fmt = _G[s[1]]
        local pat, order = Compile(fmt)
        if pat then
            compiled[#compiled + 1] = { pat = pat, order = order, type = s[2], kind = s[3], fields = s[4], self = s[5] }
        end
    end
    return compiled
end

local function Parse(text)
    for _, entry in ipairs(Compiled()) do
        local caps = Match(entry, text)
        if caps then
            local r = { type = entry.type, kind = entry.kind }
            for i, field in ipairs(entry.fields) do r[field] = caps[i] end
            if entry.self then r.player = UnitName("player") end
            if r.value then r.value = tonumber(r.value) end
            return r
        end
    end
end

local function ItemID(link)
    return link and tonumber(link:match("item:(%d+)"))
end

local function ShortName(name)
    if not name then return "?" end
    return Ambiguate and Ambiguate(name, "short") or name
end

local classCache = {}
local function ClassColor(name)
    name = ShortName(name)
    if classCache[name] then return classCache[name] end
    local units = { "player" }
    local n = GetNumGroupMembers and GetNumGroupMembers() or 0
    local prefix = IsInRaid and IsInRaid() and "raid" or "party"
    for i = 1, n do units[#units + 1] = prefix .. i end
    for _, u in ipairs(units) do
        if UnitExists(u) and ShortName(UnitName(u)) == name then
            local _, class = UnitClass(u)
            local c = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
            if c then
                classCache[name] = { c.r, c.g, c.b }
                return classCache[name]
            end
        end
    end
    return { 1, 1, 1 }
end

local function GroupNames()
    local names = {}
    local n = GetNumGroupMembers and GetNumGroupMembers() or 0
    if n == 0 or n > 6 then return names end
    names[#names + 1] = ShortName(UnitName("player"))
    for i = 1, n - 1 do
        local u = "party" .. i
        if UnitExists(u) then names[#names + 1] = ShortName(UnitName(u)) end
    end
    return names
end

local function QualityColor(q)
    if C_Item and C_Item.GetItemQualityColor and q then
        local r, g, b = C_Item.GetItemQualityColor(q)
        if r then return r, g, b end
    end
    local c = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q or 1]
    if c then return c.r, c.g, c.b end
    return 1, 1, 1
end

local function ItemMeta(link)
    if not link then return nil, nil end
    local get = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local _, _, _, ilvl, _, _, subType, _, equipLoc = get(link)
    if C_Item and C_Item.GetDetailedItemLevelInfo then
        local detailed = C_Item.GetDetailedItemLevelInfo(link)
        if detailed and detailed > 0 then ilvl = detailed end
    end
    local slot = equipLoc and equipLoc ~= "" and _G[equipLoc] or nil
    local piece
    if slot and subType and subType ~= "" and subType ~= slot then
        piece = slot .. " · " .. subType
    else
        piece = slot or subType
    end
    return ilvl, piece
end

local function Hex(h, a)
    local r, g, b = h:match("#?(%x%x)(%x%x)(%x%x)")
    return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, a or 1
end

local function Tex(parent, layer, r, g, b, a, sub)
    local t = parent:CreateTexture(nil, layer or "ARTWORK", nil, sub or 0)
    t:SetColorTexture(r, g, b, a or 1)
    return t
end

local function Fade(t, orientation, from, to)
    t:SetColorTexture(1, 1, 1, 1)
    if t.SetGradient and CreateColor then
        local ok = pcall(t.SetGradient, t, orientation, CreateColor(from[1], from[2], from[3], from[4]), CreateColor(to[1], to[2], to[3], to[4]))
        if ok then return end
    end
    if t.SetGradientAlpha then
        t:SetGradientAlpha(orientation, from[1], from[2], from[3], from[4], to[1], to[2], to[3], to[4])
    end
end

local function Font(fs, path, size, flags)
    if not fs:SetFont(path, size, flags) then
        fs:SetFont(STANDARD_TEXT_FONT, size, flags)
    end
end

local function SetKindIcon(tex, kind)
    if kind.atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(kind.atlas) then
        tex:SetAtlas(kind.atlas)
    else
        tex:SetTexture(kind.file)
        tex:SetTexCoord(0, 1, 0, 1)
    end
end

local function Circle(parent, layer, sub, size, r, g, b, a)
    local t = parent:CreateTexture(nil, layer, nil, sub)
    t:SetSize(size, size)
    t:SetColorTexture(r, g, b, a or 1)
    if parent.CreateMaskTexture then
        local m = parent:CreateMaskTexture()
        m:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        m:SetAllPoints(t)
        t:AddMaskTexture(m)
    end
    return t
end

local function Place(r, parent, x, y, w, h)
    r:ClearAllPoints()
    r:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
    if w then r:SetSize(w, h or w) end
end

local function Rect(parent, layer, sub, x, y, w, h, hex, a)
    local r, g, b, al = Hex(hex, a)
    local t = Tex(parent, layer, r, g, b, al, sub)
    Place(t, parent, x, y, w, h)
    return t
end

local function Outline(parent, layer, sub, x, y, w, h, th, hex, a)
    Rect(parent, layer, sub, x, y, w, th, hex, a)
    Rect(parent, layer, sub, x, y + h - th, w, th, hex, a)
    Rect(parent, layer, sub, x, y + th, th, h - 2 * th, hex, a)
    Rect(parent, layer, sub, x + w - th, y + th, th, h - 2 * th, hex, a)
end

local FRAME_W, FRAME_H, PANEL_W = 340, 250, 214
local ROLLER_H = 30

local SRC_UI = "UI UX Pro Max"
local SRC_TASTE = "Taste Skill"

local THEMES = {
    {
        id = "skeuo", title = "Skeuomorfismo", src = SRC_UI, w = 340, h = 250,
        panel = { style = "parch", dx = 6, y = 36, ink = "#2A1708", hi = "#9E140A", title = "#F2D175", flags = nil },
    },
    {
        id = "vintage", title = "Vintage Analógico", src = SRC_UI, w = 250, h = 336,
        ops = {
            { op = "rect", x = 6, y = 7, w = 250, h = 336, c = "#000000", a = 0.35 },
            { op = "rect", x = 0, y = 0, c = "#F5E6C8" },
            { op = "outline", x = 0, y = 0, w = 250, h = 336, th = 2, c = "#CDB88C" },
            { op = "rect", x = 14, y = 14, w = 222, h = 196, c = "#D4A574" },
            { op = "grain", x = 14, y = 14, w = 222, h = 196, n = 90, c = "#5A3A1A", a = 0.2 },
            { op = "grad", x = 14, y = 14, w = 222, h = 80, dir = "VERTICAL", c1 = "#2A1608", a1 = 0, c2 = "#2A1608", a2 = 0.5 },
            { op = "grad", x = 14, y = 130, w = 222, h = 80, dir = "VERTICAL", c1 = "#2A1608", a1 = 0.5, c2 = "#2A1608", a2 = 0 },
            { op = "grad", x = 14, y = 14, w = 90, h = 196, dir = "HORIZONTAL", c1 = "#FFC864", a1 = 0.4, c2 = "#FFC864", a2 = 0 },
            { op = "rect", x = 14, y = 166, w = 222, h = 44, c = "#3B2A1A", a = 0.9 },
            { op = "outline", x = 14, y = 14, w = 222, h = 196, th = 2, c = "#3B2A1A" },
        },
        icon = { x = 77, y = 44, size = 96, ring = 4, tint = "#EBCB9E", desat = true },
        name = { x = 20, y = 172, w = 210, font = F_MORPH, size = 15, color = "q", justify = "CENTER", flags = "OUTLINE", lines = 2 },
        piece = { x = 14, y = 218, w = 222, font = F_FRIZ, size = 12, color = "#5A4630", justify = "CENTER" },
        bind = { x = 14, y = 234, w = 222, font = F_FRIZ, size = 11, color = "#8A7350", justify = "CENTER" },
        btn = {
            shape = "circle", label = "below", iconSize = 24, labelFont = F_FRIZ, labelSize = 10, ink = "#3B2A1A",
            cells = { { 24, 254, 46, 46 }, { 76, 254, 46, 46 }, { 128, 254, 46, 46 }, { 180, 254, 46, 46 } },
            fill = { need = "#C0504D", greed = "#D4A574", de = "#4A7B7C", pass = "#8C7B66" },
            border = "#3B2A1A", th = 2, sel = "#FFFFFF", selA = 0.5,
        },
        timer = { kind = "blocks", n = 14, x = 14, y = 322, w = 222, h = 8, gap = 4, fill = "#3B2A1A", dim = "#D8C69E" },
        panel = { style = "flat", bg = "#F5E6C8", border = "#CDB88C", th = 2, ink = "#3B2A1A", hi = "#B5483E", title = "#3B2A1A", titleBg = "#D4A574", font = F_FRIZ, dx = 14, y = 14, light = true },
    },
    {
        id = "pixel", title = "Pixel Art", src = SRC_UI, w = 420, h = 98,
        ops = {
            { op = "rect", x = 5, y = 5, w = 420, h = 98, c = "#000000", a = 0.5 },
            { op = "rect", x = 0, y = 0, c = "#000000" },
            { op = "rect", x = 4, y = 4, w = 412, h = 90, c = "#1B1B3A" },
            { op = "outline", x = 6, y = 6, w = 408, h = 86, th = 2, c = "#4A4A9A" },
            { op = "rect", x = 0, y = 0, w = 4, h = 4, c = "#000000" },
        },
        icon = { x = 14, y = 16, size = 52, ring = 3 },
        name = { x = 76, y = 14, w = 132, font = F_PIXEL, size = 8, color = "q", lines = 2 },
        piece = { x = 76, y = 50, w = 132, font = F_PIXEL, size = 7, color = "#9AA0FF" },
        btn = {
            shape = "rect", label = "none", iconSize = 26, shade = true,
            cells = { { 216, 14, 44, 44 }, { 266, 14, 44, 44 }, { 316, 14, 44, 44 }, { 366, 14, 44, 44 } },
            fill = { need = "#E04040", greed = "#E0B020", de = "#A060E0", pass = "#808080" },
            border = "#000000", th = 3, sel = "#FFFFFF", selA = 0.5,
        },
        timer = { kind = "blocks", n = 20, x = 14, y = 76, w = 392, h = 10, gap = 4, fill = "#40E040", dim = "#2A2A5A" },
        panel = { style = "flat", bg = "#1B1B3A", border = "#000000", th = 3, ink = "#E8E8FF", hi = "#E0B020", title = "#E0B020", titleBg = "#000000", font = F_FRIZ, dx = 10, y = 0 },
    },
    {
        id = "oled", title = "Modo Oscuro OLED", src = SRC_UI, w = 520, h = 84,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#000000" },
            { op = "rect", x = 0, y = 0, w = 76, h = 84, c = "#0A0E27" },
            { op = "outline", x = 0, y = 0, w = 520, h = 84, th = 1, c = "#1A1F3D" },
        },
        icon = { x = 12, y = 16, size = 52, ring = 2, glow = true },
        name = { x = 88, y = 14, w = 238, font = F_FRIZ, size = 16, color = "q", lines = 2 },
        piece = { x = 88, y = 54, w = 238, font = F_FRIZ, size = 12, color = "#7F88B8" },
        btn = {
            shape = "circle", label = "none", iconSize = 22, ringBg = "#000000",
            cells = { { 338, 22, 40, 40 }, { 384, 22, 40, 40 }, { 430, 22, 40, 40 }, { 476, 22, 40, 40 } },
            fill = { need = "#FFC83D", greed = "#3DDC97", de = "#B26BFF", pass = "#6B7599" },
            border = "#FFC83D", th = 2, sel = "#FFC83D", selA = 0.35,
        },
        timer = { kind = "bar", x = 0, y = 0, w = 520, h = 3, fill = "#FFC83D", track = "#0A0E27", spark = true },
        panel = { style = "flat", bg = "#000000", border = "#1A1F3D", th = 1, ink = "#E0E0F0", hi = "#FFC83D", title = "#FFC83D", titleBg = "#0A0E27", font = F_FRIZ, dx = 8, y = 0 },
    },
    {
        id = "glass", title = "Cristal Esmerilado", src = SRC_UI, w = 300, h = 250,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#1E2A5A", a = 0.6 },
            { op = "grad", x = 0, y = 0, w = 300, h = 90, dir = "VERTICAL", c1 = "#FFFFFF", a1 = 0, c2 = "#FFFFFF", a2 = 0.16 },
            { op = "outline", x = 0, y = 0, w = 300, h = 250, th = 1, c = "#FFFFFF", a = 0.32 },
            { op = "rect", x = 1, y = 1, w = 298, h = 1, c = "#FFFFFF", a = 0.5 },
            { op = "circle", x = 270, y = 20, size = 120, c = "#8FB2FF", a = 0.12 },
        },
        icon = { x = 18, y = 18, size = 56, ring = 2, bgA = 0.35 },
        name = { x = 86, y = 20, w = 196, font = F_FRIZ, size = 16, color = "q", flags = "OUTLINE", lines = 2 },
        piece = { x = 86, y = 58, w = 196, font = F_FRIZ, size = 12, color = "#BFD0FF" },
        bind = { x = 18, y = 226, w = 264, font = F_FRIZ, size = 11, color = "#BFD0FF" },
        btn = {
            shape = "rect", label = "inside", iconSize = 24, labelFont = F_FRIZ, labelSize = 13, ink = "#FFFFFF",
            cells = { { 18, 96, 126, 44 }, { 156, 96, 126, 44 }, { 18, 148, 126, 44 }, { 156, 148, 126, 44 } },
            fill = { need = "#FFFFFF", greed = "#FFFFFF", de = "#FFFFFF", pass = "#FFFFFF" }, fillA = 0.12,
            border = "#FFFFFF", borderA = 0.32, th = 1, sel = "#8FB2FF", selA = 0.55,
        },
        timer = { kind = "bar", x = 18, y = 208, w = 264, h = 6, fill = "#8FB2FF", track = "#FFFFFF", trackA = 0.16 },
        panel = { style = "flat", bg = "#1E2A5A", bgA = 0.8, border = "#FFFFFF", borderA = 0.32, th = 1, ink = "#FFFFFF", hi = "#8FB2FF", title = "#BFD0FF", titleBg = "#FFFFFF", titleBgA = 0.1, font = F_FRIZ, dx = 8, y = 0 },
    },
    {
        id = "ticket", title = "El Billete", src = SRC_TASTE, w = 440, h = 150,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#E3E2DA" },
            { op = "rect", x = 0, y = 0, w = 112, h = 150, c = "#9FC7B8" },
            { op = "rect", x = 112, y = 0, w = 328, h = 48, c = "#161C1A" },
            { op = "row", x = 110, y = 12, n = 12, dy = 11, w = 4, h = 6, c = "#161C1A" },
            { op = "circle", x = 112, y = 0, size = 22, c = "#161C1A" },
            { op = "circle", x = 112, y = 150, size = 22, c = "#161C1A" },
        },
        icon = { x = 24, y = 42, size = 64, ring = 3 },
        name = { x = 126, y = 7, w = 304, font = F_FRIZ, size = 17, color = "q", upper = true, lines = 2 },
        piece = { x = 126, y = 56, w = 304, font = F_FRIZ, size = 13, color = "#161C1A" },
        bind = { x = 126, y = 74, w = 304, font = F_FRIZ, size = 11, color = "#4A524F" },
        btn = {
            shape = "rect", label = "stack", iconSize = 20, labelFont = F_FRIZ, labelSize = 10, ink = "#E3E2DA", selInk = "#161C1A",
            cells = { { 126, 94, 72, 40 }, { 206, 94, 72, 40 }, { 286, 94, 72, 40 }, { 366, 94, 72, 40 } },
            fill = { need = "#161C1A", greed = "#161C1A", de = "#161C1A", pass = "#161C1A" },
            sel = "#9FC7B8", selA = 1,
        },
        timer = { kind = "bar", x = 112, y = 142, w = 328, h = 8, fill = "#9FC7B8", track = "#C9C8BF" },
        panel = { style = "flat", bg = "#161C1A", border = "#9FC7B8", th = 2, ink = "#E3E2DA", hi = "#9FC7B8", title = "#9FC7B8", titleBg = "#1F2725", font = F_FRIZ, dx = 8, y = 0 },
    },
    {
        id = "poster", title = "Cartel Plano", src = SRC_TASTE, w = 380, h = 214,
        ops = {
            { op = "rect", x = 0, y = 0, w = 130, h = 122, c = "#FF8126" },
            { op = "rect", x = 130, y = 0, w = 250, h = 122, c = "#161615" },
        },
        icon = { x = 12, y = 12, size = 44, ring = 3 },
        ilvl = { x = 10, y = 62, w = 112, font = F_ANTON, size = 44, color = "#111111", justify = "LEFT" },
        name = { x = 142, y = 12, w = 226, font = F_ANTON, size = 22, color = "q", upper = true, noIlvl = true, lines = 2 },
        piece = { x = 142, y = 96, w = 226, font = F_FRIZ, size = 13, color = "#F2F2F2" },
        btn = {
            shape = "rect", label = "stack", iconSize = 28, labelFont = F_ANTON, labelSize = 15, upper = true,
            cells = { { 0, 134, 95, 80 }, { 95, 134, 95, 80 }, { 190, 134, 95, 80 }, { 285, 134, 95, 80 } },
            fill = { need = "#DE194B", greed = "#C5F53D", de = "#4DB3FF", pass = "#161615" },
            inkBy = { need = "#FFFFFF", greed = "#111111", de = "#111111", pass = "#F2F2F2" },
            sel = "#FFFFFF", selA = 0.4,
        },
        timer = { kind = "bar", x = 0, y = 122, w = 380, h = 8, fill = "#C5F53D", track = "#111111" },
        panel = { style = "flat", bg = "#161615", border = "#FF8126", th = 3, ink = "#F2F2F2", hi = "#C5F53D", title = "#FF8126", titleBg = "#161615", font = F_FRIZ, dx = 8, y = 0 },
    },
    {
        id = "specimen", title = "Ficha de Espécimen", src = SRC_TASTE, w = 330, h = 252,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#F7F9FA" },
            { op = "rect", x = 0, y = 0, w = 330, h = 52, c = "#1F3038" },
            { op = "rect", x = 14, y = 66, w = 104, h = 104, c = "#ECF0F2" },
            { op = "outline", x = 0, y = 0, w = 330, h = 252, th = 2, c = "#1F3038" },
        },
        icon = { x = 28, y = 80, size = 76, ring = 3 },
        name = { x = 14, y = 7, w = 302, font = F_FRIZ, size = 16, color = "q", noIlvl = true, lines = 2 },
        ilvl = { x = 130, y = 66, w = 190, font = F_MORPH, size = 22, color = "#0D7480", justify = "LEFT", fmt = true },
        piece = { x = 130, y = 104, w = 190, font = F_FRIZ, size = 13, color = "#1F3038" },
        bind = { x = 130, y = 128, w = 190, font = F_FRIZ, size = 12, color = "#5D6B72" },
        btn = {
            shape = "rect", label = "stack", iconSize = 22, labelFont = F_FRIZ, labelSize = 11, ink = "#FFFFFF",
            cells = { { 14, 182, 68, 44 }, { 90, 182, 68, 44 }, { 166, 182, 68, 44 }, { 242, 182, 74, 44 } },
            fill = { need = "#0D7480", greed = "#0D7480", de = "#0D7480", pass = "#5D6B72" },
            sel = "#1F3038", selA = 1,
        },
        timer = { kind = "bar", x = 14, y = 236, w = 302, h = 6, fill = "#0D7480", track = "#ECF0F2" },
        panel = { style = "flat", bg = "#F7F9FA", border = "#1F3038", th = 2, ink = "#1F3038", hi = "#0D7480", title = "#F7F9FA", titleBg = "#1F3038", font = F_FRIZ, dx = 8, y = 0, light = true },
    },
    {
        id = "darkroom", title = "Cuarto Oscuro", src = SRC_TASTE, w = 250, h = 336,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#1C1C1C" },
            { op = "circle", x = 125, y = 84, size = 170, c = "#C8C5BA", a = 0.06 },
            { op = "circle", x = 125, y = 84, size = 122, c = "#C8C5BA", a = 0.08 },
        },
        icon = { x = 85, y = 40, size = 80, ring = 2 },
        name = { x = 14, y = 138, w = 222, font = F_FRIZ, size = 17, color = "q", upper = true, justify = "CENTER", lines = 2 },
        piece = { x = 14, y = 176, w = 222, font = F_FRIZ, size = 12, color = "#9A9B96", justify = "CENTER" },
        btn = {
            shape = "rect", label = "inside", iconSize = 20, labelFont = F_FRIZ, labelSize = 14, ink = "#F1F1EF", selInk = "#1C1C1C",
            cells = { { 14, 204, 222, 28 }, { 14, 236, 222, 28 }, { 14, 268, 222, 28 }, { 14, 300, 222, 28 } },
            fill = { need = "#262626", greed = "#262626", de = "#262626", pass = "#262626" },
            sel = "#8FA68E", selA = 1,
        },
        timer = { kind = "bar", x = 0, y = 332, w = 250, h = 4, fill = "#8FA68E", track = "#262626" },
        panel = { style = "flat", bg = "#1C1C1C", border = "#8FA68E", th = 2, ink = "#F1F1EF", hi = "#8FA68E", title = "#8FA68E", titleBg = "#262626", font = F_FRIZ, dx = 8, y = 0 },
    },
    {
        id = "monument", title = "Monumento", src = SRC_TASTE, w = 460, h = 194,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#FFFFFF" },
            { op = "rect", x = 0, y = 0, w = 460, h = 104, c = "#05070A" },
        },
        icon = { x = 16, y = 20, size = 64, ring = 3 },
        name = { x = 96, y = 12, w = 352, font = F_SKURRI, size = 30, color = "q", lines = 2 },
        piece = { x = 96, y = 80, w = 352, font = F_FRIZ, size = 13, color = "#FFFFFF" },
        btn = {
            shape = "rect", label = "inside", iconSize = 24, labelFont = F_FRIZ, labelSize = 17, ink = "#1F2B4D",
            cells = { { 12, 124, 106, 56 }, { 122, 124, 106, 56 }, { 232, 124, 106, 56 }, { 342, 124, 106, 56 } },
            fill = { need = "#E3E1DC", greed = "#E3E1DC", de = "#E3E1DC", pass = "#E3E1DC" },
            sel = "#F7941D", selA = 1,
        },
        timer = { kind = "bar", x = 0, y = 104, w = 460, h = 8, fill = "#F7941D", track = "#E3E1DC" },
        panel = { style = "flat", bg = "#FFFFFF", border = "#05070A", th = 3, ink = "#1F2B4D", hi = "#F7941D", title = "#FFFFFF", titleBg = "#05070A", font = F_FRIZ, dx = 8, y = 0, light = true },
    },
}

local THEME_BY_ID = {}
for _, t in ipairs(THEMES) do THEME_BY_ID[t.id] = t end

local anchor, stack
local pools, active = {}, {}
local BuildFrameFor

local function Layout()
    local y, w = 0, FRAME_W
    for _, f in ipairs(active) do
        f:ClearAllPoints()
        f:SetPoint("BOTTOMLEFT", stack, "BOTTOMLEFT", 0, y)
        y = y + f.h + 12
        w = f.w
    end
    stack:SetWidth(w)
end

local function Release(f)
    f:Hide()
    f.panel:Hide()
    f.rollID, f.fake, f.entries, f.chosen, f.closing = nil, nil, nil, nil, nil
    for i, a in ipairs(active) do
        if a == f then table.remove(active, i) break end
    end
    local pool = pools[f.themeId]
    if pool then pool[#pool + 1] = f end
    Layout()
end

local function ReleaseAll()
    for i = #active, 1, -1 do Release(active[i]) end
end

local function RefreshPanel(f)
    local p = f.panel
    local P = f.theme.panel
    if not f.entries then return end
    local list = {}
    for name, e in pairs(f.entries) do list[#list + 1] = { name = name, kind = e.kind, value = e.value, won = e.won } end
    if f.lastNames then
        for _, name in ipairs(f.lastNames) do
            if not f.entries[name] then list[#list + 1] = { name = name, kind = "wait" } end
        end
    end
    table.sort(list, function(a, b)
        local ra, rb = RANK[a.kind] or 9, RANK[b.kind] or 9
        if ra ~= rb then return ra < rb end
        if (a.value or 0) ~= (b.value or 0) then return (a.value or 0) > (b.value or 0) end
        return a.name < b.name
    end)
    local lead
    for _, e in ipairs(list) do
        if e.won then lead = e break end
    end
    if not lead then
        for _, e in ipairs(list) do
            if (e.kind == "need" or e.kind == "greed" or e.kind == "de") and e.value then lead = e break end
        end
    end
    local shown = math.min(#list, 12)
    local ir, ig, ib = Hex(P.ink)
    local hr, hg, hb = Hex(P.hi)
    for i = 1, 12 do
        local row = p.rows[i]
        if not row then
            local y = -38 - (i - 1) * 19
            row = {}
            row.hl = Tex(p, "BACKGROUND", hr, hg, hb, 0.24, 1)
            row.hl:SetPoint("TOPLEFT", p, "TOPLEFT", 6, y + 2)
            row.hl:SetPoint("BOTTOMRIGHT", p, "TOPRIGHT", -6, y - 17)
            row.icon = p:CreateTexture(nil, "ARTWORK")
            row.icon:SetSize(16, 16)
            row.icon:SetPoint("TOPLEFT", p, "TOPLEFT", 12, y)
            row.dot = Circle(p, "ARTWORK", 1, 9, 1, 1, 1, 1)
            row.dot:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
            row.name = p:CreateFontString(nil, "OVERLAY")
            Font(row.name, P.font or F_FRIZ, 12)
            row.name:SetPoint("LEFT", row.dot, "RIGHT", 5, 0)
            row.name:SetWidth(96)
            row.name:SetJustifyH("LEFT")
            row.name:SetWordWrap(false)
            row.num = p:CreateFontString(nil, "OVERLAY")
            Font(row.num, F_ARIAL, 14, P.light and nil or "OUTLINE")
            row.num:SetPoint("TOPRIGHT", p, "TOPRIGHT", -14, y)
            row.num:SetJustifyH("RIGHT")
            row.lead = p:CreateTexture(nil, "OVERLAY")
            row.lead:SetSize(15, 15)
            row.lead:SetTexture(LEADER)
            row.lead:SetPoint("RIGHT", row.num, "LEFT", -4, 0)
            p.rows[i] = row
        end
        local e = list[i]
        if e and i <= shown then
            SetKindIcon(row.icon, KIND[e.kind] or KIND.wait)
            row.icon:SetDesaturated(e.kind == "wait" or e.kind == "pass")
            local c = ClassColor(e.name)
            row.dot:SetVertexColor(c[1], c[2], c[3])
            row.name:SetText(e.name)
            row.name:SetTextColor(ir, ig, ib)
            if e.kind == "pass" then
                row.num:SetText("-")
            elseif e.kind == "wait" then
                row.num:SetText("...")
            else
                row.num:SetText(e.value or "")
            end
            local isLead = e == lead
            if isLead then row.num:SetTextColor(hr, hg, hb) else row.num:SetTextColor(ir, ig, ib) end
            local dim = (e.kind == "wait" or e.kind == "pass") and 0.55 or 1
            row.icon:SetAlpha(dim)
            row.name:SetAlpha(dim)
            row.dot:SetAlpha(dim)
            row.hl:SetShown(isLead)
            row.lead:SetShown(isLead)
            row.icon:Show()
            row.dot:Show()
            row.name:Show()
            row.num:Show()
        else
            row.icon:Hide()
            row.dot:Hide()
            row.name:Hide()
            row.num:Hide()
            row.hl:Hide()
            row.lead:Hide()
        end
    end
    p:SetHeight(46 + math.max(shown, 1) * 19)
end

local function AddEntry(f, name, kind, value)
    f.entries = f.entries or {}
    local e = f.entries[name] or {}
    e.kind = kind or e.kind
    if value then e.value = value end
    f.entries[name] = e
    return e
end

local function Choose(f, kind)
    if f.chosen then return end
    f.chosen = kind.key
    if f.rollID and not f.fake then RollOnLoot(f.rollID, kind.roll) end
    local me = ShortName(UnitName("player"))
    AddEntry(f, me, kind.key, f.fake and math.random(1, 100) or nil)
    for _, b in ipairs(f.buttons) do b:Mark(b.kind == kind) end
    RefreshPanel(f)
end

local function ButtonTooltip(b)
    GameTooltip:SetOwner(b, "ANCHOR_TOP")
    GameTooltip:SetText(b.kind.label)
    if not b.enabled and b.reason then
        local msg = _G["LOOT_ROLL_INELIGIBLE_REASON" .. b.reason]
        if msg then GameTooltip:AddLine(msg, 1, 0.2, 0.2, true) end
    end
    GameTooltip:Show()
end

local function Text(f, spec, layer)
    local fs = f:CreateFontString(nil, layer or "OVERLAY")
    Font(fs, spec.font, spec.size, spec.flags)
    fs:ClearAllPoints()
    fs:SetPoint("TOPLEFT", f, "TOPLEFT", spec.x, -spec.y)
    fs:SetWidth(spec.w)
    fs:SetJustifyH(spec.justify or "LEFT")
    fs:SetWordWrap(true)
    fs:SetMaxLines(spec.lines or 1)
    if spec.color and spec.color ~= "q" then fs:SetTextColor(Hex(spec.color)) end
    return fs
end

local function NewFrame(T)
    local f = CreateFrame("Frame", nil, stack)
    f:SetSize(T.w, T.h)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f.theme, f.themeId, f.w, f.h = T, T.id, T.w, T.h
    f:SetScript("OnDragStart", function()
        if IsShiftKeyDown() then anchor:StartMoving() end
    end)
    f:SetScript("OnDragStop", function()
        anchor:StopMovingOrSizing()
        local x = anchor:GetCenter()
        local ux = UIParent:GetCenter()
        db.x, db.y = x - ux, anchor:GetBottom()
    end)
    f.fade = f:CreateAnimationGroup()
    local fa = f.fade:CreateAnimation("Alpha")
    fa:SetFromAlpha(0)
    fa:SetToAlpha(1)
    fa:SetDuration(0.25)
    f:SetScript("OnUpdate", function(self)
        local frac
        if self.fake then
            frac = (self.expire - GetTime()) / (self.rollTime / 1000)
        elseif self.rollID and GetLootRollTimeLeft then
            frac = GetLootRollTimeLeft(self.rollID) / (self.rollTime or 60000)
        end
        if not frac then return end
        if frac < 0 then frac = 0 elseif frac > 1 then frac = 1 end
        if self.setFrac then self.setFrac(frac) end
        if self.fake and frac <= 0 and not self.closing then
            self.closing = true
            C_Timer.After(1, function() Release(self) end)
        end
    end)
    return f
end

local function RunOps(f, T)
    local sub = -8
    for _, o in ipairs(T.ops or {}) do
        local x, y = o.x or 0, o.y or 0
        local w = o.w or (T.w - x)
        local h = o.h or (T.h - y)
        local s = math.min(sub, 7)
        if o.op == "rect" then
            Rect(f, "BACKGROUND", s, x, y, w, h, o.c, o.a)
        elseif o.op == "outline" then
            Outline(f, "BACKGROUND", s, x, y, w, h, o.th or 1, o.c, o.a)
        elseif o.op == "grad" then
            local t = Tex(f, "BACKGROUND", 1, 1, 1, 1, s)
            Place(t, f, x, y, w, h)
            local r1, g1, b1 = Hex(o.c1)
            local r2, g2, b2 = Hex(o.c2)
            Fade(t, o.dir, { r1, g1, b1, o.a1 }, { r2, g2, b2, o.a2 })
        elseif o.op == "circle" then
            local r, g, b, a = Hex(o.c, o.a)
            local c = Circle(f, "BACKGROUND", s, o.size, r, g, b, a)
            c:ClearAllPoints()
            c:SetPoint("CENTER", f, "TOPLEFT", x, -y)
        elseif o.op == "row" then
            for i = 0, o.n - 1 do
                Rect(f, "BACKGROUND", s, x + (o.dx or 0) * i, y + (o.dy or 0) * i, o.w, o.h, o.c, o.a)
            end
        elseif o.op == "grain" then
            local seed = 7
            for _ = 1, o.n do
                seed = (seed * 16807) % 2147483647
                local gx = x + (seed % w)
                seed = (seed * 16807) % 2147483647
                local gy = y + (seed % h)
                Rect(f, "BACKGROUND", s, gx, gy, 2, 2, o.c, o.a)
            end
        end
        sub = sub + 1
    end
end

local function BuildPanel(f, T)
    local P = T.panel
    local p = CreateFrame("Frame", nil, f, "BackdropTemplate")
    p:SetSize(PANEL_W, 80)
    p:SetPoint("TOPLEFT", f, "TOPRIGHT", P.dx or 8, -(P.y or 0))
    p:SetFrameLevel(f:GetFrameLevel() + 2)
    if P.style == "parch" then
        if p.SetBackdrop then
            p:SetBackdrop({ bgFile = PARCH, edgeFile = TOOLEDGE, edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 } })
            p:SetBackdropColor(1, 0.92, 0.74, 1)
            p:SetBackdropBorderColor(0.6, 0.42, 0.2, 1)
        end
        local strip = Tex(p, "BACKGROUND", 0.2, 0.12, 0.05, 0.9, 1)
        strip:SetPoint("TOPLEFT", p, "TOPLEFT", 4, -4)
        strip:SetPoint("TOPRIGHT", p, "TOPRIGHT", -4, -4)
        strip:SetHeight(26)
    else
        local th = P.th or 1
        local bg = Tex(p, "BACKGROUND", Hex(P.bg, P.bgA))
        bg:SetAllPoints()
        local br, bgc, bb, ba = Hex(P.border, P.borderA)
        local top = Tex(p, "BORDER", br, bgc, bb, ba)
        top:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
        top:SetPoint("TOPRIGHT", p, "TOPRIGHT", 0, 0)
        top:SetHeight(th)
        local bot = Tex(p, "BORDER", br, bgc, bb, ba)
        bot:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 0, 0)
        bot:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
        bot:SetHeight(th)
        local left = Tex(p, "BORDER", br, bgc, bb, ba)
        left:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
        left:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 0, 0)
        left:SetWidth(th)
        local right = Tex(p, "BORDER", br, bgc, bb, ba)
        right:SetPoint("TOPRIGHT", p, "TOPRIGHT", 0, 0)
        right:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
        right:SetWidth(th)
        local sr, sg, sb, sa = Hex(P.titleBg or P.bg, P.titleBgA)
        local strip = Tex(p, "BACKGROUND", sr, sg, sb, sa, 1)
        strip:SetPoint("TOPLEFT", p, "TOPLEFT", th, -th)
        strip:SetPoint("TOPRIGHT", p, "TOPRIGHT", -th, -th)
        strip:SetHeight(28)
    end
    p.title = p:CreateFontString(nil, "OVERLAY")
    Font(p.title, F_MORPH, 14)
    p.title:SetPoint("TOPLEFT", p, "TOPLEFT", 12, -10)
    p.title:SetTextColor(Hex(P.title))
    p.title:SetText(TITLE)
    p.rows = {}
    return p
end

local function BuildTimer(f, T)
    local M = T.timer
    if M.kind == "blocks" then
        local gap = M.gap or 4
        local bw = (M.w - (M.n - 1) * gap) / M.n
        local lit = {}
        for i = 1, M.n do
            local bx = M.x + (i - 1) * (bw + gap)
            Rect(f, "ARTWORK", 1, bx, M.y, bw, M.h, M.dim)
            lit[i] = Rect(f, "ARTWORK", 2, bx, M.y, bw, M.h, M.fill)
        end
        f.setFrac = function(frac)
            local on = math.ceil(frac * M.n)
            for i = 1, M.n do lit[i]:SetShown(i <= on) end
        end
    else
        Rect(f, "ARTWORK", 1, M.x, M.y, M.w, M.h, M.track, M.trackA)
        local fill = Rect(f, "ARTWORK", 2, M.x, M.y, M.w, M.h, M.fill)
        local spark
        if M.spark then
            spark = f:CreateTexture(nil, "OVERLAY", nil, 3)
            spark:SetTexture(SPARK)
            spark:SetBlendMode("ADD")
            spark:SetSize(20, 20)
            spark:SetVertexColor(Hex(M.fill))
        end
        f.setFrac = function(frac)
            fill:SetWidth(math.max(1, M.w * frac))
            if spark then
                spark:ClearAllPoints()
                spark:SetPoint("CENTER", fill, "RIGHT", 0, 0)
            end
        end
    end
end

local function BuildGenericButton(f, T, i, kind)
    local B = T.btn
    local cell = B.cells[i]
    local b = CreateFrame("Button", nil, f)
    b:SetFrameLevel(f:GetFrameLevel() + 6)
    b:SetPoint("TOPLEFT", f, "TOPLEFT", cell[1], -cell[2])
    b:SetSize(cell[3], cell[4])
    b.kind = kind
    local key = kind.key
    local fillHex = B.fill[key]
    if B.shape == "circle" then
        local size = cell[3]
        local outer, inner
        if B.ringBg then
            outer, inner = fillHex, B.ringBg
        else
            outer, inner = B.border, fillHex
        end
        local o = Circle(b, "BACKGROUND", 1, size, Hex(outer))
        o:SetPoint("CENTER", b, "CENTER", 0, 0)
        local th = B.th or 2
        local n = Circle(b, "BACKGROUND", 2, size - th * 2, Hex(inner, B.fillA))
        n:SetPoint("CENTER", b, "CENTER", 0, 0)
        b.sel = Circle(b, "BACKGROUND", 3, size - th * 2, Hex(B.sel, B.selA))
        b.sel:SetPoint("CENTER", b, "CENTER", 0, 0)
        b.hl = Circle(b, "HIGHLIGHT", 0, size - th * 2, 1, 1, 1, 0.18)
        b.hl:SetPoint("CENTER", b, "CENTER", 0, 0)
    else
        b.bgTex = Tex(b, "BACKGROUND", Hex(fillHex, B.fillA))
        b.bgTex:SetAllPoints()
        if B.border then
            Outline(b, "BORDER", 0, 0, 0, cell[3], cell[4], B.th or 1, B.border, B.borderA)
        end
        if B.shade then
            local sh = Tex(b, "ARTWORK", 0, 0, 0, 0.38, 1)
            sh:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", B.th or 0, B.th or 0)
            sh:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -(B.th or 0), B.th or 0)
            sh:SetHeight(4)
        end
        b.sel = Tex(b, "ARTWORK", Hex(B.sel, B.selA))
        b.sel:SetAllPoints()
        b.hl = Tex(b, "HIGHLIGHT", 1, 1, 1, 0.16)
        b.hl:SetAllPoints()
    end
    b.sel:Hide()
    b.icon = b:CreateTexture(nil, "OVERLAY")
    b.icon:SetSize(B.iconSize, B.iconSize)
    SetKindIcon(b.icon, kind)
    local mode = B.label or "none"
    local inkHex = (B.inkBy and B.inkBy[key]) or B.ink or "#FFFFFF"
    if mode ~= "none" then
        b.label = b:CreateFontString(nil, "OVERLAY")
        Font(b.label, B.labelFont, B.labelSize)
        local txt = kind.label
        if B.upper then txt = txt:upper() end
        b.label:SetText(txt)
        b.label:SetTextColor(Hex(inkHex))
    end
    if mode == "none" then
        b.icon:SetPoint("CENTER", b, "CENTER", 0, 0)
    elseif mode == "below" then
        b.icon:SetPoint("CENTER", b, "CENTER", 0, 0)
        b.label:SetPoint("TOP", b, "BOTTOM", 0, -3)
    elseif mode == "stack" then
        b.icon:SetPoint("TOP", b, "TOP", 0, -5)
        b.label:SetPoint("BOTTOM", b, "BOTTOM", 0, 5)
    else
        b.icon:SetPoint("LEFT", b, "LEFT", 8, 0)
        b.label:SetPoint("LEFT", b.icon, "RIGHT", 8, 0)
    end
    function b:Paint(enabled)
        self.enabled = enabled
        self.icon:SetDesaturated(not enabled)
        self:SetAlpha(enabled and 1 or 0.45)
    end
    function b:Mark(selected)
        self.sel:SetShown(selected)
        if self.label then
            self.label:SetTextColor(Hex(selected and B.selInk or inkHex))
        end
        if not selected then self:SetAlpha(0.4) else self:SetAlpha(1) end
    end
    b:SetScript("OnClick", function(self)
        if self.enabled then Choose(f, self.kind) end
    end)
    b:SetScript("OnEnter", ButtonTooltip)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

local function BuildGeneric(T)
    local f = NewFrame(T)
    RunOps(f, T)
    local I = T.icon
    local rw = I.ring or 2
    f.ring = Rect(f, "ARTWORK", 0, I.x - rw, I.y - rw, I.size + rw * 2, I.size + rw * 2, "#FFFFFF")
    if I.glow then
        f.glow = f:CreateTexture(nil, "ARTWORK", nil, -1)
        f.glow:SetTexture(GLOW)
        f.glow:SetBlendMode("ADD")
        f.glow:SetSize(I.size * 1.75, I.size * 1.75)
        f.glow:SetPoint("CENTER", f.ring, "CENTER", 0, 0)
    end
    Rect(f, "ARTWORK", 1, I.x, I.y, I.size, I.size, "#000000", I.bgA or 1)
    f.icon = f:CreateTexture(nil, "ARTWORK", nil, 2)
    Place(f.icon, f, I.x, I.y, I.size)
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    if I.tint then f.icon:SetVertexColor(Hex(I.tint)) end
    if I.desat then f.icon:SetDesaturated(true) end
    f.iconHit = CreateFrame("Frame", nil, f)
    f.iconHit:SetAllPoints(f.ring)
    f.iconHit:SetFrameLevel(f:GetFrameLevel() + 6)
    f.iconHit:EnableMouse(true)
    f.iconHit:SetScript("OnEnter", function(self)
        if not f.link then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if f.rollID and not f.fake and GameTooltip.SetLootRollItem then
            GameTooltip:SetLootRollItem(f.rollID)
        else
            GameTooltip:SetHyperlink(f.link)
        end
        GameTooltip:Show()
    end)
    f.iconHit:SetScript("OnLeave", function() GameTooltip:Hide() end)
    f.name = Text(f, T.name)
    f.piece = Text(f, T.piece)
    if T.bind then f.bind = Text(f, T.bind) end
    if T.ilvl then f.ilvl = Text(f, T.ilvl) end
    f.buttons = {}
    for i, kind in ipairs(KINDS) do f.buttons[i] = BuildGenericButton(f, T, i, kind) end
    BuildTimer(f, T)
    f.panel = BuildPanel(f, T)
    f.applyQuality = function(r, g, b)
        f.ring:SetColorTexture(r, g, b, 1)
        if f.glow then f.glow:SetVertexColor(r, g, b) end
        if T.name.color == "q" then f.name:SetTextColor(r, g, b) end
    end
    return f
end

local function SealPaint(b, enabled)
    local w = b.kind.wax
    if enabled then
        b.wax:SetColorTexture(w[1], w[2], w[3], 1)
        b.icon:SetDesaturated(false)
        b:SetAlpha(1)
    else
        b.wax:SetColorTexture(0.45, 0.4, 0.34, 1)
        b.icon:SetDesaturated(true)
        b:SetAlpha(0.55)
    end
    b.enabled = enabled
end

local function BuildSeal(f, i, kind)
    local b = CreateFrame("Button", nil, f)
    b:SetSize(70, 86)
    b:SetPoint("TOPLEFT", f, "TOPLEFT", 30 + (i - 1) * 70, -126)
    b:SetFrameLevel(f:GetFrameLevel() + 6)
    b.kind = kind
    b.rim = Circle(b, "BACKGROUND", 1, 62, 0.1, 0.05, 0.02, 1)
    b.rim:SetPoint("TOP", b, "TOP", 0, -2)
    b.ring = Circle(b, "BACKGROUND", 2, 58, 0.83, 0.64, 0.27, 1)
    b.ring:SetPoint("CENTER", b.rim, "CENTER", 0, 0)
    b.sel = Circle(b, "BACKGROUND", 0, 72, 1, 0.84, 0.2, 0.75)
    b.sel:SetPoint("CENTER", b.rim, "CENTER", 0, 0)
    b.sel:Hide()
    b.well = Circle(b, "BACKGROUND", 3, 53, 0.12, 0.06, 0.03, 1)
    b.well:SetPoint("CENTER", b.rim, "CENTER", 0, 0)
    b.wax = Circle(b, "ARTWORK", 1, 50, kind.wax[1], kind.wax[2], kind.wax[3], 1)
    b.wax:SetPoint("CENTER", b.rim, "CENTER", 0, 0)
    b.shade = Circle(b, "ARTWORK", 2, 50, 0, 0, 0, 0.28)
    b.shade:SetPoint("CENTER", b.wax, "CENTER", 0, -4)
    b.gloss = Circle(b, "ARTWORK", 3, 30, 1, 1, 1, 0.2)
    b.gloss:SetPoint("CENTER", b.wax, "CENTER", -7, 9)
    b.icon = b:CreateTexture(nil, "OVERLAY")
    b.icon:SetSize(30, 30)
    b.icon:SetPoint("CENTER", b.wax, "CENTER", 0, 0)
    SetKindIcon(b.icon, kind)
    b.label = b:CreateFontString(nil, "OVERLAY")
    Font(b.label, F_MORPH, 13)
    b.label:SetPoint("TOP", b.rim, "BOTTOM", 0, -5)
    b.label:SetText(kind.label)
    b.label:SetTextColor(0.2, 0.1, 0.03)
    b.hover = Circle(b, "HIGHLIGHT", 0, 50, 1, 1, 1, 0.22)
    b.hover:SetPoint("CENTER", b.rim, "CENTER", 0, 0)
    function b:Paint(enabled) SealPaint(self, enabled) end
    function b:Mark(selected)
        self.sel:SetShown(selected)
        self:SetAlpha(selected and 1 or 0.4)
    end
    b:SetScript("OnClick", function(self)
        if self.enabled then Choose(f, self.kind) end
    end)
    b:SetScript("OnEnter", ButtonTooltip)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

local function Roller(deco, atBottom)
    local bands = { { 0.14, 0.07, 0.03, 5 }, { 0.45, 0.28, 0.12, 6 }, { 0.8, 0.57, 0.3, 8 }, { 0.55, 0.36, 0.17, 6 }, { 0.16, 0.08, 0.03, 5 } }
    local off = 0
    for _, band in ipairs(bands) do
        local t = Tex(deco, "ARTWORK", band[1], band[2], band[3], 1)
        if atBottom then
            t:SetPoint("TOPLEFT", deco, "BOTTOMLEFT", 14, ROLLER_H - off)
            t:SetPoint("TOPRIGHT", deco, "BOTTOMRIGHT", -14, ROLLER_H - off)
        else
            t:SetPoint("TOPLEFT", deco, "TOPLEFT", 14, -off)
            t:SetPoint("TOPRIGHT", deco, "TOPRIGHT", -14, -off)
        end
        t:SetHeight(band[4])
        off = off + band[4]
    end
    for _, side in ipairs({ "LEFT", "RIGHT" }) do
        local sx = side == "LEFT" and 14 or -14
        local corner = atBottom and "BOTTOM" .. side or "TOP" .. side
        local cy = atBottom and (ROLLER_H / 2) or -(ROLLER_H / 2)
        local cap = Circle(deco, "OVERLAY", 1, 38, 0.2, 0.1, 0.04, 1)
        cap:SetPoint("CENTER", deco, corner, sx, cy)
        local c2 = Circle(deco, "OVERLAY", 2, 34, 0.68, 0.45, 0.2, 1)
        c2:SetPoint("CENTER", cap, "CENTER", 0, 0)
        local c3 = Circle(deco, "OVERLAY", 3, 20, 0.3, 0.17, 0.07, 1)
        c3:SetPoint("CENTER", cap, "CENTER", 0, 0)
        local c4 = Circle(deco, "OVERLAY", 4, 9, 0.93, 0.74, 0.34, 1)
        c4:SetPoint("CENTER", cap, "CENTER", 0, 0)
    end
end

local function BuildScroll(T)
    local f = NewFrame(T)
    local paper = CreateFrame("Frame", nil, f, "BackdropTemplate")
    paper:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -16)
    paper:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 16)
    paper:SetFrameLevel(f:GetFrameLevel() + 1)
    if paper.SetBackdrop then
        paper:SetBackdrop({ bgFile = PARCH, insets = { left = 0, right = 0, top = 0, bottom = 0 } })
        paper:SetBackdropColor(1, 0.9, 0.7, 1)
    end
    local base = Tex(paper, "BACKGROUND", 0.78, 0.6, 0.34, 0.35)
    base:SetAllPoints()
    local stains = { { 40, 120, 90, 0.1 }, { 210, 60, 120, 0.12 }, { 90, 200, 110, 0.1 }, { 250, 190, 80, 0.12 }, { 150, 130, 160, 0.07 } }
    for _, s in ipairs(stains) do
        local blob = Circle(paper, "BACKGROUND", 1, s[3], 0.4, 0.24, 0.08, s[4])
        blob:SetPoint("CENTER", paper, "TOPLEFT", s[1], -s[2])
    end
    local burn = {
        { "VERTICAL", { 0.3, 0.17, 0.05, 0 }, { 0.3, 0.17, 0.05, 0.5 }, "top" },
        { "VERTICAL", { 0.3, 0.17, 0.05, 0.5 }, { 0.3, 0.17, 0.05, 0 }, "bottom" },
        { "HORIZONTAL", { 0.3, 0.17, 0.05, 0.5 }, { 0.3, 0.17, 0.05, 0 }, "left" },
        { "HORIZONTAL", { 0.3, 0.17, 0.05, 0 }, { 0.3, 0.17, 0.05, 0.5 }, "right" },
    }
    for _, spec in ipairs(burn) do
        local t = Tex(paper, "ARTWORK", 1, 1, 1, 1)
        local side = spec[4]
        if side == "top" then
            t:SetPoint("TOPLEFT", paper, "TOPLEFT", 0, 0)
            t:SetPoint("TOPRIGHT", paper, "TOPRIGHT", 0, 0)
            t:SetHeight(46)
        elseif side == "bottom" then
            t:SetPoint("BOTTOMLEFT", paper, "BOTTOMLEFT", 0, 0)
            t:SetPoint("BOTTOMRIGHT", paper, "BOTTOMRIGHT", 0, 0)
            t:SetHeight(46)
        elseif side == "left" then
            t:SetPoint("TOPLEFT", paper, "TOPLEFT", 0, 0)
            t:SetPoint("BOTTOMLEFT", paper, "BOTTOMLEFT", 0, 0)
            t:SetWidth(26)
        else
            t:SetPoint("TOPRIGHT", paper, "TOPRIGHT", 0, 0)
            t:SetPoint("BOTTOMRIGHT", paper, "BOTTOMRIGHT", 0, 0)
            t:SetWidth(26)
        end
        Fade(t, spec[1], spec[2], spec[3])
    end

    local deco = CreateFrame("Frame", nil, f)
    deco:SetAllPoints(f)
    deco:SetFrameLevel(f:GetFrameLevel() + 3)
    Roller(deco, false)
    Roller(deco, true)

    local shadow = Tex(deco, "BORDER", 1, 1, 1, 1)
    shadow:SetPoint("TOPLEFT", deco, "TOPLEFT", 14, -ROLLER_H)
    shadow:SetPoint("TOPRIGHT", deco, "TOPRIGHT", -14, -ROLLER_H)
    shadow:SetHeight(10)
    Fade(shadow, "VERTICAL", { 0.1, 0.05, 0.02, 0 }, { 0.1, 0.05, 0.02, 0.55 })

    local ribbon = deco:CreateTexture(nil, "ARTWORK", nil, -1)
    ribbon:SetPoint("TOPLEFT", deco, "TOPLEFT", 0, -36)
    ribbon:SetPoint("TOPRIGHT", deco, "TOPRIGHT", 0, -36)
    ribbon:SetHeight(66)
    ribbon:SetTexture(MARBLE, "REPEAT", "REPEAT")
    ribbon:SetHorizTile(true)
    ribbon:SetVertTile(true)
    ribbon:SetVertexColor(0.62, 0.2, 0.15)
    local ribbonTint = Tex(deco, "ARTWORK", 0.16, 0.04, 0.03, 0.4)
    ribbonTint:SetAllPoints(ribbon)
    local ribbonShade = Tex(deco, "ARTWORK", 1, 1, 1, 1)
    ribbonShade:SetAllPoints(ribbon)
    Fade(ribbonShade, "VERTICAL", { 0, 0, 0, 0.45 }, { 1, 0.8, 0.5, 0.08 })
    for _, y in ipairs({ -36, -101 }) do
        local gold = Tex(deco, "OVERLAY", 0.9, 0.72, 0.32, 1)
        gold:SetPoint("TOPLEFT", deco, "TOPLEFT", 0, y)
        gold:SetPoint("TOPRIGHT", deco, "TOPRIGHT", 0, y)
        gold:SetHeight(2)
    end
    for _, x in ipairs({ 6, FRAME_W - 6 }) do
        local gem = Tex(deco, "OVERLAY", 0.93, 0.74, 0.34, 1)
        gem:SetSize(8, 8)
        gem:SetPoint("CENTER", deco, "TOPLEFT", x, -69)
        if gem.SetRotation then gem:SetRotation(math.rad(45)) end
    end

    f.glow = deco:CreateTexture(nil, "ARTWORK", nil, 2)
    f.glow:SetTexture(GLOW)
    f.glow:SetBlendMode("ADD")
    f.glow:SetSize(84, 84)
    f.glow:SetPoint("CENTER", deco, "TOPLEFT", 40, -69)
    f.ring = Tex(deco, "OVERLAY", 1, 1, 1, 1)
    f.ring:SetSize(54, 54)
    f.ring:SetPoint("CENTER", deco, "TOPLEFT", 40, -69)
    local iconBg = Tex(deco, "OVERLAY", 0, 0, 0, 1)
    iconBg:SetSize(50, 50)
    iconBg:SetPoint("CENTER", f.ring, "CENTER", 0, 0)
    f.icon = deco:CreateTexture(nil, "OVERLAY", nil, 2)
    f.icon:SetSize(46, 46)
    f.icon:SetPoint("CENTER", f.ring, "CENTER", 0, 0)
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    f.iconHit = CreateFrame("Frame", nil, f)
    f.iconHit:SetAllPoints(f.ring)
    f.iconHit:SetFrameLevel(f:GetFrameLevel() + 6)
    f.iconHit:EnableMouse(true)
    f.iconHit:SetScript("OnEnter", function(self)
        if not f.link then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if f.rollID and not f.fake and GameTooltip.SetLootRollItem then
            GameTooltip:SetLootRollItem(f.rollID)
        else
            GameTooltip:SetHyperlink(f.link)
        end
        GameTooltip:Show()
    end)
    f.iconHit:SetScript("OnLeave", function() GameTooltip:Hide() end)

    f.name = deco:CreateFontString(nil, "OVERLAY")
    Font(f.name, F_MORPH, 17, "OUTLINE")
    f.name:SetPoint("TOPLEFT", deco, "TOPLEFT", 78, -42)
    f.name:SetWidth(FRAME_W - 96)
    f.name:SetJustifyH("LEFT")
    f.name:SetWordWrap(true)
    f.name:SetMaxLines(2)
    f.piece = deco:CreateFontString(nil, "OVERLAY")
    Font(f.piece, F_FRIZ, 12, "OUTLINE")
    f.piece:SetPoint("BOTTOMLEFT", deco, "TOPLEFT", 78, -96)
    f.piece:SetTextColor(0.9, 0.8, 0.58)
    f.bind = deco:CreateFontString(nil, "OVERLAY")
    Font(f.bind, F_FRIZ, 12)
    f.bind:SetPoint("TOP", deco, "TOP", 0, -108)
    f.bind:SetTextColor(0.25, 0.14, 0.05)

    f.buttons = {}
    for i, kind in ipairs(KINDS) do f.buttons[i] = BuildSeal(f, i, kind) end

    local trackBorder = Tex(deco, "ARTWORK", 0.2, 0.11, 0.04, 1)
    trackBorder:SetPoint("BOTTOMLEFT", deco, "BOTTOMLEFT", 29, 40)
    trackBorder:SetSize(FRAME_W - 58, 10)
    local track = Tex(deco, "OVERLAY", 0.08, 0.04, 0.02, 1)
    track:SetPoint("CENTER", trackBorder, "CENTER", 0, 0)
    track:SetSize(FRAME_W - 62, 6)
    local fuse = deco:CreateTexture(nil, "OVERLAY", nil, 2)
    fuse:SetTexture(BARTEX)
    fuse:SetVertexColor(1, 0.66, 0.16)
    fuse:SetPoint("LEFT", track, "LEFT", 0, 0)
    fuse:SetSize(FRAME_W - 62, 6)
    local spark = deco:CreateTexture(nil, "OVERLAY", nil, 3)
    spark:SetTexture(SPARK)
    spark:SetBlendMode("ADD")
    spark:SetSize(22, 22)
    spark:SetVertexColor(1, 0.7, 0.2)
    f.setFrac = function(frac)
        fuse:SetWidth(math.max(1, (FRAME_W - 62) * frac))
        fuse:SetTexCoord(0, frac, 0, 1)
        spark:ClearAllPoints()
        spark:SetPoint("CENTER", fuse, "RIGHT", 0, 0)
        if frac < 0.2 then fuse:SetVertexColor(1, 0.3 + frac, 0.12) end
    end

    f.panel = BuildPanel(f, T)

    f.pulse = f.glow:CreateAnimationGroup()
    f.pulse:SetLooping("BOUNCE")
    local pa = f.pulse:CreateAnimation("Alpha")
    pa:SetFromAlpha(0.45)
    pa:SetToAlpha(1)
    pa:SetDuration(1.3)
    f.applyQuality = function(r, g, b, quality)
        f.ring:SetColorTexture(r, g, b, 1)
        f.glow:SetVertexColor(r, g, b)
        f.name:SetTextColor(r, g, b)
        if quality and quality >= 4 then f.pulse:Play() else f.pulse:Stop() end
    end
    return f
end

THEME_BY_ID.skeuo.build = BuildScroll

BuildFrameFor = function(T)
    if T.build then return T.build(T) end
    return BuildGeneric(T)
end

local function Acquire()
    local T = THEME_BY_ID[db.style] or THEMES[1]
    pools[T.id] = pools[T.id] or {}
    local f = table.remove(pools[T.id])
    if not f then f = BuildFrameFor(T) end
    f.closing = nil
    return f
end

local function Setup(f, data)
    local T = f.theme
    f.rollID, f.fake, f.rollTime, f.link = data.rollID, data.fake, data.rollTime or 60000, data.link
    f.chosen, f.entries = nil, nil
    f.itemID = ItemID(data.link)
    f.lastNames = GroupNames()
    if data.fake then f.expire = GetTime() + f.rollTime / 1000 end
    local r, g, b = QualityColor(data.quality)
    f.applyQuality(r, g, b, data.quality)
    f.icon:SetTexture(data.texture)
    f.itemName = data.name or "?"
    local function Texts()
        local ilvl, piece = ItemMeta(f.link)
        local nm = f.itemName
        local spec = T.name or {}
        if spec.upper then nm = nm:upper() end
        local suffix = ""
        if ilvl and not spec.noIlvl then suffix = "  |cffefdcb0(" .. ilvl .. ")|r" end
        f.name:SetText(nm .. suffix)
        f.piece:SetText(piece or "")
        if f.ilvl then
            local text = ""
            if ilvl then
                text = T.ilvl.fmt and string.format(ITEM_LEVEL or "Item Level %d", ilvl) or tostring(ilvl)
            end
            f.ilvl:SetText(text)
        end
    end
    f.refreshTexts = Texts
    Texts()
    if f.bind then f.bind:SetText(data.bop and (ITEM_BIND_ON_PICKUP or "") or "") end
    for _, btn in ipairs(f.buttons) do
        btn:Mark(false)
        btn.reason = nil
        local k = btn.kind.key
        local ok = true
        if k == "need" then
            ok = data.canNeed
            btn.reason = data.reasonNeed
        elseif k == "greed" then
            ok = data.canGreed
            btn.reason = data.reasonGreed
        elseif k == "de" then
            ok = data.canDE
            btn.reason = data.reasonDE
        end
        btn:Paint(ok and true or false)
    end
    f.panel:SetShown(db.showRolls)
    for _, row in ipairs(f.panel.rows) do
        row.icon:Hide()
        row.dot:Hide()
        row.name:Hide()
        row.num:Hide()
        row.hl:Hide()
        row.lead:Hide()
    end
    RefreshPanel(f)
    f:SetAlpha(1)
    f:Show()
    f.fade:Play()
    active[#active + 1] = f
    Layout()
end

local function FindFrame(itemID)
    for _, f in ipairs(active) do
        if f.itemID == itemID then return f end
    end
end

local function OnLootMessage(text)
    local r = Parse(text)
    if not r then return end
    local f = FindFrame(ItemID(r.link))
    if not f then return end
    local name = ShortName(r.player)
    if r.type == "chose" then
        AddEntry(f, name, r.kind)
    elseif r.type == "rolled" then
        AddEntry(f, name, r.kind, r.value)
    elseif r.type == "won" then
        local e = AddEntry(f, name)
        e.won = true
        C_Timer.After(6, function()
            if f.itemID == ItemID(r.link) and f.entries and f.entries[name] and f.entries[name].won then Release(f) end
        end)
    end
    RefreshPanel(f)
end

local function HideBlizzard()
    if GroupLootContainer then
        GroupLootContainer:SetAlpha(0)
        if not GroupLootContainer.brpHooked then
            GroupLootContainer.brpHooked = true
            GroupLootContainer:HookScript("OnShow", function(self) self:SetAlpha(0) end)
        end
    end
end

local function OnStartRoll(rollID, rollTime)
    if not GetLootRollItemInfo then return end
    HideBlizzard()
    local texture, name, _, quality, bop, canNeed, canGreed, canDE, reasonNeed, reasonGreed, reasonDE = GetLootRollItemInfo(rollID)
    if not name then return end
    local f = Acquire()
    Setup(f, {
        rollID = rollID, rollTime = rollTime, link = GetLootRollItemLink(rollID), texture = texture, name = name,
        quality = quality, bop = bop, canNeed = canNeed, canGreed = canGreed, canDE = canDE,
        reasonNeed = reasonNeed, reasonGreed = reasonGreed, reasonDE = reasonDE,
    })
    C_Timer.After(0.6, function()
        if f.rollID == rollID and f.refreshTexts then f.refreshTexts() end
    end)
end

local function OnCancelRoll(rollID)
    for _, f in ipairs(active) do
        if f.rollID == rollID and not f.fake then
            C_Timer.After(f.chosen and 6 or 0, function()
                if f.rollID == rollID then Release(f) end
            end)
        end
    end
end

local FAKE_NAMES = { { "Brannlor", "need", 91 }, { "Mirelle", "need", 63 }, { "Tuk", "need", 41 }, { "Zandri", "greed", 88 }, { "Lyssa", "greed", 57 }, { "Orwen", "pass" } }

local selector

local function RunTest()
    HideBlizzard()
    for i = #active, 1, -1 do
        if active[i].fake then Release(active[i]) end
    end
    local slots = { 1, 3, 5, 7, 10, 15, 16 }
    local shown = 0
    for _, slot in ipairs(slots) do
        local link = GetInventoryItemLink("player", slot)
        if link and shown < 3 then
            local get = (C_Item and C_Item.GetItemInfo) or GetItemInfo
            local name, _, quality, _, _, _, _, _, _, tex = get(link)
            if name then
                shown = shown + 1
                local f = Acquire()
                Setup(f, { fake = true, rollTime = 90000, link = link, texture = tex, name = name, quality = quality, bop = true, canNeed = true, canGreed = true, canDE = shown == 2 })
                for k, e in ipairs(FAKE_NAMES) do
                    C_Timer.After(1 + k * 1.2 + shown * 0.4, function()
                        if f.fake and f.entries then
                            AddEntry(f, e[1], e[2], e[3])
                            RefreshPanel(f)
                        end
                    end)
                end
            end
        end
    end
    if shown == 0 then
        print("|cffffd100BonusRoll Plus|r: no equipped items were found to preview.")
    end
end

local function UpdateSelector()
    if not selector then return end
    for _, b in ipairs(selector.buttons) do
        b.on:SetShown(b.id == db.style)
    end
    local cur = THEME_BY_ID[db.style]
    selector.current:SetText(cur and (cur.title .. " (" .. cur.src .. ")") or "")
end

local function SetStyle(id)
    if not THEME_BY_ID[id] then return end
    db.style = id
    ReleaseAll()
    RunTest()
    UpdateSelector()
end

local function BuildSelector()
    local s = CreateFrame("Frame", "BonusRollPlusStyles", UIParent, "BackdropTemplate")
    s:SetSize(500, 262)
    s:SetPoint("TOP", UIParent, "TOP", 0, -70)
    s:SetFrameStrata("FULLSCREEN_DIALOG")
    s:SetMovable(true)
    s:EnableMouse(true)
    s:RegisterForDrag("LeftButton")
    s:SetScript("OnDragStart", s.StartMoving)
    s:SetScript("OnDragStop", s.StopMovingOrSizing)
    s:SetClampedToScreen(true)
    if s.SetBackdrop then
        s:SetBackdrop({ bgFile = WHITE, edgeFile = TOOLEDGE, edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 } })
        s:SetBackdropColor(0.06, 0.05, 0.04, 0.96)
        s:SetBackdropBorderColor(0.83, 0.64, 0.27, 1)
    end
    local title = s:CreateFontString(nil, "OVERLAY")
    Font(title, F_MORPH, 18)
    title:SetPoint("TOPLEFT", s, "TOPLEFT", 16, -14)
    title:SetTextColor(0.95, 0.82, 0.46)
    title:SetText("BonusRoll Plus")
    s.current = s:CreateFontString(nil, "OVERLAY")
    Font(s.current, F_FRIZ, 12)
    s.current:SetPoint("TOPRIGHT", s, "TOPRIGHT", -44, -18)
    s.current:SetTextColor(0.8, 0.72, 0.55)
    local hint = s:CreateFontString(nil, "OVERLAY")
    Font(hint, F_FRIZ, 11)
    hint:SetPoint("TOPLEFT", s, "TOPLEFT", 16, -38)
    hint:SetTextColor(0.62, 0.56, 0.44)
    hint:SetText(ES and "Pulsa un estilo para verlo en vivo con tus objetos." or "Click a style to preview it live with your items.")
    local close = CreateFrame("Button", nil, s, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", s, "TOPRIGHT", -2, -2)
    s.buttons = {}
    for i, T in ipairs(THEMES) do
        local col = i <= 5 and 0 or 1
        local row = (i - 1) % 5
        local b = CreateFrame("Button", nil, s)
        b:SetSize(236, 34)
        b:SetPoint("TOPLEFT", s, "TOPLEFT", 12 + col * 244, -62 - row * 38)
        b.id = T.id
        local bg = Tex(b, "BACKGROUND", 0.14, 0.11, 0.08, 1)
        bg:SetAllPoints()
        b.on = Tex(b, "BORDER", 0.83, 0.64, 0.27, 1)
        b.on:SetAllPoints()
        local inner = Tex(b, "ARTWORK", 0.14, 0.11, 0.08, 1)
        inner:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2)
        inner:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2)
        b.hl = Tex(b, "HIGHLIGHT", 1, 1, 1, 0.1)
        b.hl:SetAllPoints()
        local label = b:CreateFontString(nil, "OVERLAY")
        Font(label, F_FRIZ, 12)
        label:SetPoint("LEFT", b, "LEFT", 10, 5)
        label:SetTextColor(0.95, 0.9, 0.78)
        label:SetText(T.title)
        local src = b:CreateFontString(nil, "OVERLAY")
        Font(src, F_FRIZ, 10)
        src:SetPoint("LEFT", b, "LEFT", 10, -8)
        if T.src == SRC_UI then src:SetTextColor(0.55, 0.78, 1) else src:SetTextColor(0.7, 0.9, 0.55) end
        src:SetText("(" .. T.src .. ")")
        b:SetScript("OnClick", function() SetStyle(T.id) end)
        s.buttons[#s.buttons + 1] = b
    end
    return s
end

local function ShowSelector()
    if not selector then selector = BuildSelector() end
    selector:Show()
    UpdateSelector()
end

local function Slash(msg)
    local cmd, arg = (msg or ""):match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    if cmd == "test" then
        ShowSelector()
        RunTest()
    elseif cmd == "style" or cmd == "estilo" then
        if arg ~= "" and THEME_BY_ID[arg:lower()] then
            SetStyle(arg:lower())
        else
            ShowSelector()
            local ids = {}
            for _, T in ipairs(THEMES) do ids[#ids + 1] = T.id end
            print("|cffffd100BonusRoll Plus|r: /br style <" .. table.concat(ids, " | ") .. ">")
        end
    elseif cmd == "scale" then
        local v = tonumber(arg)
        if v and v >= 0.5 and v <= 1.5 then
            db.scale = v
            stack:SetScale(v)
        else
            print("|cffffd100BonusRoll Plus|r: /br scale 0.5 - 1.5")
        end
    elseif cmd == "rolls" then
        db.showRolls = not db.showRolls
        for _, f in ipairs(active) do f.panel:SetShown(db.showRolls) end
    elseif cmd == "reset" then
        db.x, db.y = nil, nil
        anchor:ClearAllPoints()
        anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", -100, 190)
    else
        print("|cffffd100BonusRoll Plus|r: /br test | style [id] | scale <0.5-1.5> | rolls | reset. Shift+drag a window to move it.")
    end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, a, b)
    if event == "ADDON_LOADED" and a == ADDON then
        BonusRollPlusDB = BonusRollPlusDB or {}
        db = BonusRollPlusDB
        if db.v ~= DEFAULTS.v then
            db.scale = DEFAULTS.scale
            db.v = DEFAULTS.v
        end
        for k, v in pairs(DEFAULTS) do
            if db[k] == nil then db[k] = v end
        end
        if not THEME_BY_ID[db.style] then db.style = DEFAULTS.style end
        anchor = CreateFrame("Frame", "BonusRollPlusAnchor", UIParent)
        anchor:SetSize(FRAME_W, 1)
        anchor:SetMovable(true)
        anchor:SetClampedToScreen(true)
        if db.x and db.y then
            anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", db.x, db.y)
        else
            anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", -100, 190)
        end
        stack = CreateFrame("Frame", nil, anchor)
        stack:SetSize(FRAME_W, 1)
        stack:SetPoint("BOTTOM", anchor, "BOTTOM", 0, 0)
        stack:SetScale(db.scale)
        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("START_LOOT_ROLL")
        self:RegisterEvent("CANCEL_LOOT_ROLL")
        self:RegisterEvent("CHAT_MSG_LOOT")
        self:RegisterEvent("PLAYER_LOGIN")
        SLASH_BONUSROLLPLUS1 = "/br"
        SLASH_BONUSROLLPLUS2 = "/bonusroll"
        SlashCmdList.BONUSROLLPLUS = Slash
    elseif event == "PLAYER_LOGIN" then
        HideBlizzard()
    elseif event == "START_LOOT_ROLL" then
        OnStartRoll(a, b)
    elseif event == "CANCEL_LOOT_ROLL" then
        OnCancelRoll(a)
    elseif event == "CHAT_MSG_LOOT" then
        OnLootMessage(a)
    end
end)

ns.Compile = Compile
ns.Match = Match
ns.Parse = Parse
ns.Themes = THEMES
