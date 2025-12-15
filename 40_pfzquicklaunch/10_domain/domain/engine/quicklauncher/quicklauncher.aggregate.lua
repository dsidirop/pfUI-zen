--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Fields       = using "System.Classes.Fields"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.Quicklauncher.Aggregate" { --@formatter:on
    "IQuicklauncherAggregate", using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.Quicklauncher.IAggregate" 
}


Fields(function(upcomingInstance)
    upcomingInstance._settings = nil
    upcomingInstance._isRunning = false
    
    return upcomingInstance
end)

function Class:New()
    Scopify(EScopes.Function, self)

    local instance = self:Instantiate()

    instance._settings = nil -- set independently through :SetSettings()
    instance._isRunning = false

    return instance
end

function Class:IsRunning()
    Scopify(EScopes.Function, self)

    return _isRunning
end

-- settings is expected to be AggregateSettings
function Class:SetSettings(settings)
    Scopify(EScopes.Function, self)

    _settings = settings
end

function Class:Restart()
    Scopify(EScopes.Function, self)

    self:Stop()
    self:Start()
end

function Class:Start()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNotNil(_settings, "Self.Settings")

    if _isRunning then
        return self -- nothing to do
    end

    -- todo

    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    -- todo

    _isRunning = false

    return self
end

-- private space
