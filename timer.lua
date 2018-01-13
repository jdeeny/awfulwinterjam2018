os = require "os"

local timer = {
	font = love.graphics.newFont(
		'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

local deadline = os.time({year=2018,month=1,day=21,hour=22,min=59,sec=59})

function timer.init()
	timerOffset = love.timer.getTime()
	timeStamp = string.format("%d:%02d",0,0)
	priorPlayState = true
	currentPlayState = true
end

function timer.update()
	if state == STATE_PLAY then
		currentPlayState = true
	else
		currentPlayState = false
	end

	if currentPlayState == true and priorPlayState == true then --continuous play
		local elapsedTime = love.timer.getTime() - timerOffset
		local s = math.floor(elapsedTime % 60)
		local m = math.floor(elapsedTime / 60)
		
		-- uncomment this to show game time
		-- timeStamp = string.format("%d:%02d",m,s)
	
		-- showing time to deadline for now remove this chunk later
		local timeleft = deadline-os.time()
		s = math.floor(timeleft%60)
		timeleft = math.floor(timeleft/60)
		
		m = math.floor(timeleft%60)
		timeleft = math.floor(timeleft/60)
		
		local h = math.floor(timeleft%24)
		timeleft = math.floor(timeleft/24)

		local days = timeleft
		timeStamp = string.format("%dd %dh %02dm %02ds",days,h,m,s)
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
	love.graphics.print(timeStamp, 500, 0)
end

return timer
