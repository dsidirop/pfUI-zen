--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ITranslatorService = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Internationalization.ITranslatorService"

function ITranslatorService:TryTranslate(message)
end
