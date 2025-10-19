--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) -- @formatter:on

local IAutolootEngineMediatorService = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.IAutolootEngineMediatorService" -- @formatter:off

function IAutolootEngineMediatorService:Handle_RestartEngineCommand(command) end;
function IAutolootEngineMediatorService:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command) end;
function IAutolootEngineMediatorService:Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(command) end;
