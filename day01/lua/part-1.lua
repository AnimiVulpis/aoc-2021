-- solve example
local function solveTask(fileIterator)
    local firstValue = fileIterator()
    if firstValue == nil then return 'not enough values' end
    firstValue = tonumber(firstValue)

    local recentValue = fileIterator()
    if recentValue == nil then return 'not enough values' end
    recentValue = tonumber(recentValue)

    local incrementCounter = 0

    if recentValue > firstValue then incrementCounter = incrementCounter + 1 end

    while true do
        local nextValue = fileIterator()
        if nextValue == nil then break end
        nextValue = tonumber(nextValue)
        if nextValue > recentValue then
            incrementCounter = incrementCounter + 1
        end
        recentValue = nextValue
    end

    return incrementCounter
end

print('Example solution:', solveTask(io.lines('./example.txt')))

print('Solution:', solveTask(io.lines('./input.txt')))
