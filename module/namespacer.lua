local _g, _assert, _type, _error, _strtrim, _gsub, _match, _setfenv, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)
    local _strtrim = _assert(_g.strtrim)

    local _gsub = _assert(_g.string.gsub)
    local _match = _assert(_g.string.match)
    local _setmetatable = _assert(_g.setmetatable)

    return _g, _assert, _type, _error, _strtrim, _gsub, _match, _setfenv, _setmetatable
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(1, {})

local Class = {}

function Class:New()
    _setfenv(1, {})

    local instance = {
        _namespace_registry = {}
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

local EIntention = {
    ForClass = "class", --                     for classes declared by this project
    ForClassPartial = "class-partial", --      for designer partial files   we must ensure that those are always loaded after their respective core classes
    ForExternalSymbol = "external-symbol", --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
}

local function _is_partial_class_entry(entry)
    return entry and entry.intention == EIntention.ForClassPartial
end

-- meant to be used namespacer()
local PatternToDetectPartialKeywordPostfix = "%s*%[[Pp]artial%]%s*$"
function Class:Add(namespace_path)
    _setfenv(1, self)

    _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

    namespace_path = _strtrim(namespace_path)

    local intention = _match(namespace_path, PatternToDetectPartialKeywordPostfix)
            and EIntention.ForClassPartial
            or EIntention.ForClass
    if intention == EIntention.ForClassPartial then
        namespace_path = _gsub(namespace_path, PatternToDetectPartialKeywordPostfix, "") -- remove the [partial] postfix from the namespace path
    end

    local entry = _namespace_registry[namespace_path]
    if entry == nil then
        entry = {
            value = {},
            intention = intention,
        }
        _namespace_registry[namespace_path] = entry
    end

    if intention == EIntention.ForClass then
        if _is_partial_class_entry(entry) then
            _error("class in namespace '" .. namespace_path .. "' has already been loaded - make sure you are not trying to load the same class twice.")
        end

        entry.intention = EIntention.ForClass
    end

    return _assert(entry.value)

    --00  notice that if the intention is to declare an extension-class then we dont care if the class already
    --    exists its also perfectly fine if the the core class gets loaded after its associated extension classes too
end

-- used for binding external libs to a local namespace
--
--     _namespacer("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
--     _namespacer("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
--
function Class:Bind(namespace_path, symbol)
    _setfenv(1, self)

    _assert(symbol ~= nil, "symbol must not be nil")
    _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

    namespace_path = _strtrim(namespace_path)

    local possiblePreexistingEntry = _namespace_registry[namespace_path]
    if possiblePreexistingEntry ~= nil then
        _error("namespace '" .. namespace_path .. "' has already been assigned to another symbol.")
    end

    _namespace_registry[namespace_path] = {
        value = symbol,
        intention = EIntention.ForExternalSymbol,
    }
end

-- meant to be used namespacer()
function Class:Get(namespace_path)
    _setfenv(1, self)

    local entry = _assert(_namespace_registry[namespace_path])

    -- _assert(_is_activated_class_entry(entry)) -- dont   its perfectly ok if the user tries to get hold of a purely partial class entry

    return _assert(entry.value)
end



-- local singleton and simplified methods --
local Singleton = Class:New() -- place the singleton instance into the global namespace

-- namespacer()   todo   in production builds these symbols should get obfuscated to something like  _g.ppzcn__some_guid_here__add
_g.pvl_namespacer_add = function(namespace_path)
    return Singleton:Add(namespace_path)
end

-- namespacer_binder()
_g.pvl_namespacer_bind = function(namespace_path, symbol)
    return Singleton:Bind(namespace_path, symbol)
end

-- importer()
_g.pvl_namespacer_get = function(namespace_path)
    return Singleton:Get(namespace_path)
end
