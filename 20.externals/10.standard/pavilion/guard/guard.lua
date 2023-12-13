local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Debug = _importer("System.Debug")
local Reflection = _importer("System.Reflection")

local Guard = _namespacer("Pavilion.Guard")

do
    Guard.Check = _namespacer("Pavilion.Guard.Check")

    function Guard.Check.NotNil(value)
        Debug.Assert(value ~= nil, "value must not be nil\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsTable(value)
        Debug.Assert(Reflection.IsTable(value), "value must be a table\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyTable(value)
        Debug.Assert(Reflection.IsTableOrNil(value), "value must be a table or nil\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsEnumValue(enumType, value)
        Debug.Assert(enumType.IsValid(value), "value must be a valid enum value\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyEnumValue(enumType, value)
        Debug.Assert(value == nil or enumType.IsValid(value), "value must be a valid enum value or nil\n" .. Debug.Stacktrace() .. "\n")
    end
end
