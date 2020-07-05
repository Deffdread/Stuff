--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.tileVar = {}
    self.level = level
    self:initializeTiles()
end

function Board:initializeTiles()
    
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.min(6,math.random(self.level))))
        end
    end

    while self:calculateMatches() and self:legalBoard() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()

        --Always cconstruct a board with atleast one playable moves
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}
    local tileVar = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color
        local hasPowerup = self.tiles[y][1].powerup

        matchNum = 1

        -- every horizontal tile
        for x = 2, 8 do
            
            if self.tiles[y][x].powerup then
                hasPowerup = true
            end
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1

                if matchNum == 3 and hasPowerup then --destroy entire row regardless
                    local match = {}
                    for x3 = 1, 8 do
                        table.insert(match, self.tiles[y][x3])
                        table.insert(tileVar, self.tiles[y][x3].variety)
                    end
                    table.insert(matches, match)
                    break
                end
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color
                hasPowerup = self.tiles[y][x].powerup
                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        table.insert(tileVar, self.tiles[y][x2].variety)
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                table.insert(tileVar, self.tiles[y][x].variety)
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color
        local hasPowerup = self.tiles[1][x].powerup

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do

            if self.tiles[y][x].powerup then
                hasPowerup = true
            end

            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
                if matchNum == 3 and hasPowerup then --destroy entire column regardless
                    local match = {}
                    for y3 = 1, 8 do
                        table.insert(match, self.tiles[y3][x])
                        table.insert(tileVar, self.tiles[y3][x].variety)
                    end
                    table.insert(matches, match)
                    break
                end
            else
                colorToMatch = self.tiles[y][x].color
                hasPowerup = self.tiles[y][x].powerup
                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        table.insert(tileVar, self.tiles[y2][x].variety)
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                table.insert(tileVar, self.tiles[y][x].variety)
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches
    self.tileVar = tileVar

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
    self.tileVar = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(18), math.min(6,math.random(self.level)))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:legalBoard()
    for y = 1,8 do
        for x = 1,8 do

            if y == 1 or y == 2 then --Top edge case, swap up

            else --Proceed normally
               self:swap(x,y,x,y-1)
                if self:calculateMatches() then
                    self:swap(x,y,x,y-1)
                    return true
                else
                    self:swap(x,y,x,y-1)
                end
            end

            if y == 8 or y == 7 then --Bottom edge case, swap down

            else
                self:swap(x,y,x,y+1)
                if self:calculateMatches() then
                    self:swap(x,y,x,y+1)
                    return true
                else
                    self:swap(x,y,x,y+1)
                end
            end

            if x == 1 or x == 2 then --Left edge case, swap left

            else
                self:swap(x,y,x-1,y)
                if self:calculateMatches() then
                    self:swap(x,y,x-1,y)
                    return true
                else
                    self:swap(x,y,x-1,y)
                end
            end

            if x == 8 or x == 7 then --Right edge case, swap right

            else
                self:swap(x,y,x+1,y)
                if self:calculateMatches() then
                    self:swap(x,y,x+1,y)
                    return true
                else
                    self:swap(x,y,x+1,y)
                end
            end
        end
    end
    return false
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end

function Board:swap(x1,y1,x2,y2)
    local tempTiles = self.tiles
    

    local oldTile = tempTiles[y1][x1]
    local newTile = tempTiles[y2][x2]

    local oldTileGridX = tempTiles[y1][x1].gridX
    local oldTileGridY = tempTiles[y1][y1].gridY
    local newTileGridX = tempTiles[y2][x2].gridX
    local newTileGridY = tempTiles[y2][x2].gridY
    local oldTileX = tempTiles[y1][x1].x
    local oldTileY = tempTiles[y1][x1].y
    local newTileX = tempTiles[y2][x2].x
    local newTileY = tempTiles[y2][x2].y

    --Swap grid
    oldTile.gridX = newTileGridX
    oldTile.gridY = newTileGridY
    newTile.gridX = oldTileGridX
    newTile.gridY = oldTileGridY

    --Swap screen coords
    oldTile.x = newTileX
    oldTile.y = newTileY
    newTile.x = oldTileX
    newTile.y = oldTileY


    tempTiles[y1][x1] = newTile
    tempTiles[y2][x2] = oldTile
end