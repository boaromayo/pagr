#==============================================================================
# ■ Scene_Battle (分割定義 2)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● プレバトルフェーズ開始
  #--------------------------------------------------------------------------
  def begin_battle
    @actor_select_arrow = Arrow_ActorSelect.new(@spriteset.viewport2)
    @phase = 1
    $game_party.clear_actions
    @resolving_skill = $data_skills[70]
    @resolving_item = $data_items[42]
    setup_battle_event
  end
  #--------------------------------------------------------------------------
  # ● アフターバトルフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase3
    @phase = 3
    phase2_end
    erase_all_pictures
    kill_support_crush
    if $game_party.actors[0].summon_actor
      return_primary_party
    end
    de_index
    @escape_progress = 0
    @escape_window.refresh
    if @actor_select_arrow != nil
      unless @actor_select_arrow.disposed?
        @actor_select_arrow.dispose
      end
      @actor_select_arrow = nil
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
    if @battlemessage_window.running
      $game_temp.battle_message_text = []
      $game_temp.remove_battle_message = 100
      if $game_temp.message_proc != nil
        $game_temp.message_proc.call
      end
      $game_temp.message_text = nil
      $game_temp.message_proc = nil
      $game_temp.choice_start = 99
      $game_temp.choice_max = 0
      $game_temp.choice_cancel_type = 0
      $game_temp.choice_proc = nil
      $game_temp.num_input_start = 99
      $game_temp.num_input_variable_id = 0
      $game_temp.num_input_digits_max = 0
    end
    @monster_window.refresh
    if $game_system.microcosm_tag
      Audio.bgm_play($game_system.victory_bgm, 100, 130)
    else
      Audio.bgm_play($game_system.victory_bgm)
    end
    @exp = 0
    @gold = 0
    @treasures = []
    @level_up_actors = []
    @interfaces = [0, 0, 0, 0]
    for enemy in $game_troop.enemies
      enemy.show_hp_bar = false
      unless enemy.hidden
        $game_system.defeated_enemies.push(enemy.id)
        @exp += enemy.exp
        @gold += enemy.gold
        get_item = rand(100)
        if get_item < enemy.treasure_prob
          if enemy.item_id > 0
            @treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            @treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            @treasures.push($data_armors[enemy.armor_id])
          end
        end
        interface_order = shuffle_interface_order
        if rand(100) < 25
          @interfaces[interface_order[0]] += 1
        elsif rand(100) < 25
          @interfaces[interface_order[1]] += 1
        elsif rand(100) < 25
          @interfaces[interface_order[2]] += 1
        elsif rand(100) < 10
          @interfaces[3] += 1
        end
      end
    end
    @spriteset.hp_bars
    unless $game_actors[9].dead?
      $game_schizo.add_points
      $game_schizo.set_conditionals
    end
    if $game_party.actors.include?($game_actors[8])
      if $game_actors[8].hp > 0
        w = $game_actors[8].weapon_id
        a1 = $game_actors[8].armor1_id
        a2 = $game_actors[8].armor2_id
        a3 = $game_actors[8].armor3_id
        a4 = $game_actors[8].armor4_id
        ap = determine_ap
        if $game_system.current_ap_weapon[w] < 900000
          $game_system.current_ap_weapon[w] += ap
        end
        ap = determine_ap
        if $game_system.current_ap_armor[a1] < 900000
          $game_system.current_ap_armor[a1] += ap
        end
        ap = determine_ap
        if $game_system.current_ap_armor[a2] < 900000
          $game_system.current_ap_armor[a2] += ap
        end
        ap = determine_ap
        if $game_system.current_ap_armor[a3] < 900000
          $game_system.current_ap_armor[a3] += ap
        end
        ap = determine_ap
        if $game_system.current_ap_armor[a4] != -1
          if $game_system.current_ap_armor[a4] < 900000
            $game_system.current_ap_armor[a4] += ap
          end
        end
      end
    end
    $game_lawsystem.advance_time(2)
    if $game_temp.mandated_interfaces != []
      @interfaces = $game_temp.mandated_interfaces
      $game_temp.mandated_interfaces = []
    end
    $game_system.item_remain += @interfaces[0]
    $game_system.shaping_remain += @interfaces[1]
    $game_system.ability_remain += @interfaces[2]
    $game_system.omni_remain += @interfaces[3]
    nepthe_lv_up = false
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        lv1 = actor.level
        actor.exp += @exp
        lv2 = actor.level
        if lv2 > lv1
          @level_up_actors.push(i)
          if $game_party.actors[i].name == "Rhiaz"
            x1 = lv1
            x2 = lv2
            while x1 != x2
              $game_lawsystem.lawskill += x1
              x1 += 1
            end
          end
          if $game_party.actors[i].name == "Nepthe"
            nepthe_lv_up = true
          end
        end
      end
    end
    if nepthe_lv_up
      if ($game_actors[9].level % 3) == 0
        @new_schizoconditional = true
        $game_schizo.set_conditionals
      end
    end
    $game_party.gain_gold(@gold)
    for item in @treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    $game_temp.message_text = nil
    @result_window = nil
    @phase3_wait_count = 100
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  def update_phase3
    @battlemessage_window.visible = false
    if @phase3_wait_count > 0
      @phase3_wait_count -= 1
      if @phase3_wait_count == 5 && @result_progress > 0
         @result_window.visible = false
         @result_window.dispose
         @result_window = nil
      end
      if @phase3_wait_count == 0 && @result_progress < 7
        show_result_window
        if @result_progress < 7
          @result_window.visible = true
        end
      end
      return
    end
    if Input.trigger?(Input::C) && @result_progress == 7
      battle_end(0)
      @nepthe_learned = 0
      if $game_system.map_bgm_in_battle == false
        $game_system.bgm_play($game_temp.map_bgm)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  def phase3_start_test
    if @conclusion_delay == 0
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  def show_result_window
    while @result_window == nil && @result_progress < 7
      if @result_progress == 0
        if @exp == 0
          @result_progress = 1
          next
        end
       @result_window = Window_BattleResult.new(1, @exp)
       @phase3_wait_count = 60
       @result_progress = 1
      elsif @result_progress == 1
        if @gold == 0
          @result_progress = 2
          next
        end
        @result_window = Window_BattleResult.new(2, @gold)
        @phase3_wait_count = 60
        @result_progress = 2
      elsif @result_progress == 2
        unless @learned.size > 0
          @learned = $game_schizo.check_learned
        end
         if @learned == []
           @result_progress = 3
           next
         end
        if @learned[@nepthe_learn]
          id = @learned[@nepthe_learn]
          @nepthe_learn += 1
        end
        if @nepthe_learn == @learned.size
          @result_progress = 3
        end
        @result_window = Window_BattleResult.new(3, id)
        @phase3_wait_count = 60
      elsif @result_progress == 3
         if @treasures == []
           @result_progress = 4
           next
         else
           if @treasures[0].is_a?(RPG::Item)
             type = 4
           end
           if @treasures[0].is_a?(RPG::Weapon)
            type = 5
           end
           if @treasures[0].is_a?(RPG::Armor)
             type = 6
           end
        end
        id = @treasures[0].id
        @treasures.shift
        if @treasures == []
          @result_progress = 4
        end
        @result_window = Window_BattleResult.new(type, id)
        @phase3_wait_count = 60
      elsif @result_progress == 4
         if @interfaces == [0, 0, 0, 0]
            @result_progress = 5
            next
          else
            @result_window = Window_BattleResult.new(7, @interfaces)
            @phase3_wait_count = 60
            @result_progress = 5
          end
      elsif @result_progress == 5
        if @level_up_actors == []
          @result_progress = 6
        else
          @status_window.refresh
          id = $game_party.actors[@level_up_actors[0]].id
          @level_up_actors.shift
          if @level_up_actors == []
            @result_progress = 6
          end
          @result_window = Window_BattleResult.new(8, id)
          @phase3_wait_count = 60
        end
      elsif @result_progress == 6
        unless @new_schizoconditional
          @result_progress = 7
        else
          @result_window = Window_BattleResult.new(9, 0)
          @phase3_wait_count = 60
          @result_progress = 7
        end
      end
    end
  end
  # ----------------------------
  def shuffle_interface_order
    values = [0, 1, 2]
    result = []
    number1 = values[rand(3)]
    values.delete(number1)
    result.push(number1)
    number2 = values[rand(2)]
    values.delete(number2)
    result.push(number2)
    result.push(values[0])
    return result
  end
end
