local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" --                                                               @formatter:off
local EScopes = using "System.EScopes"

local Reflection   = using "System.Reflection"
local TablesHelper = using "System.Helpers.Tables"

local Throw                               = using("System.Exceptions.Throw")
local ValueCannotBeNilException           = using("System.Exceptions.ValueCannotBeNilException")
local ValueIsOutOfRangeException          = using("System.Exceptions.ValueIsOutOfRangeException") --    @formatter:on

local Guard = using "[declare]" "System.Guard [Partial]"

Scopify(EScopes.Function, {})

do
    Guard.Assert.Explained = using "[declare]" "System.Guard.Assert.Explained"

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
end
