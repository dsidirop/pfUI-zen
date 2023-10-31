_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local check = assert(Linquidate.Utilities.check)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)

	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local convert_function = assert(Linquidate.Utilities.convert_function)

	local type = assert(_G.type)
	
	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)

	do
		local NIL = _G.newproxy()
		--- Project each element of the sequence and flattens the resultant sequences using breadth-first search
		-- @param func a function that takes an element and selects the child sequence.
		-- @param result_selector optional: a function which takes an element and the nest level and whose result will be yielded.
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3 }):CascadeBreadthFirst(function(x) return x < 4 and Enumerable.Return(x + 1) or Enumerable.Empty() end):ToString() == "[1, 2, 3, 2, 3, 4, 3, 4, 4]"
		function Enumerable.prototype:CascadeBreadthFirst(func, result_selector)
			check(1, self, 'userdata')
			check(2, func, 'function', 'string')
			check(3, result_selector, 'function', 'string', 'nil')
			
			func = convert_function(func)
			result_selector = convert_function(result_selector)

			return Enumerable.New(function()
				local enumerator
				local nest_level = 0
				local buffer

				return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
						buffer = {}
					end, function(yield)
						while true do
							if enumerator:MoveNext() then
								local real_current = enumerator:Current()
								local current = real_current
								if current == nil then
									current = NIL
								end
								buffer[table.getn(buffer)+1] = current
								return yield(result_selector(real_current, nest_level))
							end

							local next = Enumerable.From(buffer):SelectMany(function(x)
								if x == NIL then
									return func(nil)
								else
									return func(x)
								end
							end)
							if not next:Any() then
								return false
							else
								nest_level = nest_level + 1
								buffer = {}
								safe_dispose(enumerator)
								enumerator = next:GetEnumerator()
							end
						end
					end, function()
						safe_dispose(enumerator)
						buffer = nil
					end)
			end)
		end
	end

	--- Project each element of the sequence and flattens the resultant sequences using depth-first search
	-- @param func a function that takes an element and selects the child sequence.
	-- @param result_selector optional: a function which takes an element and the nest level and whose result will be yielded.
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):CascadeDepthFirst(function(x) return x < 4 and Enumerable.Return(x + 1) or Enumerable.Empty() end):ToString() == "[1, 2, 3, 2, 3, 4, 3, 4, 4]"
	function Enumerable.prototype:CascadeDepthFirst(func, result_selector)
		check(1, self, 'userdata')
		check(2, func, 'function', 'string')
		check(3, result_selector, 'function', 'string', 'nil')
		
		func = convert_function(func)
		result_selector = convert_function(result_selector)

		return Enumerable.New(function()
			local enumerator_stack = {}
			local enumerator

			return Enumerator.New(
					function()
						enumerator = self:GetEnumerator()
					end,
					function(yield)
						while true do
							if enumerator:MoveNext() then
								local current = enumerator:Current()
								local value = result_selector(current, table.getn(enumerator_stack))
								enumerator_stack[table.getn(enumerator_stack) + 1] = enumerator
								enumerator = Enumerable.From(func(current)):GetEnumerator()
								return yield(value)
							end

							if table.getn(enumerator_stack) <= 0 then
								return false
							end

							enumerator = safe_dispose(enumerator)

							enumerator = enumerator_stack[table.getn(enumerator_stack)]
							enumerator_stack[table.getn(enumerator_stack)] = nil
						end
					end,
					function()
						tryfinally(
								function()
									safe_dispose(enumerator)
								end,
								function()
									for i = 1, table.getn(enumerator_stack) do
										safe_dispose(enumerator_stack[i])
									end
								end
						)
					end
			)
		end)
	end

	--- Flatten sequences into one sequence
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, { 2, 3 }, { { 4, 5 }, { 6, 7 } } }):Flatten()
	function Enumerable.prototype:Flatten()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local enumerator
			local middle_enumerator = nil

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					while true do
						if middle_enumerator then
							if middle_enumerator:MoveNext() then
								return yield(middle_enumerator:Current())
							else
								safe_dispose(middle_enumerator)
								middle_enumerator = nil
							end
						end

						if enumerator:MoveNext() then
							local current = enumerator:Current()
							if type(current) == "table" or Enumerable.IsEnumerable(current) then
								middle_enumerator = Enumerable.From(current)
									:Flatten()
									:GetEnumerator()
							else
								return yield(current)
							end
						else
							return false
						end
					end
				end, function()
					tryfinally(function()
						safe_dispose(enumerator)
					end, function()
						safe_dispose(middle_enumerator)
					end)
				end)
		end)
	end

	--- Projects current and next element of a sequence into a new form.
	-- @param selector A function to call whose results will be yielded.
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Pairwise(function(x, y) return x + y end):ToString() == "[3, 5, 7]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Pairwise("x, y => x + y"):ToString() == "[3, 5, 7]"
	function Enumerable.prototype:Pairwise(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string')

		selector = convert_function(selector)

		return Enumerable.New(function()
			local enumerator

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
					enumerator:MoveNext()
				end, function(yield)
					local previous = enumerator:Current()
					if enumerator:MoveNext() then
						return yield(selector(previous, enumerator:Current()))
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Apply an accumulation function over a sequence
	-- @param seed optional: The initial accumulation seed
	-- @param func The function to be invoked on each element
	-- @param result_selector optional: A function to transform each accumulator value
	-- @return An Enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Scan(function(a, b) return a + b end):ToString() == "[1, 3, 6, 10]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Scan(0, function(a, b) return a + b end):ToString() == "[0, 1, 3, 6, 10]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Scan(0, function(a, b) return a + b end, function(v) return v * 2 end):ToString() == "[0, 2, 6, 12, 20]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Scan("a, b => a + b"):ToString() == "[1, 3, 6, 10]"
	function Enumerable.prototype:Scan(seed, func, result_selector)
		check(1, self, 'userdata')
		if not func then
			check(2, seed, 'function', 'string')
			check(4, result_selector, 'nil')
		else
			check(3, func, 'function', 'string')
			check(4, result_selector, 'function', 'string', 'nil')
		end
		if result_selector then
			return self:Scan(seed, func):Select(result_selector)
		end
	
		local is_use_seed = not not func
		if not is_use_seed then
			func = seed
		end

		func = convert_function(func)

		return Enumerable.New(function()
			local enumerator
			local value
			local is_first = true

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					if is_first then
						is_first = false;
						if not is_use_seed then
							if enumerator:MoveNext() then
								value = enumerator:Current()
								return yield(value)
							else
								return false
							end
						else
							value = seed
							return yield(value)
						end
					end

					if enumerator:MoveNext() then
						value = func(value, enumerator:Current())
						return yield(value)
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Project each element of the sequence to a new element.
	-- @param selector the transform function which takes the item and the 1-based index
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Select(function(x) return x*x end):ToString() == "[1, 4, 9]"
	-- @usage Enumerable.From({ 1, 2, 3 }):Select("x => x*x"):ToString() == "[1, 4, 9]"
	function Enumerable.prototype:Select(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string')
		
		selector = convert_function(selector)
	
		return Enumerable.New(function()
			local enumerator = nil
			local index = 0

			return Enumerator.New(function()
				enumerator = self:GetEnumerator()
			end, function(yield)
				if enumerator:MoveNext() then
					index = index + 1
					return yield(selector(enumerator:Current(), index))
				else
					return false
				end
			end, function()
				safe_dispose(enumerator)
			end)
		end)
	end

	do
		local SelectMany_default_result_selector = function(a, b) return b end
		--- Project each element of the sequence to a new sequence, flattening the resultant sequences.
		-- @param collection_selector the transform function which takes the item and the 1-based index
		-- @param result_selector optional: a function that takes the input element and each resultant element.
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, 2, 3 }):SelectMany(function(x) return Enumerable.Range(1, x) end):ToString() == "[1, 1, 2, 1, 2, 3]"
		-- @usage Enumerable.From({ 1, 2, 3 }):SelectMany(function(x) return Enumerable.Range(1, x) end, function(a, b) return a * b end):ToString() == "[1, 2, 4, 3, 6, 9]"
		function Enumerable.prototype:SelectMany(collection_selector, result_selector)
			check(1, self, 'userdata')
			check(2, collection_selector, 'function', 'string')
			check(2, result_selector, 'function', 'string', 'nil')

			collection_selector = convert_function(collection_selector)
			result_selector = convert_function(result_selector or SelectMany_default_result_selector)

			return Enumerable.New(function()
				local enumerator
				local middle_enumerator = false
				local index = 0

				return Enumerator.New(function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					if middle_enumerator == false then
						if not enumerator:MoveNext() then
							return false
						end
					end

					repeat
						if not middle_enumerator then
							index = index + 1
							local middle_sequence = collection_selector(enumerator:Current(), index)
							middle_enumerator = Enumerable.From(middle_sequence):GetEnumerator()
						end
						if middle_enumerator:MoveNext() then
							return yield(result_selector(enumerator:Current(), middle_enumerator:Current()));
						end
						safe_dispose(middle_enumerator)
						middle_enumerator = nil
					until not enumerator:MoveNext()

					return false
				end, function()
					tryfinally(function()
						safe_dispose(enumerator)
					end, function()
						safe_dispose(middle_enumerator)
					end)
				end)
			end)
		end
	end

	--- Filter the Enumerable based on the predicate provided
	-- @param predicate a function to test each source element that takes the element and the 1-based index and returna a boolean.
	-- @return An enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Where(function(x) return x % 2 == 0 end):ToString() == "[2, 4]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Where("x => x%2 == 0"):ToString() == "[2, 4]"
	function Enumerable.prototype:Where(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		predicate = convert_function(predicate)
	
		return Enumerable.New(function()
			local enumerator
			local index = 0

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					while enumerator:MoveNext() do
						local current = enumerator:Current()
						index = index + 1
						if predicate(current, index) then
							return yield(current)
						end
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	do
		local of_type_cache = {}
		--- Filter the enumerable based on the given type
		-- @param type_name the name of the type.
		-- @return an Enumerable
		-- @usage Enumerable.From({ 1, "hey", function() end, "there" }):OfType("string"):ToString() == '["hey", "there"]'
		function Enumerable.prototype:OfType(type_name)
			check(1, self, 'userdata')
			check(2, type_name, 'string')
			
			local predicate = of_type_cache[type_name]
			if not predicate then
				predicate = function(x) return type(x) == type_name end
				of_type_cache[type_name] = predicate
			end
			
			return self:Where(predicate)
		end
	end

	--- Merge two sequences using the specified selector.
	-- The resultant Enumerable will only be as long as the shortest enumerable zipped upon.
	-- @param second the sequence to merge onto
	-- @param selector a function which takes two elements and the 1-based index and returns an element
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Zip({ 6, 7, 8 }, function(a, b, i) return a + b end):ToString() == "[7, 9, 11]"
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Zip({ 6, 7, 8 }, "a, b => a+b"):ToString() == "[7, 9, 11]"
	function Enumerable.prototype:Zip(second, selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, selector, 'function', 'string')

		selector = convert_function(selector)

		return Enumerable.New(function()
			local first_enumerator
			local second_enumerator
			local index = 0

			return Enumerator.New(
				function()
					first_enumerator = self:GetEnumerator()
					second_enumerator = Enumerable.From(second):GetEnumerator()
				end, function(yield)
					if first_enumerator:MoveNext() and second_enumerator:MoveNext() then
						index = index + 1
						return yield(selector(first_enumerator:Current(), second_enumerator:Current(), index))
					else
						return false
					end
				end, function()
					tryfinally(function()
						safe_dispose(first_enumerator)
					end, function()
						safe_dispose(second_enumerator)
					end)
				end)
		end)
	end
end)