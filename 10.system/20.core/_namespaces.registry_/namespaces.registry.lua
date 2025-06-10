local EScope = { EGlobal = 0, EFunction = 1 }

local _g, _assert, _tblInsert, _tblConcat, _rawequal, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _, _next = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(EScope.Function, {})

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
    local _rawequal = _assert(_g.rawequal)
    local _stringify = _assert(_g.tostring)
    local _tblInsert = _assert(_g.table.insert)
    local _tblConcat = _assert(_g.table.concat)
    local _debugstack = _assert(_g.debugstack)
    local _tableRemove = _assert(_g.table.remove)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _g, _assert, _tblInsert, _tblConcat, _rawequal, _type, _getn, _gsub, _pairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _getmetatable, _next
end)()

if _g.pvl_namespacer_add then
    return -- already in place
end

_setfenv(EScope.Function, {})

local function _throw_exception(format, ...)
    local variadicsArray = arg

    for i = 1, _getn(variadicsArray) do
        variadicsArray[i] = _stringify(variadicsArray[i])
    end

    _assert(false, _format(format, _unpack(variadicsArray)) .. "\n\n---------------Stacktrace---------------\n" .. _debugstack(2) .. "---------------End Stacktrace---------------\n ")
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

    if _rawequal(input, desiredPrefix) then
        return true
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

local function _stringEndsWith(input, desiredPostfix)
    _ = _type(input) == "string" or _throw_exception("input must be a string")
    _ = _type(desiredPostfix) == "string" or _throw_exception("desiredPrefix must be a string")

    if desiredPostfix == "" then
        return true
    end

    if input == "" then
        return false
    end

    if _rawequal(input, desiredPostfix) then
        return true
    end

    local inputLength = _strlen(input)
    local desiredPostfixLength = _strlen(desiredPostfix)
    if inputLength < desiredPostfixLength then
        return false
    end

    if inputLength == desiredPostfixLength and input == desiredPostfix then
        return true
    end

    return _strsub(input, -desiredPostfixLength) == desiredPostfix
end

local function _stringMatch(input, patternString, ...)
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

local function _stringTrim(input)
    return _stringMatch(input, '^%s*(.*%S)') or ''
end

local function _nilCoalesce(value, defaultFallbackValue)
    if value == nil then
        return defaultFallbackValue
    end

    return value
end

-- the NamespaceRegistrySingleton has to be defined at the top of the
-- file because it is used by the ProtosFactory standard-methods
local NamespaceRegistrySingleton, HealthCheckerSingleton

--[[ PROTO FACTORIES ]] --

local EnumsProtoFactory = {}
do
    local CommonMetaTable_ForAllEnumProtos
    
    function EnumsProtoFactory.Spawn()
        CommonMetaTable_ForAllEnumProtos = CommonMetaTable_ForAllEnumProtos or _spawnSimpleMetatable({
            __index = EnumsProtoFactory.OnUnknownPropertyDetected_,
        })

        local newEnumProto = _spawnSimpleMetatable({
            IsValid = EnumsProtoFactory.IsValidEnumValue_, -- must be here
        })

        return _setmetatable(newEnumProto, CommonMetaTable_ForAllEnumProtos) -- set the common mt of all enum-mts ;)
    end

    function EnumsProtoFactory.IsValidEnumValue_(self, value)
        if _type(self) ~= "table" then
            _throw_exception("The IsValid() method must be called like :IsValid() (it has probably been invoked as .IsValid() which is wrong!)")
        end

        _setfenv(EScope.Function, self)

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
        CommonMetaTable_ForAllInterfaceProtos = CommonMetaTable_ForAllInterfaceProtos or _spawnSimpleMetatable()

        local newInterfaceProto = _spawnSimpleMetatable()

        return _setmetatable(newInterfaceProto, CommonMetaTable_ForAllInterfaceProtos)

        -- 00  __index needs to be preset like this   otherwise we run into errors in runtime
    end
end

local StaticClassProtoFactory = {}
do
    local CommonMetaTable_ForAllStaticClassProtos

    function StaticClassProtoFactory.Spawn()
        CommonMetaTable_ForAllStaticClassProtos = CommonMetaTable_ForAllStaticClassProtos or _spawnSimpleMetatable({
            __call = StaticClassProtoFactory.OnProtoCalledAsFunction_, -- needed by static-class utilities like Throw.__Call__() so as for them to work properly
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
            Instantiate         = NonStaticClassProtoFactory.StandardInstantiator_,
            ChainSetDefaultCall = NonStaticClassProtoFactory.StandardChainSetDefaultCall_,
        })

        local newClassProto = _spawnSimpleMetatable({
            --  by convention static-utility-methods of instantiatable-classes are to be hosted under 'Class._.*'
            _          = { },
            __call     = NonStaticClassProtoFactory.OnProtoOrInstanceCalledAsFunction_, --00 must be here
            __tostring = nil, -- todo
        })

        return _setmetatable(newClassProto, CachedMetaTable_ForAllNonStaticClassProtos)
        
        -- 00   based on practical experiments it seems that in wow-lua the __call function doesnt work if we place it
        --      in CachedMetaTable_ForAllNonStaticClassProtos    but it does work if it is placed directly in newClassProto
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

        classProto.__Call__ = defaultCallMethod

        return classProto
    end

    function NonStaticClassProtoFactory.StandardInstantiator_(classProtoOrInstanceBeingEnriched) -- @formatter:off
        _setfenv(EScope.Function, NonStaticClassProtoFactory)

        _ = _type(classProtoOrInstanceBeingEnriched) == "table" or _throw_exception("classProtoOrInstance was expected to be a table") -- @formatter:on

        local protoTidbits = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(classProtoOrInstanceBeingEnriched)
        if protoTidbits == nil then
            -- in this scenario we are dealing with the "instance-being-enriched" case
            --
            -- the :Instantiate() was called as newInstance:Instantiate() which is a clear sign that the callstack can be traced
            -- back to a sub-class constructor so we should skip creating a new instance because the instance has already been created

            return classProtoOrInstanceBeingEnriched
        end

        _ = classProtoOrInstanceBeingEnriched.__index ~= "nil" or _throw_exception("classProto.__index is nil - how did this happen?")

        local newInstance = NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(classProtoOrInstanceBeingEnriched, protoTidbits)

        -- todo  find a way to disable access to 'instance.base' and 'instance.asBase' because these fields
        -- todo  are meant to be accessible only by the proto itself ala 'classProto.base' and 'classProto.asBase'   
        _setmetatable(newInstance, classProtoOrInstanceBeingEnriched)
        -- instance.__index = classProto.__index --00 dont

        return newInstance

        --00   the instance will already use classProto as its metatable and any missing key lookups will automatically go through classProto.__index
        --     setting instance.__index would only be relevant if the instance itself became a metatable for another table which is definitely not the case here
        --
        --     additionally setting instance.__index could interfere with the normal method lookup chain and potentially cause unexpected behavior or
        --     infinite recursion   the standard pattern is to just set the metatable and let lua's built-in metatable mechanisms handle the property lookup
    end

    function NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(classProto, protoTidbits, upcomingInstance) --@formatter:off
        _setfenv(EScope.Function, NonStaticClassProtoFactory)

        _ = _type(classProto) == "table"                                  or _throw_exception("classProto was expected to be a table")
        _ = upcomingInstance == nil or _type(upcomingInstance) == "table" or _throw_exception("newInstance was expected to be a table or nil but it was found to be of type %q", _type(upcomingInstance)) --@formatter:on

        upcomingInstance = upcomingInstance or {}
        if classProto.asBase ~= nil then
            -- iterate over the asBase.* table and call the field-plugger method of each mixin in order to
            -- aggregate all the fields of all mixins in a single instance   in case of field-overlaps the last mixin wins
            for _, mixinProto in _pairs(classProto.asBase) do

                local mixinProtoTidbits = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(mixinProto)
                if mixinProtoTidbits ~= nil and mixinProtoTidbits:IsNonStaticClassEntry() then
                    upcomingInstance = NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(mixinProto, mixinProtoTidbits, upcomingInstance) -- vital order    depth first
                end

            end
        end

        -- must be last    finally we can enrich the instance with the fields of the class itself if it has any in case of
        -- overlaps with base-classes we want the fields of this child-class to prevail over the ones of the parent-base-classes
        return protoTidbits:GetFieldPluggerCallbackFunc()(upcomingInstance)
    end
