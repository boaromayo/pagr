class Scene_Battle
# -----------------------
def sigil_effect(battler)
  command_break = false
  action_break = false
  escape_break = false
  if battler.is_a?(Game_Actor)
    if @phase == 2
      if @selected_actor_index == battler.index
        command_break = true
      end
    end
    if @escape_progress > 0
      if battler.current_action.passive > 0
        escape_break = true
      end
    end
  end
  if battler.current_action.type != 0
    action_break = true
  end
  if command_break
    battler.damage = "Command Break!"
    battler.damage_pop = true
    phase2_end
  end
  if action_break
    battler.damage = "Action Break!"
    battler.damage_pop = true
    battler.current_action.clear
  end
  if escape_break
    battler.damage = "Escape Break!"
    battler.damage_pop = true
    @escape_break = true
  end
end
# -----------------------
def inflict_evolution(battler)
  if battler.is_a?(Game_Enemy)
    id = battler.id
    effect = rand(8) + 1
    m = ""
    n = $data_enemies[id].name
    $game_temp.evolution_effect[0] = id
    $game_temp.evolution_effect[1] = effect
    case effect
    when 1
      m = "All " + n + " will have lowered Attack!"
    when 2
      m = "All " + n + " will have lowered Defense!"
    when 3
      m = "All " + n + " will have lowered Shaping Defense!"
    when 4
      m = "All " + n + " will have lowered Dexterity!"
    when 5
      m = "All " + n + " will have lowered Agility!"
    when 6
      m = "All " + n + " will have lowered Intelligence!"
    when 7
      m = "All " + n + " will have lowered FTR!"
    when 8
      m = "All " + n + " will have lowered HP!"
    end
    if m != ""
      $game_temp.battle_message_text.push(m)
    end
  end
end
# -----------------------
def apply_evolution
  for enemy in $game_troop.enemies
    if enemy.id == $game_temp.evolution_effect[0]
      evo_state = 80 + $game_temp.evolution_effect[1]
      enemy.add_state(evo_state)
    end
  end
end
# -----------------------
def reflect(scope)
  reflect_users = []
  a = scope == 3
  b = scope == 4
  c = scope == 5
  d = scope == 6
  e = scope == 7
  f = scope == 9
  g = scope == 10
  if a or b or c or d or e or f or g
    return
  end
  for target in @target_battlers
    dice = rand(100)
    r = target.reflect_chance
    if dice < r
      reflect_users.push(target)
      @target_battlers.push(@resolving_battler)
      if target.is_a?(Game_Actor)
        target.animation_id = PLAYER_REFLECT_ANIMATION_ID
      end
      if target.is_a?(Game_Enemy)
        target.animation_id = ENEMY_REFLECT_ANIMATION_ID
      end
      if target.reflect_chance == 101
        target.reflect_chance = 0
      end
    end
  end
  del = []
  for user in reflect_users
    if user.is_a?(Game_Actor)
      n = user.name
      for i in 0..@target_battlers.size - 1
        if @target_battlers[i].name == n
          del.push(@target_battlers[i])
        end
      end
    end
    if user.is_a?(Game_Enemy)
      n = user.index
      for i in 0..@target_battlers.size - 1
        a = @target_battlers[i].index == n
        b = @target_battlers[i].is_a?(Game_Enemy)
        if a and b
          del.push(@target_battlers[i])
        end
      end
    end
  end
  if del.size > 0
    @reflect = true
  end
  for i in 0..del.size - 1
    @target_battlers.delete(del[i])
  end
  @target_battlers = @target_battlers.uniq
end
# -----------------------
def remove_ferroelectric
  for actor in $game_party.actors
    if not actor.state?(89)
      if actor.reflect_chance == 50
        actor.reflect_chance = 0
      end
    end
  end
  for enemy in $game_troop.enemies
    if not enemy.state?(89)
      if enemy.reflect_chance == 50
        enemy.reflect_chance = 0
      end
    end
  end
end
# -----------------------
def start_itemfocus_select
  @item_window = Window_ItemFocus.new(@active_battler)
  @actor_command_windows[@selected_actor_index].active = false
end
# -----------------------
def end_itemfocus_select
  @item_window.dispose
  @item_window = nil
  @actor_command_windows[@selected_actor_index].active = true
end
# -----------------------
def update_phase2_itemfocus_select
  @item_window.visible = true
  @item_window.update
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @active_battler.current_action.setup = 0
    end_itemfocus_select
    return
  end
  if Input.trigger?(Input::C)
    @active_battler.current_action.setup = 3
    @item = $data_items[@active_battler.itemfocus_item]
    unless $game_party.item_can_use?(@item.id, true)
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.item_id = @item.id
    @item_window.visible = false
    @item_window.help_window.visible = false
    if @item.scope == 0
      phase2_end
    elsif @item.scope == 1
      start_enemy_select
    elsif @item.scope == 3 or @item.scope == 5
      start_actor_select
    elsif @item.scope == 2 or @item.scope == 4 or @item.scope == 6
      phase2_end
    elsif @item.scope == 7
      @active_battler.current_action.target_index = @selected_actor_index
      phase2_end
    else
      end_itemfocus_select
    end
    return
  end
