class Scene_Battle
# -----------------------
def interlocutory_briefing
  @tactical_ambush = 1
  @surprise_window = Window_Surprise.new(1, [], 0)
end
# -----------------------
def convert_forced_action
  for actor in $game_party.actors
    type = actor.current_action.type
    target = actor.current_action.target_index
    add_a = -1
    add_b = -1
    if type == 2
      add_a = actor.current_action.skill_id
    end
    if type == 3
      add_a = actor.current_action.item_id
    end
    if type != 0
      force(actor, type, target, false, add_a, add_b)
    end
  end
end
# -----------------------
def charge_item_misses
  dice = rand(100)
  if $game_temp.item_charge < dice
    if @resolving_battler == $game_actors[9]
      if @resolving_item != nil
        if @resolving_item.scope == 0
          if @common_event_id > 0
            unless $game_temp.filch_item
              miss_text = "Item failed to activate."
              $game_temp.battle_message_text.push(miss_text)
              @common_event_id = 0
            end
          end
        end
      end
    end
  end
end
# -----------------------
def overkill_explosion
  flag = false
  skill = $data_skills[37]
  if @resolving_skill.id == 36
    for target in @target_battlers
      if rand(100) < target.overkill_percent
        flag = true
        target.damage_pop = true
      end
    end
  end
  if flag
    @target_battlers[0].animation_id = 145
    for enemy in $game_troop.enemies
      unless @target_battlers.include?(enemy)
        enemy.skill_effect(@resolving_battler, skill)
        enemy.damage_pop = true
      end
    end
  end
end
# -----------------------
def secondary_effects
  if @resolving_battler.current_action.counter
    @effect_window.effect = "Counter"
    @effect_window.visible = true
  end
  if @cover
    @effect_window.effect = "Protect Ally"
    @effect_window.visible = true
  end
  if @resolving_battler.death_attack
    @effect_window.effect = "Final Attack"
    @effect_window.visible = true
  end
end
# -----------------------
def principia_alchemica
  if @resolving_battler == $game_schizo.schizo_actor?
    if @resolving_battler.armor4_id == 17
      if $game_temp.item_charge >= 150
        @resolving_battler.extra_charge = true
        @target_battlers = []
        for actor in $game_party.actors
          @target_battlers.push(actor)
        end
      end
    end
  end
end
# -----------------------
def determine_delay_player
  total = 0
  if @active_battler.sluggish?
    total += 200
  end
  if @skill != nil
    total += @skill.delay
  end
  if @active_battler.current_action.setup == 1
    if @active_battler.charge_up
      total += 100
    end
  end
  total += @active_battler.next_action_delay
  @active_battler.current_action.action_delay = total
  @active_battler.current_action.total_delay = total
  @active_battler.next_action_delay = 0
end
# -----------------------
def determine_delay_monster(monster)
  total = 0
  if monster.sluggish?
    total += 200
  end
  if monster.current_action.skill_id != 0
    skill = $data_skills[monster.current_action.skill_id]
    total += skill.delay
  end
  if monster.current_action.type == 1
    if monster.charge_up
      total += 250
    end
  end
  total += monster.next_action_delay
  monster.current_action.action_delay = total
  monster.current_action.total_delay = total
  monster.next_action_delay = 0
end
# -----------------------
def change_ft_ex(ft_value, ex_value)
  ex_mod = ft_value * @resolving_battler.exertion / 100
  ex_mod.round
  @resolving_battler.fatigue -= ft_value
  @resolving_battler.fatigue -= ex_mod
  if @resolving_battler.ex_inverse
    @resolving_battler.exertion -= ex_value
  else
    @resolving_battler.exertion += ex_value
  end
  @resolving_battler.exertion += @resolving_battler.ex_cost_up
end
# -----------------------
def reset_new_states
  for actor in $game_party.actors
    actor.new_states = []
    actor.state_grabber = false
  end
  for enemy in $game_troop.enemies
    enemy.new_states = []
    enemy.state_grabber = false
  end
end
# -----------------------
def enemy_escapes
  @effect_window.effect = "Escape"
  @effect_window.visible = true
  @resolving_battler.hidden = true
  $game_system.se_play($data_system.escape_se)
  @resolve_step = 4
