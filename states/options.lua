local options = {}

options.font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 36)

options.allowed = allowed_options

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

local line_ht = options.font:getHeight()
local sep_ht = 16 -- Spacing for separation
local all_opts_height = 0

options.option_menu = ScreenMenu:new(options.allowed,line_ht,sep_ht,{255,255,255},{127,127,127})

-- NOTE: Options state is also entered by 'returning' from credits, which does NOT call this (so we don't lose the prior state)
function options.enter()
	options.prior_state = state
	options.prior_stage = gamestage.current_stage
	state = STATE_OPTIONS
	options.warned = false
	options.selected = #(options.allowed) -- Always start at the bottom
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
	
	if player_input:pressed('fire') or player_input:pressed('sel') then
		options.allowed[options.selected]:activate()
	elseif player_input:pressed('back') or player_input:pressed('quit') or player_input:pressed('pause') then
		   options.exit()
	end
end

function options.exit()
	-- This still may be wonky when trying to switch the start stage from the pause menu.  
    if (gamestage.current_stage ~= options.prior_stage) and (options.prior_state ~= STATE_PAUSE) then
	   gamestage.setup_next_stage(gamestage.current_stage)
	end    
	gamestates[options.prior_state]:enter()
end

function options.draw()
	--love.graphics.setShader(options.background_shader)
	love.graphics.setFont(options.font)
	
	options.option_menu:draw(options.selected)
	
	love.graphics.setFont(love.graphics.newFont()) --reset to default
	--love.graphics.setShader()
end

-- Credits screen
allowed_options[option_index['credits']]:setAction(function() 
	movie_play.enter(movie_play.credits, function() state = STATE_OPTIONS end)  
 end)
 
 -- Reset Player stats
allowed_options[option_index['reset_stats']]:setAction( function()
     settings.stage_upgrades = nil
     gamestage.stage_upgrades = nil
   end)

-- Back must be the last item allowed.
allowed_options[#(allowed_options)]:setAction(function() options.exit() end)
options.selected = #(options.allowed) 


return options
