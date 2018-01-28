local RemoteSmokeParticles = class("RemoteSmokeParticles", Particles)

local PI = 3.14159

RemoteSmokeParticles.static.puffimg = love.graphics.newImage("assets/particles/smokepuff.png")

function RemoteSmokeParticles:initialize(x, y, w, h, lifetime, scale, dir)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "remotesmokeparticles"
  self.id = self.kind .. math.random()
  self.dir = dir or -PI/2
  self.particles = self:_createParticles(self.lifetime, self.scale, self.dir)
  current_level:_addToLayer(Layer.SMOKE, self.id, self)
end

function RemoteSmokeParticles:_createParticles(lifetime, scale, dir)
  local emitter = love.graphics.newParticleSystem(RemoteSmokeParticles.puffimg, 128)
  emitter:setEmissionRate(512 * 10)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(dir)
  emitter:setRadialAcceleration(.2, 2)
  --emitter:setLinearAcceleration(0,-285,0,-315)
  emitter:setSpeed(20+math.random()*20,30+math.random()*20)
  local dark = 45 + math.random() * 10
  local mid = cpml.utils.clamp(dark + math.random() * 70 + 20, 0, 255)
  local light = cpml.utils.clamp(mid + math.random() * 70 + 20, 0, 255)
  emitter:setColors(dark,dark,dark,10 + math.random()*5,  mid,mid,mid,5+ math.random()*5, light,light,light, 3+ math.random()*2)
  emitter:setSpread((PI * 0.25 + math.random() * PI *0.125) * scale)
  emitter:setSizes(.1 * scale, .6 * scale)
  emitter:setSizeVariation(0.2)
  emitter:setSpinVariation(1)
  emitter:setRotation(.2)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(.8,1.25)
  self.psystem = emitter
end

return RemoteSmokeParticles
