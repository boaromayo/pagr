class Scene_Battle
# -----------------------
def setup_actor_command_windows
  if @actor_command_windows != []
    for i in 0..@actor_command_windows.size - 1
      @actor_command_windows[i].dispose
    end
  end
  @actor_command_windows = []
  for i in 0..$game_party.actors.size - 1
    member = $game_party.actors[i]
    if member != nil
      @actor_command_windows[i] = Window_BattleCommand.new(member, 160)
      @actor_command_windows[i].x = 60
      @actor_command_windows[i].y = 320
      @actor_command_windows[i].back_opacity = 255
      @actor_command_windows[i].active = false
      @actor_command_windows[i].visible = false
    end
  end
end
# -----------------------
def clear_damage(battler)
  battler.damage = nil
  battler.fatigue_damage = nil
  battler.exertion_damage = nil
  battler.energy_damage = nil
  battler.hp_shield_damage = nil
end
# -----------------------
def disable_unusuable_commands(index)
  actor = $game_party.actors[index]
  commands = @actor_command_windows[index].commands
  @actor_command_windows[index].refresh
  for i in 0..commands.size - 1
    if actor.disabled_battle_commands[i] == 1
      @actor_command_windows[index].disable_item(i)
    end
    if actor.sealed_actions[i] == 1
      @actor_command_windows[index].disable_item(i)
    end
  end
  if $game_temp.tutorial_battle == 1
    for i in 0..commands.size - 1
      if commands[i] != "Attack"
        @actor_command_windows[index].disable_item(i)
      end
    end
  end
  if $game_temp.tutorial_battle == 2
    for i in 0..commands.size - 1
      if commands[i] != "Synthesis"
        @actor_command_windows[index].disable_item(i)
      end
    end
  end
  for i in 0..@actor_command_windows[index].commands.size - 1
    if commands[i] == "Attack"
      for state in actor.states
        if $data_states[state].fear
          @actor_command_windows[index].disable_item(i)
        end
      end
    end
    if commands[i] == "Synthesis"
      if actor.restriction == 1
        @actor_command_windows[index].disable_item(i)
      end
    end
    if commands[i] == "Psychoshape"
      if actor.restriction == 1
        @actor_command_windows[index].disable_item(i)
      end
    end
    if commands[i] == "Law"
      if actor.restriction == 1
        @actor_command_windows[index].disable_item(i)
      end
    end
    if commands[i] == "Genoshape"
      if actor.restriction == 1
        @actor_command_windows[index].disable_item(i)
      end
    end
    if commands[i] == "Item-Once" && actor.item_used_times >= 1
      @actor_command_windows[index].disable_item(i)
    end
    if commands[i] == "Hasty Exit" && $game_temp.battle_can_escape == false
      @actor_command_windows[index].disable_item(i)
    end
    if commands[i] == "Summon"
      @actor_command_windows[index].disable_item(i)
    end
  end
end
# -----------------------
def determine_act_chance(monster)
  chance = 0
  chance += aggressiveness_ft(monster)
  chance += aggressiveness_ex(monster)
  chance += aggressiveness_hp(monster)
  if chance < 80
    chance = 80
  end
  return chance
end
# -----------------------
def aggressiveness_ft(monster)
  a = $data_enemies[monster.id].maxsp / 1000
  f = monster.fatigue
  if f > 0
    modifier = f * -10
  else
    modifier = f * -4
  end
  case a
  when 0
    modifier *= 1
  when 1
    modifier *= 12
    modifier += 2000
  when 2
    modifier *= 9
    modifier += 1000
  when 3
    modifier *= 6
    modifier += 500
  when 4
    modifier *= 3
    modifier += 200
  when 5
    modifier *= 1
  when 6
    modifier /= 2
  when 7
    modifier /= 3
  when 8
    modifier /= 4
  when 9
    modifier /= 5
  end
  return modifier
