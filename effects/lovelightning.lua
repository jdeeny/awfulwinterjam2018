-- local folderOfThisFile = (...):match("(.-)[^%/%.]+$")

math = require 'math'

class = require 'lib/middleclass/middleclass'
local vec = require 'lib/hump.vector-light'

local vertex = {}

local vertex_id_counter = 0

function vertex.new()
    vertex_id_counter = vertex_id_counter+1
    return {x=0, y=0, last=nil, next=nil, fork=nil, 
        id=vertex_id_counter}
end

function vertex.break_links(vrtx)
    vrtx.last=nil
    vrtx.next=nil
    vrtx.fork=nil
    return vrtx
end 

function vertex.clear(vrtx)
    vrtx.x=0
    vrtx.y=0
    vertex.break_links(vrtx)
    return vrtx
end

function vertex.insert_fork(from_this, fork_this)
    if fork_this.last then print("Cannot fork to vertex with last") return end
    from_this.fork = fork_this
    fork_this.last = from_this
end

-- inserts X after A
function vertex.insert_after(A, X)
    X.next = A.next
    if X.next then X.next.last = X end
    A.next = X
    X.last = A
end

function vertex.insert_before(B, X)
    X.last = B.last
    if X.last.next == B then
        X.last.next = X
    elseif X.last.fork == B then
        X.last.fork = X
    end
    X.next = B
    B.last = X
end

vertex.pool = {}

function vertex.pool.new(size)
    local noo_poo = {}
    for i=1,size do
        table.insert(noo_poo, vertex.new())
    end
    return noo_poo
end

