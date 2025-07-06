local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Iterators = using "[declare] [static]" "System.Iterators"

Iterators.Next = using "[built-in]" "next"
