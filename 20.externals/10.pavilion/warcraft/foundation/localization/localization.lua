--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[ GetLocale = GetLocale ]]


local Localization = using "[declare] [static]" "Pavilion.Warcraft.Addons.Zen.Externals.WoW.Localization"


Localization.GetLocale = B.GetLocale
