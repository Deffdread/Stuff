

PlayerPickupPotState = Class{__includes = BaseState}

function PlayerPickupPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.pot = nil

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.pickupFlag = false

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    self.pickupHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerPickupPotState:enter(params)
    -- restart pot pickup animation
    self.player.currentAnimation:refresh()
end

function PlayerPickupPotState:update(dt)
    -- check if hitbox collides with any entities in the scene
    if self.pickupFlag == false then
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object:collides(self.pickupHitbox) and object.type == 'pot' and object.inPlay then
                gSounds['pickup']:play()
                self.pickupFlag = true

                Timer.tween(0.1, {
                    [object] = {x = self.player.x, y = self.player.y}
                })
                object.solid = false
                --object.inPlay = false
                self.pot = object
                break
            end
        end
    end
 
    if self.player.currentAnimation.timesPlayed > 0 and self.pickupFlag then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-pot', {pot = self.pot})
    elseif self.player.currentAnimation.timesPlayed > 0 and not self.pickupFlag then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle', {})
    end

end

function PlayerPickupPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.pickupHitbox.x, self.pickupHitbox.y,
    --     self.pickupHitbox.width, self.pickupHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end