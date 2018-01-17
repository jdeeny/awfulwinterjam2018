local allowed_options = {}

---------------
local ListOptionItem = class('ListOptionItem', OptionItem)

function ListOptionItem:initialize(label,list, default)
	OptionItem.initialize(self, label)
	self.list = list
	self.index = default or 1
	self.value = list[self.index]
end

function ListOptionItem:decrease()
	self.index = math.max(1,self.index-1)
	self.value = self.list[self.index]
end

function ListOptionItem:increase()
	self.index = math.min(#(self.list),self.index+1)
	self.value = self.list[self.index]
end

-----------------

local MasterVolumeOI = class('MasterVolumeItem', OptionItem)


function MasterVolumeOI:initialize()
	OptionItem.initialize(self, "Master Volume")
	self.vol = 1.0
	self.value = "- 100% +"
end

function MasterVolumeOI:decrease()
	print(self.vol) --DBG
	self.vol = math.max(0, self.vol - 0.1)
	AudioManager.setMasterVolume(self.vol)
	self.value = self.value_for(self.vol)
end

function MasterVolumeOI:increase()
	print(self.vol) -- DBG
	self.vol = math.min(1, self.vol + 0.1)
	AudioManager.setMasterVolume(self.vol)
	self.value = self.value_for(self.vol)
end

function MasterVolumeOI:value_for(num)
	if num == 1.0 then
		return "- 100% "
	elseif num == 0 then
		return "    0% +"
	else 
		return "-  "..(num*100).."% +"
	end
end

local masterVolume = MasterVolumeOI:new()

-- these two should actually do something instead of just show values
local gameSpeed = ListOptionItem:new("Game Speed",{"slow","medium","fast"},2) 
local levelSelect = ListOptionItem:new("Level Select",{"Tesla's Arrival","Edison's Folly"})


allowed_options[1] = masterVolume
allowed_options[2] = gameSpeed
allowed_options[3] = levelSelect
allowed_options[4] = OptionItem:new("Back")

return allowed_options