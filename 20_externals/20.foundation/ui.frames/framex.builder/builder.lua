--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local WoWUIParent = using "Pavilion.Warcraft.Foundation.Natives.UI.UIParent"
local WoWCreateFrame = using "Pavilion.Warcraft.Foundation.Natives.UI.CreateFrame"

local FrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.FrameX"
local SWoWElementType = using "Pavilion.Warcraft.Foundation.UI.Frames.Contracts.Strenums.SWoWElementType" 

local FramexBuilder = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameXBuilder.Builder" -- @formatter:on

Fields(function(upcomingInstance)
    upcomingInstance._elementType = SWoWElementType.Frame
    return upcomingInstance
end)

function FramexBuilder:NewClone(otherBuilder) -- needed for the builder fluent-api in the methods below
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(otherBuilder, FramexBuilder, "otherBuilder")

    local instance = self:Instantiate()
    
    instance._name = otherBuilder._name
    instance._elementType = otherBuilder._elementType
    instance._frameStrata = otherBuilder._frameStrata
    instance._desiredParentElement = otherBuilder._desiredParentElement
    instance._propagateKeyboardInput = otherBuilder._propagateKeyboardInput
    instance._keystrokeListenerEnabled = otherBuilder._keystrokeListenerEnabled
    instance._useWowUIRootFrameAsParent = otherBuilder._useWowUIRootFrameAsParent
    instance._namedXmlFramesToInheritFrom = otherBuilder._namedXmlFramesToInheritFrom
    
    return instance
end

function FramexBuilder:Build()
    Scopify(EScopes.Function, self)

    local eventualParentElement = _useWowUIRootFrameAsParent
            and WoWUIParent
            or _desiredParentElement

    local newNativeFrame = WoWCreateFrame(
            _elementType,
            _name, -- if the name is set to something then wowapi will autocreate a global variable _g[_name] = frame  ouch
            eventualParentElement,
            _namedXmlFramesToInheritFrom
    )

    local framex = FrameX:New(newNativeFrame)

    if _frameStrata ~= nil then
        framex:ChainSet_FrameStrata(_frameStrata)
    end

    if _propagateKeyboardInput ~= nil then
        framex:ChainSet_PropagateKeyboardInput(_propagateKeyboardInput)
    end

    if _keystrokeListenerEnabled ~= nil then
        framex:ChainSet_KeystrokeListenerEnabled(_keystrokeListenerEnabled)
    end

    return framex
end

function FramexBuilder:WithTypeSetToFrame()
    Scopify(EScopes.Function, self)

    return self:WithType(SWoWElementType.Frame)
end

function FramexBuilder:WithFrameType(frameType)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsEnumValue(SWoWElementType, frameType, "frameType")
    
    local clone = FramexBuilder:CloneClone(self)
    clone._elementType = frameType

    return clone
end

function FramexBuilder:WithFrameStrata(value)
    Scopify(EScopes.Function, self)

    _assert(_type(value) == "string", "frame-strata must be a string")
    
    Guard.Assert.IsString(value, "value")

    local clone = FramexBuilder:NewClone(self)
    clone._frameStrata = value

    return clone
end

function FramexBuilder:WithKeystrokeListenerEnabled(onOrOff)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsBoolean(onOrOff, "onOrOff")

    local clone = FramexBuilder:NewClone(self)
    clone._keystrokeListenerEnabled = onOrOff

    return clone
end

function FramexBuilder:WithName(name)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrString(name, "name")
    
    local clone = FramexBuilder:NewClone(self)
    clone._name = name

    return clone
end

function FramexBuilder:WithParentElement(parentElement)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(parentElement, "parentElement")
    
    local clone = FramexBuilder:NewClone(self)
    clone._desiredParentElement = parentElement

    return clone
end

function FramexBuilder:WithPropagateKeyboardInput(propagateKeyboardInput)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(propagateKeyboardInput, "propagateKeyboardInput")
    
    local clone = FramexBuilder:NewClone(self)
    clone._propagateKeyboardInput = propagateKeyboardInput

    return clone
end

function FramexBuilder:WithUseWowUIRootFrameAsParent(useWowUIRootFrameAsParent)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(useWowUIRootFrameAsParent, "useWowUIRootFrameAsParent")
    
    local clone = FramexBuilder:NewClone(self)
    clone._useWowUIRootFrameAsParent = useWowUIRootFrameAsParent

    return clone
end

function FramexBuilder:WithNamedXmlFramesToInheritFrom(namedXmlFramesToInheritFrom)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(namedXmlFramesToInheritFrom, "namedXmlFramesToInheritFrom")

    local clone = FramexBuilder:NewClone(self)
    clone._namedXmlFramesToInheritFrom = namedXmlFramesToInheritFrom

    return clone
end
