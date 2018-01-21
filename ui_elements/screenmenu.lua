local ScreenMenu = class('ScreenMenu')

function ScreenMenu:initialize(item_list,line_height,separator_height,highlight_color,unhighlight_color)
	self.items = item_list
	self.line_ht = line_height
	self.hl_color = highlight_color
	self.uh_color = unhighlight_color
	self.sep_ht = separator_height
	self.warning_issued = false
end


function ScreenMenu:draw(selected,menu_top_y)
	local y_start = menu_top_y or 0
	local all_items_height = 0

	for i,opt in ipairs(self.items) do
		-- 1 line for the label, + space for the option
		local label_req = 0
		if opt.label then
			label_req = 1
		end
		all_items_height = all_items_height + self.line_ht*(label_req + opt:requiredHeight()) + self.sep_ht
	end

	local cur_y = y_start + (window.h - all_items_height)/2

	if all_items_height + y_start > window.h then
		if not self.warning_issued then
			print("Warning: menu items cannot all fit on screen")
			self.warning_issued = true
		end
		cur_y = 0 -- do our best
	end
	
	love.graphics.setColor(unpack(self.uh_color))
	
	for i,opt in ipairs(self.items) do
		local opt_ht = opt:requiredHeight()*self.line_ht
		if selected == i then
			-- maybe use the stencil if we want to highlight shapes in the options
			 --love.graphics.stencil( love.graphics.rectangle('fill', 0, cur_y, window.w, opt_ht), "replace", 1)
			 love.graphics.setColor(unpack(self.hl_color))
		end
		
		-- print this option's label if it has one
		if opt.label then
			love.graphics.printf(opt.label, 0, cur_y, window.w, 'center')
			cur_y = cur_y + self.line_ht
		end
		
		-- print the option
		opt:drawIn(0,cur_y,window.w,opt_ht)
		if selected == i then
			love.graphics.setColor(unpack(self.hl_color))
			
			-- draw arrows
			local arrow_dir = {}
			-- left and right here refer to the side of the screen
			if opt.invert_pointers then
				-- inward
				arrow_dir.left = 1
				arrow_dir.right = -1
			else
				-- outward
				arrow_dir.left = -1
				arrow_dir.right = 1
			end
			
			if not opt:atMax() then
				love.graphics.draw(image['point'], window.w - 200 - 20 * math.cos(6.28 * gui_time), cur_y + 20, 0, arrow_dir.right, 1, 48, 32)
			end
			if not opt:atMin() then
				love.graphics.draw(image['point'], 200 + 20 * math.cos(6.28 * gui_time), cur_y + 20, 0, arrow_dir.left, 1, 48, 32)
			end
		end

		love.graphics.setColor(unpack(self.uh_color))

		cur_y = cur_y + opt_ht + self.sep_ht
	end
end



return ScreenMenu