_G.Linquidate_Loader(function(Linquidate)
    local Utilities = {}

    Linquidate.Utilities = Utilities

    local _G = _G
    local type = _G.type
    local pairs = _G.pairs
    local error = _G.error
    local xpcall = _G.xpcall
    local tostring = _G.tostring
    local loadstring = _G.loadstring
    local table_concat = _G.table.concat
    local setmetatable = _G.setmetatable

    do
        local mt = { __mode = 'k' }
        Utilities.make_weak_keyed_table = function(t)
            if type(t) ~= "table" then
                t = {}
            end
            return setmetatable(t, mt)
        end
    end

    do
        local mt = { __mode = 'v' }
        Utilities.make_weak_valued_table = function(t)
            if type(t) ~= "table" then
                t = {}
            end
            return setmetatable(t, mt)
        end
    end

    do
        local mt = { __mode = 'kv' }
        Utilities.make_weak_table = function(t)
            if type(t) ~= "table" then
                t = {}
            end
            return setmetatable(t, mt)
        end
    end

    function Utilities.tostring_q(obj)
        if type(obj) == "string" then
            return string.format("%q", obj)
        end

        return tostring(obj)
    end
    local tostring_q = Utilities.tostring_q

    do
        local function combine_types(...)
            local count = table.getn(arg)
            if count == 1 then
                return (unpack(arg))
            end

            if count == 2 then
                return string.format("%s or %s", unpack(arg))
            end

            if count == 3 then
                return string.format("%s, %s, or %s", unpack(arg))
            end

            local t = {}
            for i = 1, table.getn(arg) - 1 do
                t[table.getn(t) + 1] = arg[i]
                t[table.getn(t) + 1] = ", "
            end

            t[table.getn(t) + 1] = "or "
            t[table.getn(t) + 1] = arg[table.getn(arg)]

            return table_concat(t)
        end

        function Utilities.check(num, argument, ...)
            if type(num) ~= "number" then
                error(string.format("Argument #1 to check must be a number, got %s (%s)", type(num), tostring(num)))
            end

            local type_argument = type(argument)
            for i = 1, table.getn(arg) do
                if type_argument == arg[i] then
                    return
                end
            end

            error(string.format("Argument #%d must be a %s, got %s (%s)", num, combine_types(unpack(arg)), type_argument, tostring_q(argument)), 3)
        end
    end
    local check = Utilities.check

    function Utilities.trycatch(try, catch)
        check(1, try, 'function')
        check(2, catch, 'function')

        local error_message
        local function wrap(status, ...)
            if status then
                return unpack(arg)
            end

            if catch(error_message) == true then
                error(error_message, 2)
            end
        end

        return wrap(xpcall(try, function(e)
            error_message = e
        end))
    end

    function Utilities.tryfinally(try, finally)
        check(1, try, 'function')
        check(2, finally, 'function')

        local error_message
        local function wrap(status, ...)
            finally()

            if not status then
                error(error_message, 2)
            end

            return unpack(arg)
        end

        return wrap(xpcall(try, function(e)
            error_message = e
        end))
    end

    function Utilities.safe_dispose(enumerator)
        if enumerator then
            enumerator:Dispose()
        end
    end

    function Utilities.identity(...)
        return unpack(arg)
    end

    local identity = Utilities.identity

    local wipe = _G.table.wipe or function(t)
        for k in pairs(t) do
            t[k] = nil
        end
    end
    Utilities.wipe = wipe

    local cached_functions = { [""] = identity }
    local function get_cached_function(code)
        local func = cached_functions[code]
        if func then
            return func
        end

        local args, body = string.match(code, "(.*)=>(.*)")
        if not args then
            error(string.format("%q is not the right format to convert to a function", code), 3)
        end

        local func_creator, error_message = loadstring(string.format([[return function(%s) return %s end]], args, body)) -- note   in vanilla-wow-lua we cant use [=====[ to be on the safe(r) side here because wow-lua does not support this particular syntax
        if not func_creator then
            error(string.format("%q is not proper code: %s", code, error_message), 3)
        end

        func = func_creator()
        if type(func) ~= "function" then
            error(string.format("%q did not properly generate a function", code), 3)
        end

        cached_functions[code] = func
        return func
    end

    function Utilities.convert_function(func)
        local type_func = type(func)
        if type_func == 'function' then
            return func
        end

        if type_func == 'string' then
            return get_cached_function(func)
        end

        if type_func ~= 'nil' then
            error(string.format("Cannot convert a %s to a function", type_func), 2)
        end

        return identity
    end

    _G.Linquidate_Loader(function(linquidate)
        wipe(linquidate.Utilities)
        linquidate.Utilities = nil
    end)
end)