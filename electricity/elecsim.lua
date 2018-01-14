local ElectricSim = class("ElectricSim")

function ElectricSim:initialize()
  self.nodes = {}
  self.count = 0


  local n1 = TileElecNode:new(image['chargemap'], 50, 50):setAutocharge(0.5)
  local n2 = TileElecNode:new(image['chargemap'], 150, 150):setAutocharge(-0.5)

  self:addNode(n1)
  self:addNode(n2)
end

function ElectricSim:update(dt)
  for _, n in pairs(self.nodes) do
    n:update(dt)
  end
end

function ElectricSim:addNode(node)
  self.count = self.count + 1
  self.nodes[self.count] = node
  node.id = self.count
  return self
end

function ElectricSim:removeNode(node)
  self.nodes[node.id] = nil
end

function ElectricSim:nodesincircle(x, y, radius)
  local p1 = cpml.vec2:new(x, y)
  local nodes = {}
--[[  for id, n in pairs(self.nodes) do
    local p2 = cpml.vec2:new(n.x, n.y)
    if p1:dist(p2) <= radius then
      nodes[id] = n
    end
  end
]]
  return nodes
end


function ElectricSim.chargetodist(charge)
  return charge * 10
end


return ElectricSim
