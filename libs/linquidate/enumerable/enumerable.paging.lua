_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert
	
	local check = assert(Linquidate.Utilities.check)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local convert_function = assert(Linquidate.Utilities.convert_function)
	
	local error = assert(_G.error)
	local math_floor = assert(_G.math.floor)
	local math_random = assert(_G.math.random)
	local table_remove = assert(_G.table.remove)

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)

	--- Return the element at a specified index in a sequence.
	-- This will error if the element does not exist.
	-- @param index the 1-based index of the element
	-- @return an element of the sequence
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ElementAt(1) == 'a'
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ElementAt(2) == 'b'
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ElementAt(3) == 'c'
	function Enumerable.prototype:ElementAt(index)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 then
			error("index must be at least 1", 2)
		elseif math_floor(index) ~= index then
			error("index must be an integer", 2)
		end
		local value
		local found = false
		self:ForEach(function(x, i)
			if i == index then
				value = x
				found = true
				return false
			end
		end)

		if not found then
			error("index is less than 1 or greater than the number of elements in source.", 2)
		end
		return value
	end

	--- Return the element at a specified index in a sequence, or a default if the index is out of range.
	-- @param index the 1-based index of the element
	-- @param default the default value to return if the index is out of range.
	-- @return an element of the sequence or the default value
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ElementAtOrDefault(1, 'x') == 'a'
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ElementAtOrDefault(4, 'x') == 'x'
	function Enumerable.prototype:ElementAtOrDefault(index, default)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 or math_floor(index) ~= index then
			return default
		end

		local value
		local found = false
		self:ForEach(function(x, i)
			if i == index then
				value = x
				found = true
				return false
			end
		end)

		if not found then
			return default
		else
			return value
		end
	end

	--- Return the first element in the sequence.
	-- If the sequence contains no elements, this will error.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the first value that satisfies the predicate
	-- @usage Enumerable.From({ 1, 2, 3 }):First() == 1
	-- @usage Enumerable.From({ 1, 2, 3 }):First(function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):First("x => x%2 == 0") == 2
	function Enumerable.prototype:First(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')
	
		if predicate then
			return self:Where(predicate):First()
		end

		local value
		local found = false
		self:ForEach(function(x)
			value = x
			found = true
			return false
		end)

		if not found then
			error("First:No element satisfies the condition.", 2)
		end
		return value
	end

	--- Return the first element in the sequence or a default if one can't be found.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the first value that satisfies the predicate
	-- @usage Enumerable.From({ 1, 2, 3 }):FirstOrDefault(0) == 1
	-- @usage Enumerable.Empty():FirstOrDefault(0) == 0
	-- @usage Enumerable.From({ 1, 2, 3 }):FirstOrDefault(0, function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):FirstOrDefault(0, "x => x%2 == 0") == 2
	-- @usage Enumerable.From({ 1, 3, 5 }):FirstOrDefault(0, function(x) return x % 2 == 0 end) == 0
	function Enumerable.prototype:FirstOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):FirstOrDefault(default)
		end

		local value
		local found = false
		self:ForEach(function(x)
			value = x
			found = true
			return false
		end)

		if not found then
			return default
		else
			return value
		end
	end

	--- Return the last element in the sequence.
	-- If the sequence contains no elements, this will error.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the first value that satisfies the predicate
	-- @usage Enumerable.From({ 1, 2, 3 }):Last() == 3
	-- @usage Enumerable.From({ 1, 2, 3 }):Last(function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):Last("x => x%2 == 0") == 2
	function Enumerable.prototype:Last(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):Last()
		end

		local value
		local found = false
		self:ForEach(function(x)
			value = x
			found = true
		end)

		if not found then
			error("Last:No element satisfies the condition.", 2)
		end
		return value
	end

	--- Return the last element in the sequence or a default if one can't be found.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the last value that satisfies the predicate
	-- @usage Enumerable.From({ 1, 2, 3 }):LastOrDefault(0) == 3
	-- @usage Enumerable.Empty():LastOrDefault(0) == 0
	-- @usage Enumerable.From({ 1, 2, 3 }):LastOrDefault(0, function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):LastOrDefault(0, "x => x%2 == 0") == 2
	-- @usage Enumerable.From({ 1, 3, 5 }):LastOrDefault(0, function(x) return x % 2 == 0 end) == 0
	function Enumerable.prototype:LastOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):LastOrDefault(default)
		end

		local value
		local found = false
		self:ForEach(function(x)
			value = x
			found = true
		end)

		if not found then
			return default
		else
			return value
		end
	end

	--- Return the singular element in the sequence.
	-- If the sequence contains no elements, this will error.
	-- If the sequence contains more than one element, this will error.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the singular value that satisfies the predicate
	-- @usage Enumerable.From({ 1 }):Single() == 1
	-- @usage Enumerable.From({ 1, 2, 3 }):Single(function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):Single("x => x%2 == 0") == 2
	function Enumerable.prototype:Single(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):Single()
		end

		local value
		local found = false
		self:ForEach(function(x)
			if found then
				error("Single:Sequence contains more than one element.", 2)
			end
			value = x
			found = true
		end)

		if not found then
			error("Single:No element satisfies the condition.", 2)
		end
		return value
	end

	--- Return the singular element in the sequence or a default if one can't be found.
	-- If the sequence contains more than one element, this will error.
	-- @param predicate optional: A filter to apply to the sequence.
	-- @return the first value that satisfies the predicate
	-- @usage Enumerable.From({ 1 }):SingleOrDefault(0) == 1
	-- @usage Enumerable.Empty():SingleOrDefault(0) == 0
	-- @usage Enumerable.From({ 1, 2, 3 }):SingleOrDefault(0, function(x) return x % 2 == 0 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):SingleOrDefault(0, "x => x%2 == 0") == 2
	-- @usage Enumerable.From({ 1, 3, 5 }):SingleOrDefault(0, function(x) return x % 2 == 0 end) == 0
	function Enumerable.prototype:SingleOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):SingleOrDefault(default)
		end

		local value
		local found = false
		self:ForEach(function(x)
			if found then
				error("SingleOrDefault:Sequence contains more than one element.", 2)
			end
			value = x
			found = true
		end)

		if not found then
			return default
		else
			return value
		end
	end

	--- Bypass a specified number of items and return the remaining elements
	-- @param count the number of elements to skip over
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Skip(1):ToString() == "[2, 3]"
	function Enumerable.prototype:Skip(count)
		check(1, self, 'userdata')
		check(2, count, 'number')

		if count <= 0 then
			return self
		end
		local source = self

		return Enumerable.New(function()
			local enumerator
			local index = 0

			return Enumerator.New(
				function()
					enumerator = source:GetEnumerator()

					while index < count do
						index = index + 1
						if not enumerator:MoveNext() then
							break
						end
					end
				end, function(yield)
					if enumerator:MoveNext() then
						return yield(enumerator:Current())
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Bypass elements in a sequence as long as a predicate remains true, then return the rest of the elements
	-- @param predicate the function to be run to check whether to skip an element
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):SkipWhile(function(x) return x ~= 2 end):ToString() == "[2, 3]"
	-- @usage Enumerable.From({ 1, 2, 3 }):SkipWhile("x => x ~= 2"):ToString() == "[2, 3]"
	function Enumerable.prototype:SkipWhile(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		predicate = convert_function(predicate)

		return Enumerable.New(function()
			local enumerator
			local index = 0
			local is_skip_end = false

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					while not is_skip_end do
						if enumerator:MoveNext() then
							local current = enumerator:Current()
							index = index + 1
							if not predicate(current, index) then
								is_skip_end = true
								return yield(current)
							end
						else
							return false
						end
					end

					if enumerator:MoveNext() then
						return yield(enumerator:Current())
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Returns a specified number of elements in a sequence
	-- @param count the number of elements to return
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Take(2):ToString() == "[1, 2]"
	function Enumerable.prototype:Take(count)
		check(1, self, 'userdata')
		check(2, count, 'number')

		if count <= 0 then
			return Enumerable.Empty()
		end
		local source = self

		return Enumerable.New(function()
			local enumerator
			local index = 0

			return Enumerator.New(
				function()
					enumerator = source:GetEnumerator()
				end, function(yield)
					index = index + 1
					if index <= count and enumerator:MoveNext() then
						return yield(enumerator:Current())
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Return elements in a sequence as long as a predicate remains true, then stop abruptly
	-- @param predicate the function to be run to check whether to return an element
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):TakeWhile(function(x) return x ~= 2 end):ToString() == "[1]"
	-- @usage Enumerable.From({ 1, 2, 3 }):TakeWhile("x => x ~= 2"):ToString() == "[1]"
	function Enumerable.prototype:TakeWhile(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		predicate = convert_function(predicate)

		return Enumerable.New(function()
			local enumerator
			local index = 0

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end,
				function(yield)
					index = index + 1
					if enumerator:MoveNext() and predicate(enumerator:Current(), index) then
						return yield(enumerator:Current())
					else
						return false
					end
				end,
				function()
					safe_dispose(enumerator)
				end)
		end)
	end

	do
		local NIL = _G.newproxy()
		--- Return the elements in a sequence except for the last count
		-- @param count optional: the amount of elements to skip at the end
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3 }):TakeExceptLast():ToString() == "[1, 2]"
		-- @usage Enumerable.From({ 1, 2, 3 }):TakeExceptLast(2):ToString() == "[1]"
		function Enumerable.prototype:TakeExceptLast(count)
			check(1, self, 'userdata')
			check(2, count, 'number', 'nil')

			if not count then
				count = 1
			end
			if count <= 0 then
				return self
			end

			return Enumerable.New(function()
				local enumerator
				local queue

				return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
						queue = {}
					end, function(yield)
						while enumerator:MoveNext() do
							local current = enumerator:Current()
							if current == nil then
								current = NIL
							end
							queue[table.getn(queue) + 1] = current
							if table.getn(queue) > count then
								local value = table_remove(queue, 1)
								if value == NIL then
									value = nil
								end
								return yield(value)
							end
						end
						return false
					end, function()
						safe_dispose(enumerator)
					end)
			end)
		end
	end

	do
		local NIL = _G.newproxy()
		--- Return the last elements in a sequence
		-- @param count optional: the amount of elements to skip at the end
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3 }):TakeFromLast():ToString() == "[3]"
		-- @usage Enumerable.From({ 1, 2, 3 }):TakeFromLast(2):ToString() == "[2, 3]"
		function Enumerable.prototype:TakeFromLast(count)
			check(1, self, 'userdata')
			check(2, count, 'number', 'nil')

			if not count then
				count = 1
			end

			if count <= 0 then
				return Enumerable.Empty()
			end

			return Enumerable.New(function()
				local source_enumerator
				local enumerator
				local queue

				return Enumerator.New(
					function()
						source_enumerator = self:GetEnumerator()
						queue = {}
					end, function(yield)
						while source_enumerator:MoveNext() do
							if table.getn(queue) >= count then
								table_remove(queue, 1)
							end
							local current = source_enumerator:Current()
							if current == nil then
								current = NIL
							end
							queue[table.getn(queue)+1] = current
						end

						if not enumerator then
							enumerator = Enumerable.From(queue):GetEnumerator()
						end

						if enumerator:MoveNext() then
							local value = enumerator:Current()
							if value == NIL then
								value = nil
							end
							return yield(value)
						else
							return false
						end
					end, function()
						safe_dispose(enumerator)
					end)
			end)
		end
	end

	--- Returns the 1-based index of the first occurrence of a value.
	-- This will return -1 if the value cannot be found
	-- @param item the value to search for
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):IndexOf('b') == 2
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):IndexOf('d') == -1
	function Enumerable.prototype:IndexOf(item)
		check(1, self, 'userdata')
		local index = -1
		self:ForEach(function(x, i)
			if x == item then
				index = i
				return false
			end
		end)

		return index
	end

	--- Returns the 1-based index of the last occurrence of a value.
	-- This will return -1 if the value cannot be found
	-- @param item the value to search for
	-- @usage Enumerable.From({ 'a', 'b', 'c', 'b' }):LastIndexOf('b') == 4
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):LastIndexOf('d') == -1
	function Enumerable.prototype:LastIndexOf(item)
		check(1, self, 'userdata')
		local index = -1
		self:ForEach(function(x, i)
			if x == item then
				index = i
			end
		end)

		return index
	end

	do
		local NIL = _G.newproxy()
		--- Return a randomly-chosen element from the sequence.
		-- If the sequence contains no elements, this will error.
		-- @return a random value
		-- @usage Enumerable.From({ 1, 2, 3 }):PickRandom() == 2
		function Enumerable.prototype:PickRandom()
			check(1, self, 'userdata')

			local value = self:PickRandomOrDefault(NIL)
			if value == NIL then
				error("PickRandom:No elements in the Enumerable.", 2)
			else
				return value
			end
		end
	end
	
	--- Return a randomly-chosen element from the sequence or a default if one can't be found.
	-- If the sequence contains no elements, this will error.
	-- @param default the default value to return if the sequence is empty
	-- @return a random value
	-- @usage Enumerable.From({ 1, 2, 3 }):PickRandomOrDefault(0) == 2
	-- @usage Enumerable.From({ }):PickRandomOrDefault(0) == 0
	function Enumerable.prototype:PickRandomOrDefault(default)
		check(1, self, 'userdata')
		
		local value
		local found = false
		self:ForEach(function(x, i)
			found = true
			if i == 1 or math_random(i) == i then
				value = x
			end
		end)

		if not found then
			return default
		else
			return value
		end
	end
end)