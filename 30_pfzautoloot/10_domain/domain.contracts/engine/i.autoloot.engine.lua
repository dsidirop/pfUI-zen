--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IAutolootEngine = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Domain.Contracts.Engine.IAutolootEngine"  --@formatter:off

function IAutolootEngine:Stop() end;
function IAutolootEngine:Start() end;
function IAutolootEngine:Restart() end;
function IAutolootEngine:IsRunning() end;
function IAutolootEngine:SetSettings(settings) end; -- settings is expected to be Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.AutolootEngineSettings
function IAutolootEngine:GreeniesGrouplootingAutomation_SwitchMode(value) end;
function IAutolootEngine:GreeniesGrouplootingAutomation_SwitchActOnKeybind(value) end;

