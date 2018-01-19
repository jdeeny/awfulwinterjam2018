local BloodParticles = class("BloodParticles", Particles)

local PI = 3.14159

BloodParticles.static.puffimg = love.graphics.newImage("assets/particles/smokepuff.png")

function BloodParticles:initialize(x, y, w, h, lifetime, scale)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "bloodparticles"
  self.particles = self:_createParticles(self.lifetime, self.scale)
  current_level:_addToLayer(Layer.ENTITYNOSHADOW, self.id, self)
end

function BloodParticles:_createParticles(lifetime, scale)
  local emitter = love.graphics.newParticleSystem(BloodParticles.puffimg, 16)
  emitter:setEmissionRate(1024)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(PI/2)
  emitter:setLinearAcceleration(0,0)
  emitter:setSpeed(2000+math.random()*2000+math.random()*math.random()*5000,0,0,0,0)
  emitter:setLinearDamping(200)
  local dark = 150 + math.random() * 10
  local mid = dark + math.random() * 20
  local light = mid + math.random() * 30
  emitter:setColors(dark,dark*0.1,dark*0.1,240 + math.random()*10,  mid,mid*0.1,mid*0.1,240+ math.random()*10, light,light*0.1,light*0.1, 240+ math.random()*10)
  emitter:setSpread(PI + math.random() * PI *0.75)
  emitter:setSizes(.05 * scale, .25 * scale)
  emitter:setSizeVariation(0.5)
  emitter:setSpinVariation(1)
  emitter:setRotation(0)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(50000)
  self.psystem = emitter
end

return BloodParticles
