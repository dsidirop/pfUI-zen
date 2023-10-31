_G.Linquidate_Loader(function(Linquidate)
    local Utilities = {}

    Linquidate.Utilities = Utilities

    local _G = _G
    local type = _G.type
    local setmetatable = _G.setmetatable
    local select = _G.select
    local table_concat = _G.table.concat
    local error = _G.error
    local tostring = _G.tostring
    local xpcall = _G.xpcall
    local pairs = _G.pairs
    local loadstring = _G.loadstring

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
            return ("%q"):format(obj)
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
                return ("%s or %s"):format(unpack(arg))
            end

            if count == 3 then
                return ("%s, %s, or %s"):format(unpack(arg))
            end

            local t = {}
            for _ = 1, table.getn(arg) - 1 do
                t[#t + 1] = (...)
                t[#t + 1] = ", "
            end

            t[#t + 1] = "or "
            t[#t + 1] = select(table.getn(arg), ...)
            return table_concat(t)
        end

        function Utilities.check(num, argument, ...)
            if type(num) ~= "number" then
                error("Argument #1 to check must be a number, got %s (%s)"):format(type(num), tostring(num))
            end

            local type_argument = type(argument)
            for i = 1, table.getn(arg) do
                if type_argument == (arg[i]) then
                    return
                end
            end

            error(("Argument #%d must be a %s, got %s (%s)"):format(num, combine_types(...), type_argument, tostring_q(argument)), 3)
        end
    end
    local check = Utilities.check

    function Utilities.trycatch(try, catch)
        check(1, try, 'function')
        check(2, catch, 'function')

        local error_message
        local function wrap(status, ...)
            if status then
                return ...
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

			return ...
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
        return ...
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

        local args, body = code:match("(.*)=>(.*)")
        if not args then
            error(("%q is not the right format to convert to a function"):format(code), 3)
        end

        local func_creator, error_message = loadstring(([=[return function(%s) return %s end]=]):format(args, body))
        if not func_creator then
            error(("%q is not proper code: %s"):format(code, error_message), 3)
        end

        func = func_creator()
        if type(func) ~= "function" then
            error(("%q did not properly generate a function"):format(code), 3)
        end

        cached_functions[code] = func
        return func
    end

    function Utilities.convertFunction(func)
        local type_func = type(func)
        if type_func == 'function' then
            return func
		end
        
		if type_func == 'string' then
            return get_cached_function(func)
		end
        
		if type_func ~= 'nil' then
			error(("Cannot convert a %s to a function"):format(type_func), 2)
        end

		return identity
    end

    _G.Linquidate_Loader(function(linquidate)
        wipe(linquidate.Utilities)
        linquidate.Utilities = nil
    end)
end)