end
# -----------------------
def aggressiveness_ex(monster)
  a = $data_enemies[monster.id].maxsp
  while a >= 1000
    a -= 1000
  end
  a /= 100
  x = monster.exertion
  modifier = x * 6
  case a
  when 0
    modifier *= 1.00
    modifer = Integer(modifier)
  when 1
    modifier *= 2.00
    modifer = Integer(modifier)
  when 2
    modifier *= 1.75
    modifer = Integer(modifier)
  when 3
    modifier *= 1.50
    modifer = Integer(modifier)
  when 4
    modifier *= 1.25
    modifer = Integer(modifier)
  when 5
    modifier *= 1.00
    modifer = Integer(modifier)
  when 6
    modifier *= 0.75
    modifer = Integer(modifier)
  when 7
    modifier *= 0.5
    modifer = Integer(modifier)
  when 8
    modifier *= 0.25
    modifer = Integer(modifier)
  when 9
    modifier = 0
  end
  return modifier
end
# -----------------------
def aggressiveness_hp(monster)
  a = $data_enemies[monster.id].maxsp
  while a >= 1000
    a -= 1000
  end
  while a >= 100
    a -= 100
  end
  a /= 10
  h = monster.hp * 100 / monster.maxhp
  modifier = 0
  case a
  when 0
    modifier = 0
  when 1
    modifier = 0
  when 2
    modifier = 0
  when 3
    modifier = 0
  when 4
    modifier = 0
  when 5
    modifier = 0
  when 6
    modifier = 0
  when 7
    modifier = 0
  when 8
    modifier = 0
  when 9
    modifier = 0
  end
  return modifier
end
# -----------------------
def update_number_input
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    $game_variables[$game_temp.num_input_variable_id] = @number_window.number
    $game_map.need_refresh = true
    $game_temp.num_input_variable_id = 0
    @input_number_check = false
    @dummy_window.visible = false
    @number_window.visible = false
    @number_window.visible = false
    @number_window.active = false
    @number_window.dispose
    @number_window = nil
    @no_update_flag = true
  end
end
# -----------------------
def update_battle_choices
  if Input.trigger?(Input::C)
    @choice_window.clear
    @choice_check = false
    @choice_window = nil
    @no_update_flag = true
  end
end
# -----------------------
def determine_surprise
  @tactical_ambush = 0
  @initiative = 0
  surprise = 0
  crushed = []
  powerful = [0, 0, 0, 0, 0, 0, 0]
  dice = rand(100)
  if $game_temp.required_surprise_type == -999
    $game_temp.required_surprise_type = 0
    return
  end
  if $game_temp.required_surprise_type != 0
    surprise = $game_temp.required_surprise_type
    $game_temp.required_surprise_type = 0
  end
  if surprise != 0
    dice = -1
  end
  if dice == 0 || surprise == 1
    surprise = 1
    @tactical_ambush = 1
  end
  if dice == 1 || surprise == 2
    surprise = 2
    @initiative = rand(501) + 500
  end
  if dice == 2 || surprise == 3
    surprise = 3
     if $game_troop.enemies.size > 1
        number = rand($game_troop.enemies.size - 1) + 1
        while number > 0
          victim = rand($game_troop.enemies.size)
          if !$game_troop.enemies[victim].support_crush
            crushed.push($game_troop.enemies[victim].name)
            $game_troop.enemies[victim].support_crush = true
            number -= 1
          end
        end
      else
      surprise = 0
    end
  end
  if dice == 3 || surprise == -1
    surprise = -1
    @tactical_ambush = -1
  end
  if dice == 4 || surprise == -2
    surprise = -2
    @initiative = rand(501) + 500
    @initiative *= -1
  end
   if dice == 5 || surprise == -3
     surprise = -3
     if $game_party.actors.size > 1
        number = rand($game_party.actors.size - 1) + 1
        while number > 0
          victim = rand($game_party.actors.size)
          if !$game_party.actors[victim].support_crush
            crushed.push($game_party.actors[victim].name)
            $game_party.actors[victim].support_crush = true
            number -= 1
          end
        end
      else
        surprise = 0
      end
    end
   if dice == 6 || dice == 7
     surprise = -4
     powerful = powerful_enemy
   end
   if surprise != 0
     s = surprise
     c = crushed
     i = @initiative.abs
     p = powerful
     @surprise_window = Window_Surprise.new(s, c, i, p)
   end
end
# -----------------------
def init_countdown
  if @initiative < 0
    @initiative += 1
  end
  if @initiative > 0
    @initiative -= 1
  end
