local _g = assert(_G or assert(getfenv)(0))
local _gString = assert(_g.string)

_gString.match = _gString.match or assert(string.match)
