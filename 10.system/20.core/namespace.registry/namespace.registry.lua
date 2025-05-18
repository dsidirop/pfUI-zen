local _g, _assert, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _, _next = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _next = _assert(_g.next)
    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _strlen = _assert(_g.string.len)
    local _strsub = _assert(_g.string.sub)
    local _format = _assert(_g.string.format)
    local _strfind = _assert(_g.string.find)
    local _stringify = _assert(_g.tostring)
    local _debugstack = _assert(_g.debugstack)
    local _tableRemove = _assert(_g.table.remove)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _g, _assert, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _getmetatable, _next
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

local function _spawnSimpleMetatable(mt)
    mt = mt or {}
    mt.__index = mt.__index or mt
    return mt
end

local function _stringStartsWith(input, desiredPrefix)
    _ = _type(input) == "string" or _throw_exception("input must be a string")
    _ = _type(desiredPrefix) == "string" or _throw_exception("desiredPrefix must be a string")
    
    if desiredPrefix == "" then
        return true
    end

    if input == "" then
        return false
    end

    local desiredPrefixLength = _strlen(desiredPrefix)
    if _strlen(input) < desiredPrefixLength then
        return false
    end
    
    if input == desiredPrefix then
        return true
    end

    if desiredPrefixLength == 1 then
        -- optimization for 1-char-prefixes because for the runtime those 1-char-prefixes are very efficiently cached via string-interning
        return _strsub(input, 1, 1) == desiredPrefix
    end

    local startIndex = _strfind(input, desiredPrefix, --[[startindex:]] 1, --[[plainsearch:]] true)
    return startIndex == 1
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

-- the NamespaceRegistrySingleton has to be defined at the top of the
-- file because it is used by the ProtosFactory standard-methods
local NamespaceRegistrySingleton

local EnumsProtoFactory = {}
do
    local CommonMetaTable_ForAllEnumProtos
    
    function EnumsProtoFactory.Spawn()
        CommonMetaTable_ForAllEnumProtos = CommonMetaTable_ForAllEnumProtos or _spawnSimpleMetatable({
            __index = EnumsProtoFactory.OnUnknownPropertyDetected_,
        })

        local newEnumProto = _spawnSimpleMetatable({
            IsValid = EnumsProtoFactory.IsValidEnumValue_,
        })

        return _setmetatable(newEnumProto, CommonMetaTable_ForAllEnumProtos) -- set the common mt of all enum-mts ;)
    end

    function EnumsProtoFactory.IsValidEnumValue_(self, value)
        if _type(self) ~= "table" then
            _throw_exception("The IsValid() method must be called like :IsValid() (it has probably been invoked as .IsValid() which is wrong!)")
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

local InterfacesProtoFactory = {}
do
    local CommonMetaTable_ForAllInterfaceProtos

    function InterfacesProtoFactory.Spawn()
        CommonMetaTable_ForAllInterfaceProtos = CommonMetaTable_ForAllInterfaceProtos or _spawnSimpleMetatable({
            -- __call = InterfacesProtoFactory.OnProtoCalledAsFunction_ -- cant think of a good reason why interfaces would need a default call
        })

        local newInterfaceProto = _spawnSimpleMetatable({
            ChainSetDefaultCall = InterfacesProtoFactory.StandardChainSetDefaultCall_,
            
            -- __tostring  = todo,
            -- Instantiate = InterfacesProtoFactory.StandardInstantiator_,
        })

        return _setmetatable(newInterfaceProto, CommonMetaTable_ForAllInterfaceProtos)

        -- 00  __index needs to be preset like this   otherwise we run into errors in runtime
    end
end

