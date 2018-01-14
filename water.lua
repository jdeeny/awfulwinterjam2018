local moonwater = function()
  local shader = love.graphics.newShader[[
    extern Image watermask;
    extern float time;
    extern vec2 mapoffset;
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {

      float timex = time * 3;

      vec2 mapc = (sc.xy + mapoffset) / love_ScreenSize.xy;

       float x = ( sin( timex + 25 * mapc.x + 30 * mapc.y)
                 + sin(-timex + 20 * mapc.x + 35 * mapc.y + 1)
                 ) / 2;
       float y = ( sin( timex + 25 * mapc.x + 30 * mapc.y)
                 + sin(-timex + 16 * mapc.x + 3 * mapc.y + 1.5)
                 ) / 2;

       vec2 off = vec2(x,y) * 0.08 + 1;
       vec2 wc  = 3 * (mapc + 0.15 * off);

       wc = wc * 3;

       vec4 light = Texel(watermask, wc);
       vec4 dark  = Texel(watermask, wc + 0.3);
       vec4 base = Texel(texture, tc);
       vec4 mask = mix(mix(color, color * 0.9, dark), color * 2.2, light);
       return base * mask;
    }]]

  local setters = {}

  setters.watermask = function(v)
    shader:send("watermask", v)
  end
  setters.time = function(v)
    shader:send("time", v)
  end
  setters.mapoffset = function(v)
    shader:send("mapoffset", v)
  end

  --setters.darkcolor = function(v)
    --shader:send("darkcolor", math.min(1, math.max(0, tonumber(v) or 0)))
  --end

  return moonshine.Effect{
    name = "moonwater",
    shader = shader,
    setters = setters,
    defaults = { watermask = image.watermask, time = 0.0, mapoffset = {0,0} },
  }
end

return moonwater
