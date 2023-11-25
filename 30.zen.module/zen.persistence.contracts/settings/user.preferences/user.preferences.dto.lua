local _assert, _setfenv, _, _, _, _, _, _, _importer, _namespacer, _setmetatable = (function()
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

local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _greeniesAutolooting = {
            mode = nil,
            actOnKeybind = nil,
        }
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:GetGreeniesAutolooting_Mode()
    _setfenv(1, self)

    return _greeniesAutolooting.mode
end

function Class:GetGreeniesAutolooting_ActOnKeybind()
    _setfenv(1, self)

    return _greeniesAutolooting.actOnKeybind
end

function Class:ChainSetGreeniesAutolooting_Mode(value)
    _setfenv(1, self)

    _assert(SGreenItemsAutolootingMode.Validate(value))

    _greeniesAutolooting.mode = value

    return self
end

function Class:ChainSetGreeniesAutolooting_ActOnKeybind(value)
    _setfenv(1, self)

    _assert(SGreenItemsAutolootingActOnKeybind.Validate(value))

    _greeniesAutolooting.actOnKeybind = value

    return self
end
