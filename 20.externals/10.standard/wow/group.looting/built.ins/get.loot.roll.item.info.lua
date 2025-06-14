local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[  GetLootRollItemInfo = GetLootRollItemInfo  ]]

local Namespacer = using "System.Namespacer"

Namespacer:BindRawSymbol("Pavilion.Warcraft.GroupLooting.BuiltIns.GetLootRollItemInfo", B.GetLootRollItemInfo)
