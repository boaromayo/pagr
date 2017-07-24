#==============================================================================
# ■ Scene_Equip
#------------------------------------------------------------------------------
# 　装備画面の処理を行うクラスです。
#==============================================================================

class Scene_Equip
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_index : アクターインデックス
  #     equip_index : 装備インデックス
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, equip_index = 0)
    @actor_index = actor_index
    @equip_index = equip_index
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    t1 = "This item provides additional Acumen Vectors.  It"
    t2 = "cannot be unequipped until the extra Vectors are freed."
    t3 = "Please unequip some auto-abilities first."
    @actor = $game_party.actors[@actor_index]
    @help_window = Window_Help.new
    @left_window = Window_EquipLeft.new(@actor)
    @right_window = Window_EquipRight.new(@actor)
    @item_window1 = Window_EquipItem.new(@actor, 0)
    @item_window2 = Window_EquipItem.new(@actor, 1)
    @item_window3 = Window_EquipItem.new(@actor, 2)
    @item_window4 = Window_EquipItem.new(@actor, 3)
    @item_window5 = Window_EquipItem.new(@actor, 4)
    @right_window.help_window = @help_window
    @item_window1.help_window = @help_window
    @item_window2.help_window = @help_window
    @item_window3.help_window = @help_window
    @item_window4.help_window = @help_window
    @item_window5.help_window = @help_window
    @right_window.index = @equip_index
    @vector_alert_window = Window_Base.new(80, 176, 480, 128)
    @vector_alert_window.z = 4000
    @vector_alert_window.visible = false
    @vector_alert_window.contents = Bitmap.new(448, 96)
    @vector_alert_window.contents.font.name = "Arial"
    @vector_alert_window.contents.font.size = 24
    @vector_alert_window.contents.draw_text(0, 0, 448, 32, t1)
    @vector_alert_window.contents.draw_text(0, 32, 448, 32, t2)
    @vector_alert_window.contents.draw_text(0, 64, 448, 32, t3)
    @vector_alert_count = -1
    refresh
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
    @help_window.dispose
    @left_window.dispose
    @right_window.dispose
    @item_window1.dispose
    @item_window2.dispose
    @item_window3.dispose
    @item_window4.dispose
    @item_window5.dispose
    @vector_alert_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_window1.visible = (@right_window.index == 0)
    @item_window2.visible = (@right_window.index == 1)
    @item_window3.visible = (@right_window.index == 2)
    @item_window4.visible = (@right_window.index == 3)
    @item_window5.visible = (@right_window.index == 4)
    item1 = @right_window.item
    case @right_window.index
    when 0
      @item_window = @item_window1
      newmode = 0
    when 1
      @item_window = @item_window2
      newmode = 1
    when 2
      @item_window = @item_window3
      newmode = 1
    when 3
      @item_window = @item_window4
      newmode = 1
    when 4
      @item_window = @item_window5
      newmode = 1
    end
    if newmode != @left_window.mode
      @left_window.mode = newmode
      @left_window.refresh
    end
    if @right_window.active
      @left_window.set_new_parameters(nil, nil, nil, nil, nil, nil, nil, nil,
      "", "")
    end
    if @item_window.active
      item2 = @item_window.item
      last_hp = @actor.hp
      old_atk = @actor.atk
      old_pdef = @actor.pdef
      old_mdef = @actor.mdef
      old_str = @actor.str
      old_dex = @actor.dex
      old_agi = @actor.agi
      old_int = @actor.int
      old_eva = @actor.eva
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      new_atk = @actor.atk
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      new_str = @actor.str
      new_dex = @actor.dex
      new_agi = @actor.agi
      new_int = @actor.int
      new_eva = @actor.eva
      @left_window.changes = [0, 0, 0, 0, 0, 0, 0, 0]
      if new_atk > old_atk
        @left_window.changes[0] = 1
      end
      if new_atk < old_atk
        @left_window.changes[0] = -1
      end
      if new_pdef > old_pdef
        @left_window.changes[1] = 1
      end
      if new_pdef < old_pdef
        @left_window.changes[1] = -1
      end
      if new_mdef > old_mdef
        @left_window.changes[2] = 1
      end
      if new_mdef < old_mdef
        @left_window.changes[2] = -1
      end
       if new_str > old_str
        @left_window.changes[3] = 1
      end
      if new_str < old_str
        @left_window.changes[3] = -1
      end
        if new_dex > old_dex
        @left_window.changes[4] = 1
      end
      if new_dex < old_dex
        @left_window.changes[4] = -1
      end
      if new_agi > old_agi
        @left_window.changes[5] = 1
      end
      if new_agi < old_agi
        @left_window.changes[5] = -1
      end
      if new_int > old_int
        @left_window.changes[6] = 1
      end
      if new_int < old_int
        @left_window.changes[6] = -1
      end
      if new_eva > old_eva
        @left_window.changes[7] = 1
      end
      if new_eva < old_eva
        @left_window.changes[7] = -1
      end
      elem_text = ""
      stat_text = ""
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      @actor.hp = last_hp
      @left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_str,
      new_dex, new_agi, new_int, new_eva, elem_text, stat_text)
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    $game_system.menu_encounters
    @left_window.update
    @right_window.update
    @item_window.update
    refresh
    if @vector_alert_count > 0
      @vector_alert_count -= 1
      if @vector_alert_count == 0
        @vector_alert_count = -1
        @vector_alert_window.visible = false
      end
    end
    if @right_window.active
      update_right
      return
    end
    if @item_window.active
      update_item
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ライトウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_right
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new(2)
      return
    end
    if Input.trigger?(Input::C)
      if @actor.equip_fix?(@right_window.index)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      case @right_window.index
      when 1
        if unequip_vector_check(@actor.armor1_id)
          $game_system.se_play($data_system.buzzer_se)
          @vector_alert_count = 80
          @vector_alert_window.visible = true
          return
        end
      when 2
        if unequip_vector_check(@actor.armor2_id)
          $game_system.se_play($data_system.buzzer_se)
          @vector_alert_count = 80
          @vector_alert_window.visible = true
          return
        end
      when 3
        if unequip_vector_check(@actor.armor3_id)
          $game_system.se_play($data_system.buzzer_se)
          @vector_alert_count = 80
          @vector_alert_window.visible = true
          return
        end
      when 4
        if unequip_vector_check(@actor.armor4_id)
          $game_system.se_play($data_system.buzzer_se)
          @vector_alert_count = 80
          @vector_alert_window.visible = true
          return
        end
      end
      $game_system.se_play($data_system.decision_se)
      @right_window.active = false
      @item_window.active = true
      @item_window.index = 0
      return
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アイテムウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_item
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.equip_se)
      item = @item_window.item
      @actor.equip(@right_window.index, item == nil ? 0 : item.id)
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      @right_window.refresh
      @item_window.refresh
      return
    end
  end
  # --------------------------------
  def make_elem_text(item)
    text = ""
    flag = false
    if item.is_a?(RPG::Weapon)
      for i in item.element_set
        if flag
          text += ", "
        end
        text += $data_system.elements[i]
        flag = true
      end
    end
    if item.is_a?(RPG::Armor)
      for i in item.guard_element_set
        if flag
          text += ", "
        end
        text += $data_system.elements[i]
        flag = true
      end
    end
    return text
  end
# --------------------------------
def make_stat_text(item)
    text = ""
    flag = false
    if item.is_a?(RPG::Weapon)
      for i in item.plus_state_set
        if flag
          text += ", "
        end
        text += $data_states[i].name
        flag = true
      end
    end
    if item.is_a?(RPG::Armor)
      for i in item.guard_state_set
        if flag
          text += ", "
        end
        text += $data_states[i].name
        flag = true
      end
    end
    return text
  end
# --------------------------------
def unequip_vector_check(equipment)
  result = false
  if equipment == 0
    return false
  end
  if $data_armors[equipment].vector_plus > @actor.current_acumen
    result = true
  end
  return result
end
# --------------------------------
end