local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Guard      = using "System.Guard"
local Namespacer = using "System.Namespacer"

local Fields = using "[declare] [static]" "System.Classes.Fields"

function Fields:__Call__(classFieldPluggerCallbackFunc)
    Guard.Assert.IsNotNil(classFieldPluggerCallbackFunc)
    
    local proto, _ = Guard.Assert.Explained.IsNotNil(Namespacer:GetMostRecentlyDefinedSymbolProtoAndTidbits(), "seems no class is being defined at this moment - cannot plug fields into nothing")

    Namespacer:ChainSetFieldPluggerFuncForNonStaticClassProto(proto, classFieldPluggerCallbackFunc)
end
