-- bitList print helper
local function printBitList(bitList)
    for key, value in pairs(bitList) do io.write(value .. ' ') end
    io.write('\n')
end

-- helper to find most common value
local function mostCommonAtPosition(binaryTable, index)
    local length = #binaryTable
    local count = 0

    for key, line in pairs(binaryTable) do
        count = count + tonumber(string.sub(line, index, index))
    end

    if count < length / 2 then
        return 0
    else
        return 1
    end
end

-- helper fo find least common value
local function leastCommonAtPosition(binaryTable, index)
    local length = #binaryTable
    local count = 0

    for key, line in pairs(binaryTable) do
        count = count + tonumber(string.sub(line, index, index))
    end

    if count < length / 2 then
        return 1
    else
        return 0
    end
end

local function filterTable(binaryTable, filterValue, index)
    if #binaryTable == 1 then return binaryTable end
    local filtered = {}
    for key, line in pairs(binaryTable) do
        if tonumber(string.sub(line, index, index)) == filterValue then
            table.insert(filtered, line)
        end
    end
    return filtered
end

local function find_oxy_gen_rating(binaryTable)
    local bits = string.len(binaryTable[1])
    for i = 1, bits do
        local filterValue = mostCommonAtPosition(binaryTable, i)
        binaryTable = filterTable(binaryTable, filterValue, i)
    end
    return binaryTable
end

local function find_co_scrub_rating(binaryTable)
    local bits = string.len(binaryTable[1])
    for i = 1, bits do
        local filterValue = leastCommonAtPosition(binaryTable, i)
        binaryTable = filterTable(binaryTable, filterValue, i)
    end
    return binaryTable
end

local function fromBinaryToDecimal(bitList)
    local bits = ''
    for i = 1, #bitList do bits = bits .. bitList[i] end
    return tonumber(bits, 2)
end

-- solve task
local function solveTask(fileIterator)
    local numberList = {}
    for line in fileIterator do table.insert(numberList, line) end
    local oxy_gen_list = {table.unpack(numberList)}
    local co_scrub_list = {table.unpack(numberList)}

    local oxy_gen_rating_binary = find_oxy_gen_rating(oxy_gen_list)

    local co_scrub_rating_binary = find_co_scrub_rating(co_scrub_list)

    local gen_rate = fromBinaryToDecimal(oxy_gen_rating_binary)
    print(gen_rate)
    local scrub_rate = fromBinaryToDecimal(co_scrub_rating_binary)
    print(scrub_rate)

    return gen_rate * scrub_rate
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
