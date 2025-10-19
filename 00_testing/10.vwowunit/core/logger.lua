local VWoWUnit, _wowDefaultChatFrame, ELogLevels, _assert, _type, _print, _tostring, _setfenv, _setmetatable = (function()
	local _g = assert(_G or getfenv(0))
	local _assert = assert
	local _setfenv = _assert(_g.setfenv)
	_setfenv(1, {})

	_g.VWoWUnit = _g.VWoWUnit or {}
	local _ELogLevels = _assert(_g.VWoWUnit.ELogLevels)

	local _type = _assert(_g.type)
	local _print = _assert(_g.print)
    local _tostring = _assert(_g.tostring)
	local _setmetatable = _assert(_g.setmetatable)
    local _wowDefaultChatFrame = _g.DEFAULT_CHAT_FRAME -- dont assert this   it can be null
    
	return _g.VWoWUnit, _wowDefaultChatFrame, _ELogLevels, _assert, _type, _print, _tostring, _setfenv, _setmetatable
end)()

_setfenv(1, {})

local Logger = {} --       local to this file only and instantiated only once at the bottom of this file
Logger.__index = Logger -- standard class-proto scaffolding

function Logger:New(optionalLogLevel)
	_setfenv(1, self)

    local instance = {
		_options = {
			minLogLevel = optionalLogLevel or ELogLevels.Info, -- by default will print success and failure messages of tests
		},

        _properPrintFunc = _type(_wowDefaultChatFrame) == "table" and _type(_wowDefaultChatFrame.AddMessage) == "function" -- @formatter:off
                and (function(message) return _wowDefaultChatFrame:AddMessage(message) end)  --                                    if we are in wow client use the chat frame to print messages
                or _print, -- failsafe                                                                                        @formatter:on
	}

	_setmetatable(instance, self)

	return instance
end

--[[ Options ]]--

function Logger:ChainSetOption_MinLogLevel(newMinLogLevel)
	_setfenv(1, self)

	_assert(_type(newMinLogLevel) == "number", "loglevel must be a number")
	_assert(newMinLogLevel >= ELogLevels.Trace and newMinLogLevel <= ELogLevels.Fatal, "loglevel must be within the [ELogLevels.Trace, ELogLevels.Fatal]")

	_options.minLogLevel = newMinLogLevel
	
	return self
end

--[[ Printers ]]--

function Logger:Log(message, atLevel)
	_setfenv(1, self)
	
	_assert(_type(atLevel) == "number", "level must be a number")
	
	if atLevel < _options.minLogLevel then
		return
	end

    self:Print_(_tostring(message))
end

function Logger:LogTrace(message)
	_setfenv(1, self)

	if ELogLevels.Trace < _options.minLogLevel then
        return
	end

    self:Print_(_tostring(message))
end

function Logger:LogDebug(message)
	_setfenv(1, self)

	if ELogLevels.Debug < _options.minLogLevel then
		return
	end

    self:Print_(_tostring(message))
end

function Logger:LogInfo(message)
	_setfenv(1, self)
	
	if ELogLevels.Info < _options.minLogLevel then
        return
	end

    self:Print_("|cff00ccff" .. _tostring(message))
end

function Logger:LogWarn(message)
	_setfenv(1, self)

	if ELogLevels.Warn < _options.minLogLevel then
        return
	end

    self:Print_("|cffFFC125" .. _tostring(message))
end

function Logger:LogError(message) -- when tests fail
	_setfenv(1, self)

	if ELogLevels.Error < _options.minLogLevel then
        return
	end

    self:Print_("|cffff0000" .. _tostring(message))
end

function Logger:LogFatal(message)
	_setfenv(1, self)

	if ELogLevels.Fatal < _options.minLogLevel then
		return
	end

    self:Print_("|cffff0000" .. _tostring(message))
end

function Logger:Print_(message)
    _setfenv(1, self)

    _properPrintFunc(message)
end

VWoWUnit.DefaultLogger = Logger:New()
