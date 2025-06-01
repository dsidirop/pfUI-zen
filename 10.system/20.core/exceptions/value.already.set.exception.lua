local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard              = using "System.Guard" --               @formatter:off
local Scopify            = using "System.Scopify"
local EScopes            = using "System.EScopes" --             @formatter:on

local Class = using "[declare] [blend]" "System.Exceptions.ValueAlreadySetException [Partial]" {
    ["Exception"] = using "System.Exceptions.Exception",
}

Scopify(EScopes.Function, {})

function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    local newInstance = self:Instantiate()

    return newInstance.base.New(
            newInstance,
            optionalArgumentName == nil
                    and "Property/field has already been set"
                    or "'" .. optionalArgumentName .. "' has already been set"
    )
end
