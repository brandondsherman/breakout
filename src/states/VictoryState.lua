VictoryState = Class{__includes = BaseState}

function VictoryState:enter(par)
    gEventHandler:alert('victory')
    self.health = par.health
    self.level = par.level + 1
    self.paddle = par.paddle
    self.ball = par.paddle
end


function VictoryState:update(dt)
    
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level,
            bricks = LevelMaker.createLevel(self.level),
            paddle = Paddle(1),
            health = self.health,
        })
    end
end


function VictoryState:render()
    --self.paddle:render()
    --self.ball:render()

    renderHealth(self.health)
    renderScore(score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')

end