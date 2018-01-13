local sound_manager = {}

sound_manager.loaded_sounds = {}
sound_manager.playing = {}

function sound_manager.init()
	-- Short sound effects should be loaded with static to store in memory. 
  sound_manager.loaded_sounds.snap = love.audio.newSource("assets/sfx/snap.wav", "static")
  sound_manager.loaded_sounds.unh  = love.audio.newSource("assets/sfx/unh.wav", "static")
  sound_manager.loaded_sounds.unlatch  = love.audio.newSource("assets/sfx/unlatch.wav", "static")
  sound_manager.loaded_sounds.crackle  = love.audio.newSource("assets/sfx/crackle.wav", "static")
end

-- Make a playable sound, play it
-- returns a reference to the sound for future use
function sound_manager.play(loaded_sound)
	local new_sound = sound_manager.loaded_sounds[loaded_sound]:clone()
	local new_id = idcounter.get_id("sound")
	sound_manager.playing[new_id] = new_sound
	new_sound:play()
	return new_id
end

-- Pause a sound that's playing (no effect if not playing)
function sound_manager.pause(playing_id)
	if sound_manager.playing[playing_id] then
		sound_manager.playing[playing_id]:pause()
	end
end

-- Resume a sound (no effect if sound is not paused)
function sound_manager.resume(playing_id)
	if sound_manager.playing[playing_id] then
		sound_manager.playing[playing_id]:resume()
	end
end
	
-- Stops a sound. Do this if the sound is no longer needed.
function sound_manager.stop(playing_id)
	if sound_manager.playing[playing_id] then
		sound_manager.playing[playing_id]:stop()
	end
end

function sound_manager.pause_all()
	love.audio.pause()
end

function sound_manager.resume_all()
	love.audio.resume()
end

function sound_manager.update(dt)
	-- Cull sounds that aren't playing
	for i,p in ipairs(sound_manager.playing) do
		if (p ~= nil) and p:isStopped() then
			sound_manager.playing[i] = nil
		end
	end
end

return sound_manager