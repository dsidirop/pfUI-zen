--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiTranslationTable = using "[built-in]" [[ pfUI.env.T or {} ]]

local PfuiTranslator = using "[declare]" "Pavilion.Warcraft.Addons.Pfui.PfuiTranslator"

function PfuiTranslator:New()
    return self:Instantiate()
end

function PfuiTranslator:Translate(message)
    return PfuiTranslationTable[message]
end

PfuiTranslator.I = PfuiTranslator:New()
