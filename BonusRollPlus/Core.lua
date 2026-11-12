local ADDON, ns = ...

local DEFAULTS = { scale = 0.85, showRolls = true }
local db

local FRAME_W, FRAME_H, PANEL_W = 300, 214, 190
local FONT_NAME = "Fonts\\MORPHEUS.TTF"
local FONT_BODY = "Fonts\\FRIZQT__.TTF"
local FONT_NUM = "Fonts\\ARIALN.TTF"
local WHITE = "Interface\\Buttons\\WHITE8X8"

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
    return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"):gsub("", "%%%%"))
end

local function Compile(fmt)
    if type(fmt) ~= "string" then return end
    fmt = fmt:gsub("%%%%", "")
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

local function Tex(parent, layer, r, g, b, a)
    local t = parent:CreateTexture(nil, layer or "ARTWORK")
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

local anchor, stack
local pool, active = {}, {}

local function Layout()
    local y = 0
    for _, f in ipairs(active) do
        f:ClearAllPoints()
        f:SetPoint("BOTTOMLEFT", stack, "BOTTOMLEFT", 0, y)
        y = y + FRAME_H + 12
    end
end

local function Release(f)
    f:Hide()
    f.panel:Hide()
    f.rollID, f.fake, f.entries, f.chosen = nil, nil, nil, nil
    for i, a in ipairs(active) do
        if a == f then table.remove(active, i) break end
    end
    Layout()
end

local function RefreshPanel(f)
    local p = f.panel
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
    for i = 1, 12 do
        local row = p.rows[i]
        if not row then
            row = {}
            row.icon = p:CreateTexture(nil, "ARTWORK")
            row.icon:SetSize(14, 14)
            row.icon:SetPoint("TOPLEFT", p, "TOPLEFT", 8, -26 - (i - 1) * 16)
            row.name = p:CreateFontString(nil, "OVERLAY")
            Font(row.name, FONT_BODY, 11)
            row.name:SetPoint("LEFT", row.icon, "RIGHT", 5, 0)
            row.name:SetWidth(100)
            row.name:SetJustifyH("LEFT")
            row.num = p:CreateFontString(nil, "OVERLAY")
            Font(row.num, FONT_NUM, 13)
            row.num:SetPoint("TOPRIGHT", p, "TOPRIGHT", -9, -26 - (i - 1) * 16)
            row.num:SetJustifyH("RIGHT")
            row.hl = Tex(p, "BACKGROUND", 0.54, 0.1, 0.06, 0.2)
            row.hl:SetPoint("TOPLEFT", p, "TOPLEFT", 5, -25 - (i - 1) * 16)
            row.hl:SetPoint("BOTTOMRIGHT", p, "TOPRIGHT", -5, -41 - (i - 1) * 16)
            p.rows[i] = row
        end
        local e = list[i]
        if e and i <= shown then
            SetKindIcon(row.icon, KIND[e.kind] or KIND.wait)
            row.icon:SetDesaturated(e.kind == "wait" or e.kind == "pass")
            row.icon:Show()
            local c = ClassColor(e.name)
            row.name:SetText((e == lead and "♛ " or "") .. e.name)
            row.name:SetTextColor(0.23, 0.14, 0.06)
            row.name:Show()
            row.num:SetText(e.kind == "pass" and "-" or e.kind == "wait" and "…" or (e.value or ""))
            row.num:SetTextColor(e == lead and 0.54 or 0.23, e == lead and 0.1 or 0.14, e == lead and 0.06 or 0.06)
            row.num:Show()
            row.hl:SetShown(e == lead)
            row.name:SetTextColor(c[1] * 0.55, c[2] * 0.55, c[3] * 0.55)
            if (e.kind == "wait" or e.kind == "pass") then row.name:SetAlpha(0.6) else row.name:SetAlpha(1) end
        else
            row.icon:Hide()
            row.name:Hide()
            row.num:Hide()
            row.hl:Hide()
        end
    end
    p:SetHeight(34 + math.max(shown, 1) * 16)
    p.title:SetText("Rolls")
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
    for _, b in ipairs(f.buttons) do
        b.sel:SetShown(b.kind == kind)
        if b.kind ~= kind then b:SetAlpha(0.4) end
    end
    RefreshPanel(f)
end

local function PaintSeal(b, enabled)
    local w = b.kind.wax
    if enabled then
        b.wax:SetVertexColor(w[1], w[2], w[3])
        b.icon:SetDesaturated(false)
        b:SetAlpha(1)
    else
        b.wax:SetVertexColor(0.45, 0.4, 0.34)
        b.icon:SetDesaturated(true)
        b:SetAlpha(0.55)
    end
    b.enabled = enabled
