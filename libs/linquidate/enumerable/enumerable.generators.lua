_G.Linquidate_Loader(function(Linquidate)
    local _G = _G
    local assert = _G.assert

    local check = assert(Linquidate.Utilities.check)
    local convert_function = assert(Linquidate.Utilities.convert_function)

    local type = assert(_G.type)
    local error = assert(_G.error)
    local math_random = assert(_G.math.random)

    local Enumerable = assert(Linquidate.Enumerable)
    local Enumerator = assert(Linquidate.Enumerator)

    --- Return an Enumerable that represents an infinite sequence of randomly chosen items in the arguments.
    -- @param ... Either a list-like table or multiple arguments to choose.
    -- @return An infinite sequence of randomly chosen items.
    -- @usage Enumerable.Choice(1, 2, 3, 4):ToString() == "[4, 2, 4, 3, 1, 4, 2, 1, 3, 1, ...]"
    -- @usage Enumerable.Choice({ 1, 2, 3, 4 }):ToString() == "[3, 2, 4, 3, 4, 1, 3, 2, 3, 1, ...]"
    function Enumerable.Choice(...)
        local args
        local length
        if type(arg[1]) == 'table' and table.getn(arg) == 1 then
            args = arg[1]
            length = table.getn(args)
        else
            args = arg
            length = table.getn(arg)
        end

        if length == 0 then
            error("Cannot create an Enumerable from an empty table", 2)
        end

        return Enumerable.New(function()
            return Enumerator.New(
                    nil,
                    function(yield)
                        return yield(args[math_random(length)])
                    end,
                    nil)
        end)
    end

    --- Return an Enumerable that will cycle over the items in the arguments.
    -- @param ... Either a list-like table or multiple arguments to choose.
    -- @return An infinite sequence of cycled items.
    -- @usage Enumerable.Cycle(1, 2, 3, 4):ToString() == "[1, 2, 3, 4, 1, 2, 3, 4, 1, 2, ...]"
    -- @usage Enumerable.Cycle({ 1, 2, 3, 4 }):ToString() == "[1, 2, 3, 4, 1, 2, 3, 4, 1, 2, ...]"
    Enumerable.Cycle = function(...)
        local args
        local length
        if type(arg[1]) == 'table' then
            args = arg[1]
            length = table.getn(args)
        else
            args = arg
            length = table.getn(arg)
        end

        if length == 0 then
            error("Cannot create an Enumerable from an empty table", 2)
        end

        return Enumerable.New(function()
            local index = 0
            return Enumerator.New(
                    nil,
                    function(yield)
                        if index >= length then
                            index = 1
                        else
                            index = index + 1
                        end
                        return yield(args[index])
                    end,
                    nil)
        end)
    end

    do
        local empty = nil
        --- Return an Enumerable that contains no items
        -- @return an empty Enumerable
        -- @usage Enumerable.Empty():ToString() == "[]"
        function Enumerable.Empty()
            if not empty then
                empty = Enumerable.New(function()
                    return Enumerator.New(
                            nil,
                            function()
                                return false
                            end,
                            nil);
                end)
            end
            return empty
        end
    end

    local table_wrap = Enumerable.__TableWrapper

    --- Set the standard table wrapper function that Enumerable.From will use
    -- @param func the function to call that will have a table passed in.
    -- @usage Enumerable.SetTableWrapper(List.WrapTable)
    function Enumerable.SetTableWrapper(func)
        check(1, func, 'function')

        table_wrap = func
        Enumerable.__TableWrapper = func
    end

    --- Return an Enumerable by trying to convert an object to one through some means.
    -- Passing in nil will result in an empty Enumerable
    -- Passing in an Enumerable will return the same Enumerable
    -- Passing in a string will return an Enumerable that iterates over the characters in the string.
    -- Passing in a table will call List.WrapTable
    -- Passing in a number or boolean will return an Enumerable with the element you passed in.
    -- Any other object will result in an error.
    -- @return an Enumerable
    -- @usage Enumerable.From(nil):ToString() == "[]"
    -- @usage Enumerable.From("hey"):ToString() == '["h", "e", "y"]'
    -- @usage Enumerable.From(Enumerable.Empty()):ToString() == "[]"
    -- @usage Enumerable.From({ 1, 2, 3 }):ToString() == "[1, 2, 3]"
    -- @usage Enumerable.From(5):ToString() == "[5]"
    -- @usage Enumerable.From(true):ToString() == "[true]"
    function Enumerable.From(obj)
        local obj_type = type(obj)

        if obj_type == 'nil' then
            return Enumerable.Empty()
        end

        if obj_type == 'userdata' and Enumerable.IsEnumerable(obj) then
            return obj
        end

        if obj_type == 'string' then
            return Enumerable.New(function()
                local index = 0
                return Enumerator.New(
                        nil,
                        function(yield)
                            index = index + 1
                            if index <= table.getn(obj) then
                                return yield(obj:sub(index, index))
                            else
                                return false
                            end
                        end,
                        nil
                )
            end)
        end

        if obj_type == 'table' then
            if not table_wrap then
                error("No table wrapper specified")
            end

            return table_wrap(obj)
        end

        if obj_type == 'number' or obj_type == 'boolean' then
            return Enumerable.Return(obj)
        end

        error(string.format("Don't know how to convert %s to an Enumerable", obj_type), 2)
    end

    --- Return an Enumerable by converting a Lua-style iterator to an Enumerable.
    -- @param func The iteration function
    -- @param t the state object of the iterator
    -- @param start the starting object of the iterator
    -- @return an Enumerable
    -- @usage Enumerable.FromIterator(pairs({ hey = true, there = true})):ToString() == '["hey", "there"]'
    function Enumerable.FromIterator(func, t, start)
        check(1, func, 'function')

        return Enumerable.New(function()
            local current
            return Enumerator.New(
                    function()
                        current = start
                    end, function(yield)
                        current = func(t, current)
                        if current ~= nil then
                            return yield(current)
                        else
                            return false
                        end
                    end, function()
                        current = nil
                    end)
        end)
    end

    --- Return an Enumerable that repeats either infinitely or a given number of times
    -- @param obj the item to repeat
    -- @param num either nil or the amount of times to repeat
    -- @return an Enumerable that repeats the object
    -- @usage Enumerable.Repeat(0):ToString() == "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...]"
    -- @usage Enumerable.Repeat(0, 5):ToString() == "[0, 0, 0, 0, 0]"
    function Enumerable.Repeat(obj, num)
        check(2, num, 'number', 'nil')
        if num then
            return Enumerable.Repeat(obj):Take(num)
        end

        return Enumerable.New(function()
            return Enumerator.New(
                    nil,
                    function(yield)
                        return yield(obj)
                    end,
                    nil)
        end);
    end

    --- Return an Enumerable that repeats
    -- @param initializer a function which will return a value to be repeated
    -- @param finalizer a function that will be run on dispose, passing in the repeated value
    -- @param num the number of times to repeat, or nil to repeat infinitely
    -- @return an Enumerable
    -- @usage Enumerable.RepeatWithFinalize(function() return 0 end):ToString() == "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...]"
    -- @usage Enumerable.RepeatWithFinalize(function() return 0 end, function(item) end):ToString() == "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...]"
    -- @usage Enumerable.RepeatWithFinalize(function() return 0 end, nil, 5):ToString() == "[0, 0, 0, 0, 0]"
    function Enumerable.RepeatWithFinalize(initializer, finalizer, num)
        check(1, initializer, 'function')
        check(2, finalizer, 'function', 'nil')
        check(3, num, 'number', 'nil')
        if num then
            return Enumerable.RepeatWithFinalize(initializer, finalizer):Take(num)
        end

        return Enumerable.New(function()
            local element
            return Enumerator.New(
                    function()
                        element = initializer()
                    end,
                    function(yield)
                        return yield(element)
                    end,
                    function()
                        if finalizer then
                            finalizer(element)
                        end
                        element = nil
                    end)
        end)
    end

    --- Return an Enumerable that contains a single provided element
    -- @param element the element to contain
    -- @return an Enumerable
    -- @usage Enumerable.Return(nil):ToString() == "[nil]"
    -- @usage Enumerable.Return(5):ToString() == "[5]"
    -- @usage Enumerable.Return("hey"):ToString() == '["hey"]'
    function Enumerable.Return(element)
        return Enumerable.New(function()
            local is_first = true
            return Enumerator.New(
                    nil,
                    function(yield)
                        if is_first then
                            is_first = false
                            return yield(element)
                        else
                            return false
                        end
                    end,
                    nil)
        end)
    end

    --- Return an increasing range of numbers
    -- @param start the starting number
    -- @param count the count of elements
    -- @param step the step size, defaults to 1 if nil. Must not be 0.
    -- @return an Enumerable
    -- @usage Enumerable.Range(0, 5):ToString() == "[0, 1, 2, 3, 4]"
    -- @usage Enumerable.Range(5, 5):ToString() == "[5, 6, 7, 8, 9]"
    -- @usage Enumerable.Range(0, 5, 2):ToString() == "[0, 2, 4, 6, 8]"
    function Enumerable.Range(start, count, step)
        check(1, start, 'number')
        check(2, count, 'number')
        check(3, step, 'number', 'nil')

        return Enumerable.ToInfinity(start, step or 1):Take(count)
    end

    --- Return a decreasing range of numbers
    -- @param start the starting number
    -- @param count the count of elements
    -- @param step the step size, defaults to 1 if nil. Must not be 0.
    -- @return an Enumerable
    -- @usage Enumerable.RangeDown(0, 5):ToString() == "[0, -1, -2, -3, -4]"
    -- @usage Enumerable.RangeDown(5, 5):ToString() == "[5, 4, 3, 2, 1]"
    -- @usage Enumerable.RangeDown(10, 5, 2):ToString() == "[10, 8, 6, 4, 2]"
    function Enumerable.RangeDown(start, count, step)
        check(1, start, 'number')
        check(2, count, 'number')
        check(3, step, 'number', 'nil')

        return Enumerable.ToNegativeInfinity(start, step or 1):Take(count)
    end

    --- Return a range of numbers inclusively covers [start, finish] if possible
    -- @param start the starting number
    -- @param finish the final number
    -- @param step the step size, defaults to 1 if nil. Must not be 0.
    -- @return an Enumerable
    -- @usage Enumerable.RangeTo(0, 5) == "[0, 1, 2, 3, 4, 5]"
    -- @usage Enumerable.RangeTo(5, 0) == "[5, 4, 3, 2, 1, 0]"
    -- @usage Enumerable.RangeTo(0, 9, 2) == "[0, 2, 4, 6, 8]"
    -- @usage Enumerable.RangeTo(0, 10, 2) == "[0, 2, 4, 6, 8, 10]"
    function Enumerable.RangeTo(start, finish, step)
        check(1, start, 'number')
        check(2, finish, 'number')
        check(3, step, 'number', 'nil')

        if start < finish then
            return Enumerable.ToInfinity(start, step or 1):TakeWhile(function(i)
                return i <= finish
            end)
        else
            return Enumerable.ToNegativeInfinity(start, step or 1):TakeWhile(function(i)
                return i >= finish
            end)
        end
    end

    --- Return an Enumerable which yields the results of repeatedly calling the provided generator
    -- @param generator a function that will be called repeatedly
    -- @param count the amount of elements to contain. If nil, then it will be an infinite sequence.
    -- @return an Enumerable
    -- @usage Enumerable.Generate(function() return math.random(5) end):ToString() == "[1, 5, 3, 5, 2, 4, 2, 2, 1, 2, ...]"
    -- @usage Enumerable.Generate(function() return math.random(5) end, 5):ToString() == "[4, 2, 4, 5, 3]"
    function Enumerable.Generate(generator, count)
        check(1, generator, 'function', 'string')
        check(2, count, 'number', 'nil')
        if count then
            return Enumerable.Generate(generator):Take(count)
        end

        generator = convert_function(generator)

        return Enumerable.New(function()
            return Enumerator.New(
                    nil,
                    function(yield)
                        return yield(generator())
                    end,
                    nil)
        end)
    end

    --- Return an Enumerable which represents infinite sequence which yields numbers starting at the given start and increasing by the step.
    -- If a negative step is specified, it will merely be made positive.
    -- @param start The starting number, defaulting to 0 if not specified.
    -- @param step The step size, defaulting to 1 if not specified. Must not be 0.
    -- @return an Enumerable
    -- @usage Enumerable.ToInfinity():ToString() == "[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...]"
    -- @usage Enumerable.ToInfinity(1):ToString() == "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, ...]"
    -- @usage Enumerable.ToInfinity(0, 2):ToString() == "[0, 2, 4, 6, 8, 10, 12, 14, 16, 18, ...]"
    -- @usage Enumerable.ToInfinity(0, -1):ToString() == "[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...]"
    function Enumerable.ToInfinity(start, step)
        check(1, start, 'number', 'nil')
        check(2, step, 'number', 'nil')
        if not start then
            start = 0
        end
        if not step then
            step = 1
        elseif step == 0 then
            error("Argument #2 must not be 0", 2)
        elseif step < 0 then
            step = -step
        end

        return Enumerable.New(function()
            local value = start
            return Enumerator.New(
                    nil,
                    function(yield)
                        local ret = value
                        value = value + step
                        return yield(ret)
                    end,
                    nil)
        end)
    end

    --- Return an Enumerable which represents infinite sequence which yields numbers starting at the given start and decreasing by the step.
    -- If a negative step is specified, it will merely be made positive.
    -- @param start The starting number, defaulting to 0 if not specified.
    -- @param step The step size, defaulting to 1 if not specified. Must not be 0.
    -- @return an Enumerable
    -- @usage Enumerable.ToNegativeInfinity():ToString() == "[0, -1, -2, -3, -4, -5, -6, -7, -8, -9, ...]"
    -- @usage Enumerable.ToNegativeInfinity(10):ToString() == "[10, 9, 8, 7, 6, 5, 4, 3, 2, 1, ...]"
    -- @usage Enumerable.ToNegativeInfinity(0, 2):ToString() == "[0, -2, -4, -6, -8, -10, -12, -14, -16, -18, ...]"
    -- @usage Enumerable.ToNegativeInfinity(0, -1):ToString() == "[0, -1, -2, -3, -4, -5, -6, -7, -8, -9, ...]"
    function Enumerable.ToNegativeInfinity(start, step)
        check(1, start, 'number', 'nil')
        check(2, step, 'number', 'nil')
        if not start then
            start = 0
        end
        if not step then
            step = 1
        elseif step == 0 then
            error("Argument #2 must not be 0", 2)
        elseif step < 0 then
            step = -step
        end

        return Enumerable.New(function()
            local value = start
            return Enumerator.New(
                    nil,
                    function(yield)
                        local ret = value
                        value = value - step
                        return yield(ret)
                    end,
                    nil)
        end)
    end

    --- Return an Enumerable which repeatedly calls a function, passing around an aggregated value
    -- @param seed The initial value to work on and yield
    -- @param func The function to repeatedly call, first passing in the yield, then the result after that.
    -- @return an Enumerable
    -- @usage Enumerable.Unfold(1, function(x) return x*2 end):ToString() == "[1, 2, 4, 8, 16, 32, 64, 128, 256, 512, ...]"
    -- @usage Enumerable.Unfold(1, "x => x+1"):ToString() == "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, ...]"
    function Enumerable.Unfold(seed, func)
        check(2, func, 'function', 'string')

        func = convert_function(func)

        return Enumerable.New(function()
            local is_first = true
            local value
            return Enumerator.New(
                    nil,
                    function(yield)
                        if is_first then
                            is_first = false
                            value = seed
                        else
                            value = func(value)
                        end
                        return yield(value)
                    end,
                    nil)
        end)
    end
end)