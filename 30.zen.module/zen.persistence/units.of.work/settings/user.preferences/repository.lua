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

local UserPreferencesDto = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.Repository")

function Class:New(dbcontext)  
    _setfenv(1, self)

    _assert(_type(dbcontext) == "table")

    local instance = {
        _hasChanges = false,
        
        _userPreferencesEntity = dbcontext.Settings.UserPreferences,
    }

    _setmetatable(instance, self)
    self.__index = self
    
    return instance
end

function Class:HasChanges()
    _setfenv(1, self)

    return _hasChanges
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    _setfenv(1, self)

    return UserPreferencesDto
            :New()
            :ChainSetGreeniesAutolooting_Mode(_userPreferencesEntity.GreeniesAutolooting.Mode)
            :ChainSetGreeniesAutolooting_ActOnKeybind(_userPreferencesEntity.GreeniesAutolooting.ActOnKeybind)
end

-- @return self
function Class:GreeniesAutolooting_ChainUpdateMode(value)
    _setfenv(1, self)
    
    _assert(SGreenItemsAutolootingMode.Validate(value))
    
    if _userPreferencesEntity.GreeniesAutolooting.Mode == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesAutolooting.Mode = value

    return self
end

-- @return self
function Class:GreeniesAutolooting_ChainUpdateActOnKeybind(value)
    _setfenv(1, self)

    _assert(SGreenItemsAutolootingActOnKeybind.Validate(value))

    if _userPreferencesEntity.GreeniesAutolooting.ActOnKeybind == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesAutolooting.ActOnKeybind = value

    return self
end
