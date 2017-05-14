class Game_Initializer
# ---------------------
def initialize
  @vess_actor = $game_actors[8]
  @base_vess_skill_pow = []
  @base_vess_skill_ftc = []
  $game_system.fatal = []
end
# ---------------------
def new_game_setup
  setup_skill_delay
  setup_skill_drain
  setup_skill_power
  setup_skill_absorb
  setup_skill_scope
  setup_state_icons
  setup_weapon_vess
  setup_weapon_eva
  setup_armor_vess
  setup_armor_atk
  setup_exft
  setup_vector
  setup_synapse
  setup_critical_guard
  set_base_vess_skill_data
  increase_monster_stats
  setup_battle_difficulty
  set_counterattack
  set_stealing
  set_cover
  set_guts
  set_sprite_flying
  set_frequency_distributions
end
# ---------------------
def load_game_setup
  setup_skill_delay
  setup_skill_drain
  setup_skill_power
  setup_skill_absorb
  setup_skill_scope
  setup_state_icons
  setup_weapon_eva
  setup_weapon_vess
  setup_armor_vess
  setup_armor_atk
  setup_exft
  setup_vector
  setup_synapse
  setup_critical_guard
  set_base_vess_skill_data
  reconstitute_vess_skills
  increase_monster_stats
  setup_battle_difficulty
  set_counterattack
  set_stealing
  set_cover
  set_guts
  set_sprite_flying
  set_frequency_distributions
end
# ---------------------
def setup_skill_delay
  for i in 1..$data_skills.size - 1
    $data_skills[i].delay = 0
  end
  $data_skills[26].delay = 100
  $data_skills[116].delay = 100
end
# ---------------------
def setup_skill_drain
  for i in 1..$data_skills.size - 1
    $data_skills[i].drain = 0
  end
  $data_skills[13].drain = 1
  $data_skills[24].drain = 0
  $data_skills[25].drain = 0
  $data_skills[26].drain = 2
  $data_skills[27].drain = 3
  $data_skills[36].drain = 2
  $data_skills[59].drain = 0
  $data_skills[60].drain = 0
  $data_skills[76].drain = 1
  $data_skills[77].drain = 1
  $data_skills[78].drain = 1
  $data_skills[114].drain = 4
  $data_skills[115].drain = 2
  $data_skills[116].drain = 2
  $data_skills[117].drain = 1
  $data_skills[119].drain = 3
  $data_skills[139].drain = 1
  $data_skills[140].drain = 4
  $data_skills[141].drain = 1
  $data_skills[142].drain = 2
end
# ---------------------
def setup_skill_power
  for i in 1..$data_skills.size - 1
    $data_skills[i].ft_power = 0
    $data_skills[i].ex_power = 0
  end
  $data_skills[50].ft_power = -18
  $data_skills[51].ft_power = 28
  $data_skills[89].ft_power = 75
  $data_skills[31].ex_power = 100
  $data_skills[41].ex_power = 400
  $data_skills[89].ex_power = 120
  $data_skills[93].ex_power = 160
end
# ---------------------
def setup_skill_scope
  $data_skills[40].scope = 8
  $data_skills[132].scope = 8
end
# ---------------------
def setup_skill_absorb
  for i in 1..$data_skills.size - 1
    $data_skills[i].hp_absorb_percent = 0
    $data_skills[i].ft_absorb_percent = 0
    $data_skills[i].ex_absorb_percent = 0
  end
  $data_skills[30].hp_absorb_percent = 50
end
# ---------------------
def setup_synapse
  for i in 1..$data_skills.size - 1
    $data_skills[i].synapse = -1
  end
end
# ---------------------
def setup_weapon_vess
  for i in 1..$data_weapons.size - 1
    $data_weapons[i].ap_needed = -1
    $data_weapons[i].associated_skill = -1
    $data_weapons[i].associated_stat = -1
    $data_weapons[i].associated_value = -1
  end
  $data_weapons[4].ap_needed = 120
  $data_weapons[4].associated_skill = 13
  $data_weapons[5].ap_needed = 600
  $data_weapons[5].associated_skill = 36
  $data_weapons[9].ap_needed = 1650
  $data_weapons[9].associated_skill = 110
  $data_weapons[10].ap_needed = 2100
  $data_weapons[10].associated_skill = 114
  $data_weapons[11].ap_needed = 1925
  $data_weapons[11].associated_skill = 115
end
# ---------------------
def setup_weapon_eva
  for i in 1..$data_weapons.size - 1
    $data_weapons[i].eva = 0
  end
