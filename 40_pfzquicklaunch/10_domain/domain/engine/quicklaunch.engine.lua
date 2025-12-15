--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local QuicklaunchEngineSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.QuicklaunchEngineSettings"

local QuicklauncherAggregate  = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.Quicklauncher.Aggregate"
local IQuicklauncherAggregate = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.Quicklauncher.IAggregate"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.QuicklaunchEngine" { -- aggregate-root of the quicklaunching-subdomain
    "IQuicklaunchEngine", using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.IQuicklaunchEngine",
}


Fields(function(upcomingInstance)
    upcomingInstance._settings = nil -- this is set via :SetSettings()
    upcomingInstance._isRunning = false
    upcomingInstance._quicklauncherAggregate = nil

    return upcomingInstance
end)

function Class:New(quicklauncherAggregate)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrInstanceImplementing(quicklauncherAggregate, IQuicklauncherAggregate, "quicklauncherAggregate")

    local instance = self:Instantiate()
    
    instance._quicklauncherAggregate = Nils.Coalesce(quicklauncherAggregate, QuicklauncherAggregate:New())-- todo  remove this later on in favour of di
    
    return instance
end

function Class:IsRunning() -- todo   partial classes
    Scopify(EScopes.Function, self)

    return _isRunning
end

function Class:SetSettings(settings) -- todo   partial classes
    Scopify(EScopes.Function, self)
    
    Guard.Assert.Explained.IsFalse(_isRunning, "cannot change settings while engine is running - stop the engine first")

    Guard.Assert.IsNilOrInstanceOf(settings, QuicklaunchEngineSettings, "settings")
    
    if settings == _settings then
        return self -- nothing to do
    end
    
    _settings = settings
    _quicklauncherAggregate:SetSettings(settings:GetQuicklauncherAggregateSettings())

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

    _quicklauncherAggregate:Start()
    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _quicklauncherAggregate:Stop()
    _isRunning = false

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchMode(value) -- todo   partial classes
    Scopify(EScopes.Function, self)

    _quicklauncherAggregate:SwitchMode(value)

    return self
end

function Class:GreeniesGrouplootingAutomation_SwitchActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _quicklauncherAggregate:SwitchActOnKeybind(value)

    return self
end

Class.I = Class:New() -- todo   get rid off of this singleton once we have DI in place
