local function parseInput(file)
    local codes = {}
    local currentLine = nil
    while true do
        currentLine = file()
        if currentLine == nil then break end

        local _, _, code1, code2, code3, code4, code5, code6, code7, code8,
              code9, code0, ans1, ans2, ans3, ans4 =
            string.find(currentLine,
                        '^(%l+) (%l+) (%l+) (%l+) (%l+) (%l+) (%l+) (%l+) (%l+) (%l+) | (%l+) (%l+) (%l+) (%l+)$')
        table.insert(codes, {
            code1, code2, code3, code4, code5, code6, code7, code8, code9,
            code0, ans1, ans2, ans3, ans4
        })
    end
    return codes
end

--[[
    ..A..
    F...B
    ..G..
    E...C
    ..D..

    0 = 6   2 = 1
    1 = 2   3 = 7
    2 = 5   4 = 4
    3 = 5   5 = 2, 3, 5
    4 = 4   6 = 6, 9, 0
    5 = 5   7 = 8
    6 = 6
    7 = 3
    8 = 7
    9 = 6

    2 => 1
    3 => 7
    4 => 4
    7 => 8

    7 \ 1 => A
    countL(2, 3, 5) -> getL(1) -> removeL(4) => E
                               -> removeL(E) => F
    4 \ 1 \ F => G
    8 \ 1 \ A \ F \ G \ E => D
    countL(6, 9, 0) -> getL(2) -> removeL(E, G) => B
    1 \ B => C

    1 = |2|
    4 = |4|
    7 = |3|
    8 = |7|
    -------
    5 = F
    2 = E
    3 = B && C
    ----------
    6 = E && G
    9 = B && G
    0 = B && E
--]]
local function removeLetters(code, lettersToRemove)
    local remainingLetters = code
    for index = 1, string.len(lettersToRemove) do
        remainingLetters = string.gsub(remainingLetters, string.sub(
                                           lettersToRemove, index, index), '')
    end
    return remainingLetters
end

local function countLetters(codeTable, howOften)
    local letters = {}
    local result = ''
    for _, code in pairs(codeTable) do
        for index = 1, string.len(code) do
            local currentLetter = string.sub(code, index, index)
            if letters[currentLetter] == nil then
                letters[currentLetter] = 1
            else
                letters[currentLetter] = letters[currentLetter] + 1
            end
        end
    end

    for key, value in pairs(letters) do
        if value == howOften then result = result .. key end
    end

    return result
end

local function decode(codes)
    -- Group codes
    local one = nil
    local twoThreeFive = {}
    local four = nil
    local sixNineZero = {}
    local seven = nil
    local eight = nil
    for index = 1, 10 do
        local length = string.len(codes[index])
        if length == 2 then
            one = codes[index]
        elseif length == 3 then
            seven = codes[index]
        elseif length == 4 then
            four = codes[index]
        elseif length == 7 then
            eight = codes[index]
        elseif length == 5 then
            table.insert(twoThreeFive, codes[index])
        elseif length == 6 then
            table.insert(sixNineZero, codes[index])
        end
    end

    -- find code letters
    local code = {A = nil, B = nil, C = nil, D = nil, E = nil, F = nil, G = nil}
    -- find A
    code.A = removeLetters(seven, one)
    -- find E, F
    local EorF = countLetters(twoThreeFive, 1)
    code.E = removeLetters(EorF, four)
    code.F = removeLetters(EorF, code.E)
    -- find G
    code.G = removeLetters(four, one .. code.F)
    -- find D
    code.D = removeLetters(eight, one .. code.A .. code.F .. code.G .. code.E)
    -- find B
    code.B = removeLetters(countLetters(sixNineZero, 2), code.E .. code.G)
    -- find A
    code.A = removeLetters(one, code.B)

    -- decode line
    local decoded = {}
    for index = 1, 14 do
        local value = nil
        local word = codes[index]
        local length = string.len(word)
        if length == 2 then
            value = 1
        elseif length == 3 then
            value = 7
        elseif length == 4 then
            value = 4
        elseif length == 7 then
            value = 8
        elseif length == 5 then
            if string.find(word, code.F) ~= nil then
                value = 5
            elseif string.find(word, code.E) ~= nil then
                value = 2
            else
                value = 3
            end
        elseif length == 6 then
            if string.find(word, code.G) ~= nil then
                if string.find(word, code.E) ~= nil then
                    value = 6
                else
                    value = 9
                end
            else
                value = 0
            end
        end
        decoded[index] = value
    end
    return decoded
end

local function mapToNumbers(codeList)
    local numbers = {}
    for _, codes in pairs(codeList) do table.insert(numbers, decode(codes)) end
    return numbers
end

-- solve task
local function solveTask(fileIterator)
    local codesList = parseInput(fileIterator)
    local sum = 0
    local numbersList = mapToNumbers(codesList)
    for _, numbers in pairs(numbersList) do
        sum = sum +
                  tonumber(
                      numbers[11] .. numbers[12] .. numbers[13] .. numbers[14])
    end
    return sum
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
