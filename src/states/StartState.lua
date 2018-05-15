--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 0
local menuOptions = {
    [0] = 'START',
    [1] = 'HIGH SCORES'
}
local menuOptionsSize = table.size(menuOptions)

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
        highlighted = (highlighted - 1) % menuOptionsSize
        gSounds['paddle-hit']:play()
    elseif love.keyboard.wasPressed('down') then
        highlighted = (highlighted + 1) % menuOptionsSize
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if menuOptions[highlighted] == "START" then
            gStateMachine:change('play')
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])

    local startingY = VIRTUAL_HEIGHT / 2 + 110 - (20 * menuOptionsSize)
    for i, str in pairs(menuOptions) do
        if highlighted == i then
            love.graphics.setColor(103, 255, 255, 255)
        end
        love.graphics.printf(str, 0, startingY + (20 * i), VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255,255,255,255)
    end
end

