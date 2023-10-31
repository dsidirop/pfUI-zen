_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert
	
	local check = assert(Linquidate.Utilities.check)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local identity = assert(Linquidate.Utilities.identity)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local convert_function = assert(Linquidate.Utilities.convert_function)

	local newproxy = assert(_G.newproxy)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local pairs = assert(_G.pairs)
	local next = assert(_G.next)
	local type = assert(_G.type)
	local rawget = assert(_G.rawget)

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	
	--- Correlate the elements of two sequences based on matching keys
	-- @param inner the inner sequence to join on
	-- @param outer_key_selector a function to get the join key from the first sequence
	-- @param inner_key_selector a function to get the join key from the second sequence
	-- @param result_selector a function to create a result element from the two matching elements
	-- @param compare_selector an equality comparer for the join keys
	-- @usage Enumerable.From({ {v=1, n="a"}, {v=2, n="b"} }):Join({ {v=1, x="c"}, {v=2, x="d"} }, function(a) return a.v end, function(b) return b.v end, function(a, b) return a.n .. b.x end):ToString() == '["ac", "bd"]'
	-- @usage Enumerable.From({ {v=1, n="a"}, {v=2, n="b"} }):Join({ {v=1, x="c"}, {v=2, x="d"} }, "a => a.v", "b => b.v", "a, b => a.n .. b.x"):ToString() == '["ac", "bd"]'
	function Enumerable.prototype:Join(inner, outer_key_selector, inner_key_selector, result_selector, compare_selector)
		check(1, self, 'userdata')
		check(2, inner, 'userdata', 'table')
		check(3, outer_key_selector, 'function', 'string')
		check(4, inner_key_selector, 'function', 'string')
		check(5, result_selector, 'function', 'string')
		check(6, compare_selector, 'function', 'string', 'nil')

		result_selector = convert_function(result_selector)
		outer_key_selector = convert_function(outer_key_selector)
		inner_key_selector = convert_function(inner_key_selector)
		if compare_selector then
			compare_selector = convert_function(compare_selector)
		end

		return Enumerable.New(function()
			local outer_enumerator
			local lookup
			local inner_enumerator

			return Enumerator.New(
				function()
					outer_enumerator = self:GetEnumerator()
					lookup = Enumerable.From(inner):ToLookup(inner_key_selector, identity, compare_selector)
				end,
				function(yield)
					while true do
						if inner_enumerator then
							if inner_enumerator:MoveNext() then
								return yield(result_selector(outer_enumerator:Current(), inner_enumerator:Current()))
							end
							safe_dispose(inner_enumerator)
							inner_enumerator = nil
						end

						if outer_enumerator:MoveNext() then
							local key = outer_key_selector(outer_enumerator:Current())
							inner_enumerator = lookup:Get(key):GetEnumerator()
						else
							return false
						end
					end
				end,
				function()
					tryfinally(function()
						inner_enumerator = safe_dispose(inner_enumerator)
					end, function()
						outer_enumerator = safe_dispose(outer_enumerator)
					end)
				end)
		end)
	end

	--- Correlate the elements of two sequences based on matching keys and groups the results
	-- @param inner the inner sequence to join on
	-- @param outer_key_selector a function to get the join key from the first sequence
	-- @param inner_key_selector a function to get the join key from the second sequence
	-- @param result_selector a function to create a result element from the two matching elements
	-- @param compare_selector an equality comparer for the join keys
	-- @usage Enumerable.From({ {v=1, n="Magnus"}, {v=2, n="Terry"}, {v=3, n="Charlotte"} }):GroupJoin({ { n="Barley", o=2 }, { n="Boots", o=2 }, { n="Whiskers", o=3 }, { n="Daisy", o=1 } }, function(a) return a.v end, function(b) return b.o end, function(a, coll) return a.n .. "-" .. coll:Select(function(b) return b.n end):StringJoin(":") end):ToString() == '["Magnus-Daisy", "Terry-Barley:Boots", "Charlotte-Whiskers"]'
	-- @usage Enumerable.From({ {v=1, n="Magnus"}, {v=2, n="Terry"}, {v=3, n="Charlotte"} }):GroupJoin({ { n="Barley", o=2 }, { n="Boots", o=2 }, { n="Whiskers", o=3 }, { n="Daisy", o=1 } }, "a => a.v", "b => b.o", function(a, coll) return a.n .. "-" .. coll:Select("b => b.n"):StringJoin(":") end):ToString() == '["Magnus-Daisy", "Terry-Barley:Boots", "Charlotte-Whiskers"]'
	function Enumerable.prototype:GroupJoin(inner, outer_key_selector, inner_key_selector, result_selector, compare_selector)
		check(1, self, 'userdata')
		check(2, inner, 'userdata', 'table')
		check(3, outer_key_selector, 'function', 'string')
		check(4, inner_key_selector, 'function', 'string')
		check(5, result_selector, 'function', 'string')
		check(6, compare_selector, 'function', 'string', 'nil')
		
		outer_key_selector = convert_function(outer_key_selector)
		inner_key_selector = convert_function(inner_key_selector)
		result_selector = convert_function(result_selector)
		compare_selector = compare_selector and convert_function(compare_selector)

		return Enumerable.New(function()
			local enumerator
			local lookup

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
					lookup = Enumerable.From(inner):ToLookup(inner_key_selector, identity, compare_selector)
				end, function(yield)
					if enumerator:MoveNext() then
						local current = enumerator:Current()
						local inner_element = lookup:Get(outer_key_selector(current))
						return yield(result_selector(current, inner_element))
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end


	--- Groups the elements in the sequence by a given key selector function.
	-- @param key_selector a function that gets a key from an element
	-- @param element_selector optional: a function to project each element in the sequence to an element in the resultant grouping
	-- @param result_selector optional: a function to create a result value from each group
	-- @param compare_selector optional: an equality comparer
	function Enumerable.prototype:GroupBy(key_selector, element_selector, result_selector, compare_selector)
		check(1, self, 'userdata')
		check(2, key_selector, 'function', 'string')
		check(3, element_selector, 'function', 'string', 'nil')
		check(4, result_selector, 'function', 'string', 'nil')
		check(5, compare_selector, 'function', 'string', 'nil')

		key_selector = convert_function(key_selector)
		element_selector = convert_function(element_selector)
		result_selector = result_selector and convert_function(result_selector)
		compare_selector = compare_selector and convert_function(compare_selector)

		return Enumerable.New(function()
			local enumerator

			return Enumerator.New(
				function()
					enumerator = self:ToLookup(key_selector, element_selector, compare_selector)
						:ToGroupings()
						:GetEnumerator()
				end,
				function(yield)
					while enumerator:MoveNext() do
						local current = enumerator:Current()
						if not result_selector then
							return yield(current)
						else
							return yield(result_selector(current:Key(), current))
						end
					end
					return false
				end,
				function()
					safe_dispose(enumerator)
				end)
		end)
	end
	do
		local NIL = newproxy()
	
		local Lookup = { prototype = {} }
		do
			local Grouping
			local Lookup_proxy = newproxy(true)
			local Lookup_mt = getmetatable(Lookup_proxy)
			Lookup_mt.__index = Lookup.prototype

			local dicts = make_weak_keyed_table()
			local key_lookups = make_weak_keyed_table()
			local compare_selectors = make_weak_keyed_table()

			--- Construct a new Lookup.
			-- This should only be called internally by :ToLookup()
			-- @param dict a lua table representing a multi-value dict of comparison key to multiple values
			-- @param keys a lua table representing a key lookup of comparison key to real key
			-- @param compare_selector a function to convert real keys to comparison keys
			-- @return a Lookup
			function Lookup.New(dict, keys, compare_selector)
				check(1, dict, 'table')
				check(2, keys, 'table')
				check(3, compare_selector, 'function')
			
				local self = newproxy(Lookup_proxy)
			
				dicts[self] = dict
				key_lookups[self] = keys
				compare_selectors[self] = compare_selector

				return self
			end

			--- Return the number of lookup keys
			-- @return an integer
			function Lookup.prototype:Count()
				check(1, self, 'userdata')
			
				local i = 0
				for _ in pairs(dicts[self]) do
					i = i + 1
				end
				return i
			end

			local function nil_fixer(x)
				if x == NIL then
					return nil
				else
					return x
				end
			end
			--- Return an enumerable representing the values matched by the key provided.
			-- If the key does not exist in the lookup, an empty Enumerable will be returned.
			-- @param key the key to check on
			-- @return an Enumerable
			function Lookup.prototype:Get(key)
				check(1, self, 'userdata')

				local compare_selector = compare_selectors[self]

				local comparative_key = compare_selector(key)
				if comparative_key == nil then
					comparative_key = NIL
				end

				local dict = dicts[self]
				local value = dict[comparative_key]
				if not value then
					return Enumerable.Empty()
				else
					return Enumerable.From(value):Select(nil_fixer)
				end
			end
		
			--- Return whether the key exists in the lookup and has at least one associated value.
			-- @param key the key to check on
			-- @return a boolean
			function Lookup.prototype:Contains(key)
				check(1, self, 'userdata')

				local compare_selector = compare_selectors[self]

				local comparative_key = compare_selector(key)
				if comparative_key == nil then
					comparative_key = NIL
				end

				local dict = dicts[self]
				local value = dict[comparative_key]
				return not not value
			end
		
			--- Return an enumerable of Grouping that contains the values of this Lookup
			-- @return an Enumerable
			function Lookup.prototype:ToGroupings()
				check(1, self, 'userdata')

				local dict = dicts[self]
				local key_lookup = key_lookups[self]

				return Enumerable.New(function()
					local key
					return Enumerator.New(
						nil,
						function(yield)
							local value
							key, value = next(dict, key)
							if key == nil then
								return false
							else
								return yield(Grouping.New(key_lookup[key], Enumerable.From(value):Select(nil_fixer)))
							end
						end,
						nil)
				end)
			end
		
			Grouping = { prototype = {} }
			do
				setmetatable(Grouping.prototype, {__index=Enumerable.prototype})
			
				local Grouping_proxy = newproxy(true)
				local Grouping_mt = getmetatable(Grouping_proxy)
				Grouping_mt.__index = Grouping.prototype
				function Grouping_mt:__tostring()
					return self:ToString()
				end

				local keys = make_weak_keyed_table()
				local lists = make_weak_keyed_table()

				--- Construct and return a grouping based on the key and sequence provided
				-- @param key the key representative of the grouping
				-- @param elements the elements contained within the grouping
				-- @return a Grouping
				function Grouping.New(key, elements)
					check(2, elements, 'userdata')

					local self = newproxy(Grouping_proxy)

					keys[self] = key
					lists[self] = elements:ToList():ConvertToReadOnly()

					return self
				end

				--- Return the key associated with this grouping
				-- @return a key
				function Grouping.prototype:Key()
					check(1, self, 'userdata')

					return keys[self]
				end
			
				--- Return the enumerator associated with the elements of this grouping
				-- @return an Enumerator
				function Grouping.prototype:GetEnumerator()
					check(1, self, 'userdata')

					return lists[self]:GetEnumerator()
				end

				--- Return the string representation of this grouping
				-- @return a string
				function Grouping.prototype:ToString()
					check(1, self, 'userdata')

					return "Grouping(Key: " .. tostring_q(keys[self]) .. ", Values: " .. Enumerable.prototype.ToString(self) .. ")"
				end

				_G.Linquidate_Loader(function(_)
					for k, v in pairs(Enumerable.prototype) do
						if type(k) == "string" and type(v) == "function" and rawget(Grouping.prototype, k) == nil then
							Grouping.prototype[k] = function(self, ...)
								local list = lists[self]
								return list[k](list, unpack(arg))
							end
						end
					end
				end)
			end
		end
	
		--- Creates a Lookup from this sequence.
		-- @param key_selector A function to extract a key from each element
		-- @param element_selector A transform function to produce a result element value from each element
		-- @param compare_selector An equality comparer to compare values
		-- @return A Lookup enumerable
		function Enumerable.prototype:ToLookup(key_selector, element_selector, compare_selector)
			check(1, self, 'userdata')
			check(2, key_selector, 'function', 'string')
			check(3, element_selector, 'function', 'string', 'nil')
			check(4, compare_selector, 'function', 'string', 'nil')

			key_selector = convert_function(key_selector)
			element_selector = convert_function(element_selector)
			compare_selector = convert_function(compare_selector)

			local keys = {}
			local dict = {}

			self:ForEach(function(x, i)
				local key = key_selector(x, i)
				local element = element_selector(x, i)

				if element == nil then
					element = NIL
				end

				local comparative_key = compare_selector(key)
				if comparative_key == nil then
					comparative_key = NIL
				end
				local array = dict[comparative_key]
				if not array then
					array = { element }
					dict[comparative_key] = array
					keys[comparative_key] = key
				else
					array[table.getn(array)+1] = element
				end
			end)
		
			return Lookup.New(dict, keys, compare_selector)
		end
	end
end)