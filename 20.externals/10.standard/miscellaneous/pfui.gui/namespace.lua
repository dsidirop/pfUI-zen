local _g = assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer_binder = assert(_g.pvl_namespacer_bind)

local _pfuiGui = assert(_g.pfUI.gui)

_g = nil
_setfenv(1, {})

_namespacer_binder("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui", _pfuiGui)
