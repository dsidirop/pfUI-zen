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

local GreeniesAutolooterAggregate = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesAutolooter.Aggregate")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine")

function Class:New(greeniesAutolooterAggregate)
    _setfenv(1, self)

    local instance = {
        _settings = nil,
        
        _isRunning = false,
        _greeniesAutolooterAggregate = greeniesAutolooterAggregate or GreeniesAutolooterAggregate:New(), -- todo  use di
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end
Class.I = Class:New() -- todo   get rid off of this singleton once we have DI in place



-- settings is expected to be ZenEngineSettings
function Class:SetSettings(settings)
    _setfenv(1, self)
    
    _assert(_type(settings) == "table", "settings parameter is expected to be an object")
    
    if _isRunning then
        _error("cannot change settings while engine is running - stop the engine first")
        return self
    end
    
    if settings == _settings then
        return self -- nothing to do
    end
    
    _settings = settings
    _greeniesAutolooterAggregate:SetSettings(settings:GetGreeniesAutolooterAggregateSettings())

    return self
end

function Class:Restart() -- todo   partial classes
    _setfenv(1, self)

    Stop()
    Start()

    return self
end

function Class:Start()
    _setfenv(1, self)
    
    if _isRunning then
        return self -- nothing to do
    end

    _isRunning = true
    _greeniesAutolooterAggregate:Start()

    return self
end

function Class:Stop()
    _setfenv(1, self)

    _isRunning = false
    _greeniesAutolooterAggregate:Stop()

    return self
end


function Class:GreeniesAutolooting_SwitchMode(value) -- todo   partial classes
    _setfenv(1, self)

    _greeniesAutolooterAggregate:SwitchMode(value)

    return self
end

function Class:GreeniesAutolooting_SwitchActOnKeybind(value)
    _setfenv(1, self)

    _greeniesAutolooterAggregate:SwitchActOnKeybind(value)

    return self
end

