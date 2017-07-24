class Scene_Tutorial
# ------------------
def main
  @select_window = Window_TutorialSelect.new
  @frame_window = Window_TutorialFrame.new
  @header_window = Window_TutorialHeader.new
  @footer_window = Window_TutorialFooter.new
  @data_window = Window_TutorialData.new
  @frame_window.z = 1000
  @header_window.z = 1100
  @footer_window.z = 1200
  @data_window.z = 1300
  @select_window.index = 0
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
  @select_window.dispose
  @frame_window.dispose
  @header_window.dispose
  @footer_window.dispose
  @data_window.dispose
end
# ------------------
def update
  @select_window.update
  @frame_window.update
  @header_window.update
  @footer_window.update
  @data_window.update
  if @select_window.active
    update_select
    return
  end
end
# ------------------
def update_select
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(5)
    return
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    t = $game_system.tutorials[@select_window.index]
    if $game_system.new_tutorials.include?(t)
      $game_system.new_tutorials.delete(t)
      @select_window.refresh
    end
    @data_window.oy = 0
    @header_window.tutorial = t
    @footer_window.tutorial = t
    @data_window.tutorial = t
    return
  end
  if Input.repeat?(Input::L)
    if @data_window.contents.height < 416
      $game_system.se_play($data_system.buzzer_se)
    elsif @data_window.oy == 0
      $game_system.se_play($data_system.buzzer_se)
    else
      $game_system.se_play($data_system.cursor_se)
      @data_window.oy -= 16
      if @data_window.oy < 0
        @data_window.oy = 0
      end
      @data_window.refresh
    end
    return
  end
  if Input.repeat?(Input::R)
    if @data_window.contents.height < 416
      $game_system.se_play($data_system.buzzer_se)
    elsif @data_window.oy == @data_window.contents.height - 384
      $game_system.se_play($data_system.buzzer_se)
    else
      $game_system.se_play($data_system.cursor_se)
      @data_window.oy += 16
      @data_window.refresh
    end
    return
  end
end
# ------------------
end