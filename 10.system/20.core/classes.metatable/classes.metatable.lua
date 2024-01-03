local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Metatable = using "[declare]" "System.Classes.MetaTable [Partial]"

Metatable.Set = using "[global]" "setmetatable"
Metatable.Get = using "[global]" "getmetatable"
