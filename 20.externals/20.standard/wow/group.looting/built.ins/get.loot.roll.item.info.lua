local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  GetLootRollItemInfo = GetLootRollItemInfo  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.GroupLooting.BuiltIns.GetLootRollItemInfo", B.GetLootRollItemInfo)
