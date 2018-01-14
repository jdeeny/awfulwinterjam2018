local ElecNode = class("ElecNode")

function ElecNode:initialize()
  self.charge = 0.0
  self.autocharge = 0.0
end

function ElecNode:update(dt)
  self:addCharge(self.autocharge * dt)
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

return ElecNode
