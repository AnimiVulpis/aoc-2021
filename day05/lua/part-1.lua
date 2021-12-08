-- helper to display table
local function printTable(input)
    for index, data in pairs(input) do
        print(index)
        for key, value in pairs(data) do print('\t', key, value) end
    end
end

-- parse single input line
local function parseLine(line)
    local _, _, x1, y1, x2, y2 = string.find(line,
                                             '(%d+),(%d+) [-]> (%d+),(%d+)$')
    x1 = tonumber(x1)
    x2 = tonumber(x2)
    y1 = tonumber(y1)
    y2 = tonumber(y2)

    if x1 == x2 or y1 == y2 then
        return {x1 = x1, y1 = y1, x2 = x2, y2 = y2}
    else
        return nil
    end
end

-- parse input lines
local function parseInput(iterator)
    local result = {}
    while true do
        local currentLine = iterator()
        if currentLine == nil then return result end
        local parsedLine = parseLine(currentLine)
        if parsedLine ~= nil then table.insert(result, parsedLine) end
    end
end

local function countOverlaps(input)
    local result = 0
    for x, _ in pairs(input) do
        for y, _ in pairs(input[x]) do
            if input[x][y] > 1 then result = result + 1 end
        end
    end
    return result
end

-- solve task
local function solveTask(fileIterator)
    local inputTable = parseInput(fileIterator)

    local counter = {}
    for _, line in ipairs(inputTable) do
        local x1 = math.min(line.x1, line.x2)
        local x2 = math.max(line.x1, line.x2)
        for x = x1, x2 do
            local y1 = math.min(line.y1, line.y2)
            local y2 = math.max(line.y1, line.y2)
            for y = y1, y2 do
                if counter[x] == nil then counter[x] = {} end
                if counter[x][y] == nil then counter[x][y] = 0 end
                counter[x][y] = counter[x][y] + 1
            end
        end
    end

    local overlapPoints = countOverlaps(counter)
    return overlapPoints
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
