local Timer = require 'hump.timer'



function set_screen_size()
  width = 1000                         -- ゲーム画面の横幅
  height = 600                        -- ゲーム画面の高さ
  love.window.setMode(width, height)  -- これが効くなら問題なし
  transx, transy = 0, 0
  scale = 1
  love.graphics.setBackgroundColor(0.82, 0.82, 0.82) -- ゲーム画面の外は灰色の枠
end

function draw_map ()
  for i = 1, 20 do
    for j = 1, 15 do
      local x, y = (i - 1) * 40, (j - 1) * 40
      local map_index = (j - 1) * 20 + i
      batch:add(quad_tables[map[map_index] + 1], x, y)      
    end
  end
end


function love.load()
  set_screen_size()

 -- フォントサイズを32に設定
  font = love.graphics.newFont("ume-tgo4.ttf", 26)
  love.graphics.setFont(font)

  map = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,6,6,0,0,0,0,0,0,0,0,0,0,7,6,7,0,0,0,0,
    0,6,2,8,5,8,4,8,3,8,4,8,5,8,2,6,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,6,0,0,0,0,
    0,0,5,0,0,0,0,0,4,0,0,0,0,0,3,0,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,3,0,0,0,0,0,3,0,0,0,0,0,4,0,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,4,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0,
    0,7,1,7,0,0,0,7,1,7,0,0,0,0,1,0,0,0,0,0,
    0,7,2,8,3,8,5,8,2,8,4,8,3,8,2,6,0,0,0,0,
    0,7,7,7,0,0,0,6,7,6,0,0,0,0,6,6,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  }
 

  atlas = love.graphics.newImage("img/atlas.png") -- テクスチャアトラス
  Pred_image = love.graphics.newImage("img/Pred.png")
  Pblue_image = love.graphics.newImage("img/Pblue.png")
  Pyellow_image = love.graphics.newImage("img/Pyellow.png")
  Pgreen_image = love.graphics.newImage("img/Pgreen.png")
  dice1 = love.graphics.newImage("img/1.png")
  dice2 = love.graphics.newImage("img/2.png")
  dice3 = love.graphics.newImage("img/3.png")
  dice4 = love.graphics.newImage("img/4.png")
  dice5 = love.graphics.newImage("img/5.png")
  dice6 = love.graphics.newImage("img/6.png")

  dice_table = {dice1, dice2, dice3, dice4, dice5, dice6}

  dice = {
  isRolling = false,
  count = 1,
  final_numbers = {1},
  numbers = {1}
}

  --write = love.graphics.newImage("img/write.png")
  batch = love.graphics.newSpriteBatch(atlas)        -- スプライトバッチ
  wid0, high0 = atlas:getDimensions()
  quad0 = love.graphics.newQuad(0, 0, 40, 40, wid0, high0) -- sougen
  quad1 = love.graphics.newQuad(40, 0, 40, 40, wid0, high0) -- railY 
  quad2 = love.graphics.newQuad(80, 0, 40, 40, wid0, high0) -- -- station
  quad3 = love.graphics.newQuad(120, 0, 40, 40, wid0, high0) -- blue
  quad4 = love.graphics.newQuad(160, 0, 40, 40, wid0, high0) -- yellow
  quad5 = love.graphics.newQuad(200, 0, 40, 40, wid0, high0) -- red
  quad6 = love.graphics.newQuad(240, 0, 40, 40, wid0, high0) -- wood
  quad7 = love.graphics.newQuad(280, 0, 40, 40, wid0, high0) -- building
  quad8 = love.graphics.newQuad(320, 0, 40, 40, wid0, high0) --railX

  quad_tables = {quad0, quad1, quad2, quad3, quad4, quad5, quad6, quad7, quad8}


