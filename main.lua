-- Requires
local vec2 = require("vec2")

-- Init Global Variables

local launchedcirle = false
local gameover = false
local winningText = ""

local window = vec2(love.graphics.getWidth(), love.graphics.getHeight())

local entity = {
    lBlock = 
    { 
        pos = vec2(0, window.y / 2 - 135 / 2), 
        st = vec2(0, window.y / 2 - 135 / 2),
        size = vec2(15, 135) 
    },

    rBlock = 
    { 
        pos = vec2(window.x - 15, window.y / 2 - 135 / 2), 
        st = vec2(window.x - 15, window.y / 2 - 135 / 2),
        size = vec2(15, 135) 
    },


    circle = 
    { 
        pos = vec2(window.x / 2 - 15, window.y / 2 - 15), 
        st = vec2(window.x / 2 - 15, window.y / 2 - 15),
        radius = 15,
        velocity = vec2()
    }
}


--User function

local function aabb(pos1, size1, pos2, size2)
    local overlapX = pos1.x < pos2.x + size2.x and pos1.x + size1.x > pos2.x
    local overlapY = pos1.y < pos2.y + size2.y and pos1.y + size1.y > pos2.y
    
    return overlapX and overlapY
end


local function managmentBlocks(dt, speed)
    if love.keyboard.isDown("up") and entity.lBlock.pos.y >= 0 then 
        entity.lBlock.pos = entity.lBlock.pos - vec2(0, speed * dt) 
    end
    
    if love.keyboard.isDown("down") and (window.y >= (entity.lBlock.pos.y + entity.lBlock.size.y)) then 
        entity.lBlock.pos = entity.lBlock.pos + vec2(0, speed * dt) 
    end

    if love.keyboard.isDown("w") and entity.rBlock.pos.y >= 0 then 
        entity.rBlock.pos = entity.rBlock.pos - vec2(0, speed * dt) 
    end
    
    if love.keyboard.isDown("s") and (window.y >= (entity.rBlock.pos.y + entity.rBlock.size.y)) then 
        entity.rBlock.pos = entity.rBlock.pos + vec2(0, speed * dt) 
    end
end


local function managmentCirle(dt, speed)
    
    if not launchedcirle and not gameover then

        math.randomseed(love.timer.getTime() * 2)

        local angle = math.random() * 2 * math.pi
        local directionForce = vec2(math.sin(angle), math.cos(angle))


        entity.circle.velocity = directionForce * speed
       
        launchedcirle = true
    end

    if launchedcirle and not gameover then

        entity.circle.pos = entity.circle.pos + entity.circle.velocity * dt

        if entity.circle.pos.y + 15 <= 0 or entity.circle.pos.y + 15 >= window.y then
            entity.circle.velocity.y = -entity.circle.velocity.y - 10
            entity.circle.velocity.x = entity.circle.velocity.x - 5
        end

        if aabb(entity.lBlock.pos, entity.lBlock.size, entity.circle.pos, vec2(entity.circle.radius * 1.8, entity.circle.radius * 1.8)) then
            entity.circle.velocity.x = -entity.circle.velocity.x
            entity.circle.velocity.y = entity.circle.velocity.y - 15 * math.random(-1, 1)
        end

        if aabb(entity.rBlock.pos, entity.rBlock.size, entity.circle.pos, vec2(entity.circle.radius * 1.8, entity.circle.radius * 1.8)) then
            entity.circle.velocity.x = -entity.circle.velocity.x
            entity.circle.velocity.y = entity.circle.velocity.y - 15 * math.random(-1, 1)
        end

        if entity.circle.pos.x + 15 >= window.x then
            winningText = "Left Block Win"
            gameover = true
        end

        if entity.circle.pos.x + 15 < 0 then
            winningText = "Right Block Win"
            gameover = true
        end


    end
end




--Love2D function

function love.draw()
    if not gameover then
        love.graphics.rectangle("fill", entity.lBlock.pos.x, entity.lBlock.pos.y, entity.lBlock.size.x, entity.lBlock.size.y)
        love.graphics.rectangle("fill", entity.rBlock.pos.x, entity.rBlock.pos.y, entity.rBlock.size.x, entity.rBlock.size.y)

        love.graphics.circle("fill", entity.circle.pos.x, entity.circle.pos.y, entity.circle.radius)
    end
    if gameover then
        love.graphics.setColor(1, 1, 1)  
        love.graphics.print(winningText, window.x / 2.5, window.y / 2, 0, 1, 1, 0, 0) 
        love.graphics.print("Restart Game press R", window.x / 2.5, window.y / 2 + 15, 0, 1, 1, 0, 0) 
    end
end


function love.update(dt) 

    managmentBlocks(dt, 250)
    managmentCirle(dt, 250)

    if gameover and love.keyboard.isDown("r") then
        entity.circle.pos = entity.circle.st 
        entity.lBlock.pos = entity.lBlock.st
        entity.rBlock.pos = entity.rBlock.st
        gameover = false
        launchedcirle = false
    end
end






