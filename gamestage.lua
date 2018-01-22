local gamestage = {}

local stages = {}

stages[1] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 2,
	dungeon_h = 2,

	-- This is optional; any blank entry will select from all available options
	room_files = {['start'] = {7}, ['boss'] = {10}, ['generic'] = {1,2,4,5,6}},  -- See file_io for room index
	spawns = {['start'] = {'first'}, ['boss'] = {'second'}, ['generic'] = {'stage1boss'}},  -- See spawner for spawn names
	-- Other things that'd be good to put in here:
	--  * tilesets (if they can change)
}

stages[2] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data2,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 5,
	dungeon_h = 4,
	spawns = {['start'] = {'first','second'}, ['boss'] = {'stage1boss'}}, -- randomized waves

}

-- Test stage, feel free to mess around with these values
stages[3] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data3,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 2,
	dungeon_h = 2,
	room_files = {['start'] = {14}, ['boss'] = {14}, ['generic'] = {14}},  -- See file_io for room index
}

gamestage.stages = stages
gamestage.current_stage = 0
--gamestage.upgrades = {}

-- This just sets up the stage; it does not change the state
function gamestage.setup_next_stage(forced)
    local ns_number = forced or (gamestage.current_stage + 1)
    print("setup next stage",ns_number)

	if ns_number > #(gamestage.stages)  then
        print("You win!")
        ns_number = 1
        current_dungeon = nil
		movie_play.enter(movie_play.credits, function() mainmenu.enter() end)
    else
        gamestage.current_stage = ns_number

        local next_stage = gamestage.stages[gamestage.current_stage]

        current_dungeon = dungeon:new(next_stage.dungeon_w, next_stage.dungeon_h,
            next_stage.room_files, next_stage.spawns)
        current_dungeon:setup_main()
    end
end

function gamestage.advance_to_play()
    print("Load done advance_to_play")
    game_time = 0

    player.init()

    gamestage.restore_upgrades()

    enemies = nil
    enemy_value = nil
    shots = nil
    doodads = nil
    sparks = nil
    items = nil

    pathfinder.rebuild_time = 0

    if current_dungeon then
        local function movie_finished_cb()
            play.enter()
        end

        current_dungeon:move_to_room(current_dungeon.start_x,
            current_dungeon.start_y, "west")

        player:start_force_move(9999, player.speed, 0)
        fade.start_fade("fadein", 0.5, true)
        delay.start(0.5, function() player:end_force_move() end)

        if gamestage.stages[gamestage.current_stage].intro_movie then
            print("Playing movie")
            movie_play.enter(gamestage.stages[gamestage.current_stage].intro_movie,
                movie_finished_cb)
        else
            print("No Movie")

            movie_finished_cb()
        end
    end
end

function gamestage.save_upgrades()
	gamestage.upgrades = { max_hp = player.max_hp, weapon_stats = {} }
	for k,v in pairs(player.weapons) do
		gamestage.upgrades.weapon_stats[k] = {}
		gamestage.upgrades.weapon_stats[k].max_ammo = v.max_ammo
		-- add any others?
	end
end

function gamestage.restore_upgrades()
	if gamestage.upgrades then
		player.max_hp = gamestage.upgrades.max_hp
		for k,v in pairs(gamestage.upgrades.weapon_stats) do
			player.weapons[k].max_ammo = v.max_ammo
		end
	end
	player:heal(player.max_hp)
end

return gamestage
