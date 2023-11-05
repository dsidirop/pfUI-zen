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

	local queue = Linquidate.Queue or {}

	Linquidate.Queue = queue

	if not queue.prototype then
		queue.prototype = {}
	end
	setmetatable(queue.prototype, { __index= enumerable.prototype})
	
	local queue_proxy = newproxy(true)
	local queue_mt = getmetatable(queue_proxy)
	queue_mt.__index = queue.prototype
	function queue_mt:__tostring()
		return self:ToString()
	end
	
	local tables = make_weak_keyed_table(queue.__tables)
	queue.__tables = tables
	local heads = make_weak_keyed_table(queue.__heads)
	queue.__heads = heads
	local tails = make_weak_keyed_table(queue.__tails)
	queue.__tails = tails
	local contracts = make_weak_keyed_table(queue.__contracts)
	queue.__contracts = contracts
	
	local SHRINK_THRESHOLD = 32
	assert(SHRINK_THRESHOLD >= 1) -- do not remove this

	--- Construct and return a new queue
	-- @param sequence optional: The sequence to fill the queue with
	-- @return a Queue
	-- @usage local queue = Queue.New()
	-- @usage local queue = Queue.New({ 1, 2, 3 })
	-- @usage local queue = Queue.New(Enumerable.RangeTo(1, 10))
	function queue.New(sequence)
		check(1, sequence, 'userdata', 'table', 'nil')

		local self = newproxy(queue_proxy)

		tables[self] = {}
		heads[self] = 1
		tails[self] = 0

		if sequence ~= nil then
			enumerable.From(sequence):ForEach(function(item)
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
	function queue.FromArguments(...)
		local self = queue.New()

		for i = 1, table.getn(arg) do
			self:Enqueue((arg[i]))
		end

		return self
	end

	--- Return an Enumerator for the current Queue
	-- @return an Enumerator
	function queue.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local table = tables[self]
		local index

		return enumerator.New(
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
	function queue.prototype:VerifyContract()
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
				error(string.format("Element %s does not meet the contract for this Queue.", tostring_q(table[index])), 2)
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all values are strings or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the element and should return whether the element is valid.
	-- @usage queue:SetContract(function(v) return type(v) == "string" end)
	function queue.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')

		contracts[self] = contract
		self:VerifyContract()
	end
	
	--- Return whether the Queue is read-only, always returns false.
	-- @return a boolean
	-- @usage local read_only = stack:IsReadOnly()
	function queue.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return false
	end

	--- Add an element to end of the Queue
	-- @param item the element to add
	-- @usage queue:Enqueue(5)
	-- @usage queue:Enqueue(nil)
	function queue.prototype:Enqueue(item)
		check(1, self, 'userdata')

		local contract = contracts[self]
		if contract and not contract(item) then
			error(string.format("Element %s does not meet the contract for this Queue.", tostring_q(item)), 2)
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
	function queue.prototype:Dequeue()
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
	function queue.prototype:Peek()
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
	function queue.prototype:Clear()
		check(1, self, 'userdata')

		wipe(tables[self])
		heads[self] = 1
		tails[self] = 0
	end

	--- Make a shallow clone of the Queue.
	-- @usage local other = queue:Clone()
	function queue.prototype:Clone()
		check(1, self, 'userdata')

		local other = queue.New()
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
	
	function queue.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return tails[self] >= heads[self]
		else
			return enumerable.prototype.Any(self, predicate)
		end
	end

	function queue.prototype:Count(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return tails[self] - heads[self] + 1
		else
			return enumerable.prototype.Count(self, predicate)
		end
	end
	
	function queue.prototype:ElementAt(index)
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
	
	function queue.prototype:ElementAtOrDefault(index, default)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 or math_floor(index) ~= index or index > self:Count() then
			return default
		else
			return tables[self][heads[self] + index - 1]
		end
	end
	
	function queue.prototype:First(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				error("First:no elements in the queue", 2)
			else
				return self:Peek()
			end
		else
			return enumerable.prototype.First(self, predicate)
		end
	end
	
	function queue.prototype:FirstOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				return default
			else
				return self:Peek()
			end
		else
			return enumerable.prototype.FirstOrDefault(self, default, predicate)
		end
	end
	
	function queue.prototype:Last(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				error("Last:no elements in the queue", 2)
			else
				return tables[self][heads[self]]
			end
		else
			return enumerable.prototype.Last(self, predicate)
		end
	end
	
	function queue.prototype:LastOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if not self:Any() then
				return default
			else
				return tables[self][heads[self]]
			end
		else
			return enumerable.prototype.LastOrDefault(self, default, predicate)
		end
	end
	
	function queue.prototype:Single(predicate)
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
			return enumerable.prototype.Single(self, predicate)
		end
	end
	
	function queue.prototype:SingleOrDefault(default, predicate)
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
			return enumerable.prototype.SingleOrDefault(self, default, predicate)
		end
	end
	
	function queue.prototype:SequenceEqual(second, compare_selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, compare_selector, 'function', 'string', 'nil')

		second = enumerable.From(second)
		if tables[second] and self:Count() ~= second:Count() then
			return false
		end
		
		return enumerable.prototype.SequenceEqual(self, second, compare_selector)
	end
	
	function queue.prototype:Force()
	end
	
	function queue.prototype:MemoizeAll()
		return self
	end

	function queue.prototype:ToString()
		check(1, self, 'userdata')

		return "Queue" .. enumerable.prototype.ToString(self)
	end

	function queue.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convert_function(action)

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
	function queue.prototype:Iterate()
		return iterator, self, 0
	end

	function queue.prototype:PickRandom()
		check(1, self, 'userdata')

		local head = heads[self]
		local tail = tails[self]
		if head > tail then
			error("PickRandom:No elements in the Enumerable.", 2)
		end
		return tables[self][math_random(head, tail)]
	end
	
	function queue.prototype:PickRandomOrDefault(default)
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
	function enumerable.prototype:ToQueue()
		check(1, self, 'userdata')

		return queue.New(self)
	end
end)