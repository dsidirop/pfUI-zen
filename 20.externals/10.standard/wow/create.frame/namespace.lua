local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g["ZENSHARP:BIND_RAW_SYMBOL"])

local _createFrame = assert(_g.CreateFrame)

_g = nil
_setfenv(1, {})

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame", _createFrame)
