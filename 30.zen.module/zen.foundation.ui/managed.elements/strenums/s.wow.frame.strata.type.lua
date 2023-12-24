﻿local _setfenv, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _setfenv, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Reflection = _importer("System.Reflection")
local TablesHelper = _importer("System.Helpers.Tables")

local SWoWFrameStrataType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWFrameStrataType") --@formatter:off

SWoWFrameStrataType.Low              = "LOW"
SWoWFrameStrataType.High             = "HIGH"
SWoWFrameStrataType.Parent           = "PARENT"
SWoWFrameStrataType.Medium           = "MEDIUM"
SWoWFrameStrataType.Dialog           = "DIALOG"
SWoWFrameStrataType.Tooltip          = "TOOLTIP"
SWoWFrameStrataType.Background       = "BACKGROUND"
SWoWFrameStrataType.Fullscreen       = "FULLSCREEN"
SWoWFrameStrataType.FullscreenDialog = "FULLSCREEN_DIALOG" --@formatter:on

_setmetatable(SWoWFrameStrataType, { __index = TablesHelper.RawGetValue })

function SWoWFrameStrataType.IsValid(value)
    if not Reflection.IsString(value) then
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
