local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local DBContext                          = using "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext"
local QueryableService                   = using "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"
local WriteableService                   = using "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.WriteableService"
local UserPreferencesUnitOfWork          = using "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork"
local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.Service"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._serviceQueryable = nil
    upcomingInstance._serviceWriteable = nil

    return upcomingInstance
end

function Class:NewWithDBContext(optionalDbContext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(optionalDbContext, "optionalDbContext")

    optionalDbContext = optionalDbContext or DBContext:New()

    return self:New(
            QueryableService:New(UserPreferencesRepositoryQueryable:New(optionalDbContext)),
            WriteableService:New(UserPreferencesUnitOfWork:New(optionalDbContext))
    )
end

function Class:New(serviceQueryable, serviceWriteable)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(serviceQueryable, "serviceQueryable")
    Guard.Assert.IsTable(serviceWriteable, "serviceWriteable")

    local instance = self:Instantiate()

    instance._serviceQueryable = serviceQueryable
    instance._serviceWriteable = serviceWriteable

    return instance
end

function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    return _serviceQueryable:GetAllUserPreferences()
end

function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
    Scopify(EScopes.Function, self)

    return _serviceWriteable:GreeniesGrouplootingAutomation_UpdateMode(value)
end

function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    return _serviceWriteable:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
end
