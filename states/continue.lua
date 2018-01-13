local continue = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

continue.background_shader = love.graphics.newShader[[
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

function continue.enter()
	state = STATE_CONTINUE
end

function continue.update(dt)
	player_input:update()

	if player_input:pressed('fire') or player_input:pressed('sel') then
    	mainmenu.enter()
    	fade.state = nil
	elseif player_input:pressed('quit') then
		love.event.push("quit")
	end
end

function continue.draw()
	love.graphics.setShader(continue.background_shader)
	love.graphics.setFont(continue.font)

	local text
	if player_input:getActiveDevice() == 'joystick' then
		text = "You Have Died!\n\nPress A to Restart\nPress Back to Quit"
	else
		text = "You Have Died!\n\nPress Spacebar to Restart\nPress Q to Quit"
	end

	local th = continue.font:getHeight()*3

	love.graphics.printf(text, 0, love.graphics.getHeight()/2-th/2,
		love.graphics.getWidth(), 'center')

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()

	fade.draw(gui_time)
end

return continue
