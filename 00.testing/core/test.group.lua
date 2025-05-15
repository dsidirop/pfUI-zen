local VWoWUnit, _assert, _type, _pairs, _setfenv, _tableInsert, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    _g.VWoWUnit = _g.VWoWUnit or {}

    local _type = _assert(_g.type)
    local _pairs = _assert(_g.pairs)
    local _tableInsert = _assert(_g.table.insert)
    local _setmetatable = _assert(_g.setmetatable)

    return _g.VWoWUnit, _assert, _type, _pairs, _setfenv, _tableInsert, _setmetatable
end)()

_setfenv(1, {})

VWoWUnit.TestsGroup = {}
VWoWUnit.TestsGroup.__index = VWoWUnit.TestsGroup -- standard class-proto scaffolding

--[[ API ]]--

function VWoWUnit.TestsGroup:New(name)
    _setfenv(1, self)
    
    _assert(_type(name) == "string" and name ~= "", "test-group-name must be a non-empty string")
    _assert(self == VWoWUnit.TestsGroup, "constructors are supposed to be called through class-proto itself but this time it was called through an actual instance")
    
    local instance = {
        _name  = name,
        _tests = {},
    }

    _setmetatable(instance, self)

    return instance
end

function VWoWUnit.TestsGroup:GetName()
    _setfenv(1, self)

    return _name
end

function VWoWUnit.TestsGroup:Run()
    _setfenv(1, self)

    local nonSuccessfulTests = {}
    for _, test in VWoWUnit.Utilities.GetIteratorFunc_TablePairsOrderedByKeys(_tests) do
        local possibleErrorMessages = test:Run()
        if possibleErrorMessages then
            for _, errorMessage in _pairs(possibleErrorMessages) do
                _tableInsert(nonSuccessfulTests, {
                    TestName     = _name,
                    ErrorMessage = errorMessage
                })
            end
        end
    end

    return nonSuccessfulTests
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
