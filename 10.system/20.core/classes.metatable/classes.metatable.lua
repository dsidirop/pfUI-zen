--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Metatable = using "[declare] [static]" "System.Classes.Metatable"

local B = using "[built-ins]" [[
    SetMetatable = setmetatable,
    GetMetatable = getmetatable,
]]

Metatable.Set = B.SetMetatable
Metatable.Get = B.GetMetatable
