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

local ZenEngine = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine")
local ZenEngineSettings = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings")
local UserPreferencesUnitOfWork = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService")

function Class:New(userPreferencesUnitOfWork)
    _setfenv(1, self)

    local instance = {
        _zenEngineSingleton = ZenEngine.I, --todo   refactor this later on so that this gets injected through DI        
        _userPreferencesUnitOfWork = userPreferencesUnitOfWork or UserPreferencesUnitOfWork:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:EngineFreshStart()
    _setfenv(1, self)

    local userPreferencesDto = _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                                                         :GetAllUserPreferences()

    local zenEngineSettings = ZenEngineSettings:New() -- todo  automapper
    zenEngineSettings:GetGreeniesAutolooterAggregateSettings():ChainSetMode(userPreferencesDto:GetGreeniesAutolooting_Mode())
    zenEngineSettings:GetGreeniesAutolooterAggregateSettings():ChainSetActOnKeybind(userPreferencesDto:GetGreeniesAutolooting_ActOnKeybind())

    _zenEngineSingleton:Stop()
                       :SetSettings(zenEngineSettings)
                       :Start()

    return self
end

function Class:Handle_GreenItemsAutolootingApplyNewModeCommand(command)
    _setfenv(1, self)
    
    _assert(_type(command) == "table", "command parameter is expected to be an object")

    _zenEngineSingleton:GreeniesAutolooting_SwitchMode(command:GetNewValue()) -- order

    _userPreferencesUnitOfWork:GetUserPreferencesRepository() --                 order
                              :GreeniesAutolooting_ChainUpdateMode(command:GetNewValue())

    if _userPreferencesUnitOfWork:SaveChanges() then
        -- todo   raise side-effect domain-events here
    end

    return self
end

function Class:Handle_GreenItemsAutolootingApplyNewActOnKeybindCommand(command)
    _setfenv(1, self)

    _assert(_type(command) == "table", "command parameter is expected to be an object")

    _zenEngineSingleton:GreeniesAutolooting_SwitchActOnKeybind(command:GetNewValue()) -- order

    _userPreferencesUnitOfWork:GetUserPreferencesRepository() --                         order
                              :GreeniesAutolooting_ChainUpdateActOnKeybind(command:GetNewValue())

    if _userPreferencesUnitOfWork:SaveChanges() then
        -- todo   raise side-effect domain-events here
    end

    return self
end
