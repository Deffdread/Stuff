

Projectile = Class{}

function Projectile:init(def,x,y,dx,dy)
    self.texture = def.texture
    self.frame = def.frame

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.inPlay =  true

    self.dy = dy
    self.dx = dx
    
end

function Projectile:update(dt)
    if self.inPlay then
        
        --Hit borders
        if self.x + self.width >= VIRTUAL_WIDTH - MAP_RENDER_OFFSET_X  - TILE_SIZE then  --Far right
            self.inPlay = false
            gSounds['hit-enemy']:setVolume(0.1)
            gSounds['hit-enemy']:play()
        elseif self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then -- Far left
            self.inPlay = false
            gSounds['hit-enemy']:setVolume(0.1)
            gSounds['hit-enemy']:play()
        elseif self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE then --Too up
            self.inPlay = false
            gSounds['hit-enemy']:setVolume(0.1)
            gSounds['hit-enemy']:play()
        elseif self.y + self.height >= VIRTUAL_HEIGHT - MAP_RENDER_OFFSET_Y - TILE_SIZE then --Too down
            self.inPlay = false
            gSounds['hit-enemy']:setVolume(0.1)
            gSounds['hit-enemy']:play()
        end

    
        self.x = self.x + self.dx * dt 
        self.y = self.y + self.dy * dt
    end


end

function Projectile:render()
    if self.inPlay then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
    end
end