local StaticClassProtoFactory = {}
do
    local CommonMetaTable_ForAllStaticClassProtos

    function StaticClassProtoFactory.Spawn()
        CommonMetaTable_ForAllStaticClassProtos = CommonMetaTable_ForAllStaticClassProtos or _spawnSimpleMetatable({
            __call = StaticClassProtoFactory.OnProtoCalledAsFunction_, -- needed by static-class utilities like Throw.__Call__() and Rethrow.__Call__() so as for them to work properly
        })

        local newStaticClassProto = _spawnSimpleMetatable({
            -- Instantiate         = StaticClassProtoFactory.StandardInstantiator_, --        no point for static-classes
            -- ChainSetDefaultCall = StaticClassProtoFactory.StandardChainSetDefaultCall_, -- no point for static-classes    
        })

        return _setmetatable(newStaticClassProto, CommonMetaTable_ForAllStaticClassProtos)

        -- 00  in the particular case of static classes we could omit the __index assignment because static classes are not expected
        --     to be instantiated   but it doesnt hurt to keep it around
    end

    function StaticClassProtoFactory.OnProtoCalledAsFunction_(staticClassProto, ...)
        local variadicsArray = arg
        local ownCallFuncSnapshot = staticClassProto.__Call__ --   static classes are expected to define it as :__Call__()

        _ = _type(ownCallFuncSnapshot) == "function" or _throw_exception("[__call()] Cannot call static_class() because the symbol lacks the method :__Call__()")

        return ownCallFuncSnapshot(
                staticClassProto, --          vital to pass the static-class-proto to the call-function to ensure proper parameter order considering that
                _unpack(variadicsArray) --    static-classes are supposed to define this as :__Call__() ( not as .__Call__() despite being in a static-class! )
        )
    end
end

