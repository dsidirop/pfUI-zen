--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SRawTypes = using "[declare] [enum]" "System.Language.SRawTypes"

SRawTypes.Nil        =   "nil" --                                 @formatter:off
SRawTypes.Table      =   "table"
SRawTypes.Number     =   "number"
SRawTypes.String     =   "string"
SRawTypes.Boolean    =   "boolean"
SRawTypes.Function   =   "function"

SRawTypes.Thread     =   "thread" --   rarely encountered
SRawTypes.Userdata   =   "userdata" -- rarely encountered         @formatter:on
