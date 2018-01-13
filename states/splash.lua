local splash = {}

function splash.enter()
	state = STATE_SPLASH
end

function splash.update()
	mainmenu.enter()
end

function splash.draw()

end

return splash