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
//      vec2 mapc = ((sc.xy + mapoffset) / love_ScreenSize.xy);
      vec2 mapct = (sc.xy * 1.0 / love_ScreenSize.xy) + (mapoffset * 1.0 / love_ScreenSize.xy);
      vec2 mapcm = (sc.xy * 1.0 / love_ScreenSize.xy) + (mapoffset * 0.8 / love_ScreenSize.xy);
      vec2 mapcl = (sc.xy * 1.0 / love_ScreenSize.xy) + (mapoffset * 0.6 / love_ScreenSize.xy);

      float xt = ( sin( timex + 25 * mapct.x + 30 * mapct.y) + sin(-timex + 20 * mapct.x + 35 * mapct.y + 1) ) / 2;
      float yt = ( sin( timex + 25 * mapct.x + 30 * mapct.y) + sin(-timex + 16 * mapct.x + 3 * mapct.y + 1.5) ) / 2;
      float xm = ( sin( timex + 25 * mapcm.x + 30 * mapcm.y) + sin(-timex + 20 * mapcm.x + 35 * mapcm.y + 1) ) / 2;
      float ym = ( sin( timex + 25 * mapcm.x + 30 * mapcm.y) + sin(-timex + 16 * mapcm.x + 3 * mapcm.y + 1.5) ) / 2;
      float xl = ( sin( timex + 25 * mapcl.x + 30 * mapcl.y) + sin(-timex + 20 * mapcl.x + 35 * mapcl.y + 1) ) / 2;
      float yl = ( sin( timex + 25 * mapcl.x + 30 * mapcl.y) + sin(-timex + 16 * mapcl.x + 3 * mapcl.y + 1.5) ) / 2;

      vec2 offt = vec2(xt,yt) * 0.08 + 1;
      vec2 offm = vec2(xm,ym) * 0.08 + 1;
      vec2 offl = vec2(xl,yl) * 0.08 + 1;


      vec2 wct  = 12 * (mapct + 0.15 * offt);
      vec2 wcm  = 15 * (mapcm + 0.15 * offm);
      vec2 wcl  = 19 * (mapcl + 0.15 * offl);

      float m = Texel(texture, tc).r;
      vec4 base = Texel(waterbase, tc);

      vec4 lightt = Texel(watershape, wct * 0.8);
      vec4 lightm = Texel(watershape, wcm * 0.6);
      vec4 lightl = Texel(watershape, wcl * 0.3);
      vec4 darkt  = Texel(watershape, (wct + 0.3) * 1.2);
      vec4 darkm  = Texel(watershape, (wcm + 0.3) * 0.9);
      vec4 darkl  = Texel(watershape, (wcl + 0.3) * 0.5);

      vec4 shape = mix(mix(
        mix(mix(base, base * 0.9, darkt), base * 1.8, lightt),
        mix(mix(base, base * 0.4, darkm), base * 1.2, lightm),
        0.5),
        mix(mix(base, base * 0.2, darkl), base * 0.9, lightl),
        0.3);

      shape.a = m;
      return shape;
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
    defaults = { waterbase = image.water, mapoffset = {0,0}, watershape = image.watershape, time = 0.0 },
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
