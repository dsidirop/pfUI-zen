local VWoWUnit, _setfenv = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)

	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {}

	return _g.VWoWUnit, _setfenv
end)()

_setfenv(1, {})

VWoWUnit.ELogLevels = { --@formatter:off
	Fatal = 5,
	Error = 4,
	Warn  = 3,
	Info  = 2,
	Debug = 1,
	Trace = 0,
} --@formatter:on
