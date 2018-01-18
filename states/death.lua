local death = {}

function death.enter()
	state = STATE_DEATH
	fade.start_fade("fadein", 3, true)
    love.audio.stop()
end

function death.update()
	continue.enter()
end

function death.draw()
	fade.draw()
end

return death
