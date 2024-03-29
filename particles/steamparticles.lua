local SteamParticles = class("SteamParticles", Particles)

local PI = 3.14159

SteamParticles.static.puffimg = love.graphics.newImage("assets/particles/smokepuff.png")

function SteamParticles:initialize(x, y, w, h, lifetime, scale)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.kind = "steamparticles"
  self.id = self.kind .. math.random()
  self.particles = self:_createParticles(self.lifetime, self.scale)
  current_level:_addToLayer(Layer.ENTITYNOSHADOW, self.id, self)
end

function SteamParticles:_createParticles(lifetime, scale)
  local emitter = love.graphics.newParticleSystem(SteamParticles.puffimg, 4096)
  emitter:setEmissionRate(4096)
  emitter:setEmitterLifetime(lifetime)
  emitter:setDirection(-PI/2)
  emitter:setRadialAcceleration(-.5, -.75)
  emitter:setLinearAcceleration(0,-285,0,-315)
  emitter:setSpeed(20+math.random()*20,80+math.random()*20)
  local dark = 205 + math.random() * 10
  local mid = cpml.utils.clamp(dark + math.random() * 20,0,255)
  local light = cpml.utils.clamp(mid + math.random() * 30, 0, 255)
  emitter:setColors(dark,dark,dark,50 + math.random()*10,  mid,mid,mid,30+ math.random()*10, light,light,light, 15+ math.random()*10)
  emitter:setSpread((PI * 0.25 + math.random() * PI *0.125) * scale)
  emitter:setSizes(.05 * scale, .6 * scale)
  emitter:setSizeVariation(0.2)
  emitter:setSpinVariation(1)
  emitter:setRotation(0)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(.8,1.25)
  self.psystem = emitter
end

return SteamParticles
