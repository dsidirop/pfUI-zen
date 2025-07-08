--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Configuration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.ConfigurationReader"


function Class:New()
    return self:Instantiate()
end

function Class:GetLanguageSetting()
    return (PfuiConfiguration.global or {}).language 
end

Class.I = Class:New()