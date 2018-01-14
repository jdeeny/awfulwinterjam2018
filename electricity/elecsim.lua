local ElectricSim = class("ElectricSim")

function ElectricSim:initialize()
  self.nodes = {}
  self.count = 0
end

function ElectricSim:addNode(node)
  self.count = self.count + 1
  self.nodes[self.count] = node
  node.id = self.count
  return self.count
end

function ElectricSim:removeNode(node)
  self.nodes[node.id] = nil
end

return ElectricSim
