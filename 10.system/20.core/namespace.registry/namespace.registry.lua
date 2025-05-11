local _g, _assert, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _format = _assert(_g.string.format)
    local _strsub = _assert(_g.string.sub)
    local _strfind = _assert(_g.string.find)
    local _stringify = _assert(_g.tostring)
    local _debugstack = _assert(_g.debugstack)
    local _tableRemove = _assert(_g.table.remove)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _g, _assert, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(1, {})

local function _throw_exception(format, ...)
    local variadicsArray = arg

    for i = 1, _getn(variadicsArray) do
        variadicsArray[i] = _stringify(variadicsArray[i])
    end

    _assert(false, _format(format, _unpack(variadicsArray)) .. "\n\n---------------Stacktrace---------------\n" .. _debugstack(2) .. "\n---------------End Stacktrace---------------\n ")
end

local function _strmatch(input, patternString, ...)
    local variadicsArray = arg

    _ = patternString ~= nil or _throw_exception("patternString must not be nil")

    if patternString == "" then
        return nil
    end

    local results = {_strfind(input, patternString, _unpack(variadicsArray))}

    local startIndex = results[1]
    if startIndex == nil then
        -- no match
        return nil
    end

    local match01 = results[3]
    if match01 == nil then
        local endIndex = results[2]
        return _strsub(input, startIndex, endIndex) -- matched but without using captures   ("Foo 11 bar   ping pong"):match("Foo %d+ bar")
    end

    _tableRemove(results, 1) -- pop startIndex
    _tableRemove(results, 1) -- pop endIndex
    return _unpack(results) -- matched with captures  ("Foo 11 bar   ping pong"):match("Foo (%d+) bar")
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

local EnumsProtoFactory = {}
do
    function EnumsProtoFactory.Spawn()
        local metaTable = { __index = EnumsProtoFactory.OnUnknownPropertyDetected_ }

        local newEnumProto = { }
        newEnumProto.__index = newEnumProto
        newEnumProto.IsValid = EnumsProtoFactory.IsValidEnumValue_

        return _setmetatable(newEnumProto, metaTable)
    end

    function EnumsProtoFactory.IsValidEnumValue_(self, value)
        if _type(self) ~= "table" then
            _throw_exception("The IsValid() method must be called like :IsValid() instead of :IsValid()!")
        end

        _setfenv(1, self)

        local typeOfValue = _type(value)
        if typeOfValue ~= "string" and typeOfValue ~= "number" then
            return false
        end

        for _, v in _pairs(self) do
            if v == value then
                return true
            end
        end

        return false
    end

    function EnumsProtoFactory.OnUnknownPropertyDetected_(_, key) -- if the __index method gets called its a sign that the enum doesnt have a member with the given name
        _throw_exception("Enum doesn't have a member named %q", key)
    end
end

local ClassProtoFactory = {}
do
    function ClassProtoFactory.Spawn()
        local metaTable = { }
        metaTable.__call = ClassProtoFactory.OnProtoCalledAsFunction_
        metaTable.__index = metaTable
        -- metaTable.__tostring = todo

        local newClassProto = { }
        newClassProto.__index = newClassProto -- 00 vital
        newClassProto.Instantiate = ClassProtoFactory.StandardInstantiator_
        newClassProto.WithDefaultCall = ClassProtoFactory.StandardWithDefaultCall_

        return _setmetatable(newClassProto, metaTable)

        -- 00  __index needs to be preset like this   otherwise we run into errors in runtime
    end

    function ClassProtoFactory.OnProtoCalledAsFunction_(classProto, ...)
        local variadicsArray = arg

        local hasConstructorFunction = _type(classProto.New) == "function"
        local hasImplicitCallFunction = _type(classProto.__Call__) == "function"
        _ = hasConstructorFunction or hasImplicitCallFunction or _throw_exception("[__call()] Cannot call class() because the symbol lacks both methods :New() and :__Call__()")

        if hasImplicitCallFunction then
            return classProto:__Call__(_unpack(variadicsArray)) -- 00
        end

        return classProto:New(_unpack(variadicsArray))

        -- 00  if both :New(...) and :__Call__() are defined then :__Call__() takes precedence
    end

    function ClassProtoFactory.StandardWithDefaultCall_(classProto, defaultCallMethod)
        _ = _type(classProto) == "table"             or _throw_exception("classProto was expected to be a table") --             @formatter:off
        _ = _type(defaultCallMethod) == "function"   or _throw_exception("defaultCallMethod was expected to be a function") --   @formatter:on

        classProto.__call = defaultCallMethod

        return classProto
    end

    function ClassProtoFactory.StandardInstantiator_(classProto, instanceSpecificFields)
        _ = _type(classProto) == "table"                                                or _throw_exception("classProto was expected to be a table") --                             @formatter:off
        _ = instanceSpecificFields == nil or _type(instanceSpecificFields) == "table"   or _throw_exception("instanceSpecificFields was expected to be either a table or nil") --   @formatter:on

        instanceSpecificFields = instanceSpecificFields or {}

        _setmetatable(instanceSpecificFields, classProto)
        if classProto.__index == nil then
            classProto.__index = classProto
        end

        return instanceSpecificFields
    end
