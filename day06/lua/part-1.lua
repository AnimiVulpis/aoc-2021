local savedResults = {}

local function solveSingleFish(timer, limit)
    if limit <= timer then return 1 end
    local newLimit = limit - timer
    return solveSingleFish(7, newLimit) + solveSingleFish(9, newLimit)
end

local function getFishes(line)
    local result = {}
    local lastChar = string.len(line)
    local currentIndex = 1
    while true do
        if currentIndex > lastChar then break end
        local currentNumber = tonumber(string.sub(line, currentIndex,
                                                  currentIndex))
        table.insert(result, currentNumber)
        currentIndex = currentIndex + 2
    end
    return result
end

-- solve task
local function solveTask(fileIterator)
    local fishes = getFishes(fileIterator())

    local fishCount = 0

    for _, fish in pairs(fishes) do
        fishCount = fishCount + solveSingleFish(fish, 80)
    end

    -- for index, data in pairs(fishes) do print(index, data, type(data)) end
    return fishCount
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
