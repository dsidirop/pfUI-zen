local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" --                                                                          @formatter:off
local EScopes = using "System.EScopes"

local Iterators      = using "System.Iterators"
local Reflection     = using "System.Reflection"
local StringsHelper  = using "System.Helpers.Strings"
local GuardUtilities = using "System.Guard.Utilities"

local Throw                               = using "System.Exceptions.Throw"
local ValueAlreadySetException            = using "System.Exceptions.ValueAlreadySetException"
local ValueCannotBeNilException           = using "System.Exceptions.ValueCannotBeNilException"
local ValueIsOutOfRangeException          = using "System.Exceptions.ValueIsOutOfRangeException"
local ValueIsOfInappropriateTypeException = using "System.Exceptions.ValueIsOfInappropriateTypeException" --     @formatter:on

local Guard = using "[declare] [static]" "System.Guard [Partial]"

Scopify(EScopes.Function, {})

do
    Guard.Assert = using "[declare] [static]" "System.Guard.Assert [Partial]"

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

    -- ARRAYS (can't be made entirely accurate though)
    Guard.Assert.DefaultMaxIndexToCheckInIsTableray = 30 -- can be set by the user to something else
    function Guard.Assert.IsTableray(value, optionalArgumentName, optionalMaxIndexToCheck)
        if not Reflection.IsTable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table-array"))
        end

        local i = 1
        local key = Iterators.Next(value)

        optionalMaxIndexToCheck = optionalMaxIndexToCheck or Guard.Assert.DefaultMaxIndexToCheckInIsTableray
        while key and i < optionalMaxIndexToCheck do
            -- confine the validation to the first few elements of the array for the sake of performance
            if not Reflection.IsNumber(key) or key ~= i then
                Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table-array"))
            end

            i = i + 1
            key = Iterators.Next(value, key)
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

    function Guard.Assert.IsNilOrTable(value, optionalArgumentName)
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

    function Guard.Assert.IsNilOrTableOrNonDudString(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsTableOrNonDudString(value, optionalArgumentName)
    end

    function Guard.Assert.IsTableOrNonDudString(value, optionalArgumentName)
        local IsTableOrNonDudString = Reflection.IsTable(value) or (Reflection.IsString(value) and StringsHelper.Trim(value) ~= "")
        if not IsTableOrNonDudString then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "table or non-dud string"))
        end

        return value
    end

    function Guard.Assert.IsNilOrNonEmptyTable(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsNonEmptyTable(value, optionalArgumentName)
    end

    -- ENUMS
    function Guard.Assert.IsEnumValue(enumType, value, optionalArgumentName)
        if not enumType:IsValid(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "enum value"))
        end

        return value
    end

    function Guard.Assert.IsNilOrEnumValue(enumType, value, optionalArgumentName)
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

    function Guard.Assert.IsPositiveNumber(value, optionalArgumentName)
        if not Reflection.IsNumber(value) or value <= 0 then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "number"))
        end

        return value
    end

    function Guard.Assert.IsNilOrNumber(value, optionalArgumentName)
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

    function Guard.Assert.IsNilOrInteger(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsInteger(value, optionalArgumentName)
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

    function Guard.Assert.IsNilOrPositiveInteger(value, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveInteger(value, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveIntegerOfMaxValue(value, maxValue, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrPositiveIntegerOrZero(value, optionalArgumentName)
        if value == nil then
            return value
        end

        return Guard.Assert.IsPositiveIntegerOrZero(value, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrPositiveIntegerOrZeroOfMaxValue(value, maxValue, optionalArgumentName)
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

    function Guard.Assert.IsNilOrRatioNumber(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsRatioNumber(value, optionalArgumentName)
    end

    -- BOOLEANS
    function Guard.Assert.IsBoolean(value, optionalArgumentName)
        if not Reflection.IsBoolean(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "boolean"))
        end

        return value
    end

    function Guard.Assert.IsBooleanizable(value, optionalArgumentName)
        if not GuardUtilities.IsBooleanizable(value) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "booleanizable value"))
        end

        return value
    end

    function Guard.Assert.IsNilOrBooleanizable(value, optionalArgumentName)
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

    function Guard.Assert.IsStringOfMaxLength(value, optionalArgumentName)
        if not GuardUtilities.IsStringOfMaxLength(value, maxLength) then
            Throw(ValueIsOutOfRangeException:New(value, optionalArgumentName, "string of max length " .. StringsHelper.Stringify(maxLength)))
        end

        return value
    end

    function Guard.Assert.IsNilOrString(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsString(value, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrNonDudString(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsNonDudString(value, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrStringOfMaxLength(value, maxLength, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsStringOfMaxLength(value, maxLength, optionalArgumentName)
    end

    function Guard.Assert.IsNilOrNonDudStringOfMaxLength(value, maxLength, optionalArgumentName)
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

    function Guard.Assert.IsNilOrFunction(value, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsFunction(value, optionalArgumentName)
    end

    -- NAMESPACES
    function Guard.Assert.IsNamespaceStringOrRegisteredNonStaticClassProto(value, optionalArgumentName)
        local IsNamespaceStringOrRegisteredNonStaticClassProto = Reflection.IsString(value) or Reflection.TryGetNamespaceIfNonStaticClassProto(value) ~= nil
        if not IsNamespaceStringOrRegisteredNonStaticClassProto then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "namespace string or registered proto"))
        end

        return value
    end

    -- ISA
    --
    -- local Foobar = using "Some.Class.Foobar"
    --
    -- Guard.Assert.IsInstanceOf(someInstance, Foobar, "someInstance")
    --
    function Guard.Assert.IsInstanceOf(value, desiredClassProto, optionalArgumentName)
        if value == nil or not Reflection.IsInstanceOf(value, desiredClassProto) then
            Throw(ValueIsOfInappropriateTypeException:New(value, optionalArgumentName, "to be of type " .. (Reflection.TryGetNamespaceIfNonStaticClassProto(desiredClassProto) or "(desired proto is unknown!)")))
        end

        return value
    end

    function Guard.Assert.IsNilOrInstanceOf(value, desiredClassProto, optionalArgumentName)
        if value == nil then
            return nil
        end

        return Guard.Assert.IsInstanceOf(value, desiredClassProto, optionalArgumentName)
    end
end
