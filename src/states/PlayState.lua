PlayState = Class{__includes = BaseState}

function PlayState:enter(par)

    self.gameObjects = {
        ['paddle'] = par.paddle,
        ['ball'] = par.ball
    }

    self.score = par.score
    self.health = 1
    self.bricks = par.bricks

    for _, brick in pairs(par.bricks) do
        table.insert(self.gameObjects, brick)
    end

    self.gameObjects['ball'].dx = math.random(-200, 200)
    self.gameObjects['ball'].dy = math.random(-120, -80)
    
    self.paused = false
end

function PlayState:update(dt)
    local ball = self.gameObjects['ball']
    if love.keyboard.wasPressed('p') then
        self.paused = not self.paused
        gEventHandler:alert('pause')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.paused then
        for name, obj in pairs(self.gameObjects) do
            obj:update(dt) 
        end
        
        for name, obj in pairs(self.gameObjects) do
            if name ~= 'ball' then
                if ball:collidesWith(obj) then
                    ball:hit(obj)
                    obj:hit(ball)
                    break
                end
            end
        end

        if ball.y > VIRTUAL_HEIGHT then
            self.health = self.health - 1
            gEventHandler:alert('hurt')

            if self.health == 0 then
                gStateMachine:change('gameover', {
                    score = self.score
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.gameObjects.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score
                })
            end
        end
    end

end

function PlayState:render()
    for name, obj in pairs(self.gameObjects) do
       obj:render(dt) 
    end

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end