local NonStaticClassProtoFactory = {}
do
    local CachedMetaTable_ForAllNonStaticClassProtos -- this can be shared really    saves us some loading time and memory too

    function NonStaticClassProtoFactory.Spawn()
        CachedMetaTable_ForAllNonStaticClassProtos = CachedMetaTable_ForAllNonStaticClassProtos or _spawnSimpleMetatable({
            __call = NonStaticClassProtoFactory.OnProtoOrInstanceCalledAsFunction_,
        })

        local newClassProto = _spawnSimpleMetatable({
            --  by convention static-utility-methods of instantiatable-classes are to be hosted under 'Class._.*'
            _                   = { EnrichInstanceWithFields = nil, },
            Instantiate         = NonStaticClassProtoFactory.StandardInstantiator_,
            ChainSetDefaultCall = NonStaticClassProtoFactory.StandardChainSetDefaultCall_,

            -- __tostring = todo,
        })

        return _setmetatable(newClassProto, CachedMetaTable_ForAllNonStaticClassProtos)
    end

    function NonStaticClassProtoFactory.OnProtoOrInstanceCalledAsFunction_(classProtoOrInstance, ...)
        local variadicsArray = arg
        local ownNewFuncSnapshot = classProtoOrInstance.New --         classes are expected to define these as :New() and :__Call__()
        local ownCallFuncSnapshot = classProtoOrInstance.__Call__ --   respectively  ( not as .New() or .__Call__()! )

        local hasConstructorFunction = _type(ownNewFuncSnapshot) == "function"
        local hasImplicitCallFunction = _type(ownCallFuncSnapshot) == "function"
        _ = hasConstructorFunction or hasImplicitCallFunction or _throw_exception("[__call()] Cannot call class() because the symbol lacks both methods :New() and :__Call__()")

        if hasImplicitCallFunction then
            -- has priority over :new()
            return ownCallFuncSnapshot(-- 00
                    classProtoOrInstance, -- vital to pass the classproto/instance to the call-function
                    _unpack(variadicsArray)
            )
        end

        return ownNewFuncSnapshot(
                classProtoOrInstance, -- vital to pass the classproto/instance to the call-function
                _unpack(variadicsArray)
        )

        -- 00  if both :New(...) and :__Call__() are defined then :__Call__() takes precedence
    end

    function NonStaticClassProtoFactory.StandardChainSetDefaultCall_(classProto, defaultCallMethod) -- @formatter:off
        _ = _type(classProto) == "table"           or _throw_exception("classProto was expected to be a table")
        _ = _type(defaultCallMethod) == "function" or _throw_exception("defaultCallMethod was expected to be a function") -- @formatter:on

        classProto.__call = defaultCallMethod

        return classProto
    end

    -- todo   refactor all classes to have them define their fields via their own
    -- todo   _.EnrichInstanceWithFields() method and then remove the instance parameter from here
    function NonStaticClassProtoFactory.StandardInstantiator_(classProtoOrInstanceBeingEnriched, instance) -- @formatter:off
        _setfenv(1, NonStaticClassProtoFactory)

        _ = _type(classProtoOrInstanceBeingEnriched) == "table"    or _throw_exception("classProtoOrInstance was expected to be a table")
        _ = instance == nil or _type(instance) == "table"          or _throw_exception("instance was expected to be either a table or nil") -- @formatter:on

        if NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(classProtoOrInstanceBeingEnriched) == nil then
            -- in this scenario we are dealing with the "instance-being-enriched" case
            --
            -- the :Instantiate() was called as newInstance:Instantiate() which is a clear sign that the callstack can be traced
            -- back to a sub-class constructor so we should skip creating a new instance because the instance has already been created

            if instance ~= nil then
                -- todo   temporary hack    get rid of this once we remove the 'instance' parameter 
                for key, value in _pairs(instance) do
                    classProtoOrInstanceBeingEnriched[key] = value
                end
            end

            return classProtoOrInstanceBeingEnriched
        end

        _ = classProtoOrInstanceBeingEnriched.__index ~= "nil" or _throw_exception("classProto.__index is nil - how did this happen?")

        instance = NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(classProtoOrInstanceBeingEnriched, instance)
        _setmetatable(instance, classProtoOrInstanceBeingEnriched)
        -- instance.__index = classProto.__index --00 dont

        -- todo    try to auto-generate the bindings for the blendxinProtos.* and the asBlendxinProto.* using instance.blendxin.* and instance.asBlendxin.*
        -- todo    but we have to be very careful around :New*() methods because those have to be bound against the CLASS-PROTO and not against the instance!
        -- todo
        -- todo    [PFZ-38] if the classProto claims that it implements an interface we should find a way to healthcheck that the interface methods are indeed honored!

        return instance

        --00   the instance will already use classProto as its metatable and any missing key lookups will automatically go through classProto.__index
        --     setting instance.__index would only be relevant if the instance itself became a metatable for another table which is definitely not the case here
        --
        --     additionally setting instance.__index could interfere with the normal method lookup chain and potentially cause unexpected behavior or
        --     infinite recursion   the standard pattern is to just set the metatable and let lua's built-in metatable mechanisms handle the property lookup
    end

    function NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(classProto, upcomingInstance) --@formatter:off
        _setfenv(1, NonStaticClassProtoFactory)

        _ = _type(classProto) == "table"                                  or _throw_exception("classProto was expected to be a table")
        _ = upcomingInstance == nil or _type(upcomingInstance) == "table" or _throw_exception("newInstance was expected to be a table or nil but it was found to be of type '%s'", _type(upcomingInstance)) --@formatter:on

        upcomingInstance = upcomingInstance or {}
        if classProto.asBlendxin ~= nil then
            -- iterate over the asBlendxin.* table and call the _.EnrichInstanceWithFields() static-method of each mixin in
            -- order to aggregate all the fields of all mixins in a single instance   in case of field-overlaps the last mixin wins
            for _, mixinProto in _pairs(classProto.asBlendxin) do

                local mixinProtoTidbits = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(mixinProto)
                if mixinProtoTidbits ~= nil and mixinProtoTidbits:IsNonStaticClassEntry() then
                    local snapshotOfMixinStaticMethods = mixinProto._
                    __ = _type(snapshotOfMixinStaticMethods) == "table" or _throw_exception("mixinProto._ was expected to be a table but it was found to be of type '%s' (mixin-namespace = %q)", _type(snapshotOfMixinStaticMethods), mixinProtoTidbits:GetNamespace())

                    upcomingInstance = NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(mixinProto, upcomingInstance) -- vital order    depth first

                    local enrichInstanceWithFieldsOfMixin = snapshotOfMixinStaticMethods.EnrichInstanceWithFields
                    if enrichInstanceWithFieldsOfMixin ~= nil then
                        upcomingInstance = enrichInstanceWithFieldsOfMixin(upcomingInstance)
                    end
                end

            end
        end

        -- finally we can enrich the instance with the fields of the class itself if it has any
        local enrichInstanceWithOwnFields = classProto._.EnrichInstanceWithFields
        if enrichInstanceWithOwnFields ~= nil then
            upcomingInstance = enrichInstanceWithOwnFields(upcomingInstance)
        end        

        return upcomingInstance
    end
