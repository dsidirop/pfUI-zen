_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local check = assert(Linquidate.Utilities.check)
	local convert_function = assert(Linquidate.Utilities.convert_function)

	local math_random = assert(_G.math.random)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local newproxy = assert(_G.newproxy)
	local type = assert(_G.type)
	local pcall = assert(_G.pcall)
	local tostring = assert(_G.tostring)
	local table_sort = _G.table.sort

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	do
		local OrderedEnumerable = { prototype = {} }
		setmetatable(OrderedEnumerable.prototype, {__index=Enumerable.prototype})
	
		local OrderedEnumerable_proxy = newproxy(true)
		local OrderedEnumerable_mt = getmetatable(OrderedEnumerable_proxy)
		OrderedEnumerable_mt.__index = OrderedEnumerable.prototype
		function OrderedEnumerable_mt:__tostring()
			return self:ToString()
		end

		local sources = make_weak_keyed_table()
		local key_selectors = make_weak_keyed_table()
		local descendings = make_weak_keyed_table()
		local parents = make_weak_keyed_table()

		function OrderedEnumerable.New(source, key_selector, descending, parent)
			check(1, source, 'userdata')
			check(2, key_selector, 'function')
			check(3, descending, 'boolean')
			check(4, parent, 'userdata', 'nil')

			local self = newproxy(OrderedEnumerable_proxy)
		
			sources[self] = source
			key_selectors[self] = key_selector
			descendings[self] = descending
			parents[self] = parent

			return self
		end

		--- Sorts the elements of the sequence in ascending order according to a key
		-- @param key_selector a function to get a key from an element
		-- @return an OrderedEnumerable
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy(function(x) return x:len() end)
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy("x => x:len()")
		function Enumerable.prototype:OrderBy(key_selector)
			check(1, self, 'userdata')
			check(2, key_selector, 'function', 'string')

			return OrderedEnumerable.New(self, convert_function(key_selector), false)
		end
	
		--- Sorts the elements of the sequence in descending order according to a key
		-- @param key_selector a function to get a key from an element
		-- @return an OrderedEnumerable
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderByDescending(function(x) return x:len() end)
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderByDescending("x => x:len()")
		function Enumerable.prototype:OrderByDescending(key_selector)
			check(1, self, 'userdata')
			check(2, key_selector, 'function', 'string')

			return OrderedEnumerable.New(self, convert_function(key_selector), true)
		end
	
		--- Adds a subsequent sort ordering the elements of the sequence in ascending order according to a key
		-- @param key_selector a function to get a key from an element
		-- @return an OrderedEnumerable
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy(function(x) return x:len() end):ThenBy(function(x) return x end)
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy("x => x:len()"):ThenBy("x => x")
		function OrderedEnumerable.prototype:ThenBy(key_selector)
			check(1, self, 'userdata')
			check(2, key_selector, 'function', 'string')

			return OrderedEnumerable.New(sources[self], convert_function(key_selector), false, self)
		end
	
		--- Adds a subsequent sort ordering the elements of the sequence in descending order according to a key
		-- @param key_selector a function to get a key from an element
		-- @return an OrderedEnumerable
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy(function(x) return x:len() end):ThenByDescending(function(x) return x end)
		-- @usage Enumerable.From({ "alpha", "bravo", "charlie" }):OrderBy("x => x:len()"):ThenByDescending("x => x")
		function OrderedEnumerable.prototype:ThenByDescending(key_selector)
			check(1, self, 'userdata')
			check(2, key_selector, 'function', 'string')

			return OrderedEnumerable.New(sources[self], convert_function(key_selector), true, self)
		end

		local generate_comparer
		do
			local context_selectors = make_weak_keyed_table()
			local context_descendings = make_weak_keyed_table()
			local sort_key_caches = make_weak_keyed_table()

			local compare

			local NIL = newproxy()

			function generate_comparer(ordered_enumerable)
				local function comparer(alpha, bravo)
					return compare(comparer, alpha, bravo)
				end

				local selectors = {}
				context_selectors[comparer] = selectors

				local desc = {}
				context_descendings[comparer] = desc

				local cache = {}
				sort_key_caches[comparer] = cache

				local current = ordered_enumerable
				repeat
					selectors[table.getn(selectors)+1] = key_selectors[current]
					desc[table.getn(desc)+1] = descendings[current]
					cache[table.getn(cache)+1] = {}

					current = parents[current]
				until not current

				return comparer
			end

			local function get_value(cache, selector, key)
				local hash_key = key
				if hash_key == nil then
					hash_key = NIL
				end
				local value = cache[hash_key]
				if value ~= nil then
					if value == NIL then
						return nil
					else
						return value
					end
				end
				value = selector(key)
				if value == nil then
					cache[hash_key] = NIL
				else
					cache[hash_key] = value
				end
				return value
			end

			local comparers = {}
			function comparers.string(left, right)
				if left == right then
					return 0
				else
					return left < right and -1 or 1
				end
			end
			comparers.number = comparers.string
			function comparers.boolean(left, right)
				if left == right then
					return 0
				elseif left then
					return 1
				else
					return -1
				end
			end
			local function safe_compare(left, right)
				if left == right then
					return 0
				elseif left < right then
					return -1
				else
					return 1
				end
			end
			function comparers.table(left, right)
				local success, value = pcall(safe_compare, left, right)
				if not success then
					return 0
				else
					return value
				end
			end
			comparers['function'] = function(left, right)
				return tostring(left) < tostring(right)
			end
			comparers['nil'] = function(_, _)
				return 0
			end
			comparers.userdata = comparers.table
			comparers.thread = comparers['function']

			local function compare_values(left, right, reverse)
				local left_type = type(left)
				local right_type = type(right)

				if left_type ~= right_type then
					local value = comparers.string(left_type, right_type)
					if reverse then
						return -value
					else
						return value
					end
				end

				local comparer = comparers[left_type]
				if not comparer then
					return 0
				end

				local value = comparer(left, right)
				if reverse then
					return -value
				else
					return value
				end
			end

			function compare(self, alpha, bravo)
				local descs = context_descendings[self]
				local caches = sort_key_caches[self]
				local selectors = context_selectors[self]

				for i = table.getn(selectors), 1, -1 do
					local selector = selectors[i]
					local cache = caches[i]

					local alpha_key = get_value(cache, selector, alpha)
					local bravo_key = get_value(cache, selector, bravo)

					local cmp = compare_values(alpha_key, bravo_key, descs[i])
					if cmp ~= 0 then
						return cmp
					end
				end
				return 0
			end
		end

		--- Returns a compareer of the current enumerable, which provides can be called and returns the relative sort order of the two passed-in values.
		-- @return a comparer
		-- @usage local comparer = Enumerable.From({ 1, 2, 3 }):OrderBy(function(x) return x end):GetComparer()
		function OrderedEnumerable.prototype:GetComparer()
			check(1, self, 'userdata')

			return generate_comparer(self)
		end

		function OrderedEnumerable.prototype:GetEnumerator()
			local items
			local indexes
			local count
			local index = 0
			local source = sources[self]

			return Enumerator.New(
				function()
					items = {}
					indexes = {}
					count = 0
					source:ForEach(function(item)
						count = count + 1
						items[count] = item
						indexes[count] = count
					end)

					local comparer = self:GetComparer()

					table_sort(indexes, function(alpha_index, bravo_index)
						local alpha = items[alpha_index]
						local bravo = items[bravo_index]

						local cmp = comparer(alpha, bravo)
						if cmp ~= 0 then
							return cmp < 0
						else
							return alpha_index < bravo_index
						end
					end)
				end,
				function(yield)
					index = index + 1
					if index > count then
						return false
					else
						local real_index = indexes[index]
						local item = items[real_index]
						items[real_index] = nil -- allow the memory to be cleared out
						return yield(item)
					end
				end,
				function()
					items = nil
					indexes = nil
				end)
		end
	end

	--- Reverses the order of a sequence
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Reverse():ToString() == "[4, 3, 2, 1]"
	function Enumerable.prototype:Reverse()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local buffer
			local index

			return Enumerator.New(
				function()
					buffer = {}
					index = 1

					self:ForEach(function(item)
						buffer[index] = item
						index = index + 1
					end)
				end, function(yield)
					index = index - 1
					if index > 0 then
						local value = buffer[index]
						buffer[index] = nil
						return yield(value)
					else
						return false
					end
				end,
				nil)
		end)
	end

	--- Randomizes the order of a sequence
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Shuffle():ToString() == "[3, 4, 1, 2]"
	function Enumerable.prototype:Shuffle()
		check(1, self, 'userdata')
	
		return Enumerable.New(function()
			local buffer
			local index

			return Enumerator.New(
				function()
					buffer = {}
					index = 1

					self:ForEach(function(item)
						buffer[index] = item
						index = index + 1
					end)
				end, function(yield)
					index = index - 1
					if index > 0 then
						local swapping_index = math_random(index)
						if swapping_index ~= index then
							buffer[index], buffer[swapping_index] = buffer[swapping_index], buffer[index]
						end
						local value = buffer[index]
						buffer[index] = nil
						return yield(value)
					else
						return false
					end
				end,
				nil)
		end)
	end
end)