class Scene_Config
#-----------------------------
def main
  c1 = "Message Speed"
  c2 = "Battle Message Speed"
  c3 = "Battle Status Update"
  c4 = "Menu Cursor"
  c5 = "Author Comments"
  c6 = "Window Style"
  commands = [c1, c2, c3, c4, c5, c6]
  @command_window = Window_ConfigCommand.new(287, commands)
  @command_window.x = 16
  @command_window.y = 8
  @command_window.z = 5000
  @command_window.opacity = 0
  @option_window1_a = Window_Command.new(100, ["Fast"])
  @option_window1_a.x = 320
  @option_window1_a.y = 8
  @option_window1_a.z = 5000
  @option_window1_a.opacity = 0
  @option_window1_b = Window_Command.new(100, ["Slow"])
  @option_window1_b.x = 420
  @option_window1_b.y = 8
  @option_window1_b.z = 5000
  @option_window1_b.opacity = 0
  @option_window1_c = Window_Command.new(100, ["Instant"])
  @option_window1_c.x = 520
  @option_window1_c.y = 8
  @option_window1_c.z = 5000
  @option_window1_c.opacity = 0
  @option_window4_a = Window_Command.new(140, ["Initialize"])
  @option_window4_a.x = 320
  @option_window4_a.y = 161
  @option_window4_a.z = 5000
  @option_window4_a.opacity = 0
  @option_window4_b = Window_Command.new(144, ["Memorize"])
  @option_window4_b.x = 448
  @option_window4_b.y = 161
  @option_window4_b.z = 5000
  @option_window4_b.opacity = 0
  @option_window5_a = Window_Command.new(128, ["Show"])
  @option_window5_a.x = 320
  @option_window5_a.y = 212
  @option_window5_a.z = 5000
  @option_window5_a.opacity = 0
  @option_window5_b = Window_Command.new(160, ["Don't Show"])
  @option_window5_b.x = 448
  @option_window5_b.y = 212
  @option_window5_b.z = 5000
  @option_window5_b.opacity = 0
  @option_window6_a = Window_Command.new(52, ["1"])
  @option_window6_a.x = 320
  @option_window6_a.y = 263
  @option_window6_a.z = 5000
  @option_window6_a.opacity = 0
  @option_window6_b = Window_Command.new(52, ["2"])
  @option_window6_b.x = 360
  @option_window6_b.y = 263
  @option_window6_b.z = 5000
  @option_window6_b.opacity = 0
  @option_window6_c = Window_Command.new(52, ["3"])
  @option_window6_c.x = 400
  @option_window6_c.y = 263
  @option_window6_c.z = 5000
  @option_window6_c.opacity = 0
  @option_window6_d = Window_Command.new(52, ["4"])
  @option_window6_d.x = 440
  @option_window6_d.y = 263
  @option_window6_d.z = 5000
  @option_window6_d.opacity = 0
  @main_window = Window_Base.new(0, 0, 640, 352)
  @main_window.contents = Bitmap.new(608, 320)
  @main_window.contents.font.name = "Arial"
  @main_window.contents.font.size = 24
  @info_window = Window_ConfigInfo.new
  @command_window.active = true
  @last_command_index = -1
  @command_index = -1
  set_values
  draw_battle_text
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
  @option_window1_a.dispose
  @option_window1_b.dispose
  @option_window1_c.dispose
  @option_window4_a.dispose
  @option_window4_b.dispose
  @option_window5_a.dispose
  @option_window5_b.dispose
  @option_window6_a.dispose
  @option_window6_b.dispose
  @option_window6_c.dispose
  @option_window6_d.dispose
end
#-----------------------------
def update
  @command_index = @command_window.index
  if @command_index != @last_command_index
    @last_command_index = @command_window.index
    @info_window.show_data(@command_window.index)
  end
  @command_window.update
  @main_window.update
  @info_window.update
  if @command_window.active
    update_command
    return
  end
