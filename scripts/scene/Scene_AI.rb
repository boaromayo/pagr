class Scene_AI
# -----------------------
def initialize(actor)
  @actor = actor
end
# -----------------------
  def main
  @ai_window = Window_MenuAI.new(@actor)
  @ai_window.active = true
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
  @ai_window.dispose
end
# -----------------------
def update
  @ai_window.update
  if @ai_window.active
    update_ai
    return
  end
end
# -----------------------
def update_ai
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Menu.new(3)
    return
  end
  if Input.trigger?(Input::C)
    if @ai_window.index <= 3
      $game_system.se_play($data_system.decision_se)
      t = @actor.ai_tactics[@ai_window.index]
      @actor.current_tactic = t
      @ai_window.refresh
      return
    end
  end
  if Input.trigger?(Input::LEFT)
    $game_system.se_play($data_system.cursor_se)
    if @ai_window.index == 4
      @actor.ai_ft_limit -= 1
      check_bounds
      @ai_window.refresh
      return
    end
    if @ai_window.index == 5
      @actor.ai_ex_limit -= 10
      check_bounds
      @ai_window.refresh
      return
    end
  end
  if Input.trigger?(Input::RIGHT)
    $game_system.se_play($data_system.cursor_se)
    if @ai_window.index == 4
      @actor.ai_ft_limit += 1
      check_bounds
      @ai_window.refresh
      return
    end
    if @ai_window.index == 5
      @actor.ai_ex_limit += 10
      check_bounds
      @ai_window.refresh
      return
    end
  end
  if Input.trigger?(Input::L)
    $game_system.se_play($data_system.cursor_se)
    if @ai_window.index == 4
      @actor.ai_ft_limit -= 5
      check_bounds
      @ai_window.refresh
      return
    end
    if @ai_window.index == 5
      @actor.ai_ex_limit -= 100
      check_bounds
      @ai_window.refresh
      return
    end
  end
  if Input.trigger?(Input::R)
    $game_system.se_play($data_system.cursor_se)
    if @ai_window.index == 4
      @actor.ai_ft_limit += 5
      check_bounds
      @ai_window.refresh
      return
    end
    if @ai_window.index == 5
      @actor.ai_ex_limit += 100
      check_bounds
      @ai_window.refresh
      return
    end
  end
end
# -----------------------
def check_bounds
  if @actor.ai_ft_limit >= 100
    @actor.ai_ft_limit = 100
  end
  if @actor.ai_ft_limit <= -100
    @actor.ai_ft_limit = -100
  end
  if @actor.ai_ex_limit >= 1000
    @actor.ai_ex_limit = 1000
  end
  if @actor.ai_ex_limit <= 0
    @actor.ai_ex_limit = 0
  end
end
# -----------------------
end
