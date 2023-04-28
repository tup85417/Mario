Map = Class{}

tile_brick = 1
tile_empty = 4

local scroll_speed = 62

function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.camX = 0
    self.camY = 0

    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    self.mapWidthPixels = self.mapWidth * self.mapWidth
    self.mapHeightPixels = self.mapHeight * self.mapHeight

    --Fill map with empty tile --

    for  y = 1, self.mapHeight / 2 do
        for x = 1, self.mapWidth do
            
            self:setTile(x, y, tile_empty)

        end
    end

    --Starts halfway down the map filling it with bricks --

    for y = self.mapHeight / 2, self.mapHeight do
        for x = 1, self.mapWidth do

            self:setTile(x, y, tile_brick)
        
        end
    end

end

function Map:setTile(x, y, tile)

    self.tiles[(y - 1) * self.mapWidth + x] = tile

end

function Map:getTile(x, y)

    return self.tiles[(y - 1) * self.mapWidth + x]

end

function Map:update(dt)
    
    if love.keyboard.isDown('w') then --up movement

        self.camY = math.max(0, math.floor(self.camY + dt * -scroll_speed))

    elseif love.keyboard.isDown('a') then --left movement

        self.camX = math.max(0, math.floor(self.camX + dt * -scroll_speed))

    elseif love.keyboard.isDown('s') then --down movement

        self.camY = math.min(self.mapHeightPixels - virtual_height, math.floor(self.camY + dt * scroll_speed))

    elseif love.keyboard.isDown('d') then --right movement

        self.camX = math.min(self.mapWidthPixels - virtual_width, math.floor(self.camX + dt * scroll_speed))
    end
end

function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapHeight do

            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        
        end
    end
end