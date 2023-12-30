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

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classes.Classify")

local Schema = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.Pfui.Zen.Schemas.SchemaV1")
local PfuiConfiguration = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Configuration")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext")

function Class:New()
    Scopify(EScopes.Function, self)
    
    local rawAddonSettings = PfuiConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C["zen.v1"]

    return Classify(self, { -- @formatter:off

        Settings = { --        these are all public properties
            Logging = {
                -- placeholder
            },

            EngineSettings = {
                -- placeholder
            },

            UserPreferences = {
                GreeniesGrouplootingAutomation = {
                    Mode         = (rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname]         or Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Default),
                    ActOnKeybind = (rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname] or Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Default),
                },
            },
        },
    }) -- @formatter:on
end

function Class:SaveChanges()
    Scopify(EScopes.Function, self)

    local rawAddonSettings = {}

    -- @formatter:off
    rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname]         = Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode
    rawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname] = Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind
    -- @formatter:on
    
    PfuiConfiguration[Schema.RootKeyname] = rawAddonSettings
end
