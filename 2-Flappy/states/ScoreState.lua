--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local SCORE = love.graphics.newImage('food.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score

    
    local spritePosition = math.floor(params.score/5) 
    if spritePosition > 63 then --Highest possible icon for score
        spritePosition = 63
    end

    local spriteScoreY = (math.floor(spritePosition / 8))*16 --Y position in sprite sheet. 8 icons per row, 16 bits wide
    local spriteScoreX = ((1-(math.ceil((spritePosition/8)+0.00001) - (spritePosition / 8)))*8)*16  --X position in sprite sheet. After finding Y, use decimal portion to determine X by multiplying with 8 then by 16

    quad = love.graphics.newQuad(spriteScoreX, spriteScoreY, 16, 16, SCORE:getDimensions())
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(SCORE, quad, VIRTUAL_WIDTH/2 - 8, VIRTUAL_HEIGHT/2 - 20, 0, 2, 2)
end