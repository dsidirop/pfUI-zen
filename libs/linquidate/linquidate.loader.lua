local _G = _G
local funcs = _G.Linquidate_Loader_funcs
if not funcs then
	_G.Linquidate_Loader = nil
	return
end

local assert = _G.assert(_G.assert)

local table_remove = assert(_G.table.remove)
local type = assert(_G.type)
local Linquidate = _G.LibStub("Linquidate")
while table.getn(funcs) > 0 do
	local func = table_remove(funcs, 1)
	if type(func) == "function" then
		func(Linquidate)
	end
end
_G.Linquidate_Loader_funcs = nil
