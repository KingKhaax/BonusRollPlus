local function proxy()
    return setmetatable({}, { __index = function(_, k)
        if type(k) == "string" and k:find("^Get") then return function() return 100 end end
        return function() return proxy() end
    end })
end

local unpack = unpack or table.unpack
local timers = {}
_G.CreateFrame = function() return proxy() end
_G.UIParent = proxy()
_G.GameTooltip = proxy()
_G.CreateColor = function(...) return { ... } end
_G.C_Timer = { After = function(_, fn) timers[#timers + 1] = fn end }
_G.C_Item = { GetItemInfo = function() return "Crown", "link", 4, 66, 0, "Armor", "Plate", 1, "INVTYPE_HEAD", 134000 end, GetDetailedItemLevelInfo = function() return 66 end, GetItemQualityColor = function() return 0.6, 0.2, 0.9 end }
_G.C_Texture = { GetAtlasInfo = function() return nil end }
_G.INVTYPE_HEAD = "Head"
_G.NEED, _G.GREED, _G.ROLL_DISENCHANT, _G.PASS = "Need", "Greed", "Disenchant", "Pass"
_G.UnitName = function() return "Rafael" end
_G.UnitExists = function() return false end
_G.GetNumGroupMembers = function() return 0 end
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
_G.LOOT_ROLL_NEED_SELF = "You have selected Need for: %s"
_G.LOOT_ROLL_PASSED = "%s passed on: %s"
_G.LOOT_ROLL_WON = "%s won: %s"
_G.LOOT_ROLL_ROLLED_GREED = "Tirada de Codicia: %2$s %1$d por %3$s"

local ns = {}
local chunk = assert(loadfile("BonusRollPlus/Core.lua"))
chunk("BonusRollPlus", ns)

local function eq(a, b, msg) if a ~= b then error((msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a), 2) end end

local link = "|cff0070dd|Hitem:2000::::::::|h[Elder Headpiece]|h|r"
local r = ns.Parse("Brannlor has selected Need for: " .. link)
eq(r.type, "chose") eq(r.kind, "need") eq(r.player, "Brannlor") eq(r.link, link)
r = ns.Parse("Need Roll - 91 for " .. link .. " by Mirelle")
eq(r.type, "rolled") eq(r.value, 91) eq(r.player, "Mirelle") eq(r.link, link)
r = ns.Parse("Lyssa passed on: " .. link)
eq(r.kind, "pass") eq(r.player, "Lyssa")
r = ns.Parse("You have selected Need for: " .. link)
eq(r.kind, "need") eq(r.player, "Rafael")
r = ns.Parse("Zandri won: " .. link)
eq(r.type, "won") eq(r.player, "Zandri")
r = ns.Parse("Tirada de Codicia: " .. link .. " 88 por Kael")
eq(r.type, "rolled") eq(r.value, 88) eq(r.link, link) eq(r.player, "Kael")
eq(ns.Parse("something unrelated"), nil)

local pat = ns.Compile("%s (50%% off) [x]")
eq(("a (50% off) [x]"):match(pat), "a")

print("pattern tests passed")
