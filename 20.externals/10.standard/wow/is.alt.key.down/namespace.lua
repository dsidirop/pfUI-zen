local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g["ZENSHARP:BIND"])

local _isAltKeyDown = assert(_g.IsAltKeyDown)

_g = nil
_setfenv(1, {})

local function IsAltKeyDownBooleanized()
    return _isAltKeyDown() == 1
end

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsAltKeyDown", IsAltKeyDownBooleanized)
