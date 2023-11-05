if string.match then
    return -- already loaded
end

local _stringFind = string.find
if not _stringFind then
    error("string.find() is not present at the global scope", 1)
end

function string:match(patternString, ...)
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
    match25 = _stringFind(self, patternString, unpack(arg))

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
