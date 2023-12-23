local _assert, _type, _print, _pairs, _pcall, _tostring, _setfenv, _tableInsert, _setmetatable, _VWoWUnit = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _type = _assert(_g.type)
	local _pairs = _assert(_g.pairs)
	local _print = _assert(_g.print)
	local _pcall = _assert(_g.pcall)	
	local _tostring = _assert(_g.tostring)
	local _tableInsert = _assert(_g.table.insert)
	local _setmetatable = _assert(_g.setmetatable)

	local _VWoWUnit = _assert(_g.VWoWUnit)

	return _assert, _type, _print, _pairs, _pcall, _tostring, _setfenv, _tableInsert, _setmetatable, _VWoWUnit
end)()

_setfenv(1, {})

local Test = {}
_VWoWUnit.Test = Test


--[[ API ]]--

function Test:New(testname, testFunction)
	local test = {
		_testname = testname,
		_testFunction = testFunction,
	}

	_setmetatable(test, self)
	self.__index = self

	return test
end

function Test:Run()
	_setfenv(1, self)
	
	local success, errorMessage = _pcall(_testFunction)
	if success == nil or success == false or errorMessage ~= nil then
		_print("  " .. _testname .. " |cffff0000[FAILED]\r\n" .. _tostring(errorMessage))
		return errorMessage
	end

	_print("  " .. _testname .. " |cff00ff00[PASSED]")
	
	return nil
end


--[[ Operators ]]--

function Test:__lt(other)
	_setfenv(1, self)
	
	return _testname < other._testname
end
