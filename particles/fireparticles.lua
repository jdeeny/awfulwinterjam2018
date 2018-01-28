local FireParticles = class("FireParticles", Particles)

local PI = 3.14159

FireParticles.static.puffimg = love.graphics.newImage("assets/particles/fire.png")

function FireParticles:initialize(x, y, w, h, lifetime, scale)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "fireparticles"
  self.id = self.kind .. math.random()
  self.particles = self:_createParticles(self.lifetime, self.scale)
  current_level:_addToLayer(Layer.ENTITYNOSHADOW, self.id, self)
  print("added fire")
end

function FireParticles:_createParticles(lifetime, scale)
  local emitter = love.graphics.newParticleSystem(FireParticles.puffimg, 1024)

  emitter:setEmitterLifetime(lifetime)
  emitter:setRotation(PI/4)
  emitter:setEmissionRate(64)
  emitter:setDirection(-PI/2)
  emitter:setLinearAcceleration(0,-25,0,-45)
  emitter:setSpeed(5,10)
  emitter:setColors(255,255,255,200, 0xf9, 0xa7, 0x2e, 200, 0xf9, 0x84, 0x2e, 200, 0xe0, 0x21, 0x14, 200, 0xe0, 0x21, 0x14, 180, 0xe0, 0x21, 0x14, 0 )
  -- emitter:setSpread(PI * 0.2)
  emitter:setSizes(scale, scale*.9, scale*.7, scale*.5, scale*.3)
  emitter:setSizeVariation(0.2)
  emitter:setSpin(math.random()*2*PI)
  emitter:setRotation(0, PI * 2)
  emitter:setAreaSpread('normal', w, w/3)
emitter:setParticleLifetime(0.75,1.25)

--[[  emitter:setEmissionRate(4096)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(-PI/2)
  emitter:setRadialAcceleration(-.5, -.75)
  emitter:setLinearAcceleration(0,-285,0,-315)
  emitter:setSpeed(20+math.random()*20,80+math.random()*20)
  local dark = 5 + math.random() * 10
  local mid = dark + math.random() * 20
  local light = mid + math.random() * 30
  emitter:setColors(dark,dark,dark,50 + math.random()*10,  mid,mid,mid,30+ math.random()*10, light,light,light, 15+ math.random()*10)
  emitter:setSpread(PI * 0.25 + math.random() * PI *0.125)
  emitter:setSizes(.05 * scale, .6 * scale)
  emitter:setSizeVariation(0.2)
  emitter:setSpinVariation(1)
  emitter:setRotation(0)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(.8,1.25)]]
  self.psystem = emitter
end

return FireParticles
