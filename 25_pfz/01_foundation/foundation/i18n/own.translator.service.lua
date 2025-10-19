--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --@formatter:on

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local IOwnTranslatorService   = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Internationalization.IOwnTranslatorService" -- includes ITranslatorService
local LocalizationInfoService = using "Pavilion.Warcraft.Foundation.Localization.LocalizationInfoService"

local ZenAllTranslations      = using "Pavilion.Warcraft.Foundation.Internationalization.Translations.All"
local PfuiConfigurationReader = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiEnvConfigurationReader"

local ZenOwnTranslatorService = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.OwnTranslatorService" { -- [note]   dont use this directly   use the ComboTranslationService instead
    "IOwnTranslatorService", IOwnTranslatorService
}


Fields(function(upcomingInstance)
    upcomingInstance._targetLanguage = nil
    upcomingInstance._properTranslationTable = nil

    return upcomingInstance
end)


function ZenOwnTranslatorService:NewForActiveUILanguage()
    Scopify(EScopes.Function, self)

    local uiLanguage = Nils.Coalesce(PfuiConfigurationReader.I:TryGetLanguageSetting(), LocalizationInfoService.I:GetUILocale())

    return self:New(uiLanguage)
end

function ZenOwnTranslatorService:New(targetLanguage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(targetLanguage, "targetLanguage")

    local instance = self:Instantiate()

    instance._targetLanguage = targetLanguage
    instance._properTranslationTable = ZenAllTranslations[targetLanguage] or {}

    return instance
end

function ZenOwnTranslatorService:TryTranslate(message)
    Scopify(EScopes.Function, self)
    
    if _targetLanguage == "enUS" or _targetLanguage == "enGB" then
        return message --optimization   no translation needed   return as-is
    end
    
    return _properTranslationTable[message] -- we intentionally avoid coalescing to 'message' here   its vital to return nil if the translation is not found
end