end
# -----------------------
def powerful_enemy
  lv = 0
  avg_lv = 0
  maxhp_up = 0
  str_up = 0
  dex_up = 0
  agi_up = 0
  int_up = 0
  ftr_up = 0
  exr_up = 0
  something_affected = false
  maximum_increase = 0
  for actor in $game_party.actors
    lv += actor.level
  end
  avg_lv = lv / $game_party.actors.size
  maximum_increase = avg_lv + 10
  while something_affected == false
    maxhp_affected = rand(100)
    str_affected = rand(100)
    dex_affected = rand(100)
    agi_affected = rand(100)
    int_affected = rand(100)
    ftr_affected = rand(100)
    exr_affected = rand(100)
    if maxhp_affected < 20
      maxhp_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if str_affected < 20
      str_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if dex_affected < 20
      dex_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if agi_affected < 20
      agi_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if int_affected < 20
      int_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if ftr_affected < 20
      ftr_up = rand(maximum_increase) + 1
      something_affected = true
    end
    if exr_affected < 20
      exr_up = rand(maximum_increase) + 1
      something_affected = true
    end
  end
  for enemy in $game_troop.enemies
    enemy.pe_maxhp_up = maxhp_up
    enemy.pe_str_up = str_up
    enemy.pe_dex_up = dex_up
    enemy.pe_agi_up = agi_up
    enemy.pe_int_up = int_up
    enemy.pe_ftr_up = ftr_up
    enemy.pe_exr_up = exr_up
    enemy.hp = enemy.maxhp
  end
  return [maxhp_up, str_up, dex_up, agi_up, int_up, ftr_up, exr_up]
end
# -----------------------
def call_for_help(possible_enemies, probability, max_enemies)
  no_enemies = "No enemies to summon."
  summon_miss = "No allies arrived in response to the call for help."
  summon = rand(100)
  if possible_enemies == []
    result_string = no_enemies
  end
  if $game_troop.enemies.size == max_enemies
    result_string = summon_miss
  end
  p = rand(possible_enemies.size)
  enemy = possible_enemies[p]
  t = $game_temp.battle_troop_id
  for i in 0..$data_troops[t].members.size - 1
    enemy_id = $data_troops[t].members[i].enemy_id
    if enemy == enemy_id
      member_index = i
    end
  end
  if summon < probability
    for i in 0..max_enemies - 1
      if $game_troop.enemies[i] == nil
        $game_troop.enemies[i] = Game_Enemy.new(t, member_index, i)
        name = $game_troop.enemies[i].name
        @spriteset = Spriteset_Battle.new
        result_string = name + " appeared!"
        break
      end
    end
  else
    result_string = summon_miss
  end
  $game_temp.battle_message_text.push(result_string)
end
# -----------------------
def determine_ap
  power_rand = rand(11)
  power_plus = 0.1 * power_rand
  power = 1 + power_plus
  ap_variance = rand(41) - 20
  ap_get = 0.0
  ap_get += $game_system.battle_difficulty
  ap_get **= power
  ap_get *= $game_actors[8].level
  if ap_variance < 0
    v = ap_variance.abs
    value = ap_get * v / 100
    ap_get -= value.abs
  end
  if ap_variance > 0
    v = ap_variance
    value = ap_get * v / 100
    ap_get += value.abs
  end
  ap_get = ap_get.round
  ap_get = Integer(ap_get)
  return ap_get
end
# -----------------------
def bleed
  for actor in $game_party.actors
    if actor.hp > actor.bleed_last_hp
      actor.bleed = false
    end
  end
  for enemy in $game_troop.enemies
    if enemy.hp > enemy.bleed_last_hp
      enemy.bleed = false
    end
  end
  if Graphics.frame_count % 20 == 0
    for actor in $game_party.actors
      if actor.bleed
        actor.hp -= 1
      end
    end
    for enemy in $game_troop.enemies
      if enemy.bleed
        enemy.hp -= 1
      end
    end
  end
  for actor in $game_party.actors
    actor.bleed_last_hp = actor.hp
  end
  for enemy in $game_troop.enemies
    enemy.bleed_last_hp = enemy.hp
  end
end
# -----------------------
def start_ai_select
  x = $game_party.actors[@selected_actor_index]
  @ai_window.set_actor(x.id)
  @actor_command_windows[@selected_actor_index].active = false
  @ai_window.active = true
  @ai_window.visible = true
end
# -----------------------
def end_ai_select
  @ai_window.active = false
  @ai_window.visible = false
  @actor_command_windows[@selected_actor_index].active = false
  @actor_command_windows[@selected_actor_index].visible = false
  phase2_end
