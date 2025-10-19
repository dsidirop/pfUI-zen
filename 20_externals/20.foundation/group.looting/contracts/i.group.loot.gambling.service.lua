--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Service = using "[declare] [interface]" "Pavilion.Warcraft.Foundation.GroupLooting.Contracts.IGroupLootGamblingService"

function Service:GetGambledItemInfo(gamblingId) end;
function Service:SubmitResponseToItemGamblingRequest(gamblingRequestId, wowRollMode) end;
function Service:SubmitSameResponseToAllItemGamblingRequests(gamblingRequestIdsArray, wowRollMode) end;
