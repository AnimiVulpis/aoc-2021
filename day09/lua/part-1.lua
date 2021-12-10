local function calculateRisk(points)
    local sum = 0
    for _, height in pairs(points) do sum = sum + height + 1 end
    return sum
end

local function parseFile(iterator)
    local heights = {}
    local currentIndex = 1
    while true do
        local currentLine = iterator()
        if currentLine == nil then break end

        heights[currentIndex] = {}
        for x = 1, string.len(currentLine) do
            table.insert(heights[currentIndex],
                         tonumber(string.sub(currentLine, x, x)))
        end

        currentIndex = currentIndex + 1
    end
    return heights
end

local function getArea(grid, x, y)
    local area = {}

    local left = grid[y][x - 1] ~= nil
    local right = grid[y][x + 1] ~= nil
    local top = grid[y - 1] ~= nil
    local bottom = grid[y + 1] ~= nil

    if left then table.insert(area, grid[y][x - 1]) end
    if right then table.insert(area, grid[y][x + 1]) end
    if top then table.insert(area, grid[y - 1][x]) end
    if bottom then table.insert(area, grid[y + 1][x]) end

    return area
end

local function lowerThanArea(value, area)
    if #area == 4 then
        return
            value < area[1] and value < area[2] and value < area[3] and value <
                area[4]
    elseif #area == 3 then
        return value < area[1] and value < area[2] and value < area[3]
    elseif #area == 2 then
        return value < area[1] and value < area[2]
    else
        print('ERROR')
        return nil
    end
end

local function collectLowPoints(iterator)
    local heightTable = parseFile(iterator)
    local lowPoints = {}
    for y = 1, #heightTable do
        for x = 1, #heightTable[y] do
            if lowerThanArea(heightTable[y][x], getArea(heightTable, x, y)) ==
                true then table.insert(lowPoints, heightTable[y][x]) end
        end
    end
    return lowPoints
end

-- solve task
local function solveTask(fileIterator)
    local lowPoints = collectLowPoints(fileIterator)
    return calculateRisk(lowPoints)
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
