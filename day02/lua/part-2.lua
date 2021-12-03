-- defintions
local commandList = {'forward ', 'down ', 'up '}

-- parse lines
local function parseCommand(line)
    local i, currentCommand
    for command in pairs(commandList) do
        currentCommand = commandList[command]
        i = string.find(line, currentCommand)
        if i ~= nil then break end
    end

    if currentCommand == nil then print('unknown command') end

    local currentValue = tonumber(string.sub(line, string.len(currentCommand)))

    if currentCommand == 'forward ' then return currentValue, currentValue, 0 end
    if currentCommand == 'down ' then return 0, 0, currentValue end
    if currentCommand == 'up ' then return 0, 0, -currentValue end
end

-- solve example
local function solveTask(fileIterator)
    local position = 0
    local depth = 0
    local aim = 0

    while true do
        local nextLine = fileIterator()
        if nextLine == nil then break end
        local positionChange, depthChange, aimChange = parseCommand(nextLine)

        position = position + positionChange
        depth = depth + depthChange * aim
        aim = aim + aimChange
        -- print(position + positionChange, depth + depthChange)
    end

    return position, depth, position * depth
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
