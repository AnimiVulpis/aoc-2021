-- solve example
local function solveTask(fileIterator)

    local firstTriple = {}
    local secondTriple = {}

    -- initial triple fill
    firstTriple[1] = tonumber(fileIterator())
    firstTriple[2] = tonumber(fileIterator())
    secondTriple[1] = firstTriple[2]
    firstTriple[3] = tonumber(fileIterator())
    secondTriple[2] = firstTriple[3]
    secondTriple[3] = tonumber(fileIterator())

    local incrementCounter = 0

    while true do
        -- if (secondTriple[1] + secondTriple[2] + secondTriple[3]) >
        --     (firstTriple[1] + firstTriple[2] + firstTriple[3]) then
        --     incrementCounter = incrementCounter + 1
        -- end
        if firstTriple[1] < secondTriple[3] then
            incrementCounter = incrementCounter + 1
        end
        -- adjust triples
        firstTriple[1] = firstTriple[2]
        firstTriple[2] = firstTriple[3]
        firstTriple[3] = secondTriple[3]
        secondTriple[1] = secondTriple[2]
        secondTriple[2] = secondTriple[3]
        local nextValue = fileIterator()
        if nextValue == nil then break end
        nextValue = tonumber(nextValue)

        secondTriple[3] = nextValue
        -- print(firstTriple[1], firstTriple[2], firstTriple[3])
        -- print(secondTriple[1], secondTriple[2], secondTriple[3])
    end

    return incrementCounter
end

print('Example solution:', solveTask(io.lines('./example.txt')))

print('Solution:', solveTask(io.lines('./input.txt')))
