local ElecNode = class("ElecNode")

function ElecNode:initialize()
  self.charge = 0.0
  self.auto_charge = 0.0
end

function ElecNode:update(dt)
  self:addCharge(self.auto_charge * dt)
end

function ElecNode:addCharge(credit)
  self.charge = self.charge + credit
end

function ElecNode:spendCharge(debit)
  self.charge = self.charge - debit
end

return ElecNode
