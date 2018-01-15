-- local folderOfThisFile = (...):match("(.-)[^%/%.]+$")

math = require 'math'

class = require('lib/middleclass/middleclass')
vector = require('lib/hump.vector')
fx = require('effects/fx')

-------------------------------------------------------------------------------
local LightningVertex = class('LightningVertex')

function LightningVertex:initialize(vec)
    self.vec = vec
    self.is_fork_root = false
    self.fork = nil
end

function LightningVertex:createFork(fork_vec)
    self.fork = {
        LightningVertex:new(self.vec),
        LightningVertex:new(self.vec+fork_vec)
    }
    self.is_fork_root = true
end

-------------------------------------------------------------------------------
LoveLightning = class("LoveLightning")

function LoveLightning:initialize(r,g,b,power)
    if power ~= nil then self.power = power else self.power = 1.0 end
    self.jitter_factor = 0.5
    self.fork_chance = 0.25
    self.max_fork_angle = math.pi/4
    self.color = {['r']=r,['g']=g,['b']=b}
end

function LoveLightning:setPrimaryTarget(targ)
    if targ.x ~= nil and targ.y ~= nil then
        self.target = vector(targ.x, targ.y)
    end
end

function LoveLightning:setSource(source)
    if source.x ~= nil and source.y ~= nil then
        self.source = vector(source.x,source.y)
    end
end

function LoveLightning:setForkTargets(targets)
    local targs = {}
    for _, t in ipairs(targets) do
        if t.x and t.y then
            table.insert(targs,t)
        end
    end
    self.fork_targets = targets
end

function LoveLightning:_add_jitter(vertices, max_offset, level)
    local newpath = {}

    for j = 1, #vertices-1, 1 do
        
        local vsp = vertices[j].vec      -- start point
        local vep = vertices[j+1].vec    -- end point
        local vmp = (vep+vsp)/2             -- mid point
        local vseg = vep-vsp
        local vnorm = vseg:perpendicular():normalized()
        
        local voffset = (math.random()*2-1)*max_offset*vnorm
    
        table.insert(newpath, vertices[j])
        
        local lvmp = LightningVertex(vmp+voffset)

        -- chance to create a fork from the midpoint
        if math.random() < self.fork_chance then

            -- look for a fork target in the direction of the fork
            local vfork = (vep-lvmp.vec):rotated(
                math.random()*2*self.max_fork_angle-self.max_fork_angle)

            if self.fork_targets and #self.fork_targets>0 then
                for i, t in pairs(self.fork_targets) do
                    if t.x ~= nil and t.y ~= nil then
                        
                        local vt = vector(t.x, t.y)
                        print(vt,vmp,vfork)
                        
                        if math.abs(vfork.angleTo(vt-vmp)) < self.max_fork_angle then --and 
                        --         vmp.dist(vt) < self.distance/level then

                            vfork = vt
                            if self.fork_hit_handler then
                                print("calling fork hit handler")
                                self.fork_hit_handler(t,level)
                            end
                            break
                        end
                    end
                end
            end

            lvmp:createFork(vfork)
        end

        table.insert(newpath, lvmp)

        -- if the start point is a fork, then add jitter to the fork
        if vertices[j].is_fork_root == true then
            vertices[j].fork = self:_add_jitter(vertices[j].fork, max_offset, level+1)
        end

    end
    table.insert(newpath, vertices[#vertices])
    
    return newpath
end

function LoveLightning:create( fork_hit_handler )

    self.fork_hit_handler = fork_hit_handler

    local vsource = vector(self.source.x, self.source.y)
    local vtarget = vector(self.target.x, self.target.y)
    
    self.vertices = {
        LightningVertex:new(vsource),
        LightningVertex:new(vtarget)
    }

    self.distance = (vtarget-vsource):len()
    local max_jitter = self.distance*0.5*self.jitter_factor
    local iterations = math.max(4,math.floor(self.distance/50)) 

    for i = 1, iterations, 1 do
        
        self.vertices = self:_add_jitter(self.vertices, max_jitter, 1)

        max_jitter = max_jitter/2
    end
end

function LoveLightning:update(dt)

end

local function draw_path(vertex_list, color, alpha, width)
    -- get points from vertex list
    local points = {}
    for _, v in ipairs(vertex_list) do
        table.insert(points, v.vec.x)
        table.insert(points, v.vec.y)
    end

    love.graphics.setLineJoin('miter')
    love.graphics.setLineWidth(width)
    love.graphics.setColor(color['r'], color['g'], color['b'], alpha)
    love.graphics.line(unpack(points))
    love.graphics.setColor(255,255,255)

    for _, v in ipairs(vertex_list) do
        if v.is_fork_root then
            draw_path(v.fork, color, alpha*0.5, width-1)
        end
    end
end

function LoveLightning:draw()
    if self.vertices then

        local restore_mode = love.graphics.getBlendMode()
        local restore_canvas = love.graphics.getCanvas()
    
        local canvas = love.graphics.newCanvas()
        love.graphics.setCanvas(canvas)

        draw_path(self.vertices, self.color, 32*self.power, 17*self.power)
        draw_path(self.vertices, self.color, 64*self.power, 7*self.power)
        draw_path(self.vertices, self.color, 128*self.power, 5*self.power)

        canvas = fx.blur(canvas)

        love.graphics.setCanvas(restore_canvas)

        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(canvas,0,0)
        love.graphics.setBlendMode(restore_mode)

        draw_path(self.vertices, self.color, 255*self.power, 2*self.power)

    end
end

return LoveLightning
