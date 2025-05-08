local U, _setfenv, _print = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local U = _assert(_g.VWoWUnit)
	local _print = _assert(_g.print)

	return U, _setfenv, _print
end)()

_setfenv(1, {})

if U then
	-- _print("Running VWoWUnit tests...\n ")

 	-- U.TestsEngine:RunAllTestGroups()

	-- U.TestsEngine:RunTestGroupsByTag("grouplooting")

	-- U.TestsEngine:RunTestGroupsByTag("grouplooting")
end
