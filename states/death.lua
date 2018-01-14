local death = {}

function death.enter()
	state = STATE_DEATH
end

function death.update()
	continue.enter()
end

function death.draw()
	fade.draw()
end

return death