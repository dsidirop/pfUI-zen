--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local ITranslatorService = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

local LocalizationInfoService = using "Pavilion.Warcraft.Foundation.Localization.LocalizationInfoService"

local PfuiConfigurationReader = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiEnvConfigurationReader"
local ZenAllTranslations      = using "Pavilion.Warcraft.Foundation.Internationalization.Translations.All" --@formatter:on

local ZenOwnTranslatorService = using "[declare] [blend]" "Pavilion.Warcraft.Foundation.Internationalization.OwnTranslatorService" { -- [note]   dont use this directly   use the ComboTranslationService instead
    "ITranslatorService", ITranslatorService
}


Fields(function(upcomingInstance)
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

    instance._properTranslationTable = Nils.Coalesce(
            ZenAllTranslations[targetLanguage],
            ZenAllTranslations["enUS"],
            {}
    )

    return instance
end

function ZenOwnTranslatorService:TryTranslate(message)
    return self._properTranslationTable[message] -- we intentionally avoid coalescing to 'message' here   its vital to return nil if the translation is not found
end
