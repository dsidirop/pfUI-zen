local EScope = { EGlobal = 0, EFunction = 1 }

local _g, _assert, _rawset, _tableInsert, _tableConcat, _tableSort, _rawequal, _type, _getn, _gsub, _pairs, _ipairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _, _next = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(EScope.Function, {})

    local _next = _assert(_g.next)
    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _gsub = _assert(_g.string.gsub)
    local _pairs = _assert(_g.pairs)
    local _ipairs = _assert(_g.ipairs)
    local _rawset = _assert(_g.rawset)
    local _unpack = _assert(_g.unpack)
    local _strlen = _assert(_g.string.len)
    local _strsub = _assert(_g.string.sub)
    local _format = _assert(_g.string.format)
    local _strfind = _assert(_g.string.find)
    local _rawequal = _assert(_g.rawequal)
    local _stringify = _assert(_g.tostring)
    local _tableSort = _assert(_g.table.sort)
    local _debugstack = _assert(_g.debugstack)
    local _tableConcat = _assert(_g.table.concat)
    local _tableInsert = _assert(_g.table.insert)
    local _tableRemove = _assert(_g.table.remove)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _g, _assert, _rawset, _tableInsert, _tableConcat, _tableSort, _rawequal, _type, _getn, _gsub, _pairs, _ipairs, _tableRemove, _unpack, _format, _strlen, _strsub, _strfind, _stringify, _setfenv, _debugstack, _setmetatable, _getmetatable, _next
end)()

if _g["ZENSHARP:USING"] then
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

local function _stringJoinTableValues(dictionary, separator)
    _ = _type(dictionary) == "table" or _throw_exception("dictionary must be a table")
    _ = _type(separator) == "string" or _throw_exception("separator must be a string")

    local result = {}
    for _, v in _ipairs(dictionary) do
        _tableInsert(result, _stringify(v))
    end

    return _tableConcat(result, separator)
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

local function _tryPopMethodAttributesOfType(pendingAttributesArraySnapshot, desiredType) --@formatter:off
    _ = _type(desiredType) == "string"                   or _throw_exception("desiredType must be a string")
    _ = _type(pendingAttributesArraySnapshot) == "table" or _throw_exception("pendingAttributesSnapshot must be a table") --@formatter:on

    local lastMatchingAttributeSpecs
    for i, attributeSpecs in _ipairs(pendingAttributesArraySnapshot) do
        if attributeSpecs:GetType() == desiredType then
            lastMatchingAttributeSpecs = attributeSpecs
            _tableRemove(pendingAttributesArraySnapshot, i)
        end
    end

    return lastMatchingAttributeSpecs
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
local AllAbstractMethods = {}
local SRegistrySymbolTypes
local SMethodAttributeTypes
local HealthCheckerSingleton
local NamespaceRegistrySingleton

--[[ METHOD-ATTRIBUTE-SPECS ]]

local MethodAttributeSpecs = _spawnSimpleMetatable()
do
    function MethodAttributeSpecs:NewForAbstract(targetMethodName)
        _setfenv(EScope.Function, self)

        local latestProto, latestTidbits = NamespaceRegistrySingleton:GetMostRecentlyDefinedSymbolProtoAndTidbits()

        _ = latestProto ~= nil                                             or _throw_exception("[NR.MA.NFABST.CTOR.010] Cannot process 'abstract' attribute because the latest symbol proto is nil (did you forget to define a symbol in this file?)")
        _ = latestTidbits:IsAbstractClassEntry()                           or _throw_exception("[NR.MA.NFABST.CTOR.015] Cannot apply 'abstract' attribute on [%s:%s()] because the target is not an abstract class (did you forget to define it as an abstract class?)", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(latestProto)), _stringify(targetMethodName))
        _ = _type(targetMethodName) == "string" and targetMethodName ~= "" or _throw_exception("[NR.MA.NFABST.CTOR.020] targetMethodName must be a non-dud string ( got %q )", _stringify(_type(targetMethodName)))
        _ = latestProto[targetMethodName] == nil                           or _throw_exception("[NR.MA.NFABST.CTOR.030] Cannot apply 'abstract' attribute on [%s:%s()] because it is already defined (defined in the parent class maybe?)", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(latestProto)), _stringify(targetMethodName)) --@formatter:on

        local instance = {
            _attributeType    = SMethodAttributeTypes.Abstract,
            
            _targetProto      = latestProto,
            _targetMethodName = targetMethodName,
        }

        return _setmetatable(instance, self)
    end

    function MethodAttributeSpecs:NewForAutocall(targetMethodName) --@formatter:off
        _setfenv(EScope.Function, self)

        local latestProto, latestTidbits = NamespaceRegistrySingleton:GetMostRecentlyDefinedSymbolProtoAndTidbits()

        _ = latestProto ~= nil                                             or _throw_exception("[NR.MA.NFAUTO.CTOR.010] Cannot process 'autocall' attribute because the latest symbol proto is nil (did you forget to define a symbol in this file?)")
        _ = latestTidbits:IsClassEntry()                                   or _throw_exception("[NR.MA.NFABST.CTOR.015] Cannot apply 'autocall' attribute on [%s:%s()] because the target is not an interface", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(latestProto)), _stringify(targetMethodName))
        _ = _type(targetMethodName) == "string" and targetMethodName ~= "" or _throw_exception("[NR.MA.NFAUTO.CTOR.020] targetMethodName must be a non-dud string ( got %q )", _stringify(_type(targetMethodName))) --@formatter:on

        latestProto[targetMethodName] = nil --00 crucial

        local instance = {
            _attributeType    = SMethodAttributeTypes.Autocall,
            
            _targetProto      = latestProto,
            _targetMethodName = targetMethodName,
        }

        return _setmetatable(instance, self)
        
        --00   absolutely vital to remove any pre-defined method from any parent class so that the __newindex will be triggered
        --
        --     using "[autocall]" "Ping" -- this will set Class.Ping = nil so that ClassL:Ping() below will trigger the __newindex
        --     function Class:Ping()
        --        return "ping"
        --     end
    end

    function MethodAttributeSpecs:IsAbstract()
        _setfenv(EScope.Function, self)

        return self._attributeType == SMethodAttributeTypes.Abstract
    end

    function MethodAttributeSpecs:IsAutocall()
        _setfenv(EScope.Function, self)

        return self._attributeType == SMethodAttributeTypes.Autocall
    end

    function MethodAttributeSpecs:GetType()
        _setfenv(EScope.Function, self)

        return _attributeType
    end

    function MethodAttributeSpecs:GetTargetProto()
        _setfenv(EScope.Function, self)
    
        return _targetProto
    end

    function MethodAttributeSpecs:GetTargetMethodName()
        _setfenv(EScope.Function, self)

        return _targetMethodName
    end

    function MethodAttributeSpecs:__tostring()
        _setfenv(EScope.Function, self)

        return _attributeType
    end