end

local function BuildButton(f, i, kind)
    local b = CreateFrame("Button", nil, f)
    b:SetSize(56, 66)
    b:SetPoint("TOPLEFT", f, "TOPLEFT", 20 + (i - 1) * 68, -104)
    b.kind = kind
    b.wax = b:CreateTexture(nil, "ARTWORK")
    b.wax:SetSize(48, 48)
    b.wax:SetPoint("TOP", b, "TOP", 0, 0)
    b.wax:SetTexture(WHITE)
    if b.CreateMaskTexture then
        local m = b:CreateMaskTexture()
        m:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        m:SetAllPoints(b.wax)
        b.wax:AddMaskTexture(m)
    end
    b.shine = b:CreateTexture(nil, "OVERLAY")
    b.shine:SetSize(26, 14)
    b.shine:SetPoint("TOP", b.wax, "TOP", -5, -5)
    Fade(b.shine, "VERTICAL", { 1, 1, 1, 0 }, { 1, 1, 1, 0.3 })
    b.icon = b:CreateTexture(nil, "OVERLAY")
    b.icon:SetSize(26, 26)
    b.icon:SetPoint("CENTER", b.wax, "CENTER", 0, 0)
    SetKindIcon(b.icon, kind)
    b.sel = b:CreateTexture(nil, "BACKGROUND")
    b.sel:SetSize(58, 58)
    b.sel:SetPoint("CENTER", b.wax, "CENTER", 0, 0)
    b.sel:SetColorTexture(1, 0.82, 0.1, 0.55)
    if b.CreateMaskTexture then
        local m2 = b:CreateMaskTexture()
        m2:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        m2:SetAllPoints(b.sel)
        b.sel:AddMaskTexture(m2)
    end
    b.sel:Hide()
    b.label = b:CreateFontString(nil, "OVERLAY")
    Font(b.label, FONT_NAME, 11)
    b.label:SetPoint("TOP", b.wax, "BOTTOM", 0, -3)
    b.label:SetText(kind.label)
    b.label:SetTextColor(0.23, 0.14, 0.06)
    b.hover = b:CreateTexture(nil, "HIGHLIGHT")
    b.hover:SetSize(48, 48)
    b.hover:SetPoint("CENTER", b.wax, "CENTER", 0, 0)
    b.hover:SetColorTexture(1, 1, 1, 0.16)
    if b.CreateMaskTexture then
        local m3 = b:CreateMaskTexture()
        m3:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        m3:SetAllPoints(b.hover)
        b.hover:AddMaskTexture(m3)
    end
    b:SetScript("OnClick", function(self)
        if self.enabled then Choose(f, self.kind) end
    end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(self.kind.label)
        if not self.enabled and self.reason then
            local msg = _G["LOOT_ROLL_INELIGIBLE_REASON" .. self.reason]
            if msg then GameTooltip:AddLine(msg, 1, 0.2, 0.2, true) end
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

local function BuildPanel(f)
    local p = CreateFrame("Frame", nil, f)
    p:SetSize(PANEL_W, 80)
    p:SetPoint("TOPLEFT", f, "TOPRIGHT", 10, -26)
    p.bg = Tex(p, "BACKGROUND", 0.82, 0.71, 0.46, 1)
    p.bg:SetAllPoints()
    local edge = Tex(p, "BORDER", 0.42, 0.28, 0.12, 1)
    edge:SetPoint("TOPLEFT", -1, 1)
    edge:SetPoint("BOTTOMRIGHT", 1, -1)
    edge:SetDrawLayer("BACKGROUND", -1)
    p.title = p:CreateFontString(nil, "OVERLAY")
    Font(p.title, FONT_NAME, 13)
    p.title:SetPoint("TOPLEFT", 9, -8)
    p.title:SetTextColor(0.54, 0.1, 0.06)
    p.rows = {}
    return p
end

local function BuildFrame()
    local f = CreateFrame("Frame", nil, stack)
    f:SetSize(FRAME_W, FRAME_H)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function()
        if IsShiftKeyDown() then anchor:StartMoving() end
    end)
    f:SetScript("OnDragStop", function()
        anchor:StopMovingOrSizing()
        local x, y = anchor:GetCenter()
        local ux = UIParent:GetCenter()
        db.x, db.y = x - ux, anchor:GetBottom()
    end)

    local paper = Tex(f, "BACKGROUND", 0.86, 0.76, 0.55, 1)
    paper:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -12)
    paper:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 12)
    local shade1 = Tex(f, "BACKGROUND", 1, 1, 1, 1)
    shade1:SetPoint("TOPLEFT", paper, "TOPLEFT", 0, 0)
    shade1:SetPoint("BOTTOMRIGHT", paper, "TOPRIGHT", 0, -24)
    Fade(shade1, "VERTICAL", { 0.45, 0.3, 0.12, 0 }, { 0.45, 0.3, 0.12, 0.55 })
    local shade2 = Tex(f, "BACKGROUND", 1, 1, 1, 1)
    shade2:SetPoint("TOPLEFT", paper, "BOTTOMLEFT", 0, 24)
    shade2:SetPoint("BOTTOMRIGHT", paper, "BOTTOMRIGHT", 0, 0)
    Fade(shade2, "VERTICAL", { 0.45, 0.3, 0.12, 0.55 }, { 0.45, 0.3, 0.12, 0 })
    local shade3 = Tex(f, "BACKGROUND", 1, 1, 1, 1)
    shade3:SetPoint("TOPLEFT", paper, "TOPLEFT", 0, 0)
    shade3:SetPoint("BOTTOMRIGHT", paper, "BOTTOMLEFT", 16, 0)
    Fade(shade3, "HORIZONTAL", { 0.45, 0.3, 0.12, 0.5 }, { 0.45, 0.3, 0.12, 0 })
    local shade4 = Tex(f, "BACKGROUND", 1, 1, 1, 1)
    shade4:SetPoint("TOPLEFT", paper, "TOPRIGHT", -16, 0)
    shade4:SetPoint("BOTTOMRIGHT", paper, "BOTTOMRIGHT", 0, 0)
    Fade(shade4, "HORIZONTAL", { 0.45, 0.3, 0.12, 0 }, { 0.45, 0.3, 0.12, 0.5 })

    local function Roller(point, y)
        local bands = { { 0.17, 0.09, 0.04, 5 }, { 0.54, 0.35, 0.17, 5 }, { 0.82, 0.6, 0.35, 6 }, { 0.54, 0.35, 0.17, 4 }, { 0.17, 0.09, 0.04, 4 } }
        local off = 0
        for _, band in ipairs(bands) do
            local t = Tex(f, "ARTWORK", band[1], band[2], band[3], 1)
            t:SetPoint("TOPLEFT", f, point, 0, y - off)
            t:SetPoint("TOPRIGHT", f, point == "TOPLEFT" and "TOPRIGHT" or "BOTTOMRIGHT", 0, y - off)
            t:SetHeight(band[4])
            off = off + band[4]
        end
    end
    Roller("TOPLEFT", 0)
    Roller("BOTTOMLEFT", 24)

    local ribbon = Tex(f, "ARTWORK", 0.2, 0.12, 0.07, 1)
    ribbon:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -26)
    ribbon:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, -26)
    ribbon:SetHeight(54)
    local rt = Tex(f, "OVERLAY", 0.79, 0.64, 0.29, 0.8)
    rt:SetPoint("TOPLEFT", ribbon, "TOPLEFT", 0, 0)
    rt:SetPoint("TOPRIGHT", ribbon, "TOPRIGHT", 0, 0)
    rt:SetHeight(1)
    local rb = Tex(f, "OVERLAY", 0.79, 0.64, 0.29, 0.8)
    rb:SetPoint("BOTTOMLEFT", ribbon, "BOTTOMLEFT", 0, 0)
    rb:SetPoint("BOTTOMRIGHT", ribbon, "BOTTOMRIGHT", 0, 0)
    rb:SetHeight(1)

    f.iconBorder = Tex(f, "OVERLAY", 1, 1, 1, 1)
    f.iconBorder:SetSize(44, 44)
    f.iconBorder:SetPoint("LEFT", ribbon, "LEFT", 16, 0)
    local iconBg = Tex(f, "OVERLAY", 0, 0, 0, 1)
    iconBg:SetSize(40, 40)
    iconBg:SetPoint("CENTER", f.iconBorder, "CENTER", 0, 0)
    f.icon = f:CreateTexture(nil, "OVERLAY", nil, 2)
    f.icon:SetSize(38, 38)
    f.icon:SetPoint("CENTER", f.iconBorder, "CENTER", 0, 0)
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    f.iconHit = CreateFrame("Frame", nil, f)
    f.iconHit:SetAllPoints(f.iconBorder)
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

    f.name = f:CreateFontString(nil, "OVERLAY")
    Font(f.name, FONT_NAME, 15, "OUTLINE")
    f.name:SetPoint("TOPLEFT", f.iconBorder, "TOPRIGHT", 10, -2)
    f.name:SetWidth(FRAME_W - 82)
    f.name:SetJustifyH("LEFT")
    f.name:SetWordWrap(false)
    f.piece = f:CreateFontString(nil, "OVERLAY")
    Font(f.piece, FONT_BODY, 11)
    f.piece:SetPoint("TOPLEFT", f.name, "BOTTOMLEFT", 0, -4)
    f.piece:SetTextColor(0.82, 0.72, 0.52)

    f.bind = f:CreateFontString(nil, "OVERLAY")
    Font(f.bind, FONT_BODY, 11)
    f.bind:SetPoint("TOP", f, "TOP", 0, -88)
    f.bind:SetTextColor(0.29, 0.18, 0.08)

    f.buttons = {}
    for i, kind in ipairs(KINDS) do f.buttons[i] = BuildButton(f, i, kind) end

    local track = Tex(f, "ARTWORK", 0.35, 0.23, 0.1, 0.25)
    track:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 22, 34)
    track:SetSize(FRAME_W - 44, 3)
    f.fuse = Tex(f, "OVERLAY", 0.35, 0.23, 0.09, 1)
    f.fuse:SetPoint("BOTTOMLEFT", track, "BOTTOMLEFT", 0, 0)
    f.fuse:SetSize(FRAME_W - 44, 3)
    f.spark = f:CreateTexture(nil, "OVERLAY", nil, 3)
    f.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    f.spark:SetBlendMode("ADD")
    f.spark:SetSize(18, 18)
    f.spark:SetVertexColor(1, 0.6, 0.15)

    f.panel = BuildPanel(f)

    f:SetScript("OnUpdate", function(self)
        local frac
        if self.fake then
            frac = (self.expire - GetTime()) / (self.rollTime / 1000)
        elseif self.rollID and GetLootRollTimeLeft then
            frac = GetLootRollTimeLeft(self.rollID) / (self.rollTime or 60000)
        end
        if not frac then return end
        if frac < 0 then frac = 0 elseif frac > 1 then frac = 1 end
        self.fuse:SetWidth(math.max(1, (FRAME_W - 44) * frac))
        self.spark:ClearAllPoints()
        self.spark:SetPoint("CENTER", self.fuse, "RIGHT", 0, 0)
        if self.fake and frac <= 0 and not self.closing then
            self.closing = true
            C_Timer.After(1, function() Release(self) end)
        end
    end)
    return f
