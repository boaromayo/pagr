class Game_Schizo
# -----------------------
attr_accessor :seretonin
attr_accessor :dopamine
attr_accessor :norepinephrine
attr_accessor :aspartate
attr_accessor :seretonin_max
attr_accessor :dopamine_max
attr_accessor :norepinephrine_max
attr_accessor :aspartate_max
attr_accessor :conditionals
attr_accessor :max_synapse
attr_accessor :max_combo
attr_accessor :victory_floor
attr_accessor :special_effects
attr_accessor :points
attr_accessor :ft_cost_reduction
attr_accessor :ex_cost_reduction
attr_accessor :effect_bonus
attr_accessor :new_scope
attr_accessor :doublecast
attr_accessor :barrage
attr_accessor :ft_tag
attr_accessor :hp_full
attr_accessor :ft_full
attr_accessor :status_strike
attr_accessor :comorbidity
attr_accessor :faint_flag
attr_accessor :system_shock
attr_accessor :idle_frames
attr_accessor :low_ft
attr_reader   :names
attr_reader   :synapses_min
attr_reader   :synapses_max
# -----------------------
def initialize
  @actor = $game_actors[9]
  @seretonin = 0
  @dopamine = 0
  @norepinephrine = 0
  @aspartate = 0
  @seretonin_max = 0
  @dopamine_max = 0
  @norepinephrine_max = 0
  @aspartate_max = 0
  @max_combo = 0
  @max_synapse = 0
  @skill_type = 0
  @victory_floor = 0
  @points = 0
  @new_points = 0
  @chain_points = 0
  @ft_cost_reduction = 0
  @ex_cost_reduction = 0
  @effect_bonus = 1
  @new_scope = -1
  @chain_number = 0
  @idle_frames = 0
  @low_ft = 0
  @doublecast = false
  @barrage = false
  @ft_tag = false
  @hp_full = false
  @chain = false
  @status_strike = false
  @comorbility = false
  @ft_full = false
  @ignore_chain = false
  @faint_flag = false
  @system_shock = false
  @conditionals = []
  @names = []
  @requirements = []
  @synapses_min = []
  @synapses_max = []
  @special_effects = []
  @bonus = []
  set_names
  set_synapses
  set_skill_requirements
  victory_floor
end
# -----------------------
def set_names
  @names[0] = "HP less than 25%"
  @names[1] = "FT less than 0"
  @names[2] = "EX 50%"
  @names[3] = "EX 150%"
  @names[4] = "Faint Flag"
  @names[5] = "Status Ailment Present"
  @names[6] = "Four Ailments Present"
  @names[7] = "Recent HP Recovery"
  @names[8] = "Recent FT Recovery"
  @names[9] = "Recent EX Recovery"
  @names[10] = "Revived Recently"
  @names[11] = "System Shock"
  @names[12] = "Idle"
  @names[13] = "Last Resort"
  @names[14] = "Crowd"
  @names[15] = "No Damage"
end
# -----------------------
def reset
  @actor = $game_actors[9]
end
# -----------------------
def schizo_actor?
  actor = $game_actors[9]
  return actor
end
# -----------------------
def set_skill_requirements
  @requirements[0] = [485, 0, 0, 0, 60]
  @requirements[1] = [0, 410, 0, 0, 33]
  @requirements[2] = [0, 0, 370, 0, 59]
  @requirements[3] = [0, 0, 0, 350, 34]
  @requirements[4] = [1740, 0, 0, 0, 119]
  @requirements[5] = [0, 1235, 0, 0, 118]
  @requirements[6] = [0, 0, 1920, 0, 116]
  @requirements[7] = [0, 0, 0, 1360, 117]
