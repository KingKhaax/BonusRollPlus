local ADDON, ns = ...

local DEFAULTS = { scale = 1, showRolls = true, locked = false, v = 3, theme = "glass", maxVisible = 3, alpha = 1, showUpgrade = true, compact = true }
local db

local F_FRIZ = "Fonts\\FRIZQT__.TTF"
local F_MORPH = "Fonts\\MORPHEUS.TTF"
local F_ARIAL = "Fonts\\ARIALN.TTF"
local WHITE = "Interface\\Buttons\\WHITE8X8"
local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local GLOW = "Interface\\Buttons\\UI-ActionButton-Border"
local LEADER = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
local SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark"

local L = ns.L
local LOCALE_FONT = { ruRU = true, koKR = true, zhCN = true, zhTW = true }

local KINDS = {
    { key = "need", roll = 1, label = NEED or "Need", atlas = "lootroll-toast-icon-need-up", file = "Interface\\Buttons\\UI-GroupLoot-Dice-Up", wax = { 0.78, 0.17, 0.13 } },
    { key = "greed", roll = 2, label = GREED or "Greed", atlas = "lootroll-toast-icon-greed-up", file = "Interface\\Buttons\\UI-GroupLoot-Coin-Up", wax = { 0.82, 0.62, 0.17 } },
    { key = "de", roll = 3, label = ROLL_DISENCHANT or "Disenchant", atlas = "lootroll-toast-icon-disenchant-up", file = "Interface\\Buttons\\UI-GroupLoot-DE-Up", wax = { 0.5, 0.3, 0.7 } },
    { key = "pass", roll = 0, label = ns.Strings[ns.locale].PASS or PASS or "Pass", atlas = "lootroll-toast-icon-pass-up", file = "Interface\\Buttons\\UI-GroupLoot-Pass-Up", wax = { 0.33, 0.29, 0.26 } },
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
    { "LOOT_ROLL_ALL_PASSED", "allpassed", nil, { "link" } },
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
    name = tostring(name)
    name = name:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h%[?(.-)%]?|h", "%1")
    name = name:match("^%s*(.-)%s*$")
    return Ambiguate and Ambiguate(name, "short") or name
end

local classCache = {}
local TEST_CLASS = { Brannlor = "WARRIOR", Mirelle = "MAGE", Tuk = "SHAMAN", Zandri = "ROGUE", Lyssa = "PRIEST", Orwen = "DRUID", Ben = "HUNTER" }
local function ClassOf(name)
    name = ShortName(name)
    if classCache[name] then return classCache[name] end
    local units = { "player" }
    local n = GetNumGroupMembers and GetNumGroupMembers() or 0
    local prefix = IsInRaid and IsInRaid() and "raid" or "party"
    for i = 1, n do units[#units + 1] = prefix .. i end
    for _, u in ipairs(units) do
        if UnitExists(u) and ShortName(UnitName(u)) == name then
            local _, class = UnitClass(u)
            if class then
                classCache[name] = class
                return class
            end
        end
    end
    return TEST_CLASS[name]
end

local function SetClassIcon(tex, class)
    local co = class and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[class]
    if co then
        tex:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
        tex:SetTexCoord(co[1], co[2], co[3], co[4])
    else
        tex:SetTexture("Interface/Icons/INV_Misc_QuestionMark")
        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
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

local function MatchGroupName(name)
    local n = GetNumGroupMembers and GetNumGroupMembers() or 0
    local prefix = IsInRaid and IsInRaid() and "raid" or "party"
    local units = { "player" }
    for i = 1, n do units[#units + 1] = prefix .. i end
    for _, u in ipairs(units) do
        if UnitExists(u) then
            local member = ShortName(UnitName(u))
            if name == member or name:sub(1, #member + 1) == member .. " " then return member end
        end
    end
    return name
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

local SLOT_OF = {
    INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_CHEST = { 5 }, INVTYPE_ROBE = { 5 },
    INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 }, INVTYPE_HAND = { 10 },
    INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 }, INVTYPE_WEAPON = { 16, 17 },
    INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 }, INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 },
    INVTYPE_HOLDABLE = { 17 }, INVTYPE_RANGED = { 16 }, INVTYPE_RANGEDRIGHT = { 16 },
}

