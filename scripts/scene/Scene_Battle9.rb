class Scene_Battle
# -----------------------
def escape_effect?(value)
  if @escape_effects.include?(value)
    return true
  else
    return false
  end
end
# -----------------------
def scan(battler)
  if battler.is_a?(Game_Enemy)
    $game_system.scan_percentages[battler.id] += rand(11) + 10
    $game_system.scan_percentages[battler.id] += 10
    if $game_system.scan_percentages[battler.id] >= 100
      if not $game_extras.monster_info.include?(battler.id)
        $game_extras.monster_info.push(battler.id)
        text = battler.name + " was added to Advocate's Microcosm!"
        $game_temp.battle_message_text.push(text)
      end
      $game_system.scan_percentages[battler.id] = 100
    end
  end
  @scan_window = Window_Scan.new(battler)
end
# -----------------------
def sealed_action_recovery
  for actor in $game_party.actors
    if actor.sealed_actions.size > 0
      r = rand(1000)
      if r == 0
        s = actor.sealed_actions.shift
        actor.damage = "Seal Recover!"
        actor.damage_pop = true
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy.sealed_actions.size > 0
      r = rand(1000)
      if r == 0
        s = enemy.sealed_actions.shift
        enemy.damage = "Seal Recover!"
        enemy.damage_pop = true
      end
    end
  end
end
# -----------------------
def summon
  @summon_primary_party = []
  for i in 0..$game_party.actors.size - 1
    if $game_party.actors[i] != nil
      @summon_primary_party[i] = $game_party.actors[i].id
    else
      @summon_primary_party[i] = 0
    end
  end
  eligible_enemies = $game_system.defeated_enemies
  eligible_enemies = eligible_enemies.uniq
  eligible_enemies.delete(1)
  eligible_enemies.delete(2)
  eligible_enemies.delete(3)
  eligible_enemies.delete(5)
  eligible_enemies.delete(6)
  eligible_enemies.delete(7)
  eligible_enemies.delete(17)
  eligible_enemies.delete(19)
  eligible_enemies.delete(20)
  eligible_enemies.delete(21)
  eligible_enemies.delete(22)
  eligible_enemies.delete(23)
  eligible_enemies.delete(24)
  container = $game_actors[13]
  if eligible_enemies.size > 0
    enemy = $data_enemies[eligible_enemies[rand(eligible_enemies.size)]]
    $game_system.summon_monster_id = enemy.id
  else
    print("Summoning Error.")
    return
  end
  container.name = enemy.name
  container.battler_name = enemy.battler_name
  container.battler_hue = 360
  container.class_id = 9
  container.level = 1
  container.exp = 0
  container.summon_actor = true
  attack_flag = false
  skill_flag = false
  defend_flag = false
  for i in 1..$data_skills.size - 1
    container.forget_skill(i)
  end
  for action in enemy.actions
    if action.kind == 0
      if action.basic == 0
        attack_flag = true
      end
      if action.basic == 1
        defend_flag = true
      end
    end
    if action.kind == 1
      s = action.skill_id
      container.learn_skill(s)
      skill_flag = true
    end
  end
  container.battle_commands = []
  if attack_flag
    container.battle_commands.push("Attack")
  end
  if skill_flag
    container.battle_commands.push("Technique")
  end
  if defend_flag
    container.battle_commands.push("Defend")
  end
  summon_unusable_skills
  container.battle_commands.push("Withdraw")
  container.fatigue = 0
  container.exertion = 0
  container.energy = 100
  for i in 1..99
    $data_actors[13].parameters[0, i] = enemy.maxhp
    $data_actors[13].parameters[2, i] = enemy.str
    $data_actors[13].parameters[3, i] = enemy.dex
    $data_actors[13].parameters[4, i] = enemy.agi
    $data_actors[13].parameters[5, i] = enemy.int
  end
  for i in 1..$data_system.elements.size - 1
    $data_classes[9].element_ranks[i] = enemy.element_ranks[i]
  end
  for i in 1..$data_states.size - 1
    $data_classes[9].state_ranks[i] = enemy.state_ranks[i]
  end
  container.hp = container.maxhp
  for i in 1..999
    if $game_actors[i] == nil
      break
    end
    $game_party.remove_actor(i)
  end
  $game_party.add_actor(13)
  $game_party.actors[0].animation_id = SUMMON_ANIMATION_ID
  an_flag = false
  if container.name[0] == 65
    an_flag = true
  end
  if container.name[0] == 69
    an_flag = true
  end
  if container.name[0] == 73
    an_flag = true
  end
  if container.name[0] == 79
    an_flag = true
  end
  if container.name[0] == 85
    an_flag = true
  end
  if an_flag
    summon_message = "Constructed the genome of an " + container.name + "!"
  else
    summon_message = "Constructed the genome of a " + container.name + "!"
  end
  $game_temp.battle_message_text.push(summon_message)
  setup_actor_command_windows
