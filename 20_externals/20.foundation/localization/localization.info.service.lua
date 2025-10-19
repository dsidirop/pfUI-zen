--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local B = using "[built-ins]" [[ GetLocale = GetLocale ]]

local ILocalizationInfoService = using "Pavilion.Warcraft.Foundation.Localization.Contracts.ILocalizationInfoService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Foundation.Localization.LocalizationInfoService" {
    "ILocalizationInfoService", ILocalizationInfoService
}

function Class:GetUILocale()
    return B.GetLocale()
end

Class.I = Class:New() -- todo  turn this into DI
