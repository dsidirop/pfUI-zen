--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"
local Reflection = using "System.Reflection"

local IUserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.IRepositoryQueryable"

local PfuiQuicklaunchDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.EntityFramework.PfuiQuicklaunchDBContext"
local UserPreferencesDto = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"

local IPfuiQuicklaunchDBContextUntrackable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContextUntrackable"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.RepositoryQueryable" {
    "IUserPreferencesRepositoryQueryable", IUserPreferencesRepositoryQueryable
}


Fields(function(upcomingInstance)
    upcomingInstance._dbcontextReadonly = nil
    return upcomingInstance
end)

function Class:New(dbcontextReadonly)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(dbcontextReadonly, IPfuiQuicklaunchDBContextUntrackable, "dbcontextReadonly") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()
    
    instance._dbcontextReadonly = Nils.Coalesce(dbcontextReadonly, PfuiQuicklaunchDBContext:New())
    
    return instance
end

--- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    local userPreferenceEntity = _dbcontextReadonly.Settings.UserPreferences.LoadUntracked()

    -- todo   introduce ValidateCoalesce() in enums to avoid bugs with ternary operators
    local enabled = not Reflection.IsBoolean(userPreferenceEntity.Enabled) --00 anticorruption layer
            and true
            or userPreferenceEntity.Enabled

    local isFirstLoading = not Reflection.IsBoolean(userPreferenceEntity.IsFirstLoading) -- anticorruption layer
            and false
            or userPreferenceEntity.IsFirstLoading

    local customAssociations = not Reflection.IsString(userPreferenceEntity.CustomAssociations) -- anticorruption layer
            and ""
            or userPreferenceEntity.CustomAssociations

    return UserPreferencesDto -- todo   automapper (with precondition-validators!)
            :New()
            :ChainSet_Enabled(enabled)
            :ChainSet_IsFirstLoading(isFirstLoading)
            :ChainSet_CustomAssociations(customAssociations)

    --00 todo   whenever we detect a corruption in the database we auto-sanitise it but on top of that we should also update error-metrics and log it too
end
