local collision = {}

local ax, bx, pad_x, sign_x, ay, by, pad_y, sign_y
local near_time_x, far_time_x, near_time_y, far_time_y, far_time
local hit_time, hit_x, hit_y, nx, ny

--- test if moving a by (vx,vy) will cause it to hit b
-- if so, return x,y (point of impact), 0 <= t <= 1 ("time" of impact), nx,ny (normal of the surface we ran into)
function collision.aabb_sweep(a, b, vx, vy)
  ax, bx = a.x, b.x
  pad_x = b.radius + a.radius
  sign_x = vx>0 and 1 or vx<0 and -1 or 0

  ay, by = a.y, b.y
  pad_y = b.radius + a.radius
  sign_y = vy>0 and 1 or vy<0 and -1 or 0

  if vx ~= 0 then
    scale_x = 1 / vx
    near_time_x = (bx - sign_x * (pad_x) - ax) * scale_x
    far_time_x = (bx + sign_x * (pad_x) - ax) * scale_x
  else
    if ax > bx - pad_x and ax < bx + pad_x then
      near_time_x, far_time_x = -9999, 9999
    else
      return
    end
  end

  if vy ~= 0 then
    scale_y = 1 / vy
    near_time_y = (by - sign_y * (pad_y) - ay) * scale_y
    far_time_y = (by + sign_y * (pad_y) - ay) * scale_y
  else
    if ay > by - pad_y and ay < by + pad_y then
      near_time_y, far_time_y = -9999, 9999
    else
      return
    end
  end

  if near_time_x > far_time_y or near_time_y > far_time_x then
    -- missed
    return
  end

  -- pick the times we were closest
  near_time = math.max(near_time_x, near_time_y)
  far_time = math.min(far_time_x, far_time_y)

  if near_time > 1 or far_time < 0 then
    -- didn't reach b, or already past and moving away
    return
  end

  -- okay, we hit the aabb
  hit_time = cpml.utils.clamp(near_time, 0, 1)
  if near_time_x > near_time_y then
    nx = -sign_x
    ny = 0
  else
    nx = 0
    ny = -sign_y
  end

  hit_x = a.x + hit_time * vx - 0.001 * sign_x
  hit_y = a.y + hit_time * vy - 0.001 * sign_y

  return hit_x, hit_y, hit_time, nx, ny
end

local grid_x1, grid_x2, grid_y1, grid_y2
local block_type
local box
local hit
local mx, my, mt, mnx, mny

function collision.aabb_map_sweep(a, vx, vy)
  grid_x1 = map.pos_to_grid(math.min(a.x - a.radius, a.x - a.radius + vx))
  grid_x2 = map.pos_to_grid(math.max(a.x + a.radius, a.x + a.radius + vx))
  grid_y1 = map.pos_to_grid(math.min(a.y - a.radius, a.y - a.radius + vy))
  grid_y2 = map.pos_to_grid(math.max(a.y + a.radius, a.y + a.radius + vy))

  mt = 1
  hit = nil
  for i = grid_x1, grid_x2 do
    for j = grid_y1, grid_y2 do
      if mainmap:is_solid(i, j) then
        block_type = mainmap:block_at(i, j)
        box = map.bounding_box(i, j)

        hx, hy, ht, nx, ny = collision.aabb_sweep(a, box, vx, vy)

        if ht and ht < mt then
          if (nx ~= 0 and ny ~= 0) or not mainmap:is_solid(i + nx, j + ny) then
            hit = {"block", i, j}
            mt = ht
            mx = hit_x
            my = hit_y
            mnx = nx
            mny = ny
            if nx > 0 then
              mx = math.ceil(mx)
            elseif nx < 0 then
              mx = math.floor(mx)
            end
            if ny > 0 then
              my = math.ceil(my)
            elseif ny < 0 then
              my = math.floor(my)
            end
          end
        end
      end
    end
  end

  if not hit then
    mx, my = a.x + vx, a.y + vy
    mnx, mny = 0, 0
  end

  return hit, mx, my, mt, mnx, mny
end

return collision
