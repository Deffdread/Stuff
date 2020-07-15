

PlayerIdlePotState = Class{__includes = BaseState}

-- function PlayerIdlePotState:enter(params)
--     -- render offset for spaced character sprite
--     self.entity.offsetY = 5
--     self.entity.offsetX = 0
-- end


function PlayerIdlePotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('pot-idle-' .. self.player.direction)
end

function PlayerIdlePotState:enter(def)
    self.pot = def.pot
end

function PlayerIdlePotState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.player:changeState('walk-pot',{pot = self.pot})
    end

    if love.keyboard.wasPressed('a') then --Throw

        local dx = 0
        local dy = 0

        if self.player.direction == 'up' then
            dy = -5 
        elseif self.player.direction == 'down' then
            dy = 5
        elseif self.player.direction == 'left' then
            dx = -5
        else 
            dx = 5
        end

        

        local proj = Projectile(
            PROJECTILE_DEFS['pot'],
            self.pot.x,
            self.pot.y+10,
            dx,
            dy
        )

        table.insert(self.dungeon.currentRoom.projectiles,proj)

        self.pot.inPlay = false
        self.player:changeState('idle', {})
    end

    self.pot.x = self.player.x
    self.pot.y = self.player.y - 10
end


function PlayerIdlePotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end