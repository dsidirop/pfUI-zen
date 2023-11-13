﻿local _g = assert(_G or getfenv(0))

if _g.pavilion_pfui_zen_class_namespacer__add then
    return -- already in place
end

local _assert = assert

local _type = _assert(_g.type)
local _math = _assert(_g.math)
local _error = _assert(_g.error)
local _strtrim = _assert(_g.strtrim)

local _gsub = _assert(_g.string.gsub)
local _match = _assert(_g.string.match)
local _setfenv = _assert(_g.setfenv)

_setfenv(1, {})

local EIntention = {
    ForMainClass = "class",
    ForClassExtension = "class-extension", -- for designer partial files   we must ensure that those are always loaded after their respective core classes
}

local _namespace_registry = {}
local _own_class_tellsign_property_ = "__" .. _math.random() .. "__"
local _pattern_to_detect_partial_keyword_postfix = "%s*%[[Pp]artial%]%s*$"

-- todo   in production builds this function should get obfuscated to something like  _g.ppzcn__some_guid_here__add
-- todo   to minimize the risk of conflicts with other addons that might have copy pasted the code from here

-- use this as namespacer()
function _g.pavilion_pfui_zen_class_namespacer__add(namespace_path)
    _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

    namespace_path = _strtrim(namespace_path)

    local intention = _match(namespace_path, _pattern_to_detect_partial_keyword_postfix) and EIntention.ForClassExtension or EIntention.ForMainClass
    if intention == EIntention.ForClassExtension then
        namespace_path = _gsub(namespace_path, _pattern_to_detect_partial_keyword_postfix, "")
    end

    local entry = _namespace_registry[namespace_path]
    if entry == nil then
        entry = {}
        _namespace_registry[namespace_path] = entry
    end

    if intention == EIntention.ForMainClass then
        if _is_activated_class_entry(entry) then
            _error("class in namespace '" .. namespace_path .. "' has already been loaded - make sure you are not trying to load the same class twice.")
        end

        entry[_own_class_tellsign_property_] = true -- to mark this main class as loaded
    end

    return _assert(entry)

    --00  notice that if the intention is to declare an extension-class then we dont care if the class already
    --    exists its also perfectly fine if the the core class gets loaded after its associated extension classes too
end

-- used for binding external libs to a local namespace
--
--     _namespacer("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
--     _namespacer("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
--
function _g.pavilion_pfui_zen_class_namespacer__bind(namespace_path, symbol)
    _assert(symbol ~= nil, "symbol must not be nil")
    _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

    namespace_path = _strtrim(namespace_path)

    local possiblePreexistingEntry = _namespace_registry[namespace_path]
    if possiblePreexistingEntry ~= nil then
        _error("namespace '" .. namespace_path .. "' has already been assigned to another symbol.")
    end

    _namespace_registry[namespace_path] = symbol
end

-- todo   in production builds this function should get obfuscated to something like  _g.ppzcn__some_guid_here__get
-- todo   to minimize the risk of conflicts with other addons that might have copy pasted the code from here

-- use this as importer()
function _g.pavilion_pfui_zen_class_namespacer__get(namespace_path)
    local entry = _assert(_namespace_registry[namespace_path])

    -- _assert(_is_activated_class_entry(entry)) -- dont   its perfectly ok if the user tries to get hold of a purely partial class entry

    return entry
end

function _is_activated_class_entry(entry)
    return entry and entry[_own_class_tellsign_property_] == true
end