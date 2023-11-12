local _g =  assert(_G or getfenv(0))
local _assert = assert
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pavilion_pfui_zen_class_namespacer__add)
local _setmetatable = assert(_g.setmetatable)

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Settings.PfuiSettingsAdapter")

function Class:New(addonRawPfuiSettingsV1, addonRawPfuiSettingsSpecsV1)

    local instance = {
        _addonRawPfuiSettings =  _assert(addonRawPfuiSettingsV1),
        _addonRawPfuiSettingsSpecsV1 =  _assert(addonRawPfuiSettingsSpecsV1),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class.GreenItemsLootAutogambling_GetMode()
    _setfenv(1, self)
    
    return _addonRawPfuiSettings[_addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname]
end

function Class.GreenItemsLootAutogambling_GetActOnKeybind()
    _setfenv(1, self)

    return _addonRawPfuiSettings[_addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname]
end
