-- print list
local function printList(list)
    for index, item in pairs(list) do io.write(item .. ', ') end
    io.write('\n')
end

local function parseBoards(lineIterator)
    local boards = {}

    while true do
        local currentLine = lineIterator()
        if currentLine == nil then break end

        local currentBoard = {}
        for line = 1, 5 do
            currentLine = lineIterator()
            for number = 1, 14, 3 do
                table.insert(currentBoard, tonumber(
                                 string.sub(currentLine, number, number + 2)))
            end
        end
        table.insert(boards, currentBoard)
    end

    return boards
end

local function mark_board(hit, board)
    for index, number in pairs(board) do
        if hit == number then board[index] = -1 end
    end
    return board
end

local function check_win(board)
    local rows = {0, 0, 0, 0, 0}
    local cols = {0, 0, 0, 0, 0}

    for row = 1, 5 do
        for col = 1, 5 do
            if board[((row - 1) * 5) + col] == -1 then
                rows[row] = rows[row] + 1
                cols[col] = cols[col] + 1
                if (rows[row] == 5) or (cols[col] == 5) then
                    return true
                end
            end
        end
    end
    return false
end

local function play_round(hit, boards, skip_check)
    local winner = false
    local winning_indexes = {}
    for index, board in pairs(boards) do
        boards[index] = mark_board(hit, board)
        if skip_check ~= true then
            winner = check_win(board)
            if winner == true then
                table.insert(winning_indexes, index)
            end
        end
    end

    return winner, winning_indexes, boards
end

local function play(hit_list, board_list)
    local boards = board_list
    for index, hit in pairs(hit_list) do
        local winner, winning_indexes, boards =
            play_round(hit, boards, index <= 5)
        if #winning_indexes > 0 == true then
            if #boards == 1 then
                return hit, boards[winning_indexes[1]]
            end
            for index = #winning_indexes, 1, -1 do
                table.remove(boards, winning_indexes[index])
            end
        end
    end
    -- Should not happen
    return nil
end

local function score_board(board)
    local score = 0
    for index, number in pairs(board) do
        if number ~= -1 then score = score + number end
    end
    return score
end

-- solve task
local function solveTask(fileIterator)
    local game_input_line = fileIterator()
    local game_hits = {}

    for number in string.gmatch(game_input_line, '(%d+),?') do
        table.insert(game_hits, tonumber(number))
    end

    local game_boards = parseBoards(fileIterator)

    local hit, winning_board = play(game_hits, game_boards)

    return hit * score_board(winning_board)
end

print('example :', solveTask(io.lines('./example.txt')))

print('solution:', solveTask(io.lines('./input.txt')))
