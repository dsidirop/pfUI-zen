local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils" -- @formatter:off
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local PfuiTranslator     = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Translator"
local ZenAddonTranslator = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.Translator" -- @formatter:on

local TranslationsService = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"

Scopify(EScopes.Function, {})

function TranslationsService._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._zenAddonTranslator = nil
    upcomingInstance._pfuiTranslatorAsFallback = nil

    return upcomingInstance
end

function TranslationsService:New(zenAddonTranslator, pfuiTranslatorAsFallback)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(zenAddonTranslator, "zenAddonTranslator") -- todo    employ type-checking here using interfaces
    Guard.Assert.IsNilOrTable(pfuiTranslatorAsFallback, "pfuiTranslatorAsFallback")

    local instance = self:Instantiate():ChainSetDefaultCall(self.TryTranslate) --@formatter:off   vital   we want _translationsService("foobar") to call _translationsService:TryTranslate("foobar")!

    instance._zenAddonTranslator       = Nils.Coalesce(zenAddonTranslator,       ZenAddonTranslator:NewForActiveUILanguage()) -- todo   get this from di
    instance._pfuiTranslatorAsFallback = Nils.Coalesce(pfuiTranslatorAsFallback, PfuiTranslator.I                           ) -- todo   get this from di

    return instance --@formatter:on
end

--  this method is the default :__Call__ method so the following calls are equivalent
--
--     _translationsService("foobar")   <=>   _translationsService:TryTranslate("foobar")
--
function TranslationsService:TryTranslate(message, optionalColor)
    message = Nils.Coalesce(
            self._zenAddonTranslator:Translate(message), --         order
            self._pfuiTranslatorAsFallback:Translate(message), --   order
            message
    )

    if not optionalColor then
        return message
    end

    return optionalColor .. message .. "|r"
end
