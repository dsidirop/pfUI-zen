local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local SchemaV1 = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.Pfui.Zen.Schemas.SchemaV1"

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
