local _setfenv, _importer, _namespacer, _setmetatable = (function()
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

local SWoWElementType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWElementType")

--@formatter:off
SWoWElementType.Model                    = "Model"
SWoWElementType.Frame                    = "Frame"
SWoWElementType.Slider                   = "Slider"
SWoWElementType.Button                   = "Button"
SWoWElementType.Minimap                  = "Minimap"
SWoWElementType.EditBox                  = "EditBox"
SWoWElementType.Cooldown                 = "Cooldown"
SWoWElementType.StatusBar                = "StatusBar"
SWoWElementType.SimpleHTML               = "SimpleHTML"
SWoWElementType.ColorSelect              = "ColorSelect"
SWoWElementType.GameTooltip              = "GameTooltip"
SWoWElementType.ScrollFrame              = "ScrollFrame"
SWoWElementType.MessageFrame             = "MessageFrame"
SWoWElementType.ScrollingMessageFrame    = "ScrollingMessageFrame"
--@formatter:on

_setmetatable(SWoWElementType, { __index = TablesHelper.RawGetValue })

function SWoWElementType.IsValid(value)
    if not Reflection.IsString(value) then
        return false
    end

    return value == SWoWElementType.Model
            or value == SWoWElementType.Frame
            or value == SWoWElementType.Slider
            or value == SWoWElementType.Button
            or value == SWoWElementType.Minimap
            or value == SWoWElementType.EditBox
            or value == SWoWElementType.Cooldown
            or value == SWoWElementType.StatusBar
            or value == SWoWElementType.SimpleHTML
            or value == SWoWElementType.ColorSelect
            or value == SWoWElementType.GameTooltip
            or value == SWoWElementType.ScrollFrame
            or value == SWoWElementType.MessageFrame
            or value == SWoWElementType.ScrollingMessageFrame
end