end
# -----------------------
def set_synapses
  @synapses_min[0] = 4
  @synapses_max[0] = 12
  @synapses_min[1] = 4
  @synapses_max[1] = 10
  @synapses_min[2] = 8
  @synapses_max[2] = 16
  @synapses_min[3] = 24
  @synapses_max[3] = 48
  @synapses_min[4] = 0
  @synapses_max[4] = 999
  @synapses_min[5] = 4
  @synapses_max[5] = 12
  @synapses_min[6] = 16
  @synapses_max[6] = 32
  @synapses_min[7] = 6
  @synapses_max[7] = 15
  @synapses_min[8] = 10
  @synapses_max[8] = 20
  @synapses_min[9] = 16
  @synapses_max[9] = 32
  @synapses_min[10] = 32
  @synapses_max[10] = 64
  @synapses_min[11] = 10
  @synapses_max[11] = 20
  @synapses_min[12] = 8
  @synapses_max[12] = 16
  @synapses_min[13] = 64
  @synapses_max[13] = 64
  @synapses_min[14] = 16
  @synapses_max[14] = 128
  @synapses_min[15] = 8
  @synapses_max[15] = 16
end
# -----------------------
def victory_floor
  if @actor.level >= 1
    if @actor.level <= 5
      @victory_floor = 12
    end
  end
  if @actor.level >= 6
    if @actor.level <= 8
      @victory_floor = 20
    end
  end
  if @actor.level >= 9
    if @actor.level <= 12
      @victory_floor = 26
    end
  end
end
# -----------------------
def check_learned
  learned = []
  for requirement in @requirements
    if @seretonin >= requirement[0]
      if @dopamine >= requirement[1]
        if @norepinephrine >= requirement[2]
          if @aspartate >= requirement[3]
            skill = requirement[4]
            if not @actor.skill_learn?(skill)
              learned.push(skill)
              @actor.learn_skill(skill)
             end
          end
        end
      end
    end
  end
  return learned
