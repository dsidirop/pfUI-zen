--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

--- @type table IPfuiRollsUiFramesListener
local IPfuiMainSettingsFormGuiControlsFactory = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Pfui.Listeners.GroupLootingListener.Contracts.IPfuiRollsUiFramesListener"

--- @return table IPfuiMainSettingsFormGuiControlsFactory the instance of the factory that made the call
function IPfuiMainSettingsFormGuiControlsFactory:StartListening()
end

--- @return table IPfuiMainSettingsFormGuiControlsFactory the instance of the factory that made the call
function IPfuiMainSettingsFormGuiControlsFactory:StopListening()
end

--- @return table IPfuiMainSettingsFormGuiControlsFactory the instance of the factory that made the call
function IPfuiMainSettingsFormGuiControlsFactory:EventPendingLootItemGamblingDetected_Subscribe(handler, owner)
end

--- @return table IPfuiMainSettingsFormGuiControlsFactory the instance of the factory that made the call
function IPfuiMainSettingsFormGuiControlsFactory:EventPendingLootItemGamblingDetected_Unsubscribe(handler, owner)
end
