local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._userPreferencesRepositoryQueryable = nil

    return upcomingInstance
end

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