end

local SRegistrySymbolTypes = EnumsProtoFactory.Spawn()
do --@formatter:off
    SRegistrySymbolTypes.Enum = "enum"
    SRegistrySymbolTypes.Interface = "interface"
    SRegistrySymbolTypes.StaticClass = "static-class"
    SRegistrySymbolTypes.NonStaticClass = "non-static-class"

    SRegistrySymbolTypes.Keyword = "keyword" --                 [declare]* and friends
    SRegistrySymbolTypes.AutorunKeyword = "autorun-keyword" --  [healthcheck]* and friends
    
    SRegistrySymbolTypes.RawSymbol = "raw-symbol" --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
end --@formatter:off

local ProtosFactory = {}
do
    ---@class Proto
    function ProtosFactory.Spawn(symbolType)
        _setfenv(EScope.Function, ProtosFactory)

        if symbolType == SRegistrySymbolTypes.Enum then
            return EnumsProtoFactory.Spawn()
        end

        if symbolType == SRegistrySymbolTypes.StaticClass then
            return StaticClassProtoFactory.Spawn()
        end

        if symbolType == SRegistrySymbolTypes.NonStaticClass then
            return NonStaticClassProtoFactory.Spawn()
        end

        if symbolType == SRegistrySymbolTypes.Interface then
            return InterfacesProtoFactory.Spawn()
        end

        return {} -- raw-3rd-party-symbols and keywords
    end
end

