local ExplosionParticles = class("ExplosionParticles", Particles)

local PI = 3.14159

ExplosionParticles.static.puffimg = love.graphics.newImage("assets/particles/explosion.png")

function ExplosionParticles:initialize(x, y, w, h, lifetime, scale)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "explosionparticles"
  self.id = self.kind .. math.random()
  self.particles = self:_createParticles(self.lifetime, self.scale)
  current_level:_addToLayer(Layer.ENTITYNOSHADOW, self.id, self)
end

function ExplosionParticles:_createParticles(lifetime, scale)
  local emitter = love.graphics.newParticleSystem(ExplosionParticles.puffimg, 4096)
  emitter:setEmissionRate(1024 * 100)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(-PI/2)
  --emitter:setRadialAcceleration(.2, 20)
  --emitter:setLinearAcceleration(0,-285,0,-315)
  emitter:setSpeed(20+math.random()*20,290+math.random()*90)
  emitter:setColors(255,255,255,2)
  emitter:setSpread(PI * 2)
  emitter:setSizes(.6*scale, scale)
  emitter:setSizeVariation(0.2)
  emitter:setSpinVariation(1)
  emitter:setRotation(0)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(.05,.2)
  self.psystem = emitter
end

return ExplosionParticles
