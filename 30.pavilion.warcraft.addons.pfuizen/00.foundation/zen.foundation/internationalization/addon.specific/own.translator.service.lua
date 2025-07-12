--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})


local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local LocalizationInfoService = using "Pavilion.Warcraft.Foundation.Localization.LocalizationInfoService"

local PfuiConfigurationReader = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiConfigurationReader"
local ZenAllTranslations      = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.AddonSpecific.Translations.All" --@formatter:on

local ZenOwnTranslatorService = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.AddonSpecific.OwnTranslatorService" -- [note]   dont use this directly   use the TranslationService instead       todo  rename this to ZenOwnTranslatorService and move it into its own separate subfolder


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

function ZenOwnTranslatorService:Translate(message)
    return self._properTranslationTable[message] -- we intentionally avoid coalescing to 'message' here   its vital to return nil if the translation is not found
end
