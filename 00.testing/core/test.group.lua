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
        local possibleErrorMessage = test:Run()
        if possibleErrorMessage then
            _tableInsert(failedTests, {
                TestName = _name,
                ErrorMessage = possibleErrorMessage
            })
        end
    end
    
    return failedTests
end

function TestsGroup:AddTest(name, testFunction)
    _setfenv(1, self)
    
    _assert(_type(name) == "string" and name ~= "", "test name must be a non-empty string")
    _assert(_type(testFunction) == "function", "test function must be a function")

    _tableInsert(_tests, _VWoWUnit.Test:New(name, testFunction))
end


--[[ Operators ]]--

function TestsGroup.__lt(other)
    _setfenv(1, self)
    
    return _name < other._name
end
