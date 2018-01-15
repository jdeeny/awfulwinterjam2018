local AudioManager = class("AudioManager")

  function AudioManager:initialize()
    self.sources = {}
    self.looped = {}
    self.loop_count = 0

    -- Short sound effects should be loaded with static to store in memory.
    self.sources['snap'] = PooledSource:new("assets/sfx/snap.wav")
    self.sources['unh'] = PooledSource:new("assets/sfx/unh.wav")
    self.sources['unlatch'] = PooledSource:new("assets/sfx/unlatch.wav")
    self.sources['crackle'] = PooledSource:new("assets/sfx/crackle.wav")
    self.sources['car1'] = PooledSource:new("assets/sfx/car1.ogg")
    self.sources['car2'] = PooledSource:new("assets/sfx/car2.ogg")
    self.sources['car3'] = PooledSource:new("assets/sfx/car3.ogg")
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

  function AudioManager:addEffect(path, name)
    self.sources[name] = PooledSource:new(path)
  end

  function AudioManager:playOnce(name, volume)
    if self.sources[name] then
      self.sources[name]:play()
    else
      print("Tried to play sound \'" .. name .. "\' but it doesn't exist.")
    end
  end

  function AudioManager:playLooped(name, volume, prelude, epilogue)
    self.loop_count = self.loop_count + 1
    local play = LoopedAudio.new(self.loop_count, name, volume, prelude, epilogue)
    self.looped[self.loop_count] = play
    if play.epilogue then
      self.playOnce(prelude, volume)
    else
      self.playOnce(name, volume)
    end
    return play.id
  end

  function AudioManager:stopLooped(id)
    if self.looped[id] then
        self.looped[id].name = nil --:stop()
--      if self.looped[id].name then
    end
  end
return AudioManager
