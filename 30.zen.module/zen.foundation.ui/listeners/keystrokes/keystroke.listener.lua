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

local ManagedElementBuilder = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Builder")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.Listeners.Keystrokes.KeystrokesListener")

--local frame = CreateFrame("Frame")
--frame:Show()
--
--local _interval = 0.1
--function frame.onUpdate()
--    this.sinceLast = (this.sinceLast or 0) + arg1
--    while (this.sinceLast > _interval) do
--        this.sinceLast = this.sinceLast - _interval
--
--        print2("** 5secs passed **")
--        print2("** IsAltKeyDown()=" .. tostring(IsAltKeyDown() == 1))
--        print2("** IsShiftKeyDown()=" .. tostring(IsShiftKeyDown() == 1))
--        print2("** IsControlKeyDown()=" .. tostring(IsControlKeyDown() == 1))
--    end
--end
--
--frame:SetScript("OnUpdate", frame.onUpdate)

function Class:New(managedElementBuilder)
    _setfenv(1, self)
    
    managedElementBuilder = managedElementBuilder or ManagedElementBuilder:New() -- todo di this as a singleton when di comes to town

    local instance = {
        _managedKeystrokeSpyingElement = managedElementBuilder:WithTypeFrame():Build()
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:EventModifierKeysStateChanged_Subscribe(handler, owner)
    _setfenv(1, self)

    _managedKeystrokeSpyingElement:EventModifierKeysStateChanged_Subscribe(handler, owner)

    return self
end

function Class:EventModifierKeysStateChanged_Unsubscribe(handler)
    _setfenv(1, self)

    _managedKeystrokeSpyingElement:EventModifierKeysStateChanged_Unsubscribe(handler)

    return self
end

function Class:EventKeyDown_Subscribe(handler, owner)
    _setfenv(1, self)

    _managedKeystrokeSpyingElement:EventKeyDown_Subscribe(handler, owner)

    return self
end

function Class:EventKeyDown_Unsubscribe(handler)
    _setfenv(1, self)

    _managedKeystrokeSpyingElement:EventKeyDown_Unsubscribe(handler)

    return self
end

Class.I = Class:New() -- singleton   todo  remove this once di becomes available