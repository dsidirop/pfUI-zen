local _g, _assert, _type, _pairs, _setfenv, _tableInsert, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _pairs = _assert(_g.pairs)
    local _tableInsert = _assert(_g.table.insert)
    local _setmetatable = _assert(_g.setmetatable)

    return _g, _assert, _type, _pairs, _setfenv, _tableInsert, _setmetatable
end)()

local VWoWUnit = _g.VWoWUnit or {}
_g.VWoWUnit = VWoWUnit
_g = nil

_setfenv(1, {})

VWoWUnit.TestsGroup = {}

--[[ API ]]--

function VWoWUnit.TestsGroup:New(name)
    local instance = {
        _name = name,
        _tests = {},
    }
    
    _setmetatable(instance, self)
    self.__index = self
    
    return instance
end

function VWoWUnit.TestsGroup:GetName()
    _setfenv(1, self)
    
    return _name
end

function VWoWUnit.TestsGroup:Run()
    _setfenv(1, self)

    local failedTests = {}
    for _, test in VWoWUnit.Utilities.GetTablePairsOrderedByKeys(_tests) do
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

function VWoWUnit.TestsGroup:AddFact(testName, testFunction)
    _setfenv(1, self)
    
    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(testFunction) == "function", "test function must be a function")

    _tableInsert(_tests, VWoWUnit.Test:New(testName, testFunction))
end

function VWoWUnit.TestsGroup:AddTheory(testName, hardData, testFunction)
    _setfenv(1, self)

    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(hardData) == "table", "hardData must be a table")
    _assert(_type(testFunction) == "function", "test function must be a function")

    _tableInsert(_tests, VWoWUnit.Test:NewWithHardData(testName, testFunction, hardData))
end

function VWoWUnit.TestsGroup:AddDynamicTheory(testName, dynamicDataGeneratorCallback, testFunction)
    _setfenv(1, self)

    _assert(_type(testName) == "string" and testName ~= "", "testName must be a non-empty string")
    _assert(_type(testFunction) == "function", "test function must be a function")
    _assert(_type(dynamicDataGeneratorCallback) == "function", "dynamicDataGeneratorCallback must be a function")
    
    _tableInsert(_tests, VWoWUnit.Test:NewWithDynamicDataGeneratorCallback(testName, testFunction, dynamicDataGeneratorCallback))
end

--[[ Operators ]]--

function VWoWUnit.TestsGroup.__lt(other)
    _setfenv(1, self)
    
    return _name < other._name
end
