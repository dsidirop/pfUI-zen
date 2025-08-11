--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IZenEngineMediatorService = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.IZenEngineMediatorService" -- @formatter:on


function IZenEngineMediatorService:Handle_RestartEngineCommand(command)
end

function IZenEngineMediatorService:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
end

function IZenEngineMediatorService:Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(command)
end