end
# -----------------------
def check_combo
  synapse_total = 0
  combo = 0
  @bonus = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  if @conditionals.include?(0)
    if @actor.hp < @actor.maxhp / 4
      random_range = rand(@synapses_max[0] - @synapses_min[0] + 1)
      synapse_total += random_range + synapses_min[0]
      combo += 1
    end
  end
  if @conditionals.include?(1)
    if @actor.fatigue <= -1
      random_range = rand(@synapses_max[1] - @synapses_min[1] + 1)
      synapse_total += random_range + @synapses_min[1]
      @bonus[0] += 1
      combo += 1
    end
  end
  if @conditionals.include?(2)
    if @actor.exertion >= 50
      random_range = rand(@synapses_max[2] - @synapses_min[2] + 1)
      synapse_total += random_range + @synapses_min[2]
      @bonus[1] += 1
      combo += 1
    end
  end
  if @conditionals.include?(3)
    if @actor.exertion >= 150
      random_range = rand(@synapses_max[3] - @synapses_min[3] + 1)
      synapse_total += random_range + @synapses_min[3]
      @bonus[1] += 1
      combo += 1
    end
  end
  if @conditionals.include?(4)
    if @faint_flag
      @synapses_min[4] = ((@low_ft + 100) / 2).abs
      @synapses_max[4] = (@low_ft + 100).abs
      random_range = rand(@synapses_max[4] - @synapses_min[4] + 1)
      synapse_total += random_range + @synapses_min[4]
      @synapses_min[4] = 0
      @synapses_max[4] = 999
      combo += 1
      @low_ft = 0
      @faint_flag = false
    end
  end
  if @conditionals.include?(5)
    num_states = 0
    for i in 2..14
      if @actor.state?(i)
        num_states += 1
      end
    end
    if num_states >= 1
      random_range = rand(@synapses_max[5] - @synapses_min[5] + 1)
      synapse_total += random_range + @synapses_min[5]
      @bonus[2] += 1
      combo += 1
    end
  end
  if @conditionals.include?(6)
    num_states = 0
    for i in 2..14
      if @actor.state?(i)
        num_states += 4
      end
    end
    if num_states >= 4
      random_range = rand(@synapses_max[6] - @synapses_min[6] + 1)
      synapse_total += random_range + @synapses_min[6]
      @bonus[2] += 2
      combo += 1
    end
  end
  if @conditionals.include?(7)
    if @actor.recent_hp > 0
      random_range = rand(@synapses_max[7] - @synapses_min[7] + 1)
      synapse_total += random_range + @synapses_min[7]
      @bonus[3] += 1
      combo += 1
    end
  end
  if @conditionals.include?(8)
    if @actor.recent_ft > 0
      random_range = rand(@synapses_max[8] - @synapses_min[8] + 1)
      synapse_total += random_range + @synapses_min[8]
      @bonus[4] += 1
      combo += 1
    end
  end
  if @conditionals.include?(9)
    if @actor.recent_ex > 0
      random_range = rand(@synapses_max[9] - @synapses_min[9] + 1)
      synapse_total += random_range + @synapses_min[9]
      @bonus[1] += 1
      combo += 1
    end
  end
  if @conditionals.include?(10)
    if @actor.recent_ex > 0
      random_range = rand(@synapses_max[10] - @synapses_min[10] + 1)
      synapse_total += random_range + @synapses_min[10]
      combo += 1
    end
  end
  if @conditionals.include?(11)
    if @system_shock
      random_range = rand(@synapses_max[11] - @synapses_min[11] + 1)
      synapse_total += random_range + @synapses_min[11]
      combo += 1
      @bonus[5] += 1
      @system_shock = false
    end
  end
  if @conditionals.include?(12)
    if @idle_frames >= 600
      random_range = rand(@synapses_max[12] - @synapses_min[12] + 1)
      synapse_total += random_range + @synapses_min[12]
      combo += 1
      @bonus[6] += 1
      @idle_frames = 0
    end
  end
  if @conditionals.include?(13)
    dead_flag = true
    for actor in $game_party.actors
      if actor.hp >= 1
        unless actor == @actor
          dead_flag = false
        end
      end
    end
    if dead_flag
      random_range = rand(@synapses_max[13] - @synapses_min[13] + 1)
      synapse_total += random_range + @synapses_min[13]
      @bonus[7] += 1
      combo += 1
    end
  end
  if @conditionals.include?(14)
    if $game_troop.enemies.size > 4
      min_syn = ($game_troop.enemies.size - 4) * 16
      max_syn = ($game_troop.enemies.size - 4) * 32
      @synapses_min[14] = min_syn
      @synapses_max[14] = max_syn
      random_range = rand(@synapses_max[14] - @synapses_min[14] + 1)
      @synapses_min[14] = 16
      @synapses_max[14] = 128
      synapse_total += random_range + synapses_min[14]
      @bonus[8] += 1
      combo += 1
    end
  end
  if @conditionals.include?(15)
    if @actor.damage_count >= 600
      random_range = rand(@synapses_max[15] - @synapses_min[15] + 1)
      synapse_total += random_range + synapses_min[15]
      combo += 1
      @actor.damage_count = 0
    end
  end
  @points = synapse_total
  @new_points = synapse_total
  if @doublecast
    @points = 0
    @new_points = 0
  end
  if combo < 2
    combo = 0
    @points = 0
    @new_points = 0
  end
  if @chain
    @points += @chain_points
  end
  if combo > @max_combo
    @max_combo = combo
  end
  if synapse_total > @max_synapse
    @max_synapse = synapse_total
  end
  change_max_points
