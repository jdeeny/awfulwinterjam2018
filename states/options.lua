local options = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
		prior_state = nil,
		allowed = {'Game Volume','Level Select','Play Speed','Back'},
}

options.selected = #(options.allowed) -- Back should always be the last item allowed.

options.background_shader = love.graphics.newShader[[
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
		vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
		number average = (pixel.r+pixel.b+pixel.g)/3.0;
	  pixel.r = average;
	  pixel.g = average;
	  pixel.b = average;
	  pixel.w = pixel.w/2;
		return pixel;
	}
]]

function options.enter()
	options.prior_state = state
	state = STATE_OPTIONS
end


function options.update(dt)
	player_input:update()
	
	-- Move up/down screen
	if player_input:pressed('movedown') then
		selected = math.min(options.selected + 1, #(options.allowed))
	elseif player_input:pressed('moveup') then
		selected = math.max(options.selected - 1, 1)
	end
	
	-- Move left/right to change option
	if player_input:pressed('moveleft') then
		--options.decrease_value(options.selected)
	elseif player_input:pressed('moveright') then
		--options.increase_value(options.selected)
	end
	
	if player_input:pressed('back') or player_input:pressed('quit') then
		gamestates[options.prior_state]:enter()
	end
end

function options.draw()
	love.graphics.setShader(options.background_shader)
	love.graphics.setFont(options.font)

	local opt_ht = mainmenu.font:getHeight()*2   -- space for text and for the option to appear
	local cur_y = (window.h - #(options.allowed)*opt_ht)/2
	
	if cur_y < 0 then
		print("Options cannot all fit on screen")
		cur_y = 0
	end
	
	for i,opt_text in ipairs(options.allowed) do
		if options.selected == i then
			 --love.graphics.stencil(
			 love.graphics.setColor(200,200,0,255)
			 love.graphics.rectangle("line", window.w,opt_ht,0, cur_y)
			 -- , "replace", 1)
		 end
		-- print this option 
		love.graphics.printf(opt_text, 0, cur_y, window.w, 'center')
		
		cur_y = cur_y + opt_ht
	end

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()
end

return options
