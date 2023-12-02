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

local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.AggregateSettings")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _mode = nil,
        _actOnKeybind = nil,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:GetMode()
    _setfenv(1, self)

    return self._mode
end

function Class:GetActOnKeybind()
    _setfenv(1, self)

    return self._actOnKeybind
end

function Class:ChainSetMode(value)
    _setfenv(1, self)

    _assert(SGreeniesGrouplootingAutomationMode.Validate(value))
    
    _mode = value

    return self
end

function Class:ChainSetActOnKeybind(value)
    _setfenv(1, self)

    _assert(SGreeniesGrouplootingAutomationActOnKeybind.Validate(value))

    _actOnKeybind = value

    return self
end