local sound = {}

function sound.init()
	-- Short sound effects should be loaded with static to store in memory. 
  sound.snapgun = love.audio.newSource("assets/sfx/snap.wav", "static")

end

return sound