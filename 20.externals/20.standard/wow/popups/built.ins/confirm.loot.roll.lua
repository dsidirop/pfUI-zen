-- https://wowpedia.fandom.com/wiki/API_ConfirmLootRoll

local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  ConfirmLootRoll = ConfirmLootRoll  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Popups.BuiltIns.ConfirmLootRoll", B.ConfirmLootRoll)
