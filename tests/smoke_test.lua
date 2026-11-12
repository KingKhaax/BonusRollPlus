local scripts = {}
local function proxy()
    local t = {}
    return setmetatable(t, { __index = function(_, k)
        if k == "SetScript" or k == "HookScript" then
            return function(self, name, fn) scripts[self] = scripts[self] or {}; scripts[self][name] = fn end
        end
        if type(k) == "string" and k:find("^%l") then return nil end
        if type(k) == "string" and k:find("^Get") then return function() return 100 end end
        return function() return proxy() end
    end })
end
local timers = {}
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
assert(loadfile("BonusRollPlus/Core.lua"))("BonusRollPlus", ns)

local handler
for obj, s in pairs(scripts) do if s.OnEvent then handler = s.OnEvent end end
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

local clicked = 0
for obj, s in pairs(scripts) do
    if s.OnClick then
        s.OnClick(obj)
        clicked = clicked + 1
    end
end
assert(clicked >= 1, "no button click handler found")
assert(_G.__rolled and _G.__rolled[1] == 7, "RollOnLoot was not called for the real roll")
handler(self, "CHAT_MSG_LOOT", "Brannlor won: " .. link)
handler(self, "CANCEL_LOOT_ROLL", 7)
for _, fn in ipairs(timers) do fn() end
SlashCmdList.BONUSROLLPLUS("test")
for _, fn in ipairs(timers) do fn() end
assert(#ns.Themes == 1, "expected 1 theme")
SlashCmdList.BONUSROLLPLUS("scale 0.8")
SlashCmdList.BONUSROLLPLUS("rolls")
SlashCmdList.BONUSROLLPLUS("reset")
SlashCmdList.BONUSROLLPLUS("version")
SlashCmdList.BONUSROLLPLUS("")
assert(#sent >= 2, "version announce was not sent")
print("smoke test passed, rolled:", _G.__rolled and (_G.__rolled[1] .. "/" .. _G.__rolled[2]) or "none")
