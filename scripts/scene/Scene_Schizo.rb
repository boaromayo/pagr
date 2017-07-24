class Scene_Schizo
# ---------------------
def main
  @schizo_window = Window_Schizo.new
  @frame_count = 0
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
  @schizo_window.dispose
end
# ---------------------
def update
  @frame_count += 1
  @schizo_window.update
  if @frame_count % 3 == 0
    @schizo_window.refresh
  end
  $game_system.menu_encounters
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(3)
    return
  end
end
# ---------------------
end