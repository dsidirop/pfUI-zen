--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IQuicklauncherAggregate = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.Quicklauncher.IAggregate"

function IQuicklauncherAggregate:Stop() end
function IQuicklauncherAggregate:Start() end
function IQuicklauncherAggregate:Restart() end
function IQuicklauncherAggregate:IsRunning() end
function IQuicklauncherAggregate:SetSettings(settings) end -- settings is expected to be AggregateSettings
