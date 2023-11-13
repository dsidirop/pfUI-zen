local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_bind = assert(_g.pavilion_pfui_zen_class_namespacer__bind)

local _mta_lualinq_enumerable = assert(_g.Enumerable)
local _libstub_service_locator = assert(_g.LibStub)

_g = nil
_setfenv(1, {})

_namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable", _mta_lualinq_enumerable)
_namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
