window_width = 1280
window_height = 720

virtual_width = 432
virtual_height = 243

Class = require 'class'
push = require 'push'

require 'Util'
require 'Map'

function love.load()

    math.randomseed(os.time())

    map = Map()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push: setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = false
    })

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.keyboard.wasReleased(key)
    return love.keyboard.keysReleased[key]
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true

end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    map:update(dt)
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.draw()

    push:apply('start')
    
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)
    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    
    map:render()
    push:apply('end')

end