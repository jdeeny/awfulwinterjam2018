local film = {
  text = nil,
  film_text = "Default Text \n You shouldn't see this",
  music = {},
  font = love.graphics.newFont(
    'assets/fonts/babes-in-toyland-nf/BabesInToylandNF.ttf', 50),
}

function film.enter()
  filmgrain_effect = moonshine(moonshine.effects.desaturate)
                      .chain(moonshine.effects.filmgrain)
                      .chain(moonshine.effects.vignette)
  filmgrain_effect.filmgrain.size = 10
  filmgrain_effect.filmgrain.opacity = .6
  filmgrain_effect.desaturate.tint = {138, 111, 48}
  if film.music.track then
	  local music = film.music
	  audiomanager:playMusic(music.track, music.volume, music.offset)
  end
  state = STATE_FILM
end

function film.set_title(text)
  film.film_text = text
end

function film.set_music(music, starts_at, volume)
	film.music.track = music 
	film.music.offset = starts_at
	film.music.volume = volume
end

function film.update()
  player_input:update()

    if player_input:pressed('fire') or player_input:pressed('sel') then
      new_game()
	  audiomanager:stopMusic()
      play.enter()
    end
  end

function film.draw()
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.size = love.math.random() * 10 + 5 end
  if love.math.random() > 0.7 then filmgrain_effect.filmgrain.opacity = love.math.random() end
  if love.math.random() > 0.7 then filmgrain_effect.desaturate.strength = love.math.random() * .1 + .1 end
  filmgrain_effect(function()
    love.graphics.draw(image.intro, 0, 0, 0, window.w / image.intro:getWidth(), window.h / image.intro:getHeight())
    love.graphics.setFont(film.font)
    local th = mainmenu.font:getHeight()*3
    love.graphics.printf(film.film_text, 0, window.h/2-th/2,
      window.w, 'center')
    love.graphics.setFont(love.graphics.newFont())
  end)
end


return film
