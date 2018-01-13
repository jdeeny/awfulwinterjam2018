delay = class('delay')

delay.events = {}

function delay.start(time, f)
	-- run function f after a delay
	delay.events[game_time + time] = f
end

function delay.process()
	for j,z in pairs(delay.events) do
		if game_time > j then
			z()
			delay.events[j] = nil
		end
	end
end

return delay
