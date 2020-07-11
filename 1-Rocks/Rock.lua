--[[
    Rocks
    -- Player Class --

    Author: Jason Tsui

    Represents the player that can move up, down, left, and right. Used in the main
    program to dodge rocks.
]]

Rock = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Rock:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 200
    self.dx = 0
    self.bounce = 1
end

function Rock:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt * self.bounce)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt * self.bounce)
    end

    if self.dx < 0 then
        self.x = math.max(0,self.x + self.dx * dt * self.bounce)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt * self.bounce)
    end
end

function Rock:collides(player)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end 

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Rock:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end