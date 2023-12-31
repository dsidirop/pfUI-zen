local _g, _assert, _type, _gsub, _pairs, _rawget, _unpack, _strsub, _strfind, _tostring, _setfenv, _debugstack, _getmetatable, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _rawget = _assert(_g.rawget)
    local _unpack = _assert(_g.unpack)
    local _strsub = _assert(_g.string.sub)
    local _strfind = _assert(_g.string.find)
    local _tostring = _assert(_g.tostring)
    local _debugstack = _assert(_g.debugstack)
    local _getmetatable = _assert(_g.getmetatable)
    local _setmetatable = _assert(_g.setmetatable)
    
    return _g, _assert, _type, _gsub, _pairs, _rawget, _unpack, _strsub, _strfind, _tostring, _setfenv, _debugstack, _getmetatable, _setmetatable
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(1, {})

local EManagedSymbolTypes = {
    Enum = 0,
    
    Class = 1, --      for classes declared by this project
    Interface = 2,
    RawSymbol = 3, --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
}

_setmetatable(EManagedSymbolTypes, {
    __index = function(tableObject, key) -- we cant use getrawvalue here  we have to write the method ourselves
        local value = _rawget(tableObject, key)

        _assert(value ~= nil, "EManagedSymbolTypes enum doesn't have a member named '" .. key .. "'\n" .. _debugstack(2) .. "\n")

        return value
    end
})

function EManagedSymbolTypes.IsValid(value)
    if _type(value) ~= "number" then
        return false
    end

    return value >= EManagedSymbolTypes.Enum and value <= EManagedSymbolTypes.RawSymbol
end

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

local function _nilCoallesce(value, defaultFallbackValue)
    if value == nil then
        return defaultFallbackValue
    end

    return value
end

