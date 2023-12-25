local _assert, _type, _print, _pairs, _setfenv, _tableInsert, _setmetatable, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _tableInsert = _assert(_g.table.insert)
    local _setmetatable = _assert(_g.setmetatable)
    
    local _VWoWUnit = _assert(_g.VWoWUnit)

    return _assert, _type, _print, _pairs, _setfenv, _tableInsert, _setmetatable, _VWoWUnit
end)()

_setfenv(1, {})

local TestsGroup = {}
_VWoWUnit.TestsGroup = TestsGroup

--[[ API ]]--

function TestsGroup:New(name)
    local instance = {
        _name = name,
        _tests = {},
    }
    
    _setmetatable(instance, self)
    self.__index = self
    
    return instance
end

function TestsGroup:GetName()
    _setfenv(1, self)
    
    return _name
end

function TestsGroup:Run()
    _setfenv(1, self)

    local failedTests = {}
    for _, test in _pairs(_tests) do
        local possibleErrorMessages = test:Run()
        if possibleErrorMessages then
            for _, errorMessage in _pairs(possibleErrorMessages) do
                _tableInsert(failedTests, {
                    TestName = _name,
                    ErrorMessage = errorMessage
                })
            end            
        end
    end
    
    return failedTests
end

function TestsGroup:AddTest(testName, testFunction)
    _setfenv(1, self)
    
    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(testFunction) == "function", "test function must be a function")

    _tableInsert(_tests, _VWoWUnit.Test:New(testName, testFunction))
end

function TestsGroup:AddHardDataTest(testName, hardData, testFunction)
    _setfenv(1, self)

    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(hardData) == "table", "hardData must be a table")
    _assert(_type(testFunction) == "function", "test function must be a function")

    _tableInsert(_tests, _VWoWUnit.Test:NewWithHardData(testName, testFunction, hardData))
end

function TestsGroup:AddDynamicDataTest(testName, dynamicDataGeneratorCallback, testFunction)
    _setfenv(1, self)

    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(testFunction) == "function", "test function must be a function")
    _assert(_type(dynamicDataGeneratorCallback) == "function", "dynamicDataGeneratorCallback must be a function")
    
    _tableInsert(_tests, _VWoWUnit.Test:NewWithDynamicDataGeneratorCallback(testName, testFunction, dynamicDataGeneratorCallback))
end

--[[ Operators ]]--

function TestsGroup.__lt(other)
    _setfenv(1, self)
    
    return _name < other._name
end
