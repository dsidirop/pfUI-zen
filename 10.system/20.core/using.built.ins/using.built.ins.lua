--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Global = using "System.Global"

local _assert = Global.assert;

local _type = _assert(Global.type)
local _next = _assert(Global.next)
local _pairs = _assert(Global.pairs)
local _strsub = _assert(Global.string.gsub)
local _debugstack = _assert(Global.debugstack)
local _loadstring = _assert(Global.loadstring or Global.load)

local _getBuiltIns = function(builtInsString)
    if _type(builtInsString) ~= "string" then
        _assert(false, "you need to specify the built-ins you want\n\n" .. _debugstack() .. "\n")
    end

    local func, errorMessage = _loadstring("return {" .. builtInsString .. "};")
    if func == nil or errorMessage ~= nil then
        _assert(false, "failed to load built-ins: " .. errorMessage .. "\n\n" .. _debugstack() .. "\n")
    end

    local builtIns = func()

    if _next(builtIns) == nil then
        _assert(false, "no built-ins loaded\n\n" .. _debugstack() .. "\n")
    end

    local numberOfBuiltInsLoaded = 0
    for builtInName, builtInValue in _pairs(builtIns) do
        numberOfBuiltInsLoaded = numberOfBuiltInsLoaded + 1
        if builtInName == nil or builtInValue == nil then
            _assert(false, "built-in '" .. builtInName .. "' is undefined\n\n" .. _debugstack() .. "\n")
        end
    end

    if numberOfBuiltInsLoaded == 0 then
        _assert(false, "no named built-ins loaded\n\n" .. _debugstack() .. "\n")
    end

    local _, expectedNumberOfBuiltInsLoaded = _strsub(builtInsString, "[%s]*[%w_.]+[%s]*=[^,]+,?", "")
    if numberOfBuiltInsLoaded ~= expectedNumberOfBuiltInsLoaded then
        _assert(false, "expected " .. expectedNumberOfBuiltInsLoaded .. " built-ins to be loaded, but " .. numberOfBuiltInsLoaded .. " were loaded\n\n" .. _debugstack() .. "\n")
    end

    return builtIns
end

using "[declare] [keyword]" "[built-ins]" (_getBuiltIns)

using "[declare] [keyword]" "[built-in]" (function(builtInString) return _getBuiltIns("X = " .. builtInString).X end)
