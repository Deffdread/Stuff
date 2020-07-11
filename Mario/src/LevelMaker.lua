--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local keyGen = false --Is key and lock generated yet?
    local lockGen = false
    local poleGen = false



    local flag = GameObject {
        texture = 'flag',
        --x = (x - 1) * TILE_SIZE,
        --y = (6 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        frame = 8,
        collidable = false,
        consumable = false,
        solid = false,
        inPlay = false

    }

    local pole = GameObject {
        texture = 'pole',
        --x = (x - 1) * TILE_SIZE,
        --y = (6 - 1) * TILE_SIZE,
        width = 16,
        height = 64,
        frame = 1,
        collidable = true,
        consumable = false,
        solid = false,
        objRef = flag,
        inPlay = false,

        -- Obtain key
        onCollide = function(player, object)
            if object.inPlay == true then
                gSounds['pickup']:play()
                object.collidable = false
                Timer.tween(1, {
                    [object.objRef] = {y = object.y + 2 * TILE_SIZE}
                }):finish(function() 
                    gStateMachine:change('play', {
                        score = player.score
                    })
                end)
            end
        end
    }

    local lock = GameObject {
        texture = 'keyLocks',
        --x = (x - 1) * TILE_SIZE,
        --y = (6 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        frame = 5,
        collidable = false,
        consumable = false,
        solid = true,
        objRef = pole,
        objRef2 = flag,
        inPlay = true,

        -- Unlock
        onConsume = function(player, object)
            gSounds['pickup']:play()
            player.score = player.score + 50
            object.objRef.inPlay = true
            object.objRef2.inPlay = true
        end,

        onCollide = function(obj)
            gSounds['empty-block']:play()
        end

        }

    local key = GameObject {
        texture = 'keyLocks',
        --x = (x - 1) * TILE_SIZE,
        --y = (6 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        objRef = lock,
        inPlay = true,

        -- Obtain key
        onConsume = function(player, object)
            gSounds['pickup']:play()
            player.score = player.score + 50
            object.objRef.consumable = true
            object.objRef.solid = false
        end
    }

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end

           
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(20) == 1 and keyGen == false and lockGen == true or x == 90 and keyGen == false then --Generate key, if it hasn't ensure it generates on the 50th column
                key.x = (x - 1) * TILE_SIZE
                key.y = (blockHeight - 1) * TILE_SIZE
                table.insert(objects,key)
                keyGen = true
            
            elseif  math.random(20) == 1 and lockGen == false or x == 50 and lockGen == false then --Lock generate
                lock.x = (x - 1) * TILE_SIZE
                lock.y = (blockHeight - 1) * TILE_SIZE
                table.insert(objects, lock)
                lockGen = true

            elseif  math.random(20) == 1 and poleGen == false and keyGen == true or x == 98 and poleGen == false then --Pole generate
                pole.x = (x - 1) * TILE_SIZE
                pole.y = (blockHeight - 1) * TILE_SIZE
                table.insert(objects, pole)

                flag.x = (x - 1) * TILE_SIZE + TILE_SIZE/2
                flag.y = (blockHeight - 1) * TILE_SIZE
                table.insert(objects, flag)

                poleGen = true

            elseif math.random(10) == 1 then --special block
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,
                        inPlay = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
                                        inPlay = true,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end