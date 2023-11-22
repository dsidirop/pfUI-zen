local _assert, _setfenv, _type, _, _, _, _, _, _, _namespacer, _setmetatable = (function()
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

local SGreenItemsAutolootingActOnKeybind = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Strenums.SGreenItemsAutolootingActOnKeybind")

SGreenItemsAutolootingActOnKeybind.Automatic = "automatic"
SGreenItemsAutolootingActOnKeybind.Alt = "alt"
SGreenItemsAutolootingActOnKeybind.Ctrl = "ctrl"
SGreenItemsAutolootingActOnKeybind.Shift = "shift"
SGreenItemsAutolootingActOnKeybind.CtrlAlt = "ctrl_alt"
SGreenItemsAutolootingActOnKeybind.AltShift = "alt_shift"
SGreenItemsAutolootingActOnKeybind.CtrlShift = "ctrl_shift"
SGreenItemsAutolootingActOnKeybind.CtrlAltShift = "ctrl_alt_shift"

function SGreenItemsAutolootingActOnKeybind.Validate(value)
    if _type(value) ~= "string" then
        return false
    end

    return value == SGreenItemsAutolootingActOnKeybind.Automatic
            or value == SGreenItemsAutolootingActOnKeybind.Alt
            or value == SGreenItemsAutolootingActOnKeybind.Ctrl
            or value == SGreenItemsAutolootingActOnKeybind.Shift
            or value == SGreenItemsAutolootingActOnKeybind.CtrlAlt
            or value == SGreenItemsAutolootingActOnKeybind.AltShift
            or value == SGreenItemsAutolootingActOnKeybind.CtrlShift
            or value == SGreenItemsAutolootingActOnKeybind.CtrlAltShift
end
