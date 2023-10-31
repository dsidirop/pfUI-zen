_G.LibLinq_1_0_Loader(function(LibLinq)
	local _G = _G
	local assert = _G.assert

	local check = assert(LibLinq.Utilities.check)
	local safe_dispose = assert(LibLinq.Utilities.safe_dispose)
	local ConvertFunction = assert(LibLinq.Utilities.ConvertFunction)

	local Enumerable = assert(LibLinq.Enumerable)
	local Enumerator = assert(LibLinq.Enumerator)

	--- Bind the enumerable to a parameter so that it can be used multiple times
	-- @param func a function to act on the enumerable with that should return another sequence
	-- @return an Enumerable
	-- @usage Enumerable.From({ 1, 2, 3 }):Let(function(x) return x:Zip(x:Skip(1), function(a, b) return a..':'..b end) end):ToString() == '["1:2", "2:3"]'
	function Enumerable.prototype:Let(func)
		check(1, self, 'userdata')
		check(2, func, 'function', 'string')

		func = ConvertFunction(func)

		return Enumerable.New(function()
			local enumerator

			return Enumerator.New(
				function()
					enumerator = Enumerable.From(func(self)):GetEnumerator()
				end, function(yield)
					if enumerator:MoveNext() then
						return yield(enumerator:Current())
					else
						return false
					end
				end, function()
					safe_dispose(enumerator)
				end)
		end)
	end

	--- Creates an enumerable that iterates over the original enumerable only once and caches the results.
	-- Subclasses which represent concrete types will typically override this to return the same object.
	-- @return an Enumerable.
	-- @usage Enumerable.From({ 1, 2, 3 }):Select(function(x) sleep(1000) return x end):MemoizeAll()
	function Enumerable.prototype:MemoizeAll()
		check(1, self, 'userdata')
	
		local cache
		local cache_len
		local enumerator
		local is_done = false

		return Enumerable.New(function()
			local index = 0

			return Enumerator.New(
				function()
					if not is_done and not enumerator then
						enumerator = self:GetEnumerator()
						cache = {}
						cache_len = 0
					end
				end, function(yield)
					index = index + 1
					if cache_len < index then
						if not is_done and enumerator:MoveNext() then
							local current = enumerator:Current()
							cache_len = cache_len + 1
							cache[cache_len] = current
							return yield(current)
						else
							return false
						end
					end

					return yield(cache[index])
				end, function()
					is_done = true
					enumerator = safe_dispose(enumerator)
				end)
		end)
	end

end)