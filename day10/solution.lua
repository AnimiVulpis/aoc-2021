local errorValues = {[')'] = 3, [']'] = 57, ['}'] = 1197, ['>'] = 25137}

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
    return error
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

print('----------------------------------------------')
print('example:', solveTask1(io.lines('./example.txt')))
print('puzzle :', solveTask1(io.lines('./input.txt')))
