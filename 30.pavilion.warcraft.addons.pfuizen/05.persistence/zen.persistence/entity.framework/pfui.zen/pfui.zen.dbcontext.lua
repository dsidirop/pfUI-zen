--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Fields       = using "System.Classes.Fields"
local Reflection   = using "System.Reflection"
local TablesHelper = using "System.Helpers.Tables"

local Schema            = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.Pfui.Zen.Schemas.SchemaV1"
local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiConfiguration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext" --[[@formatter:on]]


Fields(function(upcomingInstance)
    local upcomingInstanceSnapshot = upcomingInstance
    
    upcomingInstance._areSettingsLoaded = false
    upcomingInstance._areUserPreferencesLoaded = false
    
    upcomingInstance.Settings = { -- these are all public properties
        EngineSettings  = { --[[placeholder]] },
        LoggingSettings = { --[[placeholder]] },
        UserPreferences = {
            GreeniesGrouplootingAutomation = {
                Mode         = nil,
                ActOnKeybind = nil,
            },
        },
    }
    
    -- root settings
    
    upcomingInstance.Settings.LoadTracked = function()
        return upcomingInstanceSnapshot:Load_Settings(true)
    end
    
    upcomingInstance.Settings.LoadAsNoTracking = function()
        return upcomingInstanceSnapshot:Load_Settings(false)
    end
    
    -- user-preferences sub-section
    
    upcomingInstance.Settings.UserPreferences.LoadTracked = function()
        return upcomingInstanceSnapshot:Load_Settings_UserPreferences(true)
    end
    
    upcomingInstance.Settings.UserPreferences.LoadAsNoTracking = function()
        return upcomingInstanceSnapshot:Load_Settings_UserPreferences(false)
    end

    return upcomingInstance
end)

function Class:Load_Settings(asTracking)
    Scopify(EScopes.Function, self)
    
    if asTracking and _areSettingsLoaded then
        return Settings -- tracked flavor already loaded, so just return it
    end
    
    Settings.UserPreferences.LoadTracked()
    --Settings.EngineSettings.LoadTracked() --  in the future ...
    --Settings.LoggingSettings.LoadTracked() -- in the future ...
    
    _areSettingsLoaded = true

    return asTracking
        and Settings -- tracked
        or TablesHelper.Clone(Settings, function(_, value) -- as-no-tracking
            return not Reflection.IsFunction(value)
        end)
end

function Class:Load_Settings_UserPreferences(asTracking)
    Scopify(EScopes.Function, self)
    
    if asTracking and _areUserPreferencesLoaded then
        return Settings.UserPreferences -- tracked flavor already loaded, so just return it
    end

    local rawAddonSettings = PfuiConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C["zen.v1"]

    Settings
            .UserPreferences
            .GreeniesGrouplootingAutomation.Mode = Nils.Coalesce(rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname], Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Default)

    Settings
            .UserPreferences
            .GreeniesGrouplootingAutomation.ActOnKeybind = Nils.Coalesce(rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname], Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Default)

    _areUserPreferencesLoaded = true

    return asTracking
        and Settings.UserPreferences -- tracked
        or TablesHelper.Clone(Settings.UserPreferences, function(_, value) -- as-no-tracking
            return not Reflection.IsFunction(value)
        end)
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