local function EquippedLevel(slot)
    local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
    if not link then return nil end
    if C_Item and C_Item.GetDetailedItemLevelInfo then
        local detailed = C_Item.GetDetailedItemLevelInfo(link)
        if detailed and detailed > 0 then return detailed end
    end
    local get = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local _, _, _, level = get(link)
    return level
end

local function UpgradeDelta(link, ilvl)
    if not link or not ilvl then return nil end
    local get = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local _, _, _, _, _, _, _, _, equipLoc = get(link)
    local slots = equipLoc and SLOT_OF[equipLoc]
    if not slots then return nil end
    local weapon = equipLoc:find("WEAPON") or equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE"
    local weakest
    for _, slot in ipairs(slots) do
        local level = EquippedLevel(slot)
        if not level then
            if not weapon then return ilvl end
        elseif not weakest or level < weakest then
            weakest = level
        end
    end
    if not weakest then return nil end
    return ilvl - weakest
end

local function DeltaText(d)
    if d > 0 then return "|cff40ff40+" .. d .. "|r" end
    if d < 0 then return "|cffff5050" .. d .. "|r" end
    return "|cffaaaaaa=|r"
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
    if LOCALE_FONT[ns.locale] then path = STANDARD_TEXT_FONT end
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

local FRAME_W, PANEL_W = 300, 214

