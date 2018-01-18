local hud = {}

hud.font = love.graphics.newFont('assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50)

hud.arrows = {}
hud.arrow_alpha_max = 192
hud.arrow_alpha_min = 16
hud.arrow_alpha = hud.arrow_alpha_min -- set to max if flash is disabled
hud.pulse_time = 0.9

function hud.draw_arrows()
	local r,g,b,a
	local yc = image['arrow']:getHeight()/2
	local xc = image['arrow']:getWidth()/2

	r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(r,g,b,hud.arrow_alpha)

	-- draw all arrows
	local dir
	local distance = math.max(100, math.min(window.w/2 - 100, window.h/2 - 100))
	if hud.arrows['up'] then
		dir = math.atan2(-4 * TILESIZE - player.y, (current_level:pixel_width() / 2) - player.x)
		love.graphics.draw(image['arrow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['right'] then
		dir = math.atan2((current_level:pixel_height() / 2) - player.y, current_level:pixel_width() + 4 * TILESIZE - player.x)
		love.graphics.draw(image['arrow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['left'] then
		dir = math.atan2((current_level:pixel_height() / 2) - player.y, -4 * TILESIZE - player.x)
		love.graphics.draw(image['arrow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	if hud.arrows['down'] then
		dir = math.atan2(current_level.pixel_height() + 4 * TILESIZE - player.y, (current_level:pixel_width() / 2) - player.x)
		love.graphics.draw(image['arrow'], (window.w/2) + math.cos(dir) * (distance), (window.h/2) + math.sin(dir) * (distance), dir, 1, 1, xc, yc)
	end

	-- restore previous draw settings
	love.graphics.setColor(r,g,b,a)
end

-- loops from max to min, repeating (must be stopped elsewhere)
function hud.flash_arrows()
	hud.arrow_tween = game_flux.to(hud, hud.pulse_time, {arrow_alpha = hud.arrow_alpha_max}):ease("backinout")
	hud.arrow_tween:after(hud, hud.pulse_time, {arrow_alpha = hud.arrow_alpha_min})
	hud.arrow_tween:oncomplete(hud.flash_arrows)
end


local function draw_bar(x, y, width, height, color, percent_filled)
	percent_filled = math.max(0, percent_filled)
	love.graphics.setColor(127,127,127)
	love.graphics.rectangle('fill', x, y, width, 
		height*(1-percent_filled))
	love.graphics.setColor(color.r, color.g, color.b)
	love.graphics.rectangle('fill', x, y+height*(1-percent_filled), 
		width, height*percent_filled)
	love.graphics.setColor(255,255,255)
end

function hud.draw()

	-- hud icons are fixed-size
	local iconWidth = 80
	local iconHeight = 80
	local iconSeparation = 20

	-- draw arrows if room is unlocked
	if current_level.cleared then
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
		end
		hud.arrows = {}
	end

	if next(hud.arrows) then
		hud:draw_arrows()
	end



	-- draw timer in upper right
	love.graphics.setFont(hud.font)
	timer.draw((window.w-275),0)

	-- draw player status bars in lower right
	local bar_dim = {x=20,y=100}
	-- love.graphics.setFont(hud.font)
	-- love.graphics.print(player.hp, (window.w - 80), (window.h - 80))
	local hp_bar = {x=love.graphics.getWidth()-bar_dim.x-iconSeparation,
		y=love.graphics.getHeight()-bar_dim.y-iconSeparation}
	local ammo_bar = {x=hp_bar.x-bar_dim.x-iconSeparation, y=hp_bar.y}
	draw_bar(hp_bar.x, hp_bar.y, bar_dim.x, bar_dim.y, {r=175,g=0,b=0}, 
		player.hp/player.max_hp)
	draw_bar(ammo_bar.x, ammo_bar.y, bar_dim.x, bar_dim.y, {r=0,g=160,b=215}, 
		player.equipped_items['weapon'].ammo/player.equipped_items['weapon'].max_ammo)
	
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


return hud
