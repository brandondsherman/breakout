PlayState = Class{__includes = BaseState}

function PlayState:init()

    self.gameObjects = {
        ['paddle'] = Paddle(),
        ['ball'] = Ball(1),
    }
    for _, brick in pairs(LevelMaker.createLevel(1)) do
        table.insert(self.gameObjects, brick)
    end

    self.gameObjects['ball'].dx = math.random(-200, 200)
    self.gameObjects['ball'].dy = math.random(-50, -60)
    self.gameObjects['ball'].x = VIRTUAL_WIDTH / 2 - 4
    self.gameObjects['ball'].y = VIRTUAL_HEIGHT - 42
    
    self.paused = false
end

function PlayState:update(dt)
    
    if love.keyboard.wasPressed('p') then
        self.paused = not self.paused
        gEventHandler('pause')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.paused then
        for name, obj in pairs(self.gameObjects) do
            obj:update(dt) 
        end
        local ball = self.gameObjects['ball']
        for name, obj in pairs(self.gameObjects) do
            if name ~= 'ball' then
                if ball:collidesWith(obj) then
                    ball:hit(obj)
                    obj:hit(ball)
                end
            end
        end
    end

end

function PlayState:render()
    for name, obj in pairs(self.gameObjects) do
       obj:render(dt) 
    end
end