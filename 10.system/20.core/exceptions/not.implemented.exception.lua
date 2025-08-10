--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils      = using "System.Nils"
local Guard     = using "System.Guard"
local Exception = using "System.Exceptions.Exception"

local Class = using "[declare] [blend]" "System.Exceptions.NotImplementedException" { --@formatter:on
    "Exception", Exception
}

function Class:New(optionalMessage)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrNonDudString(optionalMessage, "message")

    local newInstance = self:Instantiate()

    return Class.asBase.Exception.New(newInstance, Nils.Coalesce(optionalMessage, "Not implemented"))
end
