--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local Class = using "[declare] [blend]" "System.Exceptions.ValueAlreadySetException" { --[[@formatter:on]]
    "Exception", using "System.Exceptions.Exception",
}


function Class:New(optionalArgumentName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalArgumentName, "optionalArgumentName")

    local newInstance = self:Instantiate()

    return newInstance.asBase.Exception.New(
            newInstance,
            optionalArgumentName == nil
                    and "Property/field has already been set"
                    or "'" .. optionalArgumentName .. "' has already been set"
    )
end
