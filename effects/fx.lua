
-- all the fx get passed and return a canvas

fx  = {}


local shader_blur5x = love.graphics.newShader([[
	const float kernel[5] = float[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);
	vec4 effect(vec4 color, sampler2D tex, vec2 tex_coords, vec2 pos) {
		color = texture2D(tex, tex_coords) * kernel[0];
		number factor = 1.0/love_ScreenSize.x;
		for(int i = 1; i < 5; i++) {
			color += texture2D(tex, vec2(tex_coords.x + i * 1.0/love_ScreenSize.x, tex_coords.y)) * kernel[i];
			color += texture2D(tex, vec2(tex_coords.x - i * 1.0/love_ScreenSize.x, tex_coords.y)) * kernel[i];
		}
		return color;
	}
]])


local shader_blur5y = love.graphics.newShader([[
	const float kernel[5] = float[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);
	vec4 effect(vec4 color, sampler2D tex, vec2 tex_coords, vec2 pos) {
		color = texture2D(tex, tex_coords) * kernel[0];
		number factor = 1.0/love_ScreenSize.y;
		for(int i = 1; i < 5; i++) {
			color += texture2D(tex, vec2(tex_coords.x, tex_coords.y + i * factor)) * kernel[i];
			color += texture2D(tex, vec2(tex_coords.x, tex_coords.y - i * factor)) * kernel[i];
		}
		return color;
	}
]])

--0.011254    0.016436    0.023066    0.031105    0.040306    0.050187    0.060049    0.069041    0.076276    0.080977    

--0.082607,0.080977,0.076276,0.069041,0.060049,0.050187,0.040306,0.031105,0.023066,0.016436,0.011254
function fx.blur(canvas)

    local canvas_x = love.graphics.newCanvas()
    local canvas_y = love.graphics.newCanvas()

    local mode = love.graphics.getBlendMode()
    love.graphics.setBlendMode("alpha", "premultiplied")

    canvas_x:renderTo(function()
        love.graphics.setShader(shader_blur5x)
        love.graphics.draw(canvas, 0, 0)
        love.graphics.setShader()
    end)


    canvas_y:renderTo(function()
        love.graphics.setShader(shader_blur5y)
        love.graphics.draw(canvas_x, 0, 0)
        love.graphics.setShader()
    end)

    love.graphics.setBlendMode(mode)

    return canvas_y
end


return fx