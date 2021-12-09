local function getCrabs(line)
    local length = string.len(line)
    local result = {}
    local startIndex = 1
    while true do
        local _, lastMatch, value = string.find(line, '(%d+),?', startIndex)
        table.insert(result, tonumber(value))
        if lastMatch == length then break end
        startIndex = lastMatch
    end
    return result
end

local function getMedian(input)
    if math.fmod(#input, 2) == 0 then
        return (input[#input / 2] + input[(#input / 2) + 1]) / 2
    else
        return input[math.ceil(#input / 2)]
    end
end

local function calculateFuel(input, target)
    local result = 0
    for _, value in ipairs(input) do
        result = result + math.abs(value - target)
    end
    return result
end

-- solve task
local function solveTask(fileIterator)
    local crabs = getCrabs(fileIterator())

    table.sort(crabs)

    local targetPosition = getMedian(crabs)

    local fuelcost = calculateFuel(crabs, targetPosition)

    return fuelcost
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
