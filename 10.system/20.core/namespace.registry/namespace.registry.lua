local _g, _assert, _type, _getn, _gsub, _pairs, _rawget, _unpack, _format, _strsub, _strfind, _tostring, _setfenv, _debugstack, _getmetatable, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _rawget = _assert(_g.rawget)
    local _unpack = _assert(_g.unpack)
    local _format = _assert(_g.string.format)
    local _strsub = _assert(_g.string.sub)
    local _strfind = _assert(_g.string.find)
    local _tostring = _assert(_g.tostring)
    local _debugstack = _assert(_g.debugstack)
    local _getmetatable = _assert(_g.getmetatable)
    local _setmetatable = _assert(_g.setmetatable)
    
    return _g, _assert, _type, _getn, _gsub, _pairs, _rawget, _unpack, _format, _strsub, _strfind, _tostring, _setfenv, _debugstack, _getmetatable, _setmetatable
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(1, {})

local function _throw_exception(format, ...)
    local variadicArguments = arg

    for i = 1, _getn(variadicArguments) do
        variadicArguments[i] = _tostring(variadicArguments[i])
    end

    _assert(false, _format(format, _unpack(variadicArguments)) .. "\n\n---------------Stacktrace---------------" .. _debugstack(10) .. "\n---------------End Stacktrace---------------\n ")
end

local function _strmatch(input, patternString, ...)
    _ = patternString ~= nil or _throw_exception("patternString must not be nil")

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

local function _nilCoalesce(value, defaultFallbackValue)
    if value == nil then
        return defaultFallbackValue
    end

    return value
end

local EManagedSymbolTypes = {
    Enum = 0,
    
    Class = 1, --      for classes declared by this project
    Interface = 2,
    RawSymbol = 3, --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
}

_setmetatable(EManagedSymbolTypes, {
    __index = function(tableObject, key) -- we cant use getrawvalue here  we have to write the method ourselves
        local value = _rawget(tableObject, key)

        if value == nil then
            _throw_exception("EManagedSymbolTypes enum doesn't have a member named %q", key)
        end

        return value
    end
})

function EManagedSymbolTypes.IsMainstreamFlavour(value)
    return value == EManagedSymbolTypes.Class
            or value == EManagedSymbolTypes.Enum
            or value == EManagedSymbolTypes.Interface
end

function EManagedSymbolTypes.IsValid(value)
    if _type(value) ~= "number" then
        return false
    end

    return value >= EManagedSymbolTypes.Enum and value <= EManagedSymbolTypes.RawSymbol
end

local Entry = {}
do
    function Entry:New(symbolType, symbolProto, namespacePath, isForPartial)
        _setfenv(1, self)

        _ = symbolProto ~= nil                                       or  _throw_exception("symbolProto must not be nil") -- @formatter:off
        _ = _type(namespacePath) == "string"                         or  _throw_exception("namespacePath must be a string (got something of type '%s')", _type(namespacePath))
        _ = EManagedSymbolTypes.IsValid(symbolType)                  or  _throw_exception("symbolType must be a valid EManagedSymbolTypes member (got '%s')", symbolType)
        _ = isForPartial == nil or _type(isForPartial) == "boolean"  or  _throw_exception("isForPartial must be a boolean or nil (got '%s')", _type(isForPartial)) -- @formatter:on

        local instance = {
            _symbolType = symbolType,
            _symbolProto = symbolProto,
            _isForPartial = _nilCoalesce(isForPartial, false),
            _namespacePath = namespacePath,
        }

        _setmetatable(instance, self)
        self.__index = self

        return instance
    end
    
    function Entry:UnsetPartiality()
        _setfenv(1, self)

        _isForPartial = false        
    end
    
    function Entry:GetNamespace()
        _setfenv(1, self)

        _ = _type(_namespacePath) == "string" or _throw_exception("spotted unset namespace-path for a namespace-entry (how is this even possible?)")

        return _namespacePath
    end

    function Entry:GetSymbolProto()
        _setfenv(1, self)

        _ = _symbolProto ~= nil or _throw_exception("spotted unset symbol (nil) for a namespace-entry (how is this even possible?)")

        return _symbolProto
    end

    function Entry:GetManagedSymbolType()
        _setfenv(1, self)

        _ = _symbolType ~= nil or _throw_exception("spotted unset symbol-type (nil) for a namespace-entry (how is this even possible?)")

        return _symbolType
    end

    function Entry:IsPartialEntry()
        _setfenv(1, self)

        _ = _isForPartial ~= nil or _throw_exception("spotted unset is-for-partial (nil) for a namespace-entry (how is this even possible?)")

        return _isForPartial
    end

    function Entry:IsClassEntry()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.Class
    end

    function Entry:IsEnumEntry()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.Enum
    end

    function Entry:IsInterfaceEntry()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.Interface
    end

    function Entry:IsRawSymbol()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.RawSymbol
    end

    function Entry:ToString()
        _setfenv(1, self)

        return "symbolType='" .. _tostring(_symbolType) .. "', symbolProto='" .. _tostring(_symbolProto) .. "', namespacePath='" .. _tostring(_namespacePath) .. "', isForPartial='" .. _tostring(_isForPartial) .. "'"
    end
    Entry.__tostring = Entry.ToString
