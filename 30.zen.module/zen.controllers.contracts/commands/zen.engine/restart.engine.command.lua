local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate()
end
