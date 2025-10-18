--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) -- @formatter:on

local IModifierKeysListener = using "[declare] [interface]" "Pavilion.Warcraft.Foundation.Contracts.Listeners.ModifiersKeystrokes.IModifierKeysListener"

-- @formatter:off
function IModifierKeysListener:Stop() end;
function IModifierKeysListener:Start() end;
function IModifierKeysListener:ChainSet_PollingInterval(interval) end;
function IModifierKeysListener:ChainSet_MustEmitOnFreshStart(mustEmitOnFreshStart) end;
function IModifierKeysListener:EventModifierKeysStatesChanged_Subscribe(handler, owner) end;
function IModifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(handler) end;
-- @formatter:on
