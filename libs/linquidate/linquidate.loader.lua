local _G = _G or getfenv(0)

local funcs = _G.Linquidate_Loader_funcs
if not funcs then
    _G.Linquidate_Loader = nil
    return
end

local assert = _G.assert

local type = assert(_G.type)
local table_getn = assert(_G.table.getn)
local table_remove = assert(_G.table.remove)

local Linquidate = _G.LibStub("Linquidate")
while table_getn(funcs) > 0 do
    local func = table_remove(funcs, 1)
    if type(func) == "function" then
        func(Linquidate)
    end
end

_G.Linquidate_Loader_funcs = nil
