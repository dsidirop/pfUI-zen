_G.Linquidate_Loader(function(Linquidate)
    local _G = _G
    local assert = _G.assert

    local enumerable = assert(Linquidate.Enumerable)
    local enumerator = assert(Linquidate.Enumerator)

    local wipe = assert(Linquidate.Utilities.wipe)
    local check = assert(Linquidate.Utilities.check)
    local tostring_q = assert(Linquidate.Utilities.tostring_q)
    local convert_function = assert(Linquidate.Utilities.convert_function)
    local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)

    local error = assert(_G.error)
    local newproxy = assert(_G.newproxy)
    local math_floor = assert(_G.math.floor)
    local math_random = assert(_G.math.random)
    local getmetatable = assert(_G.getmetatable)
    local setmetatable = assert(_G.setmetatable)

    local stack = Linquidate.Stack or {}

    Linquidate.Stack = stack

    if not stack.prototype then
        stack.prototype = {}
    end
    setmetatable(stack.prototype, { __index = enumerable.prototype })

    local stack_proxy = newproxy(true)
    local stack_mt = getmetatable(stack_proxy)
    stack_mt.__index = stack.prototype
    function stack_mt:__tostring()
        return self:ToString()
    end

    local tables = make_weak_keyed_table(stack.__tables)
    stack.__tables = tables
    local counts = make_weak_keyed_table(stack.__counts)
    stack.__counts = counts
    local contracts = make_weak_keyed_table(stack.__contracts)
    stack.__contracts = contracts

    --- Construct and return a new Stack
    -- @param sequence optional: The sequence to fill the stack with
    -- @return a Stack
    -- @usage local stack = Stack.New()
    -- @usage local stack = Stack.New({ 1, 2, 3 })
    -- @usage local stack = Stack.New(Enumerable.RangeTo(1, 10))
    function stack.New(sequence)
        check(1, sequence, 'userdata', 'table', 'nil')

        local self = newproxy(stack_proxy)

        tables[self] = {}
        counts[self] = 0

        enumerable.From(sequence):ForEach(function(item)
            self:Push(item)
        end)

        return self
    end

    --- Construct and return a new Stack based on the arguments provided
    -- @param ... a tuple of arguments to fill the stack with
    -- @return a Stack
    -- @usage local stack = Stack.FromArguments()
    -- @usage local stack = Stack.FromArguments(1, 2, 3)
    -- @usage local stack = Stack.FromArguments(nil, nil, 5)
    function stack.FromArguments(...)
        local self = stack.New()

        for i = 1, table.getn(arg) do
            self:Push((arg[i]))
        end

        return self
    end

    --- Return an Enumerator for the current Stack
    -- @return an Enumerator
    function stack.prototype:GetEnumerator()
        check(1, self, 'userdata')

        local table = tables[self]
        local index

        return enumerator.New(
                function()
                    index = counts[self] + 1
                end,
                function(yield)
                    if index > 1 then
                        index = index - 1
                        return yield(table[index])
                    else
                        return false
                    end
                end,
                nil)
    end

    --- Verify that the contract for this Stack is valid for all elements in the Stack.
    -- If there is no contract, this does nothing.
    -- @usage stack:VerifyContract()
    function stack.prototype:VerifyContract()
        check(1, self, 'userdata')

        local contract = contracts[self]
        if not contract then
            return
        end

        local table = tables[self]
        local index = 0
        while true do
            index = index + 1
            if index > self:Count() then
                break
            end

            if not contract(table[index]) then
                error(string.format("Element %s does not meet the contract for this Stack.", tostring_q(table[index])), 2)
            end
        end
    end

    --- Set a contract that will be verified against any existing elements and any added elements or changed values.
    -- This is handy for if you want to verify that all values are strings or something like that.
    -- This will call :VerifyContract()
    -- @param contract a function that is passed the element and should return whether the element is valid.
    -- @usage stack:SetContract(function(v) return type(v) == "string" end)
    function stack.prototype:SetContract(contract)
        check(1, self, 'userdata')
        check(2, contract, 'function', 'nil')

        contracts[self] = contract
        self:VerifyContract()
    end

    --- Return whether the Stack is read-only, always returns false.
    -- @return a boolean
    -- @usage local read_only = stack:IsReadOnly()
    function stack.prototype:IsReadOnly()
        check(1, self, 'userdata')

        return false
    end

    --- Inserts an element at the top of the Stack
    -- @param item the element to push
    -- @usage stack:Push(5)
    -- @usage stack:Push(nil)
    function stack.prototype:Push(item)
        check(1, self, 'userdata')

        local contract = contracts[self]
        if contract and not contract(item) then
            error(string.format("Element %s does not meet the contract for this Stack.", tostring_q(item)), 2)
        end

        local count = counts[self] + 1
        counts[self] = count
        tables[self][count] = item
    end

    --- Removes and returns the object at the top of the Stack.
    -- This will error if the Stack is empty.
    -- @return The removed element at the top of the Stack.
    -- @usage local item = stack:Pop()
    function stack.prototype:Pop()
        check(1, self, 'userdata')

        local table = tables[self]
        local count = counts[self]
        if count < 1 then
            error("Stack is empty.", 2)
        end

        local item = table[count]
        table[count] = nil
        counts[self] = count - 1
        return item
    end

    --- Returns the object at the top of the Stack.
    -- This will error if the Stack is empty.
    -- @return The element at the top of the Stack.
    -- @usage local item = stack:Peek()
    function stack.prototype:Peek()
        check(1, self, 'userdata')

        local table = tables[self]
        local count = counts[self]
        if count < 1 then
            error("Stack is empty.", 2)
        end

        return table[count]
    end

    --- Clear all elements from the Stack
    -- @usage stack:Clear()
    function stack.prototype:Clear()
        check(1, self, 'userdata')

        wipe(tables[self])
        counts[self] = 0
    end

    --- Make a shallow clone of the Stack.
    -- @usage local other = stack:Clone()
    function stack.prototype:Clone()
        check(1, self, 'userdata')

        local other = stack.New()
        local table = tables[self]
        local other_table = tables[other]
        for i = 1, counts[self] do
            other_table[i] = table[i]
        end
        counts[other] = counts[self]
        local contract = contracts[self]
        if contract then
            other:SetContract(contracts[self])
        end

        return other
    end

    -- Methods that are faster than using the standard Enumerable ones:

    function stack.prototype:Any(predicate)
        check(1, self, 'userdata')
        check(2, predicate, 'function', 'string', 'nil')

        if not predicate then
            return counts[self] > 0
        else
            return enumerable.prototype.Any(self, predicate)
        end
    end

    function stack.prototype:Count(predicate)
        check(1, self, 'userdata')
        check(2, predicate, 'function', 'string', 'nil')

        if not predicate then
            return counts[self]
        else
            return enumerable.prototype.Count(self, predicate)
        end
    end

    function stack.prototype:ElementAt(index)
        check(1, self, 'userdata')
        check(2, index, 'number')

        if index < 1 then
            error("index must be at least 1", 2)
        elseif math_floor(index) ~= index then
            error("index must be an integer", 2)
        elseif index > counts[self] then
            error("index is greater than the amount of elements in the source", 2)
        end

        return tables[self][counts[self] - index + 1]
    end

    function stack.prototype:ElementAtOrDefault(index, default)
        check(1, self, 'userdata')
        check(2, index, 'number')

        if index < 1 or math_floor(index) ~= index or index > counts[self] then
            return default
        else
            return tables[self][counts[self] - index + 1]
        end
    end

    function stack.prototype:First(predicate)
        check(1, self, 'userdata')
        check(2, predicate, 'function', 'string', 'nil')

        if not predicate then
            return self:Peek()
        else
            return enumerable.prototype.First(self, predicate)
        end
    end

    function stack.prototype:FirstOrDefault(default, predicate)
        check(1, self, 'userdata')
        check(3, predicate, 'function', 'string', 'nil')

        if not predicate then
            if counts[self] < 1 then
                return default
            else
                return self:Peek()
            end
        else
            return enumerable.prototype.FirstOrDefault(self, default, predicate)
        end
    end

    function stack.prototype:Last(predicate)
        check(1, self, 'userdata')
        check(2, predicate, 'function', 'string', 'nil')

        if not predicate then
            if counts[self] < 1 then
                error("Last:no elements in the Stack", 2)
            else
                return tables[self][1]
            end
        else
            return enumerable.prototype.Last(self, predicate)
        end
    end

    function stack.prototype:LastOrDefault(default, predicate)
        check(1, self, 'userdata')
        check(3, predicate, 'function', 'string', 'nil')

        if not predicate then
            if counts[self] < 1 then
                return default
            else
                return tables[self][1]
            end
        else
            return enumerable.prototype.LastOrDefault(self, default, predicate)
        end
    end

    function stack.prototype:Single(predicate)
        check(1, self, 'userdata')
        check(2, predicate, 'function', 'string', 'nil')

        if not predicate then
            local count = counts[self]
            if count < 1 then
                error("Single:no elements in the Stack", 2)
            elseif count > 1 then
                error("Single:more than 1 element in the Stack", 2)
            else
                return tables[self][1]
            end
        else
            return enumerable.prototype.Single(self, predicate)
        end
    end

    function stack.prototype:SingleOrDefault(default, predicate)
        check(1, self, 'userdata')
        check(3, predicate, 'function', 'string', 'nil')

        if not predicate then
            local count = counts[self]
            if count < 1 then
                return default
            elseif count > 1 then
                error("SingleOrDefault:more than 1 element in the Stack", 2)
            else
                return tables[self][1]
            end
        else
            return enumerable.prototype.SingleOrDefault(self, default, predicate)
        end
    end

    function stack.prototype:SequenceEqual(second, compare_selector)
        check(1, self, 'userdata')
        check(2, second, 'userdata', 'table')
        check(3, compare_selector, 'function', 'string', 'nil')

        second = enumerable.From(second)
        if tables[second] and counts[self] ~= counts[second] then
            return false
        end

        return enumerable.prototype.SequenceEqual(self, second, compare_selector)
    end

    function stack.prototype:Force()
    end

    function stack.prototype:MemoizeAll()
        return self
    end

    function stack.prototype:ToString()
        check(1, self, 'userdata')

        return "Stack" .. enumerable.prototype.ToString(self)
    end

    function stack.prototype:ForEach(action)
        check(1, self, 'userdata')
        check(2, action, 'function', 'string')

        action = convert_function(action)

        local table = tables[self]
        local i = 0
        local index = counts[self] + 1
        while true do
            index = index - 1
            if index < 1 then
                break
            end

            i = i + 1
            if action(table[index], i) == false then
                break
            end
        end
    end

    local function iterator(self, index)
        index = index + 1

        local count = counts[self]
        if index > count then
            return nil
        end

        return index, tables[self][count - index + 1]
    end
    function stack.prototype:Iterate()
        return iterator, self, 0
    end

    function stack.prototype:PickRandom()
        check(1, self, 'userdata')

        local count = counts[self]
        if count == 0 then
            error("PickRandom:No elements in the Enumerable.", 2)
        end
        return tables[self][math_random(count)]
    end

    function stack.prototype:PickRandomOrDefault(default)
        check(1, self, 'userdata')

        local count = counts[self]
        if count == 0 then
            return default
        else
            return tables[self][math_random(count)]
        end
    end

    --- Make a new Stack filled with the contents of the current Enumerable
    -- @return a Stack
    function enumerable.prototype:ToStack()
        check(1, self, 'userdata')

        return stack.New(self)
    end
end)