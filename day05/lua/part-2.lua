-- helper to display grid
local function printGrid(input)
    for y = 0, 9 do
        for x = 0, 9 do
            if input[x] == nil or input[x][y] == nil then
                io.write('. ')
            else
                io.write(input[x][y] .. ' ')
            end
        end
        io.write('\n')
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
    elseif math.abs(x1 - x2) == math.abs(y1 - y2) then
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
        local x1 = line.x1
        local x2 = line.x2
        local y1 = line.y1
        local y2 = line.y2
        local x = x1
        local y = y1
        while true do
            if counter[x] == nil then counter[x] = {} end
            if counter[x][y] == nil then counter[x][y] = 0 end
            counter[x][y] = counter[x][y] + 1
            if x == x2 and y == y2 then break end
            if x < x2 then
                x = x + 1
            elseif x > x2 then
                x = x - 1
            end
            if y < y2 then
                y = y + 1
            elseif y > y2 then
                y = y - 1
            end
        end
    end

    -- printGrid(counter)
    local overlapPoints = countOverlaps(counter)
    return overlapPoints
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
