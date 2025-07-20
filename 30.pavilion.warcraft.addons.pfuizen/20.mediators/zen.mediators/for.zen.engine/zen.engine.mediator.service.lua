--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils   = using "System.Nils"
local Guard  = using "System.Guard" 
local Fields = using "System.Classes.Fields"

local ZenEngine              = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.ZenEngine"
local IZenEngine             = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.IZenEngine"

local ZenEngineSettings      = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.ZenEngineSettings"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.Service"

local IUserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IService"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService" -- @formatter:on

Fields(function(upcomingInstance)
    upcomingInstance._zenEngineSingleton = nil -- todo   get rid of these when we replace this service with a proper mediator that employs command-handlers once we have the DI system in place
    upcomingInstance._userPreferencesService = nil

    return upcomingInstance
end)

function Class:New(zenEngineSingleton, userPreferencesService)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrInstanceImplementing(zenEngineSingleton, IZenEngine, "zenEngineSingleton")
    Guard.Assert.IsNilOrInstanceImplementing(userPreferencesService, IUserPreferencesService, "userPreferencesService")
    
    local instance = self:Instantiate()
    
    instance._zenEngineSingleton = Nils.Coalesce(zenEngineSingleton, ZenEngine.I) --todo   refactor this later on so that this gets injected through DI
    instance._userPreferencesService = Nils.Coalesce(userPreferencesService, UserPreferencesService:NewWithDBContext())
    
    return instance
end

