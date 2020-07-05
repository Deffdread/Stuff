--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance. Corresponds to quad. We do 9 tiles.
    if color == 1  or color == 2 then
        self.color = 1
    elseif color == 3 or color == 4 then
        self.color = 6 
    elseif color == 5 or color == 6 then
        self.color = 9
    elseif color == 7 or color == 8 then
        self.color = 11 
    elseif color == 9 or color == 10 then
        self.color = 12
    elseif color == 11 or color == 12 then
        self.color = 17
    elseif color == 13 or color == 14 then
        self.color = 18
    elseif color == 15 or color == 16 then
        self.color = 2
    else
        self.color = 10
    end
    self.variety = variety

    --powerup
    self.powerup = math.random(1,8)
    if self.powerup == 1 then
        self.powerup = true
    else
        self.powerup = false
    end

    self.shine = 0

end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)



    -- draw tile itself
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    --If a powerup, shine
    if self.powerup then
        Timer.tween(2, {
            [self] = {shine = 200/255}
        }):finish(function()
            Timer.tween(2,{
                [self] = {shine = 0/255}
            })
        end)
        love.graphics.setColor(1, 1, 1, self.shine)
        love.graphics.rectangle('fill',self.x + x + 8, self.y + y + 8, 32-16 , 32-16, 8,8)
    end
end