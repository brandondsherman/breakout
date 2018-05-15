Paddle = Class{}


function Paddle:init(skin)
    self.type = 'paddle'
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    self.dx = 0

    self.width = 64
    self.height = 16

    self.skin = skin
    self.size = 2

    self.paddleSpeed = 200
end

function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -1 * self.paddleSpeed
    elseif love.keyboard.isDown('right') then
        self.dx = self.paddleSpeed
    else
        self.dx = 0
    end

    self.x = math.max(0, math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt))
end

function Paddle:render()
    love.graphics.draw(
        gTextures['main'], 
        gFrames['paddles'][self.size + 4 * (self.skin -1)],
        self.x, self. y
    )
end

function Paddle:hit(obj)
    gEventHandler:alert('paddle-hit')
end