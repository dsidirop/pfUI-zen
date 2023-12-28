local _setfenv, _next, _strlen, _strfind, _strupper, _tostring, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _next = _assert(_g.next)
    local _strlen = _assert(_g.string.len)    
    local _strfind = _assert(_g.string.find)
    local _strupper = _assert(_g.string.upper)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _tostring = _assert(_g.tostring)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _next, _strlen, _strfind, _strupper, _tostring, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                                                      @formatter:off

local Reflection = _importer("System.Reflection")

local Throw                                  = _importer("System.Exceptions.Throw")
local AlreadySetException                    = _importer("System.Exceptions.AlreadySetException")
local ArgumentNilException                   = _importer("System.Exceptions.ArgumentNilException")
local ArgumentOutOfRangeException            = _importer("System.Exceptions.ArgumentOutOfRangeException")
local ArgumentIsOfInappropriateTypeException = _importer("System.Exceptions.ArgumentIsOfInappropriateTypeException") --     @formatter:on

local Guard = _namespacer("System.Guard")

do
    Guard.Check = _namespacer("System.Guard.Check")

    function Guard.Check.IsUnset(value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Throw(AlreadySetException:New(optionalArgumentName))
    end
    
    function Guard.Check.IsNotNil(value, optionalArgumentName)
        return value ~= nil
                and Guard.Check
                or Throw(ArgumentNilException:New(optionalArgumentName))
    end

    -- TABLES
    function Guard.Check.IsTable(value, optionalArgumentName)
        return Reflection.IsTable(value)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "table"))
    end

    function Guard.Check.IsOptionallyTable(value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Guard.Check.IsTable(value, optionalArgumentName)
    end

    function Guard.Check.IsNonEmptyTable(value, optionalArgumentName)
        if not Reflection.IsTable(value) then
            Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "table"))
        end
        
        if _next(value) == nil then
            Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "non-empty table"))
        end

        return Guard.Check
    end

    function Guard.Check.IsOptionallyNonEmptyTable(value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Guard.Check.IsNonEmptyTable(value, optionalArgumentName)
    end

    -- ENUMS
    function Guard.Check.IsEnumValue(enumType, value, optionalArgumentName)
        return enumType.IsValid(value)
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, enumType))
    end
    
    function Guard.Check.IsOptionallyEnumValue(enumType, value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Guard.Check.IsEnumValue(enumType, value, optionalArgumentName)
    end

    -- NUMBERS
    function Guard.Check.IsNumber(value, optionalArgumentName)
        return Reflection.IsNumber(value)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "number"))
    end

    function Guard.Check.IsOptionallyNumber(value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Guard.Check.IsNumber(value, optionalArgumentName)
    end
    
    -- INTEGERS
    function Guard.Check.IsInteger(value, optionalArgumentName)
        return Reflection.IsInteger(value)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "integer"))
    end

    function Guard.Check.IsPositiveInteger(value, optionalArgumentName)
        Guard.Check.IsInteger(value, optionalArgumentName)
        
        return value > 0
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "positive integer"))
    end

    function Guard.Check.IsPositiveIntegerOrZero(value, optionalArgumentName)
        Guard.Check.IsInteger(value, optionalArgumentName)

        return value >= 0
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero"))
    end

    function Guard.Check.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Check.IsInteger(value, optionalArgumentName)
        
        return value > 0 and value <= maxValue
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "positive integer of max value " .. maxValue))
    end

    function Guard.Check.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Check.IsInteger(value, optionalArgumentName)
        
        return value >= 0 and value <= maxValue
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero of max value " .. maxValue))
    end

    function Guard.Check.IsOptionallyPositiveInteger(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsPositiveInteger(value, optionalArgumentName)
    end

    function Guard.Check.IsOptionallyPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
    end

    function Guard.Check.IsOptionallyPositiveIntegerOrZero(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsPositiveIntegerOrZero(value, optionalArgumentName)
    end

    function Guard.Check.IsOptionallyPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
    end

    -- RATIOS
    function Guard.Check.IsRatioNumber(value, optionalArgumentName)
        Guard.Check.IsNumber(value, optionalArgumentName)

        return value >= 0 and value <= 1
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "number between [0, 1]"))
    end

    function Guard.Check.IsOptionallyRatioNumber(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsRatioNumber(value, optionalArgumentName)
    end
    
    -- BOOLEANS
    function Guard.Check.IsBooleanizable(value, optionalArgumentName)
        return Guard.Check.IsBooleanizable_(value)
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "booleanizable value"))
    end
    
    function Guard.Check.IsOptionallyBooleanizable(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsBooleanizable(value, optionalArgumentName)
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
    function Guard.Check.IsString(value, optionalArgumentName)
        return Reflection.IsString(value)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "string"))
    end

    function Guard.Check.IsNonDudString(value, optionalArgumentName)
        Guard.Check.IsString(value, optionalArgumentName)

        return not Guard.Check.IsDudString_(value)
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "non-dud string"))
    end

    function Guard.Check.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        Guard.Check.IsNonDudString(value, optionalArgumentName)

        return Guard.Check.IsStringOfMaxLength_(value, maxLength)
                and Guard.Check
                or Throw(ArgumentOutOfRangeException:New(value, optionalArgumentName, "string of max length " .. _tostring(maxLength)))
    end

    function Guard.Check.IsOptionallyString(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsString(value, optionalArgumentName)
    end

    function Guard.Check.IsOptionallyNonDudString(value, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsNonDudString(value, optionalArgumentName)
    end

    function Guard.Check.IsOptionallyNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        if value == nil then
            return Guard.Check
        end

        return Guard.Check.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
    end

    function Guard.Check.IsDudString_(value) -- we cant use the trim helper here so we had to replicate it
        local startIndex = _strfind(value, "^()%s*$")
        
        return startIndex ~= nil
    end

    function Guard.Check.IsStringOfMaxLength_(value, maxLength)
        return _strlen(value) <= maxLength
    end

    -- FUNCTIONS
    function Guard.Check.IsFunction(value, optionalArgumentName)
        return Reflection.IsFunction(value)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "function"))
    end

    function Guard.Check.IsOptionallyFunction(value, optionalArgumentName)
        return value == nil
                and Guard.Check
                or Guard.Check.IsFunction(value, optionalArgumentName)
    end

    -- NAMESPACES
    function Guard.Check.IsNamespaceStringOrRegisteredType(value, optionalArgumentName)
        return Reflection.IsString(value) or Reflection.GetNamespaceOfType(value) ~= nil
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "namespace string or registered type"))
    end

    -- ISA
    function Guard.Check.IsInstanceOf(value, desiredType, optionalArgumentName)
        return Reflection.IsInstanceOf(value, desiredType)
                and Guard.Check
                or Throw(ArgumentIsOfInappropriateTypeException:New(optionalArgumentName, "to be of type " .. (Reflection.GetNamespaceOfType(desiredType) .. "(desired type is unknown!)")))
    end
end
