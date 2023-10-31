_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert
	
	local check = assert(Linquidate.Utilities.check)
	local convert_function = assert(Linquidate.Utilities.convert_function)

	local type = assert(_G.type)

	local Enumerable = assert(Linquidate.Enumerable)

	--- Apply an accumulation function over a sequence
	-- @param seed optional: The initial accumulation seed
	-- @param func The function to be invoked on each element
	-- @param result_selector optional: A function to transform each accumulator value
	-- @return A value
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Aggregate(function(a, b) return a + b end) == 10
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Aggregate(0, function(a, b) return a + b end) == 10
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Aggregate(0, function(a, b) return a + b end, function(v) return v * 2 end) == 20
	-- @usage Enumerable.From({ 1, 2, 3, 4 }):Aggregate("a, b => a * b") == 24
	function Enumerable.prototype:Aggregate(seed, func, result_selector)
		return self:Scan(seed, func, result_selector):Last()
	end

	--- Compute the average of a sequence
	-- @param selector optional: A transform to apply to each element
	-- @return nil if there are no values to average, otherwise a number representing the average
	-- @usage Enumerable.Empty():Average() == nil
	-- @usage Enumerable.From({ 1, 2, 3 }):Average() == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):Average(function(x) return x * 2 end) == 4
	-- @usage Enumerable.From({ 1, 2, 3 }):Average("x => x*2") == 4
	function Enumerable.prototype:Average(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string', 'nil')

		if selector then
			return self:Select(selector):Average()
		end

		local sum
		local count = 0
		self:ForEach(function(value)
			if type(value) == "number" then
				if not sum then
					sum = value
				else
					sum = sum + value
				end
				count = count + 1
			end
		end)

		return sum and (sum / count)
	end

	--- Return the number of elements in the sequence
	-- @param predicate optional: a filter to run on each element
	-- @return the amount of elements that satisfy the predicate, or if that's nil, the number of elements total
	-- @usage Enumerable.Empty():Count() == 0
	-- @usage Enumerable.From({ 1, 2, 3 }):Count() == 3
	-- @usage Enumerable.From({ 1, 2, 3 }):Count(function(x) return x % 2 == 1 end) == 2
	-- @usage Enumerable.From({ 1, 2, 3 }):Count("x => x%2 == 1") == 2
	function Enumerable.prototype:Count(predicate)
		check(1, self, 'userdata')
		check(2, predicate, 'function', 'string', 'nil')

		if predicate then
			return self:Where(predicate):Count()
		end
	
		local count = 0
		self:ForEach(function()
			count = count + 1
		end)
		return count
	end

	--- Return the maximum value in the sequence
	-- @param selector optional: a transform to apply to the sequence
	-- @return a maximum value or nil
	-- @usage Enumerable.From({ 1, 10, 5 }):Max() == 10
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Max() == 'charlie'
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Max(function(x) return x:len() end) == 7
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Max("x => x:len()") == 7
	function Enumerable.prototype:Max(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string', 'nil')

		if selector then
			return self:Select(selector):Max()
		end

		local max
		self:ForEach(function(x)
			if x ~= nil and (max == nil or x > max) then
				max = x
			end
		end)
		return max
	end

	--- Return the minimum value in the sequence
	-- @param selector optional: a transform to apply to the sequence
	-- @return a minimum value or nil
	-- @usage Enumerable.From({ 1, 10, 5 }):Min() == 1
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Min() == 'alpha'
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Min(function(x) return x:len() end) == 5
	-- @usage Enumerable.From({ 'alpha', 'charlie', 'bravo' }):Min("x => x:len()") == 5
	function Enumerable.prototype:Min(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string', 'nil')

		if selector then
			return self:Select(selector):Min()
		end

		local min
		self:ForEach(function(x)
			if x ~= nil and (min == nil or x < min) then
				min = x
			end
		end)
		return min
	end

	--- Return the maximum value in the sequence by the generated key per element
	-- @param key_selector a transform to get the key per element
	-- @return a maximum value or nil
	-- @usage Enumerable.From({ 'apple', 'banana', 'cake' }):MaxBy(string.len) == 'banana'
	-- @usage Enumerable.From({ 'apple', 'banana', 'cake' }):MaxBy("x => x:len()") == 'banana'
	function Enumerable.prototype:MaxBy(key_selector)
		check(1, self, 'userdata')
		check(2, key_selector, 'function', 'string')

		key_selector = convert_function(key_selector)

		local max
		local max_key
		self:ForEach(function(x)
			local x_key = key_selector(x)
			if max_key == nil or (x_key ~= nil and x_key > max_key) then
				max = x
				max_key = x_key
			end
		end)

		return max
	end

	--- Return the minimum value in the sequence by the generated key per element
	-- @param key_selector a transform to get the key per element
	-- @return a minimum value or nil
	-- @usage Enumerable.From({ 'apple', 'banana', 'cake' }):MinBy(string.len) == 'cake'
	-- @usage Enumerable.From({ 'apple', 'banana', 'cake' }):MinBy("x => x:len()") == 'cake'
	function Enumerable.prototype:MinBy(key_selector)
		check(1, self, 'userdata')
		check(2, key_selector, 'function', 'string')

		key_selector = convert_function(key_selector)

		local min
		local min_key
		self:ForEach(function(x)
			local x_key = key_selector(x)
			if min_key == nil or (x_key ~= nil and x_key < min_key) then
				min = x
				min_key = x_key
			end
		end)

		return min
	end

	--- Compute the sum of a sequence
	-- @param selector optional: A transform to apply to each element
	-- @return nil if there are no values to average, otherwise a number representing the average
	-- @usage Enumerable.Empty():Sum() == nil
	-- @usage Enumerable.From({ 1, 2, 3 }):Sum() == 6
	-- @usage Enumerable.From({ 1, 2, 3 }):Sum(function(x) return x * x end) == 14
	-- @usage Enumerable.From({ 1, 2, 3 }):Sum("x => x*x") == 14
	function Enumerable.prototype:Sum(selector)
		check(1, self, 'userdata')
		check(2, selector, 'function', 'string', 'nil')

		if selector then
			return self:Select(selector):Sum()
		end

		local sum
		self:ForEach(function(value)
			if type(value) == "number" then
				if not sum then
					sum = value
				else
					sum = sum + value
				end
			end
		end)

		return sum
	end
end)