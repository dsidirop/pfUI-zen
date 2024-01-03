local globalEnvironment = assert(_G or getfenv(0))

local _assert = assert(globalEnvironment.assert)

local _getn = _assert(globalEnvironment.getn)
local _gsub = _assert(globalEnvironment.gsub)
local _unpack = _assert(globalEnvironment.unpack)
local _format = _assert(globalEnvironment.string.format)
local _debugstack = _assert(globalEnvironment.debugstack)
local _tableInsert = _assert(globalEnvironment.table.insert)
local _namespaceBinder = _assert(globalEnvironment.pvl_namespacer_bind)

local function _strsplit(input, optionalDelimiter)
    if not input then
        return {}
    end

    local pattern = _format("([^%s]+)", optionalDelimiter or ",")

    local fields = {}
    _gsub(
            input,
            pattern,
            function(c)
                _tableInsert(fields, c)
            end
    )

    return fields
end

_namespaceBinder("[global]", function(...)
    local variadicsArray = arg
    local argumentsCount = _getn(variadicsArray)
    
    if argumentsCount == 0 then
        _assert(false, "you need to specify the names of the symbol(s) you want to get from the global-space\n\n" .. _debugstack() .. "\n")
    end

    local results = {}
    for i = 1, argumentsCount do
        local globalSymbolName = variadicsArray[i]
        local globalSymbolNameComponents = _strsplit(globalSymbolName, ".")

        local symbol
        for j = 1, _getn(globalSymbolNameComponents) do

            local component = globalSymbolNameComponents[j]
            if j == 1 then
                symbol = globalEnvironment[component]
            else
                symbol = symbol[component]
            end

            if symbol == nil then
                _assert(false, "component '" .. component .. "' in '" .. globalSymbolName .. "' was not found (is nil)\n\n" .. _debugstack() .. "\n")
            end            
        end
        
        results[i] = symbol
    end

    return _unpack(results)
end)
