local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local GreeniesAutolooterAggregate = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregate"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine"

function Class:New(greeniesAutolooterAggregate)
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _settings = nil,

        _isRunning = false,
        _greeniesAutolooterAggregate = greeniesAutolooterAggregate or GreeniesAutolooterAggregate:New(), -- todo  use di
    })
end
Class.I = Class:New() -- todo   get rid off of this singleton once we have DI in place

function Class:IsRunning() -- todo   partial classes
    Scopify(EScopes.Function, self)

    return _isRunning
end

-- settings is expected to be Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings
function Class:SetSettings(settings) -- todo   partial classes
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(settings, "settings")
    Guard.Assert.Explained.IsFalse(_isRunning, "cannot change settings while engine is running - stop the engine first")
    
    if settings == _settings then
        return self -- nothing to do
    end
    
    _settings = settings
    _greeniesAutolooterAggregate:SetSettings(settings:GetGreeniesAutolooterAggregateSettings())

    return self
end

function Class:Restart() -- todo   partial classes
    Scopify(EScopes.Function, self)

    self:Stop()
    self:Start()

    return self
end

function Class:Start()
    Scopify(EScopes.Function, self)
    
    if _isRunning then
        return self -- nothing to do
    end

    _greeniesAutolooterAggregate:Start()
    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _greeniesAutolooterAggregate:Stop()
    _isRunning = false

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchMode(value) -- todo   partial classes
    Scopify(EScopes.Function, self)

    _greeniesAutolooterAggregate:SwitchMode(value)

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _greeniesAutolooterAggregate:SwitchActOnKeybind(value)

    return self
end

