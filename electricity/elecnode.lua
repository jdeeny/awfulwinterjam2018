local ElecNode = class("ElecNode")

function ElecNode:initialize(x, y)
  self.sim = electricity --hardcoded for simplicity
  self.x = x
  self.y = y
  self.charge = 0.0
  self.autocharge = 0.0
  self.arcs = 0.5 -- average arcs per second
end

function ElecNode:update(dt)
  self:addCharge(self.autocharge * dt)
  if math.random() < self.arcs * dt then
    self:attemptArc()
  end
end

function ElecNode:addCharge(credit)
  self.charge = self.charge + credit
end

function ElecNode:spendCharge(debit)
  self.charge = self.charge - debit
end

function ElecNode:setAutocharge(chargepersec)
  self.autocharge = chargepersec
  return self
end

function ElecNode:nodesinradius(radius)
  return self.sim:nodesincircle(self.x, self.y, radius)
end


-- Try to find a nearby node to arc to
function ElecNode:attemptArc()
  local nodes = self:nodesinradius(radius)
  if #nodes > 0 then
    local target = nodes[math.random(#nodes)]
  else
    return
  end
end


return ElecNode
