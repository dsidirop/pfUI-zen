local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Localization = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.Localization"
local PfuiConfigurationReader = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.ConfigurationReader"

local ZenAllTranslations = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translations.All"

local ZenAddonTranslator = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translator"

Scopify(EScopes.Function, {})

function ZenAddonTranslator:NewForActiveUILanguage()
    Scopify(EScopes.Function, self)

    local uiLanguage = PfuiConfigurationReader.I:GetLanguageSetting() or Localization.GetLocale()
    
    return self:New(uiLanguage)
end

function ZenAddonTranslator:New(targetLanguage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(targetLanguage, "targetLanguage")

    return self:Instantiate({
        _properTranslationTable = ZenAllTranslations[targetLanguage] or ZenAllTranslations["enUS"] or {},
    })
end

function ZenAddonTranslator:Translate(message)
    return self._properTranslationTable[message]
end