local Entry = _spawnSimpleMetatable() -- proto symbol tidbits
do
    local function _dudFieldPluggerFunc(upcomingInstance)
        return upcomingInstance
    end
    
    function Entry:New(symbolType, symbolProto, namespacePath, isForPartial)
        _setfenv(EScope.Function, self)

        _ = symbolProto ~= nil                                       or  _throw_exception("[NR.ENT.NW.010] symbolProto must not be nil") -- @formatter:off
        _ = _type(namespacePath) == "string"                         or  _throw_exception("[NR.ENT.NW.020] namespacePath must be a string (got something of type %q)", _type(namespacePath))
        _ = namespacePath ~= ""                                      or  _throw_exception("[NR.ENT.NW.030] namespacePath must not be an empty string")
        _ = not _stringEndsWith(namespacePath, ".")                  or  _throw_exception("[NR.ENT.NW.032] namespacePath must not end with a dot (.)")
        -- _ = _stringMatch(namespacePath, "^[%a_][%w_]+([.][%w_]+)*$") or  _throw_exception("[NR.ENT.NW.035] namespacePath must be a valid identifier (got %q)", namespacePath)
        _ = isForPartial == nil or _type(isForPartial) == "boolean"  or  _throw_exception("[NR.ENT.NW.040] isForPartial must be a boolean or nil (got %q)", _type(isForPartial))
        _ = SRegistrySymbolTypes:IsValid(symbolType)                 or  _throw_exception("[NR.ENT.NW.050] symbolType must be a valid SRegistrySymbolTypes member (got %q)", symbolType) -- todo   auto-enable this only in debug builds   @formatter:on 

        local instance = {
            _symbolType               = symbolType,
            _symbolProto              = symbolProto,
            _isForPartial             = _nilCoalesce(isForPartial, false),
            _namespacePath            = namespacePath,
            _fieldPluggerCallbackFunc = symbolType == SRegistrySymbolTypes.NonStaticClass
                    and _dudFieldPluggerFunc  -- placeholder
                    or nil,
            
            _wasEmployedAsParentClassSomewhere = false,
        }

        _setmetatable(instance, self)
        
        return instance
    end
    
    function Entry:Healthcheck(namespaceRegistry, optionalErrorsAccumulatorArray)
        _setfenv(EScope.Function, self)

        -- _g.print("[Entry.Healthcheck.000] namespacePath=" .. _namespacePath)

        _ = _type(_namespacePath) == "string" or _throw_exception("[NR.ENT.HC.010] namespacePath must be a string (got %q - how did this happen?)", _type(_namespacePath))
        _ = _namespacePath ~= "" or _throw_exception("[NR.ENT.HC.015] namespacePath must be a non-dud string (how did this happen?)")
        _ = _symbolType ~= nil or _throw_exception("[[NR.ENT.HC.020] symbolType must not be nil (namespace=[%s] - how did this happen?)", _stringify(_namespacePath))
        _ = _symbolProto ~= nil or _throw_exception("[NR.ENT.HC.030] symbolProto must not be nil (namespace=[%s] - how did this happen?)", _stringify(_namespacePath))

        local errorsAccumulatorArray = optionalErrorsAccumulatorArray or {}

        self:HealthcheckPartiality_(errorsAccumulatorArray)
        self:HealthcheckInheritance_(namespaceRegistry, errorsAccumulatorArray)

        return errorsAccumulatorArray
    end
    
    function Entry:HealthcheckPartiality_(errorsAccumulatorArray)
        _setfenv(EScope.Function, self)
        
        if _isForPartial then
            _tblInsert(errorsAccumulatorArray, _format("- [NR.ENT.HCP.010] symbol [%s] is still partial - did you forget to add its core definition to finalize it?", _namespacePath))
        end
    end
    
    function Entry:HealthcheckInheritance_(namespaceRegistry, errorsAccumulatorArray)
        _setfenv(EScope.Function, self)

        -- _g.print("[Entry.HealthcheckInheritance.000] namespacePath=" .. _namespacePath)
        
        _ = _type(namespaceRegistry) == "table" or _throw_exception("[NR.ENT.HCI.010] namespaceRegistry must be a table (got %q)", _type(namespaceRegistry))
        _ = _type(errorsAccumulatorArray) == "table" or _throw_exception("[NR.ENT.HCI.020] errorsAccumulatorArray must be a table (got %q)", _type(errorsAccumulatorArray))
        
        if _symbolType ~= SRegistrySymbolTypes.NonStaticClass then
            -- _g.print("[Entry.HealthcheckInheritance.010]")
            return -- we want to healthcheck any non-static-class that is based on inheritance
        end

        -- _g.print("[Entry.HealthcheckInheritance.020]")
        
        local missingMethods = {}
        for mixinNicknameOrProto, _ in _pairs(_symbolProto.asBase or {}) do
            if _type(mixinNicknameOrProto) == "table" then
                local entry = namespaceRegistry:TryGetProtoTidbitsViaSymbolProto(mixinNicknameOrProto)
                if entry ~= nil and entry:IsInterfaceEntry() then
                    for interfaceMethodName, interfaceMethod in _pairs(entry:GetSymbolProto()) do
                        for _, protoMethod in _pairs(_symbolProto) do
                            if _rawequal(interfaceMethod, protoMethod) then
                                _tblInsert(missingMethods, "      - " .. entry:GetNamespace() .. ":" .. interfaceMethodName .. "()")
                            end
                        end
                    end
                end
            end
        end

        if _next(missingMethods) then
            _tblInsert(errorsAccumulatorArray, _format("- [NR.ENT.HCI.010] class [%s] lacks implementations for the following method(s):\n\n%s\n", _namespacePath, _tblConcat(missingMethods, "\n")))
        end
    end

    function Entry:GetFieldPluggerCallbackFunc()
        _setfenv(EScope.Function, self)

        _ = _symbolType == SRegistrySymbolTypes.NonStaticClass or _throw_exception("[NR.ENT.GFPCF.010] trying to get the field-plugger-func makes sense for non-static-classes but the proto of %q is of type %q", _namespacePath, _symbolType)
        
        return _fieldPluggerCallbackFunc
    end

    function Entry:ChainSetFieldPluggerFuncForNonStaticClassProto(func) -- @formatter:off
        _setfenv(EScope.Function, self)

        _ = _type(func) == "function"                          or _throw_exception("[NR.ENT.CSFPFFNSCP.010] the field-plugger-callback must be a function (got %q)", _type(func))
        _ = _symbolType == SRegistrySymbolTypes.NonStaticClass or _throw_exception("[NR.ENT.CSFPFFNSCP.020] setting a field-plugger-callback makes sense only for non-static-classes but the proto of %q is of type %q", _namespacePath, _symbolType) -- @formatter:on

        if _fieldPluggerCallbackFunc == nil then
            _fieldPluggerCallbackFunc = func
            return self
        end

        local preexistingFieldPluggerCallbackFunc = _fieldPluggerCallbackFunc

        _fieldPluggerCallbackFunc = function(upcomingInstance)
            return func(preexistingFieldPluggerCallbackFunc(upcomingInstance)) -- chain the field-plugger-callbacks
        end

        return self
    end
    
    function Entry:UnsetPartiality()
        _setfenv(EScope.Function, self)

        _isForPartial = false
        
        return self
    end

    function Entry:GetNamespace()
        _setfenv(EScope.Function, self)

        _ = _type(_namespacePath) == "string" or _throw_exception("spotted unset namespace-path for a namespace-entry (how is this even possible?)")

        return _namespacePath
    end

    function Entry:GetSymbolName()
        _setfenv(EScope.Function, self)

        _ = _type(_namespacePath) == "string" or _throw_exception("spotted unset namespace-path for a namespace-entry (how is this even possible?)")

        return _stringMatch(_namespacePath, "([^%.]+)$")
    end

    function Entry:GetSymbolProto()
        _setfenv(EScope.Function, self)

        _ = _symbolProto ~= nil or _throw_exception("spotted unset symbol (nil) for a namespace-entry (how is this even possible?)")

        return _symbolProto
    end

    function Entry:GetRegistrySymbolType()
        _setfenv(EScope.Function, self)

        _ = _symbolType ~= nil or _throw_exception("spotted unset symbol-type (nil) for a namespace-entry (how is this even possible?)")

        return _symbolType
    end

    function Entry:IsPartialEntry()
        _setfenv(EScope.Function, self)

        _ = _isForPartial ~= nil or _throw_exception("spotted unset is-for-partial (nil) for a namespace-entry (how is this even possible?)")

        return _isForPartial
    end
    
    function Entry:CanBeSubclassed()
        _setfenv(EScope.Function, self)
        
        -- if _isForPartial then -- dont   we need to allow subclassing to happen even on partial entries   it comes in handy
        --     return false
        -- end

        return _symbolType == SRegistrySymbolTypes.Enum
                or _symbolType == SRegistrySymbolTypes.Interface
                or _symbolType == SRegistrySymbolTypes.StaticClass
                or _symbolType == SRegistrySymbolTypes.NonStaticClass
    end
    
    function Entry:IsEnumEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.Enum
    end

    function Entry:IsClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.NonStaticClass or _symbolType == SRegistrySymbolTypes.StaticClass
    end
    
    function Entry:IsStaticClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.StaticClass
    end

    function Entry:IsNonStaticClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.NonStaticClass
    end

    function Entry:IsInterfaceEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.Interface
    end

    function Entry:MarkEmployedAsParentClass()
        _setfenv(EScope.Function, self)

        _wasEmployedAsParentClassSomewhere = true
    end

    function Entry:GetWasEmployedAsParentClassSomewhere()
        _setfenv(EScope.Function, self)

        return _wasEmployedAsParentClassSomewhere
    end

    function Entry:IsRawSymbol()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.RawSymbol -- external symbols from 3rd party libs etc
    end

    function Entry:IsKeyword()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.Keyword or _symbolType == SRegistrySymbolTypes.AutorunKeyword -- [declare]/[healthcheck] and friends
    end

    function Entry:IsAutorunKeyword()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.AutorunKeyword -- [healthcheck] and friends
    end

    local Enums_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]             = "base",
        ["asBase"]           = "asBase",
        ["IsValid"]          = "IsValid",
        ["__call"]           = "__call",
        ["__index"]          = "__index",
    }
    local Enums_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local StaticClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        -- ["Instantiate"]      = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local StaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local NonStaticClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["Instantiate"]         = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local NonStaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local Interface_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["Instantiate"]         = "Instantiate",
        ["ChainSetDefaultCall"] = "ChainSetDefaultCall",
    }
    local Interfaces_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    function Entry:GetSpecialReservedNames()
        _setfenv(EScope.Function, self)
        
        if _symbolType == SRegistrySymbolTypes.Enum then
            return Enums_SystemReservedMemberNames_ForDirectMembers, Enums_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == SRegistrySymbolTypes.StaticClass then
            return StaticClasses_SystemReservedMemberNames_ForDirectMembers, StaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == SRegistrySymbolTypes.NonStaticClass then
            return NonStaticClasses_SystemReservedMemberNames_ForDirectMembers, NonStaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        if _symbolType == SRegistrySymbolTypes.Interface then
            return Interface_SystemReservedMemberNames_ForDirectMembers, Interfaces_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        _throw_exception("GetSpecialReservedNames() is not implemented for symbol-type %q (how did this even happen btw?)", _symbolType)
    end

    function Entry:ToString()
        _setfenv(EScope.Function, self)

        return "symbolType='" .. _stringify(_symbolType) .. "', symbolProto='" .. _stringify(_symbolProto) .. "', namespacePath='" .. _stringify(_namespacePath) .. "', isForPartial='" .. _stringify(_isForPartial) .. "'"
    end
    Entry.__tostring = Entry.ToString

