local gamestage = {}

local stages = {}

-- Tesla's Arrival
stages[1] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 2,
	dungeon_h = 2,

	-- This is optional; any blank entry will select from all available options
	room_files = {['start'] = {7}, ['boss'] = {2}, ['generic'] = {1,4,5,6,7,8,11,13,16,18}},  -- See file_io for room index
	spawns = {['start'] = {'first'}, ['boss'] = {'stage1boss'},
		['generic'] = {'easy_1', 'easy_2', 'easy_3', 'easy_4', 'easy_5', 'easy_6'}},  -- See spawner for spawn names
	floor_tiles = {"woodFloorTile", "concreteFloor"},
	boss_floor = "woodenFloor2",
}

-- Marconi plays the mamba
stages[2] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data2,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 5,
	dungeon_h = 4,

	room_files = {['start'] = {14}, ['boss'] = {18}, ['generic'] = {5,8,4,16,17,22}},

	spawns = {['start'] = {'stage2boss'}, ['boss'] = {'stage3boss'},
		['generic'] = {'second', 'remotes', 'easy_1', 'easy_2', 'easy_3', 'easy_4', 'easy_5', 'easy_6', 'medium_1', 'medium_2', 'medium_3', 'medium_4', 'medium_5', 'medium_6'}}, -- randomized waves
	floor_tiles = {"woodenFloor", "Stonewall"},
	boss_floor = "metalFloor",
}


stages[3] = {
	-- Movie/cutscene settings
    intro_movie = movie_play.movie_data3,
    outro_movie = nil,

	-- Rooms/dungeon
	dungeon_w = 6,
	dungeon_h = 6,
	room_files = {['start'] = {9}, ['boss'] = {3}, ['generic'] = {1,4,5,8,9,11,12,13,19,21}},  -- See file_io for room index,  -- See file_io for room index
	spawns = {['start'] = {'stage3boss'}, ['boss'] = {'stage3boss'},
		['generic'] = {'second', 'remotes', 'easy_1', 'easy_2', 'easy_3', 'easy_4', 'easy_5', 'easy_6', 'medium_1', 'medium_2', 'medium_3', 'medium_4', 'medium_5', 'medium_6'}},
	floor_tiles = {"Stonewall", "woodenFloor2"},
	boss_floor = "woodenFloor3",

}


gamestage.stages = stages
gamestage.current_stage = 0
--gamestage.upgrades = {}

-- This just sets up the stage; it does not change the state
function gamestage.setup_next_stage(forced)
    local ns_number = forced or (gamestage.current_stage + 1)
    --print("setup next stage",ns_number)

	if ns_number > #(gamestage.stages)  then
		-- you win!
		movie_play.enter(movie_play.credits, function() mainmenu.enter() end)
        ns_number = 1
	end

	gamestage.current_stage = ns_number

	local next_stage = gamestage.stages[gamestage.current_stage]

    current_dungeon = dungeon:new(next_stage.dungeon_w, next_stage.dungeon_h,
        next_stage.room_files, next_stage.spawns)
    current_dungeon:setup_main()

end

function gamestage.advance_to_play()
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

    local function movie_finished_cb()
        play.enter()
    end

    current_dungeon:move_to_room(current_dungeon.start_x,
        current_dungeon.start_y, "west")

    player:start_force_move(9999, player.speed, 0)
    fade.start_fade("fadein", 0.5, true)
    delay.start(0.5, function() player:end_force_move() end)

        if gamestage.stages[gamestage.current_stage].intro_movie then
--            print("Playing movie")
            movie_play.enter(gamestage.stages[gamestage.current_stage].intro_movie,
                movie_finished_cb)
        else
            --print("No Movie")

        movie_finished_cb()
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
	--print("maxhp", player.max_hp) -- DBG
	--print("wpn 1 ammo", player.weapons[1].max_ammo) -- DBG
end

local floor_tiles = {"concreteFloor", "metalFloor",
  "Stonewall", "woodenFloor", "woodenFloor2", "woodenFloor3",
  "woodFloorTile"}

function gamestage.get_random_floor()
  return "assets/tiles/" .. gamestage.stages[gamestage.current_stage].floor_tiles[love.math.random(#gamestage.stages[gamestage.current_stage].floor_tiles)] .. ".png"
end

function gamestage.get_boss_floor()
  return "assets/tiles/" .. gamestage.stages[gamestage.current_stage].boss_floor .. ".png"
end

return gamestage
