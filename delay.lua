delay = class('delay')

delay.events = {}

function delay.start(time, f)
	-- run function f after a delay
	table.insert(delay.events, {end_time = game_time + time, f = f})
end

function delay.process()
	for j,z in pairs(delay.events) do
		if game_time > z.end_time then
			z.f()
			delay.events[j] = nil
		end
	end
end

return delay
