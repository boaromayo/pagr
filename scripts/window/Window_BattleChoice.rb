class Window_BattleChoice < Window_Base
#-------------------------------
  def initialize
    @choices = $game_temp.battle_choices
    @item_max = $game_temp.battle_choices.size
    @index = 0
    @dummy_window = Window_Base.new(20, 10, 600, 25 + @item_max * 32)
    @dummy_window.visible = true
    @dummy_window.z = 1100
    super(20, 10, 600, 28 + @item_max * 32)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 2000
    self.opacity = 0
    refresh
  end
# -------------------------------
  def clear
    $game_system.se_play($data_system.decision_se)
    $game_temp.choice_proc.call(@index)
    $game_temp.message_text = nil
    $game_temp.message_proc = nil
    $game_temp.choice_start = 99
    $game_temp.choice_max = 0
    $game_temp.choice_cancel_type = 0
    $game_temp.choice_proc = nil
    $game_temp.battle_choices = []
    $game_temp.remove_battle_message = 10
    @dummy_window.dispose
    self.visible = false
    self.active = false
    self.dispose
  end
# -------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    for i in 0..@choices.size - 1
      text = @choices[i]
      self.contents.draw_text(4, i * 32, 560, 32, text)
    end
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def update
    super
    if self.active
      if Input.trigger?(Input::UP)
        $game_system.se_play($data_system.cursor_se)
        unless @index <= 0
          @index -= 1
        end
      end
      if Input.trigger?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        unless @index >= @item_max - 1
          @index += 1
        end
      end
    end
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index <= -1
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 32, 560, 32)
    end
  end
end
