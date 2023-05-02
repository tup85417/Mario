Player = Class{}

require 'Animation'

local move_speed = 80
local jump_velocity = 400
local gravity = 30

function Player:init(map)

    self.width = 16
    self.height = 20

    self.x = map.tileWidth * 10
    self.y = map.tileHeight * (map.mapHeight / 2 - 1) - self.height

    self.dx = 0
    self.dy = 0

    self.texture = love.graphics.newImage('graphics/blue_alien.png')
    self.frames = generateQuads(self.texture, 16, 20)

    self.state = 'idle'
    self.direction = 'right'

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {self.frames[1]},
            interval = 1
        },

        ['walking'] = Animation {
            texture = self.texture,
            frames = {self.frames[9], self.frames[10], self.frames[11]},
            interval = 0.15
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {self.frames[3]},
            interval = 1
        }
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviours = {

        ['idle'] = function(dt)

            if love.keyboard.wasPressed('space') then

                self.dy = -jump_velocity
                self.state = 'jumping'
                self.animation = self.animations['jumping']

            elseif love.keyboard.isDown('a') then

                self.x = self.x - move_speed * dt
                self.animation = self.animations['walking']
                self.direction = 'left'
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']

        
            elseif love.keyboard.isDown('d') then
        
                self.x = self.x + move_speed * dt
                self.animation = self.animations['walking']
                self.direction = 'right'
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']

            else
                self.animation = self.animations['idle']
        
            end
        end,

        ['walking'] = function(dt)

            if love.keyboard.wasPressed('space') then

                self.dy = -jump_velocity
                self.state = 'jumping'
                self.animation = self.animations['jumping']

            elseif love.keyboard.isDown('a') then

                self.x = self.x - move_speed * dt
                self.animation = self.animations['walking']
                self.direction = 'left'

            elseif love.keyboard.isDown('d') then

                self.x = self.x + move_speed * dt
                self.animation = self.animations['walking']
                self.direction = 'right'

            else
                self.dx = 0
                self.state = 'idle'
                self.animation = self.animations['idle']        
            end

            --[[self:checkRightCollision()
            self:checkLeftCollision()

            if not map:collides(map:tileAt(self.x, self.y + self.height)) and not map:collides(map:tileAt(self.x, self.width - 1, self.y + self.height)) then

                self.state = 'jumping'
                self.animation = self.animations['jumping']

            end--]]

        end,

        ['jumping'] = function(dt)
            if love.keyboard.isDown('a') then

                self.direction = 'left'
                self.x = self.x - move_speed * dt

            elseif love.keyboard.isDown('d') then

                self.direction = 'right'
                self.x = self.x + move_speed * dt

            end

            self.dy = self.dy + gravity

            --[[if map.collides(map:tileAt(self.x, self.y + self.height)) or map:collides(map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.y = (map:tileAt(self.x, self.y + self.height).y - 2) * map.tileHeight - self.height

            end--]]

        end
    }
end

function Player:update(dt)

    self.behaviours[self.state](dt)
    self.animation:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.dy < 0 then
        if map:tileAt(self.x, self.y) ~= tile_empty or map:tileAt(self.x + self.width - 1, self.y) ~= tile_empty then
            
            self.dy = -10

            if map:tileAt(self.x, self.y) == jump_block then 
                map:setTile(math.floor(self.x / map.tileWidth) + 1, math.floor(self.y / map.tileHeight) + 1, jump_block_hit)
            end
            if map:tileAt(self.x + self.width - 1, self.y) == jump_block then
                map:setTile(math.floor((self.x + self.width - 1) / map.tileWidth) + math.floor(self.y / map.tileHeight) + 1, jump_block_hit)
            end
        end
    end
end

--[[{function Player:checkLeftCollision()
    if self.dx < 0 then
        if map:collides(map:tileAt(self.x - 1, self.y)) or map:collides(map:tileAt(self.x - 1, self.y + self.height - 1)) then
            self.dx = 0
            self.x = map:tileAt(self.x - 1, self.y).x * map.tileWidth
        end
    end
end

function Player:checkRightCollision()
    if self.dx > 0 then
        if map:collides(map:tileAt(self.x + self.width, self.y)) or map:collides(map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            self.dx = 0
            self.x = (map:tileAt(self.x + self.width, self.y).x - 1) * map.tileWidth - self.width
        end
    end
end
--]]

function Player:render()

    if self.direction == 'right' then

        scaleX = 1

    else
        scaleX = -1

    end

    love.graphics.draw(self.texture, self.animation: getCurrentFrame(),
     math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2),
    0, scaleX, 1, self.width / 2, self.height / 2)

end