local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]);local Scopify = using "System.Scopify";local EScopes = using "System.EScopes";Scopify(EScopes.Function, {}) -- @formatter:off

local Nils    = using "System.Nils"
local Guard   = using "System.Guard"
local Fields  = using "System.Classes.Fields"

local PfuiTranslator     = using "Pavilion.Warcraft.Addons.Pfui.PfuiTranslatorService"
local ZenAddonTranslator = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.OwnTranslatorService" -- @formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.ComboTranslationsService"

Fields(function(upcomingInstance)
    upcomingInstance._zenAddonTranslator = nil
    upcomingInstance._pfuiTranslatorAsFallback = nil

    return upcomingInstance
end)

function Class:New(zenAddonTranslator, pfuiTranslatorAsFallback)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(zenAddonTranslator, ZenAddonTranslator, "zenAddonTranslator") -- todo    employ type-checking here using interfaces
    Guard.Assert.IsNilOrTable(pfuiTranslatorAsFallback, PfuiTranslator, "pfuiTranslatorAsFallback")

    local instance = self:Instantiate() --@formatter:off   vital   we want _translationsService("foobar") to call _translationsService:TryTranslate("foobar")!

    instance._zenAddonTranslator       = Nils.Coalesce(zenAddonTranslator,       ZenAddonTranslator:NewForActiveUILanguage()) -- todo   get this from di
    instance._pfuiTranslatorAsFallback = Nils.Coalesce(pfuiTranslatorAsFallback, PfuiTranslator.I                           ) -- todo   get this from di

    return instance --@formatter:on
end

--  this method is the default :__Call__ method so the following calls are equivalent
--
--     _translationsService("foobar")   <=>   _translationsService:TryTranslate("foobar")
--
using "[autocall]"
function Class:TryTranslate(message, optionalColor)
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
