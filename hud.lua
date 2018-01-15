local hud = {}

hud.font = love.graphics.newFont('assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50)


function hud.draw() 
	
	
		
	
	love.graphics.setFont(hud.font)
	
	-- draw timer in upper right
	timer.draw((window.w-250),0)
	
	-- draw player HP in lower right
	love.graphics.print(player.hp, (window.w - 80), (window.h - 80))

	-- draw weapon icons
	local iconWidth = 80
	local iconHeight = 80
	local iconSeparation = 20
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