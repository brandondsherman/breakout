
LevelMaker = Class{}

function LevelMaker.createLevel(level)
    local bricks = {}
    local numRows = math.random(1,5)
    local numCols = math.random(7, 13)

    print("Level: ncols: " .. tostring(numCols .. ", nrows: " .. tostring(numRows)))
    for y = 1, numRows do
        for x = 1, numCols do
            table.insert(bricks, Brick(
                (x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16
            ))
        end
    end
    return bricks
end