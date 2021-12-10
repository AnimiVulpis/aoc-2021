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

local function collectLowPoints(heightTable)
    local lowPoints = {}
    for y = 1, #heightTable do
        for x = 1, #heightTable[y] do
            if lowerThanArea(heightTable[y][x], getArea(heightTable, x, y)) ==
                true then table.insert(lowPoints, {x = x, y = y}) end
        end
    end
    return lowPoints
end

local function getCandidates(posList)
    local candidates = {}
    for _, pos in pairs(posList) do
        table.insert(candidates, {pos[1] + 1, pos[2]})
        table.insert(candidates, {pos[1] - 1, pos[2]})
        table.insert(candidates, {pos[1], pos[2] + 1})
        table.insert(candidates, {pos[1], pos[2] - 1})
    end
    return candidates
end

local function maxGrow(heights, pos)
    local size = 1
    local basin = {}
    basin[pos.x] = {}
    basin[pos.x][pos.y] = true

    local sizeChange = nil
    local candidatesToGrow = getCandidates({{pos.x, pos.y}})
    while true do
        local newPos = {}
        sizeChange = 0
        for _, can in pairs(candidatesToGrow) do
            if (basin[can[1]] == nil or basin[can[1]][can[2]] ~= true) and
                heights[can[2]] ~= nil and heights[can[2]][can[1]] ~= nil and
                heights[can[2]][can[1]] < 9 then
                sizeChange = sizeChange + 1
                size = size + 1
                table.insert(newPos, {can[1], can[2]})
                if basin[can[1]] == nil then basin[can[1]] = {} end
                basin[can[1]][can[2]] = true
            end
        end
        if sizeChange == 0 then break end
        candidatesToGrow = getCandidates(newPos)
    end
    return size
end

local function sizeBasins(heights, lows)
    local basins = {}
    for index, low in pairs(lows) do basins[index] = maxGrow(heights, low) end
    return basins
end

-- solve task
local function solveTask(fileIterator)
    local heightTable = parseFile(fileIterator)
    local lowPoints = collectLowPoints(heightTable)
    local basinSizeList = sizeBasins(heightTable, lowPoints)
    table.sort(basinSizeList)
    return basinSizeList[#basinSizeList] * basinSizeList[#basinSizeList - 1] *
               basinSizeList[#basinSizeList - 2]
end

print('-----------------------------------------------')
print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