end
# -----------------------
def return_primary_party
  $game_party.remove_actor(13)
  for i in 0..@summon_primary_party.size - 1
    $game_party.add_actor(@summon_primary_party[i])
  end
  setup_actor_command_windows
  phase2_end
  @spriteset = Spriteset_Battle.new
  @spriteset.update
  @status_window.refresh
end
# -----------------------
def resolving_battler_summon?
  return @summon_resolving
end
# -----------------------
def summon_unusable_skills
  container = $game_actors[13]
  container.forget_skill(44)
  container.forget_skill(47)
  container.forget_skill(48)
  container.forget_skill(62)
  container.forget_skill(63)
  container.forget_skill(97)
end
# -----------------------
def remove_damage
  for actor in $game_party.actors
    if actor.damage == 0
      if actor.fatigue_damage == nil
        if actor.exertion_damage == nil
          if actor.energy_damage == nil
            clear_damage(actor)
          end
        end
      end
    end
  end
  for enemy in $game_troop.enemies
    if enemy.damage == 0
      if enemy.fatigue_damage == nil
        if enemy.exertion_damage == nil
          if enemy.energy_damage == nil
            clear_damage(actor)
          end
        end
      end
    end
  end
end
# -----------------------
def show_auto_abilities
  if @activated_auto_abilities.size > 0
    @auto_window = Window_SkillTrigger.new(@activated_auto_abilities)
  end
  @activated_auto_abilities = []
end
# -----------------------
def auto_abilities_general
  if $game_actors[8].equipped_auto_abilities.include?(85)
    if $game_actors[8].hp < $game_actors[8].maxhp / 4
      if $game_actors[8].fatigue < 0
        @activated_auto_abilities.push(85)
        $game_actors[8].fatigue += 100
        $game_actors[8].fatigue_damage = -100
        $game_actors[8].damage_pop = true
      end
    end
  end
  show_auto_abilities
end
# -----------------------
def auto_abilities_hit
  flag = false
  t = @target_battlers
  for battler in t
    if battler.is_a?(Game_Actor)
      if battler.leukocite >= 1
        flag = true
        @activated_auto_abilities.push(118)
      end
      unless battler.dead?
        if battler.equipped_auto_abilities.include?(121)
          if battler.hp <= 40
            if battler.auto_item_delay <= 0
              if $game_party.item_number(1) >= 1
                flag = true
                force(battler, 3, battler.index, 1, 1, -1)
                battler.auto_item_delay = 600
                @activated_auto_abilities.push(121)
              end
            end
          end
        end
      end
    end
  end
  show_auto_abilities
  return flag
end
# -----------------------
def auto_abilities_action
  r = @resolving_battler
  if r.is_a?(Game_Actor)
    x = 1
  end
end
# -----------------------
def auto_abilities_attack
  r = @resolving_battler
  if r.is_a?(Game_Actor)
    x = 1
  end
end
# -----------------------
def auto_abilities_shaping
  r = @resolving_battler
  if r.is_a?(Game_Actor)
    x = 1
  end
end
# -----------------------
def auto_abilities_item
  r = @resolving_battler
  if r.is_a?(Game_Actor)
    x = 1
  end
