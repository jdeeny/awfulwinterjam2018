local intro = {}

function intro.init()
  filmgrain_effect = moonshine(moonshine.effects.desaturate)
                      .chain(moonshine.effects.filmgrain)
                      .chain(moonshine.effects.vignette)
  filmgrain_effect.filmgrain.size = 10
  filmgrain_effect.filmgrain.opacity = .6
  filmgrain_effect.desaturate.tint = {138, 111, 48}
end

function intro.draw()
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.size = love.math.random() * 10 + 5 end
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.opacity = love.math.random() end
  if love.math.random() > 0.7 then filmgrain_effect.desaturate.strength = love.math.random() * .1 + .1 end
  filmgrain_effect(function()
    love.graphics.draw(image.intro, 0, 0, 0, window.w / image.intro:getWidth(), window.h / image.intro:getHeight())
  end)
end


return intro
