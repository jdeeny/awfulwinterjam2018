item_data = {}

function item_data.spawn(item, x, y)
    local new_id = idcounter.get_id("item")

    items[new_id] = item
    items[new_id].id = new_id
    items[new_id].x = x
    items[new_id].y = y

    return new_id
end

function item_data.destroy(id)
    items[id] = nil
end