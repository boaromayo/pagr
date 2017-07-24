#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　マップ画面の処理を行うクラスです。
#==============================================================================

class Scene_Map
  attr_accessor :transition_time
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    @spriteset = Spriteset_Map.new
    @message_window = Window_Message.new
    @location_window = Window_Location.new
    @mapeffect_window = Window_MapEffects.new
    @localmap_window = Window_NewLocalMap.new
    @warn = false
    @transition_time = 40
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @spriteset.dispose
    @message_window.dispose
    @location_window.dispose
    @mapeffect_window.dispose
    @localmap_window.dispose
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    loop do
      $game_map.update
      $game_system.map_interpreter.update
      $game_player.update
      $game_system.update
      $game_screen.update
      unless $game_temp.player_transferring
        break
      end
      transfer_player
      if $game_temp.transition_processing
        break
      end
    end
    @spriteset.update
    @message_window.update
    @location_window.update
    @localmap_window.update
    update_map_effects
    update_local_map
    if $game_temp.gameover
      $scene = Scene_Gameover.new
      return
    end
    if $game_temp.to_title
      $scene = Scene_Title.new
      return
    end
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      if $game_temp.transition_name == ""
        Graphics.transition(@transition_time / 2)
      else
        Graphics.transition(@transition_time, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    if $game_temp.message_window_showing
      return
    end
    if $game_player.encounter_count == 0
      if $game_map.encounter_list != [] || $game_map.enum_encounter_list != []
        unless $game_system.map_interpreter.running? or
             $game_system.encounter_disabled
            if $game_map.enum_encounter_list != []
              n = rand($game_map.enum_encounter_list.size)
              troop_id = $game_map.enum_encounter_list[n]
            else
              n = rand($game_map.encounter_list.size)
              troop_id = $game_map.encounter_list[n]
            end
          if $data_troops[troop_id] != nil
            $game_temp.battle_calling = true
            $game_temp.battle_troop_id = troop_id
            $game_temp.battle_can_escape = true
            $game_temp.battle_can_lose = false
            $game_temp.battle_proc = nil
          end
        end
      end
    end
    if Input.trigger?(Input::B)
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
      end
    end
    unless $game_player.moving?
      if $game_temp.battle_calling
        call_battle
      elsif $game_temp.shop_calling
        call_shop
      elsif $game_temp.password_calling
        call_password
      elsif $game_temp.menu_calling
        call_menu
      elsif $game_temp.save_calling
        call_save
      elsif $game_temp.debug_calling
        call_debug
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルの呼び出し
  #--------------------------------------------------------------------------
  def call_battle
    $scene.transition_time = 40
    $game_temp.battle_calling = false
    $game_temp.menu_calling = false
    $game_temp.menu_beep = false
    $game_player.make_encounter_count
    if $game_system.map_bgm_in_battle == false
      $game_temp.map_bgm = $game_system.playing_bgm
      $game_system.bgm_stop
    end
    unless $game_system.suppress_battle_start_se
      $game_system.se_play($data_system.battle_start_se)
    end
    if $game_system.map_bgm_in_battle == false
      $game_system.bgm_play($game_system.battle_bgm)
    end
    $game_player.straighten
    $scene = Scene_Battle.new
  end
  #--------------------------------------------------------------------------
  # ● ショップの呼び出し
  #--------------------------------------------------------------------------
  def call_shop
    $game_temp.shop_calling = false
    $game_player.straighten
    $scene = Scene_Shop.new
  end
  #--------------------------------------------------------------------------
  # ● 名前入力の呼び出し
  #--------------------------------------------------------------------------
  def call_password
    $game_temp.password_calling = false
    $game_player.straighten
    $scene = Scene_Password.new
  end
  #--------------------------------------------------------------------------
  # ● メニューの呼び出し
  #--------------------------------------------------------------------------
  def call_menu
    $game_temp.menu_calling = false
    if $game_temp.menu_beep
      $game_system.se_play($data_system.decision_se)
      $game_temp.menu_beep = false
    end
    $game_player.straighten
    if $game_system.cursor_memory == 1
      $scene = Scene_Menu.new($game_system.cursor_memory_position)
    else
      $scene = Scene_Menu.new
    end
  end
  #--------------------------------------------------------------------------
  # ● セーブの呼び出し
  #--------------------------------------------------------------------------
  def call_save
    $game_player.straighten
    $scene = Scene_Save.new
  end
  #--------------------------------------------------------------------------
  # ● デバッグの呼び出し
  #--------------------------------------------------------------------------
  def call_debug
    $game_temp.debug_calling = false
    $game_system.se_play($data_system.decision_se)
    $game_player.straighten
    $scene = Scene_Debug.new
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの場所移動
  #--------------------------------------------------------------------------
  def transfer_player
    $game_temp.player_transferring = false
    if $game_map.map_id != $game_temp.player_new_map_id
      $game_map.setup($game_temp.player_new_map_id)
      $game_mapeffects.kill_infinite
    end
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y)
    case $game_temp.player_new_direction
    when 2
      $game_player.turn_down
    when 4
      $game_player.turn_left
    when 6
      $game_player.turn_right
    when 8
      $game_player.turn_up
    end
    $game_player.straighten
    $game_map.update
    @spriteset.dispose
    @spriteset = Spriteset_Map.new
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      Graphics.transition(20)
    end
    $game_map.autoplay
    Graphics.frame_reset
    Input.update
  end
  # ----------------------------
  def set_location(location)
    @location_window.location = location
  end
  # ----------------------------
  def author_comment?
    if $game_system.author_comments == 1
      $game_switches[5] = true
      return
    else
      $game_switches[5] = false
      return
    end
  end
  # ----------------------------
  def have_crystalline_tetrahedron?
    if $game_system.omni_remain >= 1
      $game_switches[18] = true
    else
      $game_switches[18] = false
    end
  end
  # ----------------------------
  def get_world_map_area_id
    area = 0
    flag = 0
    rect1 = [10, 7, 37, 25]
    rect2 = [19, 26, 54, 50]
    rect3 = [42, 59, 115, 96]
    rect4 = [79, 47, 114, 58]
    area_rects = [rect1, rect2, rect3, rect4]
    x = $game_player.x
    y = $game_player.y
    for i in 0..area_rects.size - 1
      if x >= area_rects[i][0]
        if y >= area_rects[i][1]
          if x <= area_rects[i][2]
            if y <= area_rects[i][3]
              area = i + 1
              flag += 1
            end
          end
        end
      end
    end
    if flag >= 2 && @warn = false
      print("Warning.  Declared areas are not mutually exclusive.")
      @warn = true
    end
    $game_variables[36] = area
  end
  # ----------------------------
  def update_map_effects
    effect_updated = false
    for effect in $game_mapeffects.effects
      if effect.running?
        effect.decrement
        effect_updated = true
      end
    end
    if effect_updated && Graphics.frame_count % 4 == 0
      @mapeffect_window.refresh
    end
    if $game_mapeffects.refresh_flag
      @mapeffect_window.refresh
      $game_mapeffects.refresh_flag = false
    end
  end
  # ----------------------------
  def update_local_map
    if Graphics.frame_count % 4 == 0
      @localmap_window.refresh
    end
  end
  # ----------------------------
end
