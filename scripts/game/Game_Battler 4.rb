class Game_Battler
# -----------------------
def set_assimilate
  for i in 1..$data_system.elements.size - 1
    @assimilate_data[i] = 0
  end
end
# -----------------------
def update_assimilate(element)
  if @current_action.passive == 2
    @assimilate_data[element] += 1
    if @assimilate_data[element] > 5
      @assimilate_data[element] = 5
    end
  end
end
# -----------------------
def set_recent_recovery_values(last_hp, attack = false)
  unless attack
    if self.damage != nil
      if self.damage < 0 && last_hp == 0
        self.recent_revive = 200
      end
    end
    if self.damage != nil
      if self.damage < 0 && last_hp != 0
        if self.damage != -32767
          self.recent_hp = 800
        end
      end
    end
    if self.fatigue_damage != nil
      if self.fatigue_damage < 0
        if self.fatigue_damage != -32767
          self.recent_ft = 200
        end
      end
    end
    if self.exertion_damage != nil
      if self.exertion_damage < 0
        self.recent_ex = 200
      end
    end
  end
  if self.damage != nil
    if self.damage > 0
      self.damage_count = 0
    end
  end
end
# -----------------------
def determine_supplementary_damage_display(skill_or_item)
  guard = true
  miss = true
  obscure = false
  if @show_guard
    guard = true
    miss = false
    self.damage = nil
    self.fatigue_damage = nil
    self.exertion_damage = nil
    self.energy_damage = nil
  end
  if self.damage.is_a?(Numeric)
    @show_guard = false
    miss = false
    if self.damage != 0
      obscure = true
    end
  end
  if self.fatigue_damage.is_a?(Numeric)
    @show_guard = false
    miss = false
    if self.fatigue_damage != 0
      obscure = true
    end
  end
  if self.exertion_damage.is_a?(Numeric)
    @show_guard = false
    miss = false
    if self.exertion_damage != 0
      obscure = true
    end
  end
  if self.energy_damage.is_a?(Numeric)
    @show_guard = false
    miss = false
    if self.energy_damage != 0
      obscure = true
    end
  end
  if self.damage == 0
    if self.fatigue_damage == 0
      if self.exertion_damage == 0
        if self.energy_damage == 0
          if @new_states.size == 0
            self.damage = 0
            self.fatigue_damage = nil
            self.exertion_damage = nil
            self.energy_damage = nil
          end
        end
      end
    end
  end
  if @show_guard == false
    guard = false
  end
  if @new_states.size > 0
    guard = false
    miss = false
    obscure = true
  end
  if skill_or_item.plus_state_set.size > 0
    obscure = true
  end
  if skill_or_item.minus_state_set.size > 0
    guard = false
    miss = false
    obscure = true
  end
  if skill_or_item.common_event_id > 0
    obscure = true
  end
  if guard
    obscure = true
  end
  if obscure
    if self.damage == 0
      self.damage = nil
    end
    if self.fatigue_damage == 0
      self.fatigue_damage = nil
    end
    if self.exertion_damage == 0
      self.exertion_damage = nil
    end
    if self.energy_damage == 0
      self.energy_damage = nil
    end
  end
  if self.damage == nil
    if self.fatigue_damage == nil
      if self.exertion_damage == nil
        if self.energy_damage == nil
          unless guard
            if @new_states.size == 0
              miss = true
            end
          end
        end
      end
    end
  end
  if skill_or_item.common_event_id > 0
    guard = false
    if @state_grabber
      miss = false
    end
  end
  if guard
    self.damage = "Guard!"
    self.fatigue_damage = nil
    self.exertion_damage = nil
    self.energy_damage = nil
  end
  if miss
    self.damage = "Miss!"
    self.fatigue_damage = nil
    self.exertion_damage = nil
    self.energy_damage = nil
  end
  unless $game_temp.in_battle
    self.damage = nil
  end
end
# -----------------------
def respite_effect
  self.damage = 0
  self.damage -= rand(3)
  self.damage -= 2
  self.hp -= self.damage
  self.damage_pop = true
end
# -----------------------
def guts
  @guts_flag = false
  if self.is_a?(Game_Actor)
    chance = 0
  end
  if self.is_a?(Game_Enemy)
    chance = self.guts_chance
  end
  if self.damage != nil
    if self.damage >= self.hp
      if rand(100) < chance
        self.hp = 1
        @guts_flag = true
        @overkill_percent = 0
      end
    end
  end
