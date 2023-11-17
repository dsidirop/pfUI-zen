if strtrim then
    return -- already present in wow-lua
end

function strtrim(input)
    return string.match(input, '^%s*(.*%S)') or ''
end
