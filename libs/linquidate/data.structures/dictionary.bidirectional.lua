_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local enumerable = assert(Linquidate.Enumerable)
	local enumerator = assert(Linquidate.Enumerator)
	
	local wipe = assert(Linquidate.Utilities.wipe)
	local check = assert(Linquidate.Utilities.check)
	local identity = assert(Linquidate.Utilities.identity)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local convert_function = assert(Linquidate.Utilities.convert_function)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	
	local next = assert(_G.next)
	local type = assert(_G.type)
	local error = assert(_G.error)
	local pcall = assert(_G.pcall)
	local pairs = assert(_G.pairs)
	local newproxy = assert(_G.newproxy)
	local tostring = assert(_G.tostring)
	local table_sort = assert(_G.table.sort)
	local table_concat = assert(_G.table.concat)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)

	local bidirectionalDictionary = Linquidate.BidirectionalDictionary or {}
	if not bidirectionalDictionary.prototype then
		bidirectionalDictionary.prototype = {}
	end
	setmetatable(bidirectionalDictionary.prototype, { __index= enumerable.prototype})
	
	Linquidate.BidirectionalDictionary = bidirectionalDictionary
	local bidirectionalDictionary_proxy = newproxy(true)
	local bidirectionalDictionary_mt = getmetatable(bidirectionalDictionary_proxy)
	bidirectionalDictionary_mt.__index = bidirectionalDictionary.prototype
	function bidirectionalDictionary_mt:__tostring()
		return self:ToString()
	end

	local NIL = bidirectionalDictionary.__NIL or newproxy()
	bidirectionalDictionary.__NIL = NIL
	
	local keys_to_values = make_weak_keyed_table(bidirectionalDictionary.__keys_to_values)
	bidirectionalDictionary.__keys_to_values = keys_to_values
	local values_to_keys = make_weak_keyed_table(bidirectionalDictionary.__values_to_keys)
	bidirectionalDictionary.__values_to_keys = values_to_keys
	local key_lookups = make_weak_keyed_table(bidirectionalDictionary.__key_lookups)
	bidirectionalDictionary.__key_lookups = key_lookups
	local value_lookups = make_weak_keyed_table(bidirectionalDictionary.__value_lookups)
	bidirectionalDictionary.__value_lookups = value_lookups
	local key_comparison_selectors = make_weak_keyed_table(bidirectionalDictionary.__key_comparison_selectors)
	bidirectionalDictionary.__key_comparison_selectors = key_comparison_selectors
	local value_comparison_selectors = make_weak_keyed_table(bidirectionalDictionary.__value_comparison_selectors)
	bidirectionalDictionary.__key_comparison_selectors = value_comparison_selectors
	local contracts = make_weak_keyed_table(bidirectionalDictionary.__contracts)
	bidirectionalDictionary.__contracts = contracts
	local readonlys = make_weak_keyed_table(bidirectionalDictionary.__readonlys)
	bidirectionalDictionary.__readonlys = readonlys
	local inverses = make_weak_keyed_table(bidirectionalDictionary.__inverses)
	bidirectionalDictionary.__inverses = inverses

	--- Construct and return a new BidirectionalDictionary
	-- @param dict optional: a BidirectionalDictionary or lua table to populate the new dictionary with
	-- @param key_comparison_selector optional: a function to generate a unique key per element
	-- @param value_comparison_selector optional: a function to generate a unique value per element
	-- @usage BidirectionalDictionary.New()
	-- @usage BidirectionalDictionary.New({ a = 1, b = 2 })
	-- @usage BidirectionalDictionary.New({ a = 1, b = 2 }, string.upper)
	-- @usage BidirectionalDictionary.New(nil, string.upper)
	function bidirectionalDictionary.New(dict, key_comparison_selector, value_comparison_selector)
		check(1, dict, 'userdata', 'table', 'nil')
		check(2, key_comparison_selector, 'function', 'string', 'nil')
		check(3, value_comparison_selector, 'function', 'string', 'nil')

		local self = newproxy(bidirectionalDictionary_proxy)

		keys_to_values[self] = {}
		values_to_keys[self] = {}
		if key_comparison_selector then
			key_lookups[self] = {}
			key_comparison_selectors[self] = convert_function(key_comparison_selector)
		end
		if value_comparison_selector then
			value_lookups[self] = {}
			value_comparison_selectors[self] = convert_function(value_comparison_selector)
		end

		if dict ~= nil then
			if type(dict) == 'table' then
				for k, v in pairs(dict) do
					self:Add(k, v)
				end
			elseif Linquidate.Dictionary.IsDictionary(dict) then
				dict:ForEachByPair(function(k, v)
					self:Add(k, v)
				end)
			else
				error(string.format("Can't convert %s (%s) to a dictionary", type(dict), tostring(dict)), 2)
			end
		end

		return self
	end
	
	--- Verify that the contract for this BidirectionalDictionary is valid for all elements in the dictionary.
	-- If there is no contract, this does nothing.
	-- @usage dict:VerifyContract()
	function bidirectionalDictionary.prototype:VerifyContract()
		check(1, self, 'userdata')

		local contract = contracts[self]
		if not contract then
			return
		end

		local key_lookup = key_lookups[self]
		for hash_key, value in pairs(keys_to_values[self]) do
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
				error(string.format("Element (%s, %s) does not meet the contract for this BidirectionalDictionary.", tostring_q(key), tostring_q(value)), 2)
				break
			end
		end
	end

	local function generate_inverse_contract(contract)
		if contract then
			return function(k, v)
				return contract(v, k)
			end
		else
			return nil
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all keys are strings and all values are positive integers or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the key and value and should return whether the pair is valid.
	-- @usage dict:SetContract(function(k, v) return type(k) == "string" and type(v) == "number" end)
	function bidirectionalDictionary.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')
		
		if readonlys[self] then
			error("Cannot set the contract on a read-only BidirectionalDictionary", 2)
		end

		contracts[self] = contract
		if inverses[self] then
			contracts[inverses[self]] = generate_inverse_contract(contract)
		end
		self:VerifyContract()
	end
	
	--- Make the Set read-only, preventing any further modifications.
	-- There is no way to convert a Set back to being modifiable.
	-- @return the same Set that was made read-only
	-- @usage set:ConvertToReadOnly()
	function bidirectionalDictionary.prototype:ConvertToReadOnly()
		check(1, self, 'userdata')

		if readonlys[self] then
			return
		end

		readonlys[self] = true
		if inverses[self] then
			readonlys[inverses[self]] = true
		end

		return self
	end

	--- Return whether the Set is read-only, and thus cannot have modifications made to it.
	-- @return a boolean
	-- @usage local read_only = set:IsReadOnly()
	function bidirectionalDictionary.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return not not readonlys[self]
	end

	--- Return an enumerator for the BidirectionalDictionary that returns the keys of the dictionary
	function bidirectionalDictionary.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local key
		local table = keys_to_values[self]
		local key_lookup = key_lookups[self]

		return enumerator.New(
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

	--- Add the specific key and value to the BidirectionalDictionary.
	-- This will error if an element with the same key already exists in the BidirectionalDictionary.
	-- To avoid erroring in this case, use :Set(key, value) instead.
	-- This will error if an element with the same value already exists in the BidirectionalDictionary.
	-- @param key the key of the element to add
	-- @param value the value of the element to add
	-- @usage dict:Add("key", "value")
	function bidirectionalDictionary.prototype:Add(key, value)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add to a read-only BidirectionalDictionary", 2)
		end

		local contract = contracts[self]
		if contract and not contract(key, value) then
			error(string.format("Element (%s, %s) does not meet the contract for this BidirectionalDictionary", tostring_q(key), tostring_q(value)), 2)
		end

		local key_comparison_selector = key_comparison_selectors[self]
		local value_comparison_selector = value_comparison_selectors[self]
		local k2v = keys_to_values[self]
		local v2k = values_to_keys[self]

		local hash_key
		if key_comparison_selector then
			hash_key = key_comparison_selector(key)
		else
			hash_key = key
		end
		local hash_value
		if value_comparison_selector then
			hash_value = value_comparison_selector(value)
		else
			hash_value = value
		end

		local key_lookup = key_lookups[self]
		local value_lookup = value_lookups[self]

		if hash_key == nil then
			hash_key = NIL
		end
		if hash_value == nil then
			hash_value = NIL
		end

		if k2v[hash_key] ~= nil then
			error("Key already exists in BidirectionalDictionary", 2)
		end
		if v2k[hash_value] ~= nil then
			error("Value already exists in BidirectionalDictionary", 2)
		end

		if value == nil then
			value = NIL
		end
		k2v[hash_key] = value
		if key == nil then
			key = NIL
		end
		v2k[hash_value] = key

		if key_comparison_selector then
			key_lookup[hash_key] = key
		end
		if value_comparison_selector then
			value_lookup[hash_value] = value
		end
	end
	
	--- Set the specific key and value to the BidirectionalDictionary.
	-- If overriding an existing value, the key will not change or be overridden.
	-- @param key the key of the element to set
	-- @param value the value of the element to set
	-- @usage dict:Set("key", "value")
	function bidirectionalDictionary.prototype:Set(key, value)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot alter a read-only BidirectionalDictionary", 2)
		end

		local contract = contracts[self]
		if contract and not contract(key, value) then
			error(string.format("Element (%s, %s) does not meet the contract for this BidirectionalDictionary", tostring_q(key), tostring_q(value)), 2)
		end

		local key_comparison_selector = key_comparison_selectors[self]
		local value_comparison_selector = value_comparison_selectors[self]
		local k2v = keys_to_values[self]
		local v2k = values_to_keys[self]
		
		local hash_key
		if key_comparison_selector then
			hash_key = key_comparison_selector(key)
		else
			hash_key = key
		end
		local hash_value
		if value_comparison_selector then
			hash_value = value_comparison_selector(value)
		else
			hash_value = value
		end

		local key_lookup = key_lookups[self]
		local value_lookup = value_lookups[self]
		
		if hash_key == nil then
			hash_key = NIL
		end
		if hash_value == nil then
			hash_value = NIL
		end
		
		if v2k[hash_value] ~= nil then
			error("Value already exists in BidirectionalDictionary", 2)
		end
		
		if key == nil then
			key = NIL
		end
		if value == nil then
			value = NIL
		end

		local old_value = k2v[hash_key]
		if old_value ~= nil then
			if old_value == NIL then
				old_value = nil
			end
			local old_hash_value
			if value_comparison_selector then
				old_hash_value = value_comparison_selector(old_value)
			else
				old_hash_value = old_value
			end
			if old_hash_value == nil then
				old_hash_value = NIL
			end
			v2k[old_hash_value] = nil
			if value_lookup then
				value_lookup[old_hash_value] = nil
			end
		end

		k2v[hash_key] = value
		v2k[hash_value] = key

		if key_comparison_selector then
			if key_lookup[hash_key] == nil then -- the key shouldn't change, even if it is different
				key_lookup[hash_key] = key
			end
		end
		if value_comparison_selector then
			if value_lookup[hash_value] == nil then -- the value shouldn't change, even if it is different
				value_lookup[hash_value] = value
			end
		end
	end
	
	--- Merge another dictionary onto the current BidirectionalDictionary.
	-- @param other a BidirectionalDictionary to Merge onto the current
	-- @usage BidirectionalDictionary.From({ alpha = 1, bravo = 2 }):Merge({ bravo = 3, charlie = 4 }) -- BidirectionalDictionary["alpha": 1, "bravo": 3, "charlie": 4]
	function bidirectionalDictionary.prototype:Merge(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot alter a read-only BidirectionalDictionary", 2)
		end

		Linquidate.Dictionary.From(other):ForEachByPair(function(k, v, _)
			self:Set(k, v)
		end)
	end

	--- Get the specific value in the BidirectionalDictionary given the requested key.
	-- This will error if the key is not in the BidirectionalDictionary.
	-- @param key the key of the element to get
	-- @return the value requested
	-- @usage local value = dict:Get("key")
	function bidirectionalDictionary.prototype:Get(key)
		check(1, self, 'userdata')

		local success, value = self:TryGetValue(key)
		if not success then
			error("Key not found in dictionary", 2)
		else
			return value
		end
	end
	
	--- Get the specific value or a default value in the BidirectionalDictionary given the requested key.
	-- This will return the default value if not found.
	-- @param key the key of the element to get
	-- @param default the default value to return if the key is not found.
	-- @return the value requested or the default value
	-- @usage local value = dict:GetOrDefault("key", 0)
	function bidirectionalDictionary.prototype:GetOrDefault(key, default)
		check(1, self, 'userdata')
		
		local success, value = self:TryGetValue(key)
		if not success then
			return default
		else
			return value
		end
	end

	--- Try to get the specific value in the BidirectionalDictionary given the requested key.
	-- @param key the key of the element to get
	-- @return whether the get was successful
	-- @return the value requested
	-- @usage local success, value = dict:TryGetValue("key")
	function bidirectionalDictionary.prototype:TryGetValue(key)
		check(1, self, 'userdata')

		local key_comparison_selector = key_comparison_selectors[self]
		local k2v = keys_to_values[self]

		local hash_key
		if key_comparison_selector then
			hash_key = key_comparison_selector(key)
		else
			hash_key = key
		end

		if hash_key == nil then
			hash_key = NIL
		end

		local value = k2v[hash_key]
		if value == nil then
			return false
		end

		if value == NIL then
			return true, nil
		else
			return true, value
		end
	end
	
	--- Clear all elements from the BidirectionalDictionary
	-- @usage dict:Clear()
	function bidirectionalDictionary.prototype:Clear()
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot alter a read-only BidirectionalDictionary", 2)
		end

		wipe(keys_to_values[self])
		wipe(values_to_keys[self])
		local key_lookup = key_lookups[self]
		if key_lookup then
			wipe(key_lookup)
		end
		local value_lookup = value_lookups[self]
		if value_lookup then
			wipe(value_lookup)
		end
	end
	
	--- Return whether a given key is present in the BidirectionalDictionary
	-- @param key the key to check for
	-- @return a boolean
	-- @usage local found = dict:ContainsKey("key")
	function bidirectionalDictionary.prototype:ContainsKey(key)
		check(1, self, 'userdata')

		local key_comparison_selector = key_comparison_selectors[self]
		if key_comparison_selector then
			key = key_comparison_selector(key)
		end
		if key == nil then
			key = NIL
		end
		return keys_to_values[self][key] ~= nil
	end
	
	--- Return whether a given value is present in the BidirectionalDictionary
	-- @param value the value to check for
	-- @return a boolean
	-- @usage local found = dict:ContainsValue("value")
	function bidirectionalDictionary.prototype:ContainsValue(value)
		check(1, self, 'userdata')
		
		local value_comparison_selector = value_comparison_selectors[self]
		if value_comparison_selector then
			value = value_comparison_selector(value)
		end
		if value == nil then
			value = NIL
		end
		return values_to_keys[self][value] ~= nil
	end
	
	--- Removes the element with the provided key from the BidirectionalDictionary
	-- @param key the key to remove
	-- @return whether the element was removed
	-- @usage local removed = dict:Remove("key")
	function bidirectionalDictionary.prototype:Remove(key)
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove from a read-only BidirectionalDictionary", 2)
		end

		local k2v = keys_to_values[self]
		local key_comparison_selector = key_comparison_selectors[self]
		if key_comparison_selector then
			key = key_comparison_selector(key)
		end
		if key == nil then
			key = NIL
		end
		if k2v[key] ~= nil then
			local value = k2v[key]
			k2v[key] = nil
			local key_lookup = key_lookups[self]
			if key_lookup then
				key_lookup[key] = nil
			end

			if value == NIL then
				value = nil
			end
			local value_comparison_selector = value_comparison_selectors[self]
			if value_comparison_selector then
				value = value_comparison_selector(value)
			end
			if value == nil then
				value = NIL
			end

			values_to_keys[self][value] = nil
			local value_lookup = value_lookups[self]
			if value_lookup then
				value_lookup[value] = nil
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
	function bidirectionalDictionary.prototype:RemoveWhere(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		if readonlys[self] then
			error("Cannot remove from a read-only BidirectionalDictionary", 2)
		end

		predicate = convert_function(predicate)

		local key_lookup = key_lookups[self]
		local value_lookup = value_lookups[self]
		
		local k2v = keys_to_values[self]
		local v2k = values_to_keys[self]
		
		local value_comparison_selector = value_comparison_selectors[self]

		local num = 0
		for hash_key, value in pairs(k2v) do
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
				k2v[hash_key] = nil

				local hash_value
				if value_comparison_selector then
					hash_value = value_comparison_selector(hash_value)
				else
					hash_value = value
				end
				if hash_value == nil then
					hash_value = NIL
				end

				if value_lookup then
					value_lookup[hash_value] = nil
				end
				v2k[hash_value] = nil

				num = num + 1
			end
		end
		return num
	end
	
	--- Make a shallow clone of the Set.
	-- @usage local other = dict:Clone()
	function bidirectionalDictionary.prototype:Clone()
		check(1, self, 'userdata')

		local other = bidirectionalDictionary.New(nil, key_comparison_selectors[self], value_comparison_selectors[self])
		local contract = contracts[self]
		if contract then
			other:SetContract(contracts[self])
		end
		other:Merge(self)

		return other
	end

	--- Return the inverse of this BidirectionalDictionary, with the keys and values swapped.
	-- @usage local inverse = dict:Inverse()
	function bidirectionalDictionary.prototype:Inverse()
		check(1, self, 'userdata')
		
		local inverse = inverses[self]
		if inverse then
			return inverse
		end

		inverse = newproxy(bidirectionalDictionary_proxy)

		keys_to_values[inverse] = values_to_keys[self]
		values_to_keys[inverse] = keys_to_values[self]
		key_lookups[inverse] = value_lookups[self]
		value_lookups[inverse] = key_lookups[self]
		key_comparison_selectors[inverse] = value_comparison_selectors[self]
		value_comparison_selectors[inverse] = key_comparison_selectors[self]
		contracts[inverse] = generate_inverse_contract(contracts[self])
		readonlys[inverse] = readonlys[self]
		inverses[inverse] = self
		inverses[self] = inverse

		return inverse
	end

	-- Methods that are faster than using the standard Enumerable ones:
	
	function bidirectionalDictionary.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return (next(keys_to_values[self])) ~= nil
		else
			return enumerable.prototype.Any(self, predicate)
		end
	end
	
	bidirectionalDictionary.prototype.Contains = bidirectionalDictionary.prototype.ContainsKey

	function bidirectionalDictionary.prototype:MemoizeAll()
		return self
	end
	
	function bidirectionalDictionary.prototype:ToString()
		check(1, self, 'userdata')

		local t = {}
		t[table.getn(t)+1] = 'BidirectionalDictionary['
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
	
	function bidirectionalDictionary.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convert_function(action)

		local index = 0
		local key_lookup = key_lookups[self]
		for hash_key in pairs(keys_to_values[self]) do
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
	-- @usage for index, key, value in BidirectionalDictionary.New({ a = 1, b = 2 }):Iterate() do end
	function bidirectionalDictionary.prototype:Iterate()
		local hash_key
		return function(self, index)
			local value
			hash_key, value = next(keys_to_values[self], hash_key)
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
	function bidirectionalDictionary.prototype:ForEachByPair(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convert_function(action)

		local index = 0
		local key_lookup = key_lookups[self]
		for hash_key, value in pairs(keys_to_values[self]) do
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
	function bidirectionalDictionary.prototype:SelectByPair(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string')

		selector = convert_function(selector)

		return enumerable.New(function()
			local key
			local k2v = keys_to_values[self]
			local key_lookup = key_lookups[self]
			local index = 0

			return enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(k2v, key)
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

	--- Return an Enumerable of all the keys in the BidirectionalDictionary.
	-- This may not return in a known order.
	-- @return an Enumerable
	-- @usage local keys = dict:Keys()
	function bidirectionalDictionary.prototype:Keys()
		check(1, self, 'userdata')

		return enumerable.New(function()
			local key
			local k2v = keys_to_values[self]
			local key_lookup = key_lookups[self]

			return enumerator.New(
				nil,
				function(yield)
					key = next(k2v, key)
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
	
	--- Return an Enumerable of all the values in the BidirectionalDictionary.
	-- This may not return in a known order.
	-- @return an Enumerable
	-- @usage local values = dict:Values()
	function bidirectionalDictionary.prototype:Values()
		check(1, self, 'userdata')

		return enumerable.New(function()
			local key
			local k2v = keys_to_values[self]

			return enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(k2v, key)
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
		-- TODO: merge this with the other Dictionary KeyValuePair
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

	--- Return an Enumerable of KeyValuePair representing all the elements of the current BidirectionalDictionary.
	-- @return an Enumerable
	-- @usage local kvps = dict:ToKeyValuePairs()
	function bidirectionalDictionary.prototype:ToKeyValuePairs()
		check(1, self, 'userdata')

		return enumerable.New(function()
			local key
			local k2v = keys_to_values[self]
			local key_lookup = key_lookups[self]

			return enumerator.New(
				nil,
				function(yield)
					local value
					key, value = next(k2v, key)
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

	--- Randomly pick a random element in the BidirectionalDictionary, remove it, and return the key and value.
	-- This will error if the Set is empty.
	-- @return a random key in the BidirectionalDictionary
	-- @return a random value in the BidirectionalDictionary
	-- @usage local key, value = dict:PickAndRemoveRandom()
	function bidirectionalDictionary.prototype:PickAndRemoveRandom()
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove elements from a read-only BidirectionalDictionary", 2)
		end

		if not self:Any() then
			error("Cannot remove from an empty BidirectionalDictionary", 2)
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
	--- Convert the BidirectionalDictionary to a simple lua table.
	-- This will be missing values if nil is used.
	-- @param kind "set" to return a table where all values are true, "list" to return a list-like table, or nil to return a standard dictionary-like table
	-- @usage BidirectionalDictionary.New({ hey = "there" }):ToTable()["hey"] == "there"
	-- @usage BidirectionalDictionary.New({ hey = "there" }):ToTable("list")[1] == "hey"
	-- @usage BidirectionalDictionary.New({ hey = "there" }):ToTable("set")["hey"] == true
	function bidirectionalDictionary.prototype:ToTable(kind)
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

	--- Create and return a new BidirectionalDictionary from the current Enumerable based on the provided selectors.
	-- @param key_selector a function to get the key of the dictionary from an element
	-- @param value_selector optional: a function to get the value of the dictionary from an element
	-- @param key_comparison_selector optional: a function to generate a unique key per element
	-- @param value_comparison_selector optional: a function to generate a unique value per element
	-- @return a BidirectionalDictionary
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToBidirectionalDictionary(function(x) return x:sub(1, 1) end)
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToBidirectionalDictionary(function(x) return x:sub(1, 1) end, string.lower)
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToBidirectionalDictionary(function(x) return x:sub(1, 1) end, nil, string.upper)
	-- @usage Enumerable.From({ "Alpha", "Bravo", "Charlie" }):ToBidirectionalDictionary(function(x) return x:sub(1, 1) end, nil, nil, string.upper)
	function enumerable.prototype:ToBidirectionalDictionary(key_selector, value_selector, key_comparison_selector, value_comparison_selector)
		check(1, self, 'userdata')
		check(2, key_selector, 'function', 'string')
		check(3, value_selector, 'function', 'string', 'nil')
		check(4, key_comparison_selector, 'function', 'string', 'nil')
		check(5, value_comparison_selector, 'function', 'string', 'nil')

		key_selector = convert_function(key_selector)
		if value_selector then
			value_selector = convert_function(value_selector)
		end

		local dict = bidirectionalDictionary.New(nil, comparison_selector, value_comparison_selector)
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