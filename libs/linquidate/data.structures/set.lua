_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local enumerable = assert(Linquidate.Enumerable)
	local enumerator = assert(Linquidate.Enumerator)
	
	local wipe = assert(Linquidate.Utilities.wipe)
	local check = assert(Linquidate.Utilities.check)
	local identity = assert(Linquidate.Utilities.identity)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local make_weak_table = assert(Linquidate.Utilities.make_weak_table)
	local convert_function = assert(Linquidate.Utilities.convert_function)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)

	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	
	local next = assert(_G.next)
	local type = assert(_G.type)
	local error = assert(_G.error)
	local pairs = assert(_G.pairs)
	local pcall = assert(_G.pcall)
	local newproxy = assert(_G.newproxy)
	local table_sort = assert(_G.table.sort)

	local set = Linquidate.Set or {}
	if not set.prototype then
		set.prototype = {}
	end
	setmetatable(set.prototype, { __index= enumerable.prototype})
	
	Linquidate.Set = set
	local set_proxy = newproxy(true)
	local set_mt = getmetatable(set_proxy)
	set_mt.__index = set.prototype
	function set_mt:__tostring()
		return self:ToString()
	end

	local NIL = set.__NIL or newproxy()
	set.__NIL = NIL

	local tables = make_weak_keyed_table(set.__tables)
	set.__tables = tables
	local comparison_selectors = make_weak_keyed_table(set.__comparison_selectors)
	set.__comparison_selectors = comparison_selectors
	local contracts = make_weak_keyed_table(set.__contracts)
	set.__contracts = contracts
	local wrapped_tables = make_weak_table(set.__wrapped_tables)
	set.__wrapped_tables = wrapped_tables
	local readonlys = make_weak_keyed_table(set.__readonlys)
	set.__readonlys = readonlys
	if set.__is_wrapped then
		local is_wrapped = set.__is_wrapped
		set.__is_wrapped = nil
		for k, v in pairs(is_wrapped) do
			if v then
				wrapped_tables[tables[k]] = k
			end
		end
	end

	--- Construct and return a new Set
	-- @param sequence optional: The sequence to union the set with
	-- @param comparison_selector optional: a function to generate a unique key per element
	-- @return a Set
	-- @usage local set = Set.New()
	-- @usage local set = Set.New({ 1, 2, 3, 2, 4 })
	-- @usage local set = Set.New(nil, tostring)
	-- @usage local set = Set.New({ "alpha", "Alpha", "ALPHA" }, string.upper)
	function set.New(sequence, comparison_selector)
		check(1, sequence, 'userdata', 'table', 'nil')
		check(2, comparison_selector, 'function', 'string', 'nil')

		local self = newproxy(set_proxy)

		tables[self] = {}
		comparison_selectors[self] = comparison_selector and convert_function(comparison_selector)

		if sequence then
			self:UnionWith(sequence)
		end

		return self
	end
	
	--- Construct and return a new Set
	-- @param comparison_selector optional: a function to generate a unique key per element
	-- @param ... arguments to populate the set with
	function set.FromArguments(comparison_selector, ...)
		check(1, comparison_selector, 'function', 'string', 'nil')

		local self = set.New(nil, comparison_selector and convert_function(comparison_selector))

		self:AddMany(unpack(arg))

		return self
	end

	--- Return a Set based on either a sequence or item passed in.
	-- If a table is passed it, it will be wrapped rather than a new Set being made and copying all the data in.
	-- @param sequence_or_item either a set-like table, a sequence, a Set, or another value which a Set will wrap around.
	-- @return a Set
	-- @usage local set = Set.FromSequenceOrItem(nil) -- Set containing nil, not empty
	-- @usage local set = Set.FromSequenceOrItem("hey") -- Set containing "hey"
	-- @usage local set = Set.FromSequenceOrItem({ alpha = true, bravo = true }) -- Set containing "alpha" and "bravo"
	-- @usage local set = Set.FromSequenceOrItem(Enumerable.From({ 1, 2, 3 })) -- Set containing 1, 2, and 3
	function set.FromSequenceOrItem(sequence_or_item)
		local item_type = type(sequence_or_item)

		if item_type == 'table' then
			return set.WrapTable(sequence_or_item)
		elseif item_type == 'userdata' then
			if tables[sequence_or_item] then
				-- it's a Set already
				return sequence_or_item
			else
				return set.New(sequence_or_item)
			end
		else
			return set.FromArguments(nil, sequence_or_item)
		end
	end

	--- Wrap a lua table such that there is parity between the passed-in table and the Set.
	-- Unlike other tables, this will not gracefully handle nils.
	-- @param t the table to wrap around
	-- @return a Set
	-- @usage local set = Set.WrapTable({ [1] = true, [2] = true, [3] = true })
	-- @usage local set = Set.WrapTable({ hey = true, there = true })
	function set.WrapTable(t)
		check(1, t, 'table')

		local self = wrapped_tables[t]
		if self then
			return self
		end

		self = newproxy(set_proxy)

		tables[self] = t
		wrapped_tables[t] = self

		return self
	end

	--- Get the enumerator for the Set
	-- @return an Enumerator
	function set.prototype:GetEnumerator()
		check(1, self, 'userdata')
		
		local key
		local table = tables[self]
		local has_comparison_selector = not not comparison_selectors[self]

		return enumerator.New(
			nil,
			function(yield)
				local value
				key, value = next(table, key)

				if key == nil then
					return false
				end

				if not has_comparison_selector then
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
	
	--- Verify that the contract for this List is valid for all elements in the List.
	-- If there is no contract, this does nothing.
	-- @usage list:VerifyContract()
	function set.prototype:VerifyContract()
		check(1, self, 'userdata')

		local contract = contracts[self]
		if not contract then
			return
		end
		
		local table = tables[self]
		local has_comparison_selector = not not comparison_selectors[self]

		local key
		local index = 0
		while true do
			index = index + 1
			
			local value
			key, value = next(table, key)
			if key == nil then
				break
			end
			
			if not has_comparison_selector then
				value = key
			end

			if value == NIL then
				value = nil
			end

			if not contract(value) then
				error(string.format("Element %s does not meet the contract for this Set.", tostring_q(value)), 2)
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all values are strings or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the element and should return whether the element is valid.
	-- @usage set:SetContract(function(v) return type(v) == "string" end)
	function set.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')
		
		if readonlys[self] then
			error("Cannot set the contract on a read-only Set", 2)
		end

		contracts[self] = contract
		self:VerifyContract()
	end
	
	--- Make the Set read-only, preventing any further modifications.
	-- There is no way to convert a Set back to being modifiable.
	-- @return the same Set that was made read-only
	-- @usage set:ConvertToReadOnly()
	function set.prototype:ConvertToReadOnly()
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
	function set.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return not not readonlys[self]
	end

	--- Make a shallow clone of the Set.
	-- If the previous Set was read-only, the clone will not be.
	-- @usage local other = set:Clone()
	function set.prototype:Clone()
		check(1, self, 'userdata')

		local other = set.New(nil, comparison_selectors[self])
		local contract = contracts[self]
		if contract then
			other:SetContract(contracts[self])
		end
		other:UnionWith(self)

		return other
	end

	function set.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convert_function(action)

		local table = tables[self]
		local has_comparison_selector = not not comparison_selectors[self]

		local key
		local index = 0
		while true do
			index = index + 1
			
			local value
			key, value = next(table, key)
			if key == nil then
				break
			end
			
			if not has_comparison_selector then
				value = key
			end

			if value == NIL then
				value = nil
			end

			if action(value, index) == false then
				break
			end
		end
	end

	function set.prototype:Iterate()
		local key
		return function(self, index)
			local value
			key, value = next(tables[self], key)
			if key == nil then
				return nil
			end

			if not comparison_selectors[self] then
				value = key
			end
			if value == NIL then
				value = nil
			end
			return index + 1, value
		end, self, 0
	end

	--- Modify the current set to include the elements of the provided sequence
	-- @param sequence the sequence to union against
	-- @usage set:UnionWith({ 1, 2, 3 })
	-- @usage set:UnionWith(Enumerable.RangeTo(1, 3))
	function set.prototype:UnionWith(sequence)
		check(1, self, 'userdata')
		check(2, sequence, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot add to a read-only Set", 2)
		end

		sequence = enumerable.From(sequence)

		sequence:ForEach(function(item)
			self:Add(item)
		end)
	end
	
	--- Add an element to the Set
	-- @param item the element to add
	-- @return whether the element was inserted properly, this is typically false if the item already exists.
	-- @usage local success = set:Add(5)
	-- @usage local success = set:Add(nil)
	function set.prototype:Add(item)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add to a read-only Set", 2)
		end

		local contract = contracts[self]
		if contract and not contract(item) then
			error(string.format("Element %s does not meet the contract for this Set.", tostring_q(item)), 2)
		end

		local table = tables[self]
		local comparison_selector = comparison_selectors[self]
		if comparison_selector then
			local key = comparison_selector(item)
			if key == nil then
				key = NIL
			end
			if item == nil then
				item = NIL
			end
			if table[key] == nil then
				table[key] = item
				return true
			else
				return false
			end
		else
			if item == nil then
				if wrapped_tables[table] then
					return false
				end
				item = NIL
			end
			if table[item] == nil then
				table[item] = true
				return true
			else
				return false
			end
		end
	end
	
	--- Add multiple elements to the current Set
	-- @param ... zero or more arguments to add
	-- @usage set:AddMany(1, 2, 3)
	function set.prototype:AddMany(...)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add to a read-only Set", 2)
		end

		for i = 1, table.getn(arg) do
			self:Add((arg[i]))
		end
	end
	
	--- Remove an element from the Set
	-- @param item item to try to remove from the Set
	-- @return whether succesfully removed the element
	-- @usage local removed = set:Remove(1)
	function set.prototype:Remove(item)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot remove from a read-only Set", 2)
		end

		local table = tables[self]
		local comparison_selector = comparison_selectors[self]
		if comparison_selector then
			item = comparison_selector(item)
		end
		if item == nil then
			item = NIL
		end
		if table[item] ~= nil then
			table[item] = nil
			return true
		else
			return false
		end
	end
	
	--- Remove all elements which match a given predicate
	-- @param predicate a function which is passed each element and should return true to remove, false to keep
	-- @return the number of elements removed
	-- @usage local num = set:RemoveWhere(function(x) return x % 2 == 0 end)
	function set.prototype:RemoveWhere(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		if readonlys[self] then
			error("Cannot remove from a read-only Set", 2)
		end

		predicate = convert_function(predicate)

		local has_comparison_selector = not not comparison_selectors[self]
		
		local table = tables[self]
		local num = 0
		for k, v in pairs(table) do
			local item
			if has_comparison_selector then
				item = v
			else
				item = k
			end
			if item == NIL then
				item = nil
			end
			if predicate(item) then
				table[k] = nil
				num = num + 1
			end
		end
		return num
	end

	--- Clear all elements from the Set
	-- @usage set:Clear()
	function set.prototype:Clear()
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot remove from a read-only Set", 2)
		end

		wipe(tables[self])
	end
	
	-- Methods that are faster than using the standard Enumerable ones:
	
	function set.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return (next(tables[self])) ~= nil
		else
			return enumerable.prototype.Any(self, predicate)
		end
	end
	
	function set.prototype:Contains(item)
		check(1, self, 'userdata')

		local comparison_selector = comparison_selectors[self]
		if comparison_selector then
			item = comparison_selector(item)
		end
		if item == nil then
			item = NIL
		end
		return tables[self][item] ~= nil
	end

	function set.prototype:MemoizeAll()
		check(1, self, 'userdata')

		return self
	end

	function set.prototype:ToString()
		check(1, self, 'userdata')

		return "Set" .. enumerable.prototype.ToString(self:OrderBy(identity))
	end

	--- Removes all elements in the specified sequence from the current Set
	-- @param sequence the sequence of items to remove from the current Set
	-- @usage set:ExceptWith({ 1, 2, 3 })
	function set.prototype:ExceptWith(sequence)
		check(1, self, 'userdata')
		check(2, sequence, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot alter a read-only Set", 2)
		end

		sequence = enumerable.From(sequence)
		if sequence == self then
			self:Clear()
			return
		end

		sequence:ForEach(function(item)
			self:Remove(item)
		end)
	end

	--- Modifies the current Set to contain only items which also exist in the provided sequence
	-- @param sequence the sequence of items to include in the current Set
	-- @usage set:IntersectWith({ 1, 2, 3 })
	function set.prototype:IntersectWith(sequence)
		check(1, self, 'userdata')
		check(2, sequence, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot alter a read-only Set", 2)
		end

		sequence = enumerable.From(sequence)
		if sequence == self then
			return
		end
		
		local comparison_selector = comparison_selectors[self]
		local other_set
		if not tables[sequence] or comparison_selectors[sequence] ~= comparison_selector then
			other_set = set.New(sequence, comparison_selector)
		else
			other_set = sequence
		end

		local table = tables[self]
		local other_table = tables[other_set]
		for k, _ in pairs(table) do
			if other_table[k] == nil then
				table[k] = nil
			end
		end
	end
	
	--- Modifies the current Set to only contain elements present in either that sequence or the other sequence, but not both.
	-- @param sequence the sequence to compare to the current
	-- @usage set:SymmetricExceptWith({ 1, 2, 3 })
	function set.prototype:SymmetricExceptWith(sequence)
		check(1, self, 'userdata')
		check(2, sequence, 'userdata', 'table')
		
		if readonlys[self] then
			error("Cannot alter a read-only Set", 2)
		end

		sequence = enumerable.From(sequence)
		if sequence == self then
			self:Clear()
			return
		end
		
		local comparison_selector = comparison_selectors[self]
		local other_set
		if not tables[sequence] or comparison_selectors[sequence] ~= comparison_selector then
			other_set = set.New(sequence, comparison_selector)
		else
			other_set = sequence
		end

		local contract = contracts[self]
		local table = tables[self]
		local other_table = tables[other_set]
		for k, v in pairs(other_table) do
			if table[k] == nil then
				if contract and not contract(v) then
					error(string.format("Element %s does not meet the contract for this Set.", tostring_q(v)), 2)
				end
				table[k] = v
			else
				table[k] = nil
			end
		end
	end

	local function convert_to_set(self, other)
		other = enumerable.From(other)

		local comparison_selector = comparison_selectors[self]
		if not tables[other] or comparison_selectors[other] ~= comparison_selector then
			return set.New(other, comparison_selector)
		end

		return other
	end
	
	local function is_subset(self, other)
		local other_table = tables[other]
		for k in pairs(tables[self]) do
			if other_table[k] == nil then
				return false
			end
		end
		return true
	end

	--- Determines whether the current Set is a subset of the provided sequence
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:IsSubsetOf(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		if not self:Any() then
			return true
		end
		
		other = convert_to_set(self, other)

		if self == other then
			return true
		end

		if self:Count() > other:Count() then
			return false
		end

		return is_subset(self, other)
	end
	
	--- Determines whether the current Set is a superset of the provided sequence
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:IsSupersetOf(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		other = convert_to_set(self, other)

		if self == other then
			return true
		end

		if not other:Any() then
			return true
		end

		if self:Count() < other:Count() then
			return false
		end

		return is_subset(other, self)
	end
	
	--- Determines whether the current Set is a proper subset of the provided sequence
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:IsProperSubsetOf(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		other = convert_to_set(self, other)

		if self == other then
			return false
		end

		if self:Count() >= other:Count() then
			return false
		end

		return is_subset(self, other)
	end
	
	--- Determines whether the current Set is a proper superset of the provided sequence
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:IsProperSupersetOf(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')
		
		other = convert_to_set(self, other)
		
		if self == other then
			return false
		end

		if self:Count() <= other:Count() then
			return false
		end

		return is_subset(other, self)
	end

	--- Determines whether the current Set and a provided sequence share one or more common elements
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:Overlaps(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		if not self:Any() then
			return false
		end

		other = enumerable.From(other)
		if self == other then
			return true
		end

		local found = false
		other:ForEach(function(item)
			if self:Contains(item) then
				found = true
				return false
			end
		end)
		return found
	end

	--- Determines whether the current Set contains the same distinct elements as the provided collection
	-- @param other a sequence to compare against
	-- @return a boolean
	function set.prototype:SetEquals(other)
		check(1, self, 'userdata')
		check(2, other, 'userdata', 'table')

		other = enumerable.From(other)
		if self == other then
			return true
		end

		local comparison_selector = comparison_selectors[self]
		local keys = {}
		for k in pairs(tables[self]) do
			keys[k] = true
		end

		local found_extra = false
		other:ForEach(function(item)
			if comparison_selector then
				item = comparison_selector(item)
			end
			if item == nil then
				item = NIL
			end
			if keys[item] == nil then
				found_extra = true
				return false
			end
			keys[item] = false
		end)
		if found_extra then
			return false
		end

		for _, v in pairs(keys) do
			if v then
				return false
			end
		end
		return true
	end
	
	--- Randomly pick a random element in the Set, remove it, and return the value.
	-- This will error if the Set is empty.
	-- @return a random value in the Set
	-- @usage local value = set:PickAndRemoveRandom()
	function set.prototype:PickAndRemoveRandom()
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove elements from a read-only Set", 2)
		end

		if not self:Any() then
			error("Cannot remove from an empty Set", 2)
		end

		local item = self:PickRandom()
		self:Remove(item)
		return item
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
	--- Convert the Set to a simple lua table, with all values being true.
	-- This will be missing values if nil is used.
	-- @param kind "set" or nil to return a table where all values are true or "list" to return a list-like table
	-- @return a lua table
	-- @usage Set.New({ "hey", "there" }):ToTable()["hey"] == true
	-- @usage Set.New({ "hey", "there" }):ToTable('list')[1] == "hey"
	-- @usage Set.New({ "hey", "there" }):ToTable('set')["hey"] == true
	function set.prototype:ToTable(kind)
		check(1, self, 'userdata')
		check(2, kind, 'nil', 'string')

		local t = {}
		if kind == "list" then
			self:ForEach(function(x)
				if x ~= nil then
					t[table.getn(t) + 1] = x
				end
			end)
			table_sort(t, sorter)
		else
			self:ForEach(function(x, _)
				if x ~= nil then
					t[x] = true
				end
			end)
		end
		return t
	end

	--- Make a new Set filled with the contents of the current Enumerable
	-- @param comparison_selector optional: a function to generate a unique key per element
	-- @return a Set
	function enumerable.prototype:ToSet(comparison_selector)
		check(1, self, 'userdata')
		check(2, comparison_selector, 'function', 'string', 'nil')

		return set.New(self, comparison_selector)
	end
end)