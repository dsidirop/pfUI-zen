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

    -- TABLES
    function Guard.Check.IsTable(value)
        Debug.Assert(Reflection.IsTable(value), "value must be a table\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyTable(value)
        Debug.Assert(Reflection.IsTableOrNil(value), "value must be a table or nil\n" .. Debug.Stacktrace() .. "\n")
    end

    -- ENUMS
    function Guard.Check.IsOptionallyEnumValue(enumType, value)
        Debug.Assert(value == nil or enumType.IsValid(value), "value must be a valid enum value or nil\n" .. Debug.Stacktrace() .. "\n")
    end
    
    function Guard.Check.IsEnumValue(enumType, value)
        Debug.Assert(enumType.IsValid(value), "value must be a valid enum value\n" .. Debug.Stacktrace() .. "\n")
    end

    -- NUMBERS
    function Guard.Check.IsNumber(value)
        Debug.Assert(Reflection.IsNumber(value), "value must a number\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsNumberOrNil(value)
        Debug.Assert(Reflection.IsNumberOrNil(value), "value must a number or nil\n" .. Debug.Stacktrace() .. "\n")
    end
    
    -- INTEGERS
    function Guard.Check.IsInteger(value)
        Debug.Assert(Reflection.IsNumber(value) and _mathfloor(value) == value, "value must an integer\n" .. Debug.Stacktrace() .. "\n")
    end
    
    function Guard.Check.IsPositiveIntegerOrZero(value)
        Debug.Assert(Reflection.IsInteger(value) and value >= 0, "value must a positive integer or zero\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyPositiveIntegerOrZero(value)
        Debug.Assert(value == nil or Reflection.IsPositiveIntegerOrZero(value), "value must be nil or zero or a positive integer\n" .. Debug.Stacktrace() .. "\n")
    end

    -- RATIOS
    function Guard.Check.IsRatioNumber(value)
        Debug.Assert(Reflection.IsNumber(value) and value >= 0 and value <= 1, "value must a number between 0 and 1\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyRatioNumber(value)
        Debug.Assert(value == nil or (Reflection.IsNumber(value) and value >= 0 and value <= 1), "value must be either nil or a ratio between 0 and 1\n" .. Debug.Stacktrace() .. "\n")
    end

    -- STRINGS
    function Guard.Check.IsString(value)
        Debug.Assert(Reflection.IsString(value), "value must a string\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsStringOrNil(value)
        Debug.Assert(Reflection.IsStringOrNil(value), "value must a string or nil\n" .. Debug.Stacktrace() .. "\n")
    end

    -- FUNCTIONS
    function Guard.Check.IsFunction(value)
        Debug.Assert(Reflection.IsFunction(value), "value must a function\n" .. Debug.Stacktrace() .. "\n")
    end

    function Guard.Check.IsOptionallyFunction(value)
        Debug.Assert(value == nil or Reflection.IsFunction(value), "value must nil or a function\n" .. Debug.Stacktrace() .. "\n")
    end

end
