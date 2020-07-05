
Star = Class{}

function Star:init()
    --star old positon
    self.x = math.random(-VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2) + math.random() --divide dimensions by 2 because ellipses drawn from center position
    self.y = math.random(-VIRTUAL_HEIGHT/2, VIRTUAL_HEIGHT/2) + math.random()
    self.z = math.random(VIRTUAL_WIDTH/2) + math.random() --Distance from viewer
    self.r = nil -- star radius

    --star current positon
    self.sx = nil
    self.sy = nil
    self.sz = self.z

    --star trail
    self.pz = self.z
    self.oldFrame = 0 --counter to update self.pz, used for drawing line to previous location (2 frames ago)
    self.px = nil
    self.py = nil
end


function Star:update()
    --star
    self.sx = self.x/self.sz * VIRTUAL_WIDTH/2 --Scale star x with z
    self.sy = self.y/self.sz * VIRTUAL_HEIGHT/2 --Scale star y with z
    self.r = 0.5 * self.z/self.sz --Scale star size 

    --trail
    self.px = self.x/self.pz * VIRTUAL_WIDTH/2 
    self.py = self.y/self.pz * VIRTUAL_HEIGHT/2 



    self.sz = self.sz - SPEED  --nearer stars are "faster". Determined by mouse position

    if self.sz < 1 then --self.sx > VIRTUAL_WIDTH or self.sx < 0 or self.sy > VIRTUAL_HEIGHT or self.sy < 0 then --reset star
        self.x = math.random(-VIRTUAL_WIDTH/2, VIRTUAL_WIDTH/2) + math.random()
        self.y = math.random(-VIRTUAL_HEIGHT/2, VIRTUAL_HEIGHT/2) + math.random()
        self.s = math.random(VIRTUAL_WIDTH/2) + math.random()
        self.sz = self.z
        self.pz = self.z
    end


    --length of trail
    if self.oldFrame == 2 then
        self.pz = self.sz
        self.oldFrame = 0
    else        
        self.oldFrame = self.oldFrame + 1
    end
    
end


function Star:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 1)
    love.graphics.ellipse("fill", self.sx, self.sy, self.r, self.r) 
    love.graphics.line(self.sx, self.sy, self.px, self.py)
end