end
# -----------------------
def determine_special_effects
  @special_effects = []
  remain = @points
  while remain > 0
    flag = false
    random_check = rand(19) + 1
    if random_check == 1
      if rand(remain) >= 15 - (@bonus[0] * 5)
        @special_effects.push(1)
        flag = true
      end
    end
    if random_check == 2
      if rand(remain) >= 30 - (@bonus[0] * 5)
        @special_effects.push(2)
        flag = true
      end
    end
    if random_check == 3
      if rand(remain) >= 10 - (@bonus[1] * 5)
        @special_effects.push(3)
        flag = true
      end
    end
    if random_check == 4
      if rand(remain) >= 25 - (@bonus[1] * 5)
        @special_effects.push(4)
        flag = true
      end
    end
    if random_check == 5
      if rand(remain) >= 20 - (@bonus[8] * 10)
        @special_effects.push(5)
        flag = true
      end
    end
    if random_check == 6
      if rand(remain) >= 30 - (@bonus[7] * 5)
        @special_effects.push(6)
        flag = true
      end
    end
    if random_check == 7
      if rand(remain) >= 60 - (@bonus[7] * 5)
        @special_effects.push(7)
        flag = true
      end
    end
    if random_check == 8
      if rand(remain) >= 30 - (@bonus[5] * 5)
        @special_effects.push(8)
        flag = true
      end
    end
    if random_check == 9
      if rand(remain) >= 15
        @special_effects.push(9)
        flag = true
      end
    end
    if random_check == 10
      if rand(remain) >= 15 - (@bonus[4] * 5)
        @special_effects.push(10)
        flag = true
      end
    end
    if random_check == 11
      if rand(remain) >= 40 - (@bonus[3] * 5)
        @special_effects.push(11)
        flag = true
      end
    end
    if random_check == 12
      if rand(remain) >= 40
        @special_effects.push(12)
        flag = true
      end
    end
    if random_check == 13
      if rand(remain) >= 20 - (@bonus[6] * 5)
        unless @ignore_chain
          @special_effects.push(13)
          flag = true
        end
      end
    end
    if random_check == 14
      if rand(remain) >= 60
        @special_effects.push(14)
        flag = true
      end
    end
    if random_check == 15
      if rand(remain) >= 20
        @special_effects.push(15)
        flag = true
      end
    end
    if random_check == 16
      if rand(remain) >= 20 - (@bonus[2] * 5)
        @special_effects.push(16)
        flag = true
      end
    end
    if random_check == 17
      if rand(remain) >= 120
        @special_effects.push(17)
        flag = true
      end
    end
    if random_check == 18
      if rand(remain) >= 100
        @special_effects.push(18)
        flag = true
      end
    end
    if random_check == 19
      if rand(remain) >= 100
        @special_effects.push(19)
        flag = true
      end
    end
    if random_check == 20
      if rand(remain) >= 100
        @special_effects.push(20)
        flag = true
      end
    end
    if flag
      remain -= 10
    else
      remain -= 1
    end
  end
  @special_effects = @special_effects.uniq
  @special_effects = @special_effects[0..4]
