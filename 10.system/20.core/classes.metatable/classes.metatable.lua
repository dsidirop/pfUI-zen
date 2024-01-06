local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Metatable = using "[declare]" "System.Classes.Metatable [Partial]"

local B = using "[built-ins]" [[
    SetMetatable = setmetatable,
    GetMetatable = getmetatable,
]]

Metatable.Set = B.SetMetatable
Metatable.Get = B.GetMetatable