local THEMES = {
    {
        id = "glass", title = "Cristal Esmerilado", src = "UI UX Pro Max", w = 300, h = 250,
        ops = {
            { op = "rect", x = 0, y = 0, c = "#1E2A5A", a = 0.6 },
            { op = "grad", x = 0, y = 0, w = 300, h = 90, dir = "VERTICAL", c1 = "#FFFFFF", a1 = 0, c2 = "#FFFFFF", a2 = 0.16 },
            { op = "outline", x = 0, y = 0, w = 300, h = 250, th = 1, c = "#FFFFFF", a = 0.32 },
            { op = "rect", x = 1, y = 1, w = 298, h = 1, c = "#FFFFFF", a = 0.5 },
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
}

for _, t in ipairs(ns.ThemeDefs or {}) do THEMES[#THEMES + 1] = t end
local THEME_BY_ID = {}
for _, t in ipairs(THEMES) do THEME_BY_ID[t.id] = t end

local anchor, stack
local pools, active = {}, {}
local rollToken = 0

local BuildMini, MiniRefresh
local MINI_H, MINI_MAX = 26, 8

local function Layout()
    local MAX_VISIBLE = (db and db.maxVisible) or 3
    local y, w, shown, minis = 0, FRAME_W, 0, 0
    for _, f in ipairs(active) do
        if shown < MAX_VISIBLE then
            shown = shown + 1
            f:ClearAllPoints()
            f:SetPoint("BOTTOMLEFT", stack, "BOTTOMLEFT", 0, y)
            y = y + f.h + 12
            w = f.w
            if f.mini then f.mini:Hide() end
            if f.queued then
                f.queued = nil
                f:SetAlpha(1)
                f:Show()
                f.panel:SetShown(db.showRolls)
                f.fade:Play()
            end
        else
            f.queued = true
            f:Hide()
            f.panel:Hide()
            if db.compact and minis < MINI_MAX then
                minis = minis + 1
                local m = f.mini or BuildMini(f)
                m:ClearAllPoints()
                m:SetPoint("BOTTOMLEFT", stack, "BOTTOMLEFT", 0, y)
                y = y + MINI_H + 4
                MiniRefresh(f)
                m:Show()
            elseif f.mini then
                f.mini:Hide()
            end
        end
    end
    stack:SetWidth(w)
end

local endBtn, Release
local function UpdateEndBtn()
    local any = false
    for _, a in ipairs(active) do if a.fake then any = true break end end
    if any and not endBtn then
        endBtn = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
        endBtn:SetSize(150, 24)
        endBtn:SetFrameStrata("HIGH")
        endBtn:SetPoint("TOP", anchor, "BOTTOM", 0, -6)
        endBtn:SetText(L.END_TEST)
        endBtn:SetScript("OnClick", function()
            for i = #active, 1, -1 do
                if active[i].fake then Release(active[i]) end
            end
        end)
    end
    if endBtn then endBtn:SetShown(any) end
end

function Release(f)
    f:Hide()
    if f.mini then f.mini:Hide() end
    f.panel:Hide()
    f.rollID, f.fake, f.entries, f.chosen, f.closing, f.queued, f.closingSoon = nil, nil, nil, nil, nil, nil, nil
    for i, a in ipairs(active) do
        if a == f then table.remove(active, i) break end
    end
    local pool = pools[f.themeId]
    if pool then pool[#pool + 1] = f end
    Layout()
    UpdateEndBtn()
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
            row.dot = p:CreateTexture(nil, "ARTWORK")
            row.dot:SetSize(15, 15)
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
            SetClassIcon(row.dot, ClassOf(ShortName(e.name)))
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
    if f.mini then ns.MiniMark(f) end
    RefreshPanel(f)
end

local function ButtonTooltip(b)
    GameTooltip:SetOwner(b, "ANCHOR_TOP")
    GameTooltip:SetText(b.kind.label)
    if b.warn then GameTooltip:AddLine(L.CANT_USE, 1, 0.45, 0.2, true) end
    if (not b.enabled or b.warn) and b.reason then
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
        if not db.locked then anchor:StartMoving() end
    end)
    local lock = CreateFrame("Button", nil, f)
    lock:SetSize(18, 18)
    lock:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    lock:SetFrameLevel(f:GetFrameLevel() + 20)
    lock:SetNormalTexture("Interface\\Buttons\\LockButton-Locked-Up")
    lock:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    lock.Refresh = function(self)
        self:SetNormalTexture(db.locked and "Interface\\Buttons\\LockButton-Locked-Up" or "Interface\\Buttons\\LockButton-Unlocked-Up")
        self:SetAlpha(db.locked and 0.55 or 1)
    end
    lock:SetScript("OnShow", lock.Refresh)
    lock:SetScript("OnClick", function() ns.SetLocked(not db.locked) end)
    lock:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(db.locked and L.LOCKED_TIP or L.UNLOCKED_TIP)
        GameTooltip:Show()
    end)
    lock:SetScript("OnLeave", function() GameTooltip:Hide() end)
    f.lock = lock
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
    do
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
    p.title:SetText(L.TITLE)
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

function BuildMini(f)
    local P = f.theme.panel
    local m = CreateFrame("Frame", nil, stack)
    m:SetSize(FRAME_W, MINI_H)
    m.bg = Tex(m, "BACKGROUND", Hex(P.bg, 0.92))
    m.bg:SetAllPoints()
    Outline(m, "BORDER", 0, 0, 0, FRAME_W, MINI_H, 1, P.border, P.borderA)
    m.ring = Tex(m, "ARTWORK", 1, 1, 1, 1)
    m.ring:SetPoint("LEFT", 3, 0)
    m.ring:SetSize(22, 22)
    m.icon = m:CreateTexture(nil, "OVERLAY")
    m.icon:SetSize(18, 18)
    m.icon:SetPoint("CENTER", m.ring, "CENTER")
    m.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    m.name = m:CreateFontString(nil, "OVERLAY")
    Font(m.name, f.theme.name.font, 12)
    m.name:SetPoint("LEFT", m.ring, "RIGHT", 6, 0)
    m.name:SetWidth(FRAME_W - 40 - #KINDS * 22)
    m.name:SetJustifyH("LEFT")
    m.name:SetWordWrap(false)
    m.bar = Tex(m, "ARTWORK", Hex(P.hi))
    m.bar:SetPoint("BOTTOMLEFT", 1, 1)
    m.bar:SetHeight(2)
    m.btns = {}
    for i, kind in ipairs(KINDS) do
        local b = CreateFrame("Button", nil, m)
        b:SetSize(20, 20)
        b:SetPoint("RIGHT", m, "RIGHT", -4 - (#KINDS - i) * 22, 0)
        b.kind = kind
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetAllPoints()
        SetKindIcon(b.icon, kind)
        b.hl = b:CreateTexture(nil, "HIGHLIGHT")
        b.hl:SetAllPoints()
        b.hl:SetColorTexture(1, 1, 1, 0.2)
        b:SetScript("OnClick", function(self)
            local full = f.buttons[i]
            if full and full.enabled then Choose(f, self.kind) end
        end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(self.kind.label)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        m.btns[i] = b
    end
    m:SetScript("OnUpdate", function(self)
        local frac
        if f.fake and f.expire then
            frac = (f.expire - GetTime()) / (f.rollTime / 1000)
        elseif f.rollID and GetLootRollTimeLeft then
            frac = GetLootRollTimeLeft(f.rollID) / (f.rollTime or 60000)
        end
        if frac then
            if frac < 0 then frac = 0 elseif frac > 1 then frac = 1 end
            self.bar:SetWidth(math.max(1, (FRAME_W - 2) * frac))
        end
    end)
    f.mini = m
    return m
end

function ns.MiniMark(f)
    local m = f.mini
    if not m then return end
    for i, b in ipairs(m.btns) do
        local full = f.buttons[i]
        local usable = full and full.enabled
        b.icon:SetDesaturated(not usable)
        if f.chosen then
            b:SetAlpha(b.kind.key == f.chosen and 1 or 0.25)
        else
            b:SetAlpha(usable and 1 or 0.35)
        end
    end
end

function MiniRefresh(f)
    local m = f.mini
    if not m then return end
    m.icon:SetTexture(f.icon:GetTexture())
    local r, g, b = f.qr or 1, f.qg or 1, f.qb or 1
    m.ring:SetColorTexture(r, g, b, 1)
    m.name:SetTextColor(r, g, b)
    local ilvl = ItemMeta(f.link)
    m.name:SetText((f.itemName or "?") .. (ilvl and ("  |cffefdcb0(" .. ilvl .. ")|r") or ""))
    ns.MiniMark(f)
end

local function Acquire()
    local T = THEME_BY_ID[db.theme] or THEMES[1]
    pools[T.id] = pools[T.id] or {}
    local f = table.remove(pools[T.id])
    if not f then f = BuildGeneric(T) end
    f.closing = nil
    return f
end

local function Setup(f, data)
    local T = f.theme
    f.rollID, f.fake, f.rollTime, f.link = data.rollID, data.fake, data.rollTime or 60000, data.link
    rollToken = rollToken + 1
    f.token = rollToken
    f.deadline = GetTime() + (f.rollTime or 60000) / 1000 + 10
    f.chosen, f.entries = nil, nil
    f.itemID = ItemID(data.link)
    f.lastNames = GroupNames()
    if data.fake then f.expire = GetTime() + f.rollTime / 1000 end
    local r, g, b = QualityColor(data.quality)
    f.applyQuality(r, g, b, data.quality)
    f.qr, f.qg, f.qb = r, g, b
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
        local pieceText = piece or ""
        if db.showUpgrade then
            local delta = UpgradeDelta(f.link, ilvl)
            if delta then pieceText = pieceText .. "  " .. DeltaText(delta) end
        end
        f.piece:SetText(pieceText)
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
    if f.bind then
        if data.canNeed == false then
            f.bind:SetText("|cffff5555" .. L.CANT_USE .. "|r")
        else
            f.bind:SetText(data.bop and (ITEM_BIND_ON_PICKUP or "") or "")
        end
    end
    for _, btn in ipairs(f.buttons) do
        btn:Mark(false)
        btn.reason = nil
        local k = btn.kind.key
        local ok = true
        btn.warn = nil
        if k == "need" then
            ok = true
            btn.warn = data.canNeed == false
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

local function FindFrame(itemID, link)
    for _, f in ipairs(active) do
        if itemID and f.itemID == itemID then return f end
    end
    local name = type(link) == "string" and link:match("|h%[(.-)%]|h")
    if name then
        for _, f in ipairs(active) do
            if f.itemName and f.itemName:lower() == name:lower() then return f end
        end
    end
end

local AFTER_AWARD = 5

local function Readable(v)
    if v == nil then return false end
    return not (issecretvalue and issecretvalue(v))
end

local function MarkWon(f, name, link)
    local e = AddEntry(f, name)
    if e.won then return end
    e.won = true
    if db.history then
        table.insert(db.history, {
            t = time(), link = link, winner = name, kind = e.kind, value = e.value,
            me = name == ShortName(UnitName("player")),
        })
        while #db.history > 100 do table.remove(db.history, 1) end
    end
    local token = f.token
    f.closingSoon = true
    C_Timer.After(AFTER_AWARD, function()
        if f.token == token and f.closingSoon then Release(f) end
    end)
end

local function ReleaseAfterAward(f)
    if f.closingSoon then return end
    f.closingSoon = true
    local token = f.token
    C_Timer.After(AFTER_AWARD, function()
        if f.token == token and f.closingSoon then Release(f) end
    end)
end

local debugOn = false

local function OnLootMessage(text)
    local r = Parse(text)
    if debugOn then
        local ok, raw = pcall(tostring, text)
        print("|cff55ccffBRP|r chat: " .. (ok and raw or "<unreadable>"))
        print("|cff55ccffBRP|r parsed: " .. (r and (tostring(r.type) .. " / " .. tostring(r.kind) .. " / " .. tostring(r.player)) or "no match"))
    end
    if not r then return end
    local f = FindFrame(ItemID(r.link), r.link)
    if debugOn then
        local ok, raw = pcall(tostring, text)
        if ok then print("|cff55ccffBRP|r raw: " .. raw:gsub("|", "||")) end
        print("|cff55ccffBRP|r player=" .. type(r.player) .. ":" .. tostring(r.player):gsub("|", "||") .. "  itemID=" .. tostring(ItemID(r.link)))
        local ids = {}
        for _, w in ipairs(active) do ids[#ids + 1] = tostring(w.itemID) .. "=" .. tostring(w.itemName) end
        print("|cff55ccffBRP|r windows: " .. (#ids > 0 and table.concat(ids, ", ") or "none") .. "  found: " .. tostring(f ~= nil))
    end
    if not f then return end
    if r.type == "allpassed" then
        ReleaseAfterAward(f)
        return
    end
    local name = MatchGroupName(ShortName(r.player))
    if r.type == "chose" then
        AddEntry(f, name, r.kind)
    elseif r.type == "rolled" then
        AddEntry(f, name, r.kind, r.value)
    elseif r.type == "won" then
        MarkWon(f, name, r.link)
    end
    RefreshPanel(f)
end

local function RollKind(state)
    local S = (Enum and Enum.EncounterLootDropRollState) or {}
    if state == (S.NeedMainSpec or 0) or state == (S.NeedOffSpec or 1) then return "need" end
    if state == (S.Greed or 3) or state == (S.Transmog or 2) then return "greed" end
    if state == (S.Pass or 5) then return "pass" end
end

local function ApplyDrop(drop)
    if type(drop) ~= "table" or not Readable(drop.itemHyperlink) then return end
    local f = FindFrame(ItemID(drop.itemHyperlink), drop.itemHyperlink)
    if not f then return end
    local winnerName
    for _, roll in ipairs(drop.rollInfos or {}) do
        if Readable(roll.playerName) and Readable(roll.state) then
            local kind = RollKind(roll.state)
            if kind then
                local name = MatchGroupName(ShortName(roll.playerName))
                AddEntry(f, name, kind, Readable(roll.roll) and roll.roll or nil)
                if roll.isWinner == true then winnerName = name end
            end
        end
    end
    if winnerName then
        MarkWon(f, winnerName, drop.itemHyperlink)
    elseif drop.allPassed == true then
        ReleaseAfterAward(f)
    end
    RefreshPanel(f)
end

local function OnHistoryDrop(encounterID, lootListID)
    if C_LootHistory and C_LootHistory.GetSortedInfoForDrop and Readable(encounterID) and Readable(lootListID) then
        ApplyDrop(C_LootHistory.GetSortedInfoForDrop(encounterID, lootListID))
    end
end

local function SyncFromHistory(f)
    if not (C_LootHistory and C_LootHistory.GetAllEncounterInfos and C_LootHistory.GetSortedDropsForEncounter) then return end
    for _, encounter in ipairs(C_LootHistory.GetAllEncounterInfos() or {}) do
        for _, drop in ipairs(C_LootHistory.GetSortedDropsForEncounter(encounter.encounterID) or {}) do
            if type(drop) == "table" and Readable(drop.itemHyperlink) and FindFrame(ItemID(drop.itemHyperlink), drop.itemHyperlink) == f then
                ApplyDrop(drop)
            end
        end
    end
end

local ROLL_BUTTONS = { "NeedButton", "GreedButton", "TransmogButton", "DisenchantButton", "PassButton" }

local function Mute(f)
    if type(f) ~= "table" or not f.SetAlpha then return end
    if f.IsForbidden and f:IsForbidden() then return end
    f:SetAlpha(0)
    if f.EnableMouse then f:EnableMouse(false) end
    for _, key in ipairs(ROLL_BUTTONS) do
        local b = f[key]
        if type(b) == "table" and b.EnableMouse and not (b.IsProtected and b:IsProtected()) then b:EnableMouse(false) end
    end
end

local hooked
local function HideBlizzard()
    local c = _G.GroupLootContainer
    for i = 1, 4 do Mute(_G["GroupLootFrame" .. i]) end
    if c and type(c.rollFrames) == "table" then
        for _, rf in pairs(c.rollFrames) do Mute(rf) end
    end
    if not hooked and hooksecurefunc then
        hooked = true
        local function later() C_Timer.After(0, HideBlizzard) end
        if type(_G.GroupLootContainer_AddFrame) == "function" then hooksecurefunc("GroupLootContainer_AddFrame", later) end
        if type(_G.GroupLootContainer_Update) == "function" then hooksecurefunc("GroupLootContainer_Update", later) end
    end
end

local function OnStartRoll(rollID, rollTime)
    for _, delay in ipairs({ 0, 0.2, 0.6, 1.5 }) do C_Timer.After(delay, HideBlizzard) end
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
        if f.rollID == rollID then SyncFromHistory(f) end
    end)
end

local function OnCancelRoll(rollID)
    for _, f in ipairs(active) do
        if f.rollID == rollID and not f.fake then
            local hasWinner = false
            for _, e in pairs(f.entries or {}) do
                if e.won then hasWinner = true break end
            end
            if hasWinner or f.closingSoon then
                -- the award already closes it a few seconds later
            elseif f.chosen or (f.entries and next(f.entries)) then
                -- the roll is over but the item has not been awarded yet: wait for the winner
                local wait = math.max(1, (f.deadline or 0) - GetTime())
                local token = f.token
                C_Timer.After(wait, function()
                    if f.token == token and not f.closingSoon then Release(f) end
                end)
            else
                Release(f)
            end
        end
    end
end

local FAKE_NAMES = { { "Brannlor", "need", 91 }, { "Mirelle", "need", 63 }, { "Tuk", "need", 41 }, { "Zandri", "greed", 88 }, { "Lyssa", "greed", 57 }, { "Orwen", "pass" } }

local function RunTest()
    HideBlizzard()
    for i = #active, 1, -1 do
        if active[i].fake then Release(active[i]) end
    end
    local slots = { 1, 3, 5, 7, 10, 15, 16 }
    local shown = 0
    for _, slot in ipairs(slots) do
        local link = GetInventoryItemLink("player", slot)
        if link and shown < 5 then
            local get = (C_Item and C_Item.GetItemInfo) or GetItemInfo
            local name, _, quality, _, _, _, _, _, _, tex = get(link)
            if name then
                shown = shown + 1
                local f = Acquire()
                Setup(f, { fake = true, rollTime = 90000, link = link, texture = tex, name = name, quality = quality, bop = true, canNeed = shown ~= 3, reasonNeed = shown == 3 and 1 or nil, canGreed = true, canDE = shown == 2 })
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
        print("|cffffd100BonusRoll Plus|r: " .. L.NO_ITEMS)
    end
    UpdateEndBtn()
end

function ns.TestActive()
    for _, a in ipairs(active) do if a.fake then return true end end
    return false
end

function ns.EndTest()
    for i = #active, 1, -1 do
        if active[i].fake then Release(active[i]) end
    end
end

function ns.ApplyTheme(id)
    if not THEME_BY_ID[id] then return end
    db.theme = id
    local hadTest = false
    for _, a in ipairs(active) do if a.fake then hadTest = true break end end
    if hadTest then RunTest() end
end

function ns.SetScale(v)
    db.scale = v
    stack:SetScale(v)
end

function ns.SetAlpha(v)
    db.alpha = v
    stack:SetAlpha(v)
end

function ns.SetMaxVisible(n)
    db.maxVisible = n
    Layout()
end

function ns.SetShowRolls(v)
    db.showRolls = v and true or false
    for _, f in ipairs(active) do f.panel:SetShown(db.showRolls and not f.queued) end
end

function ns.SetCompact(v)
    db.compact = v and true or false
    Layout()
end

function ns.SetShowUpgrade(v)
    db.showUpgrade = v and true or false
    for _, f in ipairs(active) do
        if f.refreshTexts then f.refreshTexts() end
    end
end

function ns.SetPosition(x, y)
    db.x, db.y = x, y
    anchor:ClearAllPoints()
    if x and y then
        anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", x, y)
    else
        anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", -100, 190)
    end
end

function ns.PrintHistory(n)
    local list = db.history or {}
    print("|cffffd100BonusRoll Plus|r: " .. L.HISTORY_TITLE)
    if #list == 0 then
        print(L.HISTORY_EMPTY)
        return
    end
    for i = math.max(1, #list - (n or 10) + 1), #list do
        local h = list[i]
        local who = h.me and ("|cff40ff40" .. h.winner .. "|r") or h.winner
        local roll = h.value and (" (" .. h.value .. ")") or ""
        print(string.format("%s  %s  >  %s%s", date("%d/%m %H:%M", h.t), h.link or "?", who, roll))
    end
end

function ns.ClearHistory()
    if db.history then wipe(db.history) end
    print("|cffffd100BonusRoll Plus|r: " .. L.HISTORY_CLEARED)
end

function ns.ResetPosition()
    db.x, db.y = nil, nil
    anchor:ClearAllPoints()
    anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", -100, 190)
end

function ns.RunTest() RunTest() end
function ns.GetDB() return db end
function ns.GetDefaults() return DEFAULTS end
ns.ThemeList = THEMES

function ns.BuildPreview(T, parent)
    local f = BuildGeneric(T)
    f:SetParent(parent)
    f:SetFrameStrata(parent:GetFrameStrata())
    f:SetScript("OnDragStart", nil)
    f:SetScript("OnUpdate", nil)
    f:EnableMouse(false)
    f.lock:Hide()
    f.iconHit:EnableMouse(false)
    f.panel:Hide()
    local r, g, b = QualityColor(3)
    f.applyQuality(r, g, b, 3)
    local tex = GetInventoryItemTexture and GetInventoryItemTexture("player", 5)
    f.icon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
    local slot = INVTYPE_CHEST or "Chest"
    local sub = C_Item and C_Item.GetItemSubClassInfo and C_Item.GetItemSubClassInfo(4, 3)
    f.name:SetText(L.SAMPLE_ITEM .. "  |cffefdcb0(27)|r")
    f.piece:SetText(sub and (slot .. " · " .. sub) or slot)
    if f.bind then f.bind:SetText(ITEM_BIND_ON_PICKUP or "") end
    for _, btn in ipairs(f.buttons) do
        btn:EnableMouse(false)
        btn:Paint(true)
        btn:Mark(btn.kind.key == "need")
    end
    if f.setFrac then f.setFrac(0.65) end
    return f
end

local PREFIX = "BRPLUS"

local function ParseVersion(v)
    local a, b, c = tostring(v or ""):match("^(%d+)%.(%d+)%.(%d+)$")
    if not a then return end
    return tonumber(a) * 1000000 + tonumber(b) * 1000 + tonumber(c)
end

local function MyVersion()
    local get = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return get and get(ADDON, "Version") or "0.0.0"
end

local warnedFor = 0

local function CheckVersion(remote)
    local mine, theirs = ParseVersion(MyVersion()), ParseVersion(remote)
    if not mine or not theirs or theirs <= mine or theirs <= warnedFor then return end
    warnedFor = theirs
    print("|cffffd100BonusRoll Plus|r: " .. string.format(L.VERSION_OUTDATED, MyVersion(), remote))
end

local lastAnnounce = -100

local function Announce()
    local send = C_ChatInfo and C_ChatInfo.SendAddonMessage
    if not send then return end
    local now = GetTime()
    if now - lastAnnounce < 20 then return end
    lastAnnounce = now
    local msg = "V:" .. MyVersion()
    if LE_PARTY_CATEGORY_INSTANCE and IsInGroup and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        send(PREFIX, msg, "INSTANCE_CHAT")
    elseif IsInRaid and IsInRaid() then
        send(PREFIX, msg, "RAID")
    elseif IsInGroup and IsInGroup() then
        send(PREFIX, msg, "PARTY")
    end
    if IsInGuild and IsInGuild() then send(PREFIX, msg, "GUILD") end
end

local function OnAddonMessage(prefix, text, _, sender)
    if prefix ~= PREFIX or type(text) ~= "string" then return end
    if ShortName(sender) == ShortName(UnitName("player")) then return end
    local remote = text:match("^V:(%d+%.%d+%.%d+)$")
    if remote then CheckVersion(remote) end
end

function ns.SetLocked(v)
    db.locked = v and true or false
    for _, f in ipairs(active) do f.lock:Refresh() end
end

local function Slash(msg)
    local cmd, arg = (msg or ""):match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    if cmd == "test" then
        RunTest()
    elseif cmd == "scale" then
        local v = tonumber(arg)
        if v and v >= 0.5 and v <= 1.5 then
            db.scale = v
            stack:SetScale(v)
        else
            print("|cffffd100BonusRoll Plus|r: " .. L.SCALE_USAGE)
        end
    elseif cmd == "rolls" then
        db.showRolls = not db.showRolls
        for _, f in ipairs(active) do f.panel:SetShown(db.showRolls and not f.queued) end
    elseif cmd == "open" or cmd == "options" or cmd == "settings" then
        if ns.OpenSettings then ns.OpenSettings() end
    elseif cmd == "debug" then
        debugOn = not debugOn
        print("|cffffd100BonusRoll Plus|r: debug " .. (debugOn and "ON" or "OFF"))
    elseif cmd == "history" then
        if arg:lower() == "clear" then ns.ClearHistory() else ns.PrintHistory(tonumber(arg) or 10) end
    elseif cmd == "version" then
        print("|cffffd100BonusRoll Plus|r: " .. MyVersion())
    elseif cmd == "lock" then
        ns.SetLocked(not db.locked)
        print("|cffffd100BonusRoll Plus|r: " .. (db.locked and L.LOCKED_TIP or L.UNLOCKED_TIP))
    elseif cmd == "reset" then
        ns.ResetPosition()
    else
        print("|cffffd100BonusRoll Plus|r: " .. L.HELP)
    end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, a, b, c, d)
    if event == "ADDON_LOADED" and a == ADDON then
        BonusRollPlusDB = BonusRollPlusDB or {}
        db = BonusRollPlusDB
        db.history = db.history or {}
        db.profiles = db.profiles or {}
        db.charProfile = db.charProfile or {}
        if db.v ~= DEFAULTS.v then
            db.scale = DEFAULTS.scale
            db.style = nil
            db.v = DEFAULTS.v
        end
        for k, v in pairs(DEFAULTS) do
            if db[k] == nil then db[k] = v end
        end
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
        stack:SetAlpha(db.alpha)
        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("START_LOOT_ROLL")
        self:RegisterEvent("CANCEL_LOOT_ROLL")
        self:RegisterEvent("CHAT_MSG_LOOT")
        pcall(self.RegisterEvent, self, "LOOT_HISTORY_UPDATE_DROP")
        self:RegisterEvent("PLAYER_LOGIN")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("CHAT_MSG_ADDON")
        if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then C_ChatInfo.RegisterAddonMessagePrefix(PREFIX) end
        SLASH_BONUSROLLPLUS1 = "/br"
        SLASH_BONUSROLLPLUS2 = "/bonusroll"
        SlashCmdList.BONUSROLLPLUS = Slash
    elseif event == "PLAYER_LOGIN" then
        HideBlizzard()
        if ns.Profiles then ns.Profiles.AutoLoad() end
    elseif event == "START_LOOT_ROLL" then
        OnStartRoll(a, b)
    elseif event == "CANCEL_LOOT_ROLL" then
        OnCancelRoll(a)
    elseif event == "CHAT_MSG_LOOT" then
        OnLootMessage(a)
    elseif event == "LOOT_HISTORY_UPDATE_DROP" then
        OnHistoryDrop(a, b)
    elseif event == "CHAT_MSG_ADDON" then
        OnAddonMessage(a, b, c, d)
    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(10, Announce)
    elseif event == "GROUP_ROSTER_UPDATE" then
        C_Timer.After(3, Announce)
    end
end)

ns.Compile = Compile
ns.Match = Match
ns.Parse = Parse
ns.Themes = THEMES
ns.ParseVersion = ParseVersion
ns.CheckVersion = CheckVersion
ns.MyVersion = MyVersion
