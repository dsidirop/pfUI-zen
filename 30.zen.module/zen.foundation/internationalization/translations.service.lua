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

    self:ChainSetDefaultCall(self.TryTranslate) -- vital   we want _translationsService("foobar") to call _translationsService:TryTranslate("foobar")!

    return self:Instantiate({ --@formatter:off
        _zenAddonTranslator       = zenAddonTranslator       or ZenAddonTranslator:NewForActiveUILanguage(), -- todo   get this from di
        _pfuiTranslatorAsFallback = pfuiTranslatorAsFallback or PfuiTranslator.I, --                            todo   get this from di
    }) --@formatter:on
end

--  this method is the default :__Call__ method so the following calls are equivalent
--
--     _translationsService("foobar")   ==   _translationsService:TryTranslate("foobar")
--
function TranslationsService:TryTranslate(message, optionalColor)
    message = self._zenAddonTranslator:Translate(message) --          order
            or self._pfuiTranslatorAsFallback:Translate(message) --   order
            or message

    if not optionalColor then
        return message
    end

    return optionalColor .. message .. "|r"
end
