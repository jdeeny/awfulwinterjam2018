local AudioManager = class("AudioManager")

  function AudioManager:initialize()
    self.sources = {}
    self.music_tracks = {}
    self.looped = {}
    self.loop_count = 0
    self.music = nil -- currently playing track

    -- Short sound effects should be loaded with static to store in memory.
    self.sources['snap'] = PooledSource:new("assets/sfx/snap.wav")
    self.sources['unh'] = PooledSource:new("assets/sfx/unh.wav")
    self.sources['unlatch'] = PooledSource:new("assets/sfx/unlatch.wav")
    self.sources['crackle'] = PooledSource:new("assets/sfx/crackle.wav")
    -- self.sources['car1'] = PooledSource:new("assets/sfx/car1.ogg")
    -- self.sources['car2'] = PooledSource:new("assets/sfx/car2.ogg")
    -- self.sources['car3'] = PooledSource:new("assets/sfx/car3.ogg")
    self.sources['gunshot'] = PooledSource:new("assets/sfx/gunshot.wav")
    self.sources['buzz'] = PooledSource:new("assets/sfx/buzz-super-short.wav")
    self.sources['tesla_hum1'] = PooledSource:new(
      "assets/sfx/362975__follytowers__big-tesla-coil-sound-cut.wav")
    self.sources['spark'] = PooledSource:new("assets/sfx/94132__bmaczero__spark.wav")
    self.sources['crash'] = PooledSource:new("assets/sfx/crash.ogg")

    -- Music is probably better to stream.  Only one music track is playable at a time.
    self.music_tracks['figleaf'] = love.audio.newSource(
      "assets/music/Fig Leaf Times Two.ogg", "stream")
  end

  function AudioManager:update(dt)
    for id, loop in pairs(self.looped) do
      if loop.prelude then
        if not loop.prelude.isPlaying() then
          loop.prelude = nil
        end
      elseif loop.name then
        if not loop.name.isPlaying() then
          self.playOnce(loop.name)
        end
      elseif loop.epilogue then
        if not loop.epilogue.isPlaying() then
          loop.epilogue = nil
        end
      else
        self.looped[loop.id] = nil
      end
    end
  end

  function AudioManager:setMasterVolume(volume)
    love.audio.setVolume(volume)
  end

  function AudioManager:getSource( ... )
    -- body
  end

  function AudioManager:addEffect(path, name)
    self.sources[name] = PooledSource:new(path)
  end

  function AudioManager:playOnce(name)
    if self.sources[name] then
      self.sources[name]:play()
    else
      print("Tried to play sound \'" .. name .. "\' but it doesn't exist.")
    end
  end

  function AudioManager:playLooped(name, volume, prelude, epilogue)
    --[[self.loop_count = self.loop_count + 1
    local play = LoopedAudio:new(self.loop_count, name, volume, prelude, epilogue)
    self.looped[self.loop_count] = play
    if play.epilogue then
      self:playOnce(prelude, volume)
    else
      self:playOnce(name, volume)
    end
    return play.id]]
  end

  function AudioManager:stopLooped(id)
  --[[  if self.looped[id] then
        self.looped[id].name = nil --:stop()
--      if self.looped[id].name then
end]]
  end

  -- Plays music (only track at a time). Volume is 0-1, offset is in seconds
  function AudioManager:playMusic(name, volume, offset)
    local vol = volume or 1.0
      if self.music_tracks[name] then
      if self.music then
          love.audio.stop(self.music)
      end
        self.music = self.music_tracks[name]
    self.music:setVolume(vol)

    love.audio.play(self.music)

    -- seeking must be done after music starts
    if offset then
      self.music:seek(offset)
    end
      else
        print("Tried to play music track  \'" .. name .. "\' but it doesn't exist.")
      end
  end

  function AudioManager:stopMusic()
    if self.music then
      love.audio.stop(self.music)
      self.music = nil
    end
  end

return AudioManager
