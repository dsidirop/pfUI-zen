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

local Classify = _importer("System.Classify")

local ZenEngine = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine")
local ZenEngineSettings = _importer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings")
local UserPreferencesService = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.Service")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService")

function Class:New(userPreferencesService)
    _setfenv(1, self)

    return Classify(self, {
        _zenEngineSingleton = ZenEngine.I, --todo   refactor this later on so that this gets injected through DI        
        _userPreferencesService = userPreferencesService or UserPreferencesService:NewWithDBContext(),
    })
end

function Class:Handle_RestartEngineCommand(_)
    _setfenv(1, self)

    local userPreferencesDto = _userPreferencesService:GetAllUserPreferences()

    local zenEngineSettings = ZenEngineSettings:New() -- todo  automapper

    zenEngineSettings:GetGreeniesAutolooterAggregateSettings()
                     :ChainSetMode(userPreferencesDto:GetGreeniesGrouplootingAutomation_Mode())
                     :ChainSetActOnKeybind(userPreferencesDto:GetGreeniesGrouplootingAutomation_ActOnKeybind())

    _zenEngineSingleton:Stop()
                       :SetSettings(zenEngineSettings)
                       :Start()

    return self
end

function Class:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
    _setfenv(1, self)

    _assert(_type(command) == "table", "command parameter is expected to be an object")

    _zenEngineSingleton:GreeniesGrouplootingAutomation_SwitchMode(command:GetNewValue()) --                     order

    local success = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateMode(command:GetNewValue()) -- order
    if success then
        -- todo   raise side-effect domain-events here
    end

    return self
end

function Class:Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(command)
    _setfenv(1, self)

    _assert(_type(command) == "table", "command parameter is expected to be an object")

    _zenEngineSingleton:GreeniesGrouplootingAutomation_SwitchActOnKeybind(command:GetNewValue()) --                      order

    local success = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateActOnKeybind(command:GetNewValue()) --  order
    if success then
        -- todo   raise side-effect domain-events here
    end

    return self
end
