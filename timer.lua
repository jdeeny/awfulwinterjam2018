local timer = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}


function timer.init()
	timerOffset = love.timer.getTime()
	timeStamp = string.format("%d:%02d",0,0)
	priorPlayState = true
	currentPlayState = true
end

function timer.update()
	
	if game_state == 'play' then
		currentPlayState = true
	else
		currentPlayState = false
	end

	if currentPlayState == true and priorPlayState == true then --continuous play
		local elapsedTime = love.timer.getTime() - timerOffset
		local s = math.floor(elapsedTime % 60)
		local m = math.floor(elapsedTime / 60)
		timeStamp = string.format("%d:%02d",m,s)
	end

	if currentPlayState == false and priorPlayState == true then --pause initiated
		pauseTime = love.timer.getTime() --store paused time
		priorPlayState = false
	end

	if currentPlayState == true and priorPlayState == false then --play resumed
		local resumeTime = love.timer.getTime() -- store resumed time
		timerOffset = timerOffset + (resumeTime - pauseTime) --adjust for pause delay
		priorPlayState = true
	end

end

function timer.draw()
	love.graphics.setFont(timer.font)
	love.graphics.print(timeStamp, 690, 0)
end

return timer