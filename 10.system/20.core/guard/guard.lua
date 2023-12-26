local _setfenv, _pairs, _strlen, _strfind, _strupper, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _pairs = _assert(_g.pairs)
    local _strlen = _assert(_g.string.len)    
    local _strfind = _assert(_g.string.find)
    local _strupper = _assert(_g.string.upper)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _pairs, _strlen, _strfind, _strupper, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                                        @formatter:off

local Debug      = _importer("System.Debug")
local Reflection = _importer("System.Reflection")

local Throw                = _importer("System.Exceptions.Throw")
local ArgumentNilException = _importer("System.Exceptions.ArgumentNilException") --       @formatter:on

local Guard = _namespacer("System.Guard")

do
    Guard.Check = _namespacer("System.Guard.Check")

    function Guard.Check.IsNotNil(value)
        -- Debug.Assert(value ~= nil, "value must not be nil\n" .. Debug.Stacktrace() .. "\n")
       
        return value ~= nil
                and Guard.Check
                or Throw(ArgumentNilException:New())
    end

    -- TABLES
    function Guard.Check.IsTable(value)
        Debug.Assert(Reflection.IsTable(value), "value must be a table\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyTable(value)
        Debug.Assert(Reflection.IsOptionallyTable(value), "value must be a table or nil\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsNonEmptyTable(value)
        Debug.Assert(Reflection.IsTable(value), "value must be a table\n" .. Debug.Stacktrace() .. "\n")
        
        for _ in _pairs(value) do
            return Guard.Check -- has at least one key
        end
        
        Debug.Assert(false, "value is a table but it's an empty one\n" .. Debug.Stacktrace() .. "\n")
    end

    -- ENUMS
    function Guard.Check.IsOptionallyEnumValue(enumType, value)
        Debug.Assert(value == nil or enumType.IsValid(value), "value must be a valid enum value or nil\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end
    
    function Guard.Check.IsEnumValue(enumType, value)
        Debug.Assert(enumType.IsValid(value), "value must be a valid enum value\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    -- NUMBERS
    function Guard.Check.IsNumber(value)
        Debug.Assert(Reflection.IsNumber(value), "value must a number\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyNumber(value)
        Debug.Assert(Reflection.IsOptionallyNumber(value), "value must a number or nil\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end
    
    -- INTEGERS
    function Guard.Check.IsInteger(value)
        Debug.Assert(Reflection.IsNumber(value) and _mathfloor(value) == value, "value must an integer\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsPositiveInteger(value)
        Debug.Assert(Reflection.IsInteger(value) and value > 0, "value must a positive integer\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsPositiveIntegerOfMaxValue(value, maxValue)
        Debug.Assert(Reflection.IsInteger(value) and value > 0, "value must a positive integer\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(value <= maxValue, "integer value is too big\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end
    
    function Guard.Check.IsPositiveIntegerOrZero(value)
        Debug.Assert(Reflection.IsInteger(value) and value >= 0, "value must a positive integer or zero\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue)
        Debug.Assert(Reflection.IsInteger(value) and value >= 0, "value must a positive integer or zero\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(value <= maxValue, "integer value is too big\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyPositiveInteger(value)
        if value == nil then
            return Guard.Check
        end
        
        Debug.Assert(Reflection.IsInteger(value) and value > 0, "value must be nil or a positive integer\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyPositiveIntegerOfMaxValue(value, maxValue)
        if value == nil then
            return Guard.Check
        end

        Debug.Assert(Reflection.IsInteger(value) and value > 0, "value must be nil or a positive integer\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(value <= maxValue, "integer value is too big\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyPositiveIntegerOrZero(value)
        if value == nil then
            return Guard.Check
        end

        Debug.Assert(Reflection.IsInteger(value) and value >= 0, "value must be nil or zero or a positive integer\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyPositiveIntegerOrZeroOfMaxValue(value, maxValue)
        if value == nil then
            return Guard.Check
        end

        Debug.Assert(Reflection.IsInteger(value) and value >= 0, "value must be nil or zero or a positive integer\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(value <= maxValue, "integer value is too big\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    -- RATIOS
    function Guard.Check.IsRatioNumber(value)
        Debug.Assert(Reflection.IsNumber(value) and value >= 0 and value <= 1, "value must a number between 0 and 1\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyRatioNumber(value)
        Debug.Assert(value == nil or (Reflection.IsNumber(value) and value >= 0 and value <= 1), "value must be either nil or a ratio between 0 and 1\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end
    
    -- BOOLEANS
    function Guard.Check.IsBooleanizable(value)
        Debug.Assert(Guard.Check.IsBooleanizable_(value), "value must be booleanizable\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end
    
    function Guard.Check.IsOptionallyBooleanizable(value)
        Debug.Assert(value == nil or Guard.Check.IsBooleanizable_(value), "value must be nil or booleanizable\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsBooleanizable_(value)
        return Reflection.IsBoolean(value)
                or Reflection.IsInteger(value)
                or Guard.Check.IsBooleanizableString_(value)
    end

    function Guard.Check.IsBooleanizableString_(value)
        if not Reflection.IsString(value) then
            return false
        end

        value = _strupper(value)

        return     value == "1" --@formatter:off
                or value == "Y"
                or value == "T"
                or value == "YES"
                or value == "TRUE"

                or value == "0"
                or value == "F"
                or value == "N"
                or value == "NO"
                or value == "FALSE" --@formatter:on
    end

    -- STRINGS
    function Guard.Check.IsString(value)
        Debug.Assert(Reflection.IsString(value), "value must a string\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsNonDudString(value)
        Debug.Assert(Reflection.IsString(value) and not Guard.Check.IsDudString_(value), "value must a non-dud string\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsNonDudStringOfMaxLength(value, maxLength)
        Debug.Assert(Reflection.IsString(value) and not Guard.Check.IsDudString_(value), "value must a non-dud string with specific max-length\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(Guard.Check.IsStringOfMaxLength_(value, maxLength), "string is too long\n" .. Debug.Stacktrace() .. "\n")
        
        return Guard.Check
    end

    function Guard.Check.IsOptionallyString(value)
        if value == nil then
            return Guard.Check
        end
        
        Debug.Assert(Reflection.IsString(value), "value must be a string or nil\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyNonDudString(value)
        if value == nil then
            return Guard.Check
        end
        
        Debug.Assert(Reflection.IsString(value) and not Guard.Check.IsDudString_(value), "value must be nil or a non-dud string\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyNonDudStringOfMaxLength(value, maxLength)
        if value == nil then
            return Guard.Check
        end

        Debug.Assert(Reflection.IsString(value) and not Guard.Check.IsDudString_(value), "value must be nil or a non-dud string\n" .. Debug.Stacktrace() .. "\n")
        Debug.Assert(Guard.Check.IsStringOfMaxLength_(value, maxLength), "string is too long\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsDudString_(value) -- we cant use the trim helper here so we had to replicate it
        local startIndex = _strfind(value, "^()%s*$")
        
        return startIndex ~= nil
    end

    function Guard.Check.IsStringOfMaxLength_(value, maxLength)
        return _strlen(value) <= maxLength
    end

    -- FUNCTIONS
    function Guard.Check.IsFunction(value)
        Debug.Assert(Reflection.IsFunction(value), "value must a function\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

    function Guard.Check.IsOptionallyFunction(value)
        Debug.Assert(Reflection.IsOptionallyFunction(value), "value must be nil or a function\n" .. Debug.Stacktrace() .. "\n")

        return Guard.Check
    end

end
