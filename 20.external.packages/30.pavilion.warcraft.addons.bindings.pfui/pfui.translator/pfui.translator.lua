--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiTranslationTable = using "[built-in]" [[ pfUI.env.T or {} ]]

local PfuiTranslatorService = using "[declare]" "Pavilion.Warcraft.Addons.Pfui.PfuiTranslatorService"

function PfuiTranslatorService:New()
    return self:Instantiate()
end

function PfuiTranslatorService:Translate(message)
    return PfuiTranslationTable[message]
end

PfuiTranslatorService.I = PfuiTranslatorService:New()
