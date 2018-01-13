local death = {}

function death.update()
	game_state = 'continue'
end

function death.draw()
	fade.draw(gui_time)
end

return death