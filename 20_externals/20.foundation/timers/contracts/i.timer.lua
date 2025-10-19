--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local ITimer = using "[declare] [interface]" "Pavilion.Warcraft.Foundation.Timers.Contracts.ITimer" -- @formatter:on

function ITimer:Stop() end;
function ITimer:Start() end;
function ITimer:IsRunning() end;
function ITimer:GetInterval() end;
function ITimer:ChainSet_Interval(newInterval) end;
function ITimer:EventElapsed_Subscribe(handler, owner) end;
function ITimer:EventElapsed_Unsubscribe(handler) end;
