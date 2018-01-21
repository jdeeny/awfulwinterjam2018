Intertitle = require "movies/intertitle"

-------------------------------------------------------------------------------
local SequenceStep = class("SequenceStep")

function SequenceStep:initialize( seq_table )
  self.type = seq_table.type
  self.run_time = seq_table.run_time or 9999
  self._start = seq_table.start
  self._stop = seq_table.stop
  self._update = seq_table.update
  self._draw = seq_table.draw
end

function SequenceStep:start( ... )
  self.start_time = love.timer.getTime()
  self._started = true
  self._running = true
  
  if self._start then
    self:_start()
  end
end

function SequenceStep:update(dt)
  if self._running then
    if love.timer.getTime() > (self.start_time + self.run_time) then
      self._running = false
    else
      if self._update then
        self:_update(dt)
      end
      if self.type == 'animation' then
        movie_a._update_level(dt)
      end
    end
  end
end

function SequenceStep:stop( ... )
  if self._running then
    self._running = false
    if self._stop then
      self:_stop()
    end
  end
end

function SequenceStep:draw( ... )
  if self._draw and self._running then
    self:_draw()
  end

  if self.type == 'animation' then
    movie_a._draw_level()
  end
end

function SequenceStep:is_finished( ... )
  if not self._started then
    return false 
  end
  return not self._running
end

-------------------------------------------------------------------------------
IntertitleStep = class("IntertitleStep",SequenceStep)

function IntertitleStep:initialize(text, duration)
  self._text = text
  self._duration = duration
  local startfunc = function(self)
    self.intertitle = Intertitle:new(self._text,self._duration)
  end
  local updatefunc = function(self, dt)
    if self.intertitle:complete() then
        self:stop()
      end
  end
  local drawfunc = function(self)
    self.intertitle:draw()
  end
  SequenceStep.initialize(self, {start=startfunc, update=updatefunc,
    draw=drawfunc, type='intertitle'})
end


return {SequenceStep=SequenceStep, IntertitleStep=IntertitleStep}