end
# -----------------------
def resolve_effects(skill, targets)
  determine_special_effects
  @ft_cost_reduction = 0
  @ex_cost_reduction = 0
  @effect_bonus = 1
  @new_scope = -1
  @doublecast = false
  @ft_tag = false
  @hp_full = false
  @ft_full = false
  @chain = false
  @status_strike = false
  @ignore_chain = false
  target_allies = false
  target_enemies = false
  single_random_target = false
  target_one_ally = false
  effect_not_zero = skill.power != 0
  a = skill.scope >= 3 
  b = skill.scope <= 7
  c = skill.scope == 9 
  d = skill.scope == 10
  if a
    if b
      target_allies = true
    end
  end
  if c
    target_allies = true
  end
  if d
    target_allies = true
  end
  a = skill.scope == 1
  b = skill.scope == 2
  c = skill.scope == 8 
  d = skill.scope == 11
  if a
    if b
      target_enemies = true
    end
  end
   if c
    target_enemies = true
  end
  if d
    target_enemies = true
  end
  a = skill.scope == 1
  b = skill.scope == 3
  c = skill.scope == 5
  d = skill.scope == 7
  e = skill.scope >= 8
  if a
    single_random_target = true
  end
  if b
    single_random_target = true
  end
  if c
    single_random_target = true
  end
  if d
    single_random_target = true
  end
  if e
    single_random_target = true
  end
  if skill.scope == 3
    target_one_ally = true
  end
  if not target_allies
    @special_effects.delete(9)
  end
  if not target_enemies
    @special_effects.delete(10)
    @special_effects.delete(16)
  end
  if not single_random_target
    @special_effects.delete(5)
  end
  if not target_one_ally
    @special_effects.delete(11)
    @special_effects.delete(12)
  end
  if not effect_not_zero
    @special_effects.delete(6)
    @special_effects.delete(7)
    @special_effects.delete(9)
    @special_effects.delete(10)
    @special_effects.delete(16)
  end
  unless @special_effects.include?(13)
    @chain_number = 0
  end
  if @special_effects.include?(1)
    @ft_cost_reduction = 1
  end
  if @special_effects.include?(2)
    @ft_cost_reduction = 2
  end
  if @special_effects.include?(3)
    @ex_cost_reduction = 1
  end
  if @special_effects.include?(4)
    @ex_cost_reduction = 2
  end
  if @special_effects.include?(5)
    if target_enemies
      @new_scope = 2
    end
    if target_allies
      @new_scope = 4
    end
  end
  if @special_effects.include?(6)
    @effect_bonus = 2
  end
  if @special_effects.include?(7)
    @effect_bonus = 4
  end
  if @special_effects.include?(8)
    @doublecast = true
    @ignore_chain = true
  end
  if @special_effects.include?(9)
    @ft_tag = true
  end
  if @special_effects.include?(10)
    @ft_tag = true
  end
  if @special_effects.include?(11)
    @hp_full = true
  end
  if @special_effects.include?(12)
    @ft_full = true
  end
  if @special_effects.include?(13)
    if @chain_number < 3
      @chain = true
      @chain_points += @new_points
      @chain_number += 1
    else
      @chain = false
      @chain_points = 0
      @chain_number = 0
    end
  end
  if @special_effects.include?(14)
    @doublecast = false
    @barrage = true
    @ignore_chain = true
  end
  if @special_effects.include?(15)
    for i in 1..4
      @skill_type = i
      change_max_points
    end
  end
  if @special_effects.include?(16)
    @status_strike = true
  end
  if @special_effects.include?(17)
    for enemy in $game_troop.enemies
      unless enemy.dead?
        unless enemy.hidden
          enemy.states_plus([1])
        end
      end
    end
  end
  if @special_effects.include?(18)
    for actor in $game_party.actors
      for state in $data_states
        state_id = state.id
        if state_id >= 1
          if state_id <= 14
            actor.remove_state(state_id, true)
          end
        end
      end
      actor.hp += 32767
      actor.damage = -32767
      actor.damage_pop = true
    end
  end
  if @special_effects.include?(19)
    if target_enemies
      @comorbidity = true
    end
  end
  if @special_effects.include?(20)
    @actor.add_state(16)
  end
end
# -----------------------
def determine_skill_type(skill)
  id = skill.id
  @skill_type = 0
  case id
  when 17
    @skill_type = 5
  when 18
    @skill_type = 5
  when 19
    @skill_type = 5
  when 24
    @skill_type = 1
  when 25
    @skill_type = 2
  when 26
    @skill_type = 3
  when 27
    @skill_type = 4
  when 33
    @skill_type = 2
  when 34
    @skill_type = 4
  when 59
    @skill_type = 3
  when 60
    @skill_type = 1
  when 116
    @skill_type = 3
  when 117
    @skill_type = 4
  when 118
    @skill_type = 2
  when 119
    @skill_type = 1
  end
  if @skill_type == 0
    print("Schizo skill type error: Skill No. " + id.to_s)
  end
end
# -----------------------
def change_max_points
  case @skill_type
  when 1
    if @seretonin_max < @points
      @seretonin_max = @points
    end
  when 2
    if @dopamine_max < @points
      @dopamine_max = @points
    end
  when 3
    if @norepinephrine_max < @points
      @norepinephrine_max = @points
    end
  when 4
    if @aspartate_max < @points
      @aspartate_max = @points
    end
  end
