duration = class('duration')

function duration.start(length, gui_based)
	o = duration:new()
	o.length_scale = 1 / length
	o.gui_based = gui_based
	if gui_based then
		o.start_time = gui_time
		o.end_time = gui_time + length
	else
		o.start_time = game_time
		o.end_time = game_time + length
	end

	return o
end

function duration:finished()
	return self.gui_based and (gui_time >= self.end_time) or (game_time >= self.end_time)
end

function duration:t()
	-- return 0 <= t <= 1 the fraction of duration past
	return self.gui_based and cpml.utils.clamp((gui_time - self.start_time) * self.length_scale, 0, 1) or
		cpml.utils.clamp((game_time - self.start_time) * self.length_scale, 0, 1)
end

return duration