local Entry = {}
do
    function Entry:New(symbolType, symbolProto, namespacePath, isForPartial)
        _setfenv(1, self)

        _assert(symbolProto ~= nil, "symbolProto must not be nil\n" .. _debugstack(2) .. "\n")
        _assert(isForPartial == nil or _type(isForPartial) == "boolean", "isForPartial must be a boolean or nil (got '" .. _type(isForPartial) .. "')\n" .. _debugstack(2) .. "\n")
        _assert(symbolType == EManagedSymbolTypes.Class or symbolType == EManagedSymbolTypes.Enum or symbolType == EManagedSymbolTypes.Interface or symbolType == EManagedSymbolTypes.RawSymbol, "symbolType must be valid\n" .. _debugstack(2) .. "\n")
        _assert(_type(namespacePath) == "string", "namespacePath must be a string\n" .. _debugstack(2) .. "\n")

        local instance = {
            _symbolType = symbolType,
            _symbolProto = symbolProto,
            _isForPartial = _nilCoallesce(isForPartial, false),
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

        _assert(_type(_namespacePath) == "string", "spotted unset namespace-path for a namespace-entry (how is this even possible?)\n" .. _debugstack(2) .. "\n")

        return _namespacePath
    end

    function Entry:GetSymbolProto()
        _setfenv(1, self)

        _assert(_symbolProto ~= nil, "spotted unset symbol (nil) for a namespace-entry (how is this even possible?)\n" .. _debugstack(2) .. "\n")

        return _symbolProto
    end

    function Entry:GetManagedSymbolType()
        _setfenv(1, self)

        _assert(_symbolType ~= nil, "spotted unset symbol-type (nil) for a namespace-entry (how is this even possible?)\n" .. _debugstack(2) .. "\n")

        return _symbolType
    end

    function Entry:IsPartialEntry()
        _setfenv(1, self)

        _assert(_isForPartial ~= nil, "spotted unset is-for-partial (nil) for a namespace-entry (how is this even possible?)\n" .. _debugstack(2) .. "\n")

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

    -- namespacer()
    function NamespaceRegistry:UpsertSymbolProtoSpecs(namespacePath, symbolType)
        _setfenv(1, self)

        _assert(_type(namespacePath) == "string", "namespacePath must be a string\n" .. _debugstack(3) .. "\n")
        _assert(symbolType == EManagedSymbolTypes.Class or symbolType == EManagedSymbolTypes.Enum or symbolType == EManagedSymbolTypes.Interface, "symbolType for namespace '" .. namespacePath .. "' must be either ESymbolType.Class or ESymbolType.Enum or ESymbolType.Interface (got '" .. _tostring(symbolType) .. "')\n" .. _debugstack(3) .. "\n")
        
        namespacePath = _strtrim(namespacePath)        
        _assert(namespacePath ~= "", "namespacePath must not be dud\n" .. _debugstack(3) .. "\n")

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
        _assert(symbolType == preExistingEntry:GetManagedSymbolType(), "cannot register namespace '" .. sanitizedNamespacePath .. "' with type='" .. symbolType .. "' as it has already been assigned to a symbol with type='" .. preExistingEntry:GetManagedSymbolType() .. "'.\n" .. _debugstack() .. "\n") -- 10
        _assert(isForPartial or preExistingEntry:IsPartialEntry(), "namespace '" .. sanitizedNamespacePath .. "' has already been assigned to a symbol marked as '" .. preExistingEntry:GetManagedSymbolType() .. "' (did you mean to use a partial class?).\n" .. _debugstack() .. "\n") -- 10

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
            _assert(hasConstructorFunction or hasImplicitCallFunction, "Cannot call class() because the symbol lacks both methods :New() and :__Call__()\n" .. _debugstack() .. "\n")
            
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

    -- used for binding external libs to a local namespace
    --
    --     _namespacer_bind("Foo.Bar", function(x, y) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
    --
    function NamespaceRegistry:Bind(namespacePath, rawSymbolProto)
        _setfenv(1, self)

        _assert(rawSymbolProto ~= nil, "rawSymbol must not be nil\n" .. _debugstack(3) .. "\n")
        _assert(namespacePath ~= nil and _type(namespacePath) == "string" and _strtrim(namespacePath) ~= "", "namespacePath must not be dud\n" .. _debugstack(3) .. "\n")

        namespacePath = _strtrim(namespacePath)

        local possiblePreexistingEntry = _namespaces_registry[namespacePath]

        _assert(possiblePreexistingEntry == nil, "namespace '" .. namespacePath .. "' has already been assigned to another symbol.\n" .. _debugstack(3) .. "\n")
        
        local newEntry = Entry:New(EManagedSymbolTypes.RawSymbol, rawSymbolProto, namespacePath)

        _namespaces_registry[namespacePath] = newEntry
        _reflection_registry[rawSymbolProto] = newEntry
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaNamespace(namespacePath)
        _setfenv(1, self)
        
        if namespacePath == nil then -- we dont want to error out in this case   this is a try-method
            return nil, nil
        end

        local entry = self:GetEntry_(namespacePath)
        if entry == nil then
            return nil, nil
        end
        
        return entry:GetSymbolProto(), entry:GetManagedSymbolType()
    end

    -- importer()
    function NamespaceRegistry:Get(namespacePath, suppressExceptionIfNotFound)
        _setfenv(1, self)

        local entry = self:GetEntry_(namespacePath)
        if entry == nil and suppressExceptionIfNotFound then
            return nil
        end

        _assert(entry ~= nil, "namespace '" .. namespacePath .. "' has not been registered.\n" .. _debugstack() .. "\n")
        _assert(not entry:IsPartialEntry(), "namespace '" .. namespacePath .. "' holds a partially-registered entry (class/enum/interface) - did you forget to load its core definition?\n" .. _debugstack() .. "\n")
        
        return entry:GetSymbolProto()
    end

    function NamespaceRegistry:GetEntry_(namespacePath)
        _setfenv(1, self)

        _assert(_type(namespacePath) == "string", "namespacePath must be a string (got '" .. _type(namespacePath) .. "')\n" .. _debugstack() .. "\n")

        namespacePath = _strtrim(namespacePath)
        _assert(namespacePath ~= "", "namespacePath must not be dud\n" .. _debugstack() .. "\n")

        return _namespaces_registry[namespacePath]
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
