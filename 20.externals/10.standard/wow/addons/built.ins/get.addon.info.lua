local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[  GetAddonInfo = GetAddOnInfo  ]]

local Namespacer = using "System.Namespacer"

Namespacer:BindRawSymbol("Pavilion.Warcraft.Addons.BuiltIns.GetAddonInfo", B.GetAddonInfo)
