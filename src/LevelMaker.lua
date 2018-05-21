
LevelMaker = Class{}


local highestColor = 1
local highestTier = 0
local numOfActiveBricks = 0

function LevelMaker.createLevel(level)
    local bricks = {}
    local numRows = math.random(1,5)
    local numCols = math.random(7, 13)
    if numCols % 2 == 0 then
        numCols = numCols + 1
    end

    local modifications = {
        [1] = {test = function () return math.random(2) == 1 end, func = LevelMaker.skipFunc},
        [2] = {test = function () return math.random(2) == 1 end, func = LevelMaker.alternateFunc, testFailed = LevelMaker.solidFunc}
    }
    highestTier = math.min(3, math.floor(level / 5))
    highestColor = math.min(4, level % 5 + 3)
    
    
    for y = 1, numRows do
        for x = 1, numCols do
            table.insert(bricks, Brick(
                (x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16
            ))
        end
    end

    for y = 1, numRows do
        for _, mod in ipairs(modifications) do
            if mod.test then 
                mod.func(table.slice(bricks, ((y - 1) * numCols) + 1, y * numCols))
            elseif mod.testFailed ~= nil then
                mod.testFailed((table.slice(bricks, (y - 1 * numCols) + 1, (y * numCols) - 1)))
            end
        end
    end
    
    for y = 1, numRows do
        for x = 1, numCols do
            if bricks[(y - 1) * numCols + x].inPlay then
                numOfActiveBricks = numOfActiveBricks + 1    
            end
            --print(tostring(bricks[(y - 1) * numCols + x].inPlay))
        end
    end
    if numOfActiveBricks == 0 then
        bricks = LevelMaker.createLevel(level)
    end
    --if level == 1 then
      --  
        --bricks = {[1] = (Brick((1 - 1) * 32 + 8 + (13 - 1) * 16, 1 * 16))}
        --bricks[1].tier = 0
    --end
    return bricks
end

--local alternateFlag = math.random(2) == 1 


function LevelMaker.alternateFunc(brickRow)
    local alternateColor1 = math.random(1, highestColor)
    local alternateColor2 = math.random(1, highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)    
    local alternateFlag = math.random(2) == 1

    for _, brick in ipairs(brickRow) do
        if brick.inPlay then
            if alternateFlag then
                brick.color = alternateColor1
                brick.tier = alternateTier1
            else
                brick.color = alternateColor2
                brick.tier = alternateTier2
            end
            
            alternateFlag = not alternateFlag
        end
    end
end



function LevelMaker.skipFunc(brickRow)
    local skipFlag = math.random(2) == 1
    
    for _, brick in ipairs(brickRow) do
        if brick.inPlay then
            if skipFlag then
                brick.inPlay = false
            end
            skipFlag = not skipFlag
        end
    end
end

function LevelMaker.solidFunc(brickRow)
    local solidColor = math.random(1, highestColor)
    local solidTier = math.random(0, highestTier)
    for _, brick in ipairs(brickRow) do
        brick.color = solidColor
        brick.tier = solidTier
    end

end
