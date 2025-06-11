local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Guard   = using "System.Guard" --               @formatter:off
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes" --             @formatter:on

local Class = using "[declare] [blend]" "System.Exceptions.ValueCannotBeNilException" {
    ["Exception"] = using "System.Exceptions.Exception",
}

Scopify(EScopes.Function, {})

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

    return Class.base.New(newInstance, customMessage)
end
