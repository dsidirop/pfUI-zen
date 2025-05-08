local _assert, _setfenv, _type, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _assert, _setfenv, _type, _importer, _namespacer
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local WoWUIParent = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.UIParent")
local WoWCreateFrame = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame")

local ManagedElement = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element")
local SWoWElementType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWElementType") 

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Builder")

function Class:New(other)
    Scopify(EScopes.Function, self)
    
    _assert(other == nil or _type(other) == "table", "other must be nil or a table")

    other = other or {}

    return self:Instantiate({
        _elementType = other._elementType or SWoWElementType.Frame,
        
        _name = other._name,
        _frameStrata = other._frameStrata,
        _desiredParentElement = other._desiredParentElement,
        _propagateKeyboardInput = other._propagateKeyboardInput,
        _keystrokeListenerEnabled = other._keystrokeListenerEnabled,
        _useWowUIRootFrameAsParent = other._useWowUIRootFrameAsParent,
        _namedXmlFramesToInheritFrom = other._namedXmlFramesToInheritFrom,
    })
end

function Class:Build()
    Scopify(EScopes.Function, self)

    local eventualParentElement = _useWowUIRootFrameAsParent
            and WoWUIParent
            or _desiredParentElement

    local newElement = WoWCreateFrame(
            _elementType,
            _name, -- if the name is set to something then wowapi will autocreate a global variable _g[_name] = frame  ouch
            eventualParentElement,
            _namedXmlFramesToInheritFrom
    )

    local managedElement = ManagedElement:New(newElement)

    if _frameStrata ~= nil then
        managedElement:ChainSetFrameStrata(_frameStrata)
    end

    if _propagateKeyboardInput ~= nil then
        managedElement:ChainSetPropagateKeyboardInput(_propagateKeyboardInput)
    end

    if _keystrokeListenerEnabled ~= nil then
        managedElement:ChainSetKeystrokeListenerEnabled(_keystrokeListenerEnabled)
    end

    return managedElement
end

function Class:WithTypeFrame()
    Scopify(EScopes.Function, self)

    return self:WithType(SWoWElementType.Frame)
end

function Class:WithType(frameType)
    Scopify(EScopes.Function, self)

    _assert(SWoWElementType:IsValid(frameType), "frameType should be SWoWElementType (frameType = " .. (frameType or "nil") .. ")")
    
    local clone = Class:New(self)
    clone._elementType = frameType

    return clone
end

function Class:WithStrata(value)
    Scopify(EScopes.Function, self)

    _assert(_type(value) == "string", "frame-strata must be a string")

    local clone = Class:New(self)
    clone._frameStrata = value

    return clone
end

function Class:WithKeystrokeListenerEnabled(onOrOff)
    Scopify(EScopes.Function, self)

    _assert(_type(onOrOff) == "boolean", "value must be a boolean")

    local clone = Class:New(self)
    clone._keystrokeListenerEnabled = onOrOff

    return clone
end

function Class:WithName(name)
    Scopify(EScopes.Function, self)

    _assert(name == nil or _type(name) == "string", "name must nil or a string")
    
    local clone = Class:New(self)
    clone._name = name

    return clone
end

function Class:WithParentElement(parentElement)
    Scopify(EScopes.Function, self)

    _assert(parentElement == nil or _type(parentElement) == "table", "parentElement must be nil or a table")
    
    local clone = Class:New(self)
    clone._desiredParentElement = parentElement

    return clone
end

function Class:WithPropagateKeyboardInput(propagateKeyboardInput)
    Scopify(EScopes.Function, self)

    _assert(_type(propagateKeyboardInput) == "boolean", "propagateKeyboardInput must be a boolean")
    
    local clone = Class:New(self)
    clone._propagateKeyboardInput = propagateKeyboardInput

    return clone
end

function Class:WithUseWowUIRootFrameAsParent(useWowUIRootFrameAsParent)
    Scopify(EScopes.Function, self)

    _assert(_type(useWowUIRootFrameAsParent) == "boolean", "useWowUIRootFrameAsParent must be a boolean")
    
    local clone = Class:New(self)
    clone._useWowUIRootFrameAsParent = useWowUIRootFrameAsParent

    return clone
end


function Class:WithNamedXmlFramesToInheritFrom(namedXmlFramesToInheritFrom)
    Scopify(EScopes.Function, self)

    _assert(namedXmlFramesToInheritFrom == nil or _type(namedXmlFramesToInheritFrom) == "string", "namedXmlFramesToInheritFrom must be nil or a comma-separated string")

    local clone = Class:New(self)
    clone._namedXmlFramesToInheritFrom = namedXmlFramesToInheritFrom

    return clone
end
