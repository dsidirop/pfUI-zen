--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})
local Guard = using "System.Guard"

local WoWUIParent = using "Pavilion.Warcraft.Foundation.Natives.UI.UIParent"
local WoWCreateFrame = using "Pavilion.Warcraft.Foundation.Natives.UI.CreateFrame"

local ManagedElement = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element"
local SWoWElementType = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWElementType" 

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Builder" -- @formatter:on


function Class:New(other)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrTable(other, "other")

    other = other or {}
    
    local instance = self:Instantiate()
    
    instance._elementType = other._elementType or SWoWElementType.Frame

    instance._name = other._name
    instance._frameStrata = other._frameStrata
    instance._desiredParentElement = other._desiredParentElement
    instance._propagateKeyboardInput = other._propagateKeyboardInput
    instance._keystrokeListenerEnabled = other._keystrokeListenerEnabled
    instance._useWowUIRootFrameAsParent = other._useWowUIRootFrameAsParent
    instance._namedXmlFramesToInheritFrom = other._namedXmlFramesToInheritFrom
    
    return instance
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
    
    Guard.Assert.IsEnumValue(SWoWElementType, frameType, "frameType")
    
    local clone = Class:New(self)
    clone._elementType = frameType

    return clone
end

function Class:WithFrameStrata(value)
    Scopify(EScopes.Function, self)

    _assert(_type(value) == "string", "frame-strata must be a string")
    
    Guard.Assert.IsString(value, "value")

    local clone = Class:New(self)
    clone._frameStrata = value

    return clone
end

function Class:WithKeystrokeListenerEnabled(onOrOff)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsBoolean(onOrOff, "onOrOff")

    local clone = Class:New(self)
    clone._keystrokeListenerEnabled = onOrOff

    return clone
end

function Class:WithName(name)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(name, "name")
    
    local clone = Class:New(self)
    clone._name = name

    return clone
end

function Class:WithParentElement(parentElement)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(parentElement, "parentElement")
    
    local clone = Class:New(self)
    clone._desiredParentElement = parentElement

    return clone
end

function Class:WithPropagateKeyboardInput(propagateKeyboardInput)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(propagateKeyboardInput, "propagateKeyboardInput")
    
    local clone = Class:New(self)
    clone._propagateKeyboardInput = propagateKeyboardInput

    return clone
end

function Class:WithUseWowUIRootFrameAsParent(useWowUIRootFrameAsParent)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(useWowUIRootFrameAsParent, "useWowUIRootFrameAsParent")
    
    local clone = Class:New(self)
    clone._useWowUIRootFrameAsParent = useWowUIRootFrameAsParent

    return clone
end

function Class:WithNamedXmlFramesToInheritFrom(namedXmlFramesToInheritFrom)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(namedXmlFramesToInheritFrom, "namedXmlFramesToInheritFrom")

    local clone = Class:New(self)
    clone._namedXmlFramesToInheritFrom = namedXmlFramesToInheritFrom

    return clone
end