function vertex.pool.get(from_pool)
    local this = from_pool[#from_pool]
    from_pool[#from_pool] = nil
    if this then return this else return vertex.new() end
end

function vertex.pool.put(to_pool, this)
    -- also put it's children back in the pool
    if this.fork then vertex.pool.put(to_pool, this.fork) end
    if this.next then vertex.pool.put(to_pool, this.next) end
    
    if this.last and this.last.next == this then
        -- this is a next of last
        this.last.next = nil
    elseif this.last and this.last.fork == thes then
        -- this is a fork of last
        this.last.fork = nil
    end
    to_pool[#to_pool+1] = vertex.clear(this)
end

-------------------------------------------------------------------------------
LoveLightning = class("LoveLightning")

function LoveLightning:initialize(r,g,b,power)
    if power ~= nil then self.power = power else self.power = 1.0 end
    self.displacement_factor = 0.5
    self.fork_chance = 0.75
    self.max_fork_angle = math.pi/4
    self.color = {['r']=r,['g']=g,['b']=b}

    self.max_fork_depth = 1000000 -- can probably get removed eventually
    self.max_forks = 1000000 -- same
    self.max_iterations = 11
    self.min_iterations = 5
    self.min_seg_len = 3

    -- vertex shit
    self.vpool = vertex.pool.new(1000)
    self.source_vertex = vertex.new()
    self.target_vertex = vertex.new()
end

function LoveLightning:setPrimaryTarget(targ)
    if targ.x ~= nil and targ.y ~= nil then
        self.target_vertex.x = targ.x
        self.target_vertex.y = targ.y
    end
end

function LoveLightning:setSource(source)
    if source.x ~= nil and source.y ~= nil then
        self.source_vertex.x = source.x
        self.source_vertex.y = source.y
    end
end

function LoveLightning:setForkTargets(targets)
    if targets then
        local targs = {}
        for _, t in ipairs(targets) do
            if t.x and t.y then
                table.insert(targs,t)
            end
        end
        self.fork_targets = targs
    else
        self.fork_targets = {}
    end
end

-- Creates a new vertex that's a displaced midpoint between A and B
function LoveLightning:_displace_midpoint(A, B, max_offset)
    assert(B.last == A)

    -- check if B is a fork of A
    local is_fork = false; if A.fork == B then is_fork = true end

    M = vertex.pool.get(self.vpool)

    -- offset the midpoint along a line perpendicular to the line segment
    -- from start to end a random ammount from -max_offset to max_offset
    M.x, M.y = vec.normalize(vec.perpendicular(vec.sub(B.x, B.y, A.x, A.y)))
    M.x, M.y = vec.mul(max_offset*(math.random()*2-1), M.x, M.y)
    M.x, M.y = vec.add(M.x, M.y, vec.mul(0.5, vec.add(A.x, A.y, B.x, B.y)))
    
    if is_fork then
        vertex.insert_before(B, M)
    else
        vertex.insert_after(A, M)
    end

    return M
end

-- takes the segment defined from A to A.next, and rotates it a random
-- amount to create a fork from A. When forking, if targets are given
-- a target will be selected and hit, in this case, the fork segment will go 
-- from A to the target
function LoveLightning:_fork(A, targets, target_hit_handler, level)
    local selected_target = nil
    local index = nil
    
    local F = vertex.pool.get(self.vpool)

    -- generate the fork from the second segment buy randomly rotating
    F.x, F.y = vec.sub(A.next.x, A.next.y, A.x, A.y)
    F.x, F.y = vec.rotate((math.random()-0.5)*2*self.max_fork_angle, F.x, F.y)
    
    -- can that fork hit a potential target?
    if targets then
        for i, t in ipairs(targets) do
            -- if the target is in the fork firing arc and is in range,
            -- set the fork vector to the target vector
            if vec.angleTo(t.x, t.y, F.x, F.y) < self.max_fork_angle/2 and 
                    vec.dist(A.x, A.y, t.x, t.y) < vec.len(F.x, F.y) then
                F.x, F.y  = t.x, t.y
                
                selected_target = t
                index = i
                
                table.remove(targets, i)
                break
            end
        end
    end
    
    if selected_target then
        target_hit_handler(selected_target, level)
    else
        F.x, F.y = vec.add(A.x, A.y, F.x, F.y)
    end
    
    vertex.insert_fork(A, F)
    self.num_forks = self.num_forks + 1
    return F
end


-- root : root vertex to start with
-- max_offset : maximum distance to offset the midpoint
-- level : the depth of forking (1 being the main trunk)
-- targets: a list of potential targets for the forks to hit (anything with 
--      an x and a y)
-- target_hit_handler : called when a target is selected for a fork to hit
--      in the form of function(target_hit, level_of_fork_that_hit)
function LoveLightning:_add_displacement(root, max_displacement, level, targets, target_hit_handler)
    if level > self.max_fork_depth then return end

    -- if the root is the start of the fork, add a displaced midpoint between
    -- the last vertext and root
    if root.last and root.last.fork == root then
        self:_displace_midpoint(root.last, root, max_displacement)
    end 

    local vrtx = root
    while vrtx.next do
        local A = vrtx   
        local B = vrtx.next
        local ABx, ABy = vec.sub(B.x, B.y, A.x, A.y)

        if vec.len(ABx, ABy) > 2*self.min_seg_len then
            
            local M = self:_displace_midpoint(A, B, max_displacement)

            -- chance to create a fork from the midpoint
            if not A.fork and self.num_forks < self.max_forks and 
                math.random() < self.fork_chance/(level^2)  then
                
                F = self:_fork(M, targets, target_hit_handler, level+1)                
            end
        end

        -- add displacement to the fork
        if vrtx.fork then
            self:_add_displacement(vrtx.fork, max_displacement, level+1, 
                targets, target_hit_handler)
        end

        vrtx = B
    end
end

local function countIt(vrtx)
    local count = 1
    
    -- print(vrtx.last, vrtx, vrtx.next, vrtx.fork)

    if vrtx.next then
        count = count + countIt(vrtx.next)
    end

    if vrtx.fork then
        count = count + countIt(vrtx.fork)
    end

    return count
end

function LoveLightning:verticeCount()
    return countIt(self.source_vertex)
end

function LoveLightning:generate( fork_hit_handler )

    self.num_forks = 0
    self.fork_hit_handler = fork_hit_handler

    self:clear()

    self.distance = vec.len(vec.sub(self.target_vertex.x, self.target_vertex.y,
        self.source_vertex.x, self.source_vertex.y))

    local max_displacement = self.distance*0.5*self.displacement_factor
    local iterations = math.min(self.max_iterations, math.max(
        self.min_iterations,math.floor(self.distance/50)))

    local iters = 0
    -- iterations = 1
    for i = 1, iterations do
        self:_add_displacement(self.source_vertex, max_displacement, 1, 
            self.fork_targets, fork_hit_handler)
        max_displacement = max_displacement*0.5
    end

    self.canvas = nil -- will trigger a redraw
    self.last_iteration_count = iters -- for debugging
end



function LoveLightning:clear()
    -- break the target vertex off the tree
    if self.target_vertex.last then self.target_vertex.last.next = nil end

    -- put the source's fork and next back in the pool (and their children in tree)
    if self.source_vertex.next then vertex.pool.put(self.vpool, self.source_vertex.next) end
    if self.source_vertex.fork then vertex.pool.put(self.vpool, self.source_vertex.fork) end

    vertex.insert_after(self.source_vertex, self.target_vertex)
end

function LoveLightning:update(dt)

end

local function draw_path(start_vertex, color, alpha, width)
    local points = {} -- list of x and y s of the points of the lines to draw
    
    -- check to see if the start vertex is the start of a fork
    if start_vertex.last and start_vertex.last.fork == start_vertex then
        -- add the point from it's last vertex to start the fork
        points[#points+1] = start_vertex.last.x
        points[#points+1] = start_vertex.last.y
    end

    -- add the start vertex points
    points[#points+1] = start_vertex.x
    points[#points+1] = start_vertex.y

    local vrtx = start_vertex
    while vrtx.next do
        points[#points+1] = vrtx.next.x
        points[#points+1] = vrtx.next.y
        vrtx = vrtx.next
    end

    love.graphics.setLineJoin('miter')
    love.graphics.setLineWidth(width)
    love.graphics.setColor(color['r'], color['g'], color['b'], alpha)
    love.graphics.line(unpack(points))

    love.graphics.setColor(255,255,255)

    local vrtx = start_vertex
    while vrtx.next do
        if vrtx.fork then
            draw_path(vrtx.fork, color, alpha*0.5, width*.5)
        end    
        vrtx = vrtx.next
    end
        
end

function LoveLightning:draw()
    local restore_mode = love.graphics.getBlendMode()
    local restore_canvas = love.graphics.getCanvas()
    
    if self.source_vertex.next then 
        if not self.canvas then
    
            self.canvas = love.graphics.newCanvas()
            love.graphics.setCanvas(self.canvas)

            -- draw_path(self.vertices, self.color, 32*self.power, 17*self.power)
            -- draw_path(self.vertices, self.color, 64*self.power, 7*self.power)
            -- draw_path(self.vertices, self.color, 128*self.power, 5*self.power)

            -- canvas = fx.blur(canvas)

            draw_path(self.source_vertex, self.color, 255*self.power, 2*self.power)


            love.graphics.setCanvas(restore_canvas)
        end

        if self.canvas then
            love.graphics.setBlendMode("alpha", "premultiplied")
            love.graphics.draw(self.canvas,0,0)
            love.graphics.setBlendMode(restore_mode)
        end
    end
end

return LoveLightning
