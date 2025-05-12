local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local SRawTypes = using "[declare] [enum]" "System.Language.SRawTypes [Partial]"

SRawTypes.Nil        =   "nil" --                                 @formatter:off
SRawTypes.Table      =   "table"
SRawTypes.Number     =   "number"
SRawTypes.String     =   "string"
SRawTypes.Boolean    =   "boolean"
SRawTypes.Function   =   "function"

SRawTypes.Thread     =   "thread" --   rarely encountered
SRawTypes.Userdata   =   "userdata" -- rarely encountered         @formatter:on
