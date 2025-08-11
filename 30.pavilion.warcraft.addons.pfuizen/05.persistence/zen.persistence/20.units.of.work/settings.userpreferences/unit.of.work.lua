--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local IUnitOfWork = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IUnitOfWork"

local PfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext"
local IPfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.EntityFramework.PfuiZen.IPfuiZenDBContext"

local UserPreferencesRepository = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.Repository"
local IUserPreferencesRepository = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepository"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.UnitOfWork" {
    "IUnitOfWork", IUnitOfWork
}


Fields(function(upcomingInstance)
    upcomingInstance._dbcontext = nil
    upcomingInstance._userPreferencesRepository = nil

    return upcomingInstance
end)


function Class:New(dbcontext, userPreferencesRepository) -- we need both params because both need to be mockable for unit testing
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(dbcontext, IPfuiZenDBContext, "dbcontext")
    Guard.Assert.IsNilOrInstanceImplementing(userPreferencesRepository, IUserPreferencesRepository, "userPreferencesRepository")

    dbcontext = Nils.Coalesce(dbcontext, PfuiZenDBContext:New()) --keep this here

    local instance = self:Instantiate() -- @formatter:off

    instance._dbcontext                 = dbcontext
    instance._userPreferencesRepository = Nils.Coalesce(userPreferencesRepository, UserPreferencesRepository:NewWithDBContext(dbcontext))

    return instance -- @formatter:on
end

function Class:GetUserPreferencesRepository()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepository
end

function Class:SaveChanges()
    Scopify(EScopes.Function, self)

    if not _userPreferencesRepository:HasChanges() then
        return false -- nothing to do
    end

    _dbcontext:SaveChanges()

    return true
end
