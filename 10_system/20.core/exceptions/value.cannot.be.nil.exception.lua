--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local Class = using "[declare] [blend]" "System.Exceptions.ValueCannotBeNilException" { -- @formatter:on
    "Exception", using "System.Exceptions.Exception",
}


function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    return self:Instantiate():NewWithMessage(
            optionalArgumentName == nil
                    and "Value cannot be nil"
                    or "'" .. optionalArgumentName .. "' cannot be nil"
    )
end

function Class:NewWithMessage(customMessage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(customMessage, "customMessage")

    local newInstance = self:Instantiate()

    return Class.asBase.Exception.New(newInstance, customMessage)
end
