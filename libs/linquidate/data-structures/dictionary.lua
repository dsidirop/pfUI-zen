_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local make_weak_table = assert(Linquidate.Utilities.make_weak_table)
	local check = assert(Linquidate.Utilities.check)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local wipe = assert(Linquidate.Utilities.wipe)
	local identity = assert(Linquidate.Utilities.identity)
	local convertFunction = assert(Linquidate.Utilities.convertFunction)
	
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local newproxy = assert(_G.newproxy)
	local next = assert(_G.next)
	local pairs = assert(_G.pairs)
	local type = assert(_G.type)
	local error = assert(_G.error)
	local tostring = assert(_G.tostring)
	local table_concat = assert(_G.table.concat)
	local pcall = assert(_G.pcall)
	local table_sort = assert(_G.table.sort)

	local Dictionary = Linquidate.Dictionary or {}
	if not Dictionary.prototype then
		Dictionary.prototype = {}
	end
	setmetatable(Dictionary.prototype, {__index=Enumerable.prototype})
	
	Linquidate.Dictionary = Dictionary
	local Dictionary_proxy = newproxy(true)
	local Dictionary_mt = getmetatable(Dictionary_proxy)
	Dictionary_mt.__index = Dictionary.prototype
	function Dictionary_mt:__tostring()
		return self:ToString()
	end

	local NIL = Dictionary.__NIL or newproxy()
	Dictionary.__NIL = NIL
	
	local tables = make_weak_keyed_table(Dictionary.__tables)
	Dictionary.__tables = tables
	local key_lookups = make_weak_keyed_table(Dictionary.__key_lookups)
	Dictionary.__key_lookups = key_lookups
	local comparison_selectors = make_weak_keyed_table(Dictionary.__comparison_selectors)
	Dictionary.__comparison_selectors = comparison_selectors
	local contracts = make_weak_keyed_table(Dictionary.__contracts)
	Dictionary.__contracts = contracts
	local wrapped_tables = make_weak_table(Dictionary.__wrapped_tables)
	Dictionary.__wrapped_tables = wrapped_tables
	local readonlys = make_weak_keyed_table(Dictionary.__readonlys)
	Dictionary.__readonlys = readonlys
	if Dictionary.__is_wrapped then
		local is_wrapped = Dictionary.__is_wrapped
		Dictionary.__is_wrapped = nil
		for k, v in pairs(is_wrapped) do
			if v then
				wrapped_tables[tables[k]] = k
			end
		end
	end

	--- Construct and return a new Dictionary
	-- @param dict optional: a Dictionary or lua table to populate the new dictionary with
	-- @param comparison_selector optional: a function to generate a unique key per element
	-- @usage Dictionary.New()
	-- @usage Dictionary.New({ a = 1, b = 2 })
	-- @usage Dictionary.New({ a = 1, b = 2 }, string.upper)
	-- @usage Dictionary.New(nil, string.upper)
	function Dictionary.New(dict, comparison_selector)
		check(1, dict, 'userdata', 'table', 'nil')
		check(2, comparison_selector, 'function', 'string', 'nil')

		local self = newproxy(Dictionary_proxy)

		tables[self] = {}
		if comparison_selector then
			key_lookups[self] = {}
			comparison_selectors[self] = convertFunction(comparison_selector)
		end

		if dict ~= nil then
			if type(dict) == 'table' then
				for k, v in pairs(dict) do
					self:Add(k, v)
				end
			elseif Dictionary.IsDictionary(dict) then
				dict:ForEachByPair(function(k, v)
					self:Add(k, v)
				end)
			else
				error(("Can't convert %s (%s) to a dictionary"):format(type(dict), tostring(dict)), 2)
			end
		end

		return self
	end
	
	--- Wrap a lua table such that there is parity between the passed-in table and the Dictionary.
	-- Unlike other tables, this will not gracefully handle nils.
	-- @param t the table to wrap around
	-- @return a Dictionary
	-- @usage local dict = Dictionary.WrapTable({ alpha = 1, bravo = 2 })
	function Dictionary.WrapTable(t)
		check(1, t, 'table')

		local self = wrapped_tables[t]
		if self then
			return self
		end

		self = newproxy(Dictionary_proxy)

		tables[self] = t
		wrapped_tables[t] = self

		return self
	end
	
	--- Return whether the provided object is a Dictionary
	-- @param obj the object to check
	-- @return whether the object inherits from or is a Dictionary
	function Dictionary.IsDictionary(obj)
		local obj_type = type(obj)
		if obj_type ~= 'userdata' then
			return false
		end

		while obj do
			local mt = getmetatable(obj)
			if not mt then
				return false
			elseif mt.__index == Dictionary.prototype or mt.__index == Linquidate.BidirectionalDictionary.prototype then
				return true
			end

			obj = mt.__index
		end
	end
	
	--- Return a Dictionary by trying to convert an object to one through some means.
	-- Passing in nil will result in an empty Dictionary
	-- Passing in a Dictionary will return the same Dictionary
	-- Passing in a table will call Dictionary.WrapTable
	-- Any other object will result in an error.
	-- @return an Enumerable
	-- @usage Dictionary.From(nil):ToString() == "Dictionary[]"
	-- @usage Dictionary.From(Dictionary.New()):ToString() == "Dictionary[]"
	-- @usage Dictionary.From({ 'a', 'b', 'c' }):ToString() == 'Dictionary[1: "a", 2: "b", 3: "c"]'
	-- @usage Dictionary.From({ a = 1, b = 2, c = 3 }):ToString() == 'Dictionary["a": 1, "b": 2, "c": 3]'
	function Dictionary.From(obj)
		local obj_type = type(obj)
		
		if obj_type == 'nil' then
			return Dictionary.New()
		elseif obj_type == 'userdata' and Dictionary.IsDictionary(obj) then
			return obj
		elseif obj_type == 'table' then
			return Dictionary.WrapTable(obj)
		else
			error(("Don't know how to convert %s (%s) to an Enumerable"):format(obj_type, tostring(obj)), 2)
		end
	end

	--- Verify that the contract for this Dictionary is valid for all elements in the dictionary.
	-- If there is no contract, this does nothing.
	-- @usage dict:VerifyContract()
	function Dictionary.prototype:VerifyContract()
		check(1, self, 'userdata')

		local contract = contracts[self]
		if not contract then
			return
		end

		local key_lookup = key_lookups[self]
		for hash_key, value in pairs(tables[self]) do
			local key
			if key_lookup then
				key = key_lookup[hash_key]
			else
				key = hash_key
			end

			if key == NIL then
				key = nil
			end
			if value == NIL then
				value = nil
			end

			if not contract(key, value) then
				error(("Element (%s, %s) does not meet the contract for this Dictionary."):format(tostring_q(key), tostring_q(value)), 2)
				break
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all keys are strings and all values are positive integers or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the key and value and should return whether the pair is valid.
	-- @usage dict:SetContract(function(k, v) return type(k) == "string" and type(v) == "number" end)
	function Dictionary.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')
		
		if readonlys[self] then
			error("Cannot set the contract on a read-only Dictionary", 2)
		end

		contracts[self] = contract
		self:VerifyContract()
	end
	
	--- Make the Set read-only, preventing any further modifications.
	-- There is no way to convert a Set back to being modifiable.
	-- @return the same Set that was made read-only
	-- @usage set:ConvertToReadOnly()
	function Dictionary.prototype:ConvertToReadOnly()
		check(1, self, 'userdata')

		if readonlys[self] then
			return
		end

		if wrapped_tables[tables[self]] then
			error("Cannot convert a wrapped table to read-only", 2)
		end
		
		readonlys[self] = true

		return self
	end

	--- Return whether the Set is read-only, and thus cannot have modifications made to it.
	-- @return a boolean
	-- @usage local read_only = set:IsReadOnly()
	function Dictionary.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return not not readonlys[self]
	end

	--- Return an enumerator for the Dictionary that returns the keys of the dictionary
	function Dictionary.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local source = self
		local key_lookup = key_lookups[self]
		local table = tables[self]
		local index = 0
		
		local key = nil

		return Enumerator.New(
			nil,
			function(yield)
				local value
				key, value = next(table, key)

				if key == nil then
					return false
				end

				if key_lookup then
					value = key_lookup[key]
				else
					value = key
				end

				if value == NIL then
					return yield(nil)
				else
					return yield(value)
				end
			end,
			nil)
	end

	--- Add the specific key and value to the Dictionary.
	-- This will error if an element with the same key already exists in the Dictionary.
	-- To avoid erroring, use :Set(key, value) instead.
	-- @param key the key of the element to add
	-- @param value the value of the element to add
	-- @usage dict:Add("key", "value")
	function Dictionary.prototype:Add(key, value)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add to a read-only Dictionary", 2)
		end

		local contract = contracts[self]
		if contract and not contract(key, value) then
			error(("Element (%s, %s) does not meet the contract for this Dictionary"):format(tostring_q(key), tostring_q(value)), 2)
		end

		local comparison_selector = comparison_selectors[self]
		local table = tables[self]

		local hash_key
		if comparison_selector then
			hash_key = comparison_selector(key)
		else
			hash_key = key
		end

		local key_lookup = key_lookups[self]

		if hash_key == nil then
			if wrapped_tables[table] then
				return
			end
			hash_key = NIL
		end

		if table[hash_key] ~= nil then
			error("Key already exists in Dictionary", 2)
		end

		if value == nil then
			if wrapped_tables[table] then
				return
			end
			value = NIL
		end
		table[hash_key] = value
		if comparison_selector then
			if key == nil then
				key = NIL
			end
			key_lookup[hash_key] = key
		end
	end
	
	--- Set the specific key and value to the Dictionary.
	-- If overriding an existing value, the key will not change or be overridden.
	-- @param key the key of the element to set
	-- @param value the value of the element to set
	-- @usage dict:Set("key", "value")
	function Dictionary.prototype:Set(key, value)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot alter a read-only Dictionary", 2)
		end

		local contract = contracts[self]
		if contract and not contract(key, value) then
			error(("Element (%s, %s) does not meet the contract for this Dictionary"):format(tostring_q(key), tostring_q(value)), 2)
		end

		local comparison_selector = comparison_selectors[self]
		local table = tables[self]

		local hash_key
		if comparison_selector then
			hash_key = comparison_selector(key)
		else
			hash_key = key
		end

		local key_lookup = key_lookups[self]

		if hash_key == nil then
			if wrapped_tables[table] then
				return
			end
			hash_key = NIL
		end

		if value == nil then
			if wrapped_tables[table] then
				return
			end
			value = NIL
		end
		table[hash_key] = value
		if comparison_selector then
			if key_lookup[hash_key] == nil then -- the key shouldn't change, even if it is different
				if key == nil then
					key = NIL
				end
				key_lookup[hash_key] = key
			end
		end
	end
	
	--- Merge another dictionary onto the current Dictionary.
	-- @param other a Dictionary to Merge onto the current
	-- @usage Dictionary.From({ alpha = 1, bravo = 2 }):Merge({ bravo = 3, charlie = 4 }) -- Dictionary["alpha": 1, "bravo": 3, "charlie": 4]
	function Dictionary.prototype:Merge(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot alter a read-only Dictionary", 2)
		end

		Dictionary.From(other):ForEachByPair(function(k, v, i)
			self:Set(k, v)
		end)
	end

	--- Get the specific value in the Dictionary given the requested key.
	-- This will error if the key is not in the Dictionary.
	-- @param key the key of the element to get
	-- @return the value requested
	-- @usage local value = dict:Get("key")
	function Dictionary.prototype:Get(key)
		check(1, self, 'userdata')

		local success, value = self:TryGetValue(key)
		if not success then
			error("Key not found in dictionary", 2)
		else
			return value
		end
	end
	
	--- Get the specific value or a default value in the Dictionary given the requested key.
	-- This will return the default value if not found.
	-- @param key the key of the element to get
	-- @param default the default value to return if the key is not found.
	-- @return the value requested or the default value
	-- @usage local value = dict:GetOrDefault("key", 0)
	function Dictionary.prototype:GetOrDefault(key, default)
		check(1, self, 'userdata')
		
		local success, value = self:TryGetValue(key)
		if not success then
			return default
		else
			return value
		end
	end

	--- Try to get the specific value in the Dictionary given the requested key.
	-- @param key the key of the element to get
	-- @return whether the get was successful
	-- @return the value requested
	-- @usage local success, value = dict:TryGetValue("key")
	function Dictionary.prototype:TryGetValue(key)
		check(1, self, 'userdata')

		local comparison_selector = comparison_selectors[self]
		local table = tables[self]

		local hash_key
		if comparison_selector then
			hash_key = comparison_selector(key)
		else
			hash_key = key
		end

		if hash_key == nil then
			hash_key = NIL
		end

		local value = table[hash_key]
		if value == nil then
			return false
		end

		if value == NIL then
			return true, nil
		else
			return true, value
		end
	end
	
	--- Clear all elements from the Dictionary
	-- @usage dict:Clear()
	function Dictionary.prototype:Clear()
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot alter a read-only Dictionary", 2)
		end

		wipe(tables[self])
		local key_lookup = key_lookups[self]
		if key_lookup then
			wipe(key_lookup)
		end
	end
	
	--- Return whether a given key is present in the Dictionary
	-- @param key the key to check for
	-- @return a boolean
	-- @usage local found = dict:ContainsKey("key")
	function Dictionary.prototype:ContainsKey(key)
		check(1, self, 'userdata')

		local comparison_selector = comparison_selectors[self]
		if comparison_selector then
			key = comparison_selector(key)
		end
		if key == nil then
			key = NIL
		end
		return tables[self][key] ~= nil
	end
	
	--- Return whether a given value is present in the Dictionary
	-- @param value the value to check for
	-- @return a boolean
	-- @usage local found = dict:ContainsValue("value")
	function Dictionary.prototype:ContainsValue(value)
		check(1, self, 'userdata')

		for k, v in pairs(tables[self]) do
			if v == NIL then
				v = nil
			end
			if v == value then
				return true
			end
		end
		return false
	end
	
	--- Removes the element with the provided key from the Dictionary
	-- @param key the key to remove
	-- @return whether the element was removed
	-- @usage local removed = dict:Remove("key")
	function Dictionary.prototype:Remove(key)
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove from a read-only Dictionary", 2)
		end

		local table = tables[self]
		local comparison_selector = comparison_selectors[self]
		if comparison_selector then
			key = comparison_selector(key)
		end
		if key == nil then
			key = NIL
		end
		if table[key] ~= nil then
			table[key] = nil
			local key_lookup = key_lookups[self]
			if key_lookup then
				key_lookup[key] = nil
			end
			return true
		else
			return false
		end
	end
	
	--- Remove all elements which match a given predicate
	-- @param predicate a function which is passed each key and value and should return true to remove, false to keep
	-- @return the number of elements removed
	-- @usage local num = dict:RemoveWhere(function(k, v) return v % 2 == 0 end)
	function Dictionary.prototype:RemoveWhere(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		if readonlys[self] then
			error("Cannot remove from a read-only Dictionary", 2)
		end

		predicate = convertFunction(predicate)

		local key_lookup = key_lookups[self]
		
		local table = tables[self]
		local num = 0
		for hash_key, value in pairs(table) do
			local key
			if key_lookup then
				key = key_lookup[hash_key]
			else
				key = hash_key
			end
			if key == NIL then
				key = nil
			end
			if value == NIL then
				value = nil
			end
			if predicate(key, value) then
				if key_lookup then
					key_lookup[hash_key] = nil
				end
				table[hash_key] = nil
				num = num + 1
			end
		end
		return num
	end
	
	--- Make a shallow clone of the Set.
	-- @usage local other = dict:Clone()
	function Dictionary.prototype:Clone()
		check(1, self, 'userdata')

		local other = Dictionary.New(nil, comparison_selectors[self])
		local contract = contracts[self]
		if contract then
			other:SetContract(contracts[self])
		end
		other:Merge(self)

		return other
	end

	-- Methods that are faster than using the standard Enumerable ones:
	
	function Dictionary.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return (next(tables[self])) ~= nil
		else
			return Enumerable.prototype.Any(self, predicate)
		end
	end
	
	Dictionary.prototype.Contains = Dictionary.prototype.ContainsKey

	function Dictionary.prototype:MemoizeAll()
		return self
	end
	
	function Dictionary.prototype:ToString()
		check(1, self, 'userdata')

		local t = {}
		t[table.getn(t)+1] = 'Dictionary['
		self:OrderBy(identity):ForEach(function(key, i)
			local value = self:Get(key)
			if i > 1 then
				t[table.getn(t)+1] = ', '
			end
			if i >= 11 then
				t[table.getn(t)+1] = '...'
				return false
			end
			t[table.getn(t)+1] = tostring_q(key)
			t[table.getn(t)+1] = ': '
			t[table.getn(t)+1] = tostring_q(value)
		end)
		t[table.getn(t)+1] = ']'
		return table_concat(t)
	end
	
	function Dictionary.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convertFunction(action)

		local index = 0
		local key_lookup = key_lookups[self]
		for hash_key in pairs(tables[self]) do
			local key
			if key_lookup then
				key = key_lookup[hash_key]
			else
				key = hash_key
			end

			index = index + 1

			if key == NIL then
				key = nil
			end

			if action(key, index) == false then
				break
			end
		end
	end
	
	--- Return a lua iterator that returns the index, key, and value of each element and can be used in for loops.
	-- @usage for index, key, value in Dictionary.New({ a = 1, b = 2 }):Iterate() do end
	function Dictionary.prototype:Iterate()
		local hash_key = nil
		return function(self, index)
			local value
			hash_key, value = next(tables[self], hash_key)
			if hash_key == nil then
				return nil
			end

			local key
			local key_lookup = key_lookups[self]
			if key_lookup then
				key = key_lookup[hash_key]
			else
				key = hash_key
			end

			if key == NIL then
				key = nil
			end
			if value == NIL then
				value = nil
			end

			return index + 1, key, value
		end, self, 0
	end

	--- Immediately performs an action on each element in the dictionary.
	-- If the action returns false, that will act as a break and prevent any more execution on the sequence.
	-- @param action a function that takes the key, value, and the 1-based index of the element.
	-- @usage dict:ForEachByPair(function(key, value, index) end)
	function Dictionary.prototype:ForEachByPair(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convertFunction(action)

		local index = 0
		local key_lookup = key_lookups[self]
		for hash_key, value in pairs(tables[self]) do
			local key
			if key_lookup then
				key = key_lookup[hash_key]
			else
				key = hash_key
			end

			index = index + 1

			if key == NIL then
				key = nil
			end
			if value == NIL then
				value = nil
			end

			if action(key, value, index) == false then
				break
			end
		end
	end
	
	--- Project each element of the sequence to a new element.
	-- @param selector the transform function which takes the key, value, and the 1-based index
	-- @return an Enumerable
	-- @usage dict:SelectByPair(function(key, value, index) return key.."="..value end)
	function Dictionary.prototype:SelectByPair(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string')

		selector = convertFunction(selector)

		return Enumerable.New(function()
			local key
			local table = tables[self]
			local key_lookup = key_lookups[self]
			local index = 0

			return Enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(table, key)
					if key == nil then
						return false
					else
						local real_key
						if key_lookup then
							real_key = key_lookup[key]
						else
							real_key = key
						end
						if real_key == NIL then
							real_key = nil
						end
						if value == NIL then
							value = nil
						end
						index = index + 1
						return yield(selector(real_key, value, index))
					end
				end,
				nil)
		end)
	end

	--- Return an Enumerable of all the keys in the Dictionary.
	-- This may not return in a known order.
	-- @return an Enumerable
	-- @usage local keys = dict:Keys()
	function Dictionary.prototype:Keys()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local key
			local table = tables[self]
			local key_lookup = key_lookups[self]

			return Enumerator.New(
				nil,
				function(yield)
					key = next(table, key)
					if key == nil then
						return false
					else
						local real_key
						if key_lookup then
							real_key = key_lookup[key]
						else
							real_key = key
						end
						if real_key == NIL then
							real_key = nil
						end

						return yield(real_key)
					end
				end,
				nil)
		end)
	end
	
	--- Return an Enumerable of all the values in the Dictionary.
	-- This may not return in a known order.
	-- @return an Enumerable
	-- @usage local values = dict:Values()
	function Dictionary.prototype:Values()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local key
			local table = tables[self]

			return Enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(table, key)
					if key == nil then
						return false
					else
						if value == NIL then
							value = nil
						end

						return yield(value)
					end
				end,
				nil)
		end)
	end

	local KeyValuePair = { prototype = {} }
	do
		local KeyValuePair_proxy = newproxy(true)
		local KeyValuePair_mt = getmetatable(KeyValuePair_proxy)
		KeyValuePair_mt.__index = KeyValuePair.prototype
		function KeyValuePair_mt:__tostring()
			return self:ToString()
		end

		local keys = make_weak_keyed_table()
		local values = make_weak_keyed_table()

		function KeyValuePair.New(key, value)
			local self = newproxy(KeyValuePair_proxy)

			keys[self] = key
			values[self] = value

			return self
		end

		function KeyValuePair.prototype:ToString()
			return "KeyValuePair(" .. tostring_q(keys[self]) .. ", " .. tostring_q(values[self]) .. ")"
		end

		--- Return the key of the current KeyValuePair
		-- @return a value
		-- @usage local key = kvp:Key()
		function KeyValuePair.prototype:Key()
			return keys[self]
		end

		--- Return the value of the current KeyValuePair
		-- @return a value
		-- @usage local value = kvp:Value()
		function KeyValuePair.prototype:Value()
			return values[self]
		end

		--- Return the key and value of the current KeyValuePair
		-- @return the key
		-- @return the value
		-- @usage local key, value = kvp:KeyAndValue()
		function KeyValuePair.prototype:KeyAndValue()
			return keys[self], values[self]
		end
	end

	--- Return an Enumerable of KeyValuePair representing all the elements of the current Dictionary.
	-- @return an Enumerable
	-- @usage local kvps = dict:ToKeyValuePairs()
	function Dictionary.prototype:ToKeyValuePairs()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local key
			local table = tables[self]
			local key_lookup = key_lookups[self]

			return Enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(table, key)
					if key == nil then
						return false
					else
						local real_key
						if key_lookup then
							real_key = key_lookup[key]
						else
							real_key = key
						end
						if real_key == NIL then
							real_key = nil
						end
						if value == NIL then
							value = nil
						end
						return yield(KeyValuePair.New(real_key, value))
					end
				end,
				nil)
		end)
	end

	--- Randomly pick a random element in the Dictionary, remove it, and return the key and value.
	-- This will error if the Set is empty.
	-- @return a random key in the Dictionary
	-- @return a random value in the Dictionary
	-- @usage local key, value = dict:PickAndRemoveRandom()
	function Dictionary.prototype:PickAndRemoveRandom()
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove elements from a read-only Dictionary", 2)
		end

		if not self:Any() then
			error("Cannot remove from an empty Dictionary", 2)
		end

		local key = self:PickRandom()
		local value = self:Get(key)
		self:Remove(key)
		return key, value
	end
	
	local function safe_compare(alpha, bravo)
		return alpha < bravo
	end

	local function sorter(alpha, bravo)
		local type_alpha = type(alpha)
		local type_bravo = type(bravo)

		if type_alpha ~= type_bravo then
			return type_alpha < type_bravo
		end

		local success, value = pcall(safe_compare, alpha, bravo)
		if not success then
			return false
		else
			return value
		end
	end
	--- Convert the Dictionary to a simple lua table.
	-- This will be missing values if nil is used.
	-- @param kind "set" to return a table where all values are true, "list" to return a list-like table, or nil to return a standard dictionary-like table
	-- @usage Dictionary.New({ hey = "there" }):ToTable()["hey"] == "there"
	-- @usage Dictionary.New({ hey = "there" }):ToTable("list")[1] == "hey"
	-- @usage Dictionary.New({ hey = "there" }):ToTable("set")["hey"] == true
	function Dictionary.prototype:ToTable(kind)
		check(1, self, 'userdata')
		check(2, kind, 'nil', 'string')

		local t = {}
		if kind == "list" then
			self:ForEach(function(k)
				if k ~= nil then
					t[table.getn(t) + 1] = k
				end
			end)
			table_sort(t, sorter)
		elseif kind == "set" then
			self:ForEach(function(k)
				if k ~= nil then
					t[k] = true
				end
			end)
		else
			self:ForEachByPair(function(k, v)
				if k ~= nil then
					t[k] = v
				end
			end)
		end
		return t
	end

	--- Create and return a new Dictionary from the current Enumerable based on the provided selectors.
	-- @param key_selector a function to get the key of the dictionary from an element
	-- @param value_selector optional: a function to get the value of the dictionary from an element
	-- @param comparison_selector optional: a function to generate a unique key per element
	-- @return a Dictionary
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToDictionary(function(x) return x:sub(1, 1) end)
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToDictionary(function(x) return x:sub(1, 1) end, string.lower)
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToDictionary(function(x) return x:sub(1, 1) end, nil, string.upper)
	function Enumerable.prototype:ToDictionary(key_selector, value_selector, comparison_selector)
		check(1, self, 'userdata')
		check(2, key_selector, 'function', 'string')
		check(3, value_selector, 'function', 'string', 'nil')
		check(4, comparison_selector, 'function', 'string', 'nil')

		key_selector = convertFunction(key_selector)
		if value_selector then
			value_selector = convertFunction(value_selector)
		end

		local dict = Dictionary.New(nil, comparison_selector)
		self:ForEach(function(item, index)
			local key = key_selector(item, index)
			local value
			if value_selector then
				value = value_selector(item, index)
			else
				value = item
			end
			dict:Add(key, value)
		end)
		return dict
	end

end)