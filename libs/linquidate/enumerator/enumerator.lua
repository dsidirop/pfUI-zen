_G.Linquidate_Loader(function(Linquidate)
	local _G = _G
	local assert = _G.assert

	local check = assert(Linquidate.Utilities.check)
	local trycatch = assert(Linquidate.Utilities.trycatch)
	local tryfinally = assert(Linquidate.Utilities.tryfinally)
	local tostring_q = assert(Linquidate.Utilities.tostring_q)
	local make_weak_keyed_table = assert(Linquidate.Utilities.make_weak_keyed_table)

	local newproxy = assert(_G.newproxy)
	local getmetatable = assert(_G.getmetatable)

	--- A helper class to make enumerator yielding simpler.
	-- This is internal and not meant to have new instances created outside of the core Linq system.
	local Yielder = { prototype = {} }
	do
		local Yielder_proxy = newproxy(true)
		local Yielder_mt = getmetatable(Yielder_proxy)
		Yielder_mt.__index = Yielder.prototype

		local currents = make_weak_keyed_table()

		--- Return the current value in the yielder.
		-- @return the last yielded value
		function Yielder.prototype:Current()
			return currents[self]
		end

		--- Yield a new value, setting the value in the yielder and returning true.
		-- This can also be accessed by calling the yielder directly.
		-- @param value the value to set the yielder's internal value to
		-- @return true
		function Yielder.prototype:Yield(value)
			currents[self] = value
			return true
		end
		Yielder_mt.__call = Yielder.prototype.Yield

		--- Return a new yielder with no current value
		-- @return a Yielder
		function Yielder.New()
			return newproxy(Yielder_proxy)
		end
	end

	--- A class that supports simple iteration
	local Enumerator = Linquidate.Enumerator or {}
	do
		Linquidate.Enumerator = Enumerator
		Enumerator.prototype = {} -- overwrite the prototype regardless, let old Enumerators live on old code.

		local Enumerator_proxy = newproxy(true)
		local Enumerator_mt = getmetatable(Enumerator_proxy)
		Enumerator_mt.__index = Enumerator.prototype
		function Enumerator_mt:__tostring()
			return self:ToString()
		end

		local State = {
			Before = 0,
			Running = 1,
			After = 2
		}

		local yielders = make_weak_keyed_table()
		local states = make_weak_keyed_table()
		local initializers = make_weak_keyed_table()
		local try_get_nexts = make_weak_keyed_table()
		local disposers = make_weak_keyed_table()

		--- Return the last-yielded value in the Enumerator, or nil if the Enumerator no longer has a yielder.
		-- @return The current value of the Enumerator or nil.
		function Enumerator.prototype:Current()
			local yielder = yielders[self]
			if not yielder then
				-- can occur if disposed
				return nil
			else
				return yielder:Current()
			end
		end

		local move_next_switch; move_next_switch = {
			[State.Before] = function(self)
				states[self] = State.Running
				local initialize = initializers[self]
				initializers[self] = nil
				if initialize then
					initialize()
				end
				yielders[self] = Yielder.New()
				return move_next_switch[State.Running](self)
			end,
			[State.Running] = function(self)
				local yielder = yielders[self]
				local try_get_next = try_get_nexts[self]
				if not yielder or not try_get_next then
					self:Dispose()
					return false
				end
				if try_get_next(yielder) then
					return true
				else
					self:Dispose()
					return false
				end
			end,
			[State.After] = function(self)
				return false
			end
		}
		--- Advances the Enumerator to the next item in the sequence
		-- @return whether the Enumerator successfully advanced, false if passed the end of the sequence.
		function Enumerator.prototype:MoveNext()
			return trycatch(function()
				return move_next_switch[states[self]](self)
			end, function()
				self:Dispose()
				return true
			end)
		end
	
		--- Dispose the enumerator, making it so :MoveNext() always return false, and clear out any memory possible.
		-- This can be called more than once without issue.
		function Enumerator.prototype:Dispose()
			if states[self] ~= State.Running then
				return
			end

			local dispose = disposers[self]
			tryfinally(function()
				if dispose then
					dispose()
				end
			end, function()
				states[self] = State.After
			end)
			yielders[self] = nil
			initializers[self] = nil
			try_get_nexts[self] = nil
			disposers[self] = nil
		end

		--- Construct and return a new Enumerator
		-- @param initialize nil or a function that will be called no more than, before the first iteration.
		-- @param try_get_next a function that will be passed a yielder that should call the yielder or return false and will be called multiple times.
		-- @param dispose nil or a function that will be called once once iteration is complete.
		function Enumerator.New(initialize, try_get_next, dispose)
			check(1, initialize, 'function', 'nil')
			check(2, try_get_next, 'function')
			check(3, dispose, 'function', 'nil')

			local self = newproxy(Enumerator_proxy)

			states[self] = State.Before
			initializers[self] = initialize
			try_get_nexts[self] = try_get_next
			disposers[self] = dispose

			return self
		end
	
		local tostring_switch = {
			[State.Before] = function(self)
				return "Enumerator-State:Before"
			end,
			[State.Running] = function(self)
				return "Enumerator-State:Running-Current:" .. tostring_q(self:Current())
			end,
			[State.After] = function(self)
				return "Enumerator-State:After"
			end
		}
		--- Return a string representation of the Enumerator
		-- @return a string
		function Enumerator.prototype:ToString()
			return tostring_switch[states[self]](self)
		end
	end
end)