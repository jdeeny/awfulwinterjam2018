local hud = {}

hud.font = love.graphics.newFont('assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50)


hud.arrows = {}
hud.arrow_alpha = 128

function hud.draw_arrows()
	local r,g,b,a
	local yc = image['arrow']:getHeight()/2
	local xc = image['arrow']:getWidth()/2
	
	print("drawin' arrows!") -- DBG
	print(hud.arrows['up']) -- DBG
	
	--r,g,b,a = love.graphics.getColor()
	--love.graphics.setColor(r,g,b,hud.arrow_alpha)
	
	-- draw all arrows
	if hud.arrows['up'] then
		love.graphics.draw(image['arrow'], (window.w/2), 0, 0, 1, 1, xc, 0)
	end
	
	if hud.arrows['right'] then
		love.graphics.draw(image['arrow'], (window.w - 40), (window.h/2), (math.pi * 0.5), 1, 1, 0, yc)
	end
	
	-- restore previous draw settings
	--love.graphics.setColor(r,g,b,a)
end


function hud.draw() 
	
	-- hud icons are fixed-size 
	local iconWidth = 80
	local iconHeight = 80
	local iconSeparation = 20
	
	-- draw arrows if room is unlocked
	if current_room.done_state == 'coda' then
		if next(hud.arrows) == nil then
			if current_room.exits.north then
				hud.arrows.up = true
			end
			if current_room.exits.east then
				hud.arrows.right = true
			end
		end
	else 
		hud.arrows = {}
	end
	
	
	if next(hud.arrows) then  
		hud:draw_arrows()
	end
		
	
	love.graphics.setFont(hud.font)
	
	-- draw timer in upper right
	timer.draw((window.w-250),0)
	
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