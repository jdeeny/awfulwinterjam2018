local mainmenu = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

mainmenu.background_shader = love.graphics.newShader[[
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

function mainmenu.enter()
	state = STATE_MAINMENU
end

function mainmenu.update(dt)
	player_input:update()

	if player_input:pressed('fire') or player_input:pressed('sel') then
    	film.set_title("Tesla \n Arrives in \n America")
		film.set_music("figleaf", 27)
    	film.enter()
	elseif player_input:pressed('back') then
		options.enter()
	elseif player_input:pressed('quit') then
		save_settings()
		love.event.push("quit")
	end
end

function mainmenu.draw()
	love.graphics.setShader(mainmenu.background_shader)
	love.graphics.setFont(mainmenu.font)

	local text
	if player_input:getActiveDevice() == 'joystick' then
		text = "A Tesla Game\nPress A to Play\n\nPress B for Options\nPress Back to Quit"
	else
		text = "A Tesla Game\nPress Spacebar to Play\n\nPress Delete for Options\nPress Q to Quit"
	end
	local th = mainmenu.font:getHeight()*5

	love.graphics.printf(text, 0, window.h/2-th/2,
		window.w, 'center')

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()
end

return mainmenu
