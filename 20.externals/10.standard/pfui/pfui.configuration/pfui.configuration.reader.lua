local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Configuration"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.ConfigurationReader"

Scopify(EScopes.Function, {})

function Class:New()
    return self:Instantiate()
end

function Class:GetLanguageSetting()
    return (PfuiConfiguration.global or {}).language 
end

Class.I = Class:New()