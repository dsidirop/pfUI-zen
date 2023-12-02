local _g = assert(_G or assert(getfenv)(0))
local _gString = assert(_g.string)

_gString.format = _gString.format or assert(string.format)
