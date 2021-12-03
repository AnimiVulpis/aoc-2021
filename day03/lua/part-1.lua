-- bitList print helper
local function printBitList(bitList)
    for key, value in pairs(bitList) do io.write(value .. ' ') end
    io.write('\n')
end

local function find_gamma_binary(iterator)
    local lineCount = 0
    local firstLine = iterator()
    lineCount = lineCount + 1

    local numberOfDigits = string.len(firstLine)

    local bitList = {}
    -- initialize bitList with 0
    for i = 1, numberOfDigits do bitList[i] = 0 end

    local currentLine = firstLine

    -- count ones for each bit
    while true do
        for i = 1, numberOfDigits do
            bitList[i] = bitList[i] + string.sub(currentLine, i, i)
        end
        currentLine = iterator()
        if currentLine == nil then break end
        lineCount = lineCount + 1
    end

    for i = 1, numberOfDigits do
        if bitList[i] > lineCount / 2 then
            bitList[i] = 1
        else
            bitList[i] = 0
        end
    end

    return bitList
end

local function compute_epsilon_binary(bitList)
    local length = #bitList

    local epsilon_bitList = {}

    for i = 1, length do
        if bitList[i] == 1 then
            epsilon_bitList[i] = 0
        else
            epsilon_bitList[i] = 1
        end
    end

    return epsilon_bitList
end

local function fromBinaryToDecimal(bitList)
    local bits = ''
    for i = 1, #bitList do bits = bits .. bitList[i] end
    return tonumber(bits, 2)
end

-- solve example
local function solveTask(fileIterator)
    local gamma_rate_binary = find_gamma_binary(fileIterator)
    printBitList(gamma_rate_binary)
    local epsilon_rate_binary = compute_epsilon_binary(gamma_rate_binary)
    printBitList(epsilon_rate_binary)

    local gamma_rate = fromBinaryToDecimal(gamma_rate_binary)
    print(gamma_rate)
    local epsilon_rate = fromBinaryToDecimal(epsilon_rate_binary)
    print(epsilon_rate)

    return gamma_rate * epsilon_rate
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
