#==============================================================================
# ■ Scene_Battle (分割定義 3)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウのセットアップ
  #--------------------------------------------------------------------------
  def phase2_setup_command_window
    @skill = nil
    @item = nil
    disable_unusuable_commands(@selected_actor_index)
    @actor_command_windows[@selected_actor_index].active = true
    @actor_command_windows[@selected_actor_index].visible = true
    @actor_command_windows[@selected_actor_index].index = 0
    @active_battler = $game_party.actors[@selected_actor_index]
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウのセットアップ
  #--------------------------------------------------------------------------
  def phase2_end
    de_index
    @setup_commands = false
    if @skill_window != nil
      end_skill_select
    end
    if @item_window != nil
      end_item_select
    end
    if @actor_arrow != nil
      if not @actor_arrow.disposed?
        @actor_arrow.dispose
      end
      @actor_arrow = nil
    end
    if @enemy_arrow != nil
      if not @enemy_arrow.disposed?
        @enemy_arrow.dispose
      end
      @enemy_arrow = nil
    end
    for i in 0..$game_party.actors.size - 1
      @actor_command_windows[i].visible = false
    end
    @battlehelp_window.visible = false
    @itemcharge_window.visible = false
    @charging_item = false
    @no_show_command = false
    @selected_actor_index = -1
    if @phase != 3
      sleep(0.1)
      unless judge
        @actor_select_arrow = Arrow_ActorSelect.new(@spriteset.viewport2)
      end
      @phase = 1
    end
    if @active_battler != nil
      if @active_battler.current_action.setup > 0
        determine_delay_player
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ)
  #--------------------------------------------------------------------------
  def update_phase2
    if not @setup_commands
      @actor_select_arrow.dispose
      @actor_select_arrow = nil
      @setup_commands = true
      $game_system.se_play($data_system.decision_se)
      phase2_setup_command_window
      return
    end
    if @enemy_arrow != nil
      update_phase2_enemy_select
    elsif @actor_arrow != nil
      update_phase2_actor_select
    elsif @skill_window != nil
      update_phase2_skill_select
    elsif @item_window != nil
      y = @active_battler.battle_commands
      x = y[@actor_command_windows[@selected_actor_index].index]
      if x == "Item-Focus" and @active_battler.itemfocus_item > 0
        update_phase2_itemfocus_select
      else
        update_phase2_item_select
      end
    elsif @ai_window.visible
      update_phase2_ai_select
    elsif @actor_command_windows[@selected_actor_index].active
      update_phase2_basic_command
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : 基本コマンド)
  #--------------------------------------------------------------------------
  def update_phase2_basic_command
    if Graphics.frame_count % 20 == 0
      disable_unusuable_commands(@selected_actor_index)
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @active_battler.current_action.setup = 0
      phase2_end
      return
    end
    if Input.trigger?(Input::C)
      value = @actor_command_windows[@selected_actor_index].index
      if @actor_command_windows[@selected_actor_index].disabled[value]
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      @active_battler.current_action.clear
      y = @active_battler.battle_commands
      x = y[@actor_command_windows[@selected_actor_index].index]
      case x
        when "Attack"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 1
          start_enemy_select
        when "Technique"
          $game_system.se_play($data_system.decision_se)
          start_skill_select
        when "Synthesis"
          $game_system.se_play($data_system.decision_se)
          start_skill_select
        when "Psychoshape"
          $game_system.se_play($data_system.decision_se)
          start_skill_select
        when "Law"
          $game_system.se_play($data_system.decision_se)
          start_skill_select
        when "Genoshape"
          $game_system.se_play($data_system.decision_se)
          start_skill_select
        when "Item"
          $game_system.se_play($data_system.decision_se)
          start_item_select
        when "Item-Once"
          $game_system.se_play($data_system.decision_se)
          start_item_select
        when "Item-Focus"
          $game_system.se_play($data_system.decision_se)
          itm = @active_battler.itemfocus_item
          if itm == 0
            start_item_select
            @focusing = true
          else
            start_itemfocus_select
          end
        when "Item-Charge"
          $game_system.se_play($data_system.decision_se)
          $game_temp.item_charge = 50
          unless time_stopped?
            @itemcharge_window.x = 170
            @itemcharge_window.y = 340
            @itemcharge_window.visible = true
            @itemcharge_window.update
            @itemcharge_window.refresh
            @actor_command_windows[@selected_actor_index].active = false
            @charging_item = true
            @tag = true
          end
          if time_stopped?
            start_item_select
          end
        when "Steal"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 5
          start_enemy_select
        when "Filch"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 6
          start_enemy_select
        when "Larceny"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 7
          phase2_end
        when "Rob"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 8
          start_enemy_select
        when "Coordinate"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 12
          if @resolving_battler == $game_troop.enemies[0]
            $game_temp.guard_breaker = true
          end
          phase2_end
        when "Mutilate"
          $game_system.se_play($data_system.decision_se)
          @tag = true
          @c = true
          @mutilate_window.x = 170
          @mutilate_window.y = 340
          @mutilate_window.damage = 1
          @mutilate_window.status = 0
          @mutilate_window.visible = true
          @actor_command_windows[@selected_actor_index].active = false
        when "Withdraw"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 11
          phase2_end
        when "Triage"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 2
          @active_battler.current_action.skill_id = 75
          start_actor_select
        when "Ego"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 2
          @active_battler.current_action.skill_id = 17
          phase2_end
        when "Superego"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 2
          @active_battler.current_action.skill_id = 18
          phase2_end
        when "Id"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.setup = 2
          @active_battler.current_action.skill_id = 19
          phase2_end
        when "Defend"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.passive = 1
          phase2_end
        when "Assimilate"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.passive = 2
          phase2_end
        when "Respite"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.passive = 3
          phase2_end
        when "Hasty Exit"
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.passive = 4
          @escape_effects.push(1)
          phase2_end
        when "Tactics"
          $game_system.se_play($data_system.decision_se)
          start_ai_select
        when "Objection"
          $game_system.se_play($data_system.decision_se)
          @objection_pending = true
          phase2_end
        when "Intervene"
          $game_system.se_play($data_system.decision_se)
          intervene
          phase2_end
        when "Summon"
          $game_system.se_play($data_system.buzzer_se)
        end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : スキル選択)
  #--------------------------------------------------------------------------
  def update_phase2_skill_select
    @skill_window.visible = true
    @battlehelp_window.visible = true
    @supplementary_window.visible = true
    @skill_window.update
    if Graphics.frame_count % 40 == 0
      @skill_window.refresh
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @active_battler.current_action.setup = 0
      end_skill_select
      return
    end
    if Input.trigger?(Input::C)
      @active_battler.current_action.setup = 2
      @skill = @skill_window.skill
      if @skill == nil or not @active_battler.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.skill_id = @skill.id
      @skill_window.visible = false
      @battlehelp_window.visible = false
      @supplementary_window.visible = false
      if @skill.scope == 0
        phase2_end
      elsif @skill.scope == 1
        start_enemy_select
      elsif @skill.scope == 3 or @skill.scope == 5
        start_actor_select
      elsif @skill.scope == 2 or @skill.scope == 4 or @skill.scope == 6
        phase2_end
      elsif @skill.scope == 7
        phase2_end
      elsif @skill.scope >= 8
        phase2_end
      else
        end_skill_select
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : アイテム選択)
  #--------------------------------------------------------------------------
  def update_phase2_item_select
    @item_window.visible = true
    @item_window.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @active_battler.current_action.setup = 0
      end_item_select
      return
    end
    if Input.trigger?(Input::C)
      @active_battler.current_action.setup = 3
      @item = @item_window.item
      unless $game_party.item_can_use?(@item.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.item_id = @item.id
      @item_window.visible = false
      @battlehelp_window.visible = false
      if @focusing
        @active_battler.itemfocus_item = @item.id
        @focusing = false
      end
      if @item.scope == 0
        phase2_end
      elsif @item.scope == 1
        start_enemy_select
      elsif @item.scope == 3 or @item.scope == 5
        start_actor_select
      elsif @item.scope == 2 or @item.scope == 4 or @item.scope == 6
        phase2_end
      elsif @item.scope == 7
        @active_battler.current_action.target_index = @selected_actor_index
        phase2_end
      else
        end_item_select
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : エネミー選択)
  #--------------------------------------------------------------------------
  def update_phase2_enemy_select
    @enemy_arrow.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @active_battler.current_action.setup = 0
      if @skill_window != nil or @item_window != nil
        @active_battler.current_action.setup = -1
      end
      end_enemy_select
      return
    end
    if Input.trigger?(Input::C)
      i = @enemy_arrow.index
      if $game_troop.enemies[i].untargetable_frames > 0
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @enemy_arrow.index
      end_enemy_select
      if @skill_window != nil
        end_skill_select
      end
      if @item_window != nil
        end_item_select
      end
      phase2_end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : アクター選択)
  #--------------------------------------------------------------------------
  def update_phase2_actor_select
    @actor_arrow.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @active_battler.current_action.setup = 0
      if @skill_window != nil or @item_window != nil
        @active_battler.current_action.setup = -1
      end
      end_actor_select
      return
    end
    if Input.trigger?(Input::C)
      if $game_party.actors[@actor_arrow.index].isolate
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @actor_arrow.index
      end_actor_select
      if @skill_window != nil
        end_skill_select
      end
      if @item_window != nil
        end_item_select
      end
      phase2_end
    end
  end
  #--------------------------------------------------------------------------
  # ● エネミー選択開始
  #--------------------------------------------------------------------------
  def start_enemy_select
    alldead = true
    for enemy in $game_troop.enemies
      if enemy.exist?
        alldead = false
      end
    end
    if alldead
      $game_system.se_play($data_system.buzzer_se)
      @actor_command_windows[@selected_actor_index].active = true
      @actor_command_windows[@selected_actor_index].visible = true
    else
      @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport1)
      @actor_command_windows[@selected_actor_index].active = false
      @actor_command_windows[@selected_actor_index].visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● エネミー選択終了
  #--------------------------------------------------------------------------
  def end_enemy_select
    @monster_window.refresh
    @enemy_arrow.dispose
    @enemy_arrow = nil
    if $game_party.actors[@selected_actor_index].current_action.setup == 0
      @actor_command_windows[@selected_actor_index].active = true
      @actor_command_windows[@selected_actor_index].visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● アクター選択開始
  #--------------------------------------------------------------------------
  def start_actor_select
    @actor_arrow = Arrow_Actor.new(@spriteset.viewport2)
    @actor_arrow.index = @selected_actor_index
    @actor_command_windows[@selected_actor_index].active = false
    @actor_command_windows[@selected_actor_index].visible = false
  end
  #--------------------------------------------------------------------------
  # ● アクター選択終了
  #--------------------------------------------------------------------------
  def end_actor_select
    @actor_arrow.dispose
    @actor_arrow = nil
  end
  #--------------------------------------------------------------------------
  # ● スキル選択開始
  #--------------------------------------------------------------------------
  def start_skill_select
    @skill_window = Window_Skill.new(@active_battler)
    @skill_window.help_window = @battlehelp_window
    x = $game_party.actors[@selected_actor_index]
    @supplementary_window = Window_BattleSkillSupplementary.new(x)
    @supplementary_window.visible = true
    @actor_command_windows[@selected_actor_index].active = false
    @actor_command_windows[@selected_actor_index].visible = false
  end
  #--------------------------------------------------------------------------
  # ● スキル選択終了
  #--------------------------------------------------------------------------
  def end_skill_select
    @skill_window.dispose
    @skill_window = nil
    @supplementary_window.visible = false
    @supplementary_window.dispose
    @supplementary_window = nil
    @battlehelp_window.visible = false
    @actor_command_windows[@selected_actor_index].active = true
    @actor_command_windows[@selected_actor_index].visible = true
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択開始
  #--------------------------------------------------------------------------
  def start_item_select
    @item_window = Window_Item.new
    @item_window.help_window = @battlehelp_window
    @actor_command_windows[@selected_actor_index].active = false
    @actor_command_windows[@selected_actor_index].visible = false
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択終了
  #--------------------------------------------------------------------------
  def end_item_select
    @item_window.dispose
    @item_window = nil
    @battlehelp_window.visible = false
    @actor_command_windows[@selected_actor_index].active = true
    @actor_command_windows[@selected_actor_index].visible = true
  end
end
