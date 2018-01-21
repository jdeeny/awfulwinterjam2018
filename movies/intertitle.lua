local Intertitle = class("intertitle")

Intertitle.default_font = love.graphics.newFont(
    'assets/fonts/Birmingham.ttf', 50)
 
local filmgrain_effect = moonshine(moonshine.effects.desaturate)
                      .chain(moonshine.effects.filmgrain)
                      .chain(moonshine.effects.vignette)
  

function Intertitle:initialize(text, duration, font)
  self.text = text or "Default Text \n You shouldn't see this"
  self.end_time = love.timer.getTime() + duration

  if font then self.font = font else self.font=self.default_font end
 
  filmgrain_effect.filmgrain.size = 10
  filmgrain_effect.filmgrain.opacity = .6
  filmgrain_effect.desaturate.tint = {138, 111, 48}
end

function Intertitle:complete(dt)
  if love.timer.getTime() >= self.end_time then
    return true
  else
    return false
  end
end

function Intertitle:draw()
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.size = love.math.random() * 10 + 5 end
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.opacity = love.math.random() end
  if love.math.random() > 0.7 then filmgrain_effect.desaturate.strength = love.math.random() * .1 + .1 end
  filmgrain_effect(function()
    love.graphics.draw(image.intro, 0, 0, 0, window.w / image.intro:getWidth(), window.h / image.intro:getHeight())
    love.graphics.setFont(self.font)
    local th = mainmenu.font:getHeight()*3
    love.graphics.printf(self.text, 0, window.h/2-th/2,
      window.w, 'center')
    love.graphics.setFont(love.graphics.newFont())
  end)
end


return Intertitle
