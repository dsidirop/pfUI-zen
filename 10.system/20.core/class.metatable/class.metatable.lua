local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Debug = using "System.Debug"
local Global = using "System.Global"

local Metatable = using "[declare]" "System.Class.MetaTable [Partial]"

Metatable.Set = Debug.Assert(Global.setmetatable, "Global.setmetatable is undefined (how is this even possible?)")
Metatable.Get = Debug.Assert(Global.getmetatable, "Global.getmetatable is undefined (how is this even possible?)")
