_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)
	local make_weak_table = assert(Linquidate.Utilities.make_weak_table)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)
	local check = assert(Linquidate.Utilities.check)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local wipe = assert(Linquidate.Utilities.wipe)
	local convertFunction = assert(Linquidate.Utilities.convertFunction)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)

	local math_floor = assert(_G.math.floor)
	local error = assert(_G.error)
	local getmetatable = assert(_G.getmetatable)
	local setmetatable = assert(_G.setmetatable)
	local newproxy = assert(_G.newproxy)
	local select = assert(_G.select)
	local table_sort = assert(_G.table.sort)
	local math_random = assert(_G.math.random)
	local rawequal = assert(_G.rawequal)

	local List = Linquidate.List or {}

	Linquidate.List = List

	if not List.prototype then
		List.prototype = {}
	end
	setmetatable(List.prototype, {__index=Enumerable.prototype})
	
	local List_proxy = newproxy(true)
	local List_mt = getmetatable(List_proxy)
	List_mt.__index = List.prototype
	function List_mt:__tostring()
		return self:ToString()
	end
	
	local tables = make_weak_keyed_table(List.__tables)
	List.__tables = tables
	local counts = make_weak_keyed_table(List.__counts)
	List.__counts = counts
	local wrapped_tables = make_weak_table(List.__wrapped_tables)
	List.__wrapped_tables = wrapped_tables
	local contracts = make_weak_keyed_table(List.__contracts)
	List.__contracts = contracts
	local readonlys = make_weak_keyed_table(List.__readonlys)
	List.__readonlys = readonlys

	--- Construct and return a new list
	-- @param sequence optional: The sequence to fill the list with
	-- @return a List
	-- @usage local list = List.New()
	-- @usage local list = List.New({ 1, 2, 3 })
	-- @usage local list = List.New(Enumerable.RangeTo(1, 10))
	function List.New(sequence)
		check(1, sequence, 'userdata', 'table', 'nil')

		local self = newproxy(List_proxy)

		tables[self] = {}
		counts[self] = 0

		if sequence ~= nil then
			self:AddRange(sequence)
		end

		return self
	end
	
	--- Construct and return a new list based on the arguments provided
	-- @param ... a tuple of arguments to fill the list with
	-- @return a List
	-- @usage local list = List.FromArguments()
	-- @usage local list = List.FromArguments(1, 2, 3)
	-- @usage local list = List.FromArguments(nil, nil, 5)
	function List.FromArguments(...)
		local self = List.New()
		self:AddMany(unpack(...))
		return self
	end

	--- Wrap a lua table such that there is parity between the passed-in table and the List.
	-- Unlike other tables, this will not gracefully handle nils.
	-- @param t the table to wrap around
	-- @return a List
	-- @usage local list = List.WrapTable({ 1, 2, 3 })
	function List.WrapTable(t)
		check(1, t, 'table')

		local self = wrapped_tables[t]
		if self then
			return self
		end

		self = newproxy(List_proxy)

		tables[self] = t
		wrapped_tables[t] = self

		return self
	end
	Enumerable.SetTableWrapper(List.WrapTable)

	--- Return an Enumerator for the current List
	-- @return an Enumerator
	function List.prototype:GetEnumerator()
		check(1, self, 'userdata')

		local table = tables[self]
		local index = 0

		return Enumerator.New(
			nil,
			function(yield)
				if index < self:Count() then
					index = index + 1
					return yield(table[index])
				else
					return false
				end
			end,
			nil)
	end

	--- Verify that the contract for this List is valid for all elements in the List.
	-- If there is no contract, this does nothing.
	-- @usage list:VerifyContract()
	function List.prototype:VerifyContract()
		check(1, self, 'userdata')

		local contract = contracts[self]
		if not contract then
			return
		end
		
		local table = tables[self]
		local index = 0
		while true do
			index = index + 1
			if index > self:Count() then
				break
			end

			if not contract(table[index]) then
				error(("Element %s does not meet the contract for this List."):format(tostring_q(table[index])), 2)
			end
		end
	end

	--- Set a contract that will be verified against any existing elements and any added elements or changed values.
	-- This is handy for if you want to verify that all values are strings or something like that.
	-- This will call :VerifyContract()
	-- @param contract a function that is passed the element and should return whether the element is valid.
	-- @usage list:SetContract(function(v) return type(v) == "string" end)
	function List.prototype:SetContract(contract)
		check(1, self, 'userdata')
		check(2, contract, 'function', 'nil')

		if readonlys[self] then
			error("Cannot set the contract on a read-only List", 2)
		end

		contracts[self] = contract
		self:VerifyContract()
	end

	--- Make the List read-only, preventing any further modifications.
	-- There is no way to convert a List back to being modifiable.
	-- @return the same List that was made read-only
	-- @usage list:ConvertToReadOnly()
	function List.prototype:ConvertToReadOnly()
		check(1, self, 'userdata')

		if readonlys[self] then
			return
		end

		if not counts[self] then
			error("Cannot convert a wrapped table to read-only", 2)
		end
		
		readonlys[self] = true

		return self
	end

	--- Return whether the List is read-only, and thus cannot have modifications made to it.
	-- @return a boolean
	-- @usage local read_only = list:IsReadOnly()
	function List.prototype:IsReadOnly()
		check(1, self, 'userdata')

		return not not readonlys[self]
	end

	--- Add a sequence of elements to the current List
	-- @param sequence a sequence of elements to add
	-- @usage list:AddRange(Enumerable.RangeTo(1, 10))
	-- @usage list:AddRange({ 1, 2, 3 })
	function List.prototype:AddRange(sequence)
		check(1, self, 'userdata')
		check(2, sequence, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot add elements on a read-only List", 2)
		end

		local contract = contracts[self]
		local table = tables[self]
		local is_wrapped = not counts[self]
		local count = self:Count()
		Enumerable.From(sequence):ForEach(function(item)
			if contract and not contract(item) then
				error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
			end
			if not is_wrapped or item ~= nil then
				count = count + 1
				table[count] = item
			end
		end)
		if not is_wrapped then
			counts[self] = count
		end
	end
	
	--- Add an element to the List
	-- @param item the element to add
	-- @usage list:Add(5)
	-- @usage list:Add(nil)
	function List.prototype:Add(item)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add elements on a read-only List", 2)
		end
		
		local contract = contracts[self]
		if contract and not contract(item) then
			error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
		end

		local count = self:Count() + 1
		tables[self][count] = item
		if counts[self] then
			counts[self] = count
		end
	end
	
	--- Add multiple elements to the current List
	-- @param ... zero or more arguments to add
	-- @usage list:AddMany(1, 2, 3)
	function List.prototype:AddMany(...)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot add elements on a read-only List", 2)
		end

		local n = table.getn(arg)
		if n == 0 then
			return
		end

		local table = tables[self]
		local contract = contracts[self]
		local is_wrapped = not counts[self]

		local count = self:Count()
		for i = 1, n do
			local item = (arg[i])
			if contract and not contract(item) then
				error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
			end

			if not is_wrapped or item ~= nil then
				count = count + 1
				table[count] = item
			end
		end
		if not is_wrapped then
			counts[self] = count
		end
	end

	--- Insert an element into a position in the list.
	-- @param index the position of the element. Cannot be less than 1 or greater than count+1
	-- @param item the element to insert
	-- @usage list:Insert(1, "hey")
	function List.prototype:Insert(index, item)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if readonlys[self] then
			error("Cannot insert elements on a read-only List", 2)
		end

		local count = self:Count() + 1
		if index < 1 then
			error("index must be at least 1", 2)
		elseif index > count then
			error("index must not be greater than the count+1", 2)
		end

		local contract = contracts[self]
		if contract and not contract(item) then
			error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
		end

		local is_wrapped = not counts[self]
		if is_wrapped and item == nil then
			return
		end

		local table = tables[self]
		for i = count, index + 1, -1 do
			table[i] = table[i - 1]
		end
		table[index] = item
		if not is_wrapped then
			counts[self] = count
		end
	end
	
	--- Insert a sequence into a position in the list.
	-- @param index the position of the sequence. Cannot be less than 1 or greater than count+1
	-- @param sequence the sequence to insert
	-- @usage list:InsertRange(1, { "hey", "there" })
	-- @usage list:InsertRange(1, Enumerable.RangeTo(1, 5))
	function List.prototype:InsertRange(index, sequence)
		check(1, self, 'userdata')
		check(2, index, 'number')
		check(3, sequence, 'userdata', 'table')
		
		if readonlys[self] then
			error("Cannot insert elements on a read-only List", 2)
		end

		local count = self:Count()
		if index < 1 then
			error("index must be at least 1", 2)
		elseif index > count+1 then
			error("index must not be greater than the count+1", 2)
		end

		sequence = Enumerable.From(sequence):MemoizeAll()

		local is_wrapped = not counts[self]
		if is_wrapped then
			sequence = sequence:WhereNotNil()
		end

		local sequence_count = sequence:Count()
		if sequence_count == 0 then
			return
		end

		local contract = contracts[self]
		if contract then
			sequence:ForEach(function(item, i)
				if not contract(item) then
					error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
				end
			end)
		end

		local table = tables[self]
		count = count + sequence_count
		if not is_wrapped then
			counts[self] = count
		end
		for i = count, index + sequence_count, -1 do
			table[i] = table[i - sequence_count]
		end
		sequence:ForEach(function(item, i)
			table[index + i - 1] = item
		end)
	end

	local function remove_nils(...)
		if table.getn(arg) == 0 then
			return
		end

		if (arg[1]) == nil then
			return remove_nils(select(2, ...))
		end

		return (...), remove_nils(select(2, ...))
	end

	local function insert_many_helper(self, index, count, is_wrapped, ...)
		local sequence_count = table.getn(arg)
		if sequence_count == 0 then
			return
		end

		local contract = contracts[self]
		if contract then
			for i = 1, sequence_count do
				local item = (arg[i])
				if not contract(item) then
					error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
				end
			end
		end

		local table = tables[self]
		count = count + sequence_count
		if not is_wrapped then
			counts[self] = count
		end
		for i = count, index + sequence_count, -1 do
			table[i] = table[i - sequence_count]
		end
		for i = 1, sequence_count do
			local item = (arg[i])
			table[index + i - 1] = item
		end
	end

	--- Insert multiple arguments into a position in the list.
	-- @param index the position of the sequence. Cannot be less than 1 or greater than count+1
	-- @param ... zero or more arguments to add
	-- @usage list:InsertMany(1, "hey", "there")
	-- @usage list:InsertMany(1, 1, 2, 3, 4, 5)
	function List.prototype:InsertMany(index, ...)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if readonlys[self] then
			error("Cannot insert elements on a read-only List", 2)
		end
		
		local count = self:Count()
		if index < 1 then
			error("index must be at least 1", 2)
		elseif index > count+1 then
			error("index must not be greater than the count+1", 2)
		end

		local is_wrapped = not counts[self]
		if is_wrapped then
			return insert_many_helper(self, index, count, is_wrapped, remove_nils(...))
		else
			return insert_many_helper(self, index, count, is_wrapped, ...)
		end
	end

	--- Remove a given item from the list
	-- @param item the item to remove
	-- @return whether the item was successfully removed
	-- @usage local removed = list:Remove(5)
	function List.prototype:Remove(item)
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end

		local table = tables[self]
		for i = 1, self:Count() do
			if table[i] == item then
				self:RemoveAt(i)
				return true
			end
		end
		return false
	end

	--- Remove an item from the list at the given index.
	-- @param index the 1-based index to remove
	-- @usage list:RemoveAt(1)
	function List.prototype:RemoveAt(index)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end

		local count = self:Count()
		if index < 1 or index > count or math_floor(index) ~= index then
			error("index must be at least 1, no greater than the count, and an integer", 2)
		end

		count = count - 1
		if counts[self] then
			counts[self] = count
		end
		local table = tables[self]
		for i = index, count do
			table[i] = table[i + 1]
		end
		table[count + 1] = nil
	end

	--- Remove all elements which match a given predicate
	-- @param predicate a function which is passed each element and should return true to remove, false to keep
	-- @return the number of elements removed
	-- @usage local num = list:RemoveWhere(function(x) return x % 2 == 0 end)
	function List.prototype:RemoveWhere(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string')

		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end

		predicate = convertFunction(predicate)

		local i = 0
		local table = tables[self]
		local num = 0
		local count = self:Count()
		while i < count do
			i = i + 1
			local item = table[i]
			if predicate(item) then
				self:RemoveAt(i)
				i = i - 1
				num = num + 1
				count = count - 1
			end
		end
		return num
	end

	--- Remove multiple elements from the List
	-- @param index the starting 1-based index to remove
	-- @param count the amount of elements to remove
	function List.prototype:RemoveRange(index, count)
		check(1, self, 'userdata')
		check(2, index, 'number')
		check(3, count, 'number')

		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end
		
		local total_count = self:Count()

		if index < 1 or index > total_count or math_floor(index) ~= index then
			error("index must be at least 1, no greater than the count, and an integer", 2)
		elseif count < 0 or math_floor(count) ~= count then
			error("count must be at least 0 and an integer", 2)
		elseif count == 0 then
			-- nothing to do
			return
		elseif index + count > total_count then
			error("index + count must not be greater than the total count of the list", 2)
		end
		
		local result_count = total_count - count
		if counts[self] then
			counts[self] = result_count
		end
		local table = tables[self]
		for i = index, result_count do
			table[i] = table[i + count]
		end
		for i = 1, count do
			table[result_count + i] = nil
		end
	end
	
	--- Replace an element at the given index.
	-- @param index the 1-based index to replace. Must be at least 1 and no greater than the count+1
	-- @param item the item to add
	-- @usage List.New({ 1, 2 }):ReplaceAt(1, 3) -- [3, 2]
	-- @usage List.New({ 1, 2 }):ReplaceAt(3, 2) -- [1, 2, 3]
	function List.prototype:ReplaceAt(index, item)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if readonlys[self] then
			error("Cannot replace elements in a read-only List", 2)
		end

		local count = self:Count()
		if index < 1 or index > count+1 or math_floor(index) ~= index then
			error("index must be at least 1, no greater than the count+1, and an integer", 2)
		end

		if index > count then
			return self:Add(item)
		end
		
		local contract = contracts[self]
		if contract and not contract(item) then
			error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
		end

		local is_wrapped = not counts[self]
		if is_wrapped and item == nil then
			return self:RemoveAt(index)
		end

		local table = tables[self]
		table[index] = item
	end
	
	--- Replace a sequence of elements at the given index.
	-- @param index the 1-based index to replace. Must be at least 1 and no greater than the count+1
	-- @param sequence the sequence to add
	-- @usage List.New({ 1, 2 }):ReplaceRange(1, { 3, 4 }) -- [3, 4]
	-- @usage List.New({ 1, 2 }):ReplaceRange(2, { 3, 4 }) -- [1, 3, 4]
	-- @usage List.New({ 1, 2 }):ReplaceRange(3, { 3, 4 }) -- [1, 2, 3, 4]
	function List.prototype:ReplaceRange(index, sequence)
		check(1, self, 'userdata')
		check(2, index, 'number')
		check(3, sequence, 'userdata', 'table')

		if readonlys[self] then
			error("Cannot replace elements in a read-only List", 2)
		end

		sequence = Enumerable.From(sequence)

		local count = self:Count()
		if index < 1 or index > count+1 or math_floor(index) ~= index then
			error("index must be at least 1, no greater than the count+1, and an integer", 2)
		end

		if index > count then
			return self:AddRange(sequence)
		end
		
		local contract = contracts[self]
		local is_wrapped = not counts[self]
		local table = tables[self]
		sequence:ForEach(function(item)
			if contract and not contract(item) then
				error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
			end

			if is_wrapped and item == nil then
				return
			end

			table[index] = item
			if not is_wrapped and index > counts[self] then
				counts[self] = index
			end
			index = index + 1
		end)
	end

	--- Replace a sequence of elements at the given index.
	-- @param index the 1-based index to replace. Must be at least 1 and no greater than the count+1
	-- @param ... zero or more arguments to add
	-- @usage List.New({ 1, 2 }):ReplaceMany(1, 3, 4) -- [3, 4]
	-- @usage List.New({ 1, 2 }):ReplaceMany(2, 3, 4) -- [1, 3, 4]
	-- @usage List.New({ 1, 2 }):ReplaceMany(3, 3, 4) -- [1, 2, 3, 4]
	function List.prototype:ReplaceMany(index, ...)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if readonlys[self] then
			error("Cannot replace elements in a read-only List", 2)
		end

		local count = self:Count()
		if index < 1 or index > count+1 or math_floor(index) ~= index then
			error("index must be at least 1, no greater than the count+1, and an integer", 2)
		end

		if index > count then
			return self:AddMany(...)
		end
		
		local contract = contracts[self]
		local is_wrapped = not counts[self]
		local table = tables[self]
		for i = 1, table.getn(arg) do
			local item = (arg[i])
			if contract and not contract(item) then
				error(("Element %s does not meet the contract for this List."):format(tostring_q(item)), 2)
			end

			if is_wrapped and item == nil then
				return
			end

			table[index] = item
			if not is_wrapped and index > counts[self] then
				counts[self] = index
			end
			index = index + 1
		end
	end

	--- Clear all elements from the List
	-- @usage list:Clear()
	function List.prototype:Clear()
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end

		wipe(tables[self])
		if counts[self] then
			counts[self] = 0
		end
	end

	--- Make a shallow clone of the List.
	-- If the previous List was read-only, the clone will not be.
	-- @usage local other = list:Clone()
	function List.prototype:Clone()
		check(1, self, 'userdata')

		local other = List.New()
		local contract = contracts[self]
		if contract then
			other:SetContract(contracts[self])
		end
		other:AddRange(self)

		return other
	end
	
	--- Reverse the current List in-place, thus changing the contents of the list.
	-- @usage list:ReverseInPlace()
	function List.prototype:ReverseInPlace()
		check(1, self, 'userdata')

		if readonlys[self] then
			error("Cannot alter elements in a read-only List", 2)
		end

		local count = self:Count()
		local table = tables[self]
		for i = 1, count / 2 do
			local j = count - i + 1
			table[i], table[j] = table[j], table[i]
		end
	end

	--- Randomizes the elements of the List in-place, thus changes the contents of the list.
	-- @usage list:ShuffleInPlace()
	function Enumerable.prototype:ShuffleInPlace()
		check(1, self, 'userdata')
	
		if readonlys[self] then
			error("Cannot alter elements in a read-only List", 2)
		end
		
		local count = self:Count()
		local table = tables[self]

		for index = count, 1, -1 do
			local swapping_index = math_random(index)
			if swapping_index ~= index then
				table[index], table[swapping_index] = table[swapping_index], table[index]
			end
		end
	end

	do
		local NIL = newproxy()
		--- Sort the current List in-place based on the given comparison.
		-- @param comparer a function which takes two elements and returns -1 if the first is less than the second, 1 for the opposite, and 0 if equivalent.
		-- @usage list:Sort(function(a, b) if #a < #b then return -1 elseif #a > #b then return 1 elseif a < b then return -1 elseif a > b then return 1 else return 0 end end)
		function List.prototype:Sort(comparer)
			check(1, self, 'userdata')
			check(2, comparer, 'function', 'nil')
			
			if readonlys[self] then
				error("Cannot alter elements in a read-only List", 2)
			end

			local count = self:Count()
			local table = tables[self]

			if not comparer then
				comparer = self:OrderBy(""):GetComparer()
			end

			local found_nil = false
			
			local indexes = {}

			for i = count, 1, -1 do
				if table[i] == nil then
					table[i] = NIL
					found_nil = true
				end
				indexes[table[i]] = i
			end

			table_sort(table, function(alpha, bravo)
				if rawequal(alpha, bravo) then
					return false
				end

				local value = comparer(alpha, bravo)
				if value == 0 then
					return indexes[alpha] < indexes[bravo]
				else
					return value < 0
				end
			end)

			if found_nil then
				for i = 1, count do
					if table[i] == NIL then
						table[i] = nil
					end
				end
			end
		end
	end

	--- Randomly pick a random element in the List, remove it, and return the value.
	-- This will error if the List is empty.
	-- @return a random value in the List
	-- @usage local value = list:PickAndRemoveRandom()
	function List.prototype:PickAndRemoveRandom()
		check(1, self, 'userdata')
		
		if readonlys[self] then
			error("Cannot remove elements from a read-only List", 2)
		end

		local count = self:Count()
		if count == 0 then
			error("Cannot remove from an empty List", 2)
		end

		local index = math_random(count)
		local value = tables[self][index]
		self:RemoveAt(index)
		return value
	end
	
	-- Methods that are faster than using the standard Enumerable ones:
	
	function List.prototype:Any(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return self:Count() > 0
		else
			return Enumerable.prototype.Any(self, predicate)
		end
	end

	function List.prototype:Count(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			return counts[self] or #tables[self]
		else
			return Enumerable.prototype.Count(self, predicate)
		end
	end
	
	function List.prototype:ElementAt(index)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 then
			error("index must be at least 1", 2)
		elseif math_floor(index) ~= index then
			error("index must be an integer", 2)
		elseif index > self:Count() then
			error("index is greater than the amount of elements in the source", 2)
		end

		return tables[self][index]
	end
	
	function List.prototype:ElementAtOrDefault(index, default)
		check(1, self, 'userdata')
		check(2, index, 'number')

		if index < 1 or math_floor(index) ~= index or index > self:Count() then
			return default
		else
			return tables[self][index]
		end
	end
	
	function List.prototype:First(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			if self:Count() < 1 then
				error("First:no elements in the list", 2)
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.First(self, predicate)
		end
	end
	
	function List.prototype:FirstOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			if self:Count() < 1 then
				return default
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.FirstOrDefault(self, default, predicate)
		end
	end
	
	function List.prototype:Last(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				error("Last:no elements in the list", 2)
			else
				return tables[self][count]
			end
		else
			return Enumerable.prototype.Last(self, predicate)
		end
	end
	
	function List.prototype:LastOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				return default
			else
				return tables[self][count]
			end
		else
			return Enumerable.prototype.LastOrDefault(self, default, predicate)
		end
	end
	
	function List.prototype:Single(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				error("Single:no elements in the list", 2)
			elseif count > 1 then
				error("Single:more than 1 element in the list", 2)
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.Single(self, predicate)
		end
	end
	
	function List.prototype:SingleOrDefault(default, predicate)
		check(1, self, 'userdata')
		check(3, predicate, 'function', 'string', 'nil')

		if not predicate then
			local count = self:Count()
			if count < 1 then
				return default
			elseif count > 1 then
				error("SingleOrDefault:more than 1 element in the list", 2)
			else
				return tables[self][1]
			end
		else
			return Enumerable.prototype.SingleOrDefault(self, default, predicate)
		end
	end
	
	function List.prototype:Skip(count)
		check(1, self, 'userdata')
		check(2, count, 'number')

		if count <= 0 then
			return self
		end

		return Enumerable.New(function()
			local index = math_floor(count)
			local table = tables[self]

			return Enumerator.New(
				nil,
				function(yield)
					index = index + 1
					while index <= self:Count() do
						return yield(table[index])
					end
					return false
				end,
				nil)
		end)
	end

	function List.prototype:TakeExceptLast(count)
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

			return Enumerator.New(
				function()
					enumerator = self:Take(self:Count() - count):GetEnumerator()
				end, function(yield)
					return enumerator:MoveNext() and yield(enumerator:Current())
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	function List.prototype:TakeFromLast(count)
		check(1, self, 'userdata')
		check(2, count, 'number', 'nil')

		if not count then
			count = 1
		end

		if count <= 0 then
			return Enumerable.Empty()
		end

		return Enumerable.New(function()
			local enumerator

			return Enumerator.New(
				function()
					enumerator = self:Skip(self:Count() - count):GetEnumerator()
				end, function(yield)
					return enumerator:MoveNext() and yield(enumerator:Current())
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end
	
	function List.prototype:Reverse()
		check(1, self, 'userdata')

		return Enumerable.New(function()
			local index

			return Enumerator.New(
				function()
					index = self:Count() + 1
				end,
				function(yield)
					index = index - 1
					if index < 1 then
						return false
					else
						return yield(tables[self][index])
					end
				end,
				nil)
		end)
	end

	function List.prototype:SequenceEqual(second, compare_selector)
		check(1, self, 'userdata')
		check(2, second, 'userdata', 'table')
		check(3, compare_selector, 'function', 'string', 'nil')

		second = Enumerable.From(second)
		if tables[second] and self:Count() ~= second:Count() then
			return false
		end
		
		return Enumerable.prototype.SequenceEqual(self, second, compare_selector)
	end
	
	function List.prototype:Force()
	end
	
	function List.prototype:MemoizeAll()
		return self
	end

	function List.prototype:ToString()
		check(1, self, 'userdata')

		return "List" .. Enumerable.prototype.ToString(self)
	end

	function List.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = convertFunction(action)

		local table = tables[self]
		local index = 0
		while true do
			index = index + 1
			if index > self:Count() then
				break
			end

			if action(table[index], index) == false then
				break
			end
		end
	end
	
	local function iterator(self, index)
		index = index + 1

		if index > self:Count() then
			return nil
		end

		return index, tables[self][index]
	end
	function List.prototype:Iterate()
		return iterator, self, 0
	end

	function List.prototype:PickRandom()
		check(1, self, 'userdata')

		local count = self:Count()
		if count == 0 then
			error("PickRandom:No elements in the Enumerable.", 2)
		end
		return tables[self][math_random(count)]
	end
	
	function List.prototype:PickRandomOrDefault(default)
		check(1, self, 'userdata')
		
		local count = self:Count()
		if count == 0 then
			return default
		else
			return tables[self][math_random(count)]
		end
	end

	--- Make a new List filled with the contents of the current Enumerable
	-- @return a List
	function Enumerable.prototype:ToList()
		check(1, self, 'userdata')

		return List.New(self)
	end
end)