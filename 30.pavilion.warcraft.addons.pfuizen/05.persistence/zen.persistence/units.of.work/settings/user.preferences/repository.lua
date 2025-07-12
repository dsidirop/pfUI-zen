--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryQueryable"
local UserPreferencesRepositoryWriteable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryWriteable"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.Repository"


function Class:New(userPreferencesRepositoryQueryable, userPreferencesRepositoryWriteable)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(userPreferencesRepositoryQueryable, "userPreferencesRepositoryQueryable")
    Guard.Assert.IsTable(userPreferencesRepositoryWriteable, "userPreferencesRepositoryWriteable")

    local instance = self:Instantiate()

    instance._userPreferencesRepositoryQueryable = userPreferencesRepositoryQueryable
    instance._userPreferencesRepositoryWriteable = userPreferencesRepositoryWriteable

    return instance
end

function Class:NewWithDBContext(dbcontext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(dbcontext, "dbcontext")

    local instance = self:Instantiate()
    
    instance._userPreferencesRepositoryQueryable = UserPreferencesRepositoryQueryable:New(dbcontext)
    instance._userPreferencesRepositoryWriteable = UserPreferencesRepositoryWriteable:New(dbcontext)
    
    return instance
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepositoryQueryable:GetAllUserPreferences()
end

function Class:HasChanges()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepositoryWriteable:HasChanges()
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    Scopify(EScopes.Function, self)
    
    _userPreferencesRepositoryWriteable:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    
    return self
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _userPreferencesRepositoryWriteable:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)

    return self
end
