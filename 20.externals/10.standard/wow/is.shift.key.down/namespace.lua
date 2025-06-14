local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g["ZENSHARP:BIND_RAW_SYMBOL"])

local _isShiftKeyDown = assert(_g.IsShiftKeyDown)

_g = nil
_setfenv(1, {})

local function IsShiftKeyDownBooleanized()
    return _isShiftKeyDown() == 1
end

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsShiftKeyDown", IsShiftKeyDownBooleanized)
