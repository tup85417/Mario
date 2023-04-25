Map = class{}

tile_brick = 1
tile_empty = -1

local scroll_speed = 62

function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/tiles.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.camX = 0
    self.camY = 0

    self.tileSprites = generateQuads{self.spritesheet, self.tileWidth, self.tileHeight}

    -- Fill map with empty tile --

    for  y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            
            self:setTile(x, y, tile_empty)

        end
    end

    -- Starts halfway down the map filling it with bricks --

    for y = self.mapHeight / 2, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, tile_brick)
        end
    end

end

function Map:update(dt)

    self.camX = self.camX + scroll_speed * dt

end

function Map:setTile(x, y, tile)

    self.tiles[(y - 1) * self.mapWidth + x] = tile

end

function Map:getTile(x, y)

    return self.tiles[(y - 1) * self.mapWidth + x]

end

function Map:update(dt)

end

function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapHeight do
            love.graphics.draw(self.spritesheet, self.tileSprites[self.getTile(x, y)],(x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end
end