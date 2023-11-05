local MAJOR_VERSION = "Linquidate"
local MINOR_VERSION = 14

local _G = _G or getfenv(0)
if not _G.LibStub then
	_G.error(MAJOR_VERSION .. " requires LibStub.")
end

local Linquidate = _G.LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not Linquidate then
	_G.Linquidate_Loader = function() end
	return
end

_G.Linquidate_Loader_funcs = {}
_G.Linquidate_Loader = function(action)
	_G.table.insert(_G.Linquidate_Loader_funcs, action)
end