end
# -----------------------
def update_phase2_ai_select
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @active_battler.current_action.setup = 0
    @ai_window.active = false
    @ai_window.visible = false
    @actor_command_windows[@selected_actor_index].active = true
    @actor_command_windows[@selected_actor_index].visible = true
    return
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    t = @active_battler.ai_tactics[@ai_window.index]
    @active_battler.current_action.setup = 10
    @active_battler.current_action.change_tactic = t
    end_ai_select
    return
  end
end
# -----------------------
def make_tactic_action_result
  @resolve_act = 10
  @effect_window.effect = "Tactics"
  @effect_window.visible = true
  t = @resolving_battler.current_action.change_tactic
  @resolving_battler.current_tactic = t
  @animation2_id = BLANK_ANIMATION_ID
end
# -----------------------
def objection
  a = $game_actors[10]
  element_count = 0
  element_red = 0
  element_green = 0
  element_blue = 0
  fail = false
  a.white_flash = true
  @objection_pending = false
  failed_objection = "No resolving Shaping ability to which to object."
  sustained = Bitmap.new("Graphics/Stuff/obj01.png")
  overruled = Bitmap.new("Graphics/Stuff/obj02.png")
  objection_se = "Audio/SE/obj.wav"
  if @resolving_battler == nil
    fail = true
  end
  if @resolving_battler.is_a?(Game_Actor)
    fail = true
  end
  if @resolving_skill == nil
    fail = true
  end
  if @resolving_skill == $data_skills[70]
    fail = true
  end
  if fail
    $game_system.se_play($data_system.buzzer_se)
    $game_temp.battle_message_text.push(failed_objection)
    ex_mod = 20 * a.exertion / 100
    ex_mod.round
    a.fatigue -= 20
    a.fatigue -= ex_mod
    a.exertion += 100
    a.exertion += a.ex_cost_up
    return
  end
  int1 = a.int.to_f
  int2 = @resolving_battler.int.to_f
  success_prob = 60
  success_prob *= (int1 / int2)
  success_prob = Integer(success_prob)
  dice = rand(100)
  skill = @resolving_skill
  if skill.element_set.include?(1)
    element_count += 1
    element_red += 210
    element_green += 74
    element_blue += 0
  end
  if skill.element_set.include?(2)
    element_count += 1
    element_red += 214
    element_green += 148
    element_blue += 70
  end
  if skill.element_set.include?(3)
    element_count += 1
    element_red += 74
    element_green += 49
    element_blue += 189
  end
  if skill.element_set.include?(4)
    element_count += 1
    element_red += 58
    element_green += 214
    element_blue += 255
  end
  if skill.element_set.include?(5)
    element_count += 1
    element_red += 95
    element_green += 214
    element_blue += 169
  end
  if skill.element_set.include?(6)
    element_count += 1
    element_red += 132
    element_green += 110
    element_blue += 16
  end
  if skill.element_set.include?(7)
    element_count += 1
    element_red += 218
    element_green += 226
    element_blue += 53
  end
  if skill.element_set.include?(8)
    element_count += 1
    element_red += 33
    element_green += 33
    element_blue += 78
  end
  if skill.element_set.include?(9)
    element_count += 1
    element_red += 226
    element_green += 75
    element_blue += 173
  end
  if skill.element_set.include?(10)
    element_count += 1
    element_red += 255
    element_green += 255
    element_blue += 206
  end
  if element_count > 0
    red = element_red / element_count
    green = element_green / element_count
    blue = element_blue / element_count
    flash_color = Color.new(red, green, blue, 255)
  else
    flash_color = Color.new(133, 133, 133, 255)
  end
  variance = skill.sp_cost / 5
  v = rand(variance) + rand(variance) + 1
  cost = skill.sp_cost - variance + v
  if cost < 20
    cost = 20
  end
  if dice < success_prob
    @objection_sprite.bitmap = sustained
    for actor in $game_party.actors
      actor.animation_id = BLANK_ANIMATION_ID
    end
    for enemy in $game_troop.enemies
      enemy.animation_id = BLANK_ANIMATION_ID
    end
    $game_system.se_stop
    objection_skill_effect(skill)
    @resolving_battler.damage_pop = true
    resolve_end
  end
  if dice >= success_prob
    @objection_sprite.bitmap = overruled
  end
  Audio.se_play(objection_se, 100, 100)
  $game_screen.start_flash(flash_color, 10)
  @effect_window.effect = "Objection"
  @effect_window.visible = true
  @objection_sprite.visible = true
  @objection_sprite_visibility_count = 60
  @resolve_delay = 20
  ex_mod = cost * a.exertion / 100
  ex_mod.round
  a.fatigue -= cost
  a.fatigue -= ex_mod
  a.exertion += 100
  a.exertion += a.ex_cost_up
