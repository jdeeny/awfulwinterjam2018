local SmokeParticles = class("SmokeParticles", Particles)

local PI = 3.14159

SmokeParticles.static.puffimg = love.graphics.newImage("assets/particles/smokepuff.png")

function SmokeParticles:initialize(x, y, w, h, lifetime, scale)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "smokeparticles"
  self.id = self.kind .. math.random()
  self.particles = self:_createParticles(self.lifetime, self.scale)
  current_level:_addToLayer(Layer.SMOKE, self.id, self)
end

function SmokeParticles:_createParticles(lifetime, scale)
  local emitter = love.graphics.newParticleSystem(SmokeParticles.puffimg, 4096)
  emitter:setEmissionRate(256)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(-PI/2)
  emitter:setRadialAcceleration(-.05, -.075)
  emitter:setLinearAcceleration(0,-28.5,0,-31.5)
  emitter:setSpeed(6+math.random()*2,28+math.random()*2)
  local dark = 10 + math.random() * 10
  local mid = dark + math.random() * 20
  local light = mid + math.random() * 30
  emitter:setColors(dark,dark,dark,10 + math.random()*5,  mid,mid,mid,8+ math.random()*6, light,light,light, 5+ math.random()*2)
  emitter:setSpread(PI * 0.25 + math.random() * PI *0.125)
  emitter:setSizes(.05 * scale, .9 * scale)
  emitter:setSizeVariation(0.2)
  emitter:setSpinVariation(1)
  emitter:setRotation(0, PI * 2)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(lifetime / 12,lifetime/5)
  self.psystem = emitter
end

return SmokeParticles
