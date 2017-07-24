class Scene_Vess
#-----------------------------
def main
  t1 = "Cannot synthesize with zero SP."
  t2 = "Cannot synthesize Command"
  t3 = "Abilities or Auto Abilities with"
  t4 = "less AP than the Mastery Value."
  @command_window = Window_VessCommand.new
  @main_window = Window_VessMain.new
  @info_window = Window_VessInfo.new
  @command_window.active = true
  @main_window.active = false
  @confirm_window = Window_Base.new(120, 176, 400, 64)
  @confirm_window.contents = Bitmap.new(368, 32)
  @confirm_window.contents.draw_text(0, 0, 1, 32, "")
  @confirm_window.visible = false
  @confirm_window.z = 2600
  @yes_no_window = Window_Command.new(100, ["Yes", "No"])
  @yes_no_window.visible = false
  @yes_no_window.x = 270
  @yes_no_window.y = 240
  @yes_no_window.z = 2600
  @zero_ap_window = Window_Base.new(164, 208, 312, 64)
  @zero_ap_window.contents = Bitmap.new(280, 32)
  @zero_ap_window.contents.font.name = "Arial"
  @zero_ap_window.contents.font.size = 24
  @zero_ap_window.contents.draw_text(10, 0, 274, 32, t1)
  @zero_ap_window.visible = false
  @zero_ap_window.z = 2600
  @command_ability_window = Window_Base.new(120, 160, 400, 128)
  @command_ability_window.contents = Bitmap.new(368, 96)
  @command_ability_window.contents.font.name = "Arial"
  @command_ability_window.contents.font.size = 24
  @command_ability_window.contents.draw_text(32, 0, 274, 32, t2)
  @command_ability_window.contents.draw_text(32, 32, 274, 32, t3)
  @command_ability_window.contents.draw_text(32, 64, 300, 32, t4)
  @command_ability_window.visible = false
  @command_ability_window.z = 9999
  @mode = 0
  @last_main_index = -1
  @main_index = -1
  @frame_count = -1
  @actor = $game_actors[8]
  enforce_ap_limit
  @main_window.refresh
  Graphics.transition
  loop do
    Graphics.update
    Input.update
    update
    if $scene != self
      break
    end
  end
  Graphics.freeze
  @command_window.dispose
  @main_window.dispose
  @info_window.dispose
end
#-----------------------------
def update
  if @frame_count > 0
    @frame_count -= 1
    if @frame_count == 0
      @frame_count = -1
      @zero_ap_window.visible = false
      @command_ability_window.visible = false
    end
  end
  refresh_info
  $game_system.menu_encounters
  @command_window.update
  @main_window.update
  @info_window.update
  @confirm_window.update
  @yes_no_window.update
  if @command_window.active
    update_command
    return
  end
  if @main_window.active
    update_main
    return
  end
  if @yes_no_window.active
    update_yes_no
    return
  end
end
#-----------------------------
def enforce_ap_limit
  for i in 1..$game_system.current_ap_weapon.size - 1
    if $data_weapons[i].ap_needed > 0
      if $game_system.current_ap_weapon[i] < 900000
        if $game_system.current_ap_weapon[i] > $data_weapons[i].ap_needed * 2
          $game_system.current_ap_weapon[i] = $data_weapons[i].ap_needed * 2
        end
      end
    end
  end
  for i in 1..$game_system.current_ap_armor.size - 1
    if $data_armors[i].ap_needed > 0
      if $game_system.current_ap_armor[i] < 900000
        if $game_system.current_ap_armor[i] > $data_armors[i].ap_needed * 2
          $game_system.current_ap_armor[i] = $data_armors[i].ap_needed * 2
        end
      end
    end
  end
end
#-----------------------------
def update_command
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(3)
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    case @command_window.index
    when 0
      @mode = 1
      @command_window.active = false
      @main_window.active = true
      @last_main_index = -1
    when 1
      @mode = 2
      @command_window.active = false
      @main_window.active = true
      @last_main_index = -1
    when 2
      $scene = Scene_Menu.new(3)
    end
  end
