_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert
	
	local check = assert(Linquidate.Utilities.check)
	local identity = assert(Linquidate.Utilities.identity)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local convert_function = assert(Linquidate.Utilities.convert_function)

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)

	--- Return whether all elements in the sequence satisfy a predicate
	-- @param predicate a function that takes an element and the index and returns a boolean
	-- @return a boolean whether all elements in the sequence satisfy a predicate
	-- @usage Enumerable.From({ 1, 2, 3 }):All(function(x) return x % 2 == 1 end) == false
	-- @usage Enumerable.From({ 1, 3, 5 }):All(function(x) return x % 2 == 1 end) == true
	-- @usage Enumerable.From({ 1, 3, 5 }):All("x => x%2 == 1") == true
	function Enumerable.prototype:All(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		predicate = convert_function(predicate)

		local result = true
		self:ForEach(function(x, i)
			if not predicate(x, i) then
				result = false
				return false
			end
		end)
		return result
	end

	--- Return whether any of the elements in the sequence satisfy a predicate, or the sequence has any elements
	-- @param predicate optional: a function that takes an element and the index and returns a boolean
	-- @return a boolean whether any of the elements in the sequence satisfy a predicate, or the sequence has any elements
	-- @usage Enumerable.Empty():Any() == false
	-- @usage Enumerable.From({ 1 }):Any() == true
	-- @usage Enumerable.From({ 1, 2, 3 }):Any(function(x) return x % 2 == 0 end) == true
	-- @usage Enumerable.From({ 1, 3, 5 }):Any(function(x) return x % 2 == 0 end) == false
	-- @usage Enumerable.From({ 1, 2, 3 }):Any("x => x%2 == 0") == true
	function Enumerable.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			local enumerator = self:GetEnumerator()
			return tryfinally(function()
				return enumerator:MoveNext()
			end, function()
				safe_dispose(enumerator)
			end)
		else
			predicate = convert_function(predicate)
			local result = false
			self:ForEach(function(x, i)
				if predicate(x, i) then
					result = true
					return false
				end
			end)
			return result
		end
	end

	--- Concatenate two sequences
	-- @param second The sequence to concatenate
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Concat({ 4, 5, 6 }):ToString() == "[1, 2, 3, 4, 5, 6]"
	function Enumerable.prototype:Concat(second)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')

		if self == Enumerable.Empty() then
			return Enumerable.From(second)
		elseif second == Enumerable.Empty() then
			return self
		end

		return Enumerable.New(function()
			local done_first = false
			local enumerator

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end,
				function(yield)
					if enumerator:MoveNext() then
						return yield(enumerator:Current())
					elseif done_first then
						return false
					else
						done_first = true
						enumerator = safe_dispose(enumerator)
						enumerator = Enumerable.From(second):GetEnumerator()
						if enumerator:MoveNext() then
							return yield(enumerator:Current())
						else
							return false
						end
					end
				end,
				function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Returns whether the sequence contains an element
	-- @param value The element to check for
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Contains(2) == true
	-- @usage Enumerable.From({ 1, 2, 3 }):Contains(0) == false
	function Enumerable.prototype:Contains(value)
		check(1, self, 'userdata')

		local found = false
		self:ForEach(function(item)
			if item == value then
				found = true
				return false
			end
		end)
		return found
	end

	--- Returns the elements in the sequence or a single default element if empty
	-- @param default The default element to use
	-- @return an Enumerable
	-- @usage Enumerable.Empty():DefaultIfEmpty(2):ToString() == "[2]"
	-- @usage Enumerable.From({ 1, 2, 3 }):DefaultIfEmpty(2):ToString() == "[1, 2, 3]"
	function Enumerable.prototype:DefaultIfEmpty(default)
		if self == Enumerable.Empty() then
			return Enumerable.Return(default)
		end

		return Enumerable.New(function()
			local enumerator
			local is_first = true

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					if enumerator:MoveNext() then
						is_first = false
						return yield(enumerator:Current())
					elseif is_first then
						is_first = false
						return yield(default)
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Returns a sequence with unique elements
	-- @param compare_selector optional: a function to use when comparing 
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 1, 2, 3, 1, 2 }):Distinct():ToString() == "[1, 2, 3]"
	-- @usage Enumerable.From({ 1, 1, 2, 3, "1", "2" }):Distinct():ToString() == '[1, 2, 3, "1", "2"]'
	-- @usage Enumerable.From({ 1, 1, 2, 3, "1", "2" }):Distinct(tostring):ToString() == '[1, 2, 3]'
	function Enumerable.prototype:Distinct(compare_selector)
		check(1, self, 'userdata')
		check(2, compare_selector, 'function', 'string', 'nil')

		return self:Except(Enumerable.Empty(), compare_selector)
	end

	do
		local NIL = _G.newproxy()
		--- Returns the set difference between two sequences
		-- @param second The sequence whose elements will be removed from the first sequence if found
		-- @param compare_selector optional: a function to use when comparing 
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3, 4, 5 }):Except({ 2, 4 }):ToString() == "[1, 3, 5]"
		function Enumerable.prototype:Except(second, compare_selector)
			check(1, self, 'userdata')
			check(2, second, 'userdata', 'table')
			check(3, compare_selector, 'function', 'string', 'nil')

			compare_selector = convert_function(compare_selector)

			return Enumerable.New(function()
				local enumerator
				local keys
		
				return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
						keys = {}

						Enumerable.From(second)
							:ForEach(function(key)
								local value = compare_selector(key)
								if value == nil then
									value = NIL
								end
								keys[value] = true
							end)
					end, function(yield)
						while enumerator:MoveNext() do
							local real_current = enumerator:Current()
							local current = compare_selector(real_current)
							if current == nil then
								current = NIL
							end

							if not keys[current] then
								keys[current] = true
								return yield(real_current)
							end
						end

						return false
					end, function()
						safe_dispose(enumerator)
						keys = nil
					end)
			end)
		end
	end

	do
		local NIL = _G.newproxy()
		--- Returns the set intersection between two sequences
		-- @param second The sequence whose elements will be kept in the first sequence if found
		-- @param compare_selector optional: a function to use when comparing 
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3, 4, 5 }):Intersect({ 0, 2, 4 }):ToString() == "[2, 4]"
		function Enumerable.prototype:Intersect(second, compare_selector)
			check(1, self, 'userdata')
			check(2, second, 'userdata', 'table')
			check(3, compare_selector, 'function', 'string', 'nil')

			compare_selector = convert_function(compare_selector)

			return Enumerable.New(function()
				local enumerator
				local keys

				return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
						keys = {}
					
						Enumerable.From(second)
							:ForEach(function(key)
								local value = compare_selector(key)
								if value == nil then
									value = NIL
								end
								keys[value] = true
							end)
					end, function(yield)
						while enumerator:MoveNext() do
							local real_current = enumerator:Current()
							local current = compare_selector(real_current)
							if current == nil then
								current = NIL
							end
							if keys[current] then
								keys[current] = nil
								return yield(real_current)
							end
						end
						return false
					end, function()
						safe_dispose(enumerator)
						keys = nil
					end)
			end)
		end
	end

	--- Return whether the sequences are equal by comparing the elements
	-- @param second The other sequence to compare to
	-- @param compare_selector optional: a function to use when comparing 
	-- @return whether the sequences are equal
	-- @usage Enumerable.From({ 1, 2, 3 }):SequenceEqual({ 1, 2, 3 }) == true
	function Enumerable.prototype:SequenceEqual(second, compare_selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, compare_selector, 'function', 'string', 'nil')

		compare_selector = convert_function(compare_selector)

		local first_enumerator = self:GetEnumerator()
		return tryfinally(function()
			local second_enumerator = Enumerable.From(second):GetEnumerator()
			return tryfinally(function()
				while first_enumerator:MoveNext() do
					if not second_enumerator:MoveNext() or compare_selector(first_enumerator:Current()) ~= compare_selector(second_enumerator:Current()) then
						return false
					end
				end

				return not second_enumerator:MoveNext()
			end, function()
				safe_dispose(second_enumerator)
			end)
		end, function()
			safe_dispose(first_enumerator)
		end)
	end

	do
		local NIL = _G.newproxy()
		--- Returns the set union between two sequences
		-- @param second The sequence whose elements will be kept in the first sequence if found
		-- @param compare_selector optional: a function to use when comparing 
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 4, 5 }):Union({ 0, 2, 3, 4 }):ToString() == "[0, 1, 2, 3, 4, 5]"
		function Enumerable.prototype:Union(second, compare_selector)
			check(1, self, 'userdata')
			check(2, second, 'userdata', 'table')
			check(3, compare_selector, 'function', 'string', 'nil')

			compare_selector = convert_function(compare_selector)

			return Enumerable.New(function()
				local enumerator
				local keys
				local done_first = false

				return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
						keys = {}
					end,
					function(yield)
						while true do
							while enumerator:MoveNext() do
								local real_current = enumerator:Current()
								local current = compare_selector(real_current)
								if current == nil then
									current = NIL
								end
								if not keys[current] then
									keys[current] = true
									return yield(current)
								end
							end
							if not done_first then
								enumerator = safe_dispose(enumerator)
								done_first = true
								enumerator = Enumerable.From(second):GetEnumerator()
							else
								return false
							end
						end
					end, function()
						safe_dispose(enumerator)
						keys = nil
					end)
			end)
		end
	end
end)