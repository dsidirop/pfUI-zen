local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g.pvl_namespacer_bind)

local _math = assert(_g.math)

_g = nil
_setfenv(1, {})

_namespacer_binder("System.Math", _math)
