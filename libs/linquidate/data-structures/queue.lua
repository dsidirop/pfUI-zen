_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local check = assert(Linquidate.Utilities.check)
	local wipe = assert(Linquidate.Utilities.wipe)
	local convertFunction = assert(Linquidate.Utilities.convertFunction)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)

	local math_floor = assert(_G.math.floor)
	local error = assert(_G.error)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local newproxy = assert(_G.newproxy)
	local select = assert(_G.select)
	local math_random = assert(_G.math.random)

	local Queue = Linquidate.Queue or {}

	Linquidate.Queue = Queue

	if not Queue.prototype then
		Queue.prototype = {}
	end
	setmetatable(Queue.prototype, {__index=Enumerable.prototype})
	
	local Queue_proxy = newproxy(true)
	local Queue_mt = getmetatable(Queue_proxy)
	Queue_mt.__index = Queue.prototype
	function Queue_mt:__tostring()
		return self:ToString()
	end
	
	local tables = make_weak_keyed_table(Queue.__tables)
	Queue.__tables = tables
	local heads = make_weak_keyed_table(Queue.__heads)
	Queue.__heads = heads
	local tails = make_weak_keyed_table(Queue.__tails)
	Queue.__tails = tails
	local contracts = make_weak_keyed_table(Queue.__contracts)
	Queue.__contracts = contracts
	
	local SHRINK_THRESHOLD = 32
	assert(SHRINK_THRESHOLD >= 1) -- do not remove this

	--- Construct and return a new queue
	-- @param sequence optional: The sequence to fill the queue with
	-- @return a Queue
	-- @usage local queue = Queue.New()
	-- @usage local queue = Queue.New({ 1, 2, 3 })
	-- @usage local queue = Queue.New(Enumerable.RangeTo(1, 10))
	function Queue.New(sequence)
		check(1, sequence, 'userdata', 'table', 'nil')

		local self = newproxy(Queue_proxy)

		tables[self] = {}
		heads[self] = 1
		tails[self] = 0

		if sequence ~= nil then
			Enumerable.From(sequence):ForEach(function(item)
				self:Enqueue(item)
			end)
		end

		return self
	end
	
	--- Construct and return a new queue based on the arguments provided
	-- @param ... a tuple of arguments to fill the queue with
	-- @return a Queue
	-- @usage local queue = Queue.FromArguments()
	-- @usage local queue = Queue.FromArguments(1, 2, 3)
	-- @usage local queue = Queue.FromArguments(nil, nil, 5)
	function Queue.FromArguments(...)
		local self = Queue.New()

		for i = 1, select('#', ...) do
			self:Enqueue((select(i, ...)))
		end

		return self
	end

	--- Return an Enumerator for the current Queue
	-- @return an Enumerator
	function Queue.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local table = tables[self]
		local index

		return Enumerator.New(
			function()
				index = heads[self] - 1
			end,
			function(yield)
				if index < tails[self] then
					index = index + 1
					return yield(table[index])
				else
					return false
				end
			end,
			nil)
	end

	--- Verify that the contract for this Queue is valid for all elements in the Queue.
	-- If there is no contract, this does nothing.
	-- @usage queue:VerifyContract()
	function Queue.prototype:VerifyContract()
		check(1, self, 'userdata')

		local contract = contracts[self]
		if not contract then
			return
		end
		
		local table = tables[self]
		local index = heads[self] - 1
		local tail = tails[self]
		while true do
			index = index + 1
			if index > tail then
				break
			end

			if not contract(table[index]) then
				error(("Element %s does not meet the contract for this Queue."):format(tostring_q(table[index])), 2)
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all values are strings or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the element and should return whether the element is valid.
	-- @usage queue:SetContract(function(v) return type(v) == "string" end)
	function Queue.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')

		contracts[self] = contract
		self:VerifyContract()
	end
	
	--- Return whether the Queue is read-only, always returns false.
	-- @return a boolean
	-- @usage local read_only = stack:IsReadOnly()
	function Queue.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return false
	end

	--- Add an element to end of the Queue
	-- @param item the element to add
	-- @usage queue:Enqueue(5)
	-- @usage queue:Enqueue(nil)
	function Queue.prototype:Enqueue(item)
		check(1, self, 'userdata')

		local contract = contracts[self]
		if contract and not contract(item) then
			error(("Element %s does not meet the contract for this Queue."):format(tostring_q(item)), 2)
		end

		local head = heads[self]
		local tail = tails[self]
		local table = tables[self]
		if head > 1 and head > tail then
			head = 1
			tail = 0
			heads[self] = head
		elseif head > SHRINK_THRESHOLD then
			local j = 0
			for i = head, tail do
				j = j + 1
				table[j], table[i] = table[i], nil
			end
			tail = tail - head + 1
			head = 1
			heads[self] = head
		end

		tail = tail + 1
		tails[self] = tail
		table[tail] = item
	end
	
	--- Removes and returns the object at the beginning of the Queue.
	-- This will error if the Queue contains no elements.
	-- @return The item removed.
	-- @usage local removed = queue:Dequeue()
	function Queue.prototype:Dequeue()
		check(1, self, 'userdata')

		local head = heads[self]
		local tail = tails[self]

		if tail < head then
			error("Queue contains no elements", 2)
		end

		local table = tables[self]
		local item = table[head]
		table[head] = nil
		heads[self] = head + 1

		return item
	end

	--- Returns the object at the beginning of the Queue without removing it.
	-- This will error if the Queue contains no elements.
	-- @return The item at the beginning.
	-- @usage local item = queue:Peek()
	function Queue.prototype:Peek()
		check(1, self, 'userdata')

		local head = heads[self]
		local tail = tails[self]

		if tail < head then
			error("Queue contains no elements", 2)
		end

		return tables[self][head]
	end

	--- Clear all elements from the Queue
	-- @usage queue:Clear()
	function Queue.prototype:Clear()
		check(1, self, 'userdata')

		wipe(tables[self])
		heads[self] = 1
		tails[self] = 0
	end

	--- Make a shallow clone of the Queue.
	-- @usage local other = queue:Clone()
	function Queue.prototype:Clone()
		check(1, self, 'userdata')

		local other = Queue.New()
		local contract = contracts[self]
		if contract then
			other:SetContract(contracts[self])
		end
		
		local table = tables[self]
		local other_table = tables[other]
		local j = 0
		for i = heads[self], tails[self] do
			j = j + 1

			other_table[j] = table[i]
		end
		heads[other] = 1
		tails[other] = tails[self] - heads[self] + 1

		return other
	end
	
	-- Methods that are faster than using the standard Enumerable ones:
	
	function Queue.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return tails[self] >= heads[self]
		else
			return Enumerable.prototype.Any(self, predicate)
		end
	end

	function Queue.prototype:Count(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return tails[self] - heads[self] + 1
		else
			return Enumerable.prototype.Count(self, predicate)
		end
	end
	
	function Queue.prototype:ElementAt(index)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 then
			error("index must be at least 1", 2)
		elseif math_floor(index) ~= index then
			error("index must be an integer", 2)
		elseif index > self:Count() then
			error("index is greater than the amount of elements in the source", 2)
		end

		return tables[self][heads[self] + index - 1]
	end
	
	function Queue.prototype:ElementAtOrDefault(index, default)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 or math_floor(index) ~= index or index > self:Count() then
			return default
		else
			return tables[self][heads[self] + index - 1]
		end
	end
	
	function Queue.prototype:First(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				error("First:no elements in the queue", 2)
			else
				return self:Peek()
			end
		else
			return Enumerable.prototype.First(self, predicate)
		end
	end
	
	function Queue.prototype:FirstOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				return default
			else
				return self:Peek()
			end
		else
			return Enumerable.prototype.FirstOrDefault(self, default, predicate)
		end
	end
	
	function Queue.prototype:Last(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				error("Last:no elements in the queue", 2)
			else
				return tables[self][heads[self]]
			end
		else
			return Enumerable.prototype.Last(self, predicate)
		end
	end
	
	function Queue.prototype:LastOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				return default
			else
				return tables[self][heads[self]]
			end
		else
			return Enumerable.prototype.LastOrDefault(self, default, predicate)
		end
	end
	
	function Queue.prototype:Single(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				error("Single:no elements in the queue", 2)
			elseif count > 1 then
				error("Single:more than 1 element in the queue", 2)
			else
				return tables[self][heads[self]]
			end
		else
			return Enumerable.prototype.Single(self, predicate)
		end
	end
	
	function Queue.prototype:SingleOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				return default
			elseif count > 1 then
				error("SingleOrDefault:more than 1 element in the queue", 2)
			else
				return tables[self][heads[self]]
			end
		else
			return Enumerable.prototype.SingleOrDefault(self, default, predicate)
		end
	end
	
	function Queue.prototype:SequenceEqual(second, compare_selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, compare_selector, 'function', 'string', 'nil')

		second = Enumerable.From(second)
		if tables[second] and self:Count() ~= second:Count() then
			return false
		end
		
		return Enumerable.prototype.SequenceEqual(self, second, compare_selector)
	end
	
	function Queue.prototype:Force()
	end
	
	function Queue.prototype:MemoizeAll()
		return self
	end

	function Queue.prototype:ToString()
		check(1, self, 'userdata')

		return "Queue" .. Enumerable.prototype.ToString(self)
	end

	function Queue.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convertFunction(action)

		local table = tables[self]
		local i = 0
		local index = heads[self] - 1
		while true do
			i = i + 1
			index = index + 1
			if index > tails[self] then
				break
			end

			if action(table[index], i) == false then
				break
			end
		end
	end
	
	local function iterator(self, index)
		index = index + 1

		local real_index = index + heads[self] - 1

		if real_index > tails[self] then
			return nil
		end

		return index, tables[self][real_index]
	end
	function Queue.prototype:Iterate()
		return iterator, self, 0
	end

	function Queue.prototype:PickRandom()
		check(1, self, 'userdata')

		local head = heads[self]
		local tail = tails[self]
		if head > tail then
			error("PickRandom:No elements in the Enumerable.", 2)
		end
		return tables[self][math_random(head, tail)]
	end
	
	function Queue.prototype:PickRandomOrDefault(default)
		check(1, self, 'userdata')
		
		local head = heads[self]
		local tail = tails[self]
		if head > tail then
			return default
		else
			return tables[self][math_random(head, tail)]
		end
	end

	--- Make a new Queue filled with the contents of the current Enumerable
	-- @return a Queue
	function Enumerable.prototype:ToQueue()
		check(1, self, 'userdata')

		return Queue.New(self)
	end
end)