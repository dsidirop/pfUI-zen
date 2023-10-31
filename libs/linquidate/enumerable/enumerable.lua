_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local check = assert(Linquidate.Utilities.check)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)

	local newproxy = assert(_G.newproxy)
	local getmetatable = assert(_G.getmetatable)
	local type = assert(_G.type)
	local table_concat = assert(_G.table.concat)
	local tostring = assert(_G.tostring)

	--- A class that exposes an enumerator and supports simiple iteration as well as helper methods.
	local Enumerable = Linquidate.Enumerable or {}
	do
		Linquidate.Enumerable = Enumerable
		if not Enumerable.prototype then
			Enumerable.prototype = {}
		end
		local Enumerable_proxy = newproxy(true)
		local Enumerable_mt = getmetatable(Enumerable_proxy)
		Enumerable_mt.__index = Enumerable.prototype

		local get_enumerators = make_weak_keyed_table(Enumerable.__get_enumerators)
		Enumerable.__get_enumerators = get_enumerators

		--- Return the enumerator for the current Enumerable
		-- @return an Enumerator
		function Enumerable.prototype:GetEnumerator()
			return get_enumerators[self](self)
		end

		--- Construct and return a new Enumerable
		-- @param enumerator_creator a function that will return an enumerator that will be called when :GetEnumerator() is called.
		-- @return The new Enumerable
		function Enumerable.New(get_enumerator)
			check(1, get_enumerator, 'function')

			local self = newproxy(Enumerable_proxy)

			get_enumerators[self] = get_enumerator

			return self
		end
	
		--- Return whether the provided object is an Enumerable
		-- @param obj the object to check
		-- @return whether the object inherits from or is an Enumerable
		function Enumerable.IsEnumerable(obj)
			local obj_type = type(obj)
			if obj_type ~= 'userdata' then
				return false
			end

			while obj do
				local mt = getmetatable(obj)
				if not mt then
					return false
				elseif mt.__index == Enumerable.prototype then
					return true
				end

				obj = mt.__index
			end
			return false
		end

		function Enumerable_mt:__tostring()
			return self:ToString()
		end
	end

	--- Convert the enumerable to a simple lua table.
	-- The implementation can vary the result, a list might return a numerically indexed table,
	-- whereas a set might return a table with all values as true.
	-- A dictionary will probably return a standard dictionary-style table.
	-- Not all values may show up in the table, especially in cases where nil is involved.
	-- @param kind Either nil (to use the implementation's discretion), "list" to return a list-like table, or "set" to return a table where all values are true.
	-- @return a lua table
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ToTable()[2] == 'b'
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ToTable('list')[2] == 'b'
	-- @usage Enumerable.From({ 'a', 'b', 'c' }):ToTable('set')['b'] == true
	function Enumerable.prototype:ToTable(kind)
		check(1, self, 'userdata')
		check(2, kind, 'nil', 'string')
	
		local t = {}
		if kind == 'set' then
			self:ForEach(function(x, _)
				if x ~= nil then
					t[x] = true
				end
			end)
		else
			self:ForEach(function(x, i)
				t[i] = x
			end)
		end
		return t
	end

	--- Return a string representation of this Enumerable.
	-- This should only show the first 10 elements of the Enumerable, after which it follows with an ellipsis (...).
	-- @return a string
	function Enumerable.prototype:ToString()
		check(1, self, 'userdata')
	
		local t = {}
		t[table.getn(t)+1] = '['
		self:ForEach(function(value, i)
			if i > 1 then
				t[table.getn(t)+1] = ', '
			end
			if i >= 11 then
				t[table.getn(t)+1] = '...'
				return false
			end
			t[table.getn(t)+1] = tostring_q(value)
		end)
		t[table.getn(t)+1] = ']'
		return table_concat(t)
	end

	local function unpack_helper(enumerator)
		if enumerator:MoveNext() then
			return enumerator:Current(), unpack_helper(enumerator)
		else
			return
		end
	end

	--- Unpack the contents of the enumerable to a lua argument tuple
	-- @return zero or more values
	-- @usage a, b, c = Enumerable.From({ 1, 2, 3 }):Unpack()
	function Enumerable.prototype:Unpack()
		check(1, self, 'userdata')

		local enumerator = self:GetEnumerator()

		return tryfinally(function()
			return unpack_helper(enumerator)
		end, function()
			safe_dispose(enumerator)
		end)
	end

	--- Concatenate the values of the enumerable into a single string
	-- @param separator optional: the separator to use, defaults to an empty string
	-- @param selector optional: a function to select over the enumerable
	-- @return a string
	-- @usage Enumerable.From({ 1, 2, 3 }):StringJoin() == "123"
	-- @usage Enumerable.From({ 1, 2, 3 }):StringJoin(", ") == "1, 2, 3"
	-- @usage Enumerable.From({ 1, 2, 3 }):StringJoin(", ", function(x) return x*x end) == "1, 4, 9"
	-- @usage Enumerable.From({ 1, 2, 3 }):StringJoin(", ", "x => x*x") == "1, 4, 9"
	function Enumerable.prototype:StringJoin(separator, selector)
		check(1, self, 'userdata')
		check(2, separator, 'string', 'nil')
		check(3, selector, 'function', 'string', 'nil')

		if selector then
			return self:Select(selector):StringJoin(separator)
		end

		local t = {}
		self:ForEach(function(item)
			if item ~= nil then
				t[table.getn(t)+1] = tostring(item)
			end
		end)
		return table_concat(t, separator or '')
	end

	do
		local not_nil_filter = function(value) return value ~= nil end
		--- Return all non-nil elements
		-- @return an Enumerable
		function Enumerable.prototype:WhereNotNil()
			check(1, self, 'userdata')

			return self:Where(not_nil_filter)
		end
	end

	local function iterator(enumerator, index)
		if not enumerator:MoveNext() then
			safe_dispose(enumerator)
			return nil
		end

		return index + 1, enumerator:Current()
	end
	--- Return a lua iterator that returns the index and value of each element and can be used in for loops.
	-- If the loop is not fully iterated through, some garbage may persist improperly.
	-- @usage for index, value in Enumerable.From({ 1, 2, 3 }):Iterate() do end
	function Enumerable.prototype:Iterate()
		return iterator, self:GetEnumerator(), 0
	end
end)