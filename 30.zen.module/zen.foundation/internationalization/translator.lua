--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})


local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local Localization            = using "Pavilion.Warcraft.Foundation.Localization"
local PfuiConfigurationReader = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.ConfigurationReader"
local ZenAllTranslations      = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translations.All" --@formatter:on

local ZenAddonTranslator = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translator" -- [note]   dont use this directly   use the TranslationService instead       todo  rename this to ZenAddonTranslator and move it into its own separate subfolder


Fields(function(upcomingInstance)
    upcomingInstance._properTranslationTable = nil

    return upcomingInstance
end)


function ZenAddonTranslator:NewForActiveUILanguage()
    Scopify(EScopes.Function, self)

    local uiLanguage = Nils.Coalesce(PfuiConfigurationReader.I:GetLanguageSetting(), Localization.GetLocale())

    return self:New(uiLanguage)
end

function ZenAddonTranslator:New(targetLanguage)
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

function ZenAddonTranslator:Translate(message)
    return self._properTranslationTable[message] -- we intentionally avoid coalescing to 'message' here   its vital to return nil if the translation is not found
end
