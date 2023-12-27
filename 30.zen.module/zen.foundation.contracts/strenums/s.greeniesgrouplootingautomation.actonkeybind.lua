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

local Reflection = _importer("System.Reflection")
local TablesHelper = _importer("System.Helpers.Tables")

local SGreeniesGrouplootingAutomationActOnKeybind = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

SGreeniesGrouplootingAutomationActOnKeybind.Automatic = "automatic"
SGreeniesGrouplootingAutomationActOnKeybind.Alt = "Alt"
SGreeniesGrouplootingAutomationActOnKeybind.Ctrl = "Ctrl"
SGreeniesGrouplootingAutomationActOnKeybind.Shift = "Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt = "Ctrl+Alt"
SGreeniesGrouplootingAutomationActOnKeybind.AltShift = "Alt+Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift = "Ctrl+Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift = "Ctrl+Alt+Shift"

_setmetatable(SGreeniesGrouplootingAutomationActOnKeybind, { __index = TablesHelper.RawGetValue })

function SGreeniesGrouplootingAutomationActOnKeybind.IsValid(value)
    if not Reflection.IsString(value) then
        return false
    end

    return value == SGreeniesGrouplootingAutomationActOnKeybind.Automatic
            or value == SGreeniesGrouplootingAutomationActOnKeybind.Alt
            or value == SGreeniesGrouplootingAutomationActOnKeybind.Ctrl
            or value == SGreeniesGrouplootingAutomationActOnKeybind.Shift
            or value == SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt
            or value == SGreeniesGrouplootingAutomationActOnKeybind.AltShift
            or value == SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift
            or value == SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift
end
