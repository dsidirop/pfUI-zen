local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Global = using "System.Global"

local Iterators = using "[declare]" "System.Iterators [Partial]"

Iterators.Next = assert(Global.next, "Global.next() doesn't exist")
