local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Validation = using "System.Validation"

local Metatable = using "[declare]" "System.Classes.MetaTable [Partial]"

Metatable.Set = Validation.Assert(Global.setmetatable, "Global.setmetatable is undefined (how is this even possible?)")
Metatable.Get = Validation.Assert(Global.getmetatable, "Global.getmetatable is undefined (how is this even possible?)")
