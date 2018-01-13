local state = {
	-- stateOptions = {"film", "main_menu", "play", "pause"}
}

function state.update(dt)
	if game_state == "main_menu" then main_menu.update()
	elseif game_state == "film" then	film.update()
	elseif game_state == "play" then play.update(dt)
	elseif game_state == "pause" then	pause.update(dt)
	else
	end
end

function state.draw()
	if game_state == "main_menu" then main_menu.draw()
	elseif game_state == "film" then	film.draw()
	elseif game_state == "play" then play.draw()
	elseif game_state == "pause" then	pause.draw()
	else
	end
end

return state