end

local EManagedSymbolTypes = EnumsProtoFactory.Spawn()
do
    EManagedSymbolTypes.Enum = 1
    EManagedSymbolTypes.NonStaticClass = 2
    EManagedSymbolTypes.StaticClass = 3
    EManagedSymbolTypes.Interface = 3
    EManagedSymbolTypes.RawSymbol = 4 --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
    EManagedSymbolTypes.Keyword = 5 -- [declare] and friends
end

local ProtosFactory = {}
do    
    function ProtosFactory.Spawn(symbolType)
        _setfenv(1, ProtosFactory)

        if symbolType == EManagedSymbolTypes.Enum then
            return EnumsProtoFactory.Spawn()
        end

        if symbolType == EManagedSymbolTypes.StaticClass then
            return StaticClassProtoFactory.Spawn()
        end

        if symbolType == EManagedSymbolTypes.NonStaticClass then
            return NonStaticClassProtoFactory.Spawn()
        end

        if symbolType == EManagedSymbolTypes.Interface then
            return InterfacesProtoFactory.Spawn()
        end

        return {} -- raw-3rd-party-symbols and keywords
    end
end

local Entry = _spawnSimpleMetatable()
do
    function Entry:New(symbolType, symbolProto, namespacePath, isForPartial)
        _setfenv(1, self)

        _ = symbolProto ~= nil                                       or  _throw_exception("symbolProto must not be nil") -- @formatter:off
        _ = _type(namespacePath) == "string"                         or  _throw_exception("namespacePath must be a string (got something of type '%s')", _type(namespacePath))
        -- _ = EManagedSymbolTypes:IsValid(symbolType)                  or  _throw_exception("symbolType must be a valid EManagedSymbolTypes member (got '%s')", symbolType) -- todo   auto-enable this only in debug builds 
        _ = isForPartial == nil or _type(isForPartial) == "boolean"  or  _throw_exception("isForPartial must be a boolean or nil (got '%s')", _type(isForPartial)) -- @formatter:on
        
        local instance = {
            _symbolType = symbolType,
            _symbolProto = symbolProto,
            _isForPartial = _nilCoalesce(isForPartial, false),
            _namespacePath = namespacePath,
        }

        _setmetatable(instance, self)
        
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

        return _symbolType == EManagedSymbolTypes.NonStaticClass or _symbolType == EManagedSymbolTypes.StaticClass
    end
    
    function Entry:IsStaticClassEntry()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.StaticClass
    end

    function Entry:IsNonStaticClassEntry()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.NonStaticClass
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

        return _symbolType == EManagedSymbolTypes.RawSymbol -- external symbols from 3rd party libs etc
    end

    function Entry:IsKeyword()
        _setfenv(1, self)

        return _symbolType == EManagedSymbolTypes.Keyword -- [declare] and friends
    end

    local Enums_SystemReservedMemberNames_ForDirectMembers = {
        ["IsValid"]          = "IsValid",

        ["__call"]           = "__call",
        ["__index"]          = "__index",
        ["blendxin"]         = "blendxin",
        ["asBlendxin"]       = "asBlendxin",
    }
    local Enums_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
        -- ["EnrichInstanceWithFields"] = "EnrichInstanceWithFields",
    }

    local StaticClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["blendxin"]            = "blendxin",
        ["asBlendxin"]          = "asBlendxin",
        -- ["Instantiate"]         = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local StaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
        -- ["EnrichInstanceWithFields"] = "EnrichInstanceWithFields",
    }

    local NonStaticClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["blendxin"]            = "blendxin",
        ["asBlendxin"]          = "asBlendxin",
        ["Instantiate"]         = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local NonStaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
        ["EnrichInstanceWithFields"] = "EnrichInstanceWithFields",
    }

    local Interface_SystemReservedMemberNames_ForDirectMembers = {
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["blendxin"]            = "blendxin",
        ["asBlendxin"]          = "asBlendxin",
        -- ["Instantiate"]         = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local Interfaces_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
        -- ["EnrichInstanceWithFields"] = "EnrichInstanceWithFields",
    }

    function Entry:GetSpecialReservedNames()
        _setfenv(1, self)
        
        if _symbolType == EManagedSymbolTypes.Enum then
            return Enums_SystemReservedMemberNames_ForDirectMembers, Enums_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == EManagedSymbolTypes.StaticClass then
            return StaticClasses_SystemReservedMemberNames_ForDirectMembers, StaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == EManagedSymbolTypes.NonStaticClass then
            return NonStaticClasses_SystemReservedMemberNames_ForDirectMembers, NonStaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == EManagedSymbolTypes.Interface then
            return Interface_SystemReservedMemberNames_ForDirectMembers, Interfaces_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        _throw_exception("GetSpecialReservedNames() is not implemented for symbol-type %q (how did this even happen btw?)", _symbolType)
    end

    function Entry:ToString()
        _setfenv(1, self)

        return "symbolType='" .. _stringify(_symbolType) .. "', symbolProto='" .. _stringify(_symbolProto) .. "', namespacePath='" .. _stringify(_namespacePath) .. "', isForPartial='" .. _stringify(_isForPartial) .. "'"
    end
    Entry.__tostring = Entry.ToString

