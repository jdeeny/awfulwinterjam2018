local gamestage = {}

local stages = {}

stages[1] = {
	dungeon_x = 3,
	dungeon_y = 3,
	film_title = "Tesla\nArrives\nin America",
	film_music = "figleaf",
	film_music_start = 27,
}

stages[2] = {
	dungeon_x = 5,
	dungeon_y = 4,
	film_title = "Edison\nHires\nTesla",
	film_music = "figleaf",
	film_music_start = 49,
}

gamestage.stages = stages
gamestage.current_stage = 0

-- This just sets up the stage; it does not change the state
function gamestage.setup_next(forced)
	local ns_number = forced or (gamestage.current_stage + 1)
	
	if ns_number > #(gamestage.stages)  then
		-- you win!
		ns_number = 1
	end
	
	gamestage.current_stage = ns_number
	
	local next_stage = gamestage.stages[gamestage.current_stage]
	
	film.set_title(next_stage.film_title)
	film.set_music(next_stage.film_music, next_stage.film_music_start)
	
    current_dungeon = dungeon:new()
    current_dungeon:init(next_stage.dungeon_x, next_stage.dungeon_y)
    current_dungeon:setup_main()
	
end

function gamestage.advance()
    game_time = 0

	player.init()
	
    enemies = nil
    enemy_value = nil
    shots = nil
    doodads = nil
    sparks = nil

    pathfinder.rebuild_time = 0

	dungeon.move_to_room(current_dungeon.start_x, current_dungeon.start_y, "west")

    player:start_force_move(9999, player.speed, 0)

    fade.start_fade("fadein", 0.5, true)
    delay.start(0.5, function() player:end_force_move() end)
end

return gamestage