end

local EManagedSymbolTypes = EnumsProtoFactory.Spawn()
do
    EManagedSymbolTypes.Enum = 0
    EManagedSymbolTypes.Class = 1
    EManagedSymbolTypes.Interface = 2
    EManagedSymbolTypes.RawSymbol = 3 --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
end

local ProtosFactory = {}
do
    function ProtosFactory.Spawn(symbolType)
        _setfenv(1, ProtosFactory)

        if symbolType == EManagedSymbolTypes.Enum then
            return EnumsProtoFactory.Spawn()
        end

        if symbolType == EManagedSymbolTypes.Class then
            return ClassProtoFactory.Spawn()
        end

        return {} -- interfaces
    end
end


local Entry = {}
do
    function Entry:New(symbolType, symbolProto, namespacePath, isForPartial)
        _setfenv(1, self)

        _ = symbolProto ~= nil                                       or  _throw_exception("symbolProto must not be nil") -- @formatter:off
        _ = _type(namespacePath) == "string"                         or  _throw_exception("namespacePath must be a string (got something of type '%s')", _type(namespacePath))
        _ = EManagedSymbolTypes:IsValid(symbolType)                  or  _throw_exception("symbolType must be a valid EManagedSymbolTypes member (got '%s')", symbolType)
        _ = isForPartial == nil or _type(isForPartial) == "boolean"  or  _throw_exception("isForPartial must be a boolean or nil (got '%s')", _type(isForPartial)) -- @formatter:on

        local instance = {
            _symbolType = symbolType,
            _symbolProto = symbolProto,
            _isForPartial = _nilCoalesce(isForPartial, false),
            _namespacePath = namespacePath,
        }

        _setmetatable(instance, self)
        self.__index = self
        self.__tostring = self.ToString

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

        return "symbolType='" .. _stringify(_symbolType) .. "', symbolProto='" .. _stringify(_symbolProto) .. "', namespacePath='" .. _stringify(_namespacePath) .. "', isForPartial='" .. _stringify(_isForPartial) .. "'"
    end

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
    NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol = function(symbolType)
        local isDeclarableSymbol = symbolType == EManagedSymbolTypes.Class or symbolType == EManagedSymbolTypes.Enum or symbolType == EManagedSymbolTypes.Interface

        _ = isDeclarableSymbol or _throw_exception("the symbol you're trying to declare (type=%q) is not a Class/Enum/Interface to be declarable - so try binding it instead!", symbolType)
    end

    NamespaceRegistry.Assert.EntryUpdateConcernsEntryWithTheSameSymbolType = function(incomingSymbolType, preExistingEntry, namespacePath)
        _ = incomingSymbolType == preExistingEntry:GetManagedSymbolType() or _throw_exception("cannot re-register namespace %q with type=%q as it has already been registered as symbol-type=%q", namespacePath, incomingSymbolType, preExistingEntry:GetManagedSymbolType()) -- 10
    end

    NamespaceRegistry.Assert.EitherTheIncomingUpdateIsForPartialOrThePreexistingEntryIsPartial = function(isForPartial, preExistingEntry, sanitizedNamespacePath)
        _ = isForPartial or preExistingEntry:IsPartialEntry() or _throw_exception("namespace %q has already been assigned to a symbol marked as %q (did you mean to register a 'partial' symbol?)", sanitizedNamespacePath, preExistingEntry:GetManagedSymbolType()) -- 10
    end

    -- namespacer()
    function NamespaceRegistry:UpsertSymbolProtoSpecs(namespacePath, symbolType)
        _setfenv(1, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)
        NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol(symbolType)

        local sanitizedNamespacePath, isForPartial = NamespaceRegistry.SanitizeNamespacePath_(namespacePath)

        local preExistingEntry = _namespaces_registry[sanitizedNamespacePath]
        if preExistingEntry == nil then -- insert new entry
            local newSymbolProto = ProtosFactory.Spawn(symbolType)

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
            _g.print("**** namespace='" .. _stringify(namespace) .. "' ->  " .. entry:ToString())
        end

        _g.print("** reflection-registry **")
        for symbolProto, entry in _pairs(self._reflection_registry) do
            _g.print("**** symbolProto='" .. _stringify(symbolProto) .. "' ->  " .. entry:ToString())
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
    if _type(v) == "number" then
        AdvertisedEManagedSymbolTypes[k] = v
    end
end

-- no need for this   the standardized enum metatable is already in place and it does the same job just fine
--
-- _setmetatable(AdvertisedEManagedSymbolTypes, _getmetatable(EManagedSymbolTypes))
