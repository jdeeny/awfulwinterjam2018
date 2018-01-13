local AudioManager = class("AudioManager")

  function AudioManager:initialize()
    self.sources = {}

    -- Short sound effects should be loaded with static to store in memory.
    self.sources['snap'] = PooledSource:new("assets/sfx/snap.wav")
    self.sources['unh'] = PooledSource:new("assets/sfx/unh.wav")
    self.sources['unlatch'] = PooledSource:new("assets/sfx/unlatch.wav")
    self.sources['crackle'] = PooledSource:new("assets/sfx/crackle.wav")
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

return AudioManager
