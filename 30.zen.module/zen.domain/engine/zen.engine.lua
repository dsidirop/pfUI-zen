local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Class.Classify")

local GreeniesAutolooterAggregate = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.Aggregate")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine")

function Class:New(greeniesAutolooterAggregate)
    Scopify(EScopes.Function, self)

    return Classify(self, {
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

    _assert(_type(settings) == "table", "settings parameter is expected to be an object")
    _assert(not _isRunning, "cannot change settings while engine is running - stop the engine first")
    
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

