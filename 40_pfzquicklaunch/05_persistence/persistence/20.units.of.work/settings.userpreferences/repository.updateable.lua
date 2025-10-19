--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local PfuiQuicklaunchDBContext  = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.EntityFramework.PfuiQuicklaunchDBContext"
local IPfuiQuicklaunchDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContext"

local IUserPreferencesRepositoryUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.IRepositoryUpdateable"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.RepositoryUpdateable" {
    "IUserPreferencesRepositoryUpdateable", IUserPreferencesRepositoryUpdateable
} -- @formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._dbcontext = nil
    upcomingInstance._hasChanges = false

    return upcomingInstance
end)

function Class:New(dbcontext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(dbcontext, IPfuiQuicklaunchDBContext, "dbcontext") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()

    instance._dbcontext = Nils.Coalesce(dbcontext, PfuiQuicklaunchDBContext:New())
    instance._hasChanges = false
    
    return instance
end

function Class:HasChanges()
    Scopify(EScopes.Function, self)

    return _hasChanges
end

--- @return self
function Class:ChainUpdateEnabled(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(value, "value")
    
    local userPreferences = _dbcontext.Settings.UserPreferences.LoadTracked()
    
    if userPreferences.Enabled == value then
        return self
    end

    _hasChanges = true
    userPreferences.Enabled = value

    return self
end

--- @return self
function Class:ChainUpdateCustomAssociations(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(value, "value")
    
    -- todo  validate the format of the string?

    local userPreferences = _dbcontext.Settings.UserPreferences.LoadTracked()

    if userPreferences.CustomAssociations == value then
        return self
    end

    _hasChanges = true
    userPreferences.CustomAssociations = value

    return self
end
