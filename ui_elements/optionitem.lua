local OptionItem = class('OptionItem')

function OptionItem:initialize(label)
	self.label = label
end

-- Return height in lines of text required for value
function OptionItem:requiredHeight()
	return 1
end


-- This should display the current 'value' of the option within the given rectangle
function OptionItem:drawIn(x,y,width,height)
	if self.value then
		love.graphics.printf(self.value, x, y, width, 'center')
	end
end

function OptionItem:getSetting()
	-- override
end

function OptionItem:clickedOn(xhit, yhit)
	-- Indicates a click received, relative to the center of the displayed value
end


-- These will alter the state of the option; no return required
function OptionItem:decrease()
	--override
end

function OptionItem:increase()
  -- override
end

function OptionItem:setTo()
	-- override
end

return OptionItem
