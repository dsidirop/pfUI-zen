-- this file should be loaded first ahead of all other addon

_G = _G or getfenv(0)

if not string.format then
    local _format = format -- wow lua 5.1 does have format on the global scope so we can use it here
    if not _format then
        error("global::format not found", 1)
    end

    function string:format(formatString, ...)
        return _format(self, formatString, unpack(arg))
    end
end

if not strmatch then
    local _stringFind = string.find
    function strmatch(input, patternString, ...)
        if patternString == nil then
            error("patternString is nil", 1)
        end

        if patternString == "" then
            -- todo  test out these corner cases
            return nil
        end

        local startIndex, _,
        match01,
        match02,
        match03,
        match04,
        match05,
        match06,
        match07,
        match08,
        match09,
        match10,
        match11,
        match12,
        match13,
        match14,
        match15,
        match16,
        match17,
        match18,
        match19,
        match20,
        match21,
        match22,
        match23,
        match24,
        match25 = _stringFind(input, patternString, unpack(arg))

        if not startIndex then
            return nil
        end
        
        return
        match01,
        match02,
        match03,
        match04,
        match05,
        match06,
        match07,
        match08,
        match09,
        match10,
        match11,
        match12,
        match13,
        match14,
        match15,
        match16,
        match17,
        match18,
        match19,
        match20,
        match21,
        match22,
        match23,
        match24,
        match25
    end
end

if not string.match then
    local _strmatch = strmatch
    function string:match(patternString, ...)
        return _strmatch(self, patternString, unpack(arg))
    end
end
