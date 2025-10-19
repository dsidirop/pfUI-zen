--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ITranslatorService = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

local IOwnTranslatorService = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Internationalization.IOwnTranslatorService" {
    "ITranslatorService", ITranslatorService -- has everything we need for now
}
