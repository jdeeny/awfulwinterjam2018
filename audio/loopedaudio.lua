local LoopedEffect = class("LoopedEffect")

function LoopedEffect:initialize(id, name, volume, prelude, epilogue)
  local play = {}
  play.id = id
  play.name = name
  play.volume = volume
  play.prelude = prelude
  play.epilogue = epilogue
  return play
end

return LoopedEffect
