--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"

local Fields  = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.Contracts.Commands.NewConfig.SetNewCustomAssociationsCommand" --[[@formatter:on]]


Fields(function(upcomingInstance)
    upcomingInstance._newCustomAssociationsString = nil

    return upcomingInstance
end)

function Class:New()
    return self:Instantiate()
end

function Class:GetNewCustomAssociationsString()
    Scopify(EScopes.Function, self)

    return _newCustomAssociationsString
end

function Class:ChainSet_NewCustomAssociationsString(newCustomAssociationsString)
    Scopify(EScopes.Function, self)
    
    _newCustomAssociationsString = Guard.Assert.IsString(newCustomAssociationsString, "newCustomAssociationsString")

    return self
end
