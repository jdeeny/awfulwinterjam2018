local hud = {}

hud.font = love.graphics.newFont('assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50)

hud.arrows = {}
hud.arrow_alpha_max = 192
hud.arrow_alpha_min = 16
hud.arrow_alpha = hud.arrow_alpha_min -- set to max if flash is disabled
hud.pulse_time = 0.9

hud.top_margin = 15

function hud.draw_arrows()
	local r,g,b,a
	local yc = image['point_yellow']:getHeight()/2
	local xc = image['point_yellow']:getWidth()/2

	r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(r,g,b,hud.arrow_alpha)

	local dir
	local distance = math.max(100, math.min(window.w/2 - 100, window.h/2 - 100)) + 20 * math.cos(6.9813 * gui_time)
	if hud.arrows['up'] then
		dir = math.atan2(-4 * TILESIZE - player.y, (current_level:pixel_width() / 2) - player.x)
		love.graphics.draw(image['point_yellow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['right'] then
		dir = math.atan2((current_level:pixel_height() / 2) - player.y, current_level:pixel_width() + 4 * TILESIZE - player.x)
		love.graphics.draw(image['point_yellow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['left'] then
		dir = math.atan2((current_level:pixel_height() / 2) - player.y, -4 * TILESIZE - player.x)
		love.graphics.draw(image['point_yellow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['down'] then
		dir = math.atan2(current_level.pixel_height() + 4 * TILESIZE - player.y, (current_level:pixel_width() / 2) - player.x)
		love.graphics.draw(image['point_yellow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	-- restore previous draw settings
	love.graphics.setColor(r,g,b,a)
end

-- loops from max to min, repeating unless arrows are not needed (can be stopped elsewhere)
function hud.flash_arrows()
	if next(hud.arrows) == nil then
		return
	else
		hud.arrow_tween = game_flux.to(hud, hud.pulse_time, {arrow_alpha = hud.arrow_alpha_max}):ease("backinout")
		hud.arrow_tween:after(hud, hud.pulse_time, {arrow_alpha = hud.arrow_alpha_min})
		hud.arrow_tween:oncomplete(hud.flash_arrows)
	end
end


local function draw_bar(x, y, width, height, color, edge_color, current, max)
	local percent_filled = math.max(0, current/max)
	local y_low = y+height*(1-percent_filled)

	love.graphics.setColor(color.r, color.g, color.b)
	love.graphics.rectangle('fill', x, y_low, width, height*percent_filled)

	if current > 0 and current ~= max then
		love.graphics.setLineWidth(1.5)
		love.graphics.setColor(edge_color.r, edge_color.g, edge_color.b)
		love.graphics.line(x, y_low, x+width, y_low)
	end
	love.graphics.setColor(255,255,255, 255)
end

function hud.draw()

	-- hud icons are fixed-size
	local iconWidth = 80
	local iconHeight = 80
	local iconSeparation = 20

	-- draw arrows if room is unlocked
	if current_level.cleared then --and current_level.kind ~= "boss" then
		-- draw minimap
		hud.draw_dungeonmap()
		if next(hud.arrows) == nil then
			-- not currently flashing
			if current_level.exits.north then
				hud.arrows.up = true
			end
			if current_level.exits.east then
				hud.arrows.right = true
			end
			-- start flasher
			hud:flash_arrows() -- comment out to disable flash
		end
	else
		if next(hud.arrows) then
			hud.arrow_tween:stop() -- comment out if flash disabled
			hud.arrows = {}
		end
	end

	if next(hud.arrows) then
		hud:draw_arrows()
	end



	-- draw timer in upper right
	love.graphics.setFont(hud.font)
	timer.draw((window.w-255), hud.top_margin)

	-- draw player status bars in lower right
	local bar_dim = {x=24,y=140}
	local hp_bar = {x=love.graphics.getWidth()-bar_dim.x-iconSeparation,
		y=love.graphics.getHeight()-bar_dim.y-iconSeparation}
	local ammo_bar = {x=hp_bar.x-bar_dim.x-iconSeparation, y=hp_bar.y}

	love.graphics.draw(image["bar"], hp_bar.x - 5, hp_bar.y - 10)
	draw_bar(hp_bar.x, hp_bar.y, bar_dim.x, bar_dim.y, {r=100,g=0,b=0}, {r=240, g = 50, b = 10},
		player.hp, player.max_hp)
	love.graphics.draw(image["bar_shading"], hp_bar.x - 5, hp_bar.y - 10)

	love.graphics.draw(image["bar"], ammo_bar.x - 5, ammo_bar.y - 10)
	draw_bar(ammo_bar.x, ammo_bar.y, bar_dim.x, bar_dim.y, {r=0,g=60,b=140}, {r=30, g = 100, b = 240},
		player.equipped_items['weapon'].ammo, player.equipped_items['weapon'].max_ammo)
	love.graphics.draw(image["bar_shading"], ammo_bar.x - 5, ammo_bar.y - 10)

	-- draw weapon icons
	local iconOffset = iconSeparation

	selected_weapon = player.weapons[player.weapon]
	love.graphics.draw(image[selected_weapon.icon],iconOffset,(window.h - 100), 0, 1, 1, 0, 0)

	iconOffset = iconOffset + iconWidth

	-- Other player weapons drawn at half size
	local weapon_count = #player.weapons
	if weapon_count > 1 then
		for i = 1, weapon_count - 1 do
			w = player.weapon + i
			if w > weapon_count then
				w = w - weapon_count
			end
			iconOffset = iconOffset + iconSeparation
			love.graphics.draw(image[player.weapons[w].icon],iconOffset,(window.h - 100)+iconHeight/2,0,0.5,0.5,0,0)
			iconOffset = iconOffset + iconWidth/2
		end
	end

end

function hud.draw_dungeonmap()
	local r,g,b,a
	
	local square_size = 8  -- size to draw current/target location
	local dmap_dim = {x=114,y=80} -- background image dimensions
	
	local dun_origin = {x=26,y=14} -- offset from background lower left
	local border = 1 -- dungeon room border, size in pixels
	
	-- This includes a 1-px border on the dungeon
	local dun_size = {x=current_dungeon.width*(square_size+border),y=current_dungeon.height*(square_size+border)}
	
	-- Assumes boss room is in upper right.
	local target_pos = {x=dun_size.x - square_size - border, y=dun_size.y - square_size - border}
	
	local player_pos = {x=(player.dungeon_x-1)*(square_size + border), y=(current_dungeon.height- player.dungeon_y)*(square_size + border)}
	
	local mm_x = (window.w - dmap_dim.x)/2
	local mm_y = hud.top_margin
	
	love.graphics.draw(image['mmap_bg'], mm_x, mm_y)
	
	r,g,b,a = love.graphics.getColor()
	
	-- draw the dungeon
	love.graphics.setColor(140,140,140)
	love.graphics.rectangle('fill',mm_x+dun_origin.x, mm_y+(dmap_dim.y - dun_origin.y - dun_size.y), dun_size.x, dun_size.y)
	
	-- mark target room
	love.graphics.setColor(225,112,126)  -- Target room color
	love.graphics.rectangle('fill',mm_x+dun_origin.x+target_pos.x+1, mm_y+(dmap_dim.y - dun_origin.y - target_pos.y - square_size), square_size, square_size)
	
	-- mark player room
	love.graphics.setColor(255,255,255,hud.arrow_alpha)   -- Player room color
	love.graphics.rectangle('fill',mm_x+dun_origin.x+player_pos.x+1, mm_y+(dmap_dim.y - dun_origin.y - player_pos.y - square_size ), square_size, square_size)
	
	love.graphics.setColor(r,g,b,a)
end

return hud
