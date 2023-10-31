_G.Linquidate_Loader(function(Linquidate)
    local _G = _G
    local assert = _G.assert

    local check = assert(Linquidate.Utilities.check)
    local tryfinally = assert(Linquidate.Utilities.tryfinally)
    local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
    local convert_function = assert(Linquidate.Utilities.convert_function)

    local enumerable = assert(Linquidate.Enumerable)
    local enumerator = assert(Linquidate.Enumerator)

    --- Return an enumerable that when looped over, runs an action but returns the current value regardless.
    -- @param action a function to call that has the element and the 1-based index passed in.
    -- @return an Enumerable
    -- @usage Enumerable.From({ 1, 2, 3 }):Do(function(x) print(x) end)
    function enumerable.prototype:Do(action)
        check(1, self, 'userdata')
        check(2, action, 'function', 'string')

        action = convert_function(action)

        return enumerable.New(function()
            local index = 0
            local enumerator_x

            return enumerator.New(
                    function()
                        enumerator_x = self:GetEnumerator()
                    end, function(yield)
                        if enumerator_x:MoveNext() then
                            local current = enumerator_x:Current()
                            index = index + 1
                            action(current, index)
                            return yield(current)
                        end
                        return false
                    end, function()
                        safe_dispose(enumerator_x)
                    end)
        end)
    end

    --- Immediately performs an action on each element in the sequence.
    -- If the action returns false, that will act as a break and prevent any more execution on the sequence.
    -- @param action a function that takes the element and the 1-based index of the element.
    -- @usage Enumerable.From({ 1, 2, 3, 4 }):ForEach(print)
    function enumerable.prototype:ForEach(action)
        check(1, self, 'userdata')
        check(2, action, 'function', 'string')

        action = convert_function(action)

        local index = 0
        local enumerator_x = self:GetEnumerator()
        tryfinally(function()
            while enumerator_x:MoveNext() do
                index = index + 1
                if action(enumerator_x:Current(), index) == false then
                    break
                end
            end
        end, function()
            safe_dispose(enumerator_x)
        end)
    end

    --- Iterate over an enumerable, forcing it to execute
    function enumerable.prototype:Force()
        local enumerator_x = self:GetEnumerator()
        tryfinally(
                function()
                    while enumerator_x:MoveNext() do
                        -- nothing
                    end
                end,
                function()
                    safe_dispose(enumerator_x)
                end
        )
    end
end)