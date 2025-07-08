--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[ GetLocale = GetLocale ]]

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.Localization.LocalizationInfoService" -- todo   introduce an interface here

function Class:GetUILocale()
    return B.GetLocale()
end

Class.I = Class:New() -- todo  turn this into DI

