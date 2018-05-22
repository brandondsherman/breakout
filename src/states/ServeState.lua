ServeState = Class{__includes = BaseState}

function ServeState:enter(par)
    
    self.bricks = par.bricks
    self.health = par.health
    self.highScores = par.highScores
    self.paddle = par.paddle
    self.level = par.level
    self.ball = Ball()
    self.ball.color = math.random(7)    
    
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2 ) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end


end

function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end