--card data
C_kyukou = {name = "急行カード", attribute = "交通系", price = 1000, power = 2}
C_tokkyu = {name = "特急カード", attribute = "交通系", price = 3000, power = 3}
C_marusa = {name = "マルサカード", attribute = "マルサ", price = 5000, power = nil}

  player1 = {name = "player1", money = 0, coordinate = 43, cards = {C_kyukou, C_tokkyu, C_marusa}, image = Pred_image, funds = 10000, id = 1}
  player2 = {name = "player2", money = 0, coordinate = 43, cards = {}, image = Pblue_image, funds = 200000, id = 2}
  PLAYERS = {player1, player2}
  

  MESSAGE = {} --画面にメッセージを表示する内容 {object, "kind", 秒数}
  TOTAL_TIME = 0 --カウント用累積カウンタ
  CURRENT_TIME_MESSAGE = nil --メッセージ用カウンタ


  FLAGS = {
    totalP = 2, currentP = 1, 
    menuM = true, --移動前メニュー表示フラグ 
    menuT = false, --移動後メニュー表示フラグ
    menuC = false, --カード表示フラグ
    dice_go = false, dice_num = 1, move_on = false, month = 4,
    move_num = 0, walk_table = {}, 
    at_destination = false, --目的地到達フラグ
    destination_index = nil, --目的地インデックス
    message_disp_flag = false, --画面にメッセージを表示するフラグ
    arrival_flag = false,
    pending_dice_roll = nil

  }
--totalP = player numbers, currentP = current player's numeber, menuM = main menu, menuC = card manu,

 draw_map()

--menu repeat issue resolve no change?
 love.keyboard.setKeyRepeat(false)


--station data


P_hoshida_shrine = {name = "星田神社　　　　　　", attribute ="宗教法人　", price = 10000, yield = 1, owner = nil}
P_seven_eleven_hosida = {name = "７ー１１星田店　　　", attribute = "小売　　　", price = 3000, yield = 15, owner = nil}
P_top_center = {name = "トップセンター　　　", attribute = "小売　　　", price = 6000, yield = 10, owner = nil}
P_sensyu_bank = {name = "泉州銀行　　　　　　", attribute = "銀行　　　", price = 20000, yield = 3, owner = nil}

St_Hoshida = {name = "星田駅", 
    properties = {P_hoshida_shrine, P_seven_eleven_hosida, P_top_center, P_sensyu_bank},
    index = 43
    }


P_yumebanchi = {name = "カラオケ喫茶夢番地　", attribute = "サービス　", price = 5000, yield = 10, owner = nil}
P_morineki = {name = "もりねき食堂　　　　", attribute = "外食　　　", price = 3000, yield = 8, owner = nil}
P_nisikimati_c_park = {name = "錦町コインパーキング", attribute = "不動産賃貸", price = 8000, yield = 3, owner = nil}
P_sizyounawate_shrine = {name = "四條畷神社　　　　　", attribute = "宗教法人　", price = 1008000, yield = 1, owner = nil}

St_Sizyounawate = {name = "四条畷駅",
    properties = {P_yumebanchi, P_morineki, P_nisikimati_c_park, P_sizyounawate_shrine},
    index = 51
    }

STATIONS_TABLE = {[43] = St_Hoshida, [51] = St_Sizyounawate}

--property





--CURRENT_PROPERTY = {}
CURRENT_PROPERTY = {}
CURRENT_PROPERTY_NAMES = {}






--card data for menu test
--test_cards = {C_kyukou, C_tokkyu, C_marusa, C_marusa}

-- menu display 
current_card_before_names = {} 
CURRENT_CARD_BEFORE = {} --移動前カードテーブル
current_card_after_names = {} 
CURRENT_CARD_AFTER = {} --移動後カードテーブル




menuState = { --menuState構造体 到着前メニュー
  currentMenu = "mainmenu", --現在のメニュー判別用キー
  mainMenu = { --"mainmenu"
    items = {"サイコロ", "カード", "その他"},
    selected = 1
  },

  cardMenu = { --カード使用時のメニュー "cardmenu"
    items = current_card_before_names,
    selected = 1
  },

  cardDropMenu = { --カードを捨てる用メニュー "carddropmenu"
    items = current_card_before_names,
    selected = 1
  },

  cardMainMenu = { --"cardmainmenu"
    items = {"つかう", "すてる", "もどる"},
    selected = 1
  }
  }

