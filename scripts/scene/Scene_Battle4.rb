#==============================================================================
# ■ Scene_Battle (分割定義 4)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● メインフェーズ開始
  #--------------------------------------------------------------------------
  def start_resolution
    @resolve_step = 1
    @resolve_delay = 40
    $game_temp.hp_damage_hook = 0
    $game_temp.ft_damage_hook = 0
    $game_temp.ex_damage_hook = 0
    $game_temp.general_damage_hook = 0
    reset_new_states
    if @resolving_battler.current_action.type == 1
      if @resolving_battler.state?(9)
        resolve_end
      end
    end
    if @resolving_battler.is_a?(Game_Actor)
      if @resolving_battler.summon_actor
        @summon_resolving = true
      else
        @summon_resolving = false
      end
    end
    @cover = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ)
  #--------------------------------------------------------------------------
  def update_resolution
    battlers = []
    battlers.push(@resolving_battler)
    if @target_battlers != nil
      for i in 0..@target_battlers.size - 1
        battlers.push(@target_battlers[i])
      end
    end
    if @objection_pending
      objection
      return
    end
    if @resolving_battler == nil
      return
    end
    if @spriteset.effect?(battlers)
      return
    end
    if @wait_count > 0
      @wait_count -= 1
      return
    end
    case @resolve_step
    when 1
      update_resolution_step1
    when 2
      update_resolution_step2
    when 3
      update_resolution_step3
    when 4
      update_resolution_step4
    when 5
      update_resolution_step5
    when 6
      update_resolution_step6
    when 7
      update_resolution_step7
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 1 : アクション準備)
  #--------------------------------------------------------------------------
  def update_resolution_step1
    @animation1_id = 0
    @animation2_id = 0
    @common_event_id = 0
    @resolve_step = 2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 2 : アクション開始)
  #--------------------------------------------------------------------------
  def update_resolution_step2
    @target_battlers = []
    @screen_animation = false
    berserk_charm_actions
    @resolving_battler.current_action.ready_forced_action(@resolving_battler)
    if abandon_resolution
      @resolve_end
    end
    case @resolving_battler.current_action.type
    when 1
      make_basic_action_result
    when 2
      make_skill_action_result
    when 3
      make_item_action_result
    when 4
      enemy_escapes
    when 5
      @steal_type = 1
      make_steal_action_result
    when 6
      @steal_type = 2
      make_steal_action_result
    when 7
      @steal_type = 3
      make_steal_action_result
    when 8
      @steal_type = 4
      make_steal_action_result
    when 9
      make_mutilate_action_result
    when 10
      make_tactic_action_result
    when 11
      make_withdraw_action_result
    when 12
      coordinate
    end
    if @resolve_step == 2
      @resolve_step = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● 基本アクション 結果作成
  #--------------------------------------------------------------------------
  def make_basic_action_result
    if @resolving_battler.current_action.type == 1
      @animation1_id = @resolving_battler.animation1_id
      @animation2_id = @resolving_battler.animation2_id
      set_attack_target
      cover
      @resolve_act = 1
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムの対象側バトラー設定
  #     scope : スキルまたはアイテムの効果範囲
  #--------------------------------------------------------------------------
  def set_target_battlers(scope)
    if @resolving_battler.is_a?(Game_Enemy)
      case scope
      when 1
        index = @resolving_battler.current_action.target_index
        @target_battlers.push($game_party.smooth_target_actor(index))
        check_untargetable(scope)
      when 2
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 3
        index = @resolving_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index))
      when 4
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 5
        index = @resolving_battler.current_action.target_index
        enemy = $game_troop.enemies[index]
        if enemy != nil and enemy.hp0?
          @target_battlers.push(enemy)
        end
      when 6
        for enemy in $game_troop.enemies
          if enemy != nil and enemy.hp0?
            @target_battlers.push(enemy)
          end
        end
      when 7
        @target_battlers.push(@resolving_battler)
      when 8
        @target_battlers = $game_party.multi_random_target_actor
        check_untargetable(scope)
      when 9
        @target_battlers = $game_troop.multi_random_target_enemy
      when 10
        @target_battlers = $game_troop.multi_random_target_enemy(true)
      when 11
        @target_battlers = $game_party.random_target_actor
        check_untargetable(scope)
      end
    end
    if @resolving_battler.is_a?(Game_Actor)
      case scope
      when 1
        index = @resolving_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index))
      when 2
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 3
        index = @resolving_battler.current_action.target_index
        @target_battlers.push($game_party.smooth_target_actor(index))
      when 4
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 5
        index = @resolving_battler.current_action.target_index
        actor = $game_party.actors[index]
        if actor != nil and actor.hp0?
          @target_battlers.push(actor)
        end
      when 6
        for actor in $game_party.actors
          if actor != nil and actor.hp0?
            @target_battlers.push(actor)
          end
        end
      when 7
        @target_battlers.push(@resolving_battler)
      when 8
        @target_battlers = $game_troop.multi_random_target_enemy
      when 9
        @target_battlers = $game_party.multi_random_target_actor
      when 10
        @target_battlers = $game_party.multi_random_target_actor(true)
      when 11
        @target_battlers = $game_troop.random_target_enemy
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルアクション 結果作成
  #--------------------------------------------------------------------------
  def make_skill_action_result
    @resolving_skill = $data_skills[@resolving_battler.current_action.skill_id]
    if @resolving_skill.animation2_id > 0
      pos = $data_animations[@resolving_skill.animation2_id].position
      if pos == 3
        @screen_animation = true
      end
    end
    unless @resolving_battler.current_action.forcing
      unless @resolving_battler.skill_can_use?(@resolving_skill.id)
        resolve_end
        return
      end
    end
    @effect_window.effect = @resolving_skill.name
    @effect_window.visible = true
    @animation1_id = @resolving_skill.animation1_id
    @animation2_id = @resolving_skill.animation2_id
    @common_event_id = @resolving_skill.common_event_id
    modifier = get_group_scope_change(@resolving_skill)
    set_target_battlers(@resolving_skill.scope + modifier)
    if @resolving_battler.is_a?(Game_Enemy)
      if villifed_actor != 0
        if @resolving_skill.scope == 1
          @target_battlers = [$game_party.actors[villifed_actor]]
        end
        if @resolving_skill.scope == 8
          if not @target_battlers.include?($game_actors[villified_actor])
            @target_battlers.push($game_party.actors[villifed_actor])
          end
        end
        if @resolving_skill.scope == 11
          @target_battlers = [$game_party.actors[villifed_actor]]
        end
      end
    end
    shaping_magnetism
    if @resolving_battler.is_a?(Game_Actor)
      if @resolving_battler.name == $game_schizo.schizo_actor?.name
        $game_schizo.determine_skill_type(@resolving_skill)
        $game_schizo.check_combo
        if $game_schizo.points > 0
          $game_schizo.resolve_effects(@resolving_skill, @target_battlers)
          @schizo_window.set($game_schizo.points, $game_schizo.special_effects)
          if $game_schizo.new_scope > -1
            set_target_battlers($game_schizo.new_scope)
          end
        end
      end
    end
    @resolve_act = 2
  end
  #--------------------------------------------------------------------------
  # ● アイテムアクション 結果作成
  #--------------------------------------------------------------------------
  def make_item_action_result
    @resolving_item = $data_items[@resolving_battler.current_action.item_id]
    @resolving_battler.item_used_times += 1
    if @resolving_item.animation2_id > 0
      pos = $data_animations[@resolving_item.animation2_id].position
      if pos == 3
        @screen_animation = true
      end
    end
    unless $game_party.item_can_use?(@resolving_item.id)
      resolve_end
      return
    end
    if @resolving_item.consumable
      $game_party.lose_item(@resolving_item.id, 1)
    end
    @effect_window.effect = @resolving_item.name
    @effect_window.visible = true
    @animation1_id = @resolving_item.animation1_id
    @animation2_id = @resolving_item.animation2_id
    @common_event_id = @resolving_item.common_event_id
    index = @resolving_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    set_target_battlers(@resolving_item.scope)
    if @resolving_item.scope == 3 or @resolving_item.scope == 4
      principia_alchemica
    end
    @resolve_act = 3
  end
  #--------------------------------------------------------------------------
  # ● アイテムアクション 結果作成
  #--------------------------------------------------------------------------
  def make_mutilate_action_result
    @resolving_battler.damage = @mutilate_damage
    @resolving_battler.hp -= @mutilate_damage
    @resolving_battler.animation_id = 5
    if @mutilate_status != -1
      unless @resolving_battler.state_full?(@mutilate_status)
        @resolving_battler.add_state(@mutilate_status)
        @resolving_battler.new_states.push(@mutilate_string)
      end
    end
    @effect_window.effect = "Mutilate"
    @effect_window.visible = true
    @target_battlers = [@resolving_battler]
    @resolve_act = 9
    @resolve_step = 4
  end
  #--------------------------------------------------------------------------
  # ● アイテムアクション 結果作成
  #--------------------------------------------------------------------------
  def make_withdraw_action_result
    @effect_window.effect = "Withdraw"
    @effect_window.visible = true
    @resolve_act = 11
    @resolve_step = 4
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 3 : 行動側アニメーション)
  #--------------------------------------------------------------------------
  def update_resolution_step3
    secondary_effects
    if @animation1_id == 0
      @resolving_battler.white_flash = true
    else
      @resolving_battler.animation_id = @animation1_id
      @resolving_battler.animation_hit = true
    end
    @resolve_step = 4
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 4 : 対象側アニメーション)
  #--------------------------------------------------------------------------
  def update_resolution_step4
    if @resolving_skill.id != 70
      reflect(@resolving_skill.scope)
    end
    if @reflect
      @wait_count = 40
      @reflect = false
      return
    end
    if @screen_animation
      if @resolving_battler.is_a?(Game_Actor)
        $game_troop.enemies[0].animation_id = @animation2_id
      else
        $game_party.actors[0].animation_id = @animation2_id
      end
    else
      for target in @target_battlers
        target.animation_id = @animation2_id
        target.animation_hit = true
      end
    end
    @wait_count = 8
    @resolve_step = 5
  end
  #--------------------------------------
  def update_resolution_step5
    no_ft_cost = @resolving_battler.current_action.no_fatigue_cost
    if @resolve_act == 1
      for target in @target_battlers
        hostage_attack
        target.attack_effect(@resolving_battler)
        counter
         if auto_abilities_hit
           @wait_count = 40
         end
      end
      unless no_ft_cost
        if @resolving_battler.weapon_id == 8
          if $game_temp.atk_missed
            change_ft_ex(10, 50)
          else
            change_ft_ex(20, 100)
          end
        else
          change_ft_ex(20, 100)
        end
      end
    end
    if @resolve_act == 2
      for target in @target_battlers
        target.skill_effect(@resolving_battler, @resolving_skill)
        if auto_abilities_hit
          @wait_count = 40
        end
      end
      overkill_explosion
      unless no_ft_cost
        ftc_down = 1
        if @resolving_battler.extract_effect
          ftc_down *= 2
        end
        if $game_schizo.ft_cost_reduction == 1
          ftc_down *= 2
        end
        if $game_schizo.ft_cost_reduction == 2
          ftc_down *= 9999
        end
        ex_mod = @resolving_skill.sp_cost
        ex_mod /= ftc_down
        ex_mod *= @resolving_battler.exertion
        ex_mod /= 100
        ex_mod.round
        if @resolving_battler == $game_schizo.schizo_actor?
          @resolving_battler.fatigue -= @resolving_skill.sp_cost / ftc_down
          @resolving_battler.fatigue -= ex_mod
          @resolving_battler.exertion += 100
          @resolving_battler.exertion -= $game_schizo.ex_cost_reduction * 50
          @resolving_battler.exertion += @resolving_battler.ex_cost_up
          $game_schizo.ft_cost_reduction = 0
          $game_schizo.ex_cost_reduction = 0
          if $game_schizo.doublecast
            unless $game_schizo.barrage
              force(@resolving_battler, 2, -2, 1, @resolving_skill.id, -1)
            end
          end
          if $game_schizo.barrage
            for actor in $game_party.actors
              unless actor.dead?
                force(actor, 2, -1, 1, @resolving_skill.id, -1)
              end
            end
          end
        else
          @resolving_battler.fatigue -= @resolving_skill.sp_cost / ftc_down
          @resolving_battler.fatigue -= ex_mod
          @resolving_battler.exertion += 100
          @resolving_battler.exertion += @resolving_battler.ex_cost_up
        end
        if @resolving_battler.is_a?(Game_Actor)
          unless @resolving_battler.extract_effect
            @resolving_battler.energy -= @resolving_skill.drain
          end
          if @resolving_battler.extract_effect
            @resolving_battler.extract_effect = false
          end
        end
      end
    end
    if @resolve_act == 3
      charge_item_misses
      for target in @target_battlers
        target.item_effect(@resolving_item)
      end
      unless no_ft_cost
        change_ft_ex(20, 100)
      end
    end
    if @resolve_act == 5
      unless no_ft_cost
        change_ft_ex(30, 100)
      end
    end
    if @resolve_act == 6
      unless no_ft_cost
        change_ft_ex(20, 100)
      end
    end
    if @resolve_act == 7
      unless no_ft_cost
        change_ft_ex(50, 100)
      end
    end
    if @resolve_act == 8
      unless no_ft_cost
        change_ft_ex(20, 100)
      end
    end
    if @resolve_act == 9
      change_ft_ex(0, 0)
    end
    if @resolve_act == 10
      change_ft_ex(0, 0)
    end
    if @resolve_act == 11
      change_ft_ex(0, 0)
      return_primary_party
    end
    if @resolve_act == 12
      change_ft_ex(40, 100)
    end
    @resolve_step = 6
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 5 : ダメージ表示)
  #--------------------------------------------------------------------------
  def update_resolution_step6
    @effect_window.visible = false
    @effect_window.kill_dummy
    @status_window.refresh
    if $game_temp.hp_damage_hook != 0
      @resolving_battler.damage = $game_temp.hp_damage_hook * -1
      absorb = true
    end
    if $game_temp.ft_damage_hook != 0
      @resolving_battler.damage = $game_temp.ft_damage_hook * -1
      absorb = true
    end
    if $game_temp.ex_damage_hook != 0
      @resolving_battler.damage = $game_temp.ex_damage_hook * -1
      absorb = true
    end
    if absorb
      @resolving_battler.damage_pop = true
    end
    for target in @target_battlers
      damaged = false
      if target.damage != nil || target.new_states.size > 0
        system_shock
        damaged = true
      end
      if target.fatigue_damage != nil || target.new_states.size > 0
        damaged = true
      end
      if target.exertion_damage != nil || target.new_states.size > 0
        damaged = true
      end
      if target.energy_damage != nil || target.new_states.size > 0
        damaged = true
      end
      if damaged
        target.damage_pop = true
      end
    end
    @resolve_step = 7
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 6 : リフレッシュ)
  #--------------------------------------------------------------------------
  def update_resolution_step7
    show_guts
    galvanize_effect
    set_echo
    @resolving_battler.death_attack = false
    @resolving_battler.extra_charge = false
    if @resolving_battler.next_action_delay == 0
      @resolving_delay_def_down = false
    end
    if @common_event_id > 0
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    if @steal_string.is_a?(Array)
      $game_temp.battle_message_text = @steal_string
      @steal_string = ""
      @steal_type = -1
    end
    if @steal_string.is_a?(String)
      if @steal_string != ""
        $game_temp.battle_message_text[0] = @steal_string
        @steal_string = ""
        @steal_type = -1
      end
    end
    if @no_coordinate
      s = "None of the hostages are primed to strike!"
      $game_temp.battle_message_text[0] = s
      @no_coordinate = false
    end
    resolve_end
  end
  #-------------------------------
  def resolve_end
    @resolve_step = 0
    @resolving_battler.current_action.type = 0
    reset_idle
    remove_cover
    @resolving_skill = $data_skills[70]
    @resolving_item = $data_items[42]
    if @resolving_battler.is_a?(Game_Actor)
      if @resolving_battler.combo_level == 0
        combo_break(true)
      end
    end
    @resolving_battler = nil
    @target_battlers = nil
    @pending_window.refresh
    $game_schizo.ft_tag = false
    $game_temp.filch_item = false
  end
  #-------------------------------
  def berserk_charm_actions
    if @resolving_battler.is_a?(Game_Enemy)
      if @resolving_battler.restriction == 2 or
        @resolving_battler.restriction == 3
        @resolving_battler.current_action.type = 1
      end
      if @resolving_battler.restriction == 3
        target = $game_troop.random_target_enemy
        @target_battlers = [target]
      elsif @resolving_battler.restriction == 2
        target = $game_party.random_target_actor
        @target_battlers = [target]
       end
     end
     if @resolving_battler.is_a?(Game_Actor)
      if @resolving_battler.restriction == 3
        target = $game_party.random_target_actor
        @target_battlers = [target]
      elsif @resolving_battler.restriction == 2
        target = $game_troop.random_target_enemy
        @target_battlers = [target]
       end
     end
   end
  #-------------------------------
  def set_attack_target
    target = nil
    flag = false
    if @target_battlers == []
      if @resolving_battler.is_a?(Game_Actor)
        index = @resolving_battler.current_action.target_index
        if index <= -11
          t = (index + 11).abs
          target = $game_party.actors[t]
          flag = true
        end
        unless flag
          target = $game_troop.smooth_target_enemy(index)
        end
      end
      if @resolving_battler.is_a?(Game_Enemy)
        index = @resolving_battler.current_action.target_index
        if index <= -11
          t = (index + 11).abs
          target = $game_troop.enemies[t]
          flag = true
        end
        unless flag
          target = $game_party.smooth_target_actor(index)
        end
         for actor in $game_party.actors
          if actor.villify >= 1
            if not actor.dead?
              target = actor
            end
          end
        end
      end
    end
    if target != nil
      @target_battlers = [target]
      check_untargetable(0)
    end
  end
  #-------------------------------
  def abandon_resolution
    act_type = @resolving_battler.current_action.type
    targ = @resolving_battler.current_action.target_index
    if act_type == 1 && targ == -1
      return true
    end
    if @resolving_battler.restriction == 4
      return true
    end
  end
  #-------------------------------
  def counter
    if @resolving_battler.current_action.type == 1
      for target in @target_battlers
        if target.is_a?(Game_Enemy)
          if target.damage != "Miss!"
            chance = target.atk_counter_chance
            chance += counter_modifiers_attack(target)
            if rand(100) < chance
              for i in 0..$game_party.actors.size - 1
                if $game_party.actors[i].name == @resolving_battler.name
                  t = i
                  c = target.atk_counter_code
                  if c == 0
                    a = Game_ForcedAction.new(1, t, true, 1, -1)
                  end
                  if c > 0
                    a = Game_ForcedAction.new(2, t, true, c, -1)
                  end
                  target.forced_actions.push(a)
                  $game_temp.forcing_battler.push(target)
                end
              end
            end
          else
            if target.counter_misses
               for i in 0..$game_party.actors.size - 1
                if $game_party.actors[i].name == @resolving_battler.name
                  t = i
                  a = Game_ForcedAction.new(1, t, true, 1, -1)
                  target.forced_actions.push(a)
                  $game_temp.forcing_battler.push(target)
                end
              end
            end
          end
        end
        if target.is_a?(Game_Actor)
          if target.damage != "Miss!"
            chance = 0
            chance += counter_modifiers_attack(target)
            if rand(100) < chance
              for i in 0..$game_troop.enemies.size - 1
                if $game_troop.enemies[i] == @resolving_battler
                  unless $game_troop.enemies[i].restriction > 1
                    t = i
                    c = 0
                    if c == 0
                      a = Game_ForcedAction.new(1, t, true, 1, -1)
                    end
                    if c > 0
                      a = Game_ForcedAction.new(2, t, true, c, -1)
                    end
                    target.forced_actions.push(a)
                    $game_temp.forcing_battler.push(target)
                  end
                end
              end
            end
          else
            if target.counter_misses
              for i in 0..$game_troop.enemies.size - 1
                if $game_troop.enemies[i] == @resolving_battler
                  unless $game_troop.enemies[i].restriction > 1
                    t = i
                    a = Game_ForcedAction.new(1, t, true, 1, -1)
                    target.forced_actions.push(a)
                    $game_temp.forcing_battler.push(target)
                  end
                end
              end
            end
          end
        end
      end
    end
    if @resolving_battler.current_action.type == 2
      for target in @target_battlers
        if target.is_a?(Game_Enemy)
          if target.damage != "Miss!"
            if rand(100) < target.skill_counter_chance
              for i in 0..$game_party.actors.size - 1
                if $game_party.actors[i].name == @resolving_battler.name
                  unless $game_party.actors[i].restriction > 1
                    t = i
                    c = target.skill_counter_code
                    if c == 0
                      a = Game_ForcedAction.new(1, t, true, 1, -1)
                    end
                    if c > 0
                      a = Game_ForcedAction.new(2, t, true, c, -1)
                    end
                    target.forced_actions.push(a)
                    $game_temp.forcing_battler.push(target)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  #-------------------------------
end
