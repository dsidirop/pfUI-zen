local _g =  assert(_G or getfenv(0))
local _assert = assert
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pvl_namespacer_add)
local _setmetatable = assert(_g.setmetatable)

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Settings.PfuiUserPreferencesAdapter")

-- todo  this should be a simple dto and we should just introduce a mapper to map to it
function Class:New(addonRawPfuiPreferencesV1, addonRawPfuiPreferencesSpecsV1)

    local instance = {
        _addonRawPfuiPreferences =  _assert(addonRawPfuiPreferencesV1),
        _addonRawPfuiPreferencesSpecsV1 =  _assert(addonRawPfuiPreferencesSpecsV1),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class.GreenItemsAutolooting_GetMode()
    _setfenv(1, self)
    
    return _addonRawPfuiPreferences[_addonRawPfuiPreferencesSpecsV1.greenies_autolooting.mode.keyname]
end

function Class.GreenItemsAutolooting_GetActOnKeybind()
    _setfenv(1, self)

    return _addonRawPfuiPreferences[_addonRawPfuiPreferencesSpecsV1.greenies_autolooting.mode.keyname]
end
