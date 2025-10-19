--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local PfuiEnvConfiguration = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiEnvConfiguration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiEnvConfigurationReader"


function Class:New()
    return self:Instantiate()
end

function Class:TryGetLanguageSetting()
    return (PfuiEnvConfiguration.global or {}).language 
end

Class.I = Class:New() -- todo  get this from CI
