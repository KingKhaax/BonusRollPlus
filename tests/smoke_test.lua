local scripts = {}
local function proxy()
    local t = {}
    return setmetatable(t, { __index = function(_, k)
        if k == "SetScript" or k == "HookScript" then
            return function(self, name, fn) scripts[self] = scripts[self] or {}; scripts[self][name] = fn end
        end
        if k == "GetThumbTexture" then return function() return proxy() end end
        if type(k) == "string" and k:find("^%l") then return nil end
        if type(k) == "string" and k:find("^Get") then return function() return 100 end end
        return function() return proxy() end
    end })
end
local timers = {}
_G.hooksecurefunc = function() end
_G.time = os.time
_G.date = os.date
_G.wipe = function(t) for k in pairs(t) do t[k] = nil end end
_G.CreateFrame = function() return proxy() end
_G.UIParent = proxy()
_G.GameTooltip = proxy()
_G.GroupLootContainer = proxy()
_G.CreateColor = function(...) return { ... } end
_G.C_Timer = { After = function(_, fn) timers[#timers + 1] = fn end }
_G.C_Item = { GetItemInfo = function() return "Crown", "link", 4, 66, 0, "Armor", "Plate", 1, "INVTYPE_HEAD", 134000 end, GetDetailedItemLevelInfo = function() return 66 end, GetItemQualityColor = function() return 0.6, 0.2, 0.9 end }
_G.C_Texture = { GetAtlasInfo = function() return nil end }
_G.INVTYPE_HEAD = "Head"
_G.UnitName = function() return "Rafael" end
_G.UnitExists = function() return false end
_G.GetNumGroupMembers = function() return 3 end
_G.GetTime = function() return 0 end
_G.GetInventoryItemLink = function(_, slot) if slot <= 5 then return "|cffa335ee|Hitem:" .. (1000 + slot) .. "::::::::|h[Crown]|h|r" end end
_G.GetLootRollItemInfo = function() return 134000, "Elder Headpiece", 1, 3, true, true, true, false, nil, nil, 3 end
_G.GetLootRollItemLink = function() return "|cff0070dd|Hitem:2000::::::::|h[Elder Headpiece]|h|r" end
_G.GetLootRollTimeLeft = function() return 30000 end
_G.RollOnLoot = function(id, r) _G.__rolled = { id, r } end
_G.IsShiftKeyDown = function() return false end
_G.STANDARD_TEXT_FONT = "x"
_G.SlashCmdList = {}
_G.LOOT_ROLL_ROLLED_NEED = "Need Roll - %d for %s by %s"
_G.LOOT_ROLL_NEED = "%s has selected Need for: %s"
_G.LOOT_ROLL_WON = "%s won: %s"
_G.print = print
_G.ITEM_LEVEL = "Item Level %d"
_G.GetLocale = function() return "esES" end

local ns = {}
assert(loadfile("BonusRollPlus/Locales.lua"))("BonusRollPlus", ns)
assert(loadfile("BonusRollPlus/LocalesSettings.lua"))("BonusRollPlus", ns)
assert(loadfile("BonusRollPlus/Themes.lua"))("BonusRollPlus", ns)
assert(loadfile("BonusRollPlus/Core.lua"))("BonusRollPlus", ns)
_G.tinsert = table.insert
_G.UISpecialFrames = {}
for _, f in ipairs({ "LocalesText", "LocalesExtra", "Facts", "FactsDEFR", "FactsITPT", "FactsRUKO", "FactsZH", "Profiles" }) do assert(loadfile("BonusRollPlus/" .. f .. ".lua"))("BonusRollPlus", ns) end
assert(loadfile("BonusRollPlus/Settings.lua"))("BonusRollPlus", ns)

local handler
local handlers = {}
for obj, s in pairs(scripts) do if s.OnEvent then handlers[#handlers + 1] = s.OnEvent end end
handler = function(...) for _, h in ipairs(handlers) do h(...) end end
assert(handler, "no OnEvent handler registered")
handler({ UnregisterEvent = function() end, RegisterEvent = function() end }, "ADDON_LOADED", "BonusRollPlus")
local self = { UnregisterEvent = function() end, RegisterEvent = function() end }
handler(self, "PLAYER_LOGIN")
_G.GetAddOnMetadata = function() return "0.3.0" end
_G.IsInGroup = function() return true end
_G.IsInRaid = function() return false end
_G.IsInGuild = function() return true end
local sent = {}
_G.C_ChatInfo = { RegisterAddonMessagePrefix = function() end, SendAddonMessage = function(prefix, msg, channel) sent[#sent + 1] = prefix .. "|" .. msg .. "|" .. channel end }
handler(self, "PLAYER_ENTERING_WORLD")
handler(self, "GROUP_ROSTER_UPDATE")
handler(self, "CHAT_MSG_ADDON", "BRPLUS", "V:9.9.9", "PARTY", "Otro-Realm")
handler(self, "CHAT_MSG_ADDON", "BRPLUS", "V:evil", "PARTY", "Otro-Realm")
handler(self, "CHAT_MSG_ADDON", "OTHER", "V:9.9.9", "PARTY", "Otro-Realm")
handler(self, "START_LOOT_ROLL", 7, 45000)
local link = "|cff0070dd|Hitem:2000::::::::|h[Elder Headpiece]|h|r"
handler(self, "CHAT_MSG_LOOT", "Brannlor has selected Need for: " .. link)
handler(self, "CHAT_MSG_LOOT", "Need Roll - 91 for " .. link .. " by Brannlor")
_G.Enum = { EncounterLootDropRollState = { NeedMainSpec = 0, NeedOffSpec = 1, Transmog = 2, Greed = 3, NoRoll = 4, Pass = 5 } }
local dropInfo = { itemHyperlink = link, rollInfos = {
    { playerName = "Zed-Realm", state = 3, roll = 44, isWinner = false },
    { playerName = "Lyra", state = 0, roll = 71, isWinner = true },
    { playerName = "Tuk", state = 5, isWinner = false },
} }
_G.C_LootHistory = {
    GetSortedInfoForDrop = function() return dropInfo end,
    GetAllEncounterInfos = function() return { { encounterID = 1 } } end,
    GetSortedDropsForEncounter = function() return { dropInfo } end,
}
handler(self, "LOOT_HISTORY_UPDATE_DROP", 1, 1)

local clicked = 0
local snapshot = {}
for obj, s in pairs(scripts) do
    if s.OnClick then snapshot[#snapshot + 1] = { obj, s.OnClick } end
end
for _, entry in ipairs(snapshot) do
    entry[2](entry[1])
    clicked = clicked + 1
end
assert(clicked >= 1, "no button click handler found")
assert(_G.__rolled and _G.__rolled[1] == 7, "RollOnLoot was not called for the real roll")
handler(self, "CHAT_MSG_LOOT", "Brannlor won: " .. link)
handler(self, "CANCEL_LOOT_ROLL", 7)
for _, fn in ipairs(timers) do fn() end
SlashCmdList.BONUSROLLPLUS("test")
for _, fn in ipairs(timers) do fn() end
assert(#ns.Themes == 10, "expected 10 themes")
SlashCmdList.BONUSROLLPLUS("scale 0.8")
SlashCmdList.BONUSROLLPLUS("rolls")
SlashCmdList.BONUSROLLPLUS("reset")
SlashCmdList.BONUSROLLPLUS("version")
SlashCmdList.BONUSROLLPLUS("")
assert(#sent >= 2, "version announce was not sent")
print("smoke test passed, rolled:", _G.__rolled and (_G.__rolled[1] .. "/" .. _G.__rolled[2]) or "none")

assert(#ns.ThemeList == 10, "expected 10 designs, got " .. #ns.ThemeList)
for _, T in ipairs(ns.ThemeList) do
    ns.ApplyTheme(T.id)
    ns.RunTest()
    ns.EndTest()
    ns.BuildPreview(T, proxy())
end
ns.OpenSettings()
SlashCmdList.BONUSROLLPLUS("open")
print("themes and settings ok")

for loc, list in pairs(ns.FactsL) do assert(#list == #ns.Facts, "facts count " .. loc) end
for loc, names in pairs(ns.ThemeNames) do assert(#names == #ns.ThemeList, "theme names " .. loc) end
for ver, byLoc in pairs(ns.ChangelogL) do
    for loc, items in pairs(byLoc) do assert(#items >= 1, "changelog " .. ver .. loc) end
end
for loc in pairs(ns.Strings) do
    if loc ~= "esMX" and loc ~= "esES" and loc ~= "enUS" then
        assert(ns.FactsL[loc] and ns.ThemeNames[loc] and ns.ChangelogL["0.5.0"][loc], "missing translation: " .. loc)
    end
    for _, key in ipairs({ "SAMPLE_ITEM", "OPEN_SETTINGS", "SET_TITLE", "FACT_PREFIX", "END_TEST", "HIDE_TEST_BTN", "PASS", "SHOW_UPGRADE", "COMPACT_ROWS", "HISTORY_BTN", "HISTORY_TITLE", "TAB_PROFILES", "PROFILE_NEW", "PROFILE_SAVED", "IMPORT_BAD", "CLOSE", "CANT_USE", "SHOW_VALUE", "SOUND_ALERT", "FLASH_ALERT", "PROFILE_THISSPEC", "TAB_HISTORY", "STATS_WON", "HISTORY_CLEAR_BTN", "CLOSE_DELAY" }) do
        if key ~= "PASS" then assert(ns.Strings[loc][key], loc .. " lacks " .. key) end
    end
end
print("translations complete")

local function placeholders(str)
    local out = {}
    for p in str:gmatch("%%[sd]") do out[#out + 1] = p end
    return table.concat(out)
end
for loc, strings in pairs(ns.Strings) do
    for _, key in ipairs({ "PROFILE_NAME", "PROFILE_SAVED", "PROFILE_LOADED", "PROFILE_DELETED" }) do
        assert(placeholders(strings[key]) == placeholders(ns.Strings.enUS[key]), "placeholder mismatch " .. loc .. " " .. key)
    end
end

local P = ns.Profiles
local exported = P.Export()
assert(exported:sub(1, 5) == "BRP1;", "export prefix")
local parsed = P.Parse(exported)
assert(parsed and parsed.theme and parsed.scale and parsed.maxVisible, "round trip")
assert(P.Parse("hello") == nil and P.Parse("BRP1;junk") == nil, "invalid text rejected")
assert(P.Parse("BRP1;scale=99;maxVisible=77;theme=nope;").scale == 1.5, "scale clamped")
assert(P.Parse("BRP1;maxVisible=77;theme=nope;").maxVisible == 5, "windows clamped")
assert(P.Parse("BRP1;theme=nope;scale=1;").theme == "glass", "unknown theme replaced")
local name = P.Save(P.NewName())
assert(#P.Names() >= 1 and P.Load(name), "save and load")
P.UseOnThisCharacter(name)
assert(P.AssignedHere() == name, "assigned")
P.Delete(name)
assert(P.AssignedHere() == nil, "delete clears assignment")
assert(P.Import(exported), "import")

for i = 1, 6 do handler(self, "START_LOOT_ROLL", 20 + i, 45000) end
ns.SetCompact(false)
ns.SetCompact(true)
ns.PrintHistory(5)
ns.ClearHistory()
print("extras ok")

local rolledN, wonN = ns.GetStats()
assert(type(rolledN) == "number" and type(wonN) == "number", "stats")
assert(type(ns.GetHistoryLines(5)) == "table", "history lines")
ns.Profiles.UseOnThisSpec("x")
ns.Profiles.AssignedForSpec()
for loc, strings in pairs(ns.Strings) do
    for _, key in ipairs({ "STATS_ROLLED", "STATS_WON", "STATS_KINDS", "STATS_WEEK" }) do
        assert(placeholders(strings[key]) == placeholders(ns.Strings.enUS[key]), "placeholder mismatch " .. loc .. " " .. key)
    end
end
print("0.6.0 extras ok")

for loc, items in pairs(ns.ChangelogL["0.6.0"]) do assert(#items == 6, "0.6.0 notes " .. loc) end
print("0.6.0 notes ok")
