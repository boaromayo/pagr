class Scene_Battle
# -----------------------
def fatigue_change
  for actor in $game_party.actors
    if actor.restriction == 4
      next
    end
    negative = false
    delay_change = 0.00
    delay_change += primary_fatigue_recovery(actor)
    delay_change *= actor.ftr
    delay_change = delay_change.round
    if delay_change < 0
      negative = true
      delay_change = passive_fixed_ft_loss(actor)
    end
    if delay_change != 0
      recovery = rand(delay_change.abs) + 1
    else
      recovery = 0
    end
    if @initiative < 0
      recovery = 0
    end
    if negative
      actor.fatigue_delay -= recovery
    else
      actor.fatigue_delay += recovery
    end
    while actor.fatigue_delay >= 100
      actor.fatigue += 1
      actor.fatigue_delay -= 100
    end
    while actor.fatigue_delay <= -100
      actor.fatigue -= 1
      actor.fatigue_delay += 100
    end
  end
  for enemy in $game_troop.enemies
    if enemy.restriction == 4 || enemy.hidden
      next
    end
    negative = false
    delay_change = 0.00
    delay_change += primary_fatigue_recovery(enemy)
    delay_change *= enemy.ftr
    delay_change = delay_change.round
    if delay_change < 0
      negative = true
    end
    if delay_change != 0
      recovery = rand(delay_change.abs) + 1
    else
      recovery = 0
    end
    if @initiative > 0
      recovery = 0
    end
    if negative
      enemy.fatigue_delay -= recovery
    else
      enemy.fatigue_delay += recovery
    end
    while enemy.fatigue_delay >= 100
      enemy.fatigue += 1
      enemy.fatigue_delay -= 100
    end
    while actor.fatigue_delay <= -100
      enemy.fatigue -= 1
      enemy.fatigue_delay += 100
    end
  end
end
# -----------------------
def exertion_change
   for actor in $game_party.actors
    if actor.dead? || actor.current_action.pending?
      next
    end
    delay_change = rand(40) + 11
    delay_change *= actor.exr
    delay_change = delay_change.round
    if actor.ex_inverse
      delay_change *= -1
    end
    actor.exertion_delay += delay_change
  end
  for enemy in $game_troop.enemies
    if enemy.dead? || enemy.hidden || enemy.current_action.pending?
      next
    end
    delay_change = rand(40) + 11
    delay_change *= enemy.exr
    delay_change = delay_change.round
    if enemy.ex_inverse
      delay_change *= -1
    end
    enemy.exertion_delay += delay_change
  end
  for actor in $game_party.actors
    while actor.exertion_delay >= 1000
      actor.exertion -= 10
      actor.exertion_delay -= 1000
    end
    while actor.exertion_delay <= -1000
      actor.exertion += 10
      actor.exertion_delay += 1000
    end
  end
  for enemy in $game_troop.enemies
    while enemy.exertion_delay >= 1000
      enemy.exertion -= 10
      enemy.exertion_delay -= 1000
    end
    while enemy.exertion_delay <= -1000
      enemy.exertion += 10
      enemy.exertion_delay += 1000
    end
  end
end
# -----------------------
def overfatigue_death_chance
  for actor in $game_party.actors
    if actor == @resolving_battler
      next
    end
    if actor.fatigue <= -101
      if actor.no_overfatigue
        actor.fatigue = -99
        next
      end
      chance = actor.fatigue + 100
      chance = chance.abs
      random = rand(20000) + 1
      if random <= chance
        unless actor.immortal
          actor.berserk_count = -1
          spr = @spriteset.countdown_sprites[actor.index].bitmap
          spr.clear
          actor.damage = "Overfatigue!"
          actor.damage_pop = true
          actor.hp = 0
        end
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy == @resolving_battler
      next
    end
    if enemy.fatigue <= -101
      if enemy.no_overfatigue
        enemy.fatigue = -99
        next
      end
      if enemy.immortal
        enemy.fatigue = -99
        next
      end
      chance = enemy.fatigue + 100
      chance = chance.abs
      random = rand(10000) + 1
      if random <= chance
        unless enemy.immortal or enemy.hidden
          enemy.damage = "Overfatigue!"
          enemy.damage_pop = true
          enemy.hp = 0
          @monster_window.refresh
        end
      end
    end
  end
end
# -----------------------
def update_actor_select_arrow
  if @phase == 1
    unless @actor_select_arrow == nil
      if @actor_select_arrow.disposed?
        @actor_select_arrow = Arrow_ActorSelect.new(@spriteset.viewport2)
      end
      @actor_select_arrow.update
      if Input.trigger?(Input::C)
        @selected_actor_index = @actor_select_arrow.index
      end
      if Input.trigger?(Input::X)
        if @tactical_ambush == 1
          @surprise_window.visible = false
          $game_system.se_play($data_system.decision_se)
          @tactical_ambush = 0
          convert_forced_action
        end
        a = $game_party.actors[@actor_select_arrow.index]
        if a.current_action.passive > 0
          $game_system.se_play($data_system.decision_se)
          a.damage = "Passive Cancel"
          a.damage_pop = true
          a.current_action.passive = 0
        end
      end
    else
      unless @actor_select_arrow == nil
        unless @actor_select_arrow.disposed?
          @actor_select_arrow.dispose
        end
      end
    end
  end
end
# -----------------------
def check_selected_actor(buzzer)
  result = true
  if @selected_actor_index < 0
    return false
  end
  actor = $game_party.actors[@selected_actor_index]
  if actor == nil
    result = false
  end
  if actor.dead?
    result = false
  end
  if actor.fainted?
    result = false
  end
  if not actor.inputable?
    result = false
  end
  if not actor.movable?
    result = false
  end
  if actor.waiting?
    result = false
  end
  if actor.hidden
    result = false
  end
  if $game_temp.forcing_battler.include?(actor)
    result = false
  end
  if actor.current_action.pending?
    result = false
  end
  if @initiative < 0
    result = false
  end
  if @tactical_resolving
    result = false
  end
  if result == false
    if buzzer
      $game_system.se_play($data_system.buzzer_se)
    end
    @selected_actor_index = -1
  end
  return result