end
# -----------------------
def setup_pending
  flag = false
  for effect in $game_mapeffects.effects
    if effect.name == "Anamalous Cognition"
      if effect.running?
        flag = true
      end
    end
  end
  if flag
    @pending_window.visible = true
  else
    @pending_window.visible = false
  end
end
# -----------------------
def leukocite_processing
  for actor in $game_party.actors
    if actor.leukocite > 0
      if Input.trigger?(Input::A)
        actor.animation_id = LEUKOCITE_ANIMATION_ID
        p = actor.leukocite - 50
        if p < 10
          p = 10
        end
        percent = p.to_f
        percent /= 100
        heal_hp = (actor.maxhp / 3).to_f
        heal_hp *= percent
        heal_hp = Integer(heal_hp)
        heal_ft = p / 2
        heal_ex = p
        actor.hp += heal_hp
        actor.fatigue += heal_ft
        actor.exertion -= heal_ex
        actor.damage = heal_hp * -1
        actor.fatigue_damage = heal_ft * -1
        actor.exertion_damage = heal_ex * -1
        actor.leukocite = -1
      end
      actor.leukocite -= 1
    end
  end
end
# -----------------------
def shaping_magnetism
  a = @resolving_skill.scope == 1
  b = @resolving_skill.scope == 8
  c = @resolving_skill.scope == 11
  for battler in $game_troop.enemies
    if not @target_battlers.include?(battler)
      if a or b or c
        if battler.exist?
          if battler.shaping_magnet
            battler.shaping_magnet = false
           @target_battlers.push(battler)
          end
        end
      end
    end
  end
end
# -----------------------
def imperator
  for actor in $game_party.actors
    if actor.armor4_id == 35
      if actor.dead?
        actor.damage = "Revive!"
        actor.damage_pop = true
        actor.hp = 1
        if actor.fatigue >= -99
          actor.fatigue = -99
        end
        actor.exertion = 500
      end
    end
  end
end
# -----------------------
def doom
  for actor in $game_party.actors
    if actor.doom_count > 0
      actor.doom_count -= 1
      if actor.doom_count % 20 == 0
        countdown = actor.doom_count / 40
        text = countdown.to_s
        spr = @spriteset.countdown_sprites[actor.index].bitmap
        spr.clear
        spr.font.color = Color.new(255, 0, 0, 255)
        spr.draw_text(0, 0, 24, 32, text, 1)
      end
      if actor.doom_count == 0
        actor.hp = 0
        actor.doom_count = -1
        spr = @spriteset.countdown_sprites[actor.index].bitmap
        spr.clear
      end
    end
  end
end
# -----------------------
def erase_all_pictures
  for i in 51..100
    $game_screen.pictures[i].erase
  end
end
# -----------------------
def kill_countdown(actor)
  actor.doom_count = -1
  spr = @spriteset.countdown_sprites[actor.index].bitmap
  spr.clear
end
# -----------------------
def show_combo(level)
  @spriteset.show_combo_sprite(level)
end
# -----------------------
def combo_break(kill_all)
  for actor in $game_party.actors
    a = actor.hp < actor.combo_hp
    b = actor.armor4_id != 36
    c = kill_all
    if a or b or c
      actor.combo_level = 0
    end
  end
end
# -----------------------
def isolate
  r = rand(100)
  if r < 25
    for actor in $game_party.actors
      actor.isolate = false
    end
    b = rand($game_temp.echo_target_battlers.size)
    $game_temp.echo_target_battlers[b].isolate = true
    $game_temp.echo_target_battlers[b].damage = "Isolate!"
    $game_temp.echo_target_battlers[b].damage_pop = true
  end
end
# -----------------------
def set_next_target_group(side)
  @next_target_group = side
end
# -----------------------
def get_group_scope_change(skill)
  result = 0
  if @next_target_group == 1 && @resolving_battler.is_a?(Game_Actor)
     @next_target_group = 0
    if skill.scope == 1
      result = 1
    end
    if skill.scope == 3
      result = 1
    end
    if skill.scope == 5
      result = 1
    end
  end
  if @next_target_group == -1 && @resolving_battler.is_a?(Game_Enemy)
    @next_target_group = 0
    if skill.scope == 1
      result = 1
    end
    if skill.scope == 3
      result = 1
    end
    if skill.scope == 5
      result = 1
    end
  end
  return result
end
# -----------------------
def enzyme_power
  exhaustion = 0
  for actor in $game_party.actors
    hp = actor.hp
    mhp = actor.maxhp
    percent = hp * 100 / mhp
    exhaustion += 100 - percent
  end
  if $game_party.actors.size > 0
    exhaustion /= $game_party.actors.size
  end
  exhaustion /= -3
  $data_skills[136].power = exhaustion - 27
end
# -----------------------
def set_echo
  $game_temp.echo_resolving_battler = @resolving_battler.clone
  if @target_battlers != nil
    $game_temp.echo_target_battlers = @target_battlers.clone
  end
end
# -----------------------
def reassign_index
  for i in 0..$game_troop.enemies.size - 1
    $game_troop.enemies[i].member_index = i
  end
end
# -----------------------
def kill_support_crush
  for actor in $game_party.actors
    actor.support_crush = false
  end
end
# -----------------------
def create_shields
  for actor in $game_party.actors
    if actor.equipped_auto_abilities.include?(149)
      actor.hp_shield = 30
    end
  end
end
# -----------------------
end