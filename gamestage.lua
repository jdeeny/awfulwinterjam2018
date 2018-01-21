local gamestage = {}

local stages = {}

stages[1] = {
	-- Movie/cutscene settings
    intro_movie = nil,--movie_a.movie_data,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_x = 3,
	dungeon_y = 3,

	-- This is optional; any blank entry will select from all available files
	room_files = {['start'] = {3}, ['boss'] = {8}, ['generic'] = {1,2,3,4,5}},  -- See file_io for room index
	spawns = {['start'] = {'ez_lvl'}, ['boss'] = {'ez_lvl'}, ['generic'] = {'ez_lvl'}},  -- See spawner for spawn names

	-- Other things that'd be good to put in here:
	--  * tilesets (if they can change)
}

stages[2] = {
	-- Movie/cutscene settings
    intro_movie = movie_a.movie_data,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_x = 5,
	dungeon_y = 4,
	spawns = {['start'] = {'ez_lvl'}, ['boss'] = {'ez_lvl'}, ['generic'] = {'ez_lvl'}},

}

-- Test stage, feel free to mess around with these values
stages[3] = {
	-- Movie/cutscene settings
    intro_movie = movie_a.movie_data,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_x = 2,
	dungeon_y = 2,
	room_files = {['start'] = {14}, ['boss'] = {14}, ['generic'] = {14}},  -- See file_io for room index
}

gamestage.stages = stages
gamestage.current_stage = 0

-- This just sets up the stage; it does not change the state
function gamestage.setup_next_stage(forced)
	local ns_number = forced or (gamestage.current_stage + 1)

	if ns_number > #(gamestage.stages)  then
		-- you win!
		ns_number = 1
	end

	gamestage.current_stage = ns_number

	local next_stage = gamestage.stages[gamestage.current_stage]

	current_dungeon = dungeon:new()
    current_dungeon:init(next_stage.dungeon_x, next_stage.dungeon_y, 
        next_stage.room_files, next_stage.spawns)
    current_dungeon:setup_main()

end

function gamestage.advance_to_play()
    game_time = 0

	  player:restore()

    --enemies = nil
    --enemy_value = nil
    --shots = nil
    --doodads = nil
    --sparks = nil
    --items = nil

    pathfinder.rebuild_time = 0

    local function movie_finished_cb()
    	current_dungeon:move_to_room(current_dungeon.start_x, 
            current_dungeon.start_y, "west")
    	
        print("Load done advance_to_play")
        player:start_force_move(9999, player.speed, 0)

        fade.start_fade("fadein", 0.5, true)
        delay.start(0.5, function() player:end_force_move() end)

        play.enter()
    end

    if gamestage.stages[gamestage.current_stage].intro_movie then
        movie_a.enter(gamestage.stages[gamestage.current_stage].intro_movie,
            current_dungeon, movie_finished_cb)
    else
        movie_finished_cb()
    end


end

return gamestage
