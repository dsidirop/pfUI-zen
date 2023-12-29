local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pvl_namespacer_add)

local _mathFloor = assert((_g.math or {}).floor)

_g = nil
_setfenv(1, {})

local Math = _namespacer("System.Math [Partial]")

Math.Floor = _mathFloor