end
#-----------------------------
def update_main
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @main_window.active = false
    @command_window.active = true
    @info_window.show_data(0, 0)
    @mode = 0
  end
  if Input.trigger?(Input::C)
    if @mode == 1
      if @main_window.item.is_a?(RPG::Weapon)
        if $game_system.current_ap_weapon[@main_window.item.id] > 900000
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        if $game_system.current_ap_weapon[@main_window.item.id] == 0
          $game_system.se_play($data_system.buzzer_se)
          @zero_ap_window.visible = true
          @frame_count = 60
          return
        end
        if @main_window.item.associated_skill > 0
          skill = @main_window.item.associated_skill
          command = $data_skills[skill].command_ability?
          auto = $data_skills[skill].auto_ability?
          if command or auto
            pts = $game_system.current_ap_weapon[@main_window.item.id]
            mastered = pts >= $data_weapons[@main_window.item.id].ap_needed
            unless mastered
              $game_system.se_play($data_system.buzzer_se)
              @command_ability_window.visible = true
              @frame_count = 60
              return
            end
          end
        end
      end
      if @main_window.item.is_a?(RPG::Armor)
        if $game_system.current_ap_armor[@main_window.item.id] > 900000
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        if $game_system.current_ap_armor[@main_window.item.id] == 0
          $game_system.se_play($data_system.buzzer_se)
          @zero_ap_window.visible = true
          @frame_count = 60
          return
        end
        if @main_window.item.associated_skill > 0
          skill = @main_window.item.associated_skill
          command = $data_skills[skill].command_ability?
          auto = $data_skills[skill].auto_ability?
          if command or auto
            pts = $game_system.current_ap_armor[@main_window.item.id]
            mastered = pts >= $data_armors[@main_window.item.id].ap_needed
            unless mastered
              $game_system.se_play($data_system.buzzer_se)
              @command_ability_window.visible = true
              @frame_count = 60
              return
            end
          end
        end
      end
    end
    if @mode == 2
      if @main_window.item.is_a?(RPG::Weapon)
        if $game_system.current_ap_weapon[@main_window.item.id] < 900000
          $game_system.se_play($data_system.buzzer_se)
          return
        end
      end
      if @main_window.item.is_a?(RPG::Armor)
        if $game_system.current_ap_armor[@main_window.item.id] < 900000
          $game_system.se_play($data_system.buzzer_se)
          return
        end
      end
    end
    $game_system.se_play($data_system.decision_se)
    @main_window.active = false
    @confirm_window.visible = true
    @yes_no_window.index = 1
    @yes_no_window.active = true
    @yes_no_window.visible = true
    set_confirm_text
  end
end
#-----------------------------
def update_yes_no
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @confirm_window.visible = false
    @yes_no_window.active = false
    @yes_no_window.visible = false
    @main_window.active = true
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    case @yes_no_window.index
    when 0
      if @mode == 1
        synth
      end
       if @mode == 2
        bifurcate
      end
      @confirm_window.visible = false
      @yes_no_window.active = false
      @yes_no_window.visible = false
      @main_window.active = true
    when 1
      @confirm_window.visible = false
      @yes_no_window.active = false
      @yes_no_window.visible = false
      @main_window.active = true
    end
  end
end
#-----------------------------
def refresh_info
  if @main_window.active
    @main_index = @main_window.index
    if @last_main_index != @main_index
      @last_main_index = @main_window.index
      id = @main_window.item.id
      if @main_window.item.is_a?(RPG::Weapon)
        @info_window.show_data(1, id)
      end
      if @main_window.item.is_a?(RPG::Armor)
        @info_window.show_data(2, id)
      end
    end
  end
end
#-----------------------------
def synth
  id = @main_window.item.id
  if @main_window.item.is_a?(RPG::Weapon)
    if $game_system.current_ap_weapon[id] == 0
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    if $game_system.current_ap_weapon[id] > 900000
      $game_system.se_play($data_system.buzzer_se)
      return
    end
  end
  if @main_window.item.is_a?(RPG::Armor)
    if $game_system.current_ap_armor[id] == 0
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    if $game_system.current_ap_armor[id] > 900000
      $game_system.se_play($data_system.buzzer_se)
      return
    end
  end
  $game_system.se_play($data_system.decision_se)
  if @main_window.item.associated_skill > 0
    add_skill
  end
  if @main_window.item.associated_stat > 0
    add_parameter
  end
  if @main_window.item.is_a?(RPG::Weapon)
    $game_system.current_ap_weapon[@main_window.item.id] += 900000
    @info_window.show_data(1, @main_window.item.id)
  end
  if @main_window.item.is_a?(RPG::Armor)
    $game_system.current_ap_armor[@main_window.item.id] += 900000
    @info_window.show_data(2, @main_window.item.id)
  end
  @main_window.refresh
end
#-----------------------------
def bifurcate
  if $game_system.current_ap_weapon[@main_window.item.id] < 900000
    $game_system.se_play($data_system.buzzer_se)
    return
  end
  $game_system.se_play($data_system.decision_se)
  if @main_window.item.associated_skill > 0
    @actor.forget_skill(@main_window.item.associated_skill)
  end
  if @main_window.item.associated_stat > 0
    subtract_parameter
  end
  if @main_window.item.is_a?(RPG::Weapon)
    $game_system.current_ap_weapon[@main_window.item.id] = 1
    @info_window.show_data(1, @main_window.item.id)
  end
  if @main_window.item.is_a?(RPG::Armor)
    $game_system.current_ap_armor[@main_window.item.id] = 1
    @info_window.show_data(2, @main_window.item.id)
  end
  @main_window.refresh
