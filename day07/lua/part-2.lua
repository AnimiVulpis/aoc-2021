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
    local distance = math.abs(input - target)
    return (distance ^ 2 + distance) / 2
end

local function getDistribution(input)
    local count = {}
    for _, value in pairs(input) do
        if count[value] == nil then
            count[value] = 1
        else
            count[value] = count[value] + 1
        end
    end
    local result = {}
    for index = 0, input[#input] do
        if count[index] ~= nil then
            result[index] = count[index]
        else
            result[index] = 0
        end
    end
    return result
end

local function fuelCosts(input, needle)
    local fuelCost = {}
    local currentNeedle = needle
    while true do
        if fuelCost[currentNeedle] ~= nil then return fuelCost end
        local leftSum = 0
        local rightSum = 0
        for index = 0, #input do
            if index < currentNeedle then
                leftSum = leftSum +
                              (calculateFuel(index, currentNeedle) *
                                  input[index])
            elseif index > currentNeedle then
                rightSum = rightSum +
                               (calculateFuel(index, currentNeedle) *
                                   input[index])
            end
        end
        fuelCost[currentNeedle] = leftSum + rightSum
        if leftSum < rightSum then
            currentNeedle = currentNeedle + 1
        elseif leftSum > rightSum then
            currentNeedle = currentNeedle - 1
        end
    end
end

-- solve task
local function solveTask(fileIterator)
    local crabs = getCrabs(fileIterator())

    table.sort(crabs)

    local distribution = getDistribution(crabs)
    local fuelCosts = fuelCosts(distribution, getMedian(crabs))

    local minFuelCost = nil
    for index, value in pairs(fuelCosts) do
        if minFuelCost == nil then
            minFuelCost = value
        elseif value < minFuelCost then
            minFuelCost = value
        end
    end

    return minFuelCost
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