end
# -----------------------
def deciduous_woodbranch
  for actor in $game_party.actors
    e = false
    if actor.armor1_id == 23
      e = true
    end
    if actor.armor2_id == 23
      e = true
    end
    if actor.armor3_id == 23
      e = true
    end
    if actor.armor4_id == 23
      e = true
    end
    if e
      if actor.fatigue >= 1
        if woodbranch_eligible?(actor)
          x = 15
          while x >= 15
            x = rand(actor.states.size)
          end
          s = actor.states[x]
          n = $data_states[s].name
          chance = actor.fatigue
          random = rand(25000) + 1
          if random <= chance
            actor.remove_state(s)
            actor.damage = n + "Recover!"
            actor.damage_pop = true
          end
        end
      end
    end
  end
end
# -----------------------
def coordinate
  @effect_window.effect = "Coordinate"
  @effect_window.visible = true
  hostages_attacking = []
  if $game_switches[195]
    hostages_attacking.push($game_troop.enemies[1])
  end
  if $game_switches[196]
    hostages_attacking.push($game_troop.enemies[2])
  end
  if $game_switches[197]
    hostages_attacking.push($game_troop.enemies[3])
  end
  if $game_switches[198]
    hostages_attacking.push($game_troop.enemies[4])
  end
  if hostages_attacking.size >= 1
    $game_temp.hostage_attack = true
  end
  for battler in hostages_attacking
    force(battler, 1, -11, false, -1, -1)
  end
  if hostages_attacking == []
    @no_coordinate = true
  end
  $game_switches[195] = false
  $game_switches[196] = false
  $game_switches[197] = false
  $game_switches[198] = false
  @resolve_delay = 20
  @resolve_act = 12
  @resolve_step = 4
end
# -----------------------
def hostage_attack
  if $game_temp.hostage_attack
    if $game_temp.guard_breaker
      if $game_troop.enemies[0].state?(58)
        hp = $game_troop.enemies[0].hp
        maxhp = $game_troop.enemies[0].maxhp
        maxhp /= 4
        e = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        guard_break_se = "Audio/SE/seaked.wav"
        Audio.se_play(guard_break_se, 100, 100)
        s = "Ettore's shield was neutralized!"
        unless hp < maxhp
          $game_temp.battle_message_text.push(s)
        end
        $game_temp.guard_breaker = false
        $game_temp.hostage_attack = false
        $game_troop.enemies[0].remove_state(58)
        $game_troop.enemies[0].element_guard_percent = e
        $game_switches[194] = true
      else
        s = "The hostage's attack was mistimed!"
        $game_temp.battle_message_text.push(s)
        $game_temp.guard_breaker = false
        $game_temp.hostage_attack = false
      end
    end
  end
end
# -----------------------
def intervene
  mflag = 0
  if @resolving_battler == $game_troop.enemies[0]
    mflag = 1
    if @resolving_battler.current_action.type == 1
      mflag = 2
      if @resolving_battler.current_action.target_index <= -11
        mflag = 3
        @effect_window.effect = "Intervene"
        @effect_window.visible = true
        @target_battlers = [$game_party.actors[1]]
        $game_troop.enemies[1].animation_id = BLANK_ANIMATION_ID
        $game_troop.enemies[2].animation_id = BLANK_ANIMATION_ID
        $game_troop.enemies[3].animation_id = BLANK_ANIMATION_ID
        $game_troop.enemies[4].animation_id = BLANK_ANIMATION_ID
        $game_party.actors[1].animation_id = 184
      end
    end
  end
  if mflag == 0
    if @resolving_battler == nil
      s = "No action is resolving."
      $game_temp.battle_message_text.push(s)
    else
      s = "Cannot intervene in this action."
      $game_temp.battle_message_text.push(s)
    end
  end
  if mflag == 1
    s = "Cannot intervene in this action."
    $game_temp.battle_message_text.push(s)
  end
  if mflag == 2
    s = "Can only intervene in attacks against the hostages."
    $game_temp.battle_message_text.push(s)
  end
  ex = $game_party.actors[1].exertion.to_f
  ex /= 100
  ft = 40
  total = ft * ex
  total = Integer(total)
  $game_party.actors[1].fatigue -= total
  $game_party.actors[1].exertion += 100
