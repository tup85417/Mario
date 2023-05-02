require 'Util'
require 'Player'

Map = Class{}

tile_brick = 1
tile_empty = 4

cloud_left = 6
cloud_right = 7

bush_left = 2
bush_right = 3

mushroom_top = 10
mushroom_bottom = 11

jump_block = 5
jump_block_hit = 9

local scroll_speed = 62

function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.player = Player(self)

    self.camX = 0
    self.camY = -3

    self.tileSprites = generateQuads(self.spritesheet, 16, 16)

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    --Fill map with empty tile --

    for  y = 1, self.mapHeight / 2 do
        for x = 1, self.mapWidth do
            
            self:setTile(x, y, tile_empty)

        end
    end

    local x = 1
    while x < self.mapWidth do

        -- Cloud
        if x < self.mapWidth - 2 then
            if math.random(20) == 1 then

                local cloudStart = math.random(self.mapHeight / 2 - 6)

                self:setTile(x, cloudStart, cloud_left)
                self:setTile(x + 1, cloudStart, cloud_right)

            end
        end

        -- Mushroom
        if math.random(20) == 1 then

            self:setTile(x, self.mapHeight / 2 - 2, mushroom_top)
            self:setTile(x, self.mapHeight / 2 - 1, mushroom_bottom)

            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, tile_brick)
            end

            x = x + 1

        --Bush
        elseif math.random(10) == 1 and x < self.mapWidth - 3 then
            local bushLevel = self.mapHeight / 2 - 1
            
            self:setTile(x, bushLevel, bush_left)
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, tile_brick)
            end

            x = x + 1

            self:setTile(x, bushLevel, bush_right)
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, tile_brick)
            end
            x = x + 1

        -- Nothing
        elseif math.random ~= 1 then

            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, tile_brick)
            end

            --Jump block
            if math.random(15) == 1 then
                self:setTile(x, self.mapHeight / 2 - 4, jump_block)
            end

            x = x + 1
        
        else

            x = x + 2
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

--[[function Map:collides(tile)

    local collidables = {tile_brick, jump_block, jump_block_hit,mushroom_top, mushroom_bottom}

    for _, v in ipairs(collidables) do

        if tile == v then
            return true
        end
    end

    return false
end--]]
function Map:update(dt)


    self.player:update(dt)

    self.camX = math.max(0,
     math.min((self.player.x - virtual_width / 2),
     math.min((self.mapWidthPixels - virtual_width), 
     self.player.x)))

end

function Map:tileAt(x,y)
    return self:getTile(math.floor(x / self.tileWidth) + 1, 
    math.floor(y / self.tileHeight) + 1)
end

function Map:getTile(x,y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do

            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
             (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)

        end
    end

    self.player:render()

end