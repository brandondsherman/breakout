Brick = Class{}

function Brick:init(x, y)
    self.type = "brick"
    self.x = x
    self.y = y
    

    self.width = 32
    self.height = 16

    self.tier = 1
    self.color = 1

    self.inPlay = true
end

function Brick:update(dt)

end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],
            gFrames['bricks'][1 + ((self.color -1) * 4) + self.tier],
            self.x, self.y
        )
    end
end

function Brick:hit(obj)
    if self.inPlay then
        gEventHandler:alert('brick-hit-1')    
    end
    
    self.inPlay = false

end

