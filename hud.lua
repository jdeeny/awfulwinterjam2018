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
	if hud.arrows['up'] then
		love.graphics.draw(image['arrow'], (window.w/2), 0, 0, 1, 1, xc, 0)
	end
	
	if hud.arrows['right'] then
		love.graphics.draw(image['arrow'], (window.w - xc), (window.h/2), (math.pi * 0.5), 1, 1, xc, yc)
	end
	
	if hud.arrows['left'] then
		love.graphics.draw(image['arrow'], xc, (window.h/2), (math.pi * 1.5), 1, 1, xc, yc)
	end
	
	if hud.arrows['down'] then
		love.graphics.draw(image['arrow'], (window.w/2), (window.h - yc), (math.pi * 1.0), 1, 1, xc, yc)
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


function hud.draw() 
	
	-- hud icons are fixed-size 
	local iconWidth = 80
	local iconHeight = 80
	local iconSeparation = 20
	
	-- draw arrows if room is unlocked
	if current_room.cleared  then
		if true then -- DBG
			if next(hud.arrows) == nil then 
				-- not currently flashing
				if current_room.exits.north then
					hud.arrows.up = true
				end
				if current_room.exits.east then
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
	end
	
	if next(hud.arrows) then  
		hud:draw_arrows()
	end
		
	
	love.graphics.setFont(hud.font)
	
	-- draw timer in upper right
	timer.draw((window.w-275),0)
	
	-- draw player HP in lower right
	love.graphics.print(player.hp, (window.w - 80), (window.h - 80))

	-- draw weapon icons
	local iconOffset = iconSeparation
	
	selected_weapon = player.weapons[player.weapon]
	love.graphics.draw(image[selected_weapon.icon],iconOffset,(window.h - 100), 0, 1, 1, 0, 0)
	
	iconOffset = iconOffset + iconWidth
	
	-- Other player weapons drawn at half size
	for i,w in ipairs(player.weapons) do
		if w ~= selected_weapon then
			iconOffset = iconOffset + iconSeparation 
			love.graphics.draw(image[w.icon],iconOffset,(window.h - 100)+iconHeight/2,0,0.5,0.5,0,0)
			iconOffset = iconOffset + iconWidth/2
		end
	end
	
end


return hud