item_data = {}

function item_data.spawn(kind, x, y)
    local new_id = idcounter.get_id("item")
    
    local itm = item.Item:new()

    itm.id = new_id
    itm.x = x
    itm.y = y

    for j, v in pairs(item_data[kind]) do
        itm[j] = v
    end
    
    items[new_id] = itm
end

function item_data.destroy(id)
    items[id] = nil
end

item_data['health_pack'] = 
{
    radius = 30,
    health_bonus = 25,
    pick_up = function(self, owner)
            if owner.heal then
                owner:heal(self.health_bonus)
            end
            item_data.destroy(self.id)
        end,
    sprite = image.heart,
}

item_data['damage_mult'] = 
{
    radius = 30,
    damage_mult = 1.2,
    pick_up = function(self, owner)
            if owner.equipped_items['weapon'].damage then
                player.equipped_items['weapon'].damage = 
                    player.equipped_items['weapon'].damage * self.damage_mult
            end
            -- special bonus for lightnning gun
            if owner.equipped_items['weapon'].chain_targets then
                player.equipped_items['weapon'].chain_targets = 
                    player.equipped_items['weapon'].chain_targets + 1
            end

            item_data.destroy(self.id)

        end,
    sprite = image.patent_icon,
}

item_data['max_ammo_increase'] = 
{
    radius = 30,
    ammo_increase = 100,
    pick_up = function(self, owner)
            if owner.equipped_items['weapon'].max_ammo then
                player.equipped_items['weapon'].max_ammo = 
                    player.equipped_items['weapon'].max_ammo + self.ammo_increase
            end
            item_data.destroy(self.id)
        end,
    sprite = image.patent_icon,
}

item_data['max_health_increase'] = 
{
    radius = 30,
    hp_increase = 50,
    pick_up = function(self, owner)
            if owner.max_hp then
                player.max_hp = player.max_hp + self.hp_increase
            end
            item_data.destroy(self.id)
        end,
    sprite = image.patent_icon,
}

item_data['charge_rate_mult'] = 
{
    radius = 30,
    rate_mult = 1.25,
    pick_up = function(self, owner)
            if owner.equipped_items['weapon'].charge_rate then
                player.equipped_items['weapon'].charge_rate = 
                    player.equipped_items['weapon'].charge_rate + self.rate_mult
            end
            item_data.destroy(self.id)
        end,
    sprite = image.patent_icon,
}


return item_data