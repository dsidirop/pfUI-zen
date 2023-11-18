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

Class.Schema = { -- 00  public static
    greenies_autolooting = {
        mode = { keyname = "greenies_autolooting.mode" },
        act_on_keybind = { keyname = "greenies_autolooting.keybind" },
    }

    --00  should never be versioned   and since the form relies on pfui controls we need to make
    --    sure that the schema adheres to the key-value system that these controls expect  we are 
    --    doing all of this because we want to trick the controls of the form into believing that
    --    they autosave in the actual settings table while in fact they autosave in a temporary table
}

function Class:New()
    _setfenv(1, self)

    local instance = {
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

    return _rawTable[Schema.greenies_autolooting.mode.keyname]
end

-- needed by automapper
function Class:GreenItemsAutolooting_ChainSetMode(value)
    _setfenv(1, self)
    _assert(value ~= nil, "value must not be nil") -- todo  validation using strongly typed enums

    _rawTable[Schema.greenies_autolooting.mode.keyname] = value

    return self
end

function Class:GreenItemsAutolooting_GetActOnKeybind()
    _setfenv(1, self)

    return _rawTable[Schema.greenies_autolooting.act_on_keybind.keyname]
end

-- needed by automapper
function Class:GreenItemsAutolooting_ChainSetActOnKeybind(value)
    _setfenv(1, self)
    _assert(value ~= nil, "value must not be nil") -- todo  validation using strongly typed enums

    _rawTable[Schema.greenies_autolooting.act_on_keybind.keyname] = value

    return self
end