end

--[[ PROTO FACTORIES ]]--

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
        CommonMetaTable_ForAllInterfaceProtos = CommonMetaTable_ForAllInterfaceProtos or _spawnSimpleMetatable({
            __newindex = InterfacesProtoFactory.StandardNewIndexFunc_,
        })

        local newInterfaceProto = _spawnSimpleMetatable()

        return _setmetatable(newInterfaceProto, CommonMetaTable_ForAllInterfaceProtos)

        -- 00  __index needs to be preset like this   otherwise we run into errors in runtime
    end
    
    function InterfacesProtoFactory.StandardNewIndexFunc_(proto, key, value)
        _setfenv(EScope.Function, proto)

        -- _g.print(_format("[InterfacesProtoFactory.__newindex] New method added on interface-proto %q with key %q and value %q", _stringify(proto), _stringify(key), _stringify(value)))

        if key == "base" or key == "asBase" or _type(value) ~= "function" then -- .base and .asBase go here
            _rawset(proto, key, value)
            return
        end

        local autoGeneratedDudInterfaceMethod = function(self)
            local Throw = NamespaceRegistrySingleton:Get("System.Exceptions.Throw")
            local NotImplementedException = NamespaceRegistrySingleton:Get("System.Exceptions.NotImplementedException")

            local associatedClassNamespace = NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(self)
            local associatedInterfaceNamespace = NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(proto)

            Throw(NotImplementedException:New(
                    associatedClassNamespace == nil
                            and _format("Interface method [%s:%s()] is not implemented (did you forget to override it?)", _stringify(associatedInterfaceNamespace), _stringify(key))
                            or _format("Interface method [%s:%s()] is not implemented in [%s] (did you forget to override it?)", _stringify(associatedInterfaceNamespace), _stringify(key), _stringify(associatedClassNamespace))
            ))
        end

        AllAbstractMethods[autoGeneratedDudInterfaceMethod] = true 

        _rawset(proto, key, autoGeneratedDudInterfaceMethod)
    end
end

local StaticClassProtoFactory = {}
do
    local CommonMetaTable_ForAllStaticClassProtos

    function StaticClassProtoFactory.Spawn()
        CommonMetaTable_ForAllStaticClassProtos = CommonMetaTable_ForAllStaticClassProtos or _spawnSimpleMetatable({
            __call = StaticClassProtoFactory.OnProtoCalledAsFunction_, -- needed by static-class utilities like Throw.__Call__() so as for them to work properly
            __newindex = StaticClassProtoFactory.StandardNewIndexFunc_,
        })

        local newStaticClassProto = _spawnSimpleMetatable({
            -- Instantiate         = StaticClassProtoFactory.StandardInstantiator_, -- no point for static-classes    
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

    function StaticClassProtoFactory.StandardNewIndexFunc_(classProto, key, value)
        _setfenv(EScope.Function, StaticClassProtoFactory)

        local pendingAttributesArraySnapshot = NamespaceRegistrySingleton:PopAllPendingAttributes()
        _ = pendingAttributesArraySnapshot == nil or (key ~= "base" and key ~= "asBase" and _type(value) == "function") or _throw_exception("[NR.NSCPF.SCPF.SNIFFNSC.010] Cannot apply attributes on .base or .asBase or to a member that is not a function (member=[%s:%s()])", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key))

        if pendingAttributesArraySnapshot == nil or key == "base" or key == "asBase" or _type(value) ~= "function" then
            _rawset(classProto, key, value)
            return
        end

        local autocallAttributeSpecs = _tryPopMethodAttributesOfType(pendingAttributesArraySnapshot, SMethodAttributeTypes.Autocall)
        if autocallAttributeSpecs ~= nil then
            _ = autocallAttributeSpecs:GetTargetProto() == classProto and autocallAttributeSpecs:GetTargetMethodName() == key or _throw_exception("[NR.NSCPF.SCPF.SNIFFNSC.020] Autocall attribute for [%s:%s()] is not applicable to [%s:%s()]", --@formatter:off
                _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(autocallAttributeSpecs:GetTargetProto())), _stringify(autocallAttributeSpecs:GetTargetMethodName()),
                _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)),                              _stringify(key)
            ) --@formatter:on

            classProto.__Call__ = value
            _rawset(classProto, key, value)
        end

        if _next(pendingAttributesArraySnapshot) ~= nil then
            _throw_exception("[NR.NSCPF.SCPF.SNIFFNSC.030] The following attributes for [%s:%s()] are not supported:\n\n%s", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key), "- " .. _stringify(_stringJoinTableValues(pendingAttributesArraySnapshot, "\n- ")))
        end
    end
end

