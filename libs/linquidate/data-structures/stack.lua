_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	local make_weak_table = assert(Linquidate.Utilities.make_weak_table)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local check = assert(Linquidate.Utilities.check)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local wipe = assert(Linquidate.Utilities.wipe)
	local ConvertFunction = assert(Linquidate.Utilities.ConvertFunction)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)

	local math_floor = assert(_G.math.floor)
	local error = assert(_G.error)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local newproxy = assert(_G.newproxy)
	local select = assert(_G.select)
	local table_sort = assert(_G.table.sort)
	local math_random = assert(_G.math.random)
	local rawequal = assert(_G.rawequal)

	local Stack = Linquidate.Stack or {}

	Linquidate.Stack = Stack

	if not Stack.prototype then
		Stack.prototype = {}
	end
	setmetatable(Stack.prototype, {__index=Enumerable.prototype})
	
	local Stack_proxy = newproxy(true)
	local Stack_mt = getmetatable(Stack_proxy)
	Stack_mt.__index = Stack.prototype
	function Stack_mt:__tostring()
		return self:ToString()
	end
	
	local tables = make_weak_keyed_table(Stack.__tables)
	Stack.__tables = tables
	local counts = make_weak_keyed_table(Stack.__counts)
	Stack.__counts = counts
	local contracts = make_weak_keyed_table(Stack.__contracts)
	Stack.__contracts = contracts

	--- Construct and return a new Stack
	-- @param sequence optional: The sequence to fill the stack with
	-- @return a Stack
	-- @usage local stack = Stack.New()
	-- @usage local stack = Stack.New({ 1, 2, 3 })
	-- @usage local stack = Stack.New(Enumerable.RangeTo(1, 10))
	function Stack.New(sequence)
		check(1, sequence, 'userdata', 'table', 'nil')

		local self = newproxy(Stack_proxy)

		tables[self] = {}
		counts[self] = 0

		Enumerable.From(sequence):ForEach(function(item)
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
	function Stack.FromArguments(...)
		local self = Stack.New()

		for i = 1, select('#', ...) do
			self:Push((select(i, ...)))
		end

		return self
	end

	--- Return an Enumerator for the current Stack
	-- @return an Enumerator
	function Stack.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local table = tables[self]
		local index

		return Enumerator.New(
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
	function Stack.prototype:VerifyContract()
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
				error(("Element %s does not meet the contract for this Stack."):format(tostring_q(table[index])), 2)
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all values are strings or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the element and should return whether the element is valid.
	-- @usage stack:SetContract(function(v) return type(v) == "string" end)
	function Stack.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')

		contracts[self] = contract
		self:VerifyContract()
	end

	--- Return whether the Stack is read-only, always returns false.
	-- @return a boolean
	-- @usage local read_only = stack:IsReadOnly()
	function Stack.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return false
	end

	--- Inserts an element at the top of the Stack
	-- @param item the element to push
	-- @usage stack:Push(5)
	-- @usage stack:Push(nil)
	function Stack.prototype:Push(item)
		check(1, self, 'userdata')

		local contract = contracts[self]
		if contract and not contract(item) then
			error(("Element %s does not meet the contract for this Stack."):format(tostring_q(item)), 2)
		end

		local count = counts[self] + 1
		counts[self] = count
		tables[self][count] = item
	end
	
	--- Removes and returns the object at the top of the Stack.
	-- This will error if the Stack is empty.
	-- @return The removed element at the top of the Stack.
	-- @usage local item = stack:Pop()
	function Stack.prototype:Pop()
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
	function Stack.prototype:Peek()
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
	function Stack.prototype:Clear()
		check(1, self, 'userdata')

		wipe(tables[self])
		counts[self] = 0
	end

	--- Make a shallow clone of the Stack.
	-- @usage local other = stack:Clone()
	function Stack.prototype:Clone()
		check(1, self, 'userdata')

		local other = Stack.New()
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
	
	function Stack.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return counts[self] > 0
		else
			return Enumerable.prototype.Any(self, predicate)
		end
	end

	function Stack.prototype:Count(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return counts[self]
		else
			return Enumerable.prototype.Count(self, predicate)
		end
	end
	
	function Stack.prototype:ElementAt(index)
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
	
	function Stack.prototype:ElementAtOrDefault(index, default)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 or math_floor(index) ~= index or index > counts[self] then
			return default
		else
			return tables[self][counts[self] - index + 1]
		end
	end
	
	function Stack.prototype:First(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return self:Peek()
		else
			return Enumerable.prototype.First(self, predicate)
		end
	end
	
	function Stack.prototype:FirstOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if counts[self] < 1 then
				return default
			else
				return self:Peek()
			end
		else
			return Enumerable.prototype.FirstOrDefault(self, default, predicate)
		end
	end
	
	function Stack.prototype:Last(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if counts[self] < 1 then
				error("Last:no elements in the Stack", 2)
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.Last(self, predicate)
		end
	end
	
	function Stack.prototype:LastOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if counts[self] < 1 then
				return default
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.LastOrDefault(self, default, predicate)
		end
	end
	
	function Stack.prototype:Single(predicate)
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
			return Enumerable.prototype.Single(self, predicate)
		end
	end
	
	function Stack.prototype:SingleOrDefault(default, predicate)
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
			return Enumerable.prototype.SingleOrDefault(self, default, predicate)
		end
	end
	
	function Stack.prototype:SequenceEqual(second, compare_selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, compare_selector, 'function', 'string', 'nil')

		second = Enumerable.From(second)
		if tables[second] and counts[self] ~= counts[second] then
			return false
		end
		
		return Enumerable.prototype.SequenceEqual(self, second, compare_selector)
	end
	
	function Stack.prototype:Force()
	end
	
	function Stack.prototype:MemoizeAll()
		return self
	end

	function Stack.prototype:ToString()
		check(1, self, 'userdata')

		return "Stack" .. Enumerable.prototype.ToString(self)
	end

	function Stack.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = ConvertFunction(action)

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
	function Stack.prototype:Iterate()
		return iterator, self, 0
	end

	function Stack.prototype:PickRandom()
		check(1, self, 'userdata')

		local count = counts[self]
		if count == 0 then
			error("PickRandom:No elements in the Enumerable.", 2)
		end
		return tables[self][math_random(count)]
	end
	
	function Stack.prototype:PickRandomOrDefault(default)
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
	function Enumerable.prototype:ToStack()
		check(1, self, 'userdata')

		return Stack.New(self)
	end
end)