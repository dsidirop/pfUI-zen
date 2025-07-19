--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local PfuiZenDB         = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Db.PfuiZenDB"
local IPfuiZenDB        = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Db.IPfuiZenDB"

local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiConfiguration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext" --[[@formatter:on]]


Fields(function(upcomingInstance)

    upcomingInstance._zendb = nil

    upcomingInstance.Settings = { -- these are all public properties
        _isLoaded = false,

        EngineSettings  = { _isLoaded = false, --[[placeholder]] },
        LoggingSettings = { _isLoaded = false, --[[placeholder]] },

        UserPreferences = {
            _isLoaded = false,
            GreeniesGrouplootingAutomation = {
                Mode         = nil,
                ActOnKeybind = nil,
            },
        },
    }
    
    -- root settings
    
    local upcomingInstanceSnapshot = upcomingInstance
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

function Class:New(pfuiZenDB)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(pfuiZenDB, IPfuiZenDB, "pfuiZenDB")

    local instance = self:Instantiate()

    instance._zendb = Nils.Coalesce(pfuiZenDB, PfuiZenDB:New())

    return instance
end

function Class:Load_Settings(asTracking)
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

function Class:Load_Settings_UserPreferences(asTracking)
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

function Class:SaveChanges()
    Scopify(EScopes.Function, self)
    
    _zendb:UpdateDocUserPreferences(Settings.UserPreferences)
end
