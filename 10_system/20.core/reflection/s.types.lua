--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local STypes = using "[declare] [enum]" "System.Reflection.STypes" --@formatter:off

--- @alias STypes
STypes.Nil             = "nil"
STypes.Table           = "table"
STypes.Number          = "number"
STypes.String          = "string"
STypes.Boolean         = "boolean"
STypes.Function        = "function"
                       
STypes.Thread          = "thread" --   rarely encountered
STypes.Userdata        = "userdata" -- rarely encountered
                   
STypes.Enum            = "enum" -- lua-zensharp stuff here
STypes.Keyword         = "keyword"

STypes.Interface       = "interface" 
STypes.StaticClass     = "static-class"
STypes.AbstractClass   = "abstract-class"
STypes.NonStaticClass  = "non-static-class" -- @formatter:on
