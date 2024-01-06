local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[ PfuiTranslationTable = pfUI.env.T or {} ]]

local PfuiTranslator = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Translator"

function PfuiTranslator.Translate(message)
    return B.PfuiTranslationTable[message]
end