end

local NamespaceRegistry = {}
do
    function NamespaceRegistry:New()
        _setfenv(1, self)

        local instance = {
            _namespaces_registry = {},
            _reflection_registry = {},
        }

        _setmetatable(instance, self)
        self.__index = self

        return instance
    end
    
    NamespaceRegistry.Assert = {}
    NamespaceRegistry.Assert.NamespacePathIsHealthy = function(namespacePath)
        _ = _type(namespacePath) == "string" and _strtrim(namespacePath) ~= "" and namespacePath == _strtrim(namespacePath) or _throw_exception("namespacePath %q is invalid - it must be a non-empty string without prefixed/postfixed whitespaces", namespacePath)
    end
    NamespaceRegistry.Assert.SymbolTypeHasMainstreamFlavour = function(symbolType)
        _ = EManagedSymbolTypes.IsMainstreamFlavour(symbolType) or _throw_exception("symbolType must be a mainstream flavour (got %q)", symbolType)
    end

    NamespaceRegistry.Assert.EntryUpdateConcernsEntryWithTheSameSymbolType = function(incomingSymbolType, preExistingEntry, namespacePath)
        _ = incomingSymbolType == preExistingEntry:GetManagedSymbolType() or _throw_exception("cannot register namespace %q with type=%q as it has already been registered as symbol-type=%q", namespacePath, incomingSymbolType, preExistingEntry:GetManagedSymbolType()) -- 10
    end

    NamespaceRegistry.Assert.EitherTheIncomingUpdateIsForPartialOrThePreexistingEntryIsPartial = function(isForPartial, preExistingEntry, sanitizedNamespacePath)
        _ = isForPartial or preExistingEntry:IsPartialEntry() or _throw_exception("namespace %q has already been assigned to a symbol marked as %q (did you mean to register a 'partial' symbol?)", sanitizedNamespacePath, preExistingEntry:GetManagedSymbolType()) -- 10
    end

    -- namespacer()
    function NamespaceRegistry:UpsertSymbolProtoSpecs(namespacePath, symbolType)
        _setfenv(1, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)
        NamespaceRegistry.Assert.SymbolTypeHasMainstreamFlavour(symbolType)

        local sanitizedNamespacePath, isForPartial = NamespaceRegistry.SanitizeNamespacePath_(namespacePath)
        
        local preExistingEntry = _namespaces_registry[sanitizedNamespacePath]
        if preExistingEntry == nil then -- insert new entry
            local newSymbolProto = self.SpawnNewSymbol_(symbolType)

            local newEntry = Entry:New(symbolType, newSymbolProto, sanitizedNamespacePath, isForPartial)

            _reflection_registry[newSymbolProto] = newEntry
            _namespaces_registry[sanitizedNamespacePath] = newEntry

            return newSymbolProto
        end

        -- update existing entry
        NamespaceRegistry.Assert.EntryUpdateConcernsEntryWithTheSameSymbolType(symbolType, preExistingEntry, sanitizedNamespacePath) -- 10
        NamespaceRegistry.Assert.EitherTheIncomingUpdateIsForPartialOrThePreexistingEntryIsPartial(isForPartial, preExistingEntry, sanitizedNamespacePath) -- 10

        if not isForPartial then -- 20
            preExistingEntry:UnsetPartiality()
        end
        
        return preExistingEntry:GetSymbolProto()

        -- 10  notice that if the intention is to declare an extension-class then we dont care if the class already exists
        --     and its also perfectly fine if the the core class gets loaded after its associated extension classes too
        --
        -- 20  upon realizing that we are loading the core definition of a symbol-proto we need to unset the partiality flag on the proto-entry
    end

    NamespaceRegistry.PatternToDetectPartialKeywordPostfix = "%s*%[[Pp][Aa][Rr][Tt][Ii][Aa][Ll]%]%s*$"
    function NamespaceRegistry.SanitizeNamespacePath_(namespacePath)
        _setfenv(1, NamespaceRegistry)

        local sanitized = _gsub(namespacePath, NamespaceRegistry.PatternToDetectPartialKeywordPostfix, "") --00
        local isForPartial = sanitized ~= namespacePath
        
        -- sanitized = _strtrim(sanitized) noneed
        
        return sanitized, isForPartial
        
        -- 00  remove the [partial] postfix from the namespace string if it exists
    end

    NamespaceRegistry._StandardClassMetatable = { -- add a shortcut to the default constructor on the class
        __call = function(classProto, ...)
            local hasConstructorFunction = _type(classProto.New) == "function"
            local hasImplicitCallFunction = _type(classProto.__Call__) == "function"
            _ = hasConstructorFunction or hasImplicitCallFunction or _throw_exception("[__call()] Cannot call class() because the symbol lacks both methods :New() and :__Call__()")
            
            if hasImplicitCallFunction then --00
                return classProto:__Call__(_unpack(arg))
            end

            return classProto:New(_unpack(arg))
        end
        
        --00 if both :New(...) and :__Call__() are defined then :__Call__() takes precedence
    }
    function NamespaceRegistry.SpawnNewSymbol_(symbolType)
        _setfenv(1, NamespaceRegistry)
        
        if symbolType == EManagedSymbolTypes.Class then
            return _setmetatable({}, NamespaceRegistry._StandardClassMetatable)
        end

        return {} -- enums, interfaces
    end

    NamespaceRegistry.Assert.RawSymbolNamespaceIsAvailable = function(possiblePreexistingEntry, namespacePath)
        _ = possiblePreexistingEntry == nil or _throw_exception("namespace %q has already been assigned to another symbol", namespacePath)
    end
    
    NamespaceRegistry.Assert.ProtoForRawSymbolEntryMustNotBeNil = function(rawSymbolProto)
        _ = rawSymbolProto ~= nil or _throw_exception("rawSymbolProto must not be nil")
    end

    -- used for binding external libs to a local namespace
    --
    --     _namespacer_bind("Foo.Bar", function(x, y) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
    --
    function NamespaceRegistry:Bind(namespacePath, rawSymbolProto)
        _setfenv(1, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)
        NamespaceRegistry.Assert.ProtoForRawSymbolEntryMustNotBeNil(rawSymbolProto)

        local possiblePreexistingEntry = _namespaces_registry[namespacePath]

        NamespaceRegistry.Assert.RawSymbolNamespaceIsAvailable(possiblePreexistingEntry, namespacePath)

        local newEntry = Entry:New(EManagedSymbolTypes.RawSymbol, rawSymbolProto, namespacePath)

        _namespaces_registry[namespacePath] = newEntry
        _reflection_registry[rawSymbolProto] = newEntry
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaNamespace(namespacePath)
        _setfenv(1, self)
        
        -- we intentionally omit validating the namespacepath in terms of whitespaces etc
        -- thats because this method is meant to be used by the reflection.* family of methods
        
        if namespacePath == nil then -- we dont want to error out in this case   this is a try-method
            return nil, nil
        end

        local entry = _namespaces_registry[namespacePath]
        if entry == nil then
            return nil, nil
        end
        
        return entry:GetSymbolProto(), entry:GetManagedSymbolType()
    end
    
    -- importer()
    function NamespaceRegistry:Get(namespacePath, suppressExceptionIfNotFound)
        _setfenv(1, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)

        local entry = _namespaces_registry[namespacePath]
        if entry == nil then
            if suppressExceptionIfNotFound then
                return nil
            end

            _throw_exception("namespace %q has not been registered.", namespacePath) -- dont turn this into an debug.assertion   we want to know about this in production builds too
        end
        
        if entry:IsPartialEntry() then
            -- dont turn this into an debug.assertion   we want to know about this in production builds too
            _throw_exception("namespace %q holds a partially-registered entry (class/enum/interface) - did you forget to load its core definition?", namespacePath)
        end
        
        return entry:GetSymbolProto()
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaSymbolProto(symbolProto)
        _setfenv(1, self)

        if symbolProto == nil then
            return nil
        end

        return _reflection_registry[symbolProto]
    end
    
    function NamespaceRegistry:PrintOut()
        _setfenv(1, self)

        _g.print("** namespaces-registry **")
        for namespace, entry in _pairs(self._namespaces_registry) do
            _g.print("**** namespace='" .. _tostring(namespace) .. "' ->  " .. entry:ToString())
        end

        _g.print("** reflection-registry **")
        for symbolProto, entry in _pairs(self._reflection_registry) do
            _g.print("**** symbolProto='" .. _tostring(symbolProto) .. "' ->  " .. entry:ToString())
        end

        _g.print("\n\n")         
    end
end

local NamespaceRegistrySingleton = NamespaceRegistry:New()
do
    -- using "x.y.z"
    _g.pvl_namespacer_get = function(namespacePath)
        --    todo   in production builds these symbols should get obfuscated to something like  _g.ppzcn__<some_guid_here>__get
        return NamespaceRegistrySingleton:Get(namespacePath)
    end

    -- todo   remove these functions below once we migrate our codebase over to the using() scheme

    -- using "[declare]" "x.y.z"
    _g.pvl_namespacer_add = function(namespacePath)
        return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Class)
    end

    -- namespacer_binder()
    _g.pvl_namespacer_bind = function(namespacePath, symbol)
        return NamespaceRegistrySingleton:Bind(namespacePath, symbol)
    end
end

NamespaceRegistrySingleton:Bind("System.Namespacer", NamespaceRegistrySingleton)

-- @formatter:off   todo   also introduce [declare partial] [declare partial:enum] [declare:testbed] etc and remove the [partial] postfix-technique on the namespace path since it will no longer be needed 
NamespaceRegistrySingleton:Bind("[declare]",             function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Class    ) end)
NamespaceRegistrySingleton:Bind("[declare:enum]",        function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Enum     ) end)
NamespaceRegistrySingleton:Bind("[declare:class]",       function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Class    ) end)
NamespaceRegistrySingleton:Bind("[declare:interface]",   function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Interface) end)
-- @formatter:on

local AdvertisedEManagedSymbolTypes = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs("System.Namespacer.EManagedSymbolTypes", EManagedSymbolTypes.Enum)
for k, v in _pairs(EManagedSymbolTypes) do -- this is the only way to get the enum values to be advertised to the outside world
    AdvertisedEManagedSymbolTypes[k] = v
end

_setmetatable(AdvertisedEManagedSymbolTypes, _getmetatable(EManagedSymbolTypes)) -- this is important too
