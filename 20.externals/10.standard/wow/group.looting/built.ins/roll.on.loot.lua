local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[  RollOnLoot = RollOnLoot  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.GroupLooting.BuiltIns.RollOnLoot", B.RollOnLoot)
