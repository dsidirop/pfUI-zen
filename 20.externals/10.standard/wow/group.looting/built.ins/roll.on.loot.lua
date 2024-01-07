local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  RollOnLoot = RollOnLoot  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Addons.Zen.Externals.WoW.GroupLooting.BuiltIns.RollOnLoot", B.RollOnLoot)
