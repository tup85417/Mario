window_width = 1280
window_height = 720

virtual_width = 432
virtual_heigth = 243

class = require 'class'
push = require 'push'

require 'Util'
require 'Map'

function love.load()

    map = Map()

    push:setupScreen(virtual_width, virtual_heigth, window_width, window_height, {
    fullscreen = false,
    resizable = false,
    vsynce = true
    }
)

end

function love.update(dt)
    Map:update(dt)
end

function love.draw()

    push:apply('start')
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)
    
    love.graphics.translate(-map.camX, -map.camY)
    map:render()
    push:apply('end')

end