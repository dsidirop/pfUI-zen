local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  GetAddonInfo = GetAddOnInfo  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Addons.BuiltIns.GetAddonInfo", B.GetAddonInfo)
