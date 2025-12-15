--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IQuicklaunchEngineMediatorService = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.Contracts.ForQuicklaunchEngine.IQuicklaunchEngineMediatorService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.ForQuicklaunchEngine.QuicklaunchEngineMediatorService" { -- @formatter:on
    "IQuicklaunchEngineMediatorService", IQuicklaunchEngineMediatorService
}

function Class:New()
    Scopify(EScopes.Function, self)
    
    -- the mediator itself doesnt have any fields to instantiate really    everything is instantiated on demand right before invoking the handlers
    
    return self:Instantiate()
end
