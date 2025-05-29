local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard   = using "System.Guard" --               @formatter:off
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes" --             @formatter:on

local Class = using "[declare] [blend]" "System.Exceptions.ValueCannotBeNilException [Partial]" {
    ["Exception"] = using "System.Exceptions.Exception",
}

Scopify(EScopes.Function, {})

function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    return self:Instantiate():ChainSetMessage(_.FormulateMessage_(optionalArgumentName))
end

function Class:NewWithMessage(customMessage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(customMessage, "customMessage")

    return self:Instantiate():ChainSetMessage(customMessage)
end

--- @private
function Class._.FormulateMessage_(optionalArgumentName)
    Scopify(EScopes.Function, Class)

    local message = optionalArgumentName == nil
            and "Value cannot be nil"
            or "'" .. optionalArgumentName .. "' cannot be nil"

    return message
end
