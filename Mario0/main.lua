WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'class'
push = require 'push'

require 'Map'

function love.load()
    map = Map()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizeable = false,
    vsynce = true
    })
end

function love.update(dt)

end

function love.draw()
    push:apply('start')
    love.graphics.clear(108/255,140/255,1,1)
    love.graphics.print('Hello, World!')
    map:render()
    push:apply('end')
end