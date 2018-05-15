Ball = Class{}


function Ball:init(color)
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.width = 8
    self.height = 8
    self.dy = 0
    self.dx = 0

    self.color = color
end


function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x < 0 then
        self.x = 0
        self.dx = -1 * self.dx
        gEventHandler:alert('wall-hit')
    end

    if self.x + self.width > VIRTUAL_WIDTH then
        self.x = VIRTUAL_WIDTH - self.width
        self.dx = -1 * self.dx
        gEventHandler:alert('wall-hit')
    end

    if self.y < 0 then
        self.y = 0
        self.dy = -1 * self.dy
        gEventHandler:alert('wall-hit')
    end

    
end

function Ball:render()
    love.graphics.draw(
        gTextures['main'], 
        gFrames['balls'][self.color],
        self.x, self. y
    )
end


function Ball:collidesWith(rect)
    if self.x > rect.x + rect.width or rect.x > self.x + self.width then
        return false
    end

    if self.y > rect.y + rect.height or rect.y > self.y + self.height then
        return false
    end
    
    return true
end

function Ball:hit(obj)
    
    if obj.type == 'paddle' then
        self.dy = -1 * self.dy

        --self.dx = math.sign(obj.dx) * 50 + 
          --  (8 * math.abs(obj.x + obj.width / 2 - self.x))
        
        if self.x < obj.x + (obj.width / 2) and obj.dx < 0 then
            self.dx = -50 + -(8 * (obj.x + obj.width / 2 - self.x))
        elseif self.x > obj.x + (obj.width / 2) and obj.dx > 0 then
            self.dx = 50 + (8 * math.abs(obj.x + obj.width / 2 - self.x))
        end
        
    end

    if obj.type == 'brick' then
        if obj.inPlay then
            

            if self.x + 2 < obj.x and self.dx > 0 then
                self.dx = -1 * self.dx
                self.x = obj.x - 8
            elseif self.x + 6 > obj.x + obj.width and self.dx < 0 then
                self.dx = -1 * self.dx
                self.x = obj.x + 32
            elseif self.y < obj.y then
                self.dy = -1 * self.dy
                self.y = obj.y - 8
            else 
                self.dy = -1 * self.dy
                self.y = obj.y + 16
            end
        end
    end
    --self.dy = self.dy * 1.02
end
