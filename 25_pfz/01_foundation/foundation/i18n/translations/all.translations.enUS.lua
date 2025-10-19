if true then return end -- no need to load english translations really    we keep this just for reference

--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local AllTranslations = using "[declare] [static]" "Pavilion.Warcraft.Foundation.Internationalization.Translations.All [Partial]"

AllTranslations["enUS"] = {
    -- ["About"] = nil,
}