end
# -----------------------
def add_points
  victory_floor
  diff = $game_system.battle_difficulty.to_f
  variance = diff * 0.25
  v1 = $game_system.frand(variance * 2.0 + 1.0)
  v2 = $game_system.frand(variance * 2.0 + 1.0)
  v3 = $game_system.frand(variance * 2.0 + 1.0)
  v4 = $game_system.frand(variance * 2.0 + 1.0)
  v1 -= variance
  v2 -= variance
  v3 -= variance
  v4 -= variance
  multiplier1 = ((diff + v1) / 10) + 1
  multiplier2 = ((diff + v2) / 10) + 1
  multiplier3 = ((diff + v3) / 10) + 1
  multiplier4 = ((diff + v4) / 10) + 1
  vf_variance = @victory_floor / 4
  vf1 = @victory_floor - vf_variance + (rand(vf_variance * 2 + 1))
  vf2 = @victory_floor - vf_variance + (rand(vf_variance * 2 + 1))
  vf3 = @victory_floor - vf_variance + (rand(vf_variance * 2 + 1))
  vf4 = @victory_floor - vf_variance + (rand(vf_variance * 2 + 1))
  if $game_party.actors.include?(@actor)
    unless @actor.dead?
      @seretonin += [vf1, @seretonin_max * multiplier1].max
      @dopamine += [vf2, @dopamine_max * multiplier2].max
      @norepinephrine += [vf3, @norepinephrine_max * multiplier3].max
      @aspartate += [vf4, @aspartate_max * multiplier4].max
      @seretonin = Integer(@seretonin)
      @dopamine = Integer(@dopamine)
      @norepinephrine = Integer(@norepinephrine)
      @aspartate = Integer(@aspartate)
    end
  end
end
# -----------------------
def search_requirements(type)
  case type
  when 1
    value = @seretonin
  when 2
    value = @dopamine
  when 3
    value = @norepinephrine
  when 4
    value = @aspartate
  end
  value_needed = 0
  for requirement in @requirements
    if requirement[type - 1] > 0
      temp = requirement[type - 1]
    end
    if type == 1
      if requirement[1] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 2
      if requirement[0] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 3
      if requirement[0] > 0
        temp = 0
      end
      if requirement[1] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 4
      if requirement[0] > 0
        temp = 0
      end
      if requirement[1] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
    end
    if temp > value
      value_needed = temp
      break
    end
  end
  return value_needed
end
# -----------------------
def second_highest(type)
  case type
  when 1
    value = @seretonin
  when 2
    value = @dopamine
  when 3
    value = @norepinephrine
  when 4
    value = @aspartate
  end
  last_value = 9999999
  for requirement in @requirements
    if requirement[type - 1] > 0
      temp = requirement[type - 1]
    end
    if type == 1
      if requirement[1] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 2
      if requirement[0] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 3
      if requirement[0] > 0
        temp = 0
      end
      if requirement[1] > 0
        temp = 0
      end
      if requirement[3] > 0
        temp = 0
      end
    end
    if type == 4
      if requirement[0] > 0
        temp = 0
      end
      if requirement[1] > 0
        temp = 0
      end
      if requirement[2] > 0
        temp = 0
      end
    end
    if temp > 0 and temp < last_value
      unless temp == search_requirements(type)
        last_value = temp
      end
    end
  end
  return last_value
end
# -----------------------
def setup_battle
  @faint_flag = false
  @system_shock = false
  @idle_frames = 0
  @actor.recent_hp = -1
  @actor.recent_ft = -1
  @actor.recent_ex = -1
  @actor.recent_revive = -1
  @actor.damage_count = 0
end
# -----------------------
def set_conditionals
  lv = @actor.level
  @conditionals = [0, 1, 2]
  if lv >= 3
    @conditionals.push(5)
  end
  if lv >= 6
    @conditionals.push(7)
  end
end
# -----------------------
end
