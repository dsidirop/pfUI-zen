--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IZenEngine = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.IZenEngine"

function IZenEngine:IsRunning()
end

-- settings is expected to be Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.ZenEngineSettings
function IZenEngine:SetSettings(settings)
end

function IZenEngine:Restart()
end

function IZenEngine:Start()
end

function IZenEngine:Stop()
end

function IZenEngine:GreeniesGrouplootingAutomation_SwitchMode(value)
end

function IZenEngine:GreeniesGrouplootingAutomation_SwitchActOnKeybind(value)
end

