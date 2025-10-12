--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ILocalizationInfoService = using "[declare] [interface]" "Pavilion.Warcraft.Foundation.Localization.Contracts.ILocalizationInfoService"

function ILocalizationInfoService:GetUILocale() end;
