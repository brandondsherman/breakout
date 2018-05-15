SoundEngine = Class{}

local sounds = {
    ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
    ['score'] = love.audio.newSource('sounds/score.wav'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav'),
    ['select'] = love.audio.newSource('sounds/select.wav'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav'),
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav'),
    ['victory'] = love.audio.newSource('sounds/victory.wav'),
    ['recover'] = love.audio.newSource('sounds/recover.wav'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav'),
    ['pause'] = love.audio.newSource('sounds/pause.wav'),
}

local music = love.audio.newSource('sounds/music.wav')

function SoundEngine:init()
    for name, _ in pairs(sounds) do
        gEventHandler:subscribe(self, name)
    end 
    
    music:setLooping(true)
    --music:play()

end

function SoundEngine:alert(sound)
    sounds[sound]:play()
end