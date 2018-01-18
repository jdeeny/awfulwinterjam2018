local ray_effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.pixelate).chain(moonshine.effects.fastgaussianblur)
--.chain(moonshine.effects.gaussianblur)
--ray_effect.glow.strength = 5
--shadow_effect.gaussianblur.sigma = 1.0

return ray_effect