end

local NamespaceRegistry = _spawnSimpleMetatable()
do
    function NamespaceRegistry:New()
        _setfenv(1, self)

        local instance = {
            _namespaces_registry = {},
            _reflection_registry = {},
        }

        return _setmetatable(instance, self)
    end

    NamespaceRegistry.Assert = {}
    NamespaceRegistry.Assert.NamespacePathIsHealthy = function(namespacePath)
        _ = _type(namespacePath) == "string" and namespacePath == _strtrim(namespacePath) and namespacePath ~= "" and namespacePath or _throw_exception("namespacePath %q is invalid - it must be a non-empty string without prefixed/postfixed whitespaces", namespacePath)
    end
    NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol = function(symbolType)
        local isDeclarableSymbol = symbolType == EManagedSymbolTypes.NonStaticClass or symbolType == EManagedSymbolTypes.Enum or symbolType == EManagedSymbolTypes.Interface

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
    --     _namespacer_bind("Foo.Bar",         function(x) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("[declare] [class]", function(namespace) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
    --
    function NamespaceRegistry:Bind(keywordOrNamespacePath, rawSymbol)
        _setfenv(1, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(keywordOrNamespacePath)
        NamespaceRegistry.Assert.ProtoForRawSymbolEntryMustNotBeNil(rawSymbol)

        local possiblePreexistingEntry = _namespaces_registry[keywordOrNamespacePath]

        NamespaceRegistry.Assert.RawSymbolNamespaceIsAvailable(possiblePreexistingEntry, keywordOrNamespacePath)

        local properSymbolType = _stringStartsWith(keywordOrNamespacePath, "[")
                and EManagedSymbolTypes.Keyword -- [declare] and friends
                or EManagedSymbolTypes.RawSymbol

        local newFormalSymbolProtoEntry = Entry:New(properSymbolType, rawSymbol, keywordOrNamespacePath)

        _namespaces_registry[keywordOrNamespacePath] = newFormalSymbolProtoEntry

        if properSymbolType == EManagedSymbolTypes.RawSymbol then
            -- no point to include [declare] and other keywords in the registry
            _reflection_registry[rawSymbol] = newFormalSymbolProtoEntry
        end
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaNamespace(namespacePath)
        _setfenv(1, self)

        -- we intentionally omit validating the namespacepath in terms of whitespaces etc
        -- that is because this method is meant to be used by the reflection.* family of methods

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

            _throw_exception("namespace/keyword %q has not been registered.", namespacePath) -- dont turn this into an debug.assertion   we want to know about this in production builds too
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
    
    function NamespaceRegistry.HasCircularProtoDependency(mixinProtoSymbol, targetSymbolProto)
        _setfenv(1, NamespaceRegistry)

        local protosCheckedCount = 0
        
        function impl_(mixinProtoSymbol_, targetSymbolProto_, depth_)
            if mixinProtoSymbol_ == nil then
                return false
            end

            if mixinProtoSymbol_ == targetSymbolProto_ then
                return true
            end

            if mixinProtoSymbol_.asBlendxin == nil then
                return false
            end

            if mixinProtoSymbol_.asBlendxin[targetSymbolProto_] ~= nil then
                return true
            end

            protosCheckedCount = protosCheckedCount + 2

            if depth_ > 30 then
                _throw_exception("recursion-depth search too deep (%s) during circular-dependency check - something feels off - possible circular dependency detected", depth_)
            end

            if protosCheckedCount > 40 then
                _throw_exception("too many protos (%s) during recursion - something feels off - possible circular dependency detected", protosCheckedCount)
            end

            if mixinProtoSymbol_.asBlendxin ~= nil then
                for key, protoSymbol_ in _pairs(mixinProtoSymbol_.asBlendxin) do
                    if _type(key) == "table" then
                        if impl_(protoSymbol_, targetSymbolProto_, depth_ + 1) then -- recurse
                            return true
                        end
                    end
                end
            end
            
            return false
        end
        
        return impl_(mixinProtoSymbol, targetSymbolProto, 0)
    end

    function NamespaceRegistry:BlendMixins(targetSymbolProto, namedMixins)
        _setfenv(1, self)
        
        local protoTidbits = self:TryGetProtoTidbitsViaSymbolProto(targetSymbolProto)
        _ = protoTidbits ~= nil or _throw_exception("targetSymbolProto is not a symbol-proto")
        
        local targetIsEnum = protoTidbits:IsEnumEntry()
        local targetIsInterface = protoTidbits:IsInterfaceEntry()
        local targetIsStaticClass = protoTidbits:IsStaticClassEntry()
        local targetIsNonStaticClass = protoTidbits:IsNonStaticClassEntry()
        _ = (targetIsEnum or targetIsInterface or targetIsStaticClass or targetIsNonStaticClass) or _throw_exception("targetSymbolProto is not a class, an interface or an enum - its symbol-type is %q", protoTidbits:GetManagedSymbolType())

        _ = _type(namedMixins) == "table" or _throw_exception("namedMixins must be a table")
        _ = _next(namedMixins) ~= nil or _throw_exception("namedMixins must not be empty")

        local targetSymbolProto_BlendxinProp = targetSymbolProto.blendxin or {} -- create an blendxin and asBlendxin tables to hold per-mixin fields/methods
        local targetSymbolProto_asBlendxinProp = targetSymbolProto.asBlendxin or {}

        targetSymbolProto.blendxin = targetSymbolProto_BlendxinProp
        targetSymbolProto.asBlendxin = targetSymbolProto_asBlendxinProp

        -- for each named mixin, create a table with closures that bind the target as self
        local systemReservedMemberNames_forDirectMembers, systemReservedStaticMemberNames_forMembersOfUnderscore = protoTidbits:GetSpecialReservedNames()
        for specific_MixinNickname, specific_MixinProtoSymbol in _pairs(namedMixins) do
            _ = targetSymbolProto ~= specific_MixinProtoSymbol or _throw_exception("mixin nicknamed %q tries to add its target-symbol-proto directly into itself (how did you even manage this?)", specific_MixinNickname)
            _ = not NamespaceRegistry.HasCircularProtoDependency(specific_MixinProtoSymbol, targetSymbolProto) or _throw_exception("mixin nicknamed %q introduces a circular dependency", specific_MixinNickname)
            
            local mixinProtoTidbits = self:TryGetProtoTidbitsViaSymbolProto(specific_MixinProtoSymbol) -- also accounts for specific_MixinProtoSymbol being nil (nil is hard to come by but not impossible)
            _ = mixinProtoTidbits                                           ~= nil or _throw_exception("mixin nicknamed %q (raw-type=%s) is not a known class/interface/enum proto-symbol...", specific_MixinNickname, _type()) --@formatter:off
            _ = _next(specific_MixinProtoSymbol)                            ~= nil or _throw_exception("mixin nicknamed %q has dud specs (uh oh how is this even possible?)", specific_MixinNickname)
            _ = targetSymbolProto_asBlendxinProp[specific_MixinNickname]    == nil or _throw_exception("mixin nicknamed %q cannot be added because another mixin has registered this nickname", specific_MixinNickname)
            _ = targetSymbolProto_asBlendxinProp[specific_MixinProtoSymbol] == nil or _throw_exception("mixin nicknamed %q has already been added to the target under a different nickname", specific_MixinNickname)
            
            local mixinIsEnum           = mixinProtoTidbits:IsEnumEntry()
            local mixinIsInterface      = mixinProtoTidbits:IsInterfaceEntry()
            local mixinIsStaticClass    = mixinProtoTidbits:IsStaticClassEntry()
            local mixinIsNonStaticClass = mixinProtoTidbits:IsNonStaticClassEntry()
            _ = (not targetIsEnum           or mixinIsEnum           or mixinIsStaticClass) or _throw_exception("mixin nicknamed %q (symbol-type=%s) is not an enum or a static-class - cannot mix it into an enum", specific_MixinNickname, mixinProtoTidbits:GetManagedSymbolType())
            _ = (not targetIsInterface      or mixinIsInterface                           ) or _throw_exception("mixin nicknamed %q (symbol-type=%s) is not an interface - cannot mix it into an interface", specific_MixinNickname, mixinProtoTidbits:GetManagedSymbolType())
            _ = (not targetIsStaticClass    or mixinIsStaticClass    or mixinIsInterface  ) or _throw_exception("mixin nicknamed %q (symbol-type=%s) is not a static-class or an interface - cannot mix it into a static-class", specific_MixinNickname, mixinProtoTidbits:GetManagedSymbolType())
            _ = (not targetIsNonStaticClass or mixinIsNonStaticClass or mixinIsInterface  ) or _throw_exception("mixin nicknamed %q (symbol-type=%s) is not a non-static-class or an interface - cannot mix it into a non-static-class", specific_MixinNickname, mixinProtoTidbits:GetManagedSymbolType()) --@formatter:on
            
            targetSymbolProto_asBlendxinProp[specific_MixinProtoSymbol] = specific_MixinProtoSymbol -- add the mixin-proto-symbol itself as the key to its own mixin-proto-symbol

            local isNamelessMixin = specific_MixinNickname == ""
            if not isNamelessMixin then
                targetSymbolProto_asBlendxinProp[specific_MixinNickname] = specific_MixinProtoSymbol -- completely overwrite any previous asBlendxin[name]
            end

            for specific_MixinMemberName, specific_MixinMemberSymbol in _pairs(specific_MixinProtoSymbol) do
                -- _g.print("** [" .. _g.tostring(mixinNickname) .. "] processing mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "'")

                _ = _type(specific_MixinMemberName) == "string" or _throw_exception("mixin nicknamed %q has a direct-member whose name is not a string - its type is %q", _type(specific_MixinMemberName))
                _ = (specific_MixinMemberName ~= nil and specific_MixinMemberName ~= "") or _throw_exception("mixin nicknamed %q has a member with a dud name - this is not allowed", specific_MixinNickname)

                if specific_MixinMemberName == "_" then
                    -- todo   we should refactor this part to just use __index with a custom look up function for the base statics and be done with it nice and easy
                    
                    -- blend-in all whitelisted statics ._.* from every mixin directly under targetSymbolProto._.*
                    for _staticMemberName, _staticMember in _pairs(specific_MixinMemberSymbol) do
                        _ = _type(_staticMemberName) == "string" or _throw_exception("static-mixin-member-name is not a string - its type is %q", _type(_staticMemberName))
                        _ = (_staticMemberName ~= nil and _staticMemberName ~= "") or _throw_exception("statics of mixin named %q has a member with a dud name - this is not allowed", specific_MixinNickname)

                        -- must not let the mixins overwrite the default .EnrichInstanceWithFields()
                        local hasGreenName = systemReservedStaticMemberNames_forMembersOfUnderscore[_staticMemberName] == nil
                        if hasGreenName then
                            targetSymbolProto._[_staticMemberName] = _staticMember -- static member
                        end
                    end
                else
                    -- blend-in all whitelisted non-statics-methods and static-fields from every mixin both directly under targetSymbolProto.* and under target.blendxin.*

                    local isFunction = _type(specific_MixinMemberSymbol) == "function"
                    local hasBlendxinRelatedName = specific_MixinMemberName == "blendxin" or specific_MixinMemberName == "asBlendxin"
                    _ = (not isFunction or not hasBlendxinRelatedName) or _throw_exception("mixin-member %q is a function and yet it is named 'blendxin'/'asBlendxin' - this is so odd it's treated as an error", specific_MixinMemberName)

                    -- todo  once every non-static-class is migrated to place its static fields under _.* we can limit the logic to just transfer functions
                    
                    -- _g.print("** [" .. _g.tostring(mixinNickname) .. "] processing mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "'")
                    
                    local hasGreenName = systemReservedMemberNames_forDirectMembers[specific_MixinMemberName] == nil
                    if hasGreenName then
                        targetSymbolProto[specific_MixinMemberName] = specific_MixinMemberSymbol -- combine all members/methods provided by mixins directly under proto.*     later mixins override earlier ones    

                        targetSymbolProto_asBlendxinProp[specific_MixinNickname][specific_MixinMemberName] = specific_MixinMemberSymbol -- append methods provided by a specific mixin under proto.asBlendxin.<specific-mixin-nickname>.<specific-member-name>
                    -- else
                        -- _g.print("****** [" .. _g.tostring(mixinNickname) .. "] skipping mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "' because it is a system-reserved name")
                    end
                end
            end
        end

        return targetSymbolProto
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

NamespaceRegistrySingleton = NamespaceRegistry:New()
do
    -- using "x.y.z"
    _g.pvl_namespacer_get = function(namespacePath)
        --    todo   in production builds these symbols should get obfuscated to something like  _g.ppzcn__<some_guid_here>__get
        return NamespaceRegistrySingleton:Get(namespacePath)
    end

    -- using "[declare]" "x.y.z"
    _g.pvl_namespacer_add = function(namespacePath)
        return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.NonStaticClass)
    end

    -- namespacer_binder()
    _g.pvl_namespacer_bind = function(namespacePath, specificSymbolType)
        return NamespaceRegistrySingleton:Bind(namespacePath, specificSymbolType)
    end
end

NamespaceRegistrySingleton:Bind("System.Namespacer", NamespaceRegistrySingleton)

-- @formatter:off   todo   also introduce [declare] [partial] [declare] [testbed] etc and remove the [Partial] postfix-technique on the namespace path since it will no longer be needed 
NamespaceRegistrySingleton:Bind("[declare]",                   function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:Bind("[declare] [enum]",            function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Enum                 ) end)
NamespaceRegistrySingleton:Bind("[declare] [class]",           function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:Bind("[declare] [interface]",       function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.Interface            ) end)

NamespaceRegistrySingleton:Bind("[declare] [static]",          function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.StaticClass          ) end)
NamespaceRegistrySingleton:Bind("[declare] [static] [class]",  function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, EManagedSymbolTypes.StaticClass          ) end)

local function declareSymbolAndReturnBlenderCallback(namespacePath, symbolType)
    local protoEntrySnapshot = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, symbolType)

    return function(namedMixinsToAdd) return NamespaceRegistrySingleton:BlendMixins(protoEntrySnapshot, namedMixinsToAdd) end -- currying essentially
end

NamespaceRegistrySingleton:Bind("[declare] [blend]",                       function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:Bind("[declare] [enum] [blend]",                function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.Enum                 ) end)
NamespaceRegistrySingleton:Bind("[declare] [class] [blend]",               function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:Bind("[declare] [interface] [blend]",           function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.Interface            ) end)

NamespaceRegistrySingleton:Bind("[declare] [static] [blend]",              function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.StaticClass          ) end)
NamespaceRegistrySingleton:Bind("[declare] [static] [class] [blend]",      function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, EManagedSymbolTypes.StaticClass          ) end)

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
