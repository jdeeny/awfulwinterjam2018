delay = class('delay')

delay.events = {}

function delay.start(time, f)
	-- run function f after a delay
	local new_id = idcounter.get_id("delay")
	delay.events[new_id] = {}
	delay.events[new_id].duration = duration.start(time)
	delay.events[new_id].f = f
end

function delay.process()
	for j,z in pairs(delay.events) do
		if z.duration:finished() then
			z.f()
			delay.events[j] = nil
		end
	end
end

return delay
