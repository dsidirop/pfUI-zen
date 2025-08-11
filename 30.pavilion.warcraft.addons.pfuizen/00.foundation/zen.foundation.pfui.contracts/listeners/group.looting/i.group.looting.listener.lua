--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

--- @type table IGroupLootingListener
local IGroupLootingListener = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Pfui.Contracts.Listeners.GroupLooting.IGroupLootingListener"

--- @return table IGroupLootingListener the instance of the factory that made the call
function IGroupLootingListener:StartListening()
end

--- @return table IGroupLootingListener the instance of the factory that made the call
function IGroupLootingListener:StopListening()
end

--- @return table IGroupLootingListener the instance of the factory that made the call
function IGroupLootingListener:EventPendingLootItemGamblingDetected_Subscribe(handler, owner)
end

--- @return table IGroupLootingListener the instance of the factory that made the call
function IGroupLootingListener:EventPendingLootItemGamblingDetected_Unsubscribe(handler, owner)
end