end

local function Acquire()
    local f = table.remove(pool)
    if not f then f = BuildFrame() end
    f.closing = nil
    return f
end

local function Setup(f, data)
    f.rollID, f.fake, f.rollTime, f.link = data.rollID, data.fake, data.rollTime or 60000, data.link
    f.chosen, f.entries = nil, nil
    f.itemID = ItemID(data.link)
    f.lastNames = GroupNames()
    if data.fake then f.expire = GetTime() + f.rollTime / 1000 end
    local r, g, b = QualityColor(data.quality)
    f.iconBorder:SetColorTexture(r, g, b, 1)
    f.icon:SetTexture(data.texture)
    local ilvl, piece = ItemMeta(data.link)
    local name = data.name or "?"
    f.name:SetText(name .. (ilvl and ("  |cffefdcb0(" .. ilvl .. ")|r") or ""))
    f.name:SetTextColor(r, g, b)
    f.piece:SetText(piece or "")
    f.bind:SetText(data.bop and (ITEM_BIND_ON_PICKUP or "") or "")
    for _, btn in ipairs(f.buttons) do
        btn.sel:Hide()
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
        PaintSeal(btn, ok and true or false)
        btn:SetAlpha(ok and 1 or 0.55)
    end
    f.panel:SetShown(db.showRolls)
    for _, row in ipairs(f.panel.rows) do
        row.icon:Hide()
        row.name:Hide()
        row.num:Hide()
        row.hl:Hide()
    end
    RefreshPanel(f)
    f:Show()
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
        if f.rollID == rollID then
            local ilvl, piece = ItemMeta(f.link)
            f.name:SetText(name .. (ilvl and ("  |cffefdcb0(" .. ilvl .. ")|r") or ""))
            f.piece:SetText(piece or "")
        end
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
                Setup(f, { fake = true, rollTime = 45000, link = link, texture = tex, name = name, quality = quality, bop = true, canNeed = true, canGreed = true, canDE = shown == 2 })
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
        print("|cffffd100BonusRoll Plus|r: /br test | scale <0.5-1.5> | rolls | reset. Shift+drag a scroll to move it.")
    end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, a, b)
    if event == "ADDON_LOADED" and a == ADDON then
        BonusRollPlusDB = BonusRollPlusDB or {}
        db = BonusRollPlusDB
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
