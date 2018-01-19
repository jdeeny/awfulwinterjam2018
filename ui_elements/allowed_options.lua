local allowed_options = {}

---------------
local ListOptionItem = class('ListOptionItem', OptionItem)

function ListOptionItem:initialize(label, values, control_name, control_field, control_values)
	OptionItem.initialize(self, label)
	self.list = values
	self.index = 1
	self.control = control_name
	self.control_field = control_field
	self.c_values = control_values
end

function ListOptionItem:atMin()
	return self.index == 1
end

function ListOptionItem:atMax()
	return self.index == #(self.list)
end

function ListOptionItem:decrease()
	self.index = math.max(1,self.index-1)
	self:updateValue()
end

function ListOptionItem:increase()
	self.index = math.min(#(self.list),self.index+1)
	self:updateValue()
end

function ListOptionItem:setTo(i)
	self.index = i
	self:updateValue()
end

function ListOptionItem:getSetting()
	return self.index
end

function ListOptionItem:updateValue()
	self.value = self.list[self.index]
	
	if self.control and self.control_field then
		_G[self.control][self.control_field] = self.c_values[self.index]
	elseif self.control then -- a plain variable
		_G[self.control] = self.c_values[self.index]
	end
end

-----------------

local MasterVolumeOI = class('MasterVolumeOptionItem', OptionItem)


function MasterVolumeOI:initialize()
	OptionItem.initialize(self, "Volume")
	self.vol = 100
	self.value = "- 100% +"
end

function OptionItem:atMin()
	return self.vol == 0
end

function OptionItem:atMax()
	return self.vol == 100
end

function MasterVolumeOI:decrease()
	self.vol = math.max(0, self.vol-10)
	AudioManager:setMasterVolume(self.vol/10)
	self:updateValue()
end

function MasterVolumeOI:increase()
	self.vol = math.min(100, self.vol+10)
	AudioManager:setMasterVolume(self.vol/10)
	self:updateValue()
end

function MasterVolumeOI:setTo(val)
	self.vol = val
	AudioManager:setMasterVolume(self.vol/10)
	self:updateValue()
end

function MasterVolumeOI:getSetting()
	return self.vol
end

function MasterVolumeOI:updateValue()
	self.value = self.vol == 0 and "OFF" or self.vol .. " %"
end

local masterVolume = MasterVolumeOI:new()

local gameSpeed = ListOptionItem:new("Game Speed",{"super-slow (debug)","slow","medium","fast"},
                                     'gameplay_speed', nil, {0.3,0.75,1.0,1.25})

local stageSelect = ListOptionItem:new("Stage Select",{"Tesla's Arrival","Edison's Folly"},'gamestage','current_stage',{1,2})


allowed_options[1] = masterVolume
allowed_options[2] = gameSpeed
allowed_options[3] = stageSelect
allowed_options[4] = OptionItem:new("Back")

return allowed_options
