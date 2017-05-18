#==============================================================================
# ■ Game_Battler (分割定義 3)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if dead?
      return false
    end
    if self.restriction == 1
      return false
    end
    if self.fatigue <= -100
      return false
    end
    if @support_crush
      if $data_skills[skill_id].scope > 2
        return false
      end
    end
    occasion = $data_skills[skill_id].occasion
    if $game_temp.in_battle
      return (occasion == 0 or occasion == 1)
    else
      return (occasion == 0 or occasion == 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の効果適用
  #     attacker : 攻撃者 (バトラー)
  #--------------------------------------------------------------------------
  def attack_effect(attacker, already_covered = false)
    get_critical_guard_monsters
    $game_temp.atk_missed = false
    phys_attack = false
    @attack_add_state = true
    @show_guard = false
    @cover = false
    self.critical = false
    element_immune = false
    not_zero = false
    hit_result = (rand(100) < attacker.hit)
    if hit_result == true
      @show_guard = true
      atk = attacker.atk
      if attacker.charge_up
        atk *= 1.6
        atk = Integer(atk)
        attacker.charge_up = false
      end
      atk -= self.pdef / 2
      if atk < 0
        atk = 0
      end
      self.damage = atk * (20 + attacker.str) / 40
      if self.damage != 0
        not_zero = true
      end
      if attacker.element_set == []
        phys_attack = true
      end
      self.damage *= elements_correct(attacker.element_set, true, phys_attack)
      self.damage /= 100
      if self.damage == 0 && not_zero
        element_immune = true
      end
      if self.damage > 0
        critical_chance = 4 * attacker.dex / self.agi
        if critical_chance >= 10
          critical_chance = 10
        end
        if rand(100) < critical_chance
          self.damage *= 2
          self.critical = true
        end
        if self.guarding?
          self.damage /= 2
        end
      end
      if @critical_guard
        self.critical = false
      end
      if self.damage.abs > 0
        amp = [self.damage.abs * 15 / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      eva = 8 * self.agi / attacker.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
    end
    if hit_result == true
      v = attack_combo(attacker)
      if self.damage.is_a?(Numeric)
        self.damage *= v
        self.damage = Integer(self.damage)
      end
      null_states = false
      if @guard_once
        self.damage = 0
        @guard_once = false
        @show_guard = true
        null_states = true
      end
      process_hp_shield
      if invincible
        null_states = true
      end
      remove_states_shock
      reveal_hp_bar(attacker)
      retroreflect(attacker)
      spike(attacker, self.damage)
      leukocite_effect(self.damage)
      set_recent_recovery_values(-999, true)
      guts
      unless @guts_flag
        if self.damage != nil
          self.hp -= self.damage
        end
      end
      @state_changed = false
      unless null_states
        states_plus(attacker.plus_state_set)
        states_minus(attacker.minus_state_set)
        stunner(attacker)
      end
      if @show_guard
        self.damage = "Guard!"
      end
    else
      self.damage = "Miss!"
      $game_temp.atk_missed = true
      self.critical = false
    end
    if self.damage.is_a?(Numeric)
      if self.damage > 0
        @last_dmg = self.damage
      end
    else
      @last_dmg = -1
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● スキルの効果適用
  #     user  : スキルの使用者 (バトラー)
  #     skill : スキル
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    $game_temp.skill_hit = false
    @attack_add_state = false
    @show_guard = true
    self.critical = false
    element_immune_hp = false
    element_immune_ft = false
    element_immune_ex = false
    not_zero_hp = false
    not_zero_ft = false
    not_zero_ex = false
    schizo = false
    if user == $game_schizo.schizo_actor?
      schizo = true
    end
    if skill.scope == 3 or skill.scope == 4
      if self.hp == 0
        if not @immortal
          if not @berserk_count > 0
            return false
          end
        end
      end
    end
    if skill.scope == 5 or skill.scope == 6
      if self.hp > 0
        return false
      end
    end
    effective = false
    effective |= skill.common_event_id > 0
    hit = skill.hit
    if skill.atk_f > 0
      hit *= user.hit.to_f / 100.0
      hit = Integer(hit)
    end
    hit_result = (rand(100) < hit)
    effective |= hit < 100
    if hit_result == true
      power = skill.power + user.atk * skill.atk_f / 100
      ftpower = skill.ft_power
      expower = skill.ex_power
      if power > 0
        power -= self.pdef * skill.pdef_f / 200
        power -= self.mdef * skill.mdef_f / 200
        power = [power, 0].max
      end
      f_up = check_factors_up(skill)
      rate = 40
      rate += (user.str * (skill.str_f + f_up[0]) / 100)
      rate += (user.dex * (skill.dex_f + f_up[1]) / 100)
      rate += (user.agi * (skill.agi_f + f_up[2]) / 100)
      rate += (user.int * (skill.int_f + f_up[3]) / 100)
      if schizo
        rate *= $game_schizo.effect_bonus
      end
      if self.damage != 0
        not_zero_hp = true
      end
      self.damage = power * rate / 40
      self.damage *= elements_correct(skill.element_set)
      self.damage /= 100
      if self.damage == 0
        element_immune_hp = true
        not_zero_hp = false
      end
      self.fatigue_damage = ftpower
      if self.fatigue_damage != 0
        not_zero_ft = true
      end
      if schizo
        if $game_schizo.ft_tag
          if not_zero_ft
            self.fatigue_damage *= 1.5
            self.fatigue_damage = Integer(self.fatigue_damage)
          else
            self.fatigue_damage = rand(11) + 10
            if self.is_a?(Game_Actor)
              self.fatigue_damage *= -1
            end
            not_zero_ft = true
          end
        end
        if $game_schizo.hp_full
          self.damage = -32767
          $game_schizo.hp_full = false
        end
        if $game_schizo.ft_full
          self.fatigue_damage = -32767
          $game_schizo.ft_full = false
          not_zero_ft = true
        end
      end
      self.fatigue_damage *= elements_correct(skill.element_set)
      self.fatigue_damage /= 100
      if self.fatigue_damage == 0
        element_immune_ft = true
        not_zero_ft = false
      end
      if skill.ft_power == 0
        element_immune_ft = true
        not_zero_ft = false
      end
      self.exertion_damage = expower
      if self.exertion_damage != 0
        not_zero_ex = true
      end
      self.exertion_damage *= elements_correct(skill.element_set, true)
      self.exertion_damage /= 100
      if self.exertion_damage == 0
        element_immune_ex = true
        not_zero_ex = false
      end
      if skill.ex_power == 0
        element_immune_ex = true
        not_zero_ex = false
      end
      if self.damage > 0
        if self.guarding?
          self.damage /= 2
          self.fatigue_damage /= 2
          self.exertion_damage /= 2
        end
      end
      if skill.variance > 0 and self.damage.abs > 0
        amp = [self.damage.abs * skill.variance / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      if skill.variance > 0 and self.fatigue_damage.abs > 0
        amp = [self.fatigue_damage.abs * skill.variance / 100, 1].max
        self.fatigue_damage += rand(amp+1) + rand(amp+1) - amp
      end
      if skill.variance > 0 and self.exertion_damage.abs > 0
        amp = [self.exertion_damage.abs * skill.variance / 100, 1].max
        self.exertion_damage += rand(amp+1) + rand(amp+1) - amp
      end
      eva = 8 * self.agi / user.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva * skill.eva_f / 100
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
      effective |= hit < 100
    end
    if hit_result == true
      if skill.power != 0 and skill.atk_f > 0
        remove_states_shock
        effective = true
      end
    end
    if self.diseased?
      if self.damage.is_a?(Numeric)
        if self.damage < 0
          self.damage = 0
        end
      end
    end
    if hit_result == true
      $game_temp.skill_hit = true
      null_states = false
      process_hp_shield
      if @hp_shield_processed
        null_states = true
      end
      if invincible
        null_states = true
        $game_temp.skill_hit = false
      end
      last_hp = self.hp
      last_ft = self.fatigue
      last_ex = self.exertion
      set_recent_recovery_values(last_hp)
      overkill
      guts
      reduce_ft_ex_damage
      unless @guts_flag
        if self.damage != nil
          self.hp -= self.damage
        end
      end
      leukocite_effect(self.damage)
      if self.fatigue_damage != nil
        self.fatigue -= self.fatigue_damage
      end
      if self.exertion_damage != nil
        self.exertion += self.exertion_damage
      end
      $game_temp.general_damage_hook = self.damage
      if skill.hp_absorb_percent > 0
        dmg = self.damage
        dmg *= skill.hp_absorb_percent
        dmg /= 100
        user.hp += dmg
        $game_temp.hp_damage_hook += dmg
      end
      if skill.ft_absorb_percent > 0
        dmg = self.fatigue_damage
        dmg *= skill.ft_absorb_percent
        dmg /= 100
        user.fatigue += dmg
        $game_temp.ft_damage_hook += dmg
      end
      if skill.ex_absorb_percent > 0
        dmg = self.exertion_damage
        dmg *= skill.ex_absorb_percent
        dmg /= 100
        user.exertion -= dmg
        $game_temp.ex_damage_hook += dmg
      end
      effective |= self.hp != last_hp
      effective |= self.fatigue != last_ft
      effective |= self.exertion != last_ex
      extra_status = []
      unless null_states
        effective |= states_plus(skill.plus_state_set + extra_status)
        effective |= states_minus(skill.minus_state_set)
      end
      if schizo
        if $game_schizo.status_strike
          extra_status = [rand(13) + 2]
        end
        if $game_schizo.comorbidity
          extra_status = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
        end
      end
      determine_supplementary_damage_display(skill)
    else
      self.damage = "Miss!"
    end
    if self.damage.is_a?(Numeric)
      if self.damage > 0
        @last_dmg = self.damage
      end
    else
      unless skill.id == 78
        @last_dmg = -1
      end
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # ● アイテムの効果適用
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_effect(item)
    @attack_add_state = false
    null_states = false
    self.critical = false
    if item.scope == 3 or item.scope == 4
      if self.hp == 0
        if not @immortal
          if not @berserk_count > 0
            return false
          end
        end
      end
    end
    if item.scope == 5 or item.scope == 6
      if self.hp > 0
        return false
      end
    end
    effective = false
    effective |= item.common_event_id > 0
    hit = item.hit
    if $game_temp.item_charge >= 50
      if item.recover_hp_rate == 0
        if item.recover_hp == 0
          if item.recover_sp_rate == 0
            if item.recover_sp == 0
              if item.parameter_points == 0
                hit = hit * $game_temp.item_charge / 100
              end
            end
          end
        end
      end
    end
    if $game_actors[9].extra_charge
      $game_temp.item_charge = 150
    end
    hit_result = (rand(100) < hit)
    effective |= item.hit < 100
    if hit_result == true
      recover_hp = maxhp * item.recover_hp_rate / 100 + item.recover_hp
      if item.parameter_type == 2 && item.parameter_points != 0
        recover_ex = item.parameter_points
      else
        recover_ex = 0
      end
      recover_ft = item.recover_sp
      if recover_hp < 0
        recover_hp += self.pdef * item.pdef_f / 20
        recover_hp += self.mdef * item.mdef_f / 20
        recover_hp = [recover_hp, 0].min
      end
      if $game_temp.item_charge >= 50
        charge_effect = $game_temp.item_charge.to_f / 100.00
        recover_hp = recover_hp * charge_effect
        recover_hp = Integer(recover_hp)
        recover_ft = recover_ft * charge_effect
        recover_ft = Integer(recover_ft)
        recover_ex = recover_ex * charge_effect
        recover_ex = Integer(recover_ex)
      end
      recover_hp *= elements_correct(item.element_set)
      recover_hp /= 100
      recover_ft *= elements_correct(item.element_set)
      recover_ft /= 100
      recover_ex *= elements_correct(item.element_set, true)
      recover_ex /= 100
      if item.variance > 0 and recover_hp.abs > 0
        amp = [recover_hp.abs * item.variance / 100, 1].max
        recover_hp += rand(amp+1) + rand(amp+1) - amp
      end
      if item.variance > 0 and recover_ft.abs > 0
        amp = [recover_ft.abs * item.variance / 100, 1].max
        recover_ft += rand(amp+1) + rand(amp+1) - amp
      end
      if item.variance > 0 and recover_ex.abs > 0
        amp = [recover_ex.abs * item.variance / 100, 1].max
        recover_ex += rand(amp+1) + rand(amp+1) - amp
      end
      if recover_hp < 0
        if self.guarding?
          recover_hp /= 2
        end
      end
      self.damage = -recover_hp
      process_hp_shield
      if invincible
        null_states = true
        recover_hp = 0
        recover_ft = 0
        recover_ex = 0
      end
      if recover_ft != 0
        self.fatigue_damage = -recover_ft
      end
      if recover_ex != 0
        self.exertion_damage = -recover_ex
      end
      if self.diseased?
        if recover_hp > 0
          self.damage = 0
          recover_hp = 0
        end
        if recover_ft > 0
          self.fatigue_damage = 0
          recover_ft = 0
        end
        if recover_ex > 0
          self.exertion_damage = 0
          recover_ex = 0
        end
      end
      last_hp = self.hp
      last_ft = self.fatigue
      last_ex = self.exertion
      set_recent_recovery_values(last_hp)
      guts
      unless @guts_flag
        self.hp += recover_hp
      end
      self.fatigue += recover_ft
      self.exertion -= recover_ex
      effective |= self.hp != last_hp
      effective |= self.fatigue != last_ft
      effective |= self.exertion != last_ex
      @state_changed = false
      unless null_states
        effective |= states_plus(item.plus_state_set)
        effective |= states_minus(item.minus_state_set)
      end
      if item.parameter_type > 0 and item.parameter_points != 0
        case item.parameter_type
        when 1
          @maxhp_plus += item.parameter_points
        when 2
          @maxsp_plus += item.parameter_points
        when 3
          @str_plus += item.parameter_points
        when 4
          @dex_plus += item.parameter_points
        when 5
          @agi_plus += item.parameter_points
        when 6
          @int_plus += item.parameter_points
        end
        effective = true
      end
      if item.recover_hp_rate == 0 and item.recover_hp == 0
        self.damage = ""
        if item.recover_sp_rate == 0 and item.recover_sp == 0 and
           (item.parameter_type == 0 or item.parameter_points == 0)
          unless @state_changed
            self.damage = "Miss!"
          end
        end
      end
    else
      self.damage = "Miss!"
    end
    determine_supplementary_damage_display(item)
    $game_temp.item_charge = 0
    if $scene.is_a?(Scene_Battle)
      $scene.charging_item = false
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # ● スリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect
    if self.is_a?(Game_Actor)
      armor = self.armor3_id
    else
      armor = -1
    end
    self.damage = 0
    if self.state?(89)
      self.damage -= self.maxhp / 20
    end
    if self.state?(2) or self.state?(12) or self.state?(80)
      if $game_system.difficulty == 0
        self.damage += self.maxhp / 10
      end
      if $game_system.difficulty == 1
        self.damage += self.maxhp / 5
      end
      if $game_system.difficulty == 2
        self.damage += self.maxhp / 4
      end
      if self.damage.abs > 0
        amp = [self.damage.abs * 15 / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      if self.is_a?(Game_Actor)
        if self.equipped_auto_abilities.include?(110)
          if self.state?(2)
            ap = self.damage.to_f
            ap *= (1 + (self.level * 0.1))
            ap = Integer(ap)
            if $game_system.current_ap_weapon[w] < 900000
              $game_system.current_ap_weapon[w] += ap
            end
            if $game_system.current_ap_armor[a1] < 900000
              $game_system.current_ap_armor[a1] += ap
            end
            if $game_system.current_ap_armor[a2] < 900000
              $game_system.current_ap_armor[a2] += ap
            end
            if $game_system.current_ap_armor[a3] < 900000
              $game_system.current_ap_armor[a3] += ap
            end
            if $game_system.current_ap_armor[a4] != -1
              if $game_system.current_ap_armor[a4] < 900000
                $game_system.current_ap_armor[a4] += ap
              end
            end
          end
        end
      end
      if self.state?(2)
        if @venom_accelerant > 0
          self.damage *= 1.5
          self.damage = Integer(self.damage)
        end
      end
    end
    if self.current_action.passive == 3
      self.damage -= rand(4)
      self.damage -= 2
    end
    if armor == 18
      self.damage -= rand(3)
      self.damage -= 1
    end
    self.hp -= self.damage
    if self.damage == 0
      self.damage = nil
    end
    a = $game_temp.in_battle
    b = self.damage != 0
    c = self.damage != nil
    if a and b and c
      if self == $game_schizo.schizo_actor?
        self.damage_count = 0
      end
      self.damage_pop = true
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 属性修正の計算
  #     element_set : 属性
  #--------------------------------------------------------------------------
  def elements_correct(element_set, assimilate = false, physical = false)
    elements = element_set.clone
    if physical
      elements.push(1)
      @show_guard = false
    end
    if elements == []
      @show_guard = false
      return 100
    end
    multiplier = 0
    for i in elements
      multiplier += self.element_rate(i, assimilate)
    end
    if elements.size != 0
      multiplier /= elements.size
    end
    if multiplier != 0
      if not physical
        @show_guard = false
      end
    end
    return multiplier
  end
# -----------------------
def no_factors(skill)
  if skill.atk_f > 0
    return false
  end
  if skill.str_f > 0
    return false
  end
  if skill.dex_f > 0
    return false
  end
  if skill.agi_f > 0
    return false
  end
  if skill.int_f > 0
    return false
  end
  return true
end
# -----------------------
def process_hp_shield
  if self.damage < 0
    return
  end
  @hp_shield_processed = false
  if @hp_shield > self.damage
    self.animation_id = 202
    @hp_shield -= self.damage
    @hp_shield_damage = "[" + @hp_shield.to_s + "]"
    self.damage = 0
    self.fatigue_damage = nil
    self.exertion_damage = nil
    @hp_shield_processed = true
  end
  if @hp_shield > 0 && @hp_shield_processed == false
    self.animation_id = 202
    self.damage -= @hp_shield
    self.fatigue_damage = nil
    self.exertion_damage = nil
    @hp_shield = -1
    @hp_shield_damage = "[0]"
    @hp_shield_processed = true
  end
end
# -----------------------
end
