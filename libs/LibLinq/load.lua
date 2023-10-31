local _G = _G
local funcs = _G.LibLinq_1_0_Loader_funcs
if not funcs then
	_G.LibLinq_1_0_Loader = nil
	return
end

local assert = _G.assert(_G.assert)

local table_remove = assert(_G.table.remove)
local type = assert(_G.type)
local LibLinq = _G.LibStub("LibLinq-1.0")
while #funcs > 0 do
	local func = table_remove(funcs, 1)
	if type(func) == "function" then
		func(LibLinq)
	end
end
_G.LibLinq_1_0_Loader_funcs = nil