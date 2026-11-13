local ADDON, ns = ...
local L = ns.L

local ORDER = { "theme", "scale", "alpha", "maxVisible", "showRolls", "showUpgrade", "compact", "locked", "showValue", "sound", "flash", "closeDelay", "x", "y" }
local KIND = {
    theme = "s", scale = "n", alpha = "n", maxVisible = "n", showRolls = "b", showUpgrade = "b", compact = "b", locked = "b", showValue = "b", sound = "b", flash = "b", closeDelay = "n", x = "n", y = "n",
}
local PREFIX = "BRP1;"

local P = {}
ns.Profiles = P

local function db() return ns.GetDB() end

local function charKey()
    return (UnitName("player") or "?") .. "-" .. (GetRealmName and GetRealmName() or "?")
end

local function clamp(v, lo, hi, default)
    v = tonumber(v)
    if not v then return default end
    if v < lo then return lo elseif v > hi then return hi end
    return v
end

local function themeExists(id)
    for _, t in ipairs(ns.ThemeList or {}) do
        if t.id == id then return true end
    end
    return false
end

function P.Snapshot()
    local d, t = db(), {}
    for _, k in ipairs(ORDER) do t[k] = d[k] end
    return t
end

function P.Sanitize(t)
    if type(t) ~= "table" then return nil end
    local seen = false
    for _, k in ipairs(ORDER) do
        if t[k] ~= nil then seen = true break end
    end
    if not seen then return nil end
    local def = ns.GetDefaults()
    local out = {}
    out.theme = themeExists(t.theme) and t.theme or def.theme
    out.scale = clamp(t.scale, 0.5, 1.5, def.scale)
    out.alpha = clamp(t.alpha, 0.3, 1, def.alpha)
    out.maxVisible = math.floor(clamp(t.maxVisible, 1, 5, def.maxVisible))
    for _, k in ipairs({ "showRolls", "showUpgrade", "compact", "locked", "showValue", "sound", "flash" }) do
        if t[k] == nil then out[k] = def[k] else out[k] = t[k] and true or false end
    end
    out.closeDelay = math.floor(clamp(t.closeDelay, 0, 15, def.closeDelay))
    out.x = tonumber(t.x)
    out.y = tonumber(t.y)
    if not (out.x and out.y) then out.x, out.y = nil, nil end
    return out
end

function P.Names()
    local names = {}
    for name in pairs(db().profiles) do names[#names + 1] = name end
    table.sort(names)
    return names
end

function P.Apply(snapshot)
    local clean = P.Sanitize(snapshot)
    if not clean then return false end
    local d = db()
    for _, k in ipairs(ORDER) do d[k] = clean[k] end
    ns.SetScale(d.scale)
    ns.SetAlpha(d.alpha)
    ns.SetMaxVisible(d.maxVisible)
    ns.SetShowRolls(d.showRolls)
    ns.SetCompact(d.compact)
    ns.SetShowUpgrade(d.showUpgrade)
    ns.SetCloseDelay(d.closeDelay)
    ns.SetOption("showValue", d.showValue)
    ns.SetLocked(d.locked)
    ns.SetPosition(d.x, d.y)
    ns.ApplyTheme(d.theme)
    return true
end

function P.NewName()
    local d = db()
    local n = 1
    while d.profiles[string.format(L.PROFILE_NAME, n)] do n = n + 1 end
    return string.format(L.PROFILE_NAME, n)
end

function P.Save(name)
    local d = db()
    d.profiles[name] = P.Snapshot()
    d.activeProfile = name
    return name
end

function P.Load(name)
    local d = db()
    local snap = d.profiles[name]
    if not snap then return false end
    if P.Apply(snap) then
        d.activeProfile = name
        return true
    end
    return false
end

function P.Delete(name)
    local d = db()
    d.profiles[name] = nil
    if d.activeProfile == name then d.activeProfile = nil end
    for key, assigned in pairs(d.charProfile) do
        if assigned == name then d.charProfile[key] = nil end
    end
    for key, assigned in pairs(d.specProfile) do
        if assigned == name then d.specProfile[key] = nil end
    end
end

function P.UseOnThisCharacter(name)
    db().charProfile[charKey()] = name
end

function P.AssignedHere()
    return db().charProfile[charKey()]
end

local function specKey()
    local index = GetSpecialization and GetSpecialization()
    if not index or index == 0 then return nil end
    return charKey() .. ":" .. tostring(index)
end

function P.SpecAvailable()
    return specKey() ~= nil
end

function P.AssignedForSpec()
    local key = specKey()
    return key and db().specProfile[key] or nil
end

function P.UseOnThisSpec(name)
    local key = specKey()
    if key then db().specProfile[key] = name end
end

function P.AutoLoad()
    local name = P.AssignedForSpec() or P.AssignedHere()
    if name and db().profiles[name] then P.Load(name) end
end

function P.Export()
    local snap, parts = P.Snapshot(), { PREFIX }
    for _, k in ipairs(ORDER) do
        local v = snap[k]
        if v ~= nil then parts[#parts + 1] = k .. "=" .. tostring(v) .. ";" end
    end
    return table.concat(parts)
end

function P.Parse(text)
    if type(text) ~= "string" then return nil end
    text = text:gsub("%s+", "")
    if text:sub(1, #PREFIX) ~= PREFIX then return nil end
    local raw = {}
    for key, value in text:sub(#PREFIX + 1):gmatch("(%w+)=([^;]*);") do
        local kind = KIND[key]
        if kind == "n" then
            raw[key] = tonumber(value)
        elseif kind == "b" then
            raw[key] = value == "true"
        elseif kind == "s" then
            raw[key] = value
        end
    end
    return P.Sanitize(raw)
end

function P.Import(text)
    local snap = P.Parse(text)
    if not snap then return nil end
    local d = db()
    P.Apply(snap)
    local name = P.NewName()
    d.profiles[name] = P.Snapshot()
    d.activeProfile = name
    return name
end
