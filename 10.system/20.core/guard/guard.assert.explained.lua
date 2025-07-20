--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Reflection   = using "System.Reflection"
local TablesHelper = using "System.Helpers.Tables"

local Throw                               = using "System.Exceptions.Throw"
local ValueCannotBeNilException           = using "System.Exceptions.ValueCannotBeNilException"
local ValueIsOutOfRangeException          = using "System.Exceptions.ValueIsOutOfRangeException"
local ValueIsOfInappropriateTypeException = using "System.Exceptions.ValueIsOfInappropriateTypeException" --@formatter:on

local Guard = using "[declare] [static]" "System.Guard [Partial]"


do
    Guard.Assert.Explained = using "[declare] [static]" "System.Guard.Assert.Explained"
    
    function Guard.Assert.Explained.IsMereFrame(object, customMessage)
        if not Reflection.IsMereFrame(object) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(customMessage))
        end
        
        return object
    end
    
    function Guard.Assert.Explained.IsTable(value, customMessage)
        if not Reflection.IsTable(value) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(customMessage))
        end

        return value
    end
    
    function Guard.Assert.Explained.IsFunction(value, customMessage)
        if not Reflection.IsFunction(value) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(customMessage))
        end

        return value
    end

    function Guard.Assert.Explained.IsString(value, customMessage)
        if not Reflection.IsString(value) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(customMessage))
        end
        
        return value
    end

    function Guard.Assert.Explained.IsNotNil(value, customMessage)
        if value == nil then
            Throw(ValueCannotBeNilException:NewWithMessage(customMessage))
        end
        
        return value
    end

    function Guard.Assert.Explained.IsNilOrEmptyTable(value, customMessage)
        if value == nil or (Reflection.IsTable(value) and TablesHelper.IsNilOrEmpty(value)) then
            Throw(ValueIsOutOfRangeException:NewWithMessage(customMessage))
        end

        return value
    end

    function Guard.Assert.Explained.IsFalse(value, customMessage)
        if not Reflection.IsBoolean(value) or value then
            Throw(ValueIsOutOfRangeException:NewWithMessage(customMessage))
        end

        return value
    end

    function Guard.Assert.Explained.IsTrue(value, customMessage)
        if not Reflection.IsBoolean(value) or not value then
            Throw(ValueIsOutOfRangeException:NewWithMessage(customMessage))
        end

        return value
    end

    function Guard.Assert.Explained.IsInterfaceProto(proto, customMessage)
        if not Reflection.IsInterfaceProto(proto) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(customMessage))
        end

        return proto
    end

    function Guard.Assert.Explained.IsInstanceOf(value, desiredClassProto, customMessage, optionalArgumentName)
        if value == nil or not Reflection.IsInstanceOf(value, desiredClassProto) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(
                    value,
                    customMessage,
                    optionalArgumentName,
                    "to be of type " .. (Reflection.TryGetNamespaceIfProto(desiredClassProto) or "(desired proto is unknown!)")
            ))
        end

        return value
    end

    function Guard.Assert.Explained.IsNilOrInstanceOf(value, desiredClassProto, customMessage, optionalArgumentName)
        if value ~= nil and not Reflection.IsInstanceOf(value, desiredClassProto) then
            Throw(ValueIsOfInappropriateTypeException:NewWithMessage(
                    value,
                    customMessage,
                    optionalArgumentName,
                    "to be nil or instance of type " .. (Reflection.TryGetNamespaceIfProto(desiredClassProto) or "(desired proto is unknown!)")
            ))
        end

        return value
    end
end
