--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IGreeniesGrouplootingAssistantAggregate = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.GreeniesGrouplootingAssistant.IAggregate" --[[@formatter:on]]


function IGreeniesGrouplootingAssistantAggregate:IsRunning()
end

-- settings is expected to be AggregateSettings
function IGreeniesGrouplootingAssistantAggregate:SetSettings(settings)
end

function IGreeniesGrouplootingAssistantAggregate:Restart()
end

function IGreeniesGrouplootingAssistantAggregate:Start()
end

function IGreeniesGrouplootingAssistantAggregate:Stop()
end

function IGreeniesGrouplootingAssistantAggregate:SwitchMode(value)
end

function IGreeniesGrouplootingAssistantAggregate:SwitchActOnKeybind(value)
end
