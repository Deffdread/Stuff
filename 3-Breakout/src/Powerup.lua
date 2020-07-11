--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Represents a powerup to be picked up by having the paddle collide with the falling powerup
]]

Powerup = Class{}


function Powerup:init(x, y)

    

    self.x = x
    self.y = y
    self.dy = 1
    self.width = 16
    self.height = 16
    self.type = math.random(1, 3) --type of powerup; 1 = extra ball, 2 = size up, 3 = key

    if(self.type == 1) then 
        self.type = 5 -- size up
    elseif(self.type == 2) then 
        self.type = 7 -- ball
    elseif(self.type == 3) then
        self.type = 10 -- key
    end


    -- used to determine whether this powerup should be rendered
    -- stop rendering when collision with paddle or bottom of screen
    self.inPlay = false
end

function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:hit(gameState)
    if self.inPlay == true then
        gSounds['powerup']:stop()
        gSounds['powerup']:play()

        self.inPlay = false
        
        --extra ball
        if self.type == 7 then
            local ballIndex
            local newBall = Ball()
            newBall.skin = math.random(7)

            for k, ball in pairs(gameState.ball) do
                if ball.inPlay == true then
                    ballIndex = k
                    break
                end
            end
            newBall.x = gameState.ball[ballIndex].x
            newBall.y = gameState.ball[ballIndex].y
            newBall.dx = -gameState.ball[ballIndex].dx
            newBall.dy = gameState.ball[ballIndex].dy
            table.insert(gameState.ball, newBall)

            gameState.totalBalls = gameState.totalBalls + 1
            return {paddle = gameState.paddle, ball = gameState.ball, totalBalls = gameState.totalBalls, bricks = gameState.bricks} 
        --upsize paddle
        elseif self.type == 5 then
            gameState.paddle:sizeChange(1)
            return {paddle = gameState.paddle, ball = gameState.ball, totalBalls = gameState.totalBalls, bricks = gameState.bricks}
        elseif self.type == 10 then
            for k,brick in pairs(gameState.bricks) do
                brick.breakable = true
                brick.tier = 0
            end
            return {paddle = gameState.paddle, ball = gameState.ball, totalBalls = gameState.totalBalls, bricks = gameState.bricks}
        end
    end
end


function Powerup:update(dt)
    if self.inPlay then
        self.y = self.y + self.dy
    end
end


function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['powerups'][self.type],
            self.x, self.y)
    end
end