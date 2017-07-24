#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    s1 = $data_system.words.item
    s2 = $data_system.words.skill
    s3 = $data_system.words.equip
    s4 = "Ability"
    s5 = "Status"
    s6 = "Tutorials"
    s7 = "Config"
    s8 = "Save"
    s9 = "Quit Game"
    cmd = [s1, s2, s3, s4, s5, s6, s7, s8, s9]
    @ability_alert_window = Window_Base.new(120, 208, 400, 64)
    @ability_alert_window.z = 1100
    @ability_alert_window.contents = Bitmap.new(368, 32)
    @ability_alert_window.contents.font.name = "Arial"
    @ability_alert_window.contents.font.size = 24
    @ability_alert_window.visible = false
    @ability_alert_count = 0
    @command_window = Window_Command.new(192, cmd)
    @command_window.index = @menu_index
    @command_window.x = 448
    @command_window.y = 0
    @battle_on_menu = -1
    if $game_party.actors.size == 0
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
      @command_window.disable_item(4)
    end
    if not menu_item_can_access?(1)
      @command_window.disable_item(0)
    end
    if not menu_item_can_access?(2)
      @command_window.disable_item(1)
    end
    if not menu_item_can_access?(3)
      @command_window.disable_item(3)
    end
    if $game_system.tutorials.size == 0
      @command_window.disable_item(5)
    end
    if $game_system.save_disabled
      @command_window.disable_item(7)
    end
    @info_window = Window_MenuInfo.new
    @info_window.x = 448
    @info_window.y = 320
    @status_window = Window_MenuStatus.new
    @status_window.x = 0
    @status_window.y = 0
    Graphics.transition
    enforce_interface_limit
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @command_window.dispose
    @info_window.dispose
    @status_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if @ability_alert_count > 0
      @ability_alert_count -= 1
      if @ability_alert_count == 0
        @ability_alert_window.visible = false
      end
      return
    end
    $game_system.menu_encounters
    @command_window.update
    @info_window.update
    @status_window.update
    if @command_window.active
      update_command
      return
    end
    if @status_window.active
      update_status
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (コマンドウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_command
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $game_system.cursor_memory_position = @command_window.index
      $scene = Scene_Map.new
      return
    end
    if Input.trigger?(Input::C)
      if $game_party.actors.size == 0 and @command_window.index < 4
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      case @command_window.index
      when 0
        if menu_item_can_access?(1)
          remove_key(1)
          $game_system.se_play($data_system.decision_se)
          $scene = Scene_Item.new
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      when 1
        if menu_item_can_access?(2)
          $game_system.se_play($data_system.decision_se)
          @command_window.active = false
          @status_window.active = true
          @status_window.index = 0
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      when 2
        $game_system.se_play($data_system.decision_se)
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 3
        if menu_item_can_access?(3)
          $game_system.se_play($data_system.decision_se)
          @command_window.active = false
          @status_window.active = true
          @status_window.index = 0
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      when 4
        $game_system.se_play($data_system.decision_se)
        @command_window.active = false
        @status_window.active = true
        @status_window.index = 0
      when 5
        if $game_system.tutorials.size > 0
          $game_system.se_play($data_system.decision_se)
          $scene = Scene_Tutorial.new
        else
          $game_system.se_play($data_system.buzzer_se)
        end
      when 6
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Config.new
      when 7
        if $game_system.save_disabled
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Save.new
      when 8
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_End.new
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ステータスウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_status
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @command_window.active = true
      @status_window.active = false
      @status_window.index = -1
      return
    end
    if Input.trigger?(Input::C)
      case @command_window.index
      when 1
        if $game_party.actors[@status_window.index].restriction >= 2
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        if $game_party.actors[@status_window.index].fatigue <= -100
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        remove_key(2)
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Skill.new(@status_window.index)
      when 2
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Equip.new(@status_window.index)
      when 3
        person = $game_party.actors[@status_window.index]
        if ability_can_use?(person)
          remove_key(3)
          $game_system.se_play($data_system.decision_se)
          $scene = determine_ability_scene(person)
        else
          text = get_alert_text(person)
          $game_system.se_play($data_system.buzzer_se)
          @ability_alert_window.contents.clear
          @ability_alert_window.contents.draw_text(4, 0, 368, 32, text)
          @ability_alert_window.visible = true
          @ability_alert_count = 60
        end
      when 4
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Status.new(@status_window.index)
      end
      return
    end
  end
  # ----------------------
  def menu_item_can_access?(key_type)
    if $game_system.unlimited_menu_access == 1
      return true
    end
    case key_type
    when 1
      if $game_system.item_remain > 0
        return true
      end
    when 2
      if $game_system.shaping_remain > 0
        return true
      end
    when 3
      if $game_system.ability_remain > 0
        return true
      end
    end
    if $game_system.omni_remain > 0
      return true
    end
    return false
  end
  # ----------------------
  def remove_key(type)
    if $game_system.unlimited_menu_access == 1
      return
    end
    case type
    when 1
      if $game_system.item_remain > 0
        $game_system.item_remain -= 1
      else
        $game_system.omni_remain -= 1
      end
    when 2
      if $game_system.shaping_remain > 0
        $game_system.shaping_remain -= 1
      else
        $game_system.omni_remain -= 1
      end
    when 3
      if $game_system.ability_remain > 0
        $game_system.ability_remain -= 1
      else
        $game_system.omni_remain -= 1
      end
    end
  end
  # ----------------------
  def ability_can_use?(actor)
    ability_usable_actors = [8, 9, 11]
    if actor.id == 10
      if $game_lawsystem.unlocked
        return true
      end
    end
    if ability_usable_actors.include?(actor.id)
      return true
    else
      return false
    end
  end
  # ----------------------
  def determine_ability_scene(actor)
    case actor.id
    when 8
      return Scene_Vess.new
    when 9
      return Scene_Schizo.new
    when 10
      return Scene_Law.new
    when 11
      return Scene_AI.new($game_actors[11])
    end
  end
  # ----------------------
  def get_alert_text(actor)
    name = actor.name
    case actor.id
    when 1
      gender = "her"
    when 2
      gender = "his"
    when 3
      gender = "his"
    when 10
      gender = "xxx"
    end
    text = name + " is unable to develop " + gender + " skills."
    if actor.id == 10
      text = "Rhiaz cannot yet develop his skills."
    end
    return text
  end
  # ----------------------
  def enforce_interface_limit
    if $game_system.item_remain > 99
      $game_system.item_remain = 99
    end
    if $game_system.shaping_remain > 99
      $game_system.shaping_remain = 99
    end
    if $game_system.ability_remain > 99
      $game_system.ability_remain = 99
    end
    if $game_system.omni_remain > 99
      $game_system.omni_remain = 99
    end
  end
  # ----------------------
  def battles_on_menu
    if $game_system.difficulty == 0
      return
    end
    if $game_system.difficulty == 1
      @battles_on_menu = rand(100)
      return
    end
    if $game_system.difficulty == 2
      @battles_on_menu = rand(50)
      return
    end
  end
end
