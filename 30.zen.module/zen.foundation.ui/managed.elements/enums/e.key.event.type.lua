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

local EKeyEventType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType") --@formatter:off

EKeyEventType.KeyDown  = 1
EKeyEventType.KeyUp    = 2 
EKeyEventType.KeyPress = 3 --@formatter:on

_setmetatable(EKeyEventType, { __index = TablesHelper.RawGetValue })

function EKeyEventType.IsValid(value)
    if not Reflection.IsInteger(value) then
        return false
    end
    
    return value == EKeyEventType.KeyUp
            or value == EKeyEventType.KeyDown
            or value == EKeyEventType.KeyPress
end
