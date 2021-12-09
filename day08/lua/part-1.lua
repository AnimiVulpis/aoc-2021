local function parseInput(file)
    local codes = {}
    local currentLine = nil
    while true do
        currentLine = file()
        if currentLine == nil then break end

        local _, _, a, b, c, d = string.find(currentLine,
                                             '| (%l+) (%l+) (%l+) (%l+)$')
        table.insert(codes, {a, b, c, d})
    end
    return codes
end

local function counting(input)
    local count = 0
    for index = 1, 4 do
        local currentLength = string.len(input[index])
        if currentLength == 2 or currentLength == 3 or currentLength == 4 or
            currentLength == 7 then count = count + 1 end
    end
    return count
end

-- solve task
local function solveTask(fileIterator)
    local numberList = parseInput(fileIterator)
    local count = 0
    for _, numbers in pairs(numberList) do count = count + counting(numbers) end
    return count
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
