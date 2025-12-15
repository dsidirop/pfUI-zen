--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard   = using "System.Guard" -- @formatter:off

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.Quicklauncher.AggregateSettings"


Fields(function(upcomingInstance)
    return upcomingInstance
end)

function Class:New()
    return self:Instantiate()
end
