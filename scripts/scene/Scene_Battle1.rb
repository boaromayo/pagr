#==============================================================================
# ■ Scene_Battle (分割定義 1)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  attr_accessor :spriteset
  attr_accessor :charging_item
  LEUKOCITE_ANIMATION_ID = 48
  SUMMON_ANIMATION_ID = 79
  BLANK_ANIMATION_ID = 127
  PLAYER_REFLECT_ANIMATION_ID = 191
  ENEMY_REFLECT_ANIMATION_ID = 192
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    $game_temp.in_battle = true
    $game_temp.battle_turn = 1
    $game_temp.battle_event_flags.clear
    $game_temp.battle_abort = false
    $game_temp.battle_choices = []
    $game_temp.forcing_battler = []
    $game_temp.battle_message_text = [""]
    $game_temp.remove_battle_message = 0
    $game_system.battle_interpreter.setup(nil, 0)
    $game_schizo.setup_battle
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    @spriteset = Spriteset_Battle.new
    @objection_sprite = Sprite.new
    @objection_sprite.x = 194
    @objection_sprite.y = 98
    @objection_sprite.z = 5000
    @objection_sprite.visible = false
    @steal_string = ""
    @bcheck = true
    @value_changed = false
    @started = false
    @setup_commands = false
    @conclude_set = false
    @input_number_check = false
    @choice_check = false
    @tactical_resolving = false
    @paused = false
    @charging_item = false
    @cover = false
    @no_show_command = false
    @new_schizoconditional = false
    @objection_pending = false
    @screen_animation = false
    @no_coodinate = false
    @escape_break = false
    @reflect = false
    @focusing = false
    @kill_tag = false
    @resolving_battler = nil
    @subsequent_message_wait_count = 0
    @resolve_step = 0
    @resolve_delay = 0
    @resolve_action = 0
    @escape_progress = 0
    @kill_count = 0
    @next_target_group = 0
    @objection_sprite_visibility_count = -1
    @conclusion_delay = -1
    @actor_command_windows = []
    @battlemessage_window = Window_BattleMessage.new
    @battlemessage_window.visible = false
    @dummy_window = Window_Base.new(20, 0, 600, 51)
    @dummy_window.x = 20
    @dummy_window.y = 10
    @dummy_window.z = 1100
    @dummy_window.visible = false
    @surprise_window = nil
    @effect_window = Window_BattleEffect.new
    @effect_window.visible = false
    @schizo_window = Window_SchizoCombo.new
    @pause_window = Window_Base.new(256, 120, 132, 96)
    @pause_window.contents = Bitmap.new(100, 64)
    @pause_window.contents.font.name = "Monotype Corsiva"
    @pause_window.contents.font.size = 48
    @pause_window.contents.draw_text(4, 0, 100, 64, "Pause", 1)
    @pause_window.visible = false
    @pause_window.opacity = 0
    @skill_window = nil
    @item_window = nil
    @actor_arrow = nil
    @enemy_arrow = nil
    @battlehelp_window = Window_BattleHelp.new
    @battlehelp_window.visible = false
    @battlehelp_window.z = 1050
    @status_window = Window_BattleStatus.new
    @status_window.z = 1000
    @monster_window = Window_MonsterName.new
    @monster_window.z = 1000
    @itemcharge_window = Window_ItemCharge.new
    @itemcharge_window.z = 1300
    @itemcharge_window.visible = false
    @mutilate_window = Window_Mutilate.new
    @mutilate_window.visible = false
    @escape_window = Window_Escape.new
    @escape_window.visible = false
    @ai_window = Window_BattleAI.new
    @ai_window.visible = false
    @ai_window.active = false
    @pending_window = Window_PendingAction.new
    @summon_resolving = false
    @wait_count = 0
    @result_progress = 0
    @selected_actor_index = -1
    @segment = 1
    @steal_type = -1
    @nepthe_learn = 0
    @escape_effects = []
    @summon_primary_party = []
    @activated_auto_abilities = []
    @learned = []
    if $data_system.battle_transition == ""
      Graphics.transition(20)
    else
      Graphics.transition(40, "Graphics/Transitions/" +
      $data_system.battle_transition)
    end
    reassign_index
    apply_evolution
    clear_forced_actions
    setup_actor_command_windows
    setup_counts
    setup_pending
    determine_surprise
    remove_damage
    create_shields
    imperator
    enzyme_power
    begin_battle
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    $game_map.refresh
    Graphics.freeze
    @status_window.dispose
    @monster_window.dispose
    @effect_window.dispose
    @dummy_window.dispose
    @schizo_window.dispose
    @mutilate_window.dispose
    @escape_window.dispose
    @itemcharge_window.dispose
    @battlemessage_window.dispose
    @battlehelp_window.dispose
    @ai_window.dispose
    @pending_window.dispose
    @objection_sprite.dispose
    if @choice_window != nil
      @choice_window.dispose
    end
    if @number_window != nil
      @number_window.dispose
    end
    if @skill_window != nil
      @skill_window.dispose
    end
    if @item_window != nil
      @item_window.dispose
    end
    if @result_window != nil
      @result_window.dispose
    end
    if @surprise_window != nil
      @surprise_window.dispose
    end
    if @auto_window != nil
      @auto_window.dispose
    end
    for i in 0..$game_party.actors.size - 1
      @actor_command_windows[i].dispose
    end
    @spriteset.dispose
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
    if $BTEST and not $scene.is_a?(Scene_Gameover)
      $scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 勝敗判定
  #--------------------------------------------------------------------------
  def judge
    if $game_party.actors[0].summon_actor
      if $game_party.actors[0].hp == 0
        return_primary_party
      end
    end
    if $game_party.all_dead? or $game_party.actors.size == 0
      if $game_temp.battle_can_lose
        if $game_system.map_bgm_in_battle == false
          $game_system.bgm_play($game_temp.map_bgm)
        end
        battle_end(2)
        return true
      end
      if $game_system.microcosm_tag
        $scene = Scene_Microcosm.new
      else
        if @kill_tag == false
          $game_temp.battle_message_text.push("Annihilated.")
          @kill_tag = true
          @kill_count = 200
        elsif @kill_count >= 1
          @kill_count -= 1
          return
        else
          $game_temp.gameover = true
        end
      end
      return true
    end
    for enemy in $game_troop.enemies
      if enemy.exist?
        return false
      end
    end
    if phase3_start_test and not @started
      @started = true
      start_phase3
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● バトル終了
  #     result : 結果 (0:勝利 1:敗北 2:逃走)
  #--------------------------------------------------------------------------
  def battle_end(result)
    erase_all_pictures
    if $game_temp.battle_dvd_mode
      $scene = Scene_Microcosm.new
    else
      $game_temp.in_battle = false
      $game_party.clear_actions
      for actor in $game_party.actors
        actor.remove_states_battle
      end
      $game_troop.enemies.clear
      if $game_temp.battle_proc != nil
        $game_temp.battle_proc.call(result)
        $game_temp.battle_proc = nil
      end
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルイベントのセットアップ
  #--------------------------------------------------------------------------
    def setup_battle_event
    if $game_system.battle_interpreter.running?
      return
    end
    for index in 0...$data_troops[@troop_id].pages.size
      page = $data_troops[@troop_id].pages[index]
      c = page.condition
      unless c.turn_valid or c.enemy_valid or
             c.actor_valid or c.switch_valid
        next
      end
      if $game_temp.battle_event_flags[index]
        next
      end
      if c.turn_valid
        n = @segment
        a = c.turn_a
        b = c.turn_b
        if (b == 0 and n != a) or
           (b > 0 and (n < 1 or n < a or n % b != a % b))
          next
        end
      end
      if c.enemy_valid
        enemy = $game_troop.enemies[c.enemy_index]
        if enemy == nil or enemy.hp * 100.0 / enemy.maxhp > c.enemy_hp
          next
        end
      end
      if c.actor_valid
        actor = $game_actors[c.actor_id]
        if actor == nil or actor.hp * 100.0 / actor.maxhp > c.actor_hp
          next
        end
      end
      if c.switch_valid
        if $game_switches[c.switch_id] == false
          next
        end
      end
      $game_system.battle_interpreter.setup(page.list, 0)
      if page.span <= 1
        $game_temp.battle_event_flags[index] = true
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    pause
    if @paused
      return
    end
    if $game_temp.remove_battle_message > 0
      if $game_temp.battle_message_text != [] || 
        $game_temp.num_input_variable_id > 0
        @subsequent_message_wait_count = 10
      end
      $game_temp.remove_battle_message -= 1
    end
    if $game_temp.remove_battle_message == 0
      $game_temp.remove_battle_message = -1
      @battlemessage_window.visible = false
    end
    if @subsequent_message_wait_count > 0
      @subsequent_message_wait_count -= 1
    end
    if @conclusion_delay > 0
      @conclusion_delay -= 1
    end
    if @conclusion_delay == 0
      judge
    end
    if monsters_all_dead?
      if @conclusion_delay == -1
        if @conclude_set == false
          @conclude_set = true
          @conclusion_delay = 50
        end
      end
    end
    if $game_system.battle_interpreter.running?
      $game_system.battle_interpreter.update
      unless $game_system.battle_interpreter.running?
        unless judge
          setup_battle_event
        end
      end
    end
    @no_update_flag = false
    $game_system.update
    $game_screen.update
    @status_window.update
    @monster_window.update
    @effect_window.update
    @dummy_window.update
    @spriteset.update
    @battlemessage_window.update
    @schizo_window.update
    @mutilate_window.update
    @escape_window.update
    @ai_window.update
    if @surprise_window != nil
      @surprise_window.update
      if not @surprise_window.visible
        @surprise_window = nil
      end
    end
    if @auto_window != nil
      @auto_window.update
      if not @auto_window.visible
        @auto_window = nil
      end
    end
    if @scan_window != nil
      @scan_window.update
      if @scan_window.remove
        @scan_window = nil
      end
    end
    if @choice_check
      @choice_window.update
      update_battle_choices
    end
    if @input_number_check
      @number_window.update
      update_number_input
    end
    if @objection_sprite_visibility_count > 0
      @objection_sprite_visibility_count -= 1
      if @objection_sprite_visibility_count == 0
        if @effect_window.effect == "Objection"
          @effect_window.visible = false
        end
        @objection_sprite.visible = false
        @objection_sprite_visibility_count = -1
      end
    end
    for i in 0..$game_party.actors.size - 1
      member = $game_party.actors[i]
      if member.battle_commands != @actor_command_windows[i].commands
        setup_actor_command_windows
      end
      if member != nil
        @actor_command_windows[i].update
      end
    end
    if $game_temp.battle_message_text != []
      if @battlemessage_window.running
        @battlemessage_window.update
      else
        @bcheck = false
        if $game_temp.remove_battle_message == -1
          if @subsequent_message_wait_count == 0
            @battlemessage_window.dispose
            @battlemessage_window = Window_BattleMessage.new
          end
        end
      end
    end
    if $game_temp.num_input_variable_id > 0
      unless $game_temp.battle_message_text != []
        unless @input_number_check
          unless @choice_check
            unless $game_temp.remove_battle_message >= 0
              unless @subsequent_message_wait_count > 0
                unless monsters_all_dead?
                  if @phase == 2
                    phase2_end
                  end
                  unless @actor_select_arrow.disposed?
                    @actor_select_arrow.dispose
                  end
                  @input_number_check = true
                  @dummy_window.visible = true
                  digits = $game_temp.num_input_digits_max 
                  @number_window = Window_InputNumber.new(digits)
                  @number_window.visible = true
                  @number_window.active = true
                  @number_window.x = 20
                  @number_window.y = 4
                  @number_window.z = 9999
                  @number_window.back_opacity = 0
                end
              end
            end
          end
        end
      end
    end
    if $game_temp.battle_choices != []
      unless $game_temp.battle_message_text != []
        unless @input_number_check
          unless @choice_check
            unless $game_temp.remove_battle_message >= 0
              unless @subsequent_message_wait_count > 0
                unless monsters_all_dead?
                  if @phase == 2
                    phase2_end
                  end
                  unless @actor_select_arrow.disposed?
                    @actor_select_arrow.dispose
                  end
                  @choice_check = true
                  @choice_window = Window_BattleChoice.new
                  @choice_window.visible = true
                  @choice_window.active = true
                  @choice_window.x = 20
                  @choice_window.y = 4
                  @choice_window.z = 9999
                end
              end
            end
          end
        end
      end
    end
    unless @phase == 3
      unless judge
        setup_battle_event
      end
    end
    if resolving?
      update_resolution
    else
      if @objection_pending
        objection
      end
    end
    if @phase == 2
      if check_selected_actor(false) == false
        $game_temp.item_charge = 0
        phase2_end
        @phase = 1
      end
    end
    if @phase == 1
      unless @input_number_check
        unless @no_update_flag
          unless judge
            update_actor_select_arrow
          end
        end
      end
    end
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    if $game_temp.gameover
      $scene = Scene_Gameover.new
      return
    end
    if $game_temp.to_title
      $scene = Scene_Title.new
      return
    end
    if $game_temp.battle_abort
      if $game_system.map_bgm_in_battle == false
        $game_system.bgm_play($game_temp.map_bgm)
      end
      battle_end(1)
      return
    end
    if @resolve_delay > 0
      @resolve_delay -= 1
    end
    if @wait_count > 0
      @wait_count -= 1
    end
    if @phase == 3
      update_phase3
      return
    end
    if @phase == 1
      for actor in $game_party.actors
        if @initiative > 0
          init = true
        else
          init = false
        end
        actor.setup_ai_action(init)
        actor.current_action.ready_action
      end
    end
    if @phase == 1 && check_selected_actor(true)
      @phase = 2
    end
    if @phase == 2
      update_phase2
    end
    if @segment % 20 == 0
      combo_break(false)
      auto_abilities_general
      remove_ferroelectric
      slip_damage
      @spriteset.hp_bars
    end
    clear_frozen_battlers
    leukocite_processing
    unless time_stopped?
      @segment += 1
      $game_temp.battle_turn += 1
      fatigue_change
      exertion_change
      overfatigue_death_chance
      segment_state_remove
      deciduous_woodbranch
      escape
      spread_plague
      charge_item
      mutilate
      refresh_test
      schizo
      berserk
      doom
      accelerant
      sealed_action_recovery
      clear_turn_flags
      hp_shield_refresh
      action_delay_countdown
      decrement
      kill_actin
      hibernation
      bleed
      actor_involuntary_actions
      choose_monster_actions
      init_countdown
      if @resolving_battler == nil && @resolve_delay == 0
        w = actions_waiting
      else
        w = []
      end
      if $game_temp.battle_message_text == []
        if $game_temp.remove_battle_message == -1
          unless $game_system.battle_interpreter.running?
            if $game_temp.forcing_battler != [] && @resolving_battler == nil
              @resolving_battler = $game_temp.forcing_battler.shift
              start_resolution
            end
            if w.size > 0 && @resolving_battler == nil
              @resolving_battler = choose_battler_to_resolve(w)
              start_resolution
            end
          end
        end
      end
    end
  end
end
