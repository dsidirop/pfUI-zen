--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiTranslationTable = using "[built-in]" [[ pfUI.env.T or {} ]]

local IPfuiTranslatorService = using "Pavilion.Warcraft.Addons.Bindings.Pfui.IPfuiTranslatorService"

local PfuiTranslatorService = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiTranslatorService" {
    "IPfuiTranslatorService", IPfuiTranslatorService
}

function PfuiTranslatorService:New()
    return self:Instantiate()
end

function PfuiTranslatorService:TryTranslate(message)
    return PfuiTranslationTable[message]
end

PfuiTranslatorService.I = PfuiTranslatorService:New() -- todo  get this from DI