end
#-----------------------------
def update_command
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(6)
    return
  end
  if Input.trigger?(Input::RIGHT)
    $game_system.se_play($data_system.cursor_se)
    case @command_window.index
    when 0
      if $game_system.map_message_type == 1
        $game_system.map_message_type = 2
      end
      if $game_system.map_message_type == 0
        $game_system.map_message_type = 1
      end
    when 1
      $game_system.battle_message_speed += 1
      battle_message_speed_bounds_check
      draw_battle_text
    when 2
      $game_system.battle_frame_update += 1
      battle_update_speed_bounds_check
      draw_battle_text
    when 3
      if $game_system.cursor_memory == 0
        $game_system.cursor_memory = 1
      end
    when 4
      if $game_system.author_comments == 1
        $game_system.author_comments = 0
      end
    when 5
      if $game_system.window_style < 4
        $game_system.window_style += 1
      end
    end
    set_values
    change_window_skin
    return
  end
  if Input.trigger?(Input::LEFT)
    $game_system.se_play($data_system.cursor_se)
    case @command_window.index
    when 0
      if $game_system.map_message_type == 1
        $game_system.map_message_type = 0
      end
      if $game_system.map_message_type == 2
        $game_system.map_message_type = 1
      end
    when 1
      $game_system.battle_message_speed -= 1
      battle_message_speed_bounds_check
      draw_battle_text
    when 2
      $game_system.battle_frame_update -= 1
      battle_update_speed_bounds_check
      draw_battle_text
    when 3
      if $game_system.cursor_memory == 1
        $game_system.cursor_memory = 0
      end
    when 4
      if $game_system.author_comments == 0
        $game_system.author_comments = 1
      end
    when 5
      if $game_system.window_style > 1
        $game_system.window_style -= 1
      end
    end
    set_values
    change_window_skin
    return
  end
  if Input.trigger?(Input::L)
    $game_system.se_play($data_system.cursor_se)
    case @command_window.index
    when 1
      $game_system.battle_message_speed -= 10
      battle_message_speed_bounds_check
      draw_battle_text
    when 2
      $game_system.battle_frame_update -= 5
      battle_update_speed_bounds_check
      draw_battle_text
    end
    set_values
    change_window_skin
    return
  end
  if Input.trigger?(Input::R)
    $game_system.se_play($data_system.cursor_se)
    case @command_window.index
    when 1
      $game_system.battle_message_speed += 10
      battle_message_speed_bounds_check
      draw_battle_text
    when 2
      $game_system.battle_frame_update += 5
      battle_update_speed_bounds_check
      draw_battle_text
    end
    set_values
    change_window_skin
    return
  end
end
#-----------------------------
def set_values
  @option_window1_a.index = -1
  @option_window1_b.index = -1
  @option_window1_c.index = -1
  @option_window4_a.index = -1
  @option_window4_b.index = -1
  @option_window5_a.index = -1
  @option_window5_b.index = -1
  @option_window6_a.index = -1
  @option_window6_b.index = -1
  @option_window6_c.index = -1
  @option_window6_d.index = -1
  if $game_system.map_message_type == 0
    @option_window1_a.index = 0
  end
  if $game_system.map_message_type == 1
    @option_window1_b.index = 0
  end
  if $game_system.map_message_type == 2
    @option_window1_c.index = 0
  end
  if $game_system.cursor_memory == 0
    @option_window4_a.index = 0
  end
  if $game_system.cursor_memory == 1
    @option_window4_b.index = 0
  end
  if $game_system.author_comments == 1
    @option_window5_a.index = 0
  end
  if $game_system.author_comments == 0
    @option_window5_b.index = 0
  end
  if $game_system.window_style == 1
    @option_window6_a.index = 0
  end
  if $game_system.window_style == 2
    @option_window6_b.index = 0
  end
  if $game_system.window_style == 3
    @option_window6_c.index = 0
  end
  if $game_system.window_style == 4
    @option_window6_d.index = 0
  end
end
#-----------------------------
def draw_battle_text
  @main_window.contents.clear
  number = $game_system.battle_message_speed.to_s
  @main_window.contents.draw_text(320, 59, 40, 32, number)
  number = $game_system.battle_frame_update.to_s
  @main_window.contents.draw_text(320, 110, 40, 32, number)
end
#-----------------------------
def battle_message_speed_bounds_check
  if $game_system.battle_message_speed < 100
    $game_system.battle_message_speed = 100
  end
  if $game_system.battle_message_speed > 300
    $game_system.battle_message_speed = 300
  end
end
#-----------------------------
def battle_update_speed_bounds_check
  if $game_system.battle_frame_update < 1
    $game_system.battle_frame_update = 1
  end
  if $game_system.battle_frame_update > 20
    $game_system.battle_frame_update = 20
  end
end
#-----------------------------
def change_window_skin
  if $game_system.window_style == 1
    $game_system.windowskin_name = "blueskin"
  end
  if $game_system.window_style == 2
    $game_system.windowskin_name = "redskin"
  end
  if $game_system.window_style == 3
    $game_system.windowskin_name = "greenskin"
  end
  if $game_system.window_style == 4
    $game_system.windowskin_name = "blackskin"
  end
end
#-----------------------------
end