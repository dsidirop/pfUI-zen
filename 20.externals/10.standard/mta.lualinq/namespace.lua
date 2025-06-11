local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g["ZENSHARP:BIND"])
local _mta_lualinq_enumerable = assert(_g.Enumerable)

_g = nil
_setfenv(1, {})

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable", _mta_lualinq_enumerable)
