--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local PfuiQuicklaunchDB         = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Db.PfuiQuicklaunchDB"

local IPfuiQuicklaunchDB        = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Db.IPfuiQuicklaunchDB"
local IPfuiQuicklaunchDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContext"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.EntityFramework.PfuiQuicklaunchDBContext" { --[[@formatter:on]]
    "IPfuiQuicklaunchDBContext", IPfuiQuicklaunchDBContext,
}

Fields(function(upcomingInstance)

    local upcomingInstanceSnapshot = upcomingInstance
    
    upcomingInstance._db = nil    
    upcomingInstance.Settings = { --@formatter:off   public entity-properties
        _isLoaded       = false,
        LoadTracked     = function() return upcomingInstanceSnapshot:LoadTracked_Settings()   end,
        LoadUntracked   = function() return upcomingInstanceSnapshot:LoadUntracked_Settings() end,

        LoggingSettings = { _isLoaded = false, --[[placeholder]] },

        UserPreferences = {
            _isLoaded        = false,
            LoadTracked      = function() return upcomingInstanceSnapshot:LoadTracked_Settings_UserPreferences()   end,
            LoadUntracked    = function() return upcomingInstanceSnapshot:LoadUntracked_Settings_UserPreferences() end,

            Enabled            = nil,
            IsFirstLoading     = nil,
            CustomAssociations = nil,
        },
    } --@formatter:on

    return upcomingInstance
end)

function Class:New(pfuiQuicklaunchDB)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(pfuiQuicklaunchDB, IPfuiQuicklaunchDB, "pfuiQuicklaunchDB")

    local instance = self:Instantiate()

    instance._db = Nils.Coalesce(pfuiQuicklaunchDB, PfuiQuicklaunchDB:New())

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

    local rawUserPreferences = _db:TryLoadDocUserPreferences()

    Settings.UserPreferences.Enabled = rawUserPreferences.Enabled --                       mapping
    Settings.UserPreferences.IsFirstLoading = rawUserPreferences.IsFirstLoading --         mapping
    Settings.UserPreferences.CustomAssociations = rawUserPreferences.CustomAssociations -- mapping

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
    
    _db:UpdateDocUserPreferences(Settings.UserPreferences)
end
