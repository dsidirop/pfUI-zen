local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify  = using "System.Scopify"
local EScopes  = using "System.EScopes"

local PfuiTranslator = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Translator"

local TranslationsService = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"

Scopify(EScopes.Function, {})

function TranslationsService:New(zenSpecificTranslations)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(zenSpecificTranslations, "zenSpecificTranslations")

    return self:WithDefaultCall(self.Translate):Instantiate({
        _zenSpecificTranslations = zenSpecificTranslations or {},
    })
end

function TranslationsService:Translate(message)
    return self._zenSpecificTranslations[message] or PfuiTranslator.Translate(message)
end
