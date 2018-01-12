local film = {
  text = nil,
  film_text = "Default Text \n You shouldn't see this",
  font = love.graphics.newFont(
    'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

function film.init()
  filmgrain_effect = moonshine(moonshine.effects.desaturate)
                      .chain(moonshine.effects.filmgrain)
                      .chain(moonshine.effects.vignette)
  filmgrain_effect.filmgrain.size = 10
  filmgrain_effect.filmgrain.opacity = .6
  filmgrain_effect.desaturate.tint = {138, 111, 48}
end

function film.set_title(text)
  film.film_text = text
end

function film.update()
  menu_input:update()

    if menu_input:pressed('sel') then game_state = 'play' end
  end

function film.draw()
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.size = love.math.random() * 10 + 5 end
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.opacity = love.math.random() end
  if love.math.random() > 0.7 then filmgrain_effect.desaturate.strength = love.math.random() * .1 + .1 end
  filmgrain_effect(function()
    love.graphics.draw(image.intro, 0, 0, 0, window.w / image.intro:getWidth(), window.h / image.intro:getHeight())
    love.graphics.setFont(film.font)
    local th = main_menu.font:getHeight()*3
    love.graphics.printf(film.film_text, 0, love.graphics.getHeight()/2-th/2,
      love.graphics.getWidth(), 'center')
    love.graphics.setFont(love.graphics.newFont())
  end)
end


return film