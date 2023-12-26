local _setfenv, _print, _VWoWUnit = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _print = _assert(_g.print)
	local _VWoWUnit = _assert(_g.VWoWUnit)

	return _setfenv, _print, _VWoWUnit
end)()

_setfenv(1, {})

if _VWoWUnit then
	_print("Running VWoWUnit tests...\n ")

	-- VWoWUnit.I:RunAllTestGroups()

	_VWoWUnit.I:RunTestGroupsByTag("guard-check-booleanizables")
end
