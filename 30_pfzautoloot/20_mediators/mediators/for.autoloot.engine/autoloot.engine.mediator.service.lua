--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IAutolootEngineMediatorService = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.Contracts.ForAutolootEngine.IAutolootEngineMediatorService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService" { -- @formatter:on
    "IAutolootEngineMediatorService", IAutolootEngineMediatorService
}

function Class:New(zenEngineSingleton, userPreferencesService)
    Scopify(EScopes.Function, self)
    
    -- the mediator itself doesnt have any fields to instantiate really    everything is instantiated on demand right before invoking the handlers
    
    return self:Instantiate()
end

