-- adapted from https://github.com/elliottt/love-water.git
local Water = class("Water")

Water.waterbase = image["water"]

Water.moonwater = function()
  local shader = love.graphics.newShader[[
    extern Image waterbase;
    extern Image watershape;
    extern float time;
    extern vec2 mapoffset;
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {

      float timex = time * 3;
      vec2 mapc = ((sc.xy + mapoffset) / love_ScreenSize.xy) * 8;

      float x = ( sin( timex + 25 * mapc.x + 30 * mapc.y) + sin(-timex + 20 * mapc.x + 35 * mapc.y + 1) ) / 2;
      float y = ( sin( timex + 25 * mapc.x + 30 * mapc.y) + sin(-timex + 16 * mapc.x + 3 * mapc.y + 1.5) ) / 2;

      vec2 off = vec2(x,y) * 0.08 + 1;
      vec2 wc  = (mapc + 0.15 * off);

      wc = mapc*wc * 3;

      vec4 light = Texel(watershape, wc);
      vec4 dark  = Texel(watershape, wc + 0.3);
      vec4 shape = mix(mix(color, color * 0.9, dark), color * 2.2, light);

      float m = Texel(texture, tc).r;
      vec4 base = Texel(waterbase, mapc);
      vec4 final = vec4(base.r*m, base.g*m, base.b*m, 1.0) * shape;
      return final;//base * m;// * shape * mask ;
    }
  ]]

  local setters = {}

  setters.waterbase = function(v)
    shader:send("waterbase", v)
  end
  setters.watershape = function(v)
    shader:send("watershape", v)
  end
  setters.time = function(v)
    shader:send("time", v)
  end
  setters.mapoffset = function(v)
    shader:send("mapoffset", v)
  end

  return moonshine.Effect {
    name = "moonwater",
    shader = shader,
    setters = setters,
    defaults = { waterbase = image.water, mapoffset = {0,0}, watershape = image.watermask, time = 0.0 },
  }
end

Water.effect = moonshine(Water.moonwater)

function Water.update(dt)
  Water.effect.moonwater.time = game_time
  Water.effect.moonwater.mapoffset = { camera.x, camera.y }
end

function Water.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
  local bg = { love.graphics.getBackgroundColor() }
  love.graphics.setBackgroundColor({0,0,0,0})
  Water.effect(function()
    love.graphics.draw(Water.waterbase, x, y, r, sx, sy, ox, oy, kx, ky)
  end)
  love.graphics.setBackgroundColor(bg)
  love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end

return Water
