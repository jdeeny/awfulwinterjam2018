local Item = class("Item")

function Item:on_equipped(owner)
    self.equipped = true
    self.owner = owner
end

function Item:on_unequipped()
    self.equipped = false
end

function Item:pick_up(owner)
    self.owner = owner
end

function Item:drop()
    self.owner = nil
end

function Item:draw()
    if not self.owner and self.sprite then
        if self.x and self.y then
            love.graphics.draw(self.sprite, camera.view_x(self), 
                camera.view_y(self), 0, 1, 1, self.sprite:getWidth()/2, 
                self.sprite:getHeight()/2)
        end
    end
end

function Item:update(dt)
    
end

local item = {}

item.Item = Item

function item.spawn(item, x, y)
    local new_id = idcounter.get_id("item")

    items[new_id] = item
    items[new_id].id = new_id
    items[new_id].x = x
    items[new_id].y = y

    return new_id
end

-- pull it out of the dungeon
function item.unspawn(item)
    items[item.id] = nil
    return item
end

return item