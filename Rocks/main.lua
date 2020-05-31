--[[
    May 11,2020
    Rocks


    -- Main Program --

    Author: Jason Tsui

    Dodge rocks game
]]

push = require 'push'
Class = require 'class'
require 'Player'
require 'Rock'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

PLAYER_SPEED = 600
ROCK_SPEED = 200

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    --love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Rocks')

    math.randomseed(os.time())

    -- Sound
    sounds = {
        ['rock'] = love.audio.newSource('sounds/rock.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/Jump.wav', 'static')
    }
    song = love.audio.newSource('sounds/8-bit Detective.wav', 'static')
    song:setLooping(true)
    song:setVolume(0.1)
    song:play()

    -- Font
    titleFont = love.graphics.newFont('Orbitron-ExtraBold.ttf', 24)

    -- Title
    love.graphics.setFont(titleFont)

    -- initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    rocks = {}
    spawntimer = 1
    score = 0

    player = Player(VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 16 * 15, 40, 40)

    gameState = 'start'
end


function love.keypressed(key)
    -- Exit Game
    if key == 'escape' then
        love.event.quit()
    -- Start Game
    elseif key == 'enter' or key == 'return' then
        sounds['jump']:play()
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            reset()
        end
    end
end



function love.update(dt)
        -- player movement
        if gameState ~= 'gameOver' then
            if love.keyboard.isDown('up') then
                -- add negative paddle speed to current Y scaled by deltaTime
                player.dy = -PLAYER_SPEED
            elseif love.keyboard.isDown('down') then
                -- add positive paddle speed to current Y scaled by deltaTime
                player.dy = PLAYER_SPEED 
            else
                player.dy = 0
            end
        
            if love.keyboard.isDown('left') then
                -- add negative paddle speed to current X scaled by deltaTime
                player.dx = -PLAYER_SPEED
            elseif love.keyboard.isDown('right') then
                -- add positive paddle speed to current X scaled by deltaTime
                player.dx = PLAYER_SPEED
            else
                player.dx = 0
            end
        end
    
        if gameState == 'play' then
           
        --Spawns a new rock after 5 seconds and adds to score
        spawntimer = spawntimer - dt
            if spawntimer <= 0 then
                score = score + 1
                spawnRock()
                local leftover = math.abs(spawntimer)
                spawntimer = 5 - leftover
            end
        end

        for i = 1, #rocks do
            local tempRock = rocks[i] 
           
            --If rock collides into player, game ends
            if tempRock:collides(player) and gameState == 'play' then
                --Game Sound
                gameState = 'gameOver'
                sounds['explosion']:play()
                for j = 1, #rocks do
                    local endRock = rocks[j]
                    endRock.dy = 0
                    endRock.dx = 0
                end
                player.dx = 0
                player.dy = 0
            end
            
            --Collide with sides of screen
            if tempRock.x <= 0 then
                tempRock.x = 0
                tempRock.dx = -tempRock.dx
                sounds['rock']:play()
            end
            if tempRock.x >= VIRTUAL_WIDTH - tempRock.width then
                tempRock.x = VIRTUAL_WIDTH - tempRock.width 
                tempRock.dx = -tempRock.dx
                sounds['rock']:play()
            end
            if tempRock.y <= 0 then
                tempRock.y = 0
                tempRock.dy = -tempRock.dy

                tempRock.bounce = tempRock.bounce * 1.03
                tempRock.dx = math.random(-200,200)
                sounds['rock']:play()
            end
            if tempRock.y >= VIRTUAL_HEIGHT - tempRock.height then
                tempRock.y = VIRTUAL_HEIGHT - tempRock.height
                tempRock.dy = -tempRock.dy
                sounds['rock']:play()
            end

            tempRock:update(dt)
        end
        
        
        --Update state of player
        player:update(dt)
end


--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    love.graphics.clear(179/225, 135/225, 82/225, 225/225)

    if gameState == 'start' then
        love.graphics.printf('Press Enter to Start', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'gameOver' then
        love.graphics.printf("Final Score " .. score, 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Score " .. score, 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- Render player
    player:render()

    -- Render Falling Rocks
    for i = 1, #rocks do
        local tempRock = rocks[i] 
        tempRock:render()
    end

    displayFPS()

    -- end rendering at virtual resolution
    push:apply('end')
end

-- Spawns a new rock object
function spawnRock()
    local randPosX = math.random(-VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2)
    local randPosY = math.random(-VIRTUAL_HEIGHT/16, VIRTUAL_HEIGHT/16)
    local randSize = math.random(0, 50)
    local newRock = Rock(VIRTUAL_WIDTH / 2 - 5 + randPosX - randSize/2, VIRTUAL_HEIGHT / 32 * 4 + randPosY - randSize/2, 10 + randSize, 10 + randSize)
    table.insert(rocks,newRock)
end

function reset()
    rocks = {}
    gameState = 'start'
    spawntimer = 1
    score = 0
    --love.graphics.clear(179/225, 135/225, 82/225, 225/225)

end

-- Displays FPS at top-right corner
function displayFPS()
    --love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.resize(w, h)
    push:resize(w, h)
end