end
#-----------------------------
def add_skill
  total_ap = @main_window.item.ap_needed
  if @main_window.item.is_a?(RPG::Weapon)
    current_ap = $game_system.current_ap_weapon[@main_window.item.id]
  end
  if @main_window.item.is_a?(RPG::Armor)
    current_ap = $game_system.current_ap_armor[@main_window.item.id]
  end
  s = @main_window.item.associated_skill
  if $data_skills[s].command_ability?
    @actor.learn_skill(s)
    return
  end
  if $data_skills[s].auto_ability?
    @actor.learn_skill(s)
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
  @actor.learn_skill(s)
end
#-----------------------------
def add_parameter
  base_value = @main_window.item.associated_value
  total_ap = @main_window.item.ap_needed
  if @main_window.item.is_a?(RPG::Weapon)
    current_ap = $game_system.current_ap_weapon[@main_window.item.id]
  end
  if @main_window.item.is_a?(RPG::Armor)
    current_ap = $game_system.current_ap_armor[@main_window.item.id]
  end
  if current_ap < total_ap
    points_added = current_ap * base_value / total_ap
  end
  if current_ap == total_ap
    points_added = base_value
  end
  if current_ap > total_ap
    points_added = base_value + (current_ap / 4 * base_value / total_ap)
  end
  case @main_window.item.associated_stat
  when 1
    @actor.str += points_added
  when 2
    @actor.dex += points_added
  when 3
    @actor.agi += points_added
  when 4
    @actor.int += points_added
  when 5
    @actor.maxhp += points_added
  when 6
    @actor.acumen_vectors_up += points_added
  end
end
#-----------------------------
def subtract_parameter
  if @main_window.item.is_a?(RPG::Weapon)
    $game_system.current_ap_weapon[@main_window.item.id] -= 900000
  end
  if @main_window.item.is_a?(RPG::Armor)
    $game_system.current_ap_armor[@main_window.item.id] -= 900000
  end
  base_value += @main_window.item.ssociated_value
  total_ap = @main_window.item.ap_needed
  if @main_window.item.is_a?(RPG::Weapon)
    current_ap = $game_system.current_ap_weapon[@main_window.item.id]
  end
  if @main_window.item.is_a?(RPG::Armor)
    current_ap = $game_system.current_ap_armor[@main_window.item.id]
  end
  if current_ap < total_ap
    points_added = current_ap * base_value / total_ap
  end
  if current_ap == total_ap
    points_added = base_value
  end
  if current_ap > total_ap
    points_added = base_value + current_ap / 4 * base_value / total_ap
  end
  case @main_window.item.associated_stat
  when 1
    @actor.str -= points_added
  when 2
    @actor.dex -= points_added
  when 3
    @actor.agi -= points_added
  when 4
    @actor.int -= points_added
  when 5
    @actor.maxhp -= points_added
  end
end
#-----------------------------
def set_confirm_text
  @confirm_window.contents.clear
  icon = ""
  number = 0
  item = @main_window.item
  if item.associated_skill > 0
    icon = $data_skills[item.associated_skill].icon_name
    name = $data_skills[item.associated_skill].name
  elsif item.associated_stat == 1
    name = "Strength +"
    number = item.associated_value.to_s
  elsif item.associated_stat == 2
    name = "Dexterity +"
    number = item.associated_value.to_s
  elsif item.associated_stat == 3
    name = "Agility +"
    number = item.associated_value.to_s
  elsif item.associated_stat == 4
    name = "Intelligence +"
    number = item.associated_value.to_s
  elsif item.associated_stat == 5
    name = "HP +"
    number = item.associated_value.to_s
  else
    name = "Error"
  end
  if @mode == 1
    text1 = "Really Synthesize"
  end
  if @mode == 2
    text1 = "Really Bifurcate"
  end
  text2 = name
  if number != 0
    text2 += number
  end
  text2 += "?"
  w1 = @confirm_window.contents.text_size(text1).width
  w2 = @confirm_window.contents.text_size(text2).width
  if icon == ""
    x = w1 + 12
  else
    x = w1 + 40
  end
  total_width = w2 + x + 32
  window_x = (640 - total_width) / 2
  @confirm_window.dispose
  @confirm_window = Window_Base.new(window_x, 176, total_width, 64)
  @confirm_window.contents = Bitmap.new(total_width - 32, 32)
  @confirm_window.visible = true
  @confirm_window.z = 2600
  @confirm_window.contents.font.name = "Arial"
  @confirm_window.contents.font.size = 24
  if text1 == "Really Synthesize"
    @confirm_window.contents.draw_text(4, 0, w1 + 16, 32, text1)
    @confirm_window.contents.draw_text(x, 0, w2, 32, text2)
  else
    @confirm_window.contents.draw_text(4, 0, w1 + 16, 32, text1)
    @confirm_window.contents.draw_text(x, 0, w2, 32, text2)
  end
  if icon != ""
    ic = RPG::Cache.icon(icon)
    @confirm_window.contents.blt(w1 + 12, 4, ic, Rect.new(0, 0, 24, 24))
  end
end
#-----------------------------
end