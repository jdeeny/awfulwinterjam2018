local moonshine = require('lib/moonshine')
local moonwater = function(moonshine)
  local shader = love.graphics.newShader[[
    extern Image watertex;
    extern float time;
    extern vec4 darkColor;
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
      tc = sc.xy / love_ScreenSize.xy;

       float x = ( sin( time + 25 * tc.x + 30 * tc.y)
                 + sin(-time + 20 * tc.x + 35 * tc.y + 1)
                 ) / 2;
       float y = ( sin( time + 25 * tc.x + 30 * tc.y)
                 + sin(-time + 16 * tc.x + 3 * tc.y + 1.5)
                 ) / 2;

       vec2 off = vec2(x,y) * 0.08 + 1;
       vec2 wc  = 3 * (tc + 0.15 * off);

       vec4 light = Texel(watertex, wc);
       vec4 dark  = Texel(watertex, wc + 0.3);

       return mix(mix(color, color * 0.9, dark), color * 2.2, light);
    }]]

  local setters = {}

  setters.watertex = function(v)
    shader:send("watertex", v)
  end
  setters.darkcolor = function(v)
    shader:send("darkcolor", math.min(1, math.max(0, tonumber(v) or 0)))
  end

  local draw = function(buffer)
    shader:send("time", game_time)
    moonshine.draw_shader(buffer, shader)
  end

  return moonshine.Effect{
    name = "water",
    draw = draw,
    setters = setters,
    defaults = {watertex = nil, darkcolor = {50,50,50}}
  }
end

return moonwater
