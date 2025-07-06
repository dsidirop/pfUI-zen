local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local PfuiZenDbContext = using "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext"
local UserPreferencesRepository = using "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.Repository"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork"

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._dbcontext = nil
    upcomingInstance._userPreferencesRepository = nil

    return upcomingInstance
end)

function Class:New(dbcontext, userPreferencesRepository)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(dbcontext, "dbcontext")
    Guard.Assert.IsNilOrTable(userPreferencesRepository, "userPreferencesRepository")

    local instance = self:Instantiate() -- @formatter:off
    
    instance._dbcontext                 = Nils.Coalesce(dbcontext,                 PfuiZenDbContext:New())
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
