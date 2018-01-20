local ray_effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.pixelate).chain(moonshine.effects.fastgaussianblur)
function ray_effect.sizeupdate()
  ray_effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.pixelate).chain(moonshine.effects.fastgaussianblur)
end

window.addCallback(ray_effect.sizeupdate)

return ray_effect