end
# ---------------------
def setup_armor_vess
  for i in 1..$data_armors.size - 1
    $data_armors[i].ap_needed = -1
    $data_armors[i].associated_skill = -1
    $data_armors[i].associated_stat = -1
    $data_armors[i].associated_value = -1
  end
  $data_armors[6].ap_needed = 250
  $data_armors[6].associated_stat = 5
  $data_armors[6].associated_value = 24
  $data_armors[7].ap_needed = 100
  $data_armors[7].associated_stat = 1
  $data_armors[7].associated_value = 10
  $data_armors[11].ap_needed = 400
  $data_armors[11].associated_stat = 2
  $data_armors[11].associated_value = 8
  $data_armors[12].ap_needed = 750
  $data_armors[12].associated_skill = 32
  $data_armors[13].ap_needed = 475
  $data_armors[13].associated_stat = 3
  $data_armors[13].associated_value = 10
  $data_armors[16].ap_needed = 515
  $data_armors[16].associated_stat = 4
  $data_armors[16].associated_value = 9
  $data_armors[27].ap_needed = 1500
  $data_armors[27].associated_stat = 5
  $data_armors[27].associated_value = 28
  $data_armors[29].ap_needed = 1875
  $data_armors[29].associated_stat = 6
  $data_armors[29].associated_value = 2
  $data_armors[32].ap_needed = 1420
  $data_armors[32].associated_stat = 4
  $data_armors[32].associated_value = 11
end
# ---------------------
def setup_armor_atk
  for i in 1..$data_armors.size - 1
    $data_armors[i].atk = 0
  end
  $data_armors[18].atk = 5
end
# ---------------------
def setup_exft
  for i in 1..$data_weapons.size - 1
    $data_weapons[i].ftr_plus = 0
    $data_weapons[i].exr_plus = 0
  end
  for i in 1..$data_armors.size - 1
    $data_armors[i].ftr_plus = 0
    $data_armors[i].exr_plus = 0
  end
end
# ---------------------
def set_base_vess_skill_data
  for i in 1..$data_skills.size - 1
    @base_vess_skill_pow[i] = 0
    @base_vess_skill_ftc[i] = 0
  end
  $game_system.current_ap_weapon[4] = 900120
  @base_vess_skill_pow[13] = 16
  @base_vess_skill_ftc[13] = 36
  @base_vess_skill_pow[36] = 20
  @base_vess_skill_ftc[36] = 50
  @base_vess_skill_pow[114] = 32
  @base_vess_skill_ftc[114] = 56
  $data_skills[13].power = 16
  $data_skills[13].sp_cost = 36
  $data_skills[13].hit = 90
end
# ---------------------
def reconstitute_vess_skills
  for i in 1..$game_system.current_ap_weapon.size - 1
    if $game_system.current_ap_weapon[i] >= 900000
      if $data_weapons[i].associated_skill > 0
        weapon = $data_weapons[i]
        restore_skill(weapon)
      end
    end
  end
  for i in 1..$game_system.current_ap_armor.size - 1
    if $game_system.current_ap_armor[i] >= 900000
      if $data_armors[i].associated_skill > 0
        armor = $data_armors[i]
        restore_skill(armor)
      end
    end
  end
end
# ---------------------
def restore_skill(object)
  total_ap = object.ap_needed
  if object.is_a?(RPG::Weapon)
    current_ap = $game_system.current_ap_weapon[object.id] - 900000
  end
  if object.is_a?(RPG::Armor)
    current_ap = $game_system.current_ap_armor[object.id] - 900000
  end
  s = object.associated_skill
  if $data_skills[s].command_ability?
    @vess_actor.learn_skill(s)
    return
  end
  if $data_skills[s].auto_ability?
    @vess_actor.learn_skill(s)
    return
  end
  base_pow = $game_initializer.get_base_vess_skill_pow(s)
  base_ftc = $game_initializer.get_base_vess_skill_ftc(s)
  if current_ap < total_ap
    pow = current_ap * base_pow / total_ap
    ftc = (base_ftc * 2) - (current_ap * base_ftc / total_ap)
    acc = current_ap * 90 / total_ap
  end
  if current_ap == total_ap
    pow = base_pow
    ftc = base_ftc
    acc = 90
  end
  if current_ap > total_ap
    pow = base_pow + ((current_ap * base_pow / total_ap) / 8)
    ftc = base_ftc - ((current_ap * base_ftc / total_ap) / 16)
    acc = 90 + Integer(((current_ap.to_f / total_ap.to_f).to_f - 1) * 10)
  end
  $data_skills[s].hit = acc
  $data_skills[s].power = pow
  $data_skills[s].sp_cost = ftc
  @vess_actor.learn_skill(s)
end
# ---------------------
def get_base_vess_skill_pow(skill_id)
  return @base_vess_skill_pow[skill_id]
end
# ---------------------
def get_base_vess_skill_ftc(skill_id)
  return @base_vess_skill_ftc[skill_id]