end
# -----------------------
def transfer_character_stats(actor_id, enemy_id, attack, defend, escape)
  count = 0
  class_id = $game_actors[actor_id].class_id
  $data_enemies[enemy_id].maxhp = $game_actors[actor_id].maxhp
  $data_enemies[enemy_id].str = $game_actors[actor_id].str
  $data_enemies[enemy_id].dex = $game_actors[actor_id].dex
  $data_enemies[enemy_id].agi = $game_actors[actor_id].agi
  $data_enemies[enemy_id].int = $game_actors[actor_id].int
  $data_enemies[enemy_id].atk = $game_actors[actor_id].atk
  $data_enemies[enemy_id].pdef = $game_actors[actor_id].pdef
  $data_enemies[enemy_id].mdef = $game_actors[actor_id].mdef
  $data_enemies[enemy_id].eva = $game_actors[actor_id].eva
  $data_enemies[enemy_id].element_ranks = $data_classes[class_id].element_ranks
  $data_enemies[enemy_id].state_ranks = $data_classes[class_id].state_ranks
  $data_enemies[enemy_id].animation1_id = $game_actors[actor_id].animation1_id
  $data_enemies[enemy_id].animation2_id = $game_actors[actor_id].animation2_id
  $data_enemies[enemy_id].actions = []
  if attack > 0
    a = RPG::Enemy::Action.new
    a.kind = 0
    a.basic = 0
    a.skill_id = 1
    a.condition_turn_a = 0
    a.condition_turn_b = 1
    a.condition_hp = 100
    a.condition_level = 0
    a.condition_switch_id = 0
    a.rating = attack
    $data_enemies[enemy_id].actions[count] = a
    count += 1
  end
  if defend > 0
    a = RPG::Enemy::Action.new
    a.kind = 0
    a.basic = 1
    a.skill_id = 1
    a.condition_turn_a = 0
    a.condition_turn_b = 1
    a.condition_hp = 100
    a.condition_level = 0
    a.condition_switch_id = 0
    a.rating = defend
    $data_enemies[enemy_id].actions[count] = a
    count += 1
  end
  if escape > 0
    a = RPG::Enemy::Action.new
    a.kind = 0
    a.basic = 2
    a.skill_id = 1
    a.condition_turn_a = 0
    a.condition_turn_b = 1
    a.condition_hp = 100
    a.condition_level = 0
    a.condition_switch_id = 0
    a.rating = escape
    $data_enemies[enemy_id].actions[count] = a
    count += 1
  end
  for i in 1..$data_skills.size - 1
    if $game_actors[actor_id].skill_learn?(i)
      if $data_skills[i].occasion <= 2
        a = RPG::Enemy::Action.new
        a.kind = 1
        a.basic = 0
        a.skill_id = i
        a.condition_turn_a = 0
        a.condition_turn_b = 1
        a.condition_hp = 100
        a.condition_level = 0
        a.condition_switch_id = 0
        a.rating = 5
        $data_enemies[enemy_id].actions[count] = a
        count += 1
      end
    end
  end
end
# -----------------------
def kill_actin
  for actor in $game_party.actors
    t = actor.name + "'s Actin Depolymerization effect dissipated."
    a = actor.state?(59)
    b = actor.state?(60)
    c = actor.state?(61)
    d = actor.state?(62)
    e = actor.state?(63)
    f = actor.state?(64)
    if actor.fatigue >= 0
      if a or b or c or d or e or f
        actor.remove_state(59)
        actor.remove_state(60)
        actor.remove_state(61)
        actor.remove_state(62)
        actor.remove_state(63)
        actor.remove_state(64)
        $game_temp.battle_message_text.push(t)
      end
    end
  end
  for enemy in $game_troop.enemies
    t = enemy.name + "'s Actin Depolymerization effect dissipated."
    a = enemy.state?(59)
    b = enemy.state?(60)
    c = enemy.state?(61)
    d = enemy.state?(62)
    e = enemy.state?(63)
    f = enemy.state?(64)
    if enemy.fatigue >= 0
      if a or b or c or d or e or f
        enemy.remove_state(59)
        enemy.remove_state(60)
        enemy.remove_state(61)
        enemy.remove_state(62)
        enemy.remove_state(63)
        enemy.remove_state(64)
        $game_temp.battle_message_text.push(t)
      end
    end
  end
