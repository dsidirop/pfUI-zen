local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g.pvl_namespacer_bind)

local _isControlKeyDown = assert(_g.IsControlKeyDown)

_g = nil
_setfenv(1, {})

local function IsControlKeyDownBooleanized()
    return _isControlKeyDown() == 1
end

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsControlKeyDown", IsControlKeyDownBooleanized)
