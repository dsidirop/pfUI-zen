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
local Classify = _importer("System.Classes.Classify")

local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto")

function Class:New()
    Scopify(EScopes.Function, self)

    return Classify(self, {
        _greeniesGrouplootingAutomation = {
            mode = nil,
            actOnKeybind = nil,
        }
    })
end

function Class:GetGreeniesGrouplootingAutomation_Mode()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.mode
end

function Class:GetGreeniesGrouplootingAutomation_ActOnKeybind()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.actOnKeybind
end

function Class:ChainSetGreeniesGrouplootingAutomation_Mode(value)
    Scopify(EScopes.Function, self)

    _assert(SGreeniesGrouplootingAutomationMode:IsValid(value))

    _greeniesGrouplootingAutomation.mode = value

    return self
end

function Class:ChainSetGreeniesGrouplootingAutomation_ActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _assert(SGreeniesGrouplootingAutomationActOnKeybind:IsValid(value), "value must be one of SGreeniesGrouplootingAutomationActOnKeybind (value=" .. (value or "nil") .. ")")

    _greeniesGrouplootingAutomation.actOnKeybind = value

    return self
end
