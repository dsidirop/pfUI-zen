_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert
	
	local check = assert(Linquidate.Utilities.check)
	local safe_dispose = assert(Linquidate.Utilities.safe_dispose)
	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local ConvertFunction = assert(Linquidate.Utilities.ConvertFunction)

	local Enumerable = assert(Linquidate.Enumerable)
	local Enumerator = assert(Linquidate.Enumerator)

	--- Return an enumerable that when looped over, runs an action but returns the current value regardless.
	-- @param action a function to call that has the element and the 1-based index passed in.
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Do(function(x) print(x) end)
	function Enumerable.prototype:Do(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = ConvertFunction(action)

		return Enumerable.New(function()
			local enumerator
			local index = 0

			return Enumerator.New(
				function()
					enumerator = self:GetEnumerator()
				end, function(yield)
					if enumerator:MoveNext() then
						local current = enumerator:Current()
						index = index + 1
						action(current, index)
						return yield(current)
					end
					return false
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Immediately performs an action on each element in the sequence.
	-- If the action returns false, that will act as a break and prevent any more execution on the sequence.
	-- @param action a function that takes the element and the 1-based index of the element.
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):ForEach(print)
	function Enumerable.prototype:ForEach(action)
		check(1, self, 'userdata')
		check(2, action, 'function', 'string')

		action = ConvertFunction(action)

		local index = 0
		local enumerator = self:GetEnumerator()
		tryfinally(function()
			while enumerator:MoveNext() do
				index = index + 1
				if action(enumerator:Current(), index) == false then
					break
				end
			end
		end, function()
			safe_dispose(enumerator)
		end)
	end

	--- Iterate over an enumerable, forcing it to execute
	function Enumerable.prototype:Force()
		local enumerator = self:GetEnumerator()
		tryfinally(function()
			while enumerator:MoveNext() do
				-- nothing
			end
		end, function()
			safe_dispose(enumerator)
		end)
	end
end)