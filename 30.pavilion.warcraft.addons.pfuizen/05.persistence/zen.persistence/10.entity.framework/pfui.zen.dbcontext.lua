--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local PfuiZenDB         = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Db.PfuiZenDB"

local IPfuiZenDB        = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Db.IPfuiZenDB"
local IPfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.EntityFramework.PfuiZen.IPfuiZenDBContext"

local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiConfiguration"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext" { --[[@formatter:on]]
    "IPfuiZenDBContext", IPfuiZenDBContext,
}

Fields(function(upcomingInstance)

    local upcomingInstanceSnapshot = upcomingInstance
    
    upcomingInstance._zendb = nil    
    upcomingInstance.Settings = { --@formatter:off   public entity-properties
        _isLoaded       = false,
        LoadTracked     = function() return upcomingInstanceSnapshot:LoadTracked_Settings()   end,
        LoadUntracked   = function() return upcomingInstanceSnapshot:LoadUntracked_Settings() end,

        EngineSettings  = { _isLoaded = false, --[[placeholder]] },
        LoggingSettings = { _isLoaded = false, --[[placeholder]] },

        UserPreferences = {
            _isLoaded        = false,
            LoadTracked      = function() return upcomingInstanceSnapshot:LoadTracked_Settings_UserPreferences()   end,
            LoadUntracked    = function() return upcomingInstanceSnapshot:LoadUntracked_Settings_UserPreferences() end,
            GreeniesGrouplootingAutomation = {
                Mode         = nil,
                ActOnKeybind = nil,
            },
        },
    } --@formatter:on

    return upcomingInstance
end)

function Class:New(pfuiZenDB)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(pfuiZenDB, IPfuiZenDB, "pfuiZenDB")

    local instance = self:Instantiate()

    instance._zendb = Nils.Coalesce(pfuiZenDB, PfuiZenDB:New())

    return instance
end


-- [ENTITY] SETTINGS

function Class:LoadTracked_Settings()
    return self:Load_Settings_(true)
end

function Class:LoadUntracked_Settings()
    return self:Load_Settings_(false)
end

function Class:Load_Settings_(asTracking)
    Scopify(EScopes.Function, self)
    
    if asTracking and Settings._isLoaded then
        return Settings -- tracked flavor already loaded, so just return it
    end
    
    Settings.UserPreferences.LoadTracked()
    --Settings.EngineSettings.LoadTracked() --  in the future ...
    --Settings.LoggingSettings.LoadTracked() -- in the future ...
    
    Settings._isLoaded = true

    return asTracking
        and Settings -- tracked
        or TablesHelper.Clone(Settings, function(_, value) -- as-no-tracking
            return not Reflection.IsFunction(value)
        end)
end

-- [ENTITY] SETTINGS.USERPREFERENCES

function Class:LoadTracked_Settings_UserPreferences()
    return self:Load_Settings_UserPreferences_(true)
end

function Class:LoadUntracked_Settings_UserPreferences()
    return self:Load_Settings_UserPreferences_(false)
end

function Class:Load_Settings_UserPreferences_(asTracking)
    Scopify(EScopes.Function, self)
    
    if asTracking and Settings.UserPreferences._isLoaded then
        return Settings.UserPreferences -- tracked flavor already loaded, so just return it
    end

    local rawUserPreferences = _zendb:TryLoadDocUserPreferences()
    
    Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode = rawUserPreferences.GreeniesGrouplootingAutomation.Mode --                 mapping
    Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind = rawUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind -- mapping

    Settings.UserPreferences._isLoaded = true

    return asTracking
        and Settings.UserPreferences -- tracked
        or TablesHelper.Clone(Settings.UserPreferences, function(_, value) -- as-no-tracking
            return not Reflection.IsFunction(value)
        end)
end

-- SAVE CHANGES

function Class:SaveChanges()
    Scopify(EScopes.Function, self)
    
    _zendb:UpdateDocUserPreferences(Settings.UserPreferences)
end
