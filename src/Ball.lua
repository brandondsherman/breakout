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


function Ball:update(dt, bricks)
    local collision = false
    for _, brick in pairs(bricks) do
        if brick.inPlay then
            local x2 = self.x
            local y2 = self.y
            local left = false
            local right = false
            local top = false
            local bot = false
            for scale = 1, 4 do
                left = false
                right = false
                top = false
                bot = false
                local numHit = 0
                scale = scale / 4
                
                x2 = self.x + self.dx * dt * scale
                y2 = self.y + self.dx * dt * scale
                
                --check left brick wall
                if y2 < brick.y + brick.height and y2 + self.height > brick.y then --good
                    if x2 + self.width > brick.x and x2 < brick.x then --good
                        if self.dx > 0 then
                            left = true
                            numHit = numHit + 1
                        end --
                    end --
                end --
                --check right brick wall
                if y2 < brick.y + brick.height and y2 + self.height > brick.y then --good
                    if x2 + self.width > brick.x + brick.width and x2 < brick.x + brick.width then --good
                        if self.dx < 0 then
                            right = true
                            numHit = numHit + 1
                        end --
                    end --
                end --
                --check top brick wall
                if x2 + self.width > brick.x and x2 < brick.x + brick.width then --good
                    if y2 + self.height > brick.y and y2 < brick.y then --good
                        if self.dy > 0 then
                            top = true
                            numHit = numHit + 1
                        end --
                    end --
                end --
                --check bot brick wall
                if x2 + self.width > brick.x and x2 < brick.x + brick.width then --good
                    if y2 + self.height > brick.y + brick.height and y2 < brick.y + brick.height then
                        if self.dy < 0 then
                            bot = true 
                            numHit = numHit + 1
                        end--
                    end--
                end--
                if numHit == 1 then
                    collision = true
                    break
                elseif numHit > 1 then
                    --[[
                    print('collisions before: ')
                    print('left: ' .. tostring(left))
                    print('right: ' .. tostring(right))
                    print('top: ' .. tostring(top))
                    print('bot: ' .. tostring(bot))
                    print('ball left: ' .. tostring(x2))
                    print('ball right: ' .. tostring(y2))
                    --]]

                    local answer = self:multipleCollisions(dt, brick, x2, y2, left, right, top, bot)
                    left = answer.left
                    right = answer.right
                    bot = answer.bot
                    top = answer.top
                    collision = true
                    --[[
                    print('collisions after: ')
                    print('left: ' .. tostring(left))
                    print('right: ' .. tostring(right))
                    print('top: ' .. tostring(top))
                    print('bot: ' .. tostring(bot))
                    --]]
                    break
                end --
            end --for scale
            if collision then
                brick:hit()
                if left then
                    self.dx = -1 * self.dx
                    self.x = brick.x - self.width
                end --
                if right then
                    self.dx = -1 * self.dx
                    self.x = brick.x + brick.width
                end -- 
                if top then            
                    self.dy = self.dy * -1
                    self.y = brick.y - self.height
                end --
                if bot then 
                    self.dy = self.dy * -1
                    self.y = brick.y + brick.height
                end --
                break
            end --
        end --if inplay
    end -- for bricks

    
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

    return collision
end

function Ball:render()
    love.graphics.draw(
        gTextures['main'], 
        gFrames['balls'][self.color],
        self.x, self. y
    )
end


function Ball:multipleCollisions(dt, brick, x2, y2, left, right, top, bot)
    
    deltas = {}
    if left then
        local deltaX = math.abs(x2 - brick.x)/self.width
        deltas.x = deltaX
    end
    if right then
        local deltaX = math.abs(x2 + self.width - (brick.x + brick.width))/self.width
        deltas.x = deltaX
    end
    if top then
        local deltaY = math.abs(y2 - brick.y)/self.height
        deltas.y = deltaY
    end
    if bot then
        local deltaY = math.abs(y2 + self.height - (brick.y + brick.height))/self.height
        deltas.y = deltaY
    end

    if math.abs(deltas.x - deltas.y) > .25 then
        if deltas.x > deltas.y then
            return {
                ['left'] = left,
                ['right'] = right,
                ['top'] = false,
                ['bot'] = false,
            }
        else
            return {
                ['left'] = false,
                ['right'] = false,
                ['top'] = top,
                ['bot'] = bot,
            }
        end

    else
        return {
            ['left'] = right,
            ['right'] = right,
            ['top'] = top,
            ['bot'] = bot,
        }
    end
end --