local NonStaticClassProtoFactory = {} -- serves both non-static-classes and abstract-classes too!
do
    local CachedMetaTable_ForAllAbstractClassProtos
    local CachedMetaTable_ForAllNonStaticClassProtos -- this can be shared really    saves us some loading time and memory too

    function NonStaticClassProtoFactory.Spawn(isAbstract)
        CachedMetaTable_ForAllAbstractClassProtos = CachedMetaTable_ForAllAbstractClassProtos or _spawnSimpleMetatable({
            New         = NonStaticClassProtoFactory.StandardDefaultConstructor_,
            Instantiate = NonStaticClassProtoFactory.StandardInstantiator_,

            __newindex = NonStaticClassProtoFactory.StandardNewIndexFunc_ForAbstractClasses_
        })

        CachedMetaTable_ForAllNonStaticClassProtos = CachedMetaTable_ForAllNonStaticClassProtos or _spawnSimpleMetatable({
            New         = NonStaticClassProtoFactory.StandardDefaultConstructor_,
            Instantiate = NonStaticClassProtoFactory.StandardInstantiator_,

            __newindex = NonStaticClassProtoFactory.StandardNewIndexFunc_ForNonStaticClasses_
        })

        local newClassProto = _spawnSimpleMetatable({
            --  by convention static-utility-methods of instantiatable-classes are to be hosted under 'Class._.*'
            ToString = NonStaticClassProtoFactory.Standard_ToStringMethod,

            _          = { },
            __call     = not isAbstract and NonStaticClassProtoFactory.OnProtoOrInstanceCalledAsFunction_ or nil, --00 must be here
            __tostring = NonStaticClassProtoFactory.Standard__tostring
        })

        return _setmetatable(newClassProto, isAbstract
                and CachedMetaTable_ForAllAbstractClassProtos
                or CachedMetaTable_ForAllNonStaticClassProtos
        )

        -- 00   based on practical experiments it seems that in wow-lua the __call function doesnt work if we place it
        --      in CachedMetaTable_ForAllNonStaticClassProtos    but it does work if it is placed directly in newClassProto
        --
        --      also note that abstract classes dont need the __call defined because that is only relevant for non-abstract classes
        --      same holds for __tostring in the future
    end

    function NonStaticClassProtoFactory.StandardNewIndexFunc_ForAbstractClasses_(classProto, key, value)
        _setfenv(EScope.Function, NonStaticClassProtoFactory)

        local pendingAttributesArraySnapshot = NamespaceRegistrySingleton:PopAllPendingAttributes()
        
        _ = pendingAttributesArraySnapshot == nil or _type(value) == "function" or _throw_exception("[NR.NSCPF.SNIF.FAC.010] Abstract class [%s] supports attributes on functions but member %q is not a function", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key))

        if pendingAttributesArraySnapshot == nil or key == "base" or key == "asBase" or _type(value) ~= "function" then
            _rawset(classProto, key, value)
            return
        end

        local isMethodMarkedAsAbstract = _tryPopMethodAttributesOfType(pendingAttributesArraySnapshot, SMethodAttributeTypes.Abstract) ~= nil

        if isMethodMarkedAsAbstract then
            local autoGeneratedAbstractMethod = function(self)
                local Throw = NamespaceRegistrySingleton:Get("System.Exceptions.Throw")
                local NotImplementedException = NamespaceRegistrySingleton:Get("System.Exceptions.NotImplementedException")
                
                local associatedClassNamespace = NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(self)
                local associatedAbstractClassNamespace = NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)
                
                Throw(NotImplementedException:New(
                        associatedClassNamespace == nil
                                and _format("[NR.NSCPF.SNIF.FAC.020] Abstract method [%s:%s()] is not implemented (did you forget to override it?)", _stringify(associatedAbstractClassNamespace), _stringify(key))
                                or _format("[NR.NSCPF.SNIF.FAC.025] Abstract method [%s:%s()] is not implemented in [%s] (did you forget to override it?)", _stringify(associatedAbstractClassNamespace), _stringify(key), _stringify(associatedClassNamespace))
                ))
            end

            AllAbstractMethods[autoGeneratedAbstractMethod] = true
            
            _rawset(classProto, key, autoGeneratedAbstractMethod)
        end
        
        if _next(pendingAttributesArraySnapshot) ~= nil then
            _throw_exception("[NR.NSCPF.SNIF.FAC.030] The following attributes for [%s:%s()] are not supported:\n\n%s", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key), "- " .. _stringify(_stringJoinTableValues(pendingAttributesArraySnapshot, "\n- ")))
        end
    end

    function NonStaticClassProtoFactory.StandardNewIndexFunc_ForNonStaticClasses_(classProto, key, value)
        _setfenv(EScope.Function, NonStaticClassProtoFactory)

        local pendingAttributesArraySnapshot = NamespaceRegistrySingleton:PopAllPendingAttributes()
        _ = pendingAttributesArraySnapshot == nil or (key ~= "base" and key ~= "asBase" and _type(value) == "function") or _throw_exception("[NR.NSCPF.SNIF.FNSC.010] Cannot apply attributes on .base or .asBase or to a member that is not a function (member=[%s:%s()])", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key))

        if pendingAttributesArraySnapshot == nil or key == "base" or key == "asBase" or _type(value) ~= "function" then
            _rawset(classProto, key, value)
            return
        end

        local autocallAttributeSpecs = _tryPopMethodAttributesOfType(pendingAttributesArraySnapshot, SMethodAttributeTypes.Autocall)
        if autocallAttributeSpecs ~= nil then
            _ = autocallAttributeSpecs:GetTargetProto() == classProto and autocallAttributeSpecs:GetTargetMethodName() == key or _throw_exception("[NR.NSCPF.SNIF.FNSC.020] Autocall attribute for [%s:%s()] is not applicable to [%s:%s()]", --@formatter:off
                _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(autocallAttributeSpecs:GetTargetProto())), _stringify(autocallAttributeSpecs:GetTargetMethodName()),
                _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)),                              _stringify(key)
            ) --@formatter:on

            classProto.__call = value
            _rawset(classProto, key, value)
        end

        if _next(pendingAttributesArraySnapshot) ~= nil then
            _throw_exception("[NR.NSCPF.SNIF.FNSC.030] The following attributes for [%s:%s()] are not supported:\n\n%s", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProto)), _stringify(key), "- " .. _stringify(_stringJoinTableValues(pendingAttributesArraySnapshot, "\n- ")))
        end
    end

    function NonStaticClassProtoFactory.OnProtoOrInstanceCalledAsFunction_(classProtoOrInstance, ...)
        local variadicsArray = arg
        local ownNewFuncSnapshot = classProtoOrInstance.New --         classes (both static and non-static) are expected to define these
        local ownCallFuncSnapshot = classProtoOrInstance.__Call__ --   as :New() and :__Call__() respectively  ( not as .New() or .__Call__()! )

        local hasConstructorFunction = _type(ownNewFuncSnapshot) == "function"
        local hasImplicitCallFunction = _type(ownCallFuncSnapshot) == "function"
        _ = hasConstructorFunction or hasImplicitCallFunction or _throw_exception("[NR.NSCPF.OPOICAF.010] Cannot make default-call [%s()] because the symbol lacks both methods :New() and :__Call__()", _stringify(NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classProtoOrInstance)))

        if variadicsArray ~= nil then
            variadicsArray = _unpack(variadicsArray)
        end

        if hasImplicitCallFunction then
            -- has priority over :new()
            return ownCallFuncSnapshot( -- 00
                    classProtoOrInstance, -- vital to pass the classproto/instance to the call-function
                    variadicsArray
            )
        end

        return ownNewFuncSnapshot(
                classProtoOrInstance, -- vital to pass the classproto/instance to the call-function
                variadicsArray
        )

        -- 00  if both :New(...) and :__Call__() are defined then :__Call__() takes precedence
    end

    function NonStaticClassProtoFactory.StandardDefaultConstructor_(self)       
        return self:Instantiate()
    end

    function NonStaticClassProtoFactory.Standard_ToStringMethod(classInstance)
        return NamespaceRegistrySingleton:TryGetNamespaceIfInstanceOrProto(classInstance)
    end

    function NonStaticClassProtoFactory.Standard__tostring(classInstance)
        local variadicsArray = arg
        local ownToStringFunc = classInstance.ToString

        if _type(ownToStringFunc) == "function" then
            if variadicsArray ~= nil then
                variadicsArray = _unpack(variadicsArray)
            end

            return _stringify(ownToStringFunc( -- 00
                classInstance, -- vital to pass the classproto/instance to the call-function
                variadicsArray
            ))
        end

        return "" --10 

        -- 00  if both :New(...) and :__Call__() are defined then :__Call__() takes precedence
        -- 10  should be impossible but just in case   we cannot use _stringify() here because it will cause an infinite recursion
    end

    function NonStaticClassProtoFactory.StandardInstantiator_(classProtoOrInstanceBeingEnriched) -- @formatter:off
        _setfenv(EScope.Function, NonStaticClassProtoFactory)

        _ = _type(classProtoOrInstanceBeingEnriched) == "table" or _throw_exception("[NR.NSCPF.SI.010] classProtoOrInstance was expected to be a table") -- @formatter:on

        local protoTidbits = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(classProtoOrInstanceBeingEnriched)
        if protoTidbits == nil then
            -- in this scenario we are dealing with the "instance-being-enriched" case
            --
            -- the :Instantiate() was called as newInstance:Instantiate() which is a clear sign that the callstack can be traced back to a
            -- sub-class constructor so we should skip creating a new instance because the instance has already been created by the sub-class constructor

            return classProtoOrInstanceBeingEnriched
        end

        _ = not protoTidbits:IsAbstractClassEntry() or _throw_exception("[NR.NSCPF.SI.020] [%s] is an abstract class and may not be instantiated directly", _stringify(protoTidbits:GetNamespace()))

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
                if mixinProtoTidbits ~= nil and (mixinProtoTidbits:IsNonStaticClassEntry() or mixinProtoTidbits:IsAbstractClassEntry()) then
                    upcomingInstance = NonStaticClassProtoFactory.EnrichInstanceWithFieldsOfBaseClassesAndFinallyWithFieldsOfTheClassItself(mixinProto, mixinProtoTidbits, upcomingInstance) -- vital order    depth first
                end

            end
        end

        -- must be last    finally we can enrich the instance with the fields of the class itself if it has any in case of
        -- overlaps with base-classes we want the fields of this child-class to prevail over the ones of the parent-base-classes
        return protoTidbits:GetFieldPluggerCallbackFunc()(upcomingInstance)
    end
