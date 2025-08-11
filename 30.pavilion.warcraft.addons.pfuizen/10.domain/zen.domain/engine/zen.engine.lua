--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local ZenEngineSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.ZenEngineSettings"

local GreeniesGrouplootingAssistantAggregate  = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.GreeniesGrouplootingAssistant.Aggregate"
local IGreeniesGrouplootingAssistantAggregate = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.GreeniesGrouplootingAssistant.IAggregate"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.ZenEngine" {
    "IZenEngine", using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.IZenEngine",
}


Fields(function(upcomingInstance)
    upcomingInstance._settings = nil -- this is set via :SetSettings()
    upcomingInstance._isRunning = false
    upcomingInstance._greeniesGrouplootingAssistantAggregate = nil

    return upcomingInstance
end)

function Class:New(greeniesGrouplootingAssistantAggregate)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrInstanceImplementing(greeniesGrouplootingAssistantAggregate, IGreeniesGrouplootingAssistantAggregate, "greeniesGrouplootingAssistantAggregate") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()
    
    instance._greeniesGrouplootingAssistantAggregate = Nils.Coalesce(greeniesGrouplootingAssistantAggregate, GreeniesGrouplootingAssistantAggregate:New()) -- todo  use di
    
    return instance
end

function Class:IsRunning() -- todo   partial classes
    Scopify(EScopes.Function, self)

    return _isRunning
end

function Class:SetSettings(settings) -- todo   partial classes
    Scopify(EScopes.Function, self)
    
    Guard.Assert.Explained.IsFalse(_isRunning, "cannot change settings while engine is running - stop the engine first")

    Guard.Assert.IsNilOrInstanceOf(settings, ZenEngineSettings, "settings")
    
    if settings == _settings then
        return self -- nothing to do
    end
    
    _settings = settings
    _greeniesGrouplootingAssistantAggregate:SetSettings(settings:GetGreeniesGrouplootingAssistantAggregateSettings())

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

    _greeniesGrouplootingAssistantAggregate:Start()
    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _greeniesGrouplootingAssistantAggregate:Stop()
    _isRunning = false

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchMode(value) -- todo   partial classes
    Scopify(EScopes.Function, self)

    _greeniesGrouplootingAssistantAggregate:SwitchMode(value)

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _greeniesGrouplootingAssistantAggregate:SwitchActOnKeybind(value)

    return self
end

Class.I = Class:New() -- todo   get rid off of this singleton once we have DI in place