end
# -----------------------
def overkill
  @overkill_percent = 0
  if self.damage != nil
    overkill_hp = self.hp - self.damage
    if overkill_hp < 0
      overkill_hp = overkill_hp.abs
      @overkill_percent = overkill_hp * 100 / self.maxhp
      @overkill_percent *= 2
    end
  end
end
# -----------------------
def add_death_attack
  if $game_temp.in_battle
    if @armor4_id == 16
      unless @immortal
        unless @berserk_count > 0
          unless @death_attack
            @death_attack = true
            $scene.force(self, 1, -1, true, -1, -1)
          end
        end
      end
    end
  end
end
# -----------------------
def ftr
  num_states = 0
  state_total = 0.00
  energy_effect = @energy.to_f
  energy_effect /= 100.0
  state_effect = 1.00
  delay_effect = 1.00
  passive_effect = 1.00
  difficulty_effect = 1.00
  equipment_effect = 0.00
  powerful_enemy_effect = 1.00
  for state in @states
    num_states += 1
    state_total += $data_states[state].maxsp_rate.to_f
  end
  if state_total > 0
    state_effect = state_total / num_states
    state_effect /= 100.0
  end
  if $game_temp.in_battle
    if @current_action.action_delay == 0
      delay_effect = 1.0
    end
    if @current_action.action_delay > 0
      delay_effect = 0.5
    end
    if @current_action.passive == 0
      passive_effect = 1.0
    end
    if @current_action.passive == 1
      passive_effect = 0.5
    end
    if @current_action.passive == 2
      passive_effect = 0.5
    end
    if @current_action.passive == 3
      passive_effect = 0.5
    end
  end
  if self.is_a?(Game_Enemy)
    difficulty_effect = 1.20
    difficulty_effect += $game_system.difficulty.to_f / 2.0
    if self.current_action.type != 0
      difficulty_effect -= 0.20
    end
    energy_effect = 1.00
    powerful_enemy_effect += @pe_ftr_up.to_f / 100
  end
  if self.is_a?(Game_Actor)
    equipment_effect = 0.00
    if @armor1_id != 0
      a1 = $data_armors[@armor1_id]
      equipment_effect += a1.ftr_plus.to_f / 100.00
    end
    if @armor2_id != 0
      a2 = $data_armors[@armor2_id]
      equipment_effect += a2.ftr_plus.to_f / 100.00
    end
    if @armor3_id != 0
      a3 = $data_armors[@armor3_id]
      equipment_effect += a3.ftr_plus.to_f / 100.00
    end
    if @armor4_id != 0
      a4 = $data_armors[@armor4_id]
      equipment_effect += a4.ftr_plus.to_f / 100.00
    end
    if @armor4_id == 25
      equipment_effect += 0.1 * $game_party.count_dead
    end
    if self.summon_actor
      return 2.00
    end
  end
  result = energy_effect
  result *= state_effect
  result *= delay_effect
  result *= passive_effect
  result *= difficulty_effect
  result *= powerful_enemy_effect
  result += equipment_effect
  return result
end
# -----------------------
def exr
  equipment_effect = 0.00
  state_effect = 0.00
  powerful_enemy_effect = @pe_exr_up.to_f / 100
  if self.is_a?(Game_Actor)
    equipment_effect = 0.00
    if @armor1_id != 0
      a1 = $data_armors[@armor1_id]
      equipment_effect += a1.exr_plus.to_f / 100.00
    end
    if @armor2_id != 0
      a2 = $data_armors[@armor2_id]
      equipment_effect += a2.exr_plus.to_f / 100.00
    end
    if @armor3_id != 0
      a3 = $data_armors[@armor3_id]
      equipment_effect += a3.exr_plus.to_f / 100.00
    end
    if @armor4_id != 0
      a4 = $data_armors[@armor4_id]
      equipment_effect += a4.exr_plus.to_f / 100.00
    end
    if @armor4_id == 25
      equipment_effect += 0.1 * $game_party.count_dead
    end
    if self.summon_actor
      return 2.00
    end
  end
  if self.state?(57)
    return 2.00
  end
  if self.state?(80)
    return 2.00
  end
  if self.state?(65)
    state_effect = -0.25
  end
  if self.state?(66)
    state_effect = -0.50
  end
  if self.state?(67)
    state_effect = -0.75
  end
  return 1.00 + equipment_effect + powerful_enemy_effect + state_effect
