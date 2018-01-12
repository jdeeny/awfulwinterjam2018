local Item = class("Item")

function Item:equipped(owner)
    self.owner = owner
end

function Item:uneqipped()
    self.owner = nil
end

item = {}
item.Item = Item

return item