end

SRegistrySymbolTypes = EnumsProtoFactory.Spawn()
do --@formatter:off
    SRegistrySymbolTypes.Enum = "enum"
    SRegistrySymbolTypes.Interface = "interface"
    SRegistrySymbolTypes.StaticClass = "static-class"
    SRegistrySymbolTypes.AbstractClass = "abstract-class"
    SRegistrySymbolTypes.NonStaticClass = "non-static-class"

    SRegistrySymbolTypes.Keyword = "keyword" --                 [declare]* and friends
    SRegistrySymbolTypes.AutorunKeyword = "autorun-keyword" --  [healthcheck]* and friends

    SRegistrySymbolTypes.RawSymbol = "raw-symbol" --  external libraries from third party devs that are given an internal namespace (think of this like C# binding to java or swift libs)
end --@formatter:off

--[[ METHOD ATTRIBUTES ]]--

SMethodAttributeTypes = EnumsProtoFactory.Spawn()
do --@formatter:off
    SMethodAttributeTypes.Abstract = "abstract"
    SMethodAttributeTypes.Autocall = "autocall"
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
            return NonStaticClassProtoFactory.Spawn(false)
        end

        if symbolType == SRegistrySymbolTypes.AbstractClass then
            return NonStaticClassProtoFactory.Spawn(true)
        end

        if symbolType == SRegistrySymbolTypes.Interface then
            return InterfacesProtoFactory.Spawn()
        end

        return {} -- raw-3rd-party-symbols and keywords
    end
end

--[[ PROTO-SYMBOLS TIDBITS ]]--

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
            _fieldPluggerCallbackFunc = (symbolType == SRegistrySymbolTypes.NonStaticClass or symbolType == SRegistrySymbolTypes.AbstractClass)
                    and _dudFieldPluggerFunc  -- placeholder
                    or nil,

            _wasAlreadyHealthChecked           = false,
            _wasEmployedAsParentClassSomewhere = false,
        }

        _setmetatable(instance, self)

        return instance
    end

    function Entry:WasAlreadyHealthChecked()
        _setfenv(EScope.Function, self)
        
        return _wasAlreadyHealthChecked
    end

    function Entry:Healthcheck(namespaceRegistry, optionalErrorsAccumulatorArray)
        _setfenv(EScope.Function, self)

        -- _g.print("[Entry.Healthcheck.000] namespacePath=" .. _namespacePath)

        _ = _type(_namespacePath) == "string" or _throw_exception("[NR.ENT.HC.010] namespacePath must be a string (got %q - how did this happen?)", _type(_namespacePath))
        _ = _namespacePath ~= "" or _throw_exception("[NR.ENT.HC.015] namespacePath must be a non-dud string (how did this happen?)")
        _ = _symbolType ~= nil or _throw_exception("[NR.ENT.HC.020] symbolType must not be nil (namespace=[%s] - how did this happen?)", _stringify(_namespacePath))
        _ = _symbolProto ~= nil or _throw_exception("[NR.ENT.HC.030] symbolProto must not be nil (namespace=[%s] - how did this happen?)", _stringify(_namespacePath))

        self:UnwireNewIndexInterception()
        
        local errorsAccumulatorArray = optionalErrorsAccumulatorArray or {}

        self:HealthcheckPartiality_(errorsAccumulatorArray)
        self:HealthcheckInheritance_(namespaceRegistry, errorsAccumulatorArray)
        
        _wasAlreadyHealthChecked = true

        return errorsAccumulatorArray
    end

    function Entry:UnwireNewIndexInterception()
        _setfenv(EScope.Function, self)
        
        if _symbolType ~= SRegistrySymbolTypes.Interface and _symbolType ~= SRegistrySymbolTypes.AbstractClass and _symbolType ~= SRegistrySymbolTypes.NonStaticClass then
            return
        end
        
        _symbolProto.__newindex = nil
    end

    function Entry:HealthcheckPartiality_(errorsAccumulatorArray)
        _setfenv(EScope.Function, self)

        if _isForPartial then
            _tableInsert(errorsAccumulatorArray, _format("- [NR.ENT.HCP.010] symbol [%s] is still partial - did you forget to add its core definition to finalize it?", _namespacePath))
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
                if entry ~= nil and (entry:IsAbstractClassEntry() or entry:IsInterfaceEntry()) then
                    for protoMethodName, protoMethod in _pairs(_symbolProto) do
                        if AllAbstractMethods[protoMethod] ~= nil then
                            _tableInsert(missingMethods, "      - [" .. entry:GetNamespace() .. ":" .. protoMethodName .. "()]")
                        end
                    end
                end
            end
        end

        if _next(missingMethods) then
            _tableInsert(errorsAccumulatorArray, _format("- [NR.ENT.HCI.010] class [%s] lacks implementations for the following method(s):\n\n%s\n", _namespacePath, _tableConcat(missingMethods, "\n")))
        end
    end

    function Entry:GetFieldPluggerCallbackFunc()
        _setfenv(EScope.Function, self)

        _ = (_symbolType == SRegistrySymbolTypes.NonStaticClass or _symbolType == SRegistrySymbolTypes.AbstractClass) or _throw_exception("[NR.ENT.GFPCF.010] trying to get the field-plugger-func makes sense for non-static-classes and abstract-classes but the proto of [%s] is of type %q", _namespacePath, _symbolType)

        return _fieldPluggerCallbackFunc
    end

    function Entry:ChainSetFieldPluggerFuncForNonStaticClassProto(func) -- @formatter:off
        _setfenv(EScope.Function, self)

        _ = _type(func) == "function"                                                                                 or _throw_exception("[NR.ENT.CSFPFFNSCP.010] the field-plugger-callback must be a function (got %q)", _type(func))
        _ = (_symbolType == SRegistrySymbolTypes.NonStaticClass or _symbolType == SRegistrySymbolTypes.AbstractClass) or _throw_exception("[NR.ENT.CSFPFFNSCP.020] setting a field-plugger-callback makes sense only for non-static-classes and abstract-classes but the proto of [%s] is of type %q", _namespacePath, _symbolType) -- @formatter:on

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
                or _symbolType == SRegistrySymbolTypes.AbstractClass
                or _symbolType == SRegistrySymbolTypes.NonStaticClass
    end

    function Entry:IsEnumEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.Enum
    end

    function Entry:IsClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.StaticClass
            or _symbolType == SRegistrySymbolTypes.AbstractClass
            or _symbolType == SRegistrySymbolTypes.NonStaticClass
    end

    function Entry:IsStaticClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.StaticClass
    end

    function Entry:IsNonStaticClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.NonStaticClass
    end

    function Entry:IsAbstractClassEntry()
        _setfenv(EScope.Function, self)

        return _symbolType == SRegistrySymbolTypes.AbstractClass
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
    }
    local StaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local NonStaticClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["Instantiate"]         = "Instantiate",
    }
    local NonStaticClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local Interface_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["Instantiate"]         = "Instantiate",
    }
    local Interfaces_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
    }

    local AbstractClasses_SystemReservedMemberNames_ForDirectMembers = {
        ["base"]                = "base",
        ["asBase"]              = "asBase",
        ["__call"]              = "__call",
        ["__index"]             = "__index",
        ["Instantiate"]         = "Instantiate",
        
    }
    local AbstractClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore = {
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

        if _symbolType == SRegistrySymbolTypes.AbstractClass then
            return AbstractClasses_SystemReservedMemberNames_ForDirectMembers, AbstractClasses_SystemReservedStaticMemberNames_ForMembersOfUnderscore
        end

        _throw_exception("GetSpecialReservedNames() is not implemented for symbol-type %q (how did this even happen btw?)", _symbolType)
    end

    function Entry:ToString()
        _setfenv(EScope.Function, self)

        return "symbolType='" .. _stringify(_symbolType) .. "', symbolProto='" .. _stringify(_symbolProto) .. "', namespacePath='" .. _stringify(_namespacePath) .. "', isForPartial='" .. _stringify(_isForPartial) .. "'"
    end
    Entry.__tostring = Entry.ToString

end

--[[ NAMESPACE REGISTRY ]]--

local NamespaceRegistry = _spawnSimpleMetatable()
do
    function NamespaceRegistry:New()
        _setfenv(EScope.Function, self)

        local instance = {
            _pendingAttributes                     = nil,
            _namespaces_registry                   = {},
            _reflection_registry                   = {}, -- proto tidbits like namespace, symbol-type, is-for-partial, fields-plugger-callback etc
            _mostRecentlyDefinedSymbolProto        = nil, -- the most recently defined symbol proto           needed by ChainSetFieldPluggerFuncForNonStaticClassProto()
            _mostRecentlyDefinedSymbolProtoTidbits = nil, -- the most recently defined symbol proto-tidbits   needed by ChainSetFieldPluggerFuncForNonStaticClassProto()
        }

        return _setmetatable(instance, self)
    end

    NamespaceRegistry.Assert = {}
    NamespaceRegistry.Assert.NoStrayPendingAttributes = function()
        _ = NamespaceRegistrySingleton:PopAllPendingAttributes() == nil or _throw_exception("[NR.ASR.NSPA.010] There are stray attributes that were not applied to any symbol - did you forget to apply them?")
    end
    NamespaceRegistry.Assert.NamespacePathIsHealthy = function(namespacePath) --@formatter:off
        _ = _type(namespacePath) == "string"                                                      or _throw_exception("[NR.ASR.NPIH.010] the namespace-path is supposed to be a string but was given a %q", _type(namespacePath))
        _ = namespacePath == _stringTrim(namespacePath) and namespacePath ~= "" and namespacePath or _throw_exception("[NR.ASR.NPIH.020] namespace-path %q is invalid - it must be a non-empty string without prefixed/postfixed whitespaces", namespacePath)
    end --@formatter:on
    NamespaceRegistry.Assert.SymbolTypeIsForDeclarableSymbol = function(symbolType)
        local isDeclarableSymbol = symbolType == SRegistrySymbolTypes.Enum
                or symbolType == SRegistrySymbolTypes.Interface
                or symbolType == SRegistrySymbolTypes.StaticClass
                or symbolType == SRegistrySymbolTypes.AbstractClass
                or symbolType == SRegistrySymbolTypes.NonStaticClass

        _ = isDeclarableSymbol or _throw_exception("[NR.ASR.STIFDS.010] the symbol you're trying to declare (type=%q) is not a Class/Enum/Interface to be declarable - so try binding it instead!", symbolType)
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

    function NamespaceRegistry:Healthcheck(errorsAccumulatorArray, forceCheckAll)
        _setfenv(EScope.Function, self)

        -- _g.print("[NamespaceRegistry.Healthcheck.000]")

        _ = _type(errorsAccumulatorArray) == "table" or _throw_exception("[NR.HC.010] errorsAccumulator must be a table (got %q)", _type(errorsAccumulatorArray))

        for _, protoTidbits in _pairs(_namespaces_registry) do
            -- _g.print("[NamespaceRegistry.Healthcheck.010]")

            if forceCheckAll or not protoTidbits:WasAlreadyHealthChecked() then
                protoTidbits:Healthcheck(self, errorsAccumulatorArray)
            end
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
        NamespaceRegistry.Assert.NoStrayPendingAttributes()
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
    --     _namespacer_bind("Pavilion.Warcraft.Addons.PfuiZen.Externals.MTALuaLinq.Enumerable",   _mta_lualinq_enumerable)
    --
    function NamespaceRegistry:BindKeyword(keyword, keywordFunc) --@formatter:off
        _setfenv(EScope.Function, self)

        _ = _stringStartsWith(keyword, "[") and _stringEndsWith(keyword, "]")   or _throw_exception("the keyword must be [enclosed] in brackets (got %q)", keyword)
        _ = _type(keywordFunc) == "function"                                    or _throw_exception("the keyword-func must be a function (got %q)", _type(keywordFunc)) --@formatter:on

        self:BindImpl_(keyword, keywordFunc, SRegistrySymbolTypes.Keyword)
    end

    -- [healthcheck] uses this
    function NamespaceRegistry:BindAutorunKeyword(keyword, func) --@formatter:off
        _setfenv(EScope.Function, self)

        _ = _type(func) == "function"                                         or _throw_exception("the autorun keyword must be bound to a function (got %q)", _type(func))
        _ = _stringStartsWith(keyword, "[") and _stringEndsWith(keyword, "]") or _throw_exception("the keyword must be [enclosed] in brackets (got %q)", keyword) --@formatter:on

        self:BindImpl_(keyword, func, SRegistrySymbolTypes.AutorunKeyword)
    end

    function NamespaceRegistry:BindRawSymbol(keywordOrNamespacePath, rawSymbol) --@formatter:off
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
        NamespaceRegistry.Assert.NoStrayPendingAttributes()

        local entry = _namespaces_registry[namespacePath]
        if entry == nil then
            if suppressExceptionIfNotFound then
                return nil
            end

            _throw_exception("namespace/keyword [%s] has not been registered.", namespacePath) -- dont turn this into an debug.assertion   we want to know about this in production builds too
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

    function NamespaceRegistry:QueueAttribute(attributeSpecs)
        _setfenv(EScope.Function, self)
        
        _ = _type(attributeSpecs) == "table" or _throw_exception("[NR.QD.010] AttributeSpecs must be a table (got %q)", _type(attributeSpecs))

        _pendingAttributesArray = _pendingAttributesArray or {} -- order   keep this last
        _tableInsert(_pendingAttributesArray, attributeSpecs)
    end
    
    function NamespaceRegistry:PopAllPendingAttributes()
        _setfenv(EScope.Function, self)

        if _pendingAttributesArray == nil then
            return nil
        end
        
        local snapshot = _pendingAttributesArray -- order

        _pendingAttributesArray = nil -- order
        
        return snapshot
    end

    function NamespaceRegistry:TryGetNamespaceIfInstanceOrProto(instanceOrProto)
        _setfenv(EScope.Function, self)

        local proto = self:TryGetProtoTidbitsIfInstanceOrProto(instanceOrProto)
        if proto == nil then
            return nil
        end

        return proto:GetNamespace()
    end

    function NamespaceRegistry:TryGetProtoTidbitsIfInstanceOrProto(instanceOrProto)
        _setfenv(EScope.Function, self)

        if instanceOrProto == nil then
            return nil
        end

        if _type(instanceOrProto) ~= "table" or _type(instanceOrProto.__index) ~= "table" then
            return nil
        end

        return self:TryGetProtoTidbitsViaSymbolProto(instanceOrProto.__index)
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
        _ = protoTidbits ~= nil            or _throw_exception("[NR.BM.000] targetSymbolProto [%q] is not a symbol-proto", protoTidbits:GetNamespace())
        _ = protoTidbits:CanBeSubclassed() or _throw_exception("[NR.BM.002] targetSymbolProto [%q] must be a class/interface/enum to be blendable (symbol-type=%q)", protoTidbits:GetNamespace(), protoTidbits:GetRegistrySymbolType())
        
        namedMixins = NamespaceRegistry.ConvertNamedMixinsToNameValuePairs_(protoTidbits:GetNamespace(), namedMixins)

        local targetSymbolProto_baseProp = targetSymbolProto.base or {} -- create a .base and .asBase tables to hold per-mixin fields/methods
        local targetSymbolProto_asBaseProp = targetSymbolProto.asBase or {}

        targetSymbolProto.base = targetSymbolProto_baseProp
        targetSymbolProto.asBase = targetSymbolProto_asBaseProp

        local targetIsEnum           = protoTidbits:IsEnumEntry()
        local targetIsInterface      = protoTidbits:IsInterfaceEntry()
        local targetIsStaticClass    = protoTidbits:IsStaticClassEntry()
        local targetIsAbstractClass  = protoTidbits:IsAbstractClassEntry()
        local targetIsNonStaticClass = protoTidbits:IsNonStaticClassEntry() --@formatter:on

        -- for each named mixin, create a table with closures that bind the target as self
        local systemReservedMemberNames_forDirectMembers, systemReservedStaticMemberNames_forMembersOfUnderscore = protoTidbits:GetSpecialReservedNames()
        
        -- todo   we should apply mixins in the following order    interface-mixins -> abstract-mixins -> concrete-mixins  to ensure that the concrete-mixins have the last say 
        for i, mixinSpecs in _ipairs(namedMixins) do --@formatter:off
            local specific_MixinNickname    = mixinSpecs.Name
            local specific_MixinProtoSymbol = mixinSpecs.Proto

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
            local mixinIsAbstractClass  = mixinProtoTidbits:IsAbstractClassEntry()
            local mixinIsNonStaticClass = mixinProtoTidbits:IsNonStaticClassEntry()
            _ = (not targetIsEnum                                           or mixinIsEnum           or mixinIsStaticClass                      ) or _throw_exception("[NR.BM.070] mixin nicknamed %q (symbol-type=%s) is not an enum or a static-class - cannot mix it into an enum", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = (not targetIsInterface                                      or mixinIsInterface                                                 ) or _throw_exception("[NR.BM.071] mixin nicknamed %q (symbol-type=%s) is not an interface - cannot mix it into an interface", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = (not targetIsStaticClass                                    or mixinIsStaticClass    or mixinIsInterface                        ) or _throw_exception("[NR.BM.072] mixin nicknamed %q (symbol-type=%s) is not a static-class or an interface - cannot mix it into a static-class", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType())
            _ = ((not targetIsNonStaticClass and not targetIsAbstractClass) or mixinIsNonStaticClass or mixinIsAbstractClass or mixinIsInterface) or _throw_exception("[NR.BM.073] mixin nicknamed %q (symbol-type=%s) is not a non-static-class or an abstract-class or an interface - cannot mix it in the blend", specific_MixinNickname, mixinProtoTidbits:GetRegistrySymbolType()) --@formatter:on

            mixinProtoTidbits:MarkEmployedAsParentClass()

            targetSymbolProto_asBaseProp[specific_MixinProtoSymbol] = specific_MixinProtoSymbol -- add the mixin-proto-symbol itself as the key to its own mixin-proto-symbol

            local isNamelessMixin = specific_MixinNickname == ""
            if not isNamelessMixin then
                targetSymbolProto_asBaseProp[specific_MixinNickname] = specific_MixinProtoSymbol -- completely overwrite any previous asBase[name]
            end

            for specific_MixinMemberName, specific_MixinMemberSymbol in _pairs(specific_MixinProtoSymbol) do --@formatter:off   _g.print("** [" .. _g.tostring(mixinNickname) .. "] processing mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "'")
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

                        if not (mixinIsInterface or mixinIsAbstractClass) or targetSymbolProto[specific_MixinMemberName] == nil then
                            targetSymbolProto[specific_MixinMemberName] = specific_MixinMemberSymbol -- combine all members/methods provided by mixins directly under proto.*     later mixins override earlier ones
                        end

                        if not (mixinIsInterface or mixinIsAbstractClass) or targetSymbolProto_baseProp[specific_MixinMemberName] == nil then
                            targetSymbolProto_baseProp[specific_MixinMemberName] = specific_MixinMemberSymbol    
                        end                        

                        targetSymbolProto_asBaseProp[specific_MixinNickname][specific_MixinMemberName] = specific_MixinMemberSymbol -- append methods provided by a specific mixin under proto.asBase.<specific-mixin-nickname>.<specific-member-name>
                        -- else
                        --     _g.print("****** [" .. _g.tostring(mixinNickname) .. "] skipping mixin-member '" .. _g.tostring(specific_MixinMemberName) .. "' because it is a system-reserved name")
                    end
                end
            end
        end

        return targetSymbolProto
    end

    -- converts an array-table of named mixins into a name-value-pairs table
    --
    -- {
    --     "mixinName1", mixinProtoSymbol1,
    --     "mixinName2", mixinProtoSymbol2,
    --     ...
    -- }
    --
    -- gets converted to:
    --
    -- {
    --     { Name = "mixinName1", Proto = mixinProtoSymbol1 },
    --     { Name = "mixinName2", Proto = mixinProtoSymbol2 },
    --     ...
    -- }
    function NamespaceRegistry.ConvertNamedMixinsToNameValuePairs_(targetSymbolProtoNamespace, namedMixinsArray) --@formatter:off
        _setfenv(EScope.Function, NamespaceRegistry)
        
        _ = _type(namedMixinsArray) == "table"  or _throw_exception("[NR.BM.005] [%s] namedMixinsArray must be an array-table", targetSymbolProtoNamespace)
        _ = _next(namedMixinsArray) ~= nil      or _throw_exception("[NR.BM.010] [%s] namedMixinsArray must not be an empty array", targetSymbolProtoNamespace)

        local i = 1
        local currentPair = { Name = nil, Proto = nil }
        local transformedMixins = {}
        for index, mixinNameOrProto in _pairs(namedMixinsArray) do
            -- _g.print("** [" .. targetSymbolProtoNamespace .. "] processing mixin #" .. _stringify(i) .. " with value '" .. _stringify(mixinNameOrProto) .. "'")

            if currentPair.Name == nil then
                _ = _type(mixinNameOrProto) == "string" and mixinNameOrProto ~= "" or _throw_exception("[NR.BM.020] Upon trying to create blend for [%s], blend-item#%d was expected to be a non-dud mixin-nickname string but it was found to be %q (type=%q)", targetSymbolProtoNamespace, i, _stringify(mixinNameOrProto), _type(mixinNameOrProto))

                currentPair.Name = mixinNameOrProto -- the first item in the pair is the name

            else
                local mixinProtoTidbits = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(mixinNameOrProto)

                _ = mixinProtoTidbits ~= nil or _throw_exception("[NR.BM.030] Upon trying to create blend for [%s], blend-item#%d was expected to be a proto but it is not (type=%q)", targetSymbolProtoNamespace, i, _type(mixinNameOrProto))

                currentPair.Proto = mixinNameOrProto --           order    the second item in the pair is the proto-symbol
                _tableInsert(transformedMixins, currentPair) --   order
                currentPair = { Name = nil, Proto = nil } --      order    reset the pair for the next iteration
            end

            i = i + 1            
        end
    
        _tableSort(transformedMixins, NamespaceRegistry.NamedMixinsSortingFunc_)

        return transformedMixins
    end --@formatter:on
    
    function NamespaceRegistry.NamedMixinsSortingFunc_(a, b)
        _setfenv(EScope.Function, NamespaceRegistry)

        local protoTidbitsA = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(a.Proto)
        local protoTidbitsB = NamespaceRegistrySingleton:TryGetProtoTidbitsViaSymbolProto(b.Proto)
        
        _ = protoTidbitsA ~= nil or _throw_exception("[NR.BM.NMSF.010] [%s] protoTidbitsA = nil (how?)", _stringify(a))
        _ = protoTidbitsB ~= nil or _throw_exception("[NR.BM.NMSF.010] [%s] protoTidbitsB = nil (how?)", _stringify(b))

        local typeA = protoTidbitsA:GetRegistrySymbolType()
        local typeB = protoTidbitsB:GetRegistrySymbolType()
        if typeA == typeB then
            return protoTidbitsA:GetNamespace() < protoTidbitsB:GetNamespace() -- sort by namespace if types are the same
        end

        local scoreA = NamespaceRegistry.GetMixinProtoSortingScore_(typeA)
        local scoreB = NamespaceRegistry.GetMixinProtoSortingScore_(typeB)

        return scoreA < scoreB or (scoreA == scoreB and protoTidbitsA:GetNamespace() < protoTidbitsB:GetNamespace())
    end
    
    function NamespaceRegistry.GetMixinProtoSortingScore_(protoType) --@formatter:off
        _setfenv(EScope.Function, NamespaceRegistry)
        
        return     protoType == SRegistrySymbolTypes.NonStaticClass    and 90 -- must be appear last in the sorted-array
               or  protoType == SRegistrySymbolTypes.StaticClass       and 80
               or  protoType == SRegistrySymbolTypes.AbstractClass     and 70
               or  protoType == SRegistrySymbolTypes.Interface         and 60 -- must appear at the beginning of the sorted-array

               or  protoType == SRegistrySymbolTypes.Enum              and 50 -- these shouldnt appear but just in case ... 
               or  protoType == SRegistrySymbolTypes.Keyword           and 40
               or  protoType == SRegistrySymbolTypes.RawSymbol         and 20
               or  protoType == SRegistrySymbolTypes.AutorunKeyword    and 30
               or  10 -- this is a fallback for any other type that we might not have accounted for
    end --@formatter:on

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

--[[ HEALTH-CHECKER ]]--

local HealthChecker = _spawnSimpleMetatable()
do
    function HealthChecker:New()
        _setfenv(EScope.Function, self)

        local instance = { }

        return _setmetatable(instance, self)
    end

    function HealthChecker:Run(namespaceRegistry, forceCheckAll)
        _setfenv(EScope.Function, self)

        _ = _type(namespaceRegistry) == "table" or _throw_exception("[NR.HCR.RN.010] namespaceRegistry must be a table but it was found to be of type %q", _type(namespaceRegistry))

        local errorsAccumulatorArray = {}

        namespaceRegistry:Healthcheck(errorsAccumulatorArray, forceCheckAll)
        -- add more healthchecks here in the future ...

        if _next(errorsAccumulatorArray) then
            _throw_exception("[NR.HCR.RN.020] Healthcheck failed with the following errors:\n\n%s", _tableConcat(errorsAccumulatorArray, "\n\n"))
        end
    end
end

--[[ SINGLETON INSTANCES ]]--

HealthCheckerSingleton = HealthChecker:New()
NamespaceRegistrySingleton = NamespaceRegistry:New()

--[[ EXPORTED GLOBAL-SYMBOLS ]]--
do
    -- using "x.y.z" 
    _g["ZENSHARP:USING"] = function(namespacePath)
        --    todo   in production builds these symbols should get obfuscated to something like  _g.ppzcn__<some_guid_here>__get
        return NamespaceRegistrySingleton:Get(namespacePath)
    end
end

--[[ EXPORTED CANON-KEYWORDS ]]--
do
    NamespaceRegistrySingleton:BindRawSymbol("System.Global", _g)
    NamespaceRegistrySingleton:BindRawSymbol("System.Namespacer", NamespaceRegistrySingleton)

    NamespaceRegistrySingleton:BindKeyword("[declare] [bind]", function(namespacePath)
        local namespacePathSnapshot = namespacePath -- vital
        return function(rawExternalSymbol)
            NamespaceRegistrySingleton:BindRawSymbol(namespacePathSnapshot, rawExternalSymbol)
        end
    end)

    NamespaceRegistrySingleton:BindKeyword("[declare] [keyword]", function(keyword)
        local keywordSnapshot = keyword -- vital
        return function(keywordFunc)
            NamespaceRegistrySingleton:BindKeyword(keywordSnapshot, keywordFunc)
        end
    end)

    -- @formatter:off   todo   also introduce [declare] [partial] etc and remove the [Partial] postfix-technique on the namespace path since it will no longer be needed
    NamespaceRegistrySingleton:BindKeyword("[autocall]",                     function(targetMethodName) NamespaceRegistrySingleton:QueueAttribute(MethodAttributeSpecs:NewForAutocall(targetMethodName)) end)
    NamespaceRegistrySingleton:BindKeyword("[abstract]",                     function(targetMethodName) NamespaceRegistrySingleton:QueueAttribute(MethodAttributeSpecs:NewForAbstract(targetMethodName)) end)

    NamespaceRegistrySingleton:BindAutorunKeyword("[healthcheck]",           function() HealthCheckerSingleton:Run(NamespaceRegistrySingleton, --[[forceCheckAll:]] false)               end)
    NamespaceRegistrySingleton:BindAutorunKeyword("[healthcheck] [all]",     function() HealthCheckerSingleton:Run(NamespaceRegistrySingleton, --[[forceCheckAll:]] true)                end)

    NamespaceRegistrySingleton:BindKeyword("[declare]",                      function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [enum]",               function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.Enum                 ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [class]",              function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.NonStaticClass       ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [interface]",          function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.Interface            ) end)

    NamespaceRegistrySingleton:BindKeyword("[declare] [abstract]",           function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.AbstractClass        ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [abstract] [class]",   function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.AbstractClass        ) end)

    NamespaceRegistrySingleton:BindKeyword("[declare] [static]",             function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [static] [class]",     function(namespacePath) return NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, SRegistrySymbolTypes.StaticClass          ) end)

    local function declareSymbolAndReturnBlenderCallback(namespacePath, symbolType)
        local protoEntrySnapshot = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs(namespacePath, symbolType)

        return function(namedMixinsToAdd) return NamespaceRegistrySingleton:BlendMixins(protoEntrySnapshot, namedMixinsToAdd) end -- currying essentially
    end

    NamespaceRegistrySingleton:BindKeyword("[declare] [blend]",                      function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.NonStaticClass      ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [enum] [blend]",               function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.Enum                ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [class] [blend]",              function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.NonStaticClass      ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [interface] [blend]",          function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.Interface           ) end)

    NamespaceRegistrySingleton:BindKeyword("[declare] [abstract] [blend]",           function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.AbstractClass       ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [abstract] [class] [blend]",   function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.AbstractClass       ) end)

    NamespaceRegistrySingleton:BindKeyword("[declare] [static] [blend]",             function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.StaticClass         ) end)
    NamespaceRegistrySingleton:BindKeyword("[declare] [static] [class] [blend]",     function(namespacePath) return declareSymbolAndReturnBlenderCallback(namespacePath, SRegistrySymbolTypes.StaticClass         ) end)
    -- @formatter:on
end

--[[ EXPORTED SRegistrySymbolTypes ]]--
do
    local AdvertisedSRegistrySymbolTypes = NamespaceRegistrySingleton:UpsertSymbolProtoSpecs("System.Namespacer.SRegistrySymbolTypes", SRegistrySymbolTypes.Enum)
    for k, v in _pairs(SRegistrySymbolTypes) do -- this is the safest way to get the enum values to be advertised to the outside world
        AdvertisedSRegistrySymbolTypes[k] = v
    end

    -- no need for this   the standardized enum metatable is already in place and it does the same job just fine
    --
    -- _setmetatable(AdvertisedSRegistrySymbolTypes, _getmetatable(SRegistrySymbolTypes))
end
