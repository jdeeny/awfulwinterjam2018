local ElecNode = class("ElecNode")

function ElecNode:initialize()
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

-- Try to find a nearby node to arc to
function ElecNode:attemptArc()
  for id, n in electricity.nodes , electricityfindNearby
end


return ElecNode
