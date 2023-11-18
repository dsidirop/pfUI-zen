local _assert, _setfenv, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = assert(_g.setfenv)
    local _namespacer = assert(_g.pvl_namespacer_add)
    local _setmetatable = assert(_g.setmetatable)

    return _assert, _setfenv, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Settings.PfuiUserPreferencesAdapter")

local _GetSchema

function Class:New(translations)
    _setfenv(1, self)

    local instance = {
        _schema = _assert(_GetSchema(translations)),
        _rawTable = {},
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:GetRawTable()
    _setfenv(1, self)

    return _rawTable
end

function Class:GreenItemsAutolooting_GetMode()
    _setfenv(1, self)

    return _addonRawPfuiPreferences[_schema.greenies_autolooting.mode.keyname]
end

-- needed by automapping
function Class:GreenItemsAutolooting_ChainSetMode(value)
    _setfenv(1, self)
    _assert(value ~= nil, "value must not be nil") -- todo  validation using strongly typed enums

    _addonRawPfuiPreferences[_schema.greenies_autolooting.mode.keyname] = value
    
    return self
end

function Class:GreenItemsAutolooting_GetActOnKeybind()
    _setfenv(1, self)

    return _addonRawPfuiPreferences[_schema.greenies_autolooting.mode.keyname]
end

-- needed by automapping
function Class:GreenItemsAutolooting_SetActOnKeybind(value)
    _setfenv(1, self)
    _assert(value ~= nil, "value must not be nil") -- todo  validation using strongly typed enums

    _addonRawPfuiPreferences[_schema.greenies_autolooting.mode.keyname] = value
    
    return self
end

local _cachedSchema
_GetSchema = function(t)
    _setfenv(1, self)

    if _cachedSchema ~= nil then
        return _cachedSchema -- init once
    end

    _cachedSchema = { -- 00
        greenies_autolooting = {
            mode = {
                keyname = "greenies_autolooting.mode",
                options = {
                    "roll_need:" .. t["Roll '|cFFFF4500Need|r'"],
                    "roll_greed:" .. t["Roll '|cFFFFD700Greed|r'"],
                    "just_pass:" .. t["Just '|cff888888Pass|r'"],
                    "let_user_choose:" .. t["Let me handle it myself"],
                },
            },

            act_on_keybind = {
                keyname = "greenies_autolooting.keybind",
                options = {
                    "automatic:" .. t["|cff888888(Simply Autoloot)|r"],
                    "alt:" .. t["Alt"],
                    "ctrl:" .. t["Ctrl"],
                    "shift:" .. t["Shift"],
                    "ctrl_alt:" .. t["Ctrl + Alt"],
                    "ctrl_shift:" .. t["Ctrl + Shift"],
                    "alt_shift:" .. t["Alt + Shift"],
                    "ctrl_alt_shift:" .. t["Ctrl + Alt + Shift"],
                },
            },
        }
    }

    return schema

    --00  should never be versioned   and since the form relies on pfui controls we need to make sure that the schema adheres to the key-value
    --    system that these controls expect   we are doing all this because we want to trick the controls of the form into believing that they
    --    autosave in the actual settings table while in fact they autosave in a temporary table
end