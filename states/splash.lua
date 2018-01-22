local splash = {}

local filmgrain_effect = moonshine(moonshine.effects.desaturate)
                      .chain(moonshine.effects.filmgrain)
                      .chain(moonshine.effects.vignette)

                      filmgrain_effect.filmgrain.size = 10
                      filmgrain_effect.filmgrain.opacity = .6
                      filmgrain_effect.desaturate.tint = {138, 111, 48}

function splash.enter()
	state = STATE_SPLASH
end

function splash.update()
  player_input:update()

  if player_input:pressed('pause') or player_input:pressed('back') or player_input:pressed('quit') or player_input:pressed('fire') or player_input:pressed('sel') then
    mainmenu.enter()
  end

end

function splash.draw()
	local f = math.random(3)
	local img = image["title"..f]

	if love.math.random() > 0.7 then filmgrain_effect.filmgrain.size = love.math.random() * 10 + 5 end
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.opacity = love.math.random() * 0.2 end
  if love.math.random() > 0.7 then filmgrain_effect.desaturate.strength = love.math.random() * .1 + .1 end
  if love.math.random() > 0.7 then filmgrain_effect.vignette.radius = love.math.random() * .1 + .6 end
  if love.math.random() > 0.7 then filmgrain_effect.vignette.opacity = love.math.random() * .1 + .6 end

  filmgrain_effect(function()
		love.graphics.draw(img, 0, 0, 0, window.w / img:getWidth(), window.h / img:getHeight())
  end)


end

return splash
