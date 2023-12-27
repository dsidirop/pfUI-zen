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
local Classify = _importer("System.Classify")

local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryWriteable")

function Class:New(dbcontext)
    Scopify(EScopes.Function, self)

    _assert(_type(dbcontext) == "table")

    return Classify(self, {
        _hasChanges = false,

        _userPreferencesEntity = dbcontext.Settings.UserPreferences,
    })    
end

function Class:HasChanges()
    Scopify(EScopes.Function, self)

    return _hasChanges
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    Scopify(EScopes.Function, self)
    
    _assert(SGreeniesGrouplootingAutomationMode.IsValid(value))
    
    if _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode = value

    return self
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _assert(SGreeniesGrouplootingAutomationActOnKeybind.IsValid(value))

    if _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind = value

    return self
end