end
# -----------------------
def item_support_crush_eval(item_id)
  if $game_party.actors[@selected_actor_index].support_crush
    if $data_items[item_id].scope > 2
      return false
    end
  end
  return true
end
# -----------------------
def action_delay_countdown
  for actor in $game_party.actors
    if actor.current_action.action_delay > 0
      actor.current_action.action_delay -= 1
    end
  end
  for enemy in $game_troop.enemies
    if enemy.current_action.action_delay > 0
      enemy.current_action.action_delay -= 1
    end
  end
end
# -----------------------
def fatigue_loss_change(parameter)
  if parameter == 0
    $game_system.null_fatigue_loss = false
  end
  if parameter == 1
    $game_system.null_fatigue_loss = true
  end
end
# -----------------------
def primary_fatigue_recovery(battler)
  if battler.fatigue == 100
    return 0.00
  end
  if battler.fatigue <= -100
    return 1.00
  end
  if battler.fatigue > 0
    if battler.is_a?(Game_Actor)
      result = (100.00 - battler.fatigue.abs) / 18.00
    end
    if battler.is_a?(Game_Enemy)
      result = (100.00 - battler.fatigue.abs) / 10.00
    end
  end
  if battler.fatigue < 0
    if battler.is_a?(Game_Actor)
      result = battler.fatigue.abs / 3.00
    end
    if battler.is_a?(Game_Enemy)
      result = battler.fatigue.abs / 2.00
    end
  end
  if battler.fatigue == 0
    result = 10.00
  end
  if result < 10 && battler.fatigue < 0
    result = 10.00
  end
  result *= 1.2
  return result
end
# -----------------------
def passive_fixed_ft_loss(battler)
  if battler.current_action.passive == 0
    return 0
  end
end
# -----------------------
def spread_plague
  dice = rand(1000)
  target_index = -1
  if dice == 0
    for actor in $game_party.actors
      if actor.plague?
        target_index = rand($game_party.actors.size)
        if not $game_party.actors[target_index].plague?
          $game_party.actors[target_index].damage = "Plague Spread!"
          $game_party.actors[target_index].damage_pop = true
          $game_party.actors[target_index].add_state(12)
          return
        end
      end
    end
    for enemy in $game_troop.enemies
      if enemy.plague?
       target_index = rand($game_troop.enemies.size)
        if not $game_troop.enemies[target_index].plague?
          $game_troop.enemies[target_index].damage = "Plague Spread!"
          $game_troop.enemies[target_index].damage_pop = true
          $game_troop.enemies[target_index].add_state(12)
          return
        end
      end
    end
  end
end
# -----------------------
def force(battler, type, target, nonfatigue, add_a = -1, add_b = -1)
  if nonfatigue == 1
    nonfatigue = true
  end
  if nonfatigue == 0
    nonfatigue = false
  end
  battler.forced_actions.push(Game_ForcedAction.new(type, target, nonfatigue, 
  add_a, add_b))
  $game_temp.forcing_battler.push(battler)
end
# -----------------------
def hide(battler)
  battler.hidden = true
end
# -----------------------
def show(battler)
  battler.hidden = false
end
# -----------------------
def kill_surprise
  if @surprise_window != nil
    @surprise_window.dispose
    @surprise_window = nil
  end
end
# -----------------------
def pause
  if $game_temp.battle_dvd_mode
    return
  end
  if @phase == 1 && Input.trigger?(Input::Z)
    if @paused
      @paused = false
      @pause_window.visible = false
      @spriteset.unpause_effect
      if $map_bgm_in_battle
        song = $game_temp.map_bgm
        music = "Audio/BGM/" + song + ".mid"
        Audio.bgm_play(music, 100, 100)
      else
        song = $data_system.battle_bgm.name
        music = "Audio/BGM/" + song + ".mid"
        Audio.bgm_play(music, 100, 100)
      end
    else
      @paused = true
      @pause_window.visible = true
      @spriteset.pause_effect
      if $map_bgm_in_battle
        song = $game_temp.map_bgm
        music = "Audio/BGM/" + song + ".mid"
        Audio.bgm_play(music, 70, 100)
      else
        song = $data_system.battle_bgm.name
        music = "Audio/BGM/" + song + ".mid"
        Audio.bgm_play(music, 70, 100)
      end
    end
  end
end
# -----------------------
end