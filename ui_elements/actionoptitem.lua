local ActionOptItem = class('ActionOptItem',OptionItem)

function ActionOptItem:initialize(label,action)
	OptionItem:initialize(self)  -- label is blank
	self.value = label
	self.invert_pointers = true
	if action then
		self.on_activate = action
	else
		self.on_activate = function() end
	end
end

-- Setting one or both of these true may cause arrows to be shown
function ActionOptItem:atMin()
	return true -- indicates that option can go no lower
end

function ActionOptItem:atMax()
	return true -- indicates that option can go no higher
end

function ActionOptItem:clickedIn(xhit, yhit)
	-- Indicates a click received, relative to the center of the displayed value
end

function ActionOptItem:setAction(func)
	self.on_activate = func
end

function ActionOptItem:activate()
	self.on_activate()
	-- Happens when the user hits fire/space while this item is selected
end


return ActionOptItem