end
# -----------------------
def battler_can_act?(battler, check_involuntary, check_pending)
  result = true
  if battler == nil
    result = false
  end
  if battler.dead?
    result = false
  end
  if battler.fainted?
    result = false
  end
  if battler.hidden
    result = false
  end
  if not battler.movable?
    result = false
  end
  if check_involuntary
    if not battler.inputable?
    result = false
    end
  end
  if check_pending
    if battler.current_action.pending?
      result = false
    end
    if battler.waiting?
      result = false
    end
  end
  if battler.is_a?(Game_Enemy) && @initiative > 0
    result = false
  end
  return result
end
# -----------------------
def monsters_all_frozen?
  result = true
  for enemy in $game_troop.enemies
    if battler_can_act?(enemy, false, true)
      result = false
    end
  end
  return result
end
# -----------------------
def actions_waiting
  waiting_battlers = []
  for actor in $game_party.actors
    if actor.current_action.type != 0 
      if actor.current_action.action_delay == 0
        waiting_battlers.push(actor)
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy.current_action.type != 0
      if enemy.current_action.action_delay == 0
        waiting_battlers.push(enemy)
      end
    end
  end
  p = max_priority(waiting_battlers)
  priority_battlers = []
  for battler in waiting_battlers
    if battler.action_priority == p
      priority_battlers.push(battler)
    end
  end
  waiting_battlers = priority_battlers
  return waiting_battlers
end
# -----------------------
def clear_frozen_battlers
  for actor in $game_party.actors
    if actor.restriction >= 2
      if actor.current_action.type >= 2
        actor.current_action.clear
      end
      actor.current_action.passive = 0
    end
    if !battler_can_act?(actor, false, false)
      unless actor.forced_actions.size > 0
        actor.current_action.clear
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy.restriction >= 2
      if enemy.current_action.type >= 2
        enemy.current_action.clear
      end
      enemy.current_action.passive = 0
    end
    if !battler_can_act?(enemy, false, false)
       unless enemy.forced_actions.size > 0
        enemy.current_action.clear
      end
    end
  end
end
# -----------------------
def choose_battler_to_resolve(battlers)
  if battlers.size == 0
    return
  end
  highest_agi_battler = battlers[0]
  if battlers.size > 1
    for battler in battlers
      if battler.agi > highest_agi_battler.agi
        highest_agi_battler = battler
      end
    end
  end
  return highest_agi_battler
end
# -----------------------
def resolving?
  return @resolve_step > 0
end
# -----------------------
def choose_monster_actions
  if monsters_all_dead?
    return
  end
  if monsters_all_frozen?
    return
  end
  if @tactical_resolving
    none = true
    for monster in $game_troop.enemies
      if monster.current_action.type > 0
        none = false
      end
    end
    if none
      @surprise_window.visible = false
      @tactical_resolving = false
    end
  end
  if @tactical_ambush == -1
    @tactical_ambush = 0
    @tactical_resolving = true
    for monster in $game_troop.enemies
      monster.make_action
    end
    return
  end
  for monster in $game_troop.enemies
    if battler_can_act?(monster, false, true)
      if rand(determine_act_chance(monster)) == 0
        monster.make_action
        @pending_window.refresh
        determine_delay_monster(monster)
        if monster.current_action.passive > 0
          monster.white_flash = true
          s = $data_skills[monster.current_action.skill_id]
          @effect_window.effect = s.name
          @effect_window.visible = true
          @effect_window.passive_time = 60
        end
      end
    end
  end
end
# -----------------------
def actor_involuntary_actions
  for actor in $game_party.actors
    x = rand(250)
    if x == 0
      if actor.restriction == 2
        actor.current_action.type = 1
      end
      if actor.restriction == 3
        actor.current_action.type = 1
      end
    end
  end
end
# -----------------------
def slip_damage
  if @segment % 200 == 0
    for actor in $game_party.actors
      if actor.hp >= 1
        actor.slip_damage_effect
      end
    end
    for enemy in $game_troop.enemies
      if enemy.hp >= 1
        enemy.slip_damage_effect
      end
    end
  end
end
# -----------------------
def refresh_test
  if @phase == 3
    return
  end
  if @segment % (10 * $game_system.battle_frame_update) == 0
    @status_window.refresh
    @monster_window.refresh
    if @supplementary_window != nil
      if @supplementary_window.visible
        @supplementary_window.refresh
      end
    end
  end
end
# -----------------------
def clear_turn_flags
  for page in 0...$data_troops[@troop_id].pages.size
    if $data_troops[@troop_id].pages[page].span == 1
      $game_temp.battle_event_flags[page] = false
    end
  end
end
# -----------------------
def monsters_all_dead?
  result = true
  for enemy in $game_troop.enemies
    if enemy.exist?
       result = false
     end
  end
  return result
end
# -----------------------
def time_stopped?
  if @phase == 3
    return true
  end
  if @tactical_ambush == 1
    return true
  end
  if @wait_count > 0
    return true
  end
  if @conclusion_delay > 0
    return true
  end
  if $game_temp.num_input_variable_id > 0
    return true
  end
  if @scan_window != nil
    return true
  end
  return false
end
# -----------------------
def segment_state_remove
  for actor in $game_party.actors
    actor.remove_states_auto
  end
  for enemy in $game_troop.enemies
    enemy.remove_states_auto
  end
end
# -----------------------
end