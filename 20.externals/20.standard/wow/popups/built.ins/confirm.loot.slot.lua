-- https://wowpedia.fandom.com/wiki/API_ConfirmLootSlot

local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

-- unfortunately ConfirmLootSlot doesnt exist in vanilla wow 1.12
local B = using "[built-ins]" [[  ConfirmLootSlot = ConfirmLootSlot or (function() return false end)  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Popups.BuiltIns.ConfirmLootSlot", B.ConfirmLootSlot)
