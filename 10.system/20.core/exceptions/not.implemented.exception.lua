local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Exception = using "System.Exceptions.Exception"

local Class = using "[declare] [blend]" "System.Exceptions.NotImplementedException [Partial]" {
    ["Exception"] = Exception
}

Scopify(EScopes.Function, {})

function Class:New(optionalMessage)
    Scopify(EScopes.Function, self)
   
    Guard.Assert.IsNilOrNonDudString(optionalMessage, "message")
    
    -- todo  call the base constructor :New() here

    return self:Instantiate():ChainSetMessage(Nils.Coalesce(optionalMessage, "Not implemented"))
end
