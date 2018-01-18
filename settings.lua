local default_settings = {
  volume = 100,   -- max
  game_speed = 1,  -- medium
  start_stage = 1, -- first
  max_unlocked_dungeon = 1,  -- just the first
  gfx_mode = 'windowed',
  window_width =  window.w,
  window_height = window.h,
  -- This last setting is only here to force defaults to reset when settings get renamed 
  -- Changing the number of entries in the table forces the update, so add or remove it if
  --  a setting gets changed, and increment the count if you wish.
  integrity_buster = 1, 
}

local settings = {}

if love.filesystem.exists('savedata') then
     settings = bitser.loadLoveFile('savedata')
	 
	 -- integrity check, primarily during dev
	 if #(settings) ~= #(default_settings) then
		 settings = default_settings
	 end
else
	settings = default_settings
	bitser.dumpLoveFile('savedata', settings)
end



-- bitser won't serialize functions, so these need to be global

function init_settings()
	allowed_options[1]:setTo(settings.volume)
	allowed_options[2]:setTo(settings.game_speed)
	allowed_options[3]:setTo(settings.start_stage)
end

function save_settings()
	settings.volume = allowed_options[1]:getSetting()
	settings.game_speed = allowed_options[2]:getSetting()
	settings.start_stage = allowed_options[3]:getSetting()   
	bitser.dumpLoveFile('savedata', settings)
end

return settings
