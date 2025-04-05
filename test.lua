function love.load()
  -- ...（既存のload処理はそのまま）...

  -- Playerオブジェクトにアニメーション用プロパティ追加
  for _, player in ipairs(PLAYERS) do
    local coords = convert_index_coordinate(player.coordinate)
    player.currentX = coords[1]
    player.currentY = coords[2]
    player.targetX = coords[1]
    player.targetY = coords[2]
    player.isMoving = false
    player.moveSpeed = 200 -- ピクセル/秒
  end

  -- ...（既存のload処理続き）...
end

function love.update(dt)
  -- ...（既存のupdate処理）...

  for _, player in ipairs(PLAYERS) do
    if player.isMoving then
      local dx = player.targetX - player.currentX
      local dy = player.targetY - player.currentY

      if dx ~= 0 or dy ~= 0 then
        local distance = math.sqrt(dx^2 + dy^2)
        local moveAmount = player.moveSpeed * dt
        
        if distance <= moveAmount then
          -- Move to exact position if close enough
          player.currentX = player.targetX 
          player.currentY = player.targetY 
          player.isMoving = false

          -- Update coordinate after movement completes (optional)
          for i=1,#map do 
            local coords = convert_index_coordinate(i)
            if math.floor(coords[1]) == math.floor(player.targetX) and 
               math.floor(coords[2]) == math.floor(player.targetY) then 
              print("Updated coordinate to", i)
              break 
            end 
          end 
        else 
          -- Normal movement calculation 
          local ratio = moveAmount / distance 
          player.currentX = player.currentX + dx * ratio 
          player.currentY = player.currentY + dy * ratio 
        end 
      else 
        player.isMoving = false 
      end 
    end 
  end 

end 

function love.keypressed(key)
  local current_player_idx = FLAGS.currentP 
  
  if FLAGS.move_on and not PLAYERS[current_player_idx].isMoving then 
    
    local new_coord
    
     if key == "up" and PLAYERS[current_player_idx].coordinate >40 then  
       new_coord=PLAYERS[current_player_idx].coordinate -40  
     elseif key == "down" and PLAYERS[current_player_idx].coordinate <=560 then  
       new_coord=PLAYERS[current_player_idx].coordinate +40  
     elseif key == "left" and PLAYERS[current_player_idx].coordinate%20 ~=1 then  
       new_coord=PLAYERS[current_player_idx].coordinate -2  
     elseif key == "right" and PLAYERS[current_player_idx].coordinate%20 ~=0 then  
       new_coord=PLAYERS[current_player_idx].coordinate +2  
     else return  
     end  

     if map[new_coord] ~=0 then  
       PLAYERS[current_player_idx].isMoving=true  
       PLAYERS[current_player_idx].targetX, PLAYERS[current_player_idx].targetY =
         convert_index_coordinate(new_coord)  
       PLAYERS[current_player_idx].coordinate=new_coord  
     end  

   elseif FLAGS.menuM then  
     keyPressed[key]=true  
   end  
end 

function love.draw()
   love.graphics.translate(transx, transy)  
   love.graphics.scale(scale, scale)  

   -- ...（既存の描画処理）...

   for _, p in ipairs(PLAYERS) do  
     love.graphics.draw(
       p.image,
       p.currentX,
       p.currentY,
       0,
       1,
       1,
       0,
       p.image:getHeight()/2 -- Adjust pivot point to center bottom  
     )
   end  

   love.graphics.origin()  

   -- ...（既存のUI描画処理）...  
end 

-- ...（他の既存関数）...
