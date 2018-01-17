local allowed_options = {}

---------------
local ListOptionItem = class('ListOptionItem', OptionItem)

function ListOptionItem:initialize(label,values, default, control_name, control_field, control_values)
	OptionItem.initialize(self, label)
	self.list = values
	self.index = default or 1
	self.value = values[self.index]
	
	self.control = control_name
	self.control_field = control_field
	self.c_values = control_values
end

function ListOptionItem:decrease()
	self.index = math.max(1,self.index-1)
	self:updateValue()
end

function ListOptionItem:increase()
	self.index = math.min(#(self.list),self.index+1)
	self:updateValue()
end

function ListOptionItem:updateValue()
	self.value = self.list[self.index]
	if self.control then
		_G[self.control][self.control_field] = self.c_values[self.index]
	end
end

-----------------

local MasterVolumeOI = class('MasterVolumeItem', OptionItem)


function MasterVolumeOI:initialize()
	OptionItem.initialize(self, "Master Volume")
	self.vol = 1.0
	self.value = "- 100% +"
end

function MasterVolumeOI:decrease()
	self.vol = math.max(0, self.vol-0.1)
	AudioManager:setMasterVolume(self.vol)
	self.value = self:value_for(self.vol)
end

function MasterVolumeOI:increase()
	self.vol = math.min(1, self.vol+0.1)
	AudioManager:setMasterVolume(self.vol)
	self.value = self:value_for(self.vol)
end

function MasterVolumeOI:value_for(num)
	if num == 1.0 then
		return "- 100% "
	elseif num == 0 then
		return "  OFF  +"
	else 
		return "-  "..(num*100).."% +"
	end
end

local masterVolume = MasterVolumeOI:new()

local gameSpeed = ListOptionItem:new("Game Speed",{"super-slow (debug)","slow","medium","fast"},3,
                                     'settings','game_speed', {0.3,0.75,1.0,1.25}) 

-- Currently levelSelect does nothing
local levelSelect = ListOptionItem:new("Level Select",{"Tesla's Arrival","Edison's Folly"})


allowed_options[1] = masterVolume
allowed_options[2] = gameSpeed
allowed_options[3] = levelSelect
allowed_options[4] = OptionItem:new("Back")

return allowed_options