end
# -----------------------
def spike(attacker, damage)
  if @spike_mult > 0
    d = damage * @spike_mult
    d = Integer(d)
    unless attacker.invincible_frames > 0
      attacker.hp -= d
      $game_temp.hp_damage_hook = -d
    end
  end
end
# -----------------------
def invincible
  if self.invincible_frames > 0
    if self.damage != nil
      if self.damage > 0
        self.damage = nil
      end
    end
    if self.fatigue_damage != nil
      if self.fatigue_damage > 0
        self.fatigue_damage = nil
      end
    end
    if self.exertion_damage != nil
      if self.exertion_damage > 0
        self.exertion_damage = nil
      end
    end
    if self.energy_damage != nil
      if self.energy_damage > 0
        self.energy_damage = nil
      end
    end
    @show_guard = true
    return true
  end
  return false
end
# -----------------------
def get_critical_guard_monsters
  if self.is_a?(Game_Enemy)
    if $data_enemies[self.id].critical_guard
      @critical_guard = true
    end
  end
end
# -----------------------
def check_factors_up(skill)
  result = [0, 0, 0, 0]
  s = skill.str_f + skill.dex_f + skill.agi_f + skill.int_f
  if s > 0
    result[0] = @factor_changes[0]
    result[1] = @factor_changes[1]
    result[2] = @factor_changes[2]
    result[3] = @factor_changes[3]
  end
  return result
end
# -----------------------
def reveal_hp_bar(attacker)
  if attacker.is_a?(Game_Actor)
    if attacker.weapon_id == 12
      r = rand(100)
      if r < 15
        self.show_hp_bar = true
      end
    end
  end
end
# -----------------------
def retroreflect(attacker)
  if self.is_a?(Game_Actor)
    if self.armor3_id == 30
      r = rand(100)
      if r < 5
        attacker.add_state(10)
        attacker.damage = "Unsteady!"
        attacker.damage_pop = true
      end
    end
  end
end
# -----------------------
def leukocite_effect(damage)
  if self.is_a?(Game_Actor)
    if self.equipped_auto_abilities.include?(118)
      if damage.is_a?(Numeric)
        if damage >= self.maxhp / 3
          r = rand(100)
          if r < 50
            @leukocite = 125
          end
        end
      end
    end
  end
end
# -----------------------
def attack_combo(attacker)
  result = 1.0
  if attacker.is_a?(Game_Actor)
    if attacker.armor4_id == 36
      attacker.combo_level += 1
      if attacker.combo_level > 10
        attacker.combo_level = 10
      end
      attacker.combo_hp = attacker.hp
      case attacker.combo_level
      when 2
        result = 1.2
        $scene.show_combo(2)
      when 3
        result = 1.5
        $scene.show_combo(3)
      when 4
        result = 1.8
        $scene.show_combo(4)
      when 5
        result = 2.0
        $scene.show_combo(5)
      when 6
        result = 2.5
        $scene.show_combo(6)
      when 7
        result = 3.0
        $scene.show_combo(7)
      when 8
        result = 3.5
        $scene.show_combo(8)
      when 9
        result = 4.0
        $scene.show_combo(9)
      when 10
        result = 5.0
        $scene.show_combo(10)
      end
    end
  end
  return result
end
# -----------------------
def reduce_ft_ex_damage
  if self.is_a?(Game_Actor)
    if self.armor1_id == 37
      if self.fatigue_damage.is_a?(Numeric)
        if self.fatigue_damage > 0
          self.fatigue_damage /= 4
        end
      end
      if self.exertion_damage.is_a?(Numeric)
        if self.exertion_damage > 0
          self.exertion_damage /= 4
        end
      end
    end
  end
end
# -----------------------
def stunner(attacker)
  if self.state?(4)
    return
  end
  if @stunner
    r = rand(100)
    chance = 60 - self.state_ranks[4] * 10
    if r < chance
      self.add_state(4)
      @new_states.push("Stun")
    end
  end
end
# -----------------------
end
