
require 'Dependencies'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

SPEED = 0
SCALING_FACTOR = 0.5
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    love.window.setTitle('Starfield')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.graphics.setBackgroundColor(0,0,0,0)

    stars = {}
    for i=1,200 do
        table.insert(stars, Star())
    end
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    for k,star in pairs(stars) do
        star:update()
    end

    SPEED = (math.sqrt((love.mouse.getX()-VIRTUAL_WIDTH/2)^2 + (love.mouse.getY()-VIRTUAL_HEIGHT/2)^2))^SCALING_FACTOR --Speed is based off of distance of mouse from center. Scaling factor to scale down.
    print(SPEED)

end


function love.draw()
    push:apply('start')
    love.graphics.translate(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2)
    for k,star in pairs(stars) do
        star:render()
    end

    push:apply('end')
end