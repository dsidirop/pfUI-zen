local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" --                                                                          @formatter:off
local EScopes = using "System.EScopes"

local Iterators      = using("System.Iterators")
local Reflection     = using("System.Reflection")
local StringsHelper  = using("System.Helpers.Strings")
local GuardUtilities = using("System.Guard.Utilities")

local Throw                               = using("System.Exceptions.Throw")
local ValueAlreadySetException            = using("System.Exceptions.ValueAlreadySetException")
local ValueCannotBeNilException           = using("System.Exceptions.ValueCannotBeNilException")
local ValueIsOutOfRangeException          = using("System.Exceptions.ValueIsOutOfRangeException")
local ValueIsOfInappropriateTypeException = using("System.Exceptions.ValueIsOfInappropriateTypeException") --     @formatter:on

local Guard = using "[declare]" "System.Guard [Partial]"

Scopify(EScopes.Function, Guard)

do
    Guard.Assert = using "[declare]" "System.Guard.Assert"

    function Guard.Assert.IsUnset(value, optionalArgumentName)
        if value ~= nil then
            Throw(ValueAlreadySetException:New(optionalArgumentName))
        end
        
        return nil
    end
    
    function Guard.Assert.IsNotNil(value, optionalArgumentName)
        if value == nil then
            Throw(ValueCannotBeNilException:New(optionalArgumentName))
        end
        
        return value
    end

    -- TABLES
    function Guard.Assert.IsTable(value, optionalArgumentName)
        if not Reflection.IsTable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table"))
        end
        
        return value
    end

    function Guard.Assert.IsOptionallyTable(value, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsTable(value, optionalArgumentName) 
    end

    function Guard.Assert.IsNonEmptyTable(value, optionalArgumentName)
        if not Reflection.IsTable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table"))
        end
        
        if Iterators.Next(value) == nil then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "non-empty table"))
        end

        return value
    end

    function Guard.Assert.IsOptionallyNonEmptyTable(value, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsNonEmptyTable(value, optionalArgumentName)
    end

    -- ENUMS
    function Guard.Assert.IsEnumValue(enumType, value, optionalArgumentName)
        if not enumType.IsValid(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "enum value"))
        end
        
        return value
    end
    
    function Guard.Assert.IsOptionallyEnumValue(enumType, value, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsEnumValue(enumType, value, optionalArgumentName)
    end

    -- NUMBERS
    function Guard.Assert.IsNumber(value, optionalArgumentName)
        if not Reflection.IsNumber(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "number"))
        end
        
        return value
    end

    function Guard.Assert.IsOptionallyNumber(value, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsNumber(value, optionalArgumentName) 
    end
    
    -- INTEGERS
    function Guard.Assert.IsInteger(value, optionalArgumentName)
        if not Reflection.IsInteger(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "integer"))
        end
        
        return value
    end

    function Guard.Assert.IsPositiveInteger(value, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        if value <= 0 then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer"))
        end
        
        return value
    end

    function Guard.Assert.IsPositiveIntegerOrZero(value, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        if value < 0 then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero"))
        end

        return value
    end

    function Guard.Assert.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Assert.IsInteger(maxValue, maxValue)

        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        if value <= 0 or value > maxValue then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer of max value " .. maxValue))
        end
        
        return value
    end

    function Guard.Assert.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        Guard.Assert.IsInteger(value, optionalArgumentName)
        
        if value < 0 or value > maxValue then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "positive integer or zero of max value " .. maxValue))
        end
        
        return value
    end

    function Guard.Assert.IsOptionallyPositiveInteger(value, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveInteger(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOrZero(value, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveIntegerOrZero(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
    end

    -- RATIOS
    function Guard.Assert.IsRatioNumber(value, optionalArgumentName)
        Guard.Assert.IsNumber(value, optionalArgumentName)
        
        if value < 0 or value > 1 then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "number between [0, 1]"))
        end

        return value
    end

    function Guard.Assert.IsOptionallyRatioNumber(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsRatioNumber(value, optionalArgumentName)
    end
    
    -- BOOLEANS
    function Guard.Assert.IsBooleanizable(value, optionalArgumentName)
        if not GuardUtilities.IsBooleanizable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "booleanizable value"))
        end
        
        return value
    end
    
    function Guard.Assert.IsOptionallyBooleanizable(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsBooleanizable(value, optionalArgumentName)
    end

    -- STRINGS
    function Guard.Assert.IsString(value, optionalArgumentName)
        if not Reflection.IsString(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "string"))
        end
        
        return value
    end

    function Guard.Assert.IsNonDudString(value, optionalArgumentName)
        Guard.Assert.IsString(value, optionalArgumentName)
        
        if StringsHelper.Trim(value) == "" then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "non-dud string"))
        end

        return value 
    end

    function Guard.Assert.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        Guard.Assert.IsNonDudString(value, optionalArgumentName)
        
        if not GuardUtilities.IsStringOfMaxLength(value, maxLength) then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "string of max length " .. StringsHelper.Stringify(maxLength)))
        end

        return value 
    end

    function Guard.Assert.IsOptionallyString(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsString(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyNonDudString(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsNonDudString(value, optionalArgumentName)
    end

    function Guard.Assert.IsOptionallyNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
    end

    -- FUNCTIONS
    function Guard.Assert.IsFunction(value, optionalArgumentName)
        if not Reflection.IsFunction(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "function"))
        end
        
        return value
    end

    function Guard.Assert.IsOptionallyFunction(value, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsFunction(value, optionalArgumentName)
    end

    -- NAMESPACES
    function Guard.Assert.IsNamespaceStringOrRegisteredClassProto(value, optionalArgumentName)
        if not (Reflection.IsString(value) or Reflection.TryGetNamespaceOfClassProto(value) ~= nil) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "namespace string or registered proto"))
        end
        
        return value 
    end

    -- ISA
    function Guard.Assert.IsInstanceOf(value, desiredClassProto, optionalArgumentName)
        if not Reflection.IsInstanceOf(value, desiredClassProto) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "to be of type " .. (Reflection.TryGetNamespaceOfClassProto(desiredClassProto) or "(desired proto is unknown!)")))
        end
        
        return value 
    end

    function Guard.Assert.IsOptionallyInstanceOf(value, desiredClassProto, optionalArgumentName)
        if value == nil then
            return nil
        end
        
        return Guard.Assert.IsInstanceOf(value, desiredClassProto, optionalArgumentName)
    end
end
