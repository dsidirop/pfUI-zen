--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local SchemaV1 = using "[declare] [static]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Db.Schemas.SchemaV1"

-- todo  take this into account in the future when we have new versions that we have to smoothly upgrade the preexisting versions to

SchemaV1.RootKeyname = "zen.v1" -- must be hardcoded right here   its an integral part of the settings specs and not of the addon specs 

SchemaV1.Settings = {
    Logging = {
        -- nothing yet
    },
    
    EngineSettings = {
        -- nothing yet
    },
    
    UserPreferences = {
        GreeniesGrouplootingAutomation = {
            Mode = {
                Keyname = "user_preferences.greenies_grouplooting_automation.mode",
                Default = SGreeniesGrouplootingAutomationMode.RollGreed,
            },

            ActOnKeybind = {
                Keyname = "user_preferences.greenies_grouplooting_automation.act_on_keybind",
                Default = SGreeniesGrouplootingAutomationActOnKeybind.Automatic,
            },
        },
    },
}