end
# -----------------------
def objection_skill_effect(skill)
  $game_temp.skill_hit = false
  @show_guard = true
  element_immune_hp = false
  element_immune_ft = false
  element_immune_ex = false
  if skill.scope >= 3
    if skill.scope <= 7
      return false
    end
  end
  effective = false
  power = skill.power + @resolving_battler.atk * skill.atk_f / 100
  ftpower = skill.ft_power
  expower = skill.ex_power
  if power > 0
    power -= @resolving_battler.pdef * skill.pdef_f / 200
    power -= @resolving_battler.mdef * skill.mdef_f / 200
    power = [power, 0].max
  end
  rate = 40
  rate += (@resolving_battler.str * skill.str_f / 100)
  rate += (@resolving_battler.dex * skill.dex_f / 100)
  rate += (@resolving_battler.agi * skill.agi_f / 100)
  rate += (@resolving_battler.int * skill.int_f / 100)
  @resolving_battler.damage = power * rate / 40
  if @resolving_battler.damage == 0
    return false
  end
  x = @resolving_battler.elements_correct(skill.element_set, true)
  @resolving_battler.damage *= x
  @resolving_battler.damage /= 100
  if @resolving_battler.damage == 0
    element_immune_hp = true
  end
  @resolving_battler.fatigue_damage = ftpower / 2
  x = @resolving_battler.elements_correct(skill.element_set, true)
  @resolving_battler.fatigue_damage *= x
  @resolving_battler.fatigue_damage /= 100
  if @resolving_battler.fatigue_damage == 0
    element_immune_ft = true
  end
  if skill.ft_power == 0
    element_immune_ft = true
  end
  @resolving_battler.exertion_damage = expower / 2
  x = @resolving_battler.elements_correct(skill.element_set, true)
  @resolving_battler.exertion_damage *= x
  @resolving_battler.exertion_damage /= 100
  if @resolving_battler.exertion_damage == 0
    element_immune_ex = true
  end
  if skill.ex_power == 0
    element_immune_ex = true
  end
  if skill.variance > 0 and @resolving_battler.damage.abs > 0
    amp = [@resolving_battler.damage.abs * skill.variance / 100, 1].max
    @resolving_battler.damage += rand(amp+1) + rand(amp+1) - amp
  end
  if skill.variance > 0 and @resolving_battler.fatigue_damage.abs > 0
    amp = [@resolving_battler.fatigue_damage.abs * skill.variance / 100, 1].max
    @resolving_battler.fatigue_damage += rand(amp+1) + rand(amp+1) - amp
  end
  if skill.variance > 0 and @resolving_battler.exertion_damage.abs > 0
    amp = [@resolving_battler.exertion_damage.abs * skill.variance / 100, 1].max
    @resolving_battler.exertion_damage += rand(amp+1) + rand(amp+1) - amp
  end
  $game_temp.skill_hit = true
  null_states = false
  @resolving_battler.process_hp_shield
  if @resolving_battler.invincible
    null_states = true
    $game_temp.skill_hit = false
  end
  last_hp = @resolving_battler.hp
  last_ft = @resolving_battler.fatigue
  last_ex = @resolving_battler.exertion
  @resolving_battler.overkill
  @resolving_battler.guts
  unless @guts_flag
    @resolving_battler.hp -= @resolving_battler.damage
  end
  @resolving_battler.fatigue -= @resolving_battler.fatigue_damage
  @resolving_battler.exertion += @resolving_battler.exertion_damage
  $game_temp.general_damage_hook = @resolving_battler.damage
  effective |= @resolving_battler.hp != last_hp
  effective |= @resolving_battler.fatigue != last_ft
  effective |= @resolving_battler.exertion != last_ex
  unless null_states
    effective |= @resolving_battler.states_plus(skill.plus_state_set)
    effective |= @resolving_battler.states_minus(skill.minus_state_set)
  end
  @resolving_battler.determine_supplementary_damage_display(skill)
  return effective
end
# -----------------------
end