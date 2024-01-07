local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local STypes = using "[declare:enum]" "System.Reflection.STypes" --@formatter:off

STypes.Nil         =   "nil"
STypes.Table       =   "table"
STypes.Number      =   "number"
STypes.String      =   "string"
STypes.Boolean     =   "boolean"
STypes.Function    =   "function"
                   
STypes.Thread      =   "thread" --   rarely encountered
STypes.Userdata    =   "userdata" -- rarely encountered
                   
STypes.Enum        =   "enum"
STypes.Class       =   "class"
--STypes.Interface = "Interface" -- todo   @formatter:on
