--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local AllTranslations = using "[declare] [static]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.AddonSpecific.Translations.All [Partial]"

AllTranslations["frFR"] = {
    -- ["About"] = "À propos",
}
