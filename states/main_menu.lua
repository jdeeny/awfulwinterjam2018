local main_menu = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

main_menu.background_shader = love.graphics.newShader[[
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

function main_menu.update(dt)
	player_input:update()

	if player_input:pressed('fire') or player_input:pressed('sel') then
    film.set_title("Tesla \n Arrives in \n America")
    game_state = 'film'
	elseif player_input:pressed('quit') then
		love.event.push("quit")
	end
end

function main_menu.draw()
	love.graphics.setShader(main_menu.background_shader)
	love.graphics.setFont(main_menu.font)


	local text = "A Tesla Game\nPress Spacebar to Play\nPress Q to Quit"
	local th = main_menu.font:getHeight()*3

	love.graphics.printf(text, 0, love.graphics.getHeight()/2-th/2,
		love.graphics.getWidth(), 'center')

	love.graphics.setFont(love.graphics.newFont()) --reset to default
	love.graphics.setShader()
end

return main_menu
