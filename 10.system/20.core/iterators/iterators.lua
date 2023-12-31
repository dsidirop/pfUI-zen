local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"
local Validation = using "System.Validation"

local Iterators = using "[declare]" "System.Iterators [Partial]"

Iterators.Next = Validation.Assert(Global.next, "Global.next() doesn't exist")
