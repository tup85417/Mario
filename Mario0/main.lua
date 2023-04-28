window_width = 1280
window_height = 720

virtual_width = 432
virtual_height = 243

Class = require 'class'
push = require 'push'

require 'Util'
require 'Map'

function love.load()

    map = Map()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = false
    })

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    map:update(dt)
end

function love.draw()

    push:apply('start')
    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)
    map:render()
    push:apply('end')

end