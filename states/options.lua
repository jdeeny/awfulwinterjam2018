local options = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 36),
		prior_state = nil,
		allowed = allowed_options,
}

options.selected = #(options.allowed) -- Back must be the last item allowed.

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
	options.warned = false
end


function options.update(dt)
	player_input:update()
	
	-- Move up/down screen to select option, left/right to change it
	if player_input:pressed('movedown') or player_input:pressed('aimdown') then
		options.selected = math.min(options.selected + 1, #(options.allowed))
	elseif player_input:pressed('moveup') or player_input:pressed('aimup') then
		options.selected = math.max(options.selected - 1, 1)
	elseif player_input:pressed('moveleft') or player_input:pressed('aimleft') then
		options.allowed[options.selected]:decrease()
	elseif player_input:pressed('moveright') or player_input:pressed('aimright') then
		options.allowed[options.selected]:increase()
	end
	
	-- The last choice here requires 'back' to be the last option in the last.
	if player_input:pressed('back') or player_input:pressed('quit') or player_input:pressed('pause') or 
	   (options.selected == #(options.allowed) and (player_input:pressed('fire') or player_input:pressed('sel'))) then 
		gamestates[options.prior_state]:enter()
	end
end

function options.draw()
	--love.graphics.setShader(options.background_shader)
	love.graphics.setColor(128,128,128)
	love.graphics.setFont(options.font)
	
	local line_ht = mainmenu.font:getHeight()
	local all_opts_height = 0
	
	for i,opt in ipairs(options.allowed) do
		-- 1 line for the label, + space for the option
		all_opts_height = all_opts_height + line_ht*(1 + opt:requiredHeight())
	end
	
	local cur_y = (window.h - all_opts_height)/2
	
	if cur_y < 0 then
		if not options.warned then 
			print("Warning: options cannot all fit on screen")
			options.warned = true  
		end
		cur_y = 0
	end
	
	for i,opt in ipairs(options.allowed) do
		local opt_ht = opt:requiredHeight()*line_ht
		if options.selected == i then
			-- maybe use the stencil if we want to highlight shapes in the options
			 --love.graphics.stencil( love.graphics.rectangle('fill', 0, cur_y, window.w, opt_ht), "replace", 1)
			 love.graphics.setColor(250,250,0)   -- print the selected one in yellow
		 end
		-- print this option's label 
		love.graphics.printf(opt.label, 0, cur_y, window.w, 'center')
	    love.graphics.setColor(128,128,128)	
		cur_y = cur_y + line_ht
		-- print the option
		opt:drawIn(0,cur_y,window.w,opt_ht)
	
		cur_y = cur_y + opt_ht
	end

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()
end

return options