end
# -----------------------
def hibernation
  for actor in $game_party.actors
    flag = false
    e = false
    if actor.armor1_id == 26
      e = true
    end
    if actor.armor2_id == 26
      e = true
    end
    if actor.armor3_id == 26
      e = true
    end
    if actor.armor4_id == 26
      e = true
    end
    if e
      if actor.state?(14) or actor.fatigue <= -100
        actor.hibernation_level += 0.01
        flag = true
      end
    end
    unless flag
      if actor.hibernation_level > 0
        actor.hibernation_level -= 0.01
      end
    end
  end
end
# -----------------------
def auto_recast(skill_id, percentage, percentage_type)
  percentage = 0
  if $game_temp.echo_target_battlers.size == 1
    t = $game_temp.echo_target_battlers[0].index
  else
    t = 0
  end
  battler = $game_temp.echo_resolving_battler
  if percentage_type == 1
    h = battler.hp
    m = battler.maxhp
    hp_percent = h
    hp_percent *= 100
    hp_percent /= m
    hp_percent = Integer(hp_percent)
    if hp_percent < 25
      percentage = (25 - hp_percent) * 2
    end
  end
  if rand(100) < percentage
    @effect_window.effect = "Auto-Recast"
    @effect_window.visible = true
    @wait_count = 20
    a = Game_ForcedAction.new(2, t, true, skill_id, -1)
    battler.forced_actions.push(a)
    $game_temp.forcing_battler.push(battler)
  end
end
# -----------------------
def get_echo
  result = nil
  s = $game_party.actors.size - 1
  for i in 0..s
    if @echo_resolving_battler.name == $game_party.actors[i].name
      result = $game_party.actors[i]
    end
  end
  s = $game_troop.enemies.size - 1
  for i in 0..s
    if @echo_resolving_battler.index == $game_troop.enemies[i].index
      result = $game_troop.enemies[i]
    end
  end
  return result
end
# -----------------------
def max_priority(battlers)
  result = 0
  for battler in battlers
    if battler.action_priority > result
      result = battler.action_priority
    end
  end
  return result
end
# -----------------------
def galvanize_effect
  if @resolving_battler.is_a?(Game_Enemy)
    for actor in $game_party.actors
      if actor.exist?
        if actor.galvanized
          actor.fatigue += 5
          actor.exertion -= 20
          actor.fatigue_damage = -5
          actor.exertion_damage = -20
          actor.damage_pop = true
        end
      else
        actor.galvanized = false
      end
    end
  end
  if @resolving_battler.is_a?(Game_Actor)
    for enemy in $game_troop.enemies
      if enemy.exist?
        if enemy.galvanized
          enemy.fatigue += 5
          enemy.exertion -= 20
          enemy.fatigue_damage = -5
          enemy.exertion_damage = -20
          enemy.damage_pop = true
        end
      else
        enemy.galvanized = false
      end
    end
  end
end
# -----------------------
def clear_forced_actions
  $game_temp.forcing_battler = []
  for actor in $game_party.actors
    actor.forced_actions = []
  end
end
# -----------------------
def woodbranch_eligible?(battler)
  result = false
  for s in battler.states
    if s >= 2
      if s <= 14
        result = true
      end
    end
  end
  return result
end
# -----------------------
def devillify
  for actor in $game_party.actors
    actor.villify = -1
  end
end
# -----------------------
def villifed_actor
  result = 0
  for actor in $game_party.actors
    if actor.villify >= 1
      result = actor.index
    end
  end
  return result
end
# -----------------------
end