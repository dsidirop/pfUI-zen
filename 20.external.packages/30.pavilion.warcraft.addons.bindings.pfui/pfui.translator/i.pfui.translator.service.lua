--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiTranslationTable = using "[built-in]" [[ pfUI.env.T or {} ]]

local IPfuiTranslatorService = using "[declare] [interface]" "Pavilion.Warcraft.Addons.Bindings.Pfui.IPfuiTranslatorService"

function IPfuiTranslatorService:TryTranslate(message)
end