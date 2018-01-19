local WaterParticles = class("WaterParticles", Particles)

local PI = 3.14159

WaterParticles.static.puffimg = love.graphics.newImage("assets/particles/waterdrop.png")

function WaterParticles:initialize(x, y, w, h, force, scale, qty)
  self.qty = cpml.utils.clamp(qty or 8, 1, 16)
  Particles.initialize(self, x, y, w, h, lifetime)--camera.view_x({x = x, y = y}), camera.view_y({x = x, y = y}))
  self.scale = scale or 1.0
  self.angle = angle
  self.kind = "waterarticles"
  self.particles = self:_createParticles(self.force, self.scale)
  current_level:_addToLayer(Layer.BLOOD, self.id, self)
end

function WaterParticles:_createParticles(force, scale)
  local emitter = love.graphics.newParticleSystem(WaterParticles.puffimg, self.qty)
  emitter:setEmissionRate(1000)
  emitter:setEmitterLifetime(0.1)
  emitter:setDirection(-PI/2)
  emitter:setLinearAcceleration(0,0)
  emitter:setSpeed((2000+math.random()*5000+math.random()*math.random()*10000) * math.sqrt(force) * 2 + 300 * math.sqrt(force), 0,0,0,0)
  emitter:setLinearDamping(200)
  local dark = 150 + math.random() * 10
  local mid = dark + math.random() * 20
  local light = mid + math.random() * 30
  emitter:setColors( light,light*0.1,light*0.1, 240+ math.random()*10, mid,mid*0.1,mid*0.1,240+ math.random()*10, dark,dark*0.1,dark*0.1,240 + math.random()*10  )
  emitter:setSpread(PI/force + math.random() * PI/force *0.75 + PI/4)
  emitter:setSizes(.05 * cpml.utils.clamp(scale,1,10), .35 *cpml.utils.clamp(scale,1,10))
  emitter:setSizeVariation(0.5)
  emitter:setSpinVariation(1)
  emitter:setRotation(0)
  emitter:setAreaSpread('normal', self.w, self.h)
  emitter:setParticleLifetime(.5)
  self.psystem = emitter
end

return WaterParticles
