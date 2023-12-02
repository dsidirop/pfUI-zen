local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local SchemaV1 = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.Pfui.Zen.Schemas.SchemaV1")

-- todo  take this into account in the future when we have new versions that we have to smoothly upgrade the preexisting versions to

SchemaV1.RootKeyname = "zen.v1" -- must be hardcoded right here   its an integral part of the settings specs and not of the addon specs 

SchemaV1.Settings = {
    Logging = {
        -- nothing yet
    },
    
    EngineSettings = {
        -- nothing yet
    },
    
    UserPreferences = {
        GreeniesAutolooting = {
            Mode = {
                Keyname = "user_preferences.greenies_autolooting.mode",
                Default = SGreeniesGrouplootingAutomationMode.RollGreed,
            },

            ActOnKeybind = {
                Keyname = "user_preferences.greenies_autolooting.act_on_keybind",
                Default = SGreeniesGrouplootingAutomationActOnKeybind.Automatic,
            },
        },
    },
}

