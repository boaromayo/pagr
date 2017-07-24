class Scene_End
# --------------------------
def main
  @bg_sprite = Sprite.new
  @bg_sprite.bitmap = Bitmap.new("Graphics/Stuff/end01.png")
  string1 = "If you quit the game, you will be returned to the "
  string2 = "title screen and all unsaved data will be lost."
  string3 = "Really quit the game?"
  @info_window = Window_Base.new(80, 160, 480, 160)
  @info_window.contents = Bitmap.new(448, 128)
  @info_window.contents.font.name = "Arial"
  @info_window.contents.font.size = 24
  @info_window.contents.draw_text(4, 0, 448, 32, string1, 1)
  @info_window.contents.draw_text(4, 32, 448, 32, string2, 1)
  @info_window.contents.draw_text(4, 64, 448, 32, string3, 1)
  @select_window = Window_EndCommand.new
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
  @bg_sprite.dispose
  @info_window.dispose
  @select_window.dispose
  if $scene.is_a?(Scene_Title)
    Graphics.transition
    Graphics.freeze
  end
end
# --------------------------
def update
  @info_window.update
  @select_window.update
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(8)
    return
  end
  if Input.trigger?(Input::C)
    case @select_window.index
    when 0
      command_to_title
    when 1
      command_cancel
    end
    return
  end
end
# --------------------------
def command_to_title
  $game_system.se_play($data_system.decision_se)
  Audio.bgm_fade(800)
  Audio.bgs_fade(800)
  Audio.me_fade(800)
  $scene = Scene_Title.new
end
# --------------------------
def command_cancel
  $game_system.se_play($data_system.decision_se)
  $scene = Scene_Menu.new(8)
end
# --------------------------
end