end

--[[ NAMESPACE REGISTRY ]] --

local NamespaceRegistry = _spawnSimpleMetatable()
do
    function NamespaceRegistry:New()
        _setfenv(EScope.Function, self)

        local instance = {
            _namespaces_registry                   = {},
            _reflection_registry                   = {}, -- proto tidbits like namespace, symbol-type, is-for-partial, fields-plugger-callback etc

            _mostRecentlyDefinedSymbolProto        = nil, -- the most recently defined symbol proto           needed by ChainSetFieldPluggerFuncForNonStaticClassProto()
            _mostRecentlyDefinedSymbolProtoTidbits = nil, -- the most recently defined symbol proto-tidbits   needed by ChainSetFieldPluggerFuncForNonStaticClassProto()
        }

        return _setmetatable(instance, self)
    end

    NamespaceRegistry.Assert = {}
    NamespaceRegistry.Assert.NamespacePathIsHealthy = function(namespacePath) --@formatter:off
        _ = _type(namespacePath) == "string"                                                      or _throw_exception("the namespace-path is supposed to be a string but was given a %q", _type(namespacePath))
        _ = namespacePath == _stringTrim(namespacePath) and namespacePath ~= "" and namespacePath or _throw_exception("namespace-path %q is invalid - it must be a non-empty string without prefixed/postfixed whitespaces", namespacePath)
    end --@formatter:on
    NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol = function(symbolType)
        local isDeclarableSymbol = symbolType == SRegistrySymbolTypes.Enum
                or symbolType == SRegistrySymbolTypes.Interface
                or symbolType == SRegistrySymbolTypes.StaticClass
                or symbolType == SRegistrySymbolTypes.NonStaticClass

        _ = isDeclarableSymbol or _throw_exception("the symbol you're trying to declare (type=%q) is not a Class/Enum/Interface to be declarable - so try binding it instead!", symbolType)
    end

    NamespaceRegistry.Assert.EntryUpdateConcernsEntryWithTheSameSymbolType = function(incomingSymbolType, preExistingEntry, namespacePath)
        _ = incomingSymbolType == preExistingEntry:GetRegistrySymbolType() or _throw_exception("[NR.ASR.EUCEWTSST.010] cannot re-register namespace [%s] with type=%q as it has already been registered as symbol-type=%q", namespacePath, incomingSymbolType, preExistingEntry:GetRegistrySymbolType()) -- 10
    end

    NamespaceRegistry.Assert.EitherTheIncomingUpdateIsForPartialOrThePreexistingEntryIsPartial = function(isForPartial, preExistingEntry, sanitizedNamespacePath)
        _ = isForPartial or preExistingEntry:IsPartialEntry() or _throw_exception("[NR.ASR.ETIUIFPOTPEIP.010] namespace [%s] has already been assigned to a symbol marked as %q (did you mean to register a 'partial' symbol?)", sanitizedNamespacePath, preExistingEntry:GetRegistrySymbolType()) -- 10
    end

    NamespaceRegistry.Assert.HasNotBeenEmployedAsParentClassYet = function(preExistingEntry, sanitizedNamespacePath)
        _ = not preExistingEntry:GetWasEmployedAsParentClassSomewhere() or _throw_exception("[NR.ASR.HNBEAPCY.010] Symbol [%s] is being amended through [partial] but it was already used as a parent-symbol at least once - this is forbidden as it can lead to unexpected behaviour in runtime", sanitizedNamespacePath) -- 10
    end
    
    function NamespaceRegistry:Healthcheck(errorsAccumulatorArray)
        _setfenv(EScope.Function, self)

        -- _g.print("[NamespaceRegistry.Healthcheck.000]")
        
        _ = _type(errorsAccumulatorArray) == "table" or _throw_exception("[NR.HC.010] errorsAccumulator must be a table (got %q)", _type(errorsAccumulatorArray))
        
        for _, protoTidbits in _pairs(_namespaces_registry) do
            -- _g.print("[NamespaceRegistry.Healthcheck.010]")
            
            protoTidbits:Healthcheck(self, errorsAccumulatorArray)
        end
        
        return errorsAccumulatorArray
    end

    -- namespacer()
    function NamespaceRegistry:ChainSetFieldPluggerFuncForNonStaticClassProto(classProto, func)
        _setfenv(EScope.Function, self)

        local protoTidbits = self:TryGetProtoTidbitsViaSymbolProto(classProto)
        if protoTidbits == nil then
            _throw_exception("[NR.CSFPFFNSCP.010] cannot chain-set field-plugger-callback for a non-static-class %q because it has not been registered yet", classProto)
        end

        protoTidbits:ChainSetFieldPluggerFuncForNonStaticClassProto(func)
        
        return self
    end

    function NamespaceRegistry:GetMostRecentlyDefinedSymbolProtoAndTidbits()
        _setfenv(EScope.Function, self)

        return _mostRecentlyDefinedSymbolProto, _mostRecentlyDefinedSymbolProtoTidbits
    end
    
    function NamespaceRegistry:UpsertSymbolProtoSpecs(namespacePath, symbolType)
        _setfenv(EScope.Function, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)
        NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol(symbolType)

        local sanitizedNamespacePath, isForPartial = NamespaceRegistry.SanitizeNamespacePath_(namespacePath)

        local preExistingTidbitsEntry = _namespaces_registry[sanitizedNamespacePath]
        if preExistingTidbitsEntry == nil then -- insert new entry
            local newSymbolProto = ProtosFactory.Spawn(symbolType)

            local newProtoTidbitsEntry = Entry:New(symbolType, newSymbolProto, sanitizedNamespacePath, isForPartial)

            _mostRecentlyDefinedSymbolProto = newSymbolProto
            _mostRecentlyDefinedSymbolProtoTidbits = newProtoTidbitsEntry
            
            _reflection_registry[newSymbolProto] = newProtoTidbitsEntry
            _namespaces_registry[sanitizedNamespacePath] = newProtoTidbitsEntry

            return newSymbolProto
        end
        
        -- update existing entry (partials come here)
        NamespaceRegistry.Assert.EntryUpdateConcernsEntryWithTheSameSymbolType(symbolType, preExistingTidbitsEntry, sanitizedNamespacePath) -- 10
        NamespaceRegistry.Assert.EitherTheIncomingUpdateIsForPartialOrThePreexistingEntryIsPartial(isForPartial, preExistingTidbitsEntry, sanitizedNamespacePath) -- 10
        NamespaceRegistry.Assert.HasNotBeenEmployedAsParentClassYet(preExistingTidbitsEntry, sanitizedNamespacePath)

        if not isForPartial then -- 20
            preExistingTidbitsEntry:UnsetPartiality()
        end

        _mostRecentlyDefinedSymbolProto = preExistingTidbitsEntry:GetSymbolProto()
        _mostRecentlyDefinedSymbolProtoTidbits = preExistingTidbitsEntry

        return _mostRecentlyDefinedSymbolProto

        -- 10  notice that if the intention is to declare an extension-class then we dont care if the class already exists
        --     and its also perfectly fine if the the core class gets loaded after its associated extension classes too
        --
        -- 20  upon realizing that we are loading the core definition of a symbol-proto we need to unset the partiality flag on the proto-entry
    end

    NamespaceRegistry.PatternToDetectPartialKeywordPostfix = "%s*%[[Pp][Aa][Rr][Tt][Ii][Aa][Ll]%]%s*$"
    function NamespaceRegistry.SanitizeNamespacePath_(namespacePath)
        _setfenv(EScope.Function, NamespaceRegistry)

        local sanitized = _gsub(namespacePath, NamespaceRegistry.PatternToDetectPartialKeywordPostfix, "") --00
        local isForPartial = sanitized ~= namespacePath

        -- sanitized = _stringTrim(sanitized) noneed

        return sanitized, isForPartial

        -- 00  remove the [partial] postfix from the namespace string if it exists
    end

    NamespaceRegistry.Assert.RawSymbolNamespaceIsAvailable = function(possiblePreexistingEntry, namespacePath)
        _ = possiblePreexistingEntry == nil or _throw_exception("namespace [%s] has already been assigned to another symbol", namespacePath)
    end

    NamespaceRegistry.Assert.ProtoForRawSymbolEntryMustNotBeNil = function(rawSymbolProto)
        _ = rawSymbolProto ~= nil or _throw_exception("rawSymbolProto must not be nil")
    end

    -- used for binding external libs to a local namespace
    --
    --     _namespacer_bind("Foo.Bar",           function(x) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("[declare] [class]", function(namespace) [...] end) <- yes the raw-symbol-proto might be just a function or an int or whatever
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --     _namespacer_bind("Pavilion.Warcraft.Addons.Zen.Externals.ServiceLocators.LibStub", _libstub_service_locator)
    --
    function NamespaceRegistry:BindKeyword(keyword, rawSymbol) --@formatter:off
        _setfenv(EScope.Function, self)
        
        _ = _stringStartsWith(keyword, "[") and _stringEndsWith(keyword, "]")                                                             or _throw_exception("the keyword must be [enclosed] in brackets (got %q)", keyword)
        _ = _type(rawSymbol) == "function" or _type(rawSymbol) == "table" or _type(rawSymbol) == "string" or _type(rawSymbol) == "number" or _throw_exception("the raw-symbol must be a function, table, string or number (got %q)", _type(rawSymbol)) --@formatter:on

        self:BindImpl_(keyword, rawSymbol, SRegistrySymbolTypes.Keyword)
    end

    -- [healthcheck] uses this
    function NamespaceRegistry:BindAutorunKeyword(keyword, func) --@formatter:off
        _setfenv(EScope.Function, self)

        _ = _type(func) == "function"                                         or _throw_exception("the autorun keyword must be bound to a function (got %q)", _type(func))
        _ = _stringStartsWith(keyword, "[") and _stringEndsWith(keyword, "]") or _throw_exception("the keyword must be [enclosed] in brackets (got %q)", keyword) --@formatter:on

        self:BindImpl_(keyword, func, SRegistrySymbolTypes.AutorunKeyword)
    end

    -- todo  rename this to :BindRawSymbol() for clarity
    function NamespaceRegistry:Bind(keywordOrNamespacePath, rawSymbol) --@formatter:off
        _setfenv(EScope.Function, self)
        
        _ = rawSymbol ~= nil                          or _throw_exception("the raw-symbol must not be nil (got %q)", _type(rawSymbol))
        _ = _type(keywordOrNamespacePath) == "string" or _throw_exception("the keyword-or-namespace-path must be a string (got %q)", _type(keywordOrNamespacePath)) --@formatter:on

        self:BindImpl_(keywordOrNamespacePath, rawSymbol, SRegistrySymbolTypes.RawSymbol)
    end

    function NamespaceRegistry:BindImpl_(keywordOrNamespacePath, rawSymbol, properSymbolType)
        _setfenv(EScope.Function, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(keywordOrNamespacePath)
        NamespaceRegistry.Assert.ProtoForRawSymbolEntryMustNotBeNil(rawSymbol)

        local possiblePreexistingEntry = _namespaces_registry[keywordOrNamespacePath]

        NamespaceRegistry.Assert.RawSymbolNamespaceIsAvailable(possiblePreexistingEntry, keywordOrNamespacePath)

        local newFormalSymbolProtoEntry = Entry:New(properSymbolType, rawSymbol, keywordOrNamespacePath)

        _namespaces_registry[keywordOrNamespacePath] = newFormalSymbolProtoEntry

        if properSymbolType == SRegistrySymbolTypes.RawSymbol then
            -- no point to include [declare] and other keywords in the registry
            _reflection_registry[rawSymbol] = newFormalSymbolProtoEntry
        end
    end

    function NamespaceRegistry:UnbindKeyword(keyword)
        _setfenv(EScope.Function, self)

        local entry = _namespaces_registry[keyword]
        if entry == nil then
            return -- already unbound
        end

        local symbolType = entry:GetRegistrySymbolType()
        if symbolType ~= SRegistrySymbolTypes.Keyword and symbolType ~= SRegistrySymbolTypes.AutorunKeyword then
            _throw_exception("cannot unbind namespace %q because it is not a keyword (it is a %q)", keyword, symbolType)
        end

        _namespaces_registry[keyword] = nil
        _reflection_registry[entry:GetSymbolProto()] = nil -- remove the proto tidbits from the reflection registry
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaNamespace(namespacePath)
        _setfenv(EScope.Function, self)

        -- we intentionally omit validating the namespacepath in terms of whitespaces etc
        -- that is because this method is meant to be used by the reflection.* family of methods

        if namespacePath == nil then -- we dont want to error out in this case   this is a try-method
            return nil, nil
        end

        local entry = _namespaces_registry[namespacePath]
        if entry == nil then
            return nil, nil
        end

        return entry:GetSymbolProto(), entry:GetRegistrySymbolType()
    end

    -- importer()
    function NamespaceRegistry:Get(namespacePath, suppressExceptionIfNotFound)
        _setfenv(EScope.Function, self)

        NamespaceRegistry.Assert.NamespacePathIsHealthy(namespacePath)

        local entry = _namespaces_registry[namespacePath]
        if entry == nil then
            if suppressExceptionIfNotFound then
                return nil
            end

            _throw_exception("namespace/keyword %q has not been registered.", namespacePath) -- dont turn this into an debug.assertion   we want to know about this in production builds too
        end

        --if entry:IsPartialEntry() then -- dont   use "[healthcheck] [all]" to find out about dangling partial entries
        --    _throw_exception("namespace [%s] holds a partially-registered entry (class/enum/interface) - did you forget to load its core definition?", namespacePath)
        --end
        
        if entry:IsAutorunKeyword() then
            return entry:GetSymbolProto()() --special case for [healthcheck] and friends
        end

        return entry:GetSymbolProto()
    end

    function NamespaceRegistry:TryGetProtoTidbitsViaSymbolProto(symbolProto)
        _setfenv(EScope.Function, self)

        if symbolProto == nil then
            return nil
        end

        return _reflection_registry[symbolProto]
    end
    
    function NamespaceRegistry.HasCircularProtoDependency(mixinProtoSymbol, targetSymbolProto)
        _setfenv(EScope.Function, NamespaceRegistry)
        
        _ = _type(mixinProtoSymbol) == "table" or _throw_exception("mixinProtoSymbol must be a table but it was found to be of type %q", _type(mixinProtoSymbol))
        _ = _type(targetSymbolProto) == "table" or _throw_exception("targetSymbolProto must be a table but it was found to be of type %q", _type(targetSymbolProto))

        local protosCheckedCount = 0
        
        function impl_(mixinProtoSymbol_, targetSymbolProto_, depth_)
            if mixinProtoSymbol_ == nil then
                return false
            end

            if mixinProtoSymbol_ == targetSymbolProto_ then
                return true
            end

            if mixinProtoSymbol_.asBase == nil then
                return false
            end

            if mixinProtoSymbol_.asBase[targetSymbolProto_] ~= nil then
                return true
            end

            protosCheckedCount = protosCheckedCount + 2

            if depth_ > 30 then
                _throw_exception("recursion-depth search too deep (%s) during circular-dependency check - something feels off - possible circular dependency detected", depth_)
            end

            if protosCheckedCount > 40 then
                _throw_exception("too many protos (%s) during recursion - something feels off - possible circular dependency detected", protosCheckedCount)
            end

            if mixinProtoSymbol_.asBase ~= nil then
                for key, protoSymbol_ in _pairs(mixinProtoSymbol_.asBase) do
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
        _setfenv(EScope.Function, self)
        
        local protoTidbits = self:TryGetProtoTidbitsViaSymbolProto(targetSymbolProto) --@formatter:off
        _ = protoTidbits ~= nil            or _throw_exception("[NR.BM.000] targetSymbolProto is not a symbol-proto")
        _ = protoTidbits:CanBeSubclassed() or _throw_exception("[NR.BM.002] targetSymbolProto to be blended must be a class/interface/enum (symbol-type=%q)", protoTidbits:GetRegistrySymbolType())
        _ = _type(namedMixins) == "table"  or _throw_exception("[NR.BM.005] namedMixins must be a table")
        _ = _next(namedMixins) ~= nil      or _throw_exception("[NR.BM.010] namedMixins must not be an empty table") --@formatter:on

        local targetSymbolProto_baseProp = targetSymbolProto.base or {} -- create a .base and .asBase tables to hold per-mixin fields/methods
        local targetSymbolProto_asBaseProp = targetSymbolProto.asBase or {}

        targetSymbolProto.base = targetSymbolProto_baseProp
        targetSymbolProto.asBase = targetSymbolProto_asBaseProp

        -- for each named mixin, create a table with closures that bind the target as self
        local systemReservedMemberNames_forDirectMembers, systemReservedStaticMemberNames_forMembersOfUnderscore = protoTidbits:GetSpecialReservedNames()
        for specific_MixinNickname, specific_MixinProtoSymbol in _pairs(namedMixins) do --@formatter:off
            _ = targetSymbolProto ~= specific_MixinProtoSymbol                                                 or _throw_exception("[NR.BM.050] mixin nicknamed %q tries to add its target-symbol-proto directly into itself (how did you even manage this?)", specific_MixinNickname)
            _ = _type(specific_MixinNickname) == "string" and specific_MixinNickname ~= ""                     or _throw_exception("[NR.BM.051] mixin nicknamed %q has a nickname that is either not a string or its dud - its type is %q", specific_MixinNickname, _type(specific_MixinNickname))
            _ = _type(specific_MixinProtoSymbol) == "table"                                                    or _throw_exception("[NR.BM.052] mixin nicknamed %q has a proto-symbol that is not a table (type=%q)", specific_MixinNickname, _type(specific_MixinProtoSymbol))
            _ = not NamespaceRegistry.HasCircularProtoDependency(specific_MixinProtoSymbol, targetSymbolProto) or _throw_exception("[NR.BM.053] mixin nicknamed %q introduces a circular dependency", specific_MixinNickname)

            local mixinProtoTidbits = self:TryGetProtoTidbitsViaSymbolProto(specific_MixinProtoSymbol) -- also accounts for specific_MixinProtoSymbol being nil (nil is hard to come by but not impossible)
            _ = mixinProtoTidbits                                       ~= nil or _throw_exception("[NR.BM.060] mixin nicknamed %q is not a registered proto-symbol for a class/interface/enum", specific_MixinNickname)
            _ = _next(specific_MixinProtoSymbol)                        ~= nil or _throw_exception("[NR.BM.061] mixin nicknamed %q has dud specs (uh oh how is this even possible?)", specific_MixinNickname)
            _ = targetSymbolProto_asBaseProp[specific_MixinNickname]    == nil or _throw_exception("[NR.BM.062] mixin nicknamed %q cannot be added because another mixin has registered this nickname", specific_MixinNickname)
            _ = targetSymbolProto_asBaseProp[specific_MixinProtoSymbol] == nil or _throw_exception("[NR.BM.063] mixin nicknamed %q has already been added to the target under a different nickname", specific_MixinNickname) --@formatter:on
            _ = not mixinProtoTidbits:IsPartialEntry()                         or _throw_exception("[NR.BM.064] mixin nicknamed %q is only partially defined and cannot be blended until it is fully defined", specific_MixinNickname) --@formatter:on

            local mixinIsEnum           = mixinProtoTidbits:IsEnumEntry()
            local mixinIsInterface      = mixinProtoTidbits:IsInterfaceEntry()
            local mixinIsStaticClass    = mixinProtoTidbits:IsStaticClassEntry()
            local mixinIsNonStaticClass = mixinProtoTidbits:IsNonStaticClassEntry()
            _ = (not targetIsEnum           or mixinIsEnum           or mixinIsStaticClass) or _throw_exception("[NR.BM.070] mixin nicknamed %q (symbol-type=%s) is not an enum or a static-class - cannot mix it into an enum", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = (not targetIsInterface      or mixinIsInterface                           ) or _throw_exception("[NR.BM.071] mixin nicknamed %q (symbol-type=%s) is not an interface - cannot mix it into an interface", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = (not targetIsStaticClass    or mixinIsStaticClass    or mixinIsInterface  ) or _throw_exception("[NR.BM.072] mixin nicknamed %q (symbol-type=%s) is not a static-class or an interface - cannot mix it into a static-class", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = (not targetIsNonStaticClass or mixinIsNonStaticClass or mixinIsInterface  ) or _throw_exception("[NR.BM.073] mixin nicknamed %q (symbol-type=%s) is not a non-static-class or an interface - cannot mix it into a non-static-class", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType()) --@formatter:on

            mixinProtoTidbits:MarkEmployedAsParentClass()
            
            targetSymbolProto_asBaseProp[specific_MixinProtoSymbol] = specific_MixinProtoSymbol -- add the mixin-proto-symbol itself as the key to its own mixin-proto-symbol

            local isNamelessMixin = specific_MixinNickname == ""
            if not isNamelessMixin then
                targetSymbolProto_asBaseProp[specific_MixinNickname] = specific_MixinProtoSymbol -- completely overwrite any previous asBase[name]
            end

            for specific_MixinMemberName, specific_MixinMemberSymbol in _pairs(specific_MixinProtoSymbol) do --@formatter:off _g.print("** [" .. _g.tostring(mixinNickname) .. "] processing mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "'")
                _ = _type(specific_MixinMemberName) == "string"                          or _throw_exception("[NR.BM.080] mixin nicknamed %q has a direct-member whose name is not a string - its type is %q", _type(specific_MixinMemberName))
                _ = (specific_MixinMemberName ~= nil and specific_MixinMemberName ~= "") or _throw_exception("[NR.BM.081] mixin nicknamed %q has a member with a dud name - this is not allowed", specific_MixinNickname) --@formatter:on

                if specific_MixinMemberName == "_" then
                    -- todo   try refactor this part to just use __index with a custom look up function for the base statics and be done with it nice and easy (not sure if wow-lua indeed supports multi-mt lookups though!)
                    
                    -- blend-in all whitelisted statics ._.* from every mixin directly under targetSymbolProto._.*
                    for _staticMemberName, _staticMember in _pairs(specific_MixinMemberSymbol) do --@formatter:off
                        _ = _type(_staticMemberName) == "string"                   or _throw_exception("[NR.BM.090] static-mixin-member-name is not a string - its type is %q", _type(_staticMemberName))
                        _ = (_staticMemberName ~= nil and _staticMemberName ~= "") or _throw_exception("[NR.BM.091] statics of mixin named %q has a member with a dud name - this is not allowed", specific_MixinNickname) --@formatter:on

                        -- must not let the mixins overwrite the default fields
                        local hasGreenName = systemReservedStaticMemberNames_forMembersOfUnderscore[_staticMemberName] == nil
                        if hasGreenName then
                            targetSymbolProto._[_staticMemberName] = _staticMember -- static member
                        end
                    end
                else
                    -- blend-in all whitelisted non-statics-methods and static-fields from every mixin both directly under targetSymbolProto.* and under target.base.*

                    local isFunction = _type(specific_MixinMemberSymbol) == "function"
                    local hasBaseRelatedName = specific_MixinMemberName == "base" or specific_MixinMemberName == "asBase"
                    _ = (not isFunction or not hasBaseRelatedName) or _throw_exception("mixin-member %q is a function and yet it is named 'base'/'asBase' - this is so odd it's treated as an error", specific_MixinMemberName)

                    -- _g.print("** [" .. _g.tostring(mixinNickname) .. "] processing mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "'")
                    
                    local hasGreenName = systemReservedMemberNames_forDirectMembers[specific_MixinMemberName] == nil
                    if hasGreenName then
                        -- _g.print("****** [" .. _g.tostring(specific_MixinNickname) .. "] adding mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "' to targetSymbolProto")
                        
                        targetSymbolProto[specific_MixinMemberName] = specific_MixinMemberSymbol -- combine all members/methods provided by mixins directly under proto.*     later mixins override earlier ones    

                        targetSymbolProto_baseProp[specific_MixinMemberName] = specific_MixinMemberSymbol
                        targetSymbolProto_asBaseProp[specific_MixinNickname][specific_MixinMemberName] = specific_MixinMemberSymbol -- append methods provided by a specific mixin under proto.asBase.<specific-mixin-nickname>.<specific-member-name>
                    -- else
                    --     _g.print("****** [" .. _g.tostring(mixinNickname) .. "] skipping mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "' because it is a system-reserved name")
                    end
                end
            end
        end

        return targetSymbolProto
    end

    function NamespaceRegistry:PrintOut()
        _setfenv(EScope.Function, self)

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

--[[ HEALTH-CHECKER ]] --

local HealthChecker = _spawnSimpleMetatable()
do
    function HealthChecker:New()
        _setfenv(EScope.Function, self)

        local instance = { }

        return _setmetatable(instance, self)
    end
    
    function HealthChecker:Run(namespaceRegistry)
        _setfenv(EScope.Function, self)

        _ = _type(namespaceRegistry) == "table" or _throw_exception("[NR.HCR.RN.010] namespaceRegistry must be a table but it was found to be of type %q", _type(namespaceRegistry))
        
        local errorsAccumulatorArray = {}
        
        namespaceRegistry:Healthcheck(errorsAccumulatorArray)
        -- add more healthchecks here in the future ...
        
        if _next(errorsAccumulatorArray) then
            _throw_exception("[NR.HCR.RN.020] Healthcheck failed with the following errors:\n\n%s", _tblConcat(errorsAccumulatorArray, "\n\n"))
        end
    end
end

--[[ SINGLETON INSTANCES ]] --

HealthCheckerSingleton = HealthChecker:New()
NamespaceRegistrySingleton = NamespaceRegistry:New()

--[[ EXPORTED SYMBOLS ]] --
do
    -- using "x.y.z"   todo  rename pvl_* to lua_zen_sharp_* 
    _g.pvl_namespacer_get = function(namespacePath)
        --    todo   in production builds these symbols should get obfuscated to something like  _g.ppzcn__<some_guid_here>__get
        return NamespaceRegistrySingleton:Get(namespacePath)
    end

    -- using "[declare]" "x.y.z"
    _g.pvl_namespacer_add = function(namespacePath)
        return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.NonStaticClass)
    end

    -- namespacer_binder()
    _g.pvl_namespacer_bind = function(namespacePath, externalSymbol)
        return NamespaceRegistrySingleton:Bind(namespacePath, externalSymbol)
    end
end


NamespaceRegistrySingleton:Bind("System.Namespacer", NamespaceRegistrySingleton)

-- @formatter:off   todo   also introduce [declare] [partial] [declare] [testbed] etc and remove the [Partial] postfix-technique on the namespace path since it will no longer be needed 
NamespaceRegistrySingleton:BindKeyword("[declare]",                   function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [enum]",            function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.Enum                 ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [class]",           function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [interface]",       function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.Interface            ) end)

NamespaceRegistrySingleton:BindKeyword("[declare] [static]",          function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [static] [class]",  function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)

local function declareSymbolAndReturnBlenderCallback(namespacePath, symbolType)
    local protoEntrySnapshot = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, symbolType)

    return function(namedMixinsToAdd) return NamespaceRegistrySingleton:BlendMixins(protoEntrySnapshot, namedMixinsToAdd) end -- currying essentially
end

NamespaceRegistrySingleton:BindKeyword("[declare] [blend]",                       function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [enum] [blend]",                function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.Enum                 ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [class] [blend]",               function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [interface] [blend]",           function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.Interface            ) end)

NamespaceRegistrySingleton:BindKeyword("[declare] [static] [blend]",              function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)
NamespaceRegistrySingleton:BindKeyword("[declare] [static] [class] [blend]",      function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)

NamespaceRegistrySingleton:BindAutorunKeyword("[healthcheck] [all]", function() HealthCheckerSingleton:Run(NamespaceRegistrySingleton) end)
-- @formatter:on

local AdvertisedSRegistrySymbolTypes = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs("System.Namespacer.SRegistrySymbolTypes", SRegistrySymbolTypes.Enum)
for k, v in _pairs(SRegistrySymbolTypes) do -- this is the only way to get the enum values to be advertised to the outside world
    AdvertisedSRegistrySymbolTypes[k] = v
end

-- no need for this   the standardized enum metatable is already in place and it does the same job just fine
--
-- _setmetatable(AdvertisedSRegistrySymbolTypes, _getmetatable(SRegistrySymbolTypes))
