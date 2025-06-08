local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[ GetLocale = GetLocale ]]

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Localization = using "[declare] [static]" "Pavilion.Warcraft.Addons.Zen.Externals.WoW.Localization"

Scopify(EScopes.Function, {})

Localization.GetLocale = B.GetLocale
