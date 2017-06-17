class Scene_Battle
# -----------------------
def hp_shield_refresh
  for actor in $game_party.actors
    if actor.hp_shield_refresh_frames > 0
      if @segment % actor.hp_shield_refresh_frames == 0
        actor.hp_shield = actor.hp_shield_max
        actor.damage = "Shield Refreshed!"
        actor.damage_pop = true
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy.hp_shield_refresh_frames > 0
      if @segment % enemy.hp_shield_refresh_frames == 0
        enemy.hp_shield = enemy.hp_shield_max
        enemy.damage = "Shield Refreshed!"
        enemy.damage_pop = true
      end
    end
  end
end
# -----------------------
def decrement
  for actor in $game_party.actors
    if actor.untargetable_frames >= 0
      actor.untargetable_frames -= 1
    end
    if actor.auto_item_delay >= 0
      actor.auto_item_delay -= 1
    end
    if actor.invincible_frames >= 0
      actor.invincible_frames -= 1
    end
    if actor.villify >= 0
      actor.villify -= 1
    end
  end
  for enemy in $game_troop.enemies
    if enemy.untargetable_frames >= 0
      enemy.untargetable_frames -= 1
    end
    if enemy.invincible_frames >= 0
      enemy.invincible_frames -= 1
    end
  end
end
# -----------------------
def check_untargetable(scope)
  total = 0
  untargetable_battlers = []
  for actor in $game_party.actors
    if actor.untargetable_frames > 0
      untargetable_battlers.push(actor)
    end
  end
  for battler in untargetable_battlers
    total += 1
  end
  if total == $game_party.actors.size
    resolve_end
    return
  end
  for actor in untargetable_battlers
    if @target_battlers.include?(battler)
      @target_battlers.delete(battler)
    end
  end
  if @target_battlers == []
    if scope == 0
      x = $game_party.random_target_actor
      @target_battlers = [x]
      check_untargetable(0)
      return
    else
      actor = $game_party.random_target_actor
      @resolving_battler.current_action.target_index = actor.index
      set_target_battlers(scope)
    end
  end
end
# -----------------------
def charge_item
  if @charging_item
    unless @tag
      if Input.trigger?(Input::B)
        $game_system.se_play($data_system.cancel_se)
        @itemcharge_window.visible = false
        @actor_command_windows[@selected_actor_index].active = true
        $game_temp.item_charge = 0
        return
      end
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        @itemcharge_window.visible = false
        @charging_item = false
        start_item_select
        return
      end
    end
  end
  if @charging_item
    @tag = false
  end
  frames = 0
  if $game_temp.item_charge < 150
    frames = 10
  end
  if $game_temp.item_charge < 120
    frames = 8
  end
  if $game_temp.item_charge < 100
    frames = 6
  end
  if $game_temp.item_charge < 80
    frames = 4
  end
  if $game_temp.item_charge < 60
    frames = 3
  end
  if @itemcharge_window.visible
    if frames > 0
      if @segment % frames == 0
        if $game_temp.item_charge < 150
          $game_temp.item_charge += 1
          @itemcharge_window.update
          @itemcharge_window.refresh
        end
      end
    end
  end
