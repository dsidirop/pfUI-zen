local _assert, _setfenv, _type, _getn, _, _, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
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

-- local KeyEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.KeyEventArgs")

local WoWUIParent = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.UIParent")
local WoWCreateFrame = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame")

local ManagedElement = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element")
local SWoWElementType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.SWoWElementType") 

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Builder")

function Class:New(other)
    _setfenv(1, self)
    
    _assert(other == nil or _type(other) == "table", "other must be nil or a table")

    other = other or {}

    local instance = {
        _type = other._type,
        _name = other._name,
        _parentElement = other._parentElement,
        _propagateKeyboardInput = other._propagateKeyboardInput,
        _useGlobalWowFrameAsParent = other._useGlobalWowFrameAsParent,
        _namedXmlFramesToInheritFrom = other._namedXmlFramesToInheritFrom,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Build()
    _setfenv(1, self)

    _assert(SWoWElementType.Validate(_elementType), "element type should be one of SWoWElementType")
    _assert(_name == nil or _type(_name) == "boolean", "name must be nil or a string")
    _assert(_type(_propagateKeyboardInput) == "boolean", "propagateKeyboardInput must be a boolean")
    _assert(_type(_useGlobalWowFrameAsParent) == "boolean", "useGlobalWowFrameAsParent must be a boolean")
    _assert(_parentElement == nil or _type(_parentElement) == "table", "parentElement must be nil or a table")
    _assert(_namedXmlFramesToInheritFrom == nil or _type(_namedXmlFramesToInheritFrom) == "string", "namedXmlFramesToInheritFrom must be nil or a comma-separated string")

    _elementType = _elementType or SWoWElementType.Frame

    _parentElement = _useGlobalWowFrameAsParent
            and WoWUIParent
            or _parentElement

    local newElement = WoWCreateFrame(
            SWoWElementType.Frame,
            _name, -- if the name is set to something then wowapi will autocreate a global variable _g[_name] = frame  ouch
            _parentElement,
            _namedXmlFramesToInheritFrom
    )

    _assert(_type(newElement) == "table", "failed to create new element")

    return ManagedElement:New()
                         :ChainSetPropagateKeyboardInput(_propagateKeyboardInput)
end

function Class:WithTypeFrame()
    _setfenv(1, self)

    return self:WithType(SWoWElementType.Frame)
end

function Class:WithType(frameType)
    _setfenv(1, self)

    _assert(SWoWElementType.Validate(frameType), "frameType should be SWoWElementType")
    
    local clone = Class:New(self)
    clone._type = frameType

    return clone
end

function Class:WithName(name)
    _setfenv(1, self)

    _assert(name == nil or _type(name) == "string", "name must nil or a string")
    
    local clone = Class:New(self)
    clone._name = name

    return clone
end

function Class:WithParentElement(parentElement)
    _setfenv(1, self)

    _assert(parentElement == nil or _type(parentElement) == "table", "parentElement must be nil or a table")
    
    local clone = Class:New(self)
    clone._parentElement = parentElement

    return clone
end

function Class:WithPropagateKeyboardInput(propagateKeyboardInput)
    _setfenv(1, self)

    _assert(_type(propagateKeyboardInput) == "boolean", "propagateKeyboardInput must be a boolean")
    
    local clone = Class:New(self)
    clone._propagateKeyboardInput = propagateKeyboardInput

    return clone
end

function Class:WithUseGlobalWowFrameAsParent(useGlobalWowFrameAsParent)
    _setfenv(1, self)

    _assert(_type(useGlobalWowFrameAsParent) == "boolean", "useGlobalWowFrameAsParent must be a boolean")
    
    local clone = Class:New(self)
    clone._useGlobalWowFrameAsParent = useGlobalWowFrameAsParent

    return clone
end


function Class:WithNamedXmlFramesToInheritFrom(namedXmlFramesToInheritFrom)
    _setfenv(1, self)

    _assert(namedXmlFramesToInheritFrom == nil or _type(namedXmlFramesToInheritFrom) == "string", "namedXmlFramesToInheritFrom must be nil or a comma-separated string")

    local clone = Class:New(self)
    clone._namedXmlFramesToInheritFrom = namedXmlFramesToInheritFrom

    return clone
end
