--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard      = using "System.Guard"
local Namespacer = using "System.Namespacer"

local Fields = using "[declare] [static]" "System.Classes.Fields"

using "[autocall]"
function Fields:SetFieldPluggerFunc(classFieldPluggerCallbackFunc)
    Guard.Assert.IsNotNil(classFieldPluggerCallbackFunc, "classFieldPluggerCallbackFunc")
    
    local proto, _ = Guard.Assert.Explained.IsNotNil(Namespacer:GetMostRecentlyDefinedSymbolProtoAndTidbits(), "seems no class is being defined at this moment - cannot plug fields into nothing")

    Namespacer:ChainSetFieldPluggerFuncForNonStaticClassProto(proto, classFieldPluggerCallbackFunc)
end