end
# -----------------------
def make_steal_action_result
  prob = 0
  @steal_string = ""
  set_attack_target
  @resolve_act = @steal_type + 4
  @animation2_id = BLANK_ANIMATION_ID
  a = @resolving_battler.agi.to_f
  b = @target_battlers[0].agi.to_f
  idnum = @target_battlers[0].id
  c = $data_enemies[idnum]
  tb = @target_battlers[0]
  if @steal_type == 1
    @effect_window.effect = "Steal"
  end
  if @steal_type == 2
    @effect_window.effect = "Filch"
  end
  if @steal_type == 3
    @effect_window.effect = "Larceny"
  end
  if @steal_type == 4
    @effect_window.effect = "Rob"
  end
  @effect_window.visible = true
  Audio.se_play($game_system.steal_se, 100, 100)
  if tb.already_stolen
    @steal_string = "Nothing to steal."
    @resolve_step = 4
    return
  end
  item_check = c.steal_item == 0
  weapon_check = c.steal_weapon == 0
  armor_check = c.steal_armor == 0
  money_check = c.steal_money == 0
  if item_check && weapon_check && armor_check && money_check
    @steal_string = "Nothing to steal."
    @resolve_step = 4
    return
  end
  if tb.already_stolen
    @steal_string = "Nothing to steal."
    @resolve_step = 4
    return
  end
  if @steal_type == 1
    prob = 30 * (a / b)
    prob = Integer(prob)
    stolen = rand(100) < prob
    clear_damage(tb)
    if stolen
      if c.steal_item != 0
        name = $data_items[c.steal_item].name
        @steal_string = "Stole " + name + "!"
        tb.already_stolen = true
        $game_party.gain_item(c.steal_item, 1)
      end
      if c.steal_weapon != 0
        name = $data_weapons[c.steal_weapon].name
        @steal_string = "Stole " + name + "!"
        tb.already_stolen = true
        $game_party.gain_weapon(c.steal_weapon, 1)
      end
       if c.steal_armor != 0
        name = $data_armors[c.steal_armor].name
        @steal_string = "Stole " + name + "!"
        tb.already_stolen = true
        $game_party.gain_armor(c.steal_armor, 1)
      end
    else
      @steal_string = "Failed to steal."
    end
  end
  if @steal_type == 2
    clear_damage(tb)
    prob = 50 * (a / b)
    prob = Integer(prob)
    stolen = rand(100) < prob
    if stolen
      if c.steal_item != 0
        name = $data_items[c.steal_item].name
        @steal_string = "Stole " + name + "!"
        tb.already_stolen = true
        $game_party.gain_item(c.steal_item, 1)
        item = $data_items[c.steal_item].id
        a = Game_ForcedAction.new(3, -1, true, item, 2)
        @resolving_battler.forced_actions.push(a)
        $game_temp.forcing_battler.push(@resolving_battler)
      else
        @steal_string = "Failed to steal."
      end
    else
      @steal_string = "Failed to steal."
    end
  end
  if @steal_type == 3
    @target_battlers = []
    for enemy in $game_troop.enemies
      unless enemy.hidden
        unless enemy.dead?
          @target_battlers.push(enemy)
        end
      end
    end
    stolen = false
    @steal_string = []
    for i in 0..@target_battlers.size - 1
      a = @resolving_battler.agi.to_f
      b = @target_battlers[i].agi.to_f
      idnum = @target_battlers[i].id
      c = $data_enemies[idnum]
      tb = @target_battlers[i]
      clear_damage(tb)
      if tb.already_stolen
        next
      end
      prob = 20 * (a / b)
      prob = Integer(prob)
      stolen = rand(100) < prob
      if stolen
        if c.steal_item != 0
          name = $data_items[c.steal_item].name
          @steal_string.push("Stole " + name + "!")
          tb.already_stolen = true
          $game_party.gain_item(c.steal_item, 1)
        end
      end
    end
    if @steal_string == []
      @steal_string = "Failed to steal."
    end
  end
  if @steal_type == 4
    clear_damage(tb)
    prob = 30 * (a / b)
    prob = Integer(prob)
    stolen = rand(100) < prob
    if stolen
      if c.steal_money != 0
        name = c.steal_money.to_s
        @steal_string = "Stole " + name + " " + $data_system.words.gold + "!"
        tb.already_stolen = true
        $game_party.gain_gold(c.steal_money)
      else
        @steal_string = "Nothing to steal."
      end
    else
      @steal_string = "Failed to steal."
    end
  end
  @resolve_delay = 20
  @resolve_step = 4
end
# -----------------------
def de_index
  for i in 0..@actor_command_windows.size - 1
    @actor_command_windows[i].index = -1
  end
end
# -----------------------
def schizo
  actor = $game_schizo.schizo_actor?
  if actor.fatigue <= -100
    $game_schizo.faint_flag = true
    $game_schizo.low_ft = actor.fatigue
  end
  actor.recent_hp -= 1
  actor.recent_ft -= 1
  actor.recent_ex -= 1
  actor.recent_revive -= 1
  actor.damage_count += 1
  if actor.restriction == 4
    $game_schizo.idle_frames = 0
  end
  if actor.current_action.passive > 0
    $game_schizo.idle_frames = 0
  end
  $game_schizo.idle_frames += 1
end
# -----------------------
def system_shock
  actor = $game_schizo.schizo_actor?
  if @target_battlers.include?(actor)
    if actor.damage.is_a?(Numeric)
      if actor.damage > actor.maxhp / 3
        $game_schizo.system_shock = true
      end
    end
  end
end
# -----------------------
def reset_idle
  if @resolving_battler == $game_schizo.schizo_actor?
    $game_schizo.idle_frames = 0
  end
end
# -----------------------
def counter_modifiers_attack(battler)
  result = 0
  if battler.is_a?(Game_Actor)
    if battler.armor4_id == 8
      hp_portion = 0.00
      hp_portion += battler.hp.to_f / battler.maxhp.to_f
      hp_portion *= 10
      counter_up = 500 - hp_portion
      counter_up = Integer(counter_up)
      result += counter_up
    end
  end
  return result
end
# -----------------------
def berserk
  for actor in $game_party.actors
    if actor.berserk_count > 0
      if actor.hp == 0
        actor.berserk_count -= 1
        if actor.berserk_count % 20 == 0
          countdown = actor.berserk_count / 40
          text = countdown.to_s
          spr = @spriteset.countdown_sprites[actor.index].bitmap
          spr.clear
          spr.draw_text(0, 0, 24, 32, text, 1)
        end
        if actor.berserk_count == 0
          actor.berserk_count = -1
          spr = @spriteset.countdown_sprites[actor.index].bitmap
          spr.clear
        end
      end
    end
    if actor.berserk_count < 600
      if actor.doom_count == -1
        if actor.hp > 0
          actor.berserk_count = -1
          spr = @spriteset.countdown_sprites[actor.index].bitmap
          spr.clear
        end
      end
    end
  end
