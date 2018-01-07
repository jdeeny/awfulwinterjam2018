local idcounter = {}

function idcounter.get_id(type)
  if not idcounter[type] then
    idcounter[type] = 1
  else
    idcounter[type] = idcounter[type] + 1
  end
  return idcounter[type]
end

return idcounter
