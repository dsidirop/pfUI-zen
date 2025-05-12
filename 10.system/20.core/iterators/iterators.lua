local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Iterators = using "[declare] [static]" "System.Iterators [Partial]"

Iterators.Next = using "[built-in]" "next"