end
# -----------------------
def accelerant
  for actor in $game_party.actors
    if actor.venom_accelerant > 0
      actor.venom_accelerant -= 1
    end
  end
end
# -----------------------
def setup_counts
  for actor in $game_party.actors
    actor.support_crush = false
    actor.extract_effect = false
    actor.bleed = false
    actor.ex_inverse = false
    actor.delay_def_down = false
    actor.isolate = false
    actor.counter_misses = false
    actor.berserk_count = -1
    actor.doom_count = -1
    actor.venom_accelerant = -1
    actor.untargetable_frames = -1
    actor.invincible_frames = -1
    actor.auto_item_delay = -1
    actor.villify = -1
    actor.item_used_times = 0
    actor.itemfocus_item = 0
    actor.libel_level = 0
    actor.ex_cost_up = 0
    actor.bleed_last_hp = 0
    actor.combo_level = 0
    actor.ft_limit = 100
    actor.sealed_actions = []
    actor.element_guard_percent = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end
end
# -----------------------
def mutilate
  if @tag
    @tag = false
    return
  end
  if @mutilate_window.visible
    if Input.trigger?(Input::UP)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.damage += 1
    end
    if Input.trigger?(Input::DOWN)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.damage -= 1
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.damage -= 10
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.damage += 10
    end
    if Input.trigger?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.status += 1
    end
    if Input.trigger?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      @mutilate_window.status -= 1
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @mutilate_window.visible = false
      @actor_command_windows[@selected_actor_index].active = true
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.type = 9
      @mutilate_window.visible = false
      @mutilate_damage = @mutilate_window.damage
      case @mutilate_window.status
      when 0
        @mutilate_status = -1
      when 1
        @mutilate_status = 2
        @mutilate_string = "Poison"
      when 2
        @mutilate_status = 8
        @mutilate_string = "Disease"
      when 3
        @mutilate_status = 11
        @mutilate_string = "Sluggish"
      when 4
        @mutilate_status = 13
        @mutilate_string = "Stupify"
      end
      phase2_end
    end
  end
end
# -----------------------
def cover
  target = @target_battlers[0]
  if target.is_a?(Game_Enemy)
    for enemy in $game_troop.enemies
      if not @target_battlers.include?(enemy)
        if enemy != @resolving_battler
          if enemy.exist?
            if rand(100) < enemy.cover_chance
              unless @cover
                @cover = true
                @target_battlers = [enemy]
                enemy.cover_x = target.screen_x + 80
                enemy.cover_y = target.screen_y
              end
            end
          end
        end
      end
    end
  end
end
# -----------------------
def remove_cover
  @effect_window.visible = false
  for enemy in $game_troop.enemies
    enemy.cover_x = -1
    enemy.cover_y = -1
  end
end
# -----------------------
def show_guts
  for actor in $game_party.actors
    if actor.guts_flag
      actor.damage = "Guts!"
      actor.damage_pop = true
      actor.guts_flag = false
    end
  end
  for enemy in $game_troop.enemies
    if enemy.guts_flag
      enemy.damage = "Guts!"
      enemy.damage_pop = true
      enemy.guts_flag = false
    end
  end
end
# -----------------------
def escape_progress
  return @escape_progress
end
# -----------------------
def escape
  for actor in $game_party.actors
    process_escape(actor)
  end
  if not $game_temp.battle_can_escape
    @escape_progress = -1
  end
  if Input.trigger?(Input::Y)
    @escape_progress = 0
    @escape_effects = []
    @escape_window.refresh
  end
  if abort_escape?
    @escape_progress = 0
    @escape_effects = []
    @escape_window.refresh
  end
  if @escape_progress > 0
    if Graphics.frame_count % 4 == 0
      @escape_window.refresh
    end
  end
  if @escape_progress >= 10000
    force($game_party.actors[0], 2, 0, true, 35, -1)
  end
end
# -----------------------
def abort_escape?
  result = true
  for actor in $game_party.actors
    if actor.current_action.passive == 4
      result = false
    end
  end
  if @escape_break
    @escape_break = false
    result = true
  end
  return result
end
# -----------------------
def process_escape(actor)
  escaping = false
  base_value = 0
  if actor.current_action.passive == 4
    base_value = 12
    escaping = true
  end
  player_agi = actor.agi.to_f
  enemy_agi = 0.00
  enemy_count = 0
  for enemy in $game_troop.enemies
    if enemy.exist?
      enemy_count += 1
      enemy_agi += enemy.agi
    end
  end
  if enemy_count > 0
    enemy_agi /= enemy_count
    ratio = player_agi / enemy_agi
    if actor.armor2_id == 34
      ratio *= 1.1
    end
    total = Integer(ratio * base_value)
    if escaping
      if total < 1
        if enemy_count > 0
          total = 1
        end
      end
    end
  else
    total = 0
  end
  @escape_progress += total
end
# -----------------------
end