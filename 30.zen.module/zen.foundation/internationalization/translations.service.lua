local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard" -- @formatter:off
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local PfuiTranslator     = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Translator"
local ZenAddonTranslator = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translator" -- @formatter:on

local TranslationsService = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"

Scopify(EScopes.Function, {})

function TranslationsService:New(zenAddonTranslator, pfuiTranslatorAsFallback)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrTable(zenAddonTranslator, "zenAddonTranslator")
    Guard.Assert.IsNilOrTable(pfuiTranslatorAsFallback, "pfuiTranslatorAsFallback")

    return self:ChainSetDefaultCall(self.Translate):Instantiate({ --@formatter:off
        _zenAddonTranslator        = zenAddonTranslator       or ZenAddonTranslator:NewForActiveUILanguage(),  -- todo   get this from di
        _pfuiTranslatorAsFallback  = pfuiTranslatorAsFallback or PfuiTranslator.I,                             -- todo   get this from di
    }) --@formatter:on
end

function TranslationsService:Translate(message, optionalColor) -- 00
    message = self._zenAddonTranslator:Translate(message) or self._pfuiTranslatorAsFallback:Translate(message) or message

    if not optionalColor then
        return message
    end
    
    return optionalColor .. message .. "|r"
    
    --00   this method is the default call method so it can be called via _t("some message") 
end
