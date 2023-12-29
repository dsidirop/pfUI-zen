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

_setfenv(1, {}) --                                                                                                    @formatter:off

local Reflection = _importer("System.Reflection")

local Throw                               = _importer("System.Exceptions.Throw")
local ValueAlreadySetException            = _importer("System.Exceptions.ValueAlreadySetException")
local ValueCannotBeNilException           = _importer("System.Exceptions.ValueCannotBeNilException")
local ValueIsOutOfRangeException          = _importer("System.Exceptions.ValueIsOutOfRangeException")
local ValueIsOfInappropriateTypeException = _importer("System.Exceptions.ValueIsOfInappropriateTypeException") --     @formatter:on

local Guard = _namespacer("System.Guard")

do
    Guard.Assert = _namespacer("System.Guard.Assert")

    function Guard.Assert.IsUnset(value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Throw(ValueAlreadySetException:New(optionalArgumentName))
    end
    
    function Guard.Assert.IsNotNil(value, optionalArgumentName)
        return value ~= nil
                and Guard.Assert
                or Throw(ValueCannotBeNilException:New(optionalArgumentName))
    end

    -- TABLES
    function Guard.Assert.IsTable(value, optionalArgumentName)
        return Reflection.IsTable(value)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table"))
    end

    function Guard.Assert.IsOptionallyTable(value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Guard.Assert.IsTable(value, optionalArgumentName)
    end

    function Guard.Assert.IsNonEmptyTable(value, optionalArgumentName)
        if not Reflection.IsTable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table"))
        end
        
        if _next(value) == nil then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "non-empty table"))
        end

        return Guard.Assert
    end

    function Guard.Assert.IsOptionallyNonEmptyTable(value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Guard.Assert.IsNonEmptyTable(value, optionalArgumentName)
    end

    -- ENUMS
    function Guard.Assert.IsEnumValue(enumType, value, optionalArgumentName)
        return enumType.IsValid(value)
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, enumType))
    end
    
    function Guard.Assert.IsOptionallyEnumValue(enumType, value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Guard.Assert.IsEnumValue(enumType, value, optionalArgumentName)
    end

    -- NUMBERS
    function Guard.Assert.IsNumber(value, optionalArgumentName)
        return Reflection.IsNumber(value)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "number"))
    end

    function Guard.Assert.IsOptionallyNumber(value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Guard.Assert.IsNumber(value, optionalArgumentName)
    end
    
    -- INTEGERS
    function Guard.Assert.IsInteger(value, optionalArgumentName)
        return Reflection.IsInteger(value)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "integer"))
    end

    function Guard.Assert.IsPositiveInteger(value, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        return value > 0
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer"))
    end

    function Guard.Assert.IsPositiveIntegerOrZero(value, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)

        return value >= 0
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero"))
    end

    function Guard.Assert.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        return value > 0 and value <= maxValue
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer of max value " .. maxValue))
    end

    function Guard.Assert.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        return value >= 0 and value <= maxValue
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero of max value " .. maxValue))
    end

    function Guard.Assert.IsOptionallyPositiveInteger(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsPositiveInteger(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOrZero(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsPositiveIntegerOrZero(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
    end

    -- RATIOS
    function Guard.Assert.IsRatioNumber(value, optionalArgumentName)
        Guard.Assert.IsNumber(value, optionalArgumentName)

        return value >= 0 and value <= 1
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "number between [0, 1]"))
    end

    function Guard.Assert.IsOptionallyRatioNumber(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsRatioNumber(value, optionalArgumentName)
    end
    
    -- BOOLEANS
    function Guard.Assert.IsBooleanizable(value, optionalArgumentName)
        return Guard.Assert.IsBooleanizable_(value)
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "booleanizable value"))
    end
    
    function Guard.Assert.IsOptionallyBooleanizable(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsBooleanizable(value, optionalArgumentName)
    end

    function Guard.Assert.IsBooleanizable_(value)
        return Reflection.IsBoolean(value)
                or Reflection.IsInteger(value)
                or Guard.Assert.IsBooleanizableString_(value)
    end

    function Guard.Assert.IsBooleanizableString_(value)
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
    function Guard.Assert.IsString(value, optionalArgumentName)
        return Reflection.IsString(value)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "string"))
    end

    function Guard.Assert.IsNonDudString(value, optionalArgumentName)
        Guard.Assert.IsString(value, optionalArgumentName)

        return not Guard.Assert.IsDudString_(value)
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "non-dud string"))
    end

    function Guard.Assert.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        Guard.Assert.IsNonDudString(value, optionalArgumentName)

        return Guard.Assert.IsStringOfMaxLength_(value, maxLength)
                and Guard.Assert
                or Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "string of max length " .. _tostring(maxLength)))
    end

    function Guard.Assert.IsOptionallyString(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsString(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyNonDudString(value, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsNonDudString(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end

        return Guard.Assert.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
    end

    function Guard.Assert.IsDudString_(value) -- we cant use the trim helper here so we had to replicate it
        local startIndex = _strfind(value, "^()%s*$")
        
        return startIndex ~= nil
    end

    function Guard.Assert.IsStringOfMaxLength_(value, maxLength)
        return _strlen(value) <= maxLength
    end

    -- FUNCTIONS
    function Guard.Assert.IsFunction(value, optionalArgumentName)
        return Reflection.IsFunction(value)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "function"))
    end

    function Guard.Assert.IsOptionallyFunction(value, optionalArgumentName)
        return value == nil
                and Guard.Assert
                or Guard.Assert.IsFunction(value, optionalArgumentName)
    end

    -- NAMESPACES
    function Guard.Assert.IsNamespaceStringOrRegisteredType(value, optionalArgumentName)
        return Reflection.IsString(value) or Reflection.TryGetNamespaceOfType(value) ~= nil
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "namespace string or registered type"))
    end

    -- ISA
    function Guard.Assert.IsInstanceOf(value, desiredType, optionalArgumentName)
        return Reflection.IsInstanceOf(value, desiredType)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "to be of type " .. (Reflection.TryGetNamespaceOfType(desiredType) .. "(desired type is unknown!)")))
    end

    function Guard.Assert.IsOptionallyInstanceOf(value, desiredType, optionalArgumentName)
        if value == nil then
            return Guard.Assert
        end
        
        return Reflection.IsInstanceOf(value, desiredType)
                and Guard.Assert
                or Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "to be of type " .. (Reflection.TryGetNamespaceOfType(desiredType) .. "(desired type is unknown!)")))
    end
end
