local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local GreeniesAutolooterAggregateSettings = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregateSettings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings"


function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _greeniesAutolooterAggregateSettings = GreeniesAutolooterAggregateSettings:New(),
    })
end

function Class:GetGreeniesAutolooterAggregateSettings()
    Scopify(EScopes.Function, self)
    
    return _greeniesAutolooterAggregateSettings
end
