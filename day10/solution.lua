local errorValues = {[')'] = 3, [']'] = 57, ['}'] = 1197, ['>'] = 25137}
local completionValues = {['('] = 1, ['['] = 2, ['{'] = 3, ['<'] = 4}

local function findError(line)
    local error = nil
    local stack = {}
    for index = 1, string.len(line) do
        local stackTop = stack[#stack]
        local char = string.sub(line, index, index)
        if char == '(' or char == '[' or char == '{' or char == '<' then
            table.insert(stack, char)
        elseif (char == ')' and stackTop == '(') or
            (char == ']' and stackTop == '[') or
            (char == '}' and stackTop == '{') or
            (char == '>' and stackTop == '<') then
            table.remove(stack, #stack)
        else
            error = char
            break
        end
    end
    return error, stack
end

local function scoreCompletion(stack)
    local score = 0
    for index = #stack, 1, -1 do
        local char = stack[index]
        score = (score * 5) + completionValues[char]
    end
    return score
end

local function solveTask2(fileIterator)
    local stacks = {}
    while true do
        local line = fileIterator()
        if line == nil then break end
        local error, stack = findError(line)
        if error == nil then table.insert(stacks, stack) end
    end

    local completionScores = {}
    for _, stack in pairs(stacks) do
        table.insert(completionScores, scoreCompletion(stack))
    end
    table.sort(completionScores)
    return completionScores[math.ceil(#completionScores / 2)]
end

local function solveTask1(fileIterator)
    local errors = {}
    while true do
        local line = fileIterator()
        if line == nil then break end
        local error = findError(line)
        if error ~= nil then table.insert(errors, error) end
    end

    local errorValueSum = 0
    for _, error in pairs(errors) do
        errorValueSum = errorValueSum + errorValues[error]
    end
    return errorValueSum
end

print('------- Part 1 --------------------------------')
print('example:', solveTask1(io.lines('./example.txt')))
print('puzzle :', solveTask1(io.lines('./input.txt')))
print('------- Part 2 --------------------------------')
print('example:', solveTask2(io.lines('./example.txt')))
print('puzzle :', solveTask2(io.lines('./input.txt')))