end
# ---------------------
def setup_state_icons
  for i in 1..$data_states.size - 1
    $data_states[i].icon = ""
  end
  $data_states[1].icon = RPG::Cache.icon("status01")
  $data_states[2].icon = RPG::Cache.icon("status02") 
  $data_states[3].icon = RPG::Cache.icon("status03")
  $data_states[4].icon = RPG::Cache.icon("status04")
  $data_states[5].icon = RPG::Cache.icon("status05")
  $data_states[6].icon = RPG::Cache.icon("status06")
  $data_states[7].icon = RPG::Cache.icon("status07")
  $data_states[8].icon = RPG::Cache.icon("status08")
  $data_states[9].icon = RPG::Cache.icon("status09")
  $data_states[10].icon = RPG::Cache.icon("status10")
  $data_states[11].icon = RPG::Cache.icon("status11")
  $data_states[12].icon = RPG::Cache.icon("status12")
  $data_states[13].icon = RPG::Cache.icon("status13")
  $data_states[14].icon = RPG::Cache.icon("status14")
  $data_states[15].icon = RPG::Cache.icon("status15")
end
# ---------------------
def increase_monster_stats
  if $game_system.difficulty == 1
    for i in 1..$data_enemies.size - 1
      $data_enemies[i].maxhp *= 6
      $data_enemies[i].atk *= 6
      $data_enemies[i].dex *= 6
      $data_enemies[i].int *= 6
      $data_enemies[i].maxhp /= 5
      $data_enemies[i].atk /= 5
      $data_enemies[i].dex /= 5
      $data_enemies[i].int /= 5
      $data_enemies[i].no_overfatigue = true
    end
  end
  if $game_system.difficulty == 2
    for i in 1..$data_enemies.size - 1
      $data_enemies[i].maxhp *= 3 / 2
      $data_enemies[i].atk *= 3 / 2
      $data_enemies[i].dex *= 3 / 2
      $data_enemies[i].int *= 3 / 2
      $data_enemies[i].no_overfatigue = true
    end
  end
end
# ---------------------
def setup_battle_difficulty
  for i in 1..$data_troops.size - 1
    $data_troops[i].difficulty = 0
  end
end
# ---------------------
def setup_critical_guard
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].critical_guard = false
  end
  $data_enemies[3].critical_guard = true
  $data_enemies[22].critical_guard = true
end
# ---------------------
def set_counterattack
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].atk_counter_chance = 0
    $data_enemies[i].skill_counter_chance = 0
    $data_enemies[i].atk_counter_code = -1
    $data_enemies[i].skill_counter_code = -1
  end
  $data_enemies[10].atk_counter_chance = 10
  $data_enemies[10].atk_counter_code = 0
  $data_enemies[10].skill_counter_chance = 10
  $data_enemies[10].skill_counter_code = 0
  $data_enemies[30].atk_counter_chance = 20
  $data_enemies[30].atk_counter_code = 0
  $data_enemies[30].skill_counter_chance = 0
  $data_enemies[30].skill_counter_code = 0
end
# ---------------------
def set_stealing
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].steal_item = 0
    $data_enemies[i].steal_weapon = 0
    $data_enemies[i].steal_armor = 0
    $data_enemies[i].steal_money = 0
  end
  $data_enemies[8].steal_item = 8
  $data_enemies[9].steal_item = 25
  $data_enemies[10].steal_item = 1
  $data_enemies[11].steal_item = 37
  $data_enemies[12].steal_item = 15
  $data_enemies[13].steal_item = 40
  $data_enemies[14].steal_item = 5
  $data_enemies[15].steal_item = 36
  $data_enemies[16].steal_item = 2
  $data_enemies[17].steal_item = 41
  $data_enemies[25].steal_item = 20
  $data_enemies[26].steal_item = 25
  $data_enemies[27].steal_item = 50
  $data_enemies[28].steal_item = 10
  $data_enemies[29].steal_item = 47
  $data_enemies[30].steal_item = 48
  $data_enemies[31].steal_item = 7
  $data_enemies[32].steal_item = 16
  $data_enemies[33].steal_item = 15
  $data_enemies[34].steal_item = 1
  $data_enemies[35].steal_item = 45
end
# ---------------------
def set_cover
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].cover_chance = 0
  end
  $data_enemies[27].cover_chance = 33
end
# ---------------------
def set_guts
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].guts_chance = 0
  end
  $data_enemies[10].guts_chance = 10
end
# ---------------------
def set_sprite_flying
  for i in 1..$data_enemies.size - 1
    $data_enemies[i].flying = false
  end
  $data_enemies[12].flying = true
  $data_enemies[14].flying = true
  $data_enemies[26].flying = true
  $data_enemies[29].flying = true
end
# ---------------------
def set_frequency_distributions
  for i in 1..$data_troops.size - 1
    $data_troops[i].frequency_distribution = []
  end
  $data_troops[8].frequency_distribution = [20, 80]
  $data_troops[9].frequency_distribution = [33, 67]
  $data_troops[10].frequency_distribution = [75, 25]
  $data_troops[20].frequency_distribution = [70, 30]
  $data_troops[21].frequency_distribution = [80, 20]
  $data_troops[22].frequency_distribution = [80, 20]
  $data_troops[24].frequency_distribution = [50, 50]
end
# ---------------------
def setup_vector
  for i in 1..$data_armors.size - 1
    $data_armors[i].vector_plus = 0
  end
  $data_armors[38].vector_plus = 2
end
# ---------------------
end