menuStateAfter = { --到着後メインメニュー
  currentMenu = "mainmenuafter",
  mainMenuAfter = { --目的地でのメニュー "mainmenuafter"
    items = {"物件を買う", "カード", "終わる"},
    selected = 1
  },

  propertyMenuAfter = { --物件選択メニュー "propertymenuafter"
    items = CURRENT_PROPERTY, --CURRENT_PROPERTY_NAMES,
    selected = 1
  },

  cardMenuAfter = { --目的地で使えるカードメニュー "cardmenuafter"
    items = current_card_after_names,
    selected = 1
  },

  cardMainMenuAfter = { --"cardmainmenuafter"
    items = {"つかう", "すてる", "もどる"},
    selected = 1
  }
  }

keyPressed = {}

end

function love.draw()
  love.graphics.translate(transx, transy) -- 原点移動
  love.graphics.scale(scale, scale) -- 拡大率を設定
  -- 画面サイズを (width,height) と思って描画する
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, 1, width, height, 10)  -- ゲーム画面を白く塗る
  love.graphics.draw(batch)  -- 一気に描画


    -- 元の変換をリセット（重要！）
    love.graphics.origin()
    
    -- 右側のUIメニューを描画
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 800, 0, 200, height, 10) -- メニュー背景

    --local coordinates = convert_index_coordinate(player1.coordinate)
    --love.graphics.draw(player1.image, coordinates[1], coordinates[2])


  for i, currentP in pairs(PLAYERS) do
   love.graphics.setColor(1, 1, 1, 1)
   if i ~= FLAGS.currentP then
   love.graphics.draw(
    currentP.image, 
    convert_index_coordinate(currentP.coordinate)[1] + (i - 1) * 10, 
    convert_index_coordinate(currentP.coordinate)[2], 0, 1, 1, 0, 40
    )--キャラは中心を半分の高さの部分にする
    end
  end

   currentP = PLAYERS[FLAGS.currentP]
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.draw(
    currentP.image, 
    convert_index_coordinate(currentP.coordinate)[1] + (currentP.id - 1) * 10, 
    convert_index_coordinate(currentP.coordinate)[2], 0, 1, 1, 0, 40
    )--キャラは中心を半分の高さの部分にする

   love.graphics.origin()

   --for menu

  
  --メニュー呼び出し用フラグを破壊的変更
   if FLAGS.menuM then --FLAGS.menuM acticve

    if menuState.currentMenu == "mainmenu" then
    local v_height = #menuState.mainMenu.items * 30 + 20
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 800, 320, 200, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 802, 320, 194, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuState.mainMenu)

   elseif menuState.currentMenu == "cardmainmenu" then --card用のメニュー
    local v_height = #menuState.mainMenu.items * 30 + 20
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 800, 320, 200, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 802, 320, 194, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuState.cardMainMenu)

    elseif menuState.currentMenu == "cardmenu" or menuState.currentMenu == "carddropmenu" then --カード一覧表示
    local v_height = #menuState.cardMenu.items * 30 + 20
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 600, 320, 200, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 602, 320, 194, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuState.cardMenu)
 
    end
  end

  --到着後メニュー呼び出しフラグを破壊的変更
    if FLAGS.menuT then --到着後メニュー表示フラグON
    if menuStateAfter.currentMenu == "mainmenuafter" then --最初のメニュー
      local v_height = #menuStateAfter.mainMenuAfter.items * 30 + 20 
        love.graphics.setColor(0, 0, 0) 
        love.graphics.rectangle("fill", 800, 320, 200, v_height, 10)
        love.graphics.setLineWidth(5)--枠線の太さ
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 802, 320, 194, (v_height - 2), 10) --角を丸める
        love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuStateAfter.mainMenuAfter)

    elseif menuStateAfter.currentMenu == "propertymenuafter" then --到着後物件選択メニュー表示
      local v_height = #menuStateAfter.propertyMenuAfter.items * 40
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 100, 340, 800, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 100, 340, 800, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuStateAfter.propertyMenuAfter)

    elseif menuStateAfter.currentMenu == "cardmenuafter" then --到着後カードメニュー表示
    local v_height = #menuState.cardMenu.items * 30 + 20
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 600, 320, 200, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 602, 320, 194, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuStateAfter.cardMenuAfter)

    elseif menuStateAfter.currentMenu == "cardmainmenuafter" then
    local v_height = #menuState.cardMenu.items * 30 + 20
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 600, 320, 200, v_height, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 602, 320, 194, (v_height - 2), 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      drawMenu(menuState.cardMenuAfter)
    end
  end


     


