--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SchemaV1 = using "[declare] [static]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Db.Schemas.SchemaV1"

-- todo  take this into account in the future when we have new versions that we have to smoothly upgrade the preexisting versions to

SchemaV1.RootKeyname = "zen.quicklaunch.v1" -- must be hardcoded right here   its an integral part of the settings specs and not of the addon specs 

SchemaV1.Settings = {
    Logging = {
        -- nothing yet
    },
    
    UserPreferences = {
        IsFirstLoading = {
            Keyname = "is_first_loading",
            Default = true,
        },
        
        Enabled = {
            Keyname = "user_preferences.enabled",
            Default = true,
        },

        CustomAssociations = {
            Keyname = "user_preferences.custom_associations",
            Default = "", -- will be populated via autoscan the first time we run
        },
    },
}
