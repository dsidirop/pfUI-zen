--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local Nils = using "System.Nils"
local Fields = using "System.Classes.Fields"

local Schema = using "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.Pfui.Zen.Schemas.SchemaV1"
local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Pfui.Native.PfuiConfiguration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext"


Fields(function(upcomingInstance)
    upcomingInstance.Settings = { -- these are all public properties
        Logging         = { --[[placeholder]] },
        EngineSettings  = { --[[placeholder]] },
        UserPreferences = {
            GreeniesGrouplootingAutomation = {
                Mode         = nil,
                ActOnKeybind = nil,
            },
        },
    }

    return upcomingInstance
end)

function Class:New()
    Scopify(EScopes.Function, self)

    local rawAddonSettings = PfuiConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C["zen.v1"]

    local instance = self:Instantiate()

    instance
            .Settings
            .UserPreferences
            .GreeniesGrouplootingAutomation.Mode = Nils.Coalesce(rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname], Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Default)

    instance
            .Settings
            .UserPreferences
            .GreeniesGrouplootingAutomation.ActOnKeybind = Nils.Coalesce(rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname], Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Default)

    return instance
end

function Class:SaveChanges()
    Scopify(EScopes.Function, self)

    local rawAddonSettings = {}

    -- @formatter:off
    rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname]         = Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode
    rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname] = Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind
    -- @formatter:on

    PfuiConfiguration[Schema.RootKeyname] = rawAddonSettings
end
