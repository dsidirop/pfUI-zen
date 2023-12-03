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

local SWoWFrameStrataType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWFrameStrataType")

--@formatter:off
SWoWFrameStrataType.Low              = "LOW"
SWoWFrameStrataType.High             = "HIGH"
SWoWFrameStrataType.Parent           = "PARENT"
SWoWFrameStrataType.Medium           = "MEDIUM"
SWoWFrameStrataType.Dialog           = "DIALOG"
SWoWFrameStrataType.Tooltip          = "TOOLTIP"
SWoWFrameStrataType.Background       = "BACKGROUND"
SWoWFrameStrataType.Fullscreen       = "FULLSCREEN"
SWoWFrameStrataType.FullscreenDialog = "FULLSCREEN_DIALOG"
--@formatter:on

function SWoWFrameStrataType.Validate(value)
    if _type(value) ~= "string" then
        return false
    end

    --@formatter:off
    return     value == SWoWFrameStrataType.Low
            or value == SWoWFrameStrataType.High
            or value == SWoWFrameStrataType.Parent
            or value == SWoWFrameStrataType.Medium
            or value == SWoWFrameStrataType.Dialog
            or value == SWoWFrameStrataType.Tooltip
            or value == SWoWFrameStrataType.Background
            or value == SWoWFrameStrataType.Fullscreen
            or value == SWoWFrameStrataType.FullscreenDialog
    --@formatter:on
end
