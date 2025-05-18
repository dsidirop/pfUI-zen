local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local GreeniesAutolooterAggregateSettings = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.AggregateSettings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._greeniesAutolooterAggregateSettings = nil

    return upcomingInstance
end

function Class:New()
    Scopify(EScopes.Function, self)
    
    local instance = self:Instantiate()

    instance._greeniesAutolooterAggregateSettings = GreeniesAutolooterAggregateSettings:New()

    return instance
end

function Class:GetGreeniesAutolooterAggregateSettings()
    Scopify(EScopes.Function, self)
    
    return _greeniesAutolooterAggregateSettings
end
