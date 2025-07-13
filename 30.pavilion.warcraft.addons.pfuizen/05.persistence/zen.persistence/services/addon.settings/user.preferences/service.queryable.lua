--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryQueryable"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"


Fields(function(upcomingInstance)
    upcomingInstance._userPreferencesRepositoryQueryable = nil

    return upcomingInstance
end)

function Class:New(userPreferencesRepositoryQueryable)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(userPreferencesRepositoryQueryable, "userPreferencesRepositoryQueryable")

    local instance = self:Instantiate()

    instance._userPreferencesRepositoryQueryable = Nils.Coalesce(userPreferencesRepositoryQueryable, UserPreferencesRepositoryQueryable:New()) --todo   refactor this later on so that this gets injected through DI

    return instance
end

function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepositoryQueryable:GetAllUserPreferences()
end
