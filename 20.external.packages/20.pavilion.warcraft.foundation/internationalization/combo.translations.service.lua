--[[@formatter:off]] local _g = assert((_G or getfenv(0) or {})); local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]);local Scopify = using "System.Scopify";local EScopes = using "System.EScopes";Scopify(EScopes.Function, {}) -- @formatter:on

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local ITranslatorService = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Foundation.Internationalization.ComboTranslationsService" {
    "ITranslatorService", ITranslatorService
}

Fields(function(upcomingInstance)
    upcomingInstance._primaryTranslatorService = nil
    upcomingInstance._fallbackTranslationService1 = nil
    upcomingInstance._fallbackTranslationService2 = nil

    return upcomingInstance
end)

function Class:New(primaryTranslatorService, fallbackTranslationService1, fallbackTranslationService2)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceImplementing(primaryTranslatorService, ITranslatorService, "primaryTranslatorService")
    Guard.Assert.IsNilOrInstanceImplementing(fallbackTranslationService1, ITranslatorService, "fallbackTranslationService1")
    Guard.Assert.IsNilOrInstanceImplementing(fallbackTranslationService2, ITranslatorService, "fallbackTranslationService2")

    local instance = self:Instantiate() --@formatter:off   vital   we want _translationsService("foobar") to call _translationsService:TryTranslate("foobar")!

    instance._primaryTranslatorService    = primaryTranslatorService
    instance._fallbackTranslationService1 = fallbackTranslationService1 -- can be nil
    instance._fallbackTranslationService2 = fallbackTranslationService2 -- can be nil

    return instance --@formatter:on
end

--  this method is the default :__Call__ method so the following calls are equivalent
--
--     _translationsService("foobar")   <=>   _translationsService:TryTranslate("foobar")
--
using "[autocall]" "TryTranslate"
function Class:TryTranslate(message, optionalColor)
    message = Nils.Coalesce( --@formatter:off
                                                    self._primaryTranslatorService:TryTranslate(message),            --   order
            self._fallbackTranslationService1   and self._fallbackTranslationService1:TryTranslate(message)  or nil, --   order
            self._fallbackTranslationService2   and self._fallbackTranslationService2:TryTranslate(message)  or nil, --   order
            message
    ) --@formatter:on

    if not optionalColor then
        return message
    end

    return optionalColor .. message .. "|r"
end
