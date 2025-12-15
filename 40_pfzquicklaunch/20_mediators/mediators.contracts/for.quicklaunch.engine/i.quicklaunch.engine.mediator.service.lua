--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IQuicklaunchEngineMediatorService = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.Contracts.ForQuicklaunchEngine.IQuicklaunchEngineMediatorService"

function IQuicklaunchEngineMediatorService:Handle_SetNewCustomAssociationsCommand(command) end;
function IQuicklaunchEngineMediatorService:Handle_TweakEnabledStateOnEngineCommand(command) end;
function IQuicklaunchEngineMediatorService:Handle_RestartEngineIfApplicableCommand(command) end;
