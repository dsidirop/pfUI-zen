local _g, _assert, _type, _print, _pcall, _tostring, _setfenv, _next, _tableInsert, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	local _next = _assert(_g.next)
	local _type = _assert(_g.type)
	local _print = _assert(_g.print)
	local _pcall = _assert(_g.pcall)	
	local _tostring = _assert(_g.tostring)
	local _tableInsert = _assert(_g.table.insert)
	local _setmetatable = _assert(_g.setmetatable)

	return _g, _assert, _type, _print, _pcall, _tostring, _setfenv, _next, _tableInsert, _setmetatable
end)()

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

_setfenv(1, {})

VWoWUnit.Test = {}

--[[ API ]]--

function VWoWUnit.Test:New(testName, testFunction)
	_setfenv(1, self)

	_assert(_type(testName) == "string" and testName ~= "", "test name must be a non-empty string")
	_assert(_type(testFunction) == "function", "test function must be a function")

	return self:NewWithDynamicDataGeneratorCallback(testName, testFunction, function()
		return {}
	end)
end

function VWoWUnit.Test:NewWithHardData(testName, testFunction, hardData)
	_setfenv(1, self)

	_assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
	_assert(_type(hardData) == "table", "hardData must be a table")
	_assert(_type(testFunction) == "function", "test function must be a function")

	return self:NewWithDynamicDataGeneratorCallback(testName, testFunction, function()
		return hardData
	end)
end

function VWoWUnit.Test:NewWithDynamicDataGeneratorCallback(testName, testFunction, dynamicDataGeneratorCallback)
	_assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
	_assert(_type(testFunction) == "function", "test function must be a function")
	_assert(_type(dynamicDataGeneratorCallback) == "function", "dynamicDataGeneratorCallback must be a function")

	local test = {
		_testName = testName,
		_testFunction = testFunction,
		_dynamicDataGeneratorCallback = dynamicDataGeneratorCallback,
	}

	_setmetatable(test, self)
	self.__index = self

	return test
end

function VWoWUnit.Test:Run()
	_setfenv(1, self)

	local testData = self._dynamicDataGeneratorCallback()
	if testData == nil or _next(testData) == nil then -- if testData is nil or empty
		local possibleErrorMessage = self:RunImpl_(" " .. _testName, {})
		return { possibleErrorMessage }
	end

	_print("**** Running sub-test-cases of |cffbbbbbb " .. _testName)
	
	local allErrorMessages = {}
	for subtestName, datum in VWoWUnit.Utilities.GetTablePairsOrderedByKeys(testData) do -- if testData actually has data
		local possibleErrorMessage = self:RunImpl_("** " .. subtestName, datum)
		if possibleErrorMessage then
			_tableInsert(allErrorMessages, possibleErrorMessage)
		end
	end
	
	return allErrorMessages
end

function VWoWUnit.Test:RunImpl_(testName, data)
	_setfenv(1, self)

	_assert(_type(data) == "table", "test data must be a table")
	_assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")

	-- _print("****" .. testName .. " starting ... ")

	local success, errorMessage = _pcall(_testFunction, data)
	if success == nil or success == false or errorMessage ~= nil then
		_print("****" .. testName .. " |cffff0000[FAILED]\r\n" .. _tostring(errorMessage))
		return errorMessage
	end

	-- _print("****" .. testName .. " |cff00ff00[PASSED]")

	return nil
end

--[[ Operators ]]--

function VWoWUnit.Test:__lt(other)
	_setfenv(1, self)
	
	return _testName < other._testName
end
