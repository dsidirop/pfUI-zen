--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Fields = using "System.Classes.Fields"

local GreeniesQuicklauncherAggregateSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.Quicklauncher.AggregateSettings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.QuicklaunchEngineSettings"


Fields(function(upcomingInstance)
    upcomingInstance._greeniesQuicklauncherAggregateSettings = nil

    return upcomingInstance
end)

function Class:New()
    Scopify(EScopes.Function, self)
    
    local instance = self:Instantiate()

    instance._greeniesQuicklauncherAggregateSettings = GreeniesQuicklauncherAggregateSettings:New()

    return instance
end

function Class:GetQuicklauncherAggregateSettings()
    Scopify(EScopes.Function, self)
    
    return _greeniesQuicklauncherAggregateSettings
end
