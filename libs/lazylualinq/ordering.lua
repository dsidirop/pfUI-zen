-- ordering.lua
--
-- Contains functions used in the ordering functions of lazylualinq

function getDefaultComparer()
    return function(a, b)
        if a < b then
            return -1
        elseif a == b then
            return 0
        else
            return 1
        end
    end
end

function getReverseComparer(comparerFunc)
    return function(a, b)
        return comparerFunc(b, a)
    end
end

function getCompositeSelector(primarySelector, secondarySelector)
    return function(element, key)
        return {
            primary = primarySelector(element, key),
            secondary = secondarySelector(element, key)
        }
    end
end

function getCompositeComparer(primaryComparer, secondaryComparer)
    return function(a, b)
        local primaryResult = primaryComparer(a.primary, b.primary)

        if primaryResult ~= 0 then
            return primaryResult
        end

        return secondaryComparer(a.secondary, b.secondary)
    end
end

local function partition(indices, keys, left, right, pivot, comparer)
    local pivotIndex = indices[pivot]
    local pivotKey = keys[pivotIndex]

    indices[pivot] = indices[right]
    indices[right] = pivotIndex
    local storeIndex = left
    for i = left, right do
        local candidateIndex = indices[i]
        local candidateKey = keys[candidateIndex]
        local comparison = comparer(candidateKey, pivotKey)
        if comparison < 0 or (comparison == 0 and candidateIndex < pivotIndex) then
            indices[i] = indices[storeIndex]
            indices[storeIndex] = candidateIndex
            storeIndex = storeIndex + 1
        end
    end

    local tmp = indices[storeIndex]
    indices[storeIndex] = indices[right]
    indices[right] = tmp

    return storeIndex
end

local function quicksort(indices, keys, left, right, comparer)
    if right > left then
        local pivot = math.floor((right + left) / 2)
        local pivotPosition = partition(indices, keys, left, right, pivot, comparer)
        quicksort(indices, keys, left, pivotPosition - 1, comparer)
        quicksort(indices, keys, pivotPosition + 1, right, comparer)
    end
end

function getOrderingFactory()
    return function(me)
        local comparer = me.comparer
        local selector = me.selector

        local array = me.source -- @formatter:off
                :select(function(v, k) return { key = k, value = v } end)
                :toArray() -- @formatter:off

        local indices = {}
        local keys = {}
        for i = 1, table.getn(array) do
            indices[i] = i
            keys[i] = selector(array[i].value, array[i].key)
        end

        quicksort(indices, keys, 1, table.getn(keys), comparer)

        local progress = 0

        return function()
            progress = progress + 1
            local pair = array[indices[progress]]
            if pair ~= nil then
                return pair.value, pair.key
            else
                return nil, nil
            end
        end
    end
end

return {
    getDefaultComparer = getDefaultComparer,
    getReverseComparer = getReverseComparer,
    getOrderingFactory = getOrderingFactory,
    getCompositeComparer = getCompositeComparer,
    getCompositeSelector = getCompositeSelector
}