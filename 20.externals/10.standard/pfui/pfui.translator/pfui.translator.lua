local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local PfuiTranslationTable = using "[built-in]" [[ pfUI.env.T or {} ]]

local PfuiTranslator = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Translator"

function PfuiTranslator:New()
    return self:Instantiate()
end

function PfuiTranslator:Translate(message)
    return PfuiTranslationTable[message]
end

PfuiTranslator.I = PfuiTranslator:New()
