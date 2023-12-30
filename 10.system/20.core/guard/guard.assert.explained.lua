local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" --                                                               @formatter:off
local EScopes = using "System.EScopes"

local Throw                               = using("System.Exceptions.Throw")
local ValueCannotBeNilException           = using("System.Exceptions.ValueCannotBeNilException") --     @formatter:on

local Guard = using "[declare]" "System.Guard [Partial]"

Scopify(EScopes.Function, Guard)

do
    Guard.Assert.Explained = using "[declare]" "System.Guard.Assert.Explained"

    function Guard.Assert.Explained.IsNotNil(value, customMessage)
        if value == nil then
            Throw(ValueCannotBeNilException:NewWithMessage(customMessage))
        end
        
        return value
    end
end
