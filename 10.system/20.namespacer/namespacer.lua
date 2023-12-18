local _g, _assert, _type, _, _gsub, _print, _unpack, _strsub, _strfind, _tostring, _setfenv, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)

    local _gsub = _assert(_g.string.gsub)
    local _print = _assert(_g.print)
    local _unpack = _assert(_g.unpack)
    local _strsub = _assert(_g.string.sub)
    local _strfind = _assert(_g.string.find)
    local _tostring = _assert(_g.tostring)
    local _setmetatable = _assert(_g.setmetatable)

    return _g, _assert, _type, _error, _gsub, _print, _unpack, _strsub, _strfind, _tostring, _setfenv, _setmetatable
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(1, {})

local EIntention = {
    ForClass = "class", --                     for classes declared by this project
    ForClassPartial = "class-partial", --      for designer partial files   we must ensure that those are always loaded after their respective core classes
    ForExternalSymbol = "external-symbol", --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
}

local function _strmatch(input, patternString, ...)
    _assert(patternString ~= nil)

    if patternString == "" then
        -- todo  test out these corner cases
        return nil
    end

    local startIndex, endIndex,
    match01,
    match02,
    match03,
    match04,
    match05,
    match06,
    match07,
    match08,
    match09,
    match10,
    match11,
    match12,
    match13,
    match14,
    match15,
    match16,
    match17,
    match18,
    match19,
    match20,
    match21,
    match22,
    match23,
    match24,
    match25 = _strfind(input, patternString, _unpack(arg))

    if startIndex == nil then
        -- no match
        return nil
    end

    if match01 == nil then
        -- matched but without using captures   ("Foo 11 bar   ping pong"):match("Foo %d+ bar")
        return _strsub(input, startIndex, endIndex)
    end

    return -- matched with captures  ("Foo 11 bar   ping pong"):match("Foo (%d+) bar")
    match01,
    match02,
    match03,
    match04,
    match05,
    match06,
    match07,
    match08,
    match09,
    match10,
    match11,
    match12,
    match13,
    match14,
    match15,
    match16,
    match17,
    match18,
    match19,
    match20,
    match21,
    match22,
    match23,
    match24,
    match25
end

local function _strtrim(input)
    return _strmatch(input, '^%s*(.*%S)') or ''
end

local Entry = {}
do
    function Entry:New(intention, symbol)
        _setfenv(1, self)

        _assert(symbol ~= nil, "symbol must not be nil")
        _assert(intention == EIntention.ForClass or intention == EIntention.ForClassPartial or intention == EIntention.ForExternalSymbol, "intention must be valid")

        local instance = {
            _symbol = symbol,
            _intention = intention,
        }

        _setmetatable(instance, self)
        self.__index = self

        return instance
    end

    function Entry:GetSymbol()
        _setfenv(1, self)

        return _assert(_symbol)
    end

    function Entry:GetIntention()
        _setfenv(1, self)

        return _assert(_intention)
    end

    function Entry:IsClassEntry()
        _setfenv(1, self)

        return _intention == EIntention.ForClass
    end
    
    function Entry:IsPartialClassEntry()
        _setfenv(1, self)

        return _intention == EIntention.ForClassPartial
    end

    function Entry:IsEitherFlavorOfClass()
        _setfenv(1, self)

        return self:IsClassEntry() or self:IsPartialClassEntry()
    end

    function Entry:UpgradeIntentionFromPartialToClass()
        _setfenv(1, self)
        
        _assert(_intention == EIntention.ForClassPartial, "the current entry was supposed to be a partial class but it was '".._intention.."' instead")

        _intention = EIntention.ForClass
        return true
    end
end

local Namespacer = {}
do
    function Namespacer:New()
        _setfenv(1, self)

        local instance = {
            _namespace_registry = {}
        }

        _setmetatable(instance, self)
        self.__index = self

        return instance
    end

    -- namespacer()
    local PatternToDetectPartialKeywordPostfix = "%s*%[[Pp]artial%]%s*$"
    function Namespacer:Add(namespace_path)
        _setfenv(1, self)

        _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud\n" .. _g.debugstack() .. "\n")

        namespace_path = _strtrim(namespace_path)

        local intention = _strmatch(namespace_path, PatternToDetectPartialKeywordPostfix)
                and EIntention.ForClassPartial
                or EIntention.ForClass
        
        if namespace_path == "Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm [Partial]" then
            _print("** intention partial? => " .. _tostring(intention == EIntention.ForClassPartial))
        end
        
        if intention == EIntention.ForClassPartial then
            namespace_path = _gsub(namespace_path, PatternToDetectPartialKeywordPostfix, "") -- remove the [partial] postfix from the namespace path
        end

        local preExistingEntry = _namespace_registry[namespace_path]
        if preExistingEntry == nil then
            local newEntry = Entry:New(intention, {})

            _namespace_registry[namespace_path] = newEntry

            return newEntry:GetSymbol()
        end
        
        if intention == EIntention.ForClass then
            _assert(preExistingEntry:IsPartialClassEntry(), "namespace '" .. namespace_path .. "' has already been assigned to a symbol with intention '" .. preExistingEntry:GetIntention() .. "' and cannot be associated with another class (are you trying to register the same symbol twice?)\n" .. _g.debugstack() .. "\n")

            preExistingEntry:UpgradeIntentionFromPartialToClass()
            
            return preExistingEntry:GetSymbol()
        end

        if intention == EIntention.ForClassPartial then
            _assert(preExistingEntry:IsEitherFlavorOfClass(), "namespace '" .. namespace_path .. "' has already been assigned to a symbol with non-class intention '" .. preExistingEntry:GetIntention() .. "' and cannot be associated with a partial class.\n" .. _g.debugstack() .. "\n")
            
            return preExistingEntry:GetSymbol()
        end
        
        _assert(false, "how did we get here?\n" .. _g.debugstack() .. "\n")

        --00  notice that if the intention is to declare an extension-class then we dont care if the class already
        --    exists its also perfectly fine if the the core class gets loaded after its associated extension classes too
    end

    -- used for binding external libs to a local namespace
    --
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
    --
    function Namespacer:Bind(namespace_path, symbol)
        _setfenv(1, self)

        _assert(symbol ~= nil, "symbol must not be nil")
        _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

        namespace_path = _strtrim(namespace_path)

        local possiblePreexistingEntry = _namespace_registry[namespace_path]
        
        _assert(possiblePreexistingEntry == nil, "namespace '" .. namespace_path .. "' has already been assigned to another symbol.")

        _namespace_registry[namespace_path] = Entry:New(EIntention.ForExternalSymbol, symbol)
    end

    -- importer()
    function Namespacer:Get(namespace_path)
        _setfenv(1, self)

        _assert(namespace_path ~= nil and _type(namespace_path) == "string" and _strtrim(namespace_path) ~= "", "namespace_path must not be dud")

        namespace_path = _strtrim(namespace_path)

        local entry = _namespace_registry[namespace_path]

        _assert(entry, "namespace '" .. namespace_path .. "' has not been registered.\n" .. _g.debugstack() .. "\n")
        _assert(not entry:IsPartialClassEntry(), "namespace '" .. namespace_path .. "' holds a partially-registered class - did you forget to load the main class definition?\n" .. _g.debugstack() .. "\n")

        return _assert(entry:GetSymbol())
    end
end

local Singleton = Namespacer:New()
do  
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
end 