--[[@formatter:off]] local _g = assert((_G or getfenv(0) or {})); local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]);local Scopify = using "System.Scopify";local EScopes = using "System.EScopes";Scopify(EScopes.Function, {})

local Nils    = using "System.Nils"
local Guard   = using "System.Guard"
local Fields  = using "System.Classes.Fields"

local ITranslatorService      = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Internationalization.ITranslatorService"

local PfuiTranslatorService   = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiTranslatorService"
local IPfuiTranslatorService  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.IPfuiTranslatorService"

local ZenOwnTranslatorService = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.AddonSpecific.OwnTranslatorService" -- @formatter:on

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.ComboTranslationsService" {
    "ITranslatorService", ITranslatorService
}

Fields(function(upcomingInstance)
    upcomingInstance._zenOwnTranslatorService = nil
    upcomingInstance._pfuiTranslatorAsFallbackService = nil

    return upcomingInstance
end)

function Class:New(zenOwnTranslatorService, pfuiTranslatorAsFallbackService)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(zenOwnTranslatorService, ITranslatorService, "zenOwnTranslatorService")
    Guard.Assert.IsNilOrInstanceImplementing(pfuiTranslatorAsFallbackService, IPfuiTranslatorService, "pfuiTranslatorAsFallbackService")

    local instance = self:Instantiate() --@formatter:off   vital   we want _translationsService("foobar") to call _translationsService:TryTranslate("foobar")!

    instance._zenOwnTranslatorService         = Nils.Coalesce(zenOwnTranslatorService,         ZenOwnTranslatorService:NewForActiveUILanguage()) -- todo   get this from di
    instance._pfuiTranslatorAsFallbackService = Nils.Coalesce(pfuiTranslatorAsFallbackService, PfuiTranslatorService.I)                          -- todo   get this from di

    return instance --@formatter:on
end

--  this method is the default :__Call__ method so the following calls are equivalent
--
--     _translationsService("foobar")   <=>   _translationsService:TryTranslate("foobar")
--
using "[autocall]" "TryTranslate"
function Class:TryTranslate(message, optionalColor)
    message = Nils.Coalesce(
            self._zenOwnTranslatorService:TryTranslate(message), --           order
            self._pfuiTranslatorAsFallbackService:TryTranslate(message), --   order
            message
    )

    if not optionalColor then
        return message
    end

    return optionalColor .. message .. "|r"
end
