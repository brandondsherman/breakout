PlayState = Class{__includes = BaseState}

function PlayState:enter(par)

    self.paddle = par.paddle
    self.ball = par.ball
    self.bricks = par.bricks
    self.highScores = par.highScores
    
    self.health = par.health
    self.bricks = par.bricks
    self.level = par.level

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-120, -80)
    
    self.paused = false
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        self.paused = not self.paused
        gEventHandler:alert('pause')
    end --

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end -- 

    if not self.paused then
        self.paddle:update(dt)
        local collision = self.ball:update(dt, self.bricks)
        if collision then
            if self:checkVictory() then
                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    highScores = self.highScores,
                    ball = self.ball
                })
            end --
        end --

        local paddleHit = false
        --top
        if self.ball.x + self.ball.width > self.paddle.x and self.ball.x < self.paddle.x + self.paddle.width then --good
            if self.ball.y + self.ball.height > self.paddle.y and self.ball.y < self.paddle.y then 
                paddleHit = true
                self.ball.y = self.paddle.y - self.ball.height
            end
        end

        --left
        if self.ball.y < self.paddle.y + self.paddle.height and self.ball.y + self.ball.height > self.paddle.y then --good
            if self.ball.x + self.ball.width > self.paddle.x and self.ball.x < self.paddle.x then --good
                paddleHit = true
                self.ball.x = self.paddle.x - self.ball.width
            end
        end

        --right
        if self.ball.y < self.paddle.y + self.paddle.height and self.ball.y + self.ball.height > self.paddle.y then --good
            if self.ball.x + self.ball.width > self.paddle.x + self.paddle.width and self.ball.x < self.paddle.x + self.paddle.width then --good
                paddleHit = true
                self.ball.x = self.paddle.x + self.paddle.width
            end
        end

        if paddleHit then
            self.ball.dy = -1 * self.ball.dy
            if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
            end --
        end --
        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end

        if math.abs(self.ball.dy) < 140 + 10 * self.level then
            self.ball.dy = self.ball.dy * 1.02
        end

        if self.ball.y > VIRTUAL_HEIGHT then
            self.health = self.health - 1
            gEventHandler:alert('hurt')

            if self.health == 0 then
                gStateMachine:change('gameover',{})
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                })
            end
        end
    end --
end --

        

function PlayState:render()
    
    for _, brick in pairs(self.bricks) do
       brick:render() 
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end

end

function PlayState:checkVictory()
    for _, brick in ipairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end