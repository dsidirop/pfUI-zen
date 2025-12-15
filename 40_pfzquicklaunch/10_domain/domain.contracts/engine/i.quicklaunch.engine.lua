--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IQuicklaunchEngine = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.IQuicklaunchEngine"  --@formatter:off

function IQuicklaunchEngine:Stop() end;
function IQuicklaunchEngine:Start() end;
function IQuicklaunchEngine:Restart() end;
function IQuicklaunchEngine:IsRunning() end;
function IQuicklaunchEngine:SetSettings(settings) end; -- settings is expected to be Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.QuicklaunchEngineSettings
