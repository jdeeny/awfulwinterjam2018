
local pause = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

pause.background_shader = love.graphics.newShader[[
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

function pause.update()
	menu_input:update()

	if menu_input:pressed('unpause') or menu_input:pressed('back') then
    game_state = 'play'
	elseif menu_input:pressed('quit') then
		love.event.push("quit")
	end
	timer.update()
end

function pause.draw()
	love.graphics.setShader(pause.background_shader)
	play.draw()
	love.graphics.setFont(pause.font)
	

	local text = "PAUSED\nPress Q/Select to quit\nPress Esc/Start/B to return"
	local th = pause.font:getHeight()*3

	love.graphics.printf(text, 0, love.graphics.getHeight()/2-th/2,
		love.graphics.getWidth(), 'center')

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()
end

return pause