--for walk

 if FLAGS.move_on == true then

      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 800, 120, 200, 180, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 800, 120, 196, 176, 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ

    love.graphics.print(
      string.format("残り: %02d歩", FLAGS.move_num),
      810, 130)
    --デバッグ用インデックス表示
    --love.graphics.print(FLAGS.walk_table, 810, 160)
    --if #FLAGS.walk_table > 0 then 
      --love.graphics.print(FLAGS.walk_table[#FLAGS.walk_table], 810, 190)
       --end
     end

    --for dice
    if FLAGS.dice_go then
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 800, 320, 200, 180, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 800, 320, 196, 176, 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ

      for num, dice_num in pairs(dice.numbers) do
        love.graphics.draw(dice_table[dice_num], 810, 300 + num * 50)
      end
      --love.graphics.draw(dice_table[dice.final_numbers[1]])
    end


 --for message

  if FLAGS.message_disp_flag == true then
    if CURRENT_TIME_MESSAGE == nil then
       CURRENT_TIME_MESSAGE = TOTAL_TIME
    end

    if (TOTAL_TIME - CURRENT_TIME_MESSAGE) < MESSAGE[3] then
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 200, 420, 600, 50, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 200, 420, 600, 46, 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      if MESSAGE[2] == "success_buy" then --購入成功表示
        love.graphics.print(
        string.format("%sさんは%sを購入した", PLAYERS[FLAGS.currentP].name, MESSAGE[1]:gsub("　", "")), 210, 430)
      elseif MESSAGE[2] == "lack_money" then --購入失敗
        love.graphics.print(
          string.format("%sさん、お金が足りません！", PLAYERS[FLAGS.currentP].name), 210, 430)
      elseif MESSAGE[2] == "already_else" then --他人の物件
        love.graphics.print(
          string.format("%sさん、ソレ他人の物件です！", PLAYERS[FLAGS.currentP].name), 210, 430)
        end
    else
      FLAGS.message_disp_flag = false
      CURRENT_TIME_MESSAGE = nil
      MESSAGE = {}
    end
  end


--for arrival
  if FLAGS.arrival_flag == true then
    if CURRENT_TIME_MESSAGE == nil then
      CURRENT_TIME_MESSAGE = TOTAL_TIME
    end
    if (TOTAL_TIME - CURRENT_TIME_MESSAGE) < 3 then
      love.graphics.setColor(0, 0, 0) 
      love.graphics.rectangle("fill", 400, 400, 200, 100, 10)
      love.graphics.setLineWidth(5)--枠線の太さ
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("line", 400, 400, 200, 100, 10) --角を丸める
      love.graphics.setLineWidth(1)--枠線の太さ
      love.graphics.print(
        string.format("%sが%s駅に一番乗りです！", PLAYERS[FLAGS.currentP].name, 
        STATIONS_TABLE[PLAYER[FLAGS.currentP].coordinate].name), 400, 400)
    end
  end
  --display FLAGS for DEBUG
  --draw_debug_info()
  if FLAGS.menuM and current_card_before_names ~= {} then
    love.graphics.setColor(0,0,0)
    for i, card in pairs(current_card_before_names) do
     love.graphics.print(card, 200, 200 + 30 * i)
   end
 end


end




function love.keypressed(key)

  -- マップ移動キー入力
  local current_player = PLAYERS[FLAGS.currentP]--現在のPlayerを束縛
  if FLAGS.move_on then --Move状態であれば

    local new_coordinate = current_player.coordinate -- add
    if key == "up" and current_player.coordinate > 40 then
      new_coordinate = current_player.coordinate - 40
      current_player.coordinate = new_coordinate
      walk_count(new_coordinate)
    elseif key == "down" and current_player.coordinate <= 280 then
      new_coordinate = current_player.coordinate + 40
     current_player.coordinate = new_coordinate
      walk_count(new_coordinate)
    elseif key == "left" and current_player.coordinate % 20 ~= 1 then
      new_coordinate = current_player.coordinate - 2
     current_player.coordinate = new_coordinate
      walk_count(new_coordinate)
    elseif key == "right" and current_player.coordinate % 20 ~= 0 then
      new_coordinate = current_player.coordinate + 2
     current_player.coordinate = new_coordinate
      walk_count(new_coordinate)
    elseif
    map[new_coordinate] ~= 0 then
    PLAYERS[FLAGS.currentP].coordinate = new_coordinate
    end
  end


    --メニュー移動キー入力
  if FLAGS.menuM or FLAGS.menuT then --menu active
       keyPressed[key] = true
     end

    --Message表示中であれば
  if FLAGS.message_disp_flag then
        if key == "space" or key == "return" then
          FLAGS.message_disp_flag = false
          CURRENT_TIME_MESSAGE = nil
          MESSAGE = {}
        end

   end
 end




function love.update(dt)
  if menuState.currentMenu == "mainmenu" and FLAGS.menuM == true then
    updateMainMenu()
  elseif menuState.currentMenu == "cardmenu" and FLAGS.menuM == true then
    updateCardMenu()
  elseif menuState.currentMenu == "cardmainmenu" and FLAGS.menuM == true then
    updateCardMainMenu()
  elseif menuState.currentMenu == "carddropmenu" and FLAGS.menuM == true then
    updateCardDropMenu() --new
  elseif menuStateAfter.currentMenu == "mainmenuafter" and FLAGS.menuT == true then
    updateMainMenuAfter()
  elseif menuStateAfter.currentMenu == "propertymenuafter" and FLAGS.menuT == true then
    updatePropertyMenuAfter()
  elseif menuStateAfter.currentMenu == "cardmenuafter" and FLAGS.menuT == true then
    updateCardMenuAfter()
  elseif menuStateAfter.currentMenu == "cardmainmenuafter" and FLAGS.menuT == true then
    updateCardMainMenuAfter() --new
  end

--移動用キー入力
  for k in pairs(keyPressed) do
    keyPressed[k] = false
  end  

  Timer.update(dt)

  TOTAL_TIME = TOTAL_TIME + dt

  -- メッセージ表示終了後の処理
  if not FLAGS.message_disp_flag and FLAGS.pending_dice_roll then
    FLAGS.move_on = true
    roll_dice(FLAGS.pending_dice_roll.power)
    FLAGS.pending_dice_roll = nil
  end

  --update_current_cards()

end






-- created original functions --



--目的地到着処理
function arrival_destination(player) --引数はPlayer構造体

  --playerに賞金
  local prize = ((math.floor(FLAGS.month / 12) * 0.1) + 1) * 100000
  player.funds = player.funds + prize

 --次の目的地を決める
  local removed_stations_table = {} --現在地以外の駅
  for i, station in pairs(STATIONS_TABLE) do
    if station.index ~= player.coordinate then
      table.insert(removed_stations_table, station)
    end
  end
  local random_count = math.random(1, #removed_stations_table)
  local local_target = STATIONS_TABLE[random_count]

  --FLAGS.destination_index = local_target.index

  --到着の画面表示
  FLAGS.arrival_flag = true
  MESSAGE = {player.name, "arrival", 5, prize,
              STATIONS_TABLE[local_target.index]} --FLAGS.destination_index}
end




function buyProperty(property) --引数は物件のテーブル１つ
  update_all()
  local current_player = PLAYERS[FLAGS.currentP]

  if property.owner then --誰かの持ちものなら
    MESSAGE = {property.name, "already_else", 5}
    update_all()
    FLAGS.message_disp_flag = true
  elseif current_player.funds >= property.price then --購入成功
    MESSAGE = {property.name, "success_buy", 5} --画面に購入成功のメッセージ表示　5秒
    current_player.funds = current_player.funds - property.price --購入資金減算
    property.owner = current_player.name --物件オーナー更新
    --update_current_properties()
    update_all()
    FLAGS.message_disp_flag = true
  elseif current_player.funds < property.price then
    MESSAGE = {property.name, "lack_money", 5} --金が足りない
    update_all()
    FLAGS.message_disp_flag = true
  end
end


function convert_index_coordinate(index)
    local row = math.floor((index - 1) / 20)
    local col = (index - 1) % 20
    local x, y = col * 40, row * 40
    return {x, y}
end


--ステートマシン関数 ---------------------------------------------------------------------------------------------

function updateMainMenu()
  local menu = menuState.mainMenu
  if keyPressed["up"] then
    menu.selected = (menu.selected - 2) % #menu.items + 1
  elseif keyPressed["down"] then
    menu.selected = menu.selected % #menu.items + 1
  elseif keyPressed["return"] or keyPressed["space"] then
    if menu.selected == 1 then
      --FLAGS.menuM = false --以前はmainMenuだったのでエラーが起きるかも？
      FLAGS.dice_go = true
      roll_dice(1)
    elseif menu.selected == 2 then
      update_current_cards()
      menuState.currentMenu = "cardmenu"
    elseif menu.selected == 3 then
      print("etc")
    end
  end
end

function updateCardMenu()
    local menu = menuState.cardMenu
    if keyPressed["up"] then
      menu.selected = (menu.selected - 2) % #menu.items + 1
    elseif keyPressed["down"] then
      menu.selected = menu.selected % #menu.items + 1
    elseif keyPressed["return"] or keyPressed["space"] then
      usecard(CURRENT_CARD_BEFORE[menu.selected]) --cardテーブルを入れないと
    elseif keyPressed["escape"] then
      menuState.currentmenu = "main"
    end
  end

--function updateCardDropMenu() -- new

function updateCardMainMenu()
  local menu = menuState.cardMainMenu
  if keyPressed["up"] then
    if menu.selected == 1 then
      menu.selected = #menu.items
    else
      menu.selected = menu.selected - 1
    end
  elseif keyPressed["down"] then
    if menu.selected == #menu.items then
      menu.selected = 1
    else
      menu.selected = menu.selected + 1
    end
  elseif keyPressed["return"] or keyPressed["space"] then
    if menu.selected == 1 then
      menuState.currentmenu = "cardmenu"
    elseif menu.selected == 2 then
      menuState.currentmenu = "drop"
    end
  elseif keyPressed["escape"] or keyPressed["q"] then
    --前のメニューに戻る処理
    menuState.currentMenu = "main"
  end
end
 

--到着後のメニューステートマシン関数

function updateMainMenuAfter()
  local menu = menuStateAfter.mainMenuAfter--初期値としてmainmenuafterをセット
  if keyPressed["up"] then
    if menu.selected == 1 then
      menu.selected = #menu.items
    else
      menu.selected = menu.selected - 1
    end
  elseif keyPressed["down"] then
    if menu.selected == #menu.items then
      menu.selected = 1
    else
      menu.selected = menu.selected + 1
    end
  elseif keyPressed["return"] or keyPressed["space"] then
    if menu.selected == 1 then
      menuStateAfter.currentMenu = "propertymenuafter"
    elseif menu.selected == 2 then
      update_current_cards()
      menuStateAfter.currentMenu = "cardmenuafter"
    elseif menu.selected == 3 then
      --ターン終了
      FLAGS.menuT = false --menu vanish
      if FLAGS.currentP == #PLAYERS then --next player
        FLAGS.currentP = FLAGS.currentP + 1
      else 
        FLAGS.currentP = FLAGS.currentP + 1
        update_all()
        FLAGS.menuT = false
        FLAGS.menuM = true
        menuState.currentMenu = "main"
      end
    end
  end
end

function updatePropertyMenuAfter()
  local menu = menuStateAfter.propertyMenuAfter
  if keyPressed["up"] then
    if menu.selected == 1 then
      menu.selected = #menu.items
    else
      menu.selected = menu.selected - 1
    end
  elseif keyPressed["down"] then
    if menu.selected == #menu.items then
      menu.selected = 1
    else
      menu.selected = menu.selected + 1
    end
  elseif keyPressed["return"] or keyPressed["space"] then
    buyProperty(CURRENT_PROPERTY[menu.selected])
    --updatePropertyAfterMenu() -- loop
  elseif keyPressed["escape"] or keyPressed["q"] then
    --前のメニューに戻る処理
    menuStateAfter.currentMenu = "mainAfter"
  end
end

--function updateCardMenuAfter() --new



--function updateCardMainMenuAfter() --new





--[[
--メニュー本文表示menuはメニュー構造体を受け取る
function drawMenu(menu)
  for i, item in ipairs(menu.items) do
    if i == menu.selected then
      love.graphics.setColor(1,1,0) --yellow
    else 
      love.graphics.setColor(1,1,1) --white
    end
    if menu == menuStateAfter.propertyMenuAfter then
      love.graphics.print(
        string.format("%s %s %d％ %d %s社長", 
          item.name, item.attribute, item.yield, item.price, item.owner),
        110, 330 + i * 30)
    else
      love.graphics.print(item, 810, 300 + i *30)
    end
  end
end
]]--

function drawMenu(menu)
    for i, item in ipairs(menu.items) do
        -- 色設定
        love.graphics.setColor(i == menu.selected and {1,1,0} or {1,1,1})

 
        
        if menu == menuStateAfter.propertyMenuAfter then
            -- UTF-8対応の文字列切り取り
        local smart_price = nil
        local string_price = tostring(item.price)
        if string.len(string_price) > 4 then --1億以上
          if getCharFromRight(string_price, 4) == "0" then --億ピッタリ
            smart_price = string.sub(string_price, 1, -5) .. "億"
          else
            smart_price = string.sub(string_price, 1, -5) .. "億" .. string.sub(string_price, -4) .. "万"
          end
        else
          smart_price = string.sub(string_price, -4) .. "万"
        end
            local function utf8sub(str, start, len)
                return str:sub(1, len*3) -- マルチバイト文字を考慮した簡易対応
            end
            
            local text = string.format(
                "%-18s %-10s %5d%% %12s円 %-8s",
                utf8sub(item.name, 1, 16), -- 最大16文字（マルチバイト考慮）
                item.attribute,
                item.yield or 0,
                smart_price,
                item.owner or "未所有"
            )
            
            love.graphics.print(text, 110, 330 + i * 30)
        elseif menu == menuState.cardMenu then
            love.graphics.print(item, 610, 300 + i *30)
          else
            love.graphics.print(item, 810, 300 + i *30)
          end
        end

end






function roll_dice(num, callback)
  dice.isRolling = true
  dice.count = 0
  --dice.final_numbers = {}
  dice.numbers = {}

  -- タイマーを保持する変数
  local timer
  
  timer = Timer.every(0.5, function()
    dice.count = dice.count + 1
    dice.numbers = {}

    -- ダイスを振る
    for i = 1, num do
      table.insert(dice.numbers, math.random(1, 6))
    end

    -- 10回目で終了
    if dice.count >= 10 then
      Timer.cancel(timer) -- タイマー停止
      dice.isRolling = false
      dice.final_numbers = dice.numbers -- 最終結果を保存
      FLAGS.move_num = sum(dice.final_numbers) --移動可能歩数を決定
      FLAGS.move_on = true --移動フラグON　同時に残り歩数表示も設定
      if callback then callback(dice.final_numbers) end
    end
  end)
end


function sum(lst)
  local acc = 0
  for _, num in pairs(lst) do
    acc = acc + num
  end
  return acc
end



function walk_count(t_coordinate)
    -- 経路が存在し、現在座標が直近の経路と一致（後戻り）
    if #FLAGS.walk_table > 0 and 
      t_coordinate == FLAGS.walk_table[(#FLAGS.walk_table - 1)] then
        FLAGS.move_num = FLAGS.move_num + 1
        table.remove(FLAGS.walk_table) -- 最新の経路を削除
    else -- 新しい移動（前進）
        FLAGS.move_num = FLAGS.move_num - 1
        table.insert(FLAGS.walk_table, t_coordinate) -- 経路追加
    end
    
    -- 歩数が0になったら移動終了
    if FLAGS.move_num <= 0 then
        end_movement()
    end
end

--駅以外の場所に止まった場合の処理を追加する
function end_movement()
    FLAGS.dice_go = false
    FLAGS.menuM = false
    FLAGS.move_on = false
    --FLAGS.menuT = true
    FLAGS.walk_table = {}
    --目的地到着
    if PLAYERS[FLAGS.currentP].coordinate == FLAGS.destination_index then
      arrival_destination(PLAYERS[FLAGS.currentP]) --Playerの参照を渡す
    end
    --駅到着
    if isStation() then
      --update_all()
      update_current_properties()
      update_current_properties_name()
      update_menu_state()
      FLAGS.menuT = true
    else 
      FLAGS.menuT = false
    end

    --print("移動終了")
end


function isStation()
  for _, station in pairs(STATIONS_TABLE) do
    if station.index == PLAYERS[FLAGS.currentP].coordinate then
      return true
    end
  end
  return false
end


function tableToString(tbl, indent)
    indent = indent or 0
    local str = ""
    local spaces = string.rep("  ", indent)
    
    for k, v in pairs(tbl) do
        local key = tostring(k)
        if type(v) == "table" then
            str = str .. string.format("%s%s:\n%s\n", spaces, key, tableToString(v, indent + 1))
        else
            str = str .. string.format("%s%s: %s\n", spaces, key, tostring(v))
        end
    end
    return str
end



function draw_debug_info()
    -- デバッグ情報表示位置
    local x = 700
    local y = 10
    
    -- デバッグ情報の文字列生成
    local debug_text = "FLAGS:\n" .. tableToString(FLAGS, 1)
    
    -- 表示設定
    love.graphics.setColor(0, 0, 0)  -- 白色
    love.graphics.setFont(love.graphics.newFont(12))
    
    -- 複数行表示対応
    local line_height = 15
    for line in debug_text:gmatch("[^\n]+") do
        love.graphics.print(line, x, y)
        y = y + line_height
    end
end


function update_current_cards() --各カード選択時に手動実行する
  --current_card_before_names = {} --カード名だけ入る
--[[
  CURRENT_CARD_BEFORE = {}
  current_card_before_names = {}
  CURRENT_CARD_AFTER = {}
  current_card_after_names = {}
  current_card_after_names = {}
  ]]--

  for _, card in pairs(PLAYERS[FLAGS.currentP].cards) do
    if card.attribute == "交通系" then
      table.insert(CURRENT_CARD_BEFORE, card)
      table.insert(current_card_before_names, card.name)
    else 
      table.insert(CURRENT_CARD_AFTER, card)
      table.insert(current_card_after_names, card.name)

    end
  end
end

function update_current_properties() --プロパティをいじるときには呼び出す
  CURRENT_PROPERTY =  STATIONS_TABLE[PLAYERS[FLAGS.currentP].coordinate].properties
end

function update_current_properties_name()--プロパティの名前を破壊的生成
  local new_proparties_name = {}
  for _, property in pairs(CURRENT_PROPERTY) do
    table.insert(new_proparties_name, property.name)
  end
  CURRENT_PROPERTY_NAMES = new_proparties_name
end


function update_menu_state()

menuState.cardMenu.items = current_card_before_names

menuStateAfter.propertyMenuAfter.items = CURRENT_PROPERTY
menuStateAfter.cardMenuAfter.items = current_card_after_names

end

function update_all()
  update_current_properties()--グローバルを破壊的変更
  update_current_properties_name()--グローバルを破壊的変更
  update_current_cards()
  update_menu_state()
end

function getDigitCount(num)
    if num == 0 then return 1 end
    return math.floor(math.log10(math.abs(num))) + 1
end

function getCharFromRight(str, n)
    return string.sub(str, -n, -n)
end


function usecard(card)

  if card.attribute == "交通系" then
    FLAGS.message_disp_flag = true
    MESSAGE = {card.name, card.attribute, card.power, 5}
    FLAGS.pending_dice_roll = {power = card.power} -- 保留中のサイコロ情報
  end
end





--function arrival(player) --引数プレイヤーテーブル

--function count_distance(player) --引数プレイヤーテーブル

