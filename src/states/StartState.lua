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



function StartState:init()
    self.highlighted = 0
    self.menuOptions = {
        [0] = 'START',
        [1] = 'HIGH SCORES'
    }
    self.menuOptionsSize = table.size(self.menuOptions)
end

function StartState:update(dt)
    -- toggle self.highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
        self.highlighted = (self.highlighted - 1) % self.menuOptionsSize
        gEventHandler:alert('select')
    elseif love.keyboard.wasPressed('down') then
        self.highlighted = (self.highlighted + 1) % self.menuOptionsSize
        gEventHandler:alert('select')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --gEventHandler:alert('confirm')
        
        if self.menuOptions[self.highlighted] == "START" then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createLevel(1),
                health = 3,
                level = 1,
            })
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

    local startingY = VIRTUAL_HEIGHT / 2 + 110 - (20 * self.menuOptionsSize)
    for i, str in pairs(self.menuOptions) do
        if self.highlighted == i then
            love.graphics.setColor(103, 255, 255, 255)
        end
        love.graphics.printf(str, 0, startingY + (20 * i), VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255,255,255,255)
    end
end

