
local pause = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

pause.background_shader = love.graphics.newShader[[
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
		vec4 pixel = Texel(texture, texture_coords) * color; //This is the current pixel color
	  	number luma = 0.5 * dot(vec3(0.299f, 0.587f, 0.114f), pixel.rgb);
	  	pixel.r = luma;
	  	pixel.g = luma;
	  	pixel.b = luma;
	  	return pixel;
	}
]]

function pause.enter()
	state = STATE_PAUSE
end

function pause.update()
	player_input:update()

	if player_input:pressed('pause') then
    	play.enter()
	elseif player_input:pressed('back') then
		options.enter()
	elseif player_input:pressed('quit') then
		mainmenu.enter()
	end
	timer.update()
end

function pause.draw()
	love.graphics.setShader(pause.background_shader)
	play.draw()
	love.graphics.setShader()

	love.graphics.setFont(pause.font)

	local text
	if player_input:getActiveDevice() == 'joystick' then
		text = "PAUSED\nPress Start to continue\n\nPress B for Options\nPress Back to end game"
	else
		text = "PAUSED\nPress Esc to continue\n\nPress Backspace for Options\nPress Q to end game"
	end

	local th = pause.font:getHeight()*3

	love.graphics.printf(text, 0, window.h/2-th/2,
		window.w, 'center')

	love.graphics.setFont(love.graphics.newFont()) --reset to default
end

return pause
