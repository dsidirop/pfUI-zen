--[=[
Name: LibLinq-1.0
Revision: 1
Author(s): ckknight (ckknight@gmail.com)
Description: A collection and querying library for managing collections of items.
Dependencies: LibStub
]=]

local MAJOR_VERSION = "LibLinq-1.0"
local MINOR_VERSION = 14

local _G = _G
if not _G.LibStub then _G.error(MAJOR_VERSION .. " requires LibStub.") end
local LibLinq = _G.LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not LibLinq then
	_G.LibLinq_1_0_Loader = function() end
	return
end

_G.LibLinq_1_0_Loader_funcs = {}
_G.LibLinq_1_0_Loader = function(action)
	_G.table.insert(_G.LibLinq_1_0_Loader_funcs, action)
end