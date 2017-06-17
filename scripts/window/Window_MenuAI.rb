class Window_MenuAI < Window_Base
# ------------------------------
attr_reader :index
# ------------------------------
def initialize(actor)
  super(0, 0, 640, 480)
  @actor = actor
  @index = 0
  @tactic1 = ""
  @tactic2 = ""
  @tactic3 = ""
  @tactic4 = ""
  self.contents = Bitmap.new(608, 448)
  refresh
end
# ------------------------------
def setup
  ptr_graphic = Bitmap.new("Graphics/Stuff/ai02.png")
  t = @actor.current_tactic
  if t == @actor.ai_tactics[0]
    self.contents.blt(4, 47, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if t == @actor.ai_tactics[1]
    self.contents.blt(4, 79, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if t == @actor.ai_tactics[2]
    self.contents.blt(4, 111, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if t == @actor.ai_tactics[3]
    self.contents.blt(4, 143, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if @index >= 4
    return
  end
  if t == @actor.ai_tactics[0]
    @index = 0
  end
  if t == @actor.ai_tactics[1]
    @index = 1
  end
  if t == @actor.ai_tactics[2]
    @index = 2
  end
  if t == @actor.ai_tactics[3]
    @index = 3
  end
  update_cursor_rect
end
# ------------------------------
def refresh
  c_button = RPG::Cache.icon("talk05")
  l_button = RPG::Cache.icon("talk04")
  r_button = RPG::Cache.icon("talk03")
  text1 = "AI Settings for " + @actor.name
  text2 = "Don't Act Unless FT is above:"
  text3 = "Don't Act Unless EX is below:"
  text4 = @actor.ai_ft_limit.to_s
  text5 = @actor.ai_ex_limit.to_s + "%"
  text6 = ": Select Option"
  text7 = ": Change FT/EX Limits (small)"
  text8 = ": Select Tactic"
  text9 = ": Change FT/EX Limits (large)"
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  get_tactics
  setup
  draw_lines
  self.contents.blt(16, 324, c_button, Rect.new(0, 0, 24, 24))
  self.contents.blt(16, 350, l_button, Rect.new(0, 0, 24, 24))
  self.contents.blt(47, 350, r_button, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(20, 0, 250, 32, text1)
  self.contents.draw_text(20, 40, 380, 32, @tactic1)
  self.contents.draw_text(20, 72, 380, 32, @tactic2)
  self.contents.draw_text(20, 104, 380, 32, @tactic3)
  self.contents.draw_text(20, 136, 380, 32, @tactic4)
  self.contents.draw_text(20, 192, 300, 32, text2)
  self.contents.draw_text(20, 224, 300, 32, text3)
  self.contents.draw_text(540, 192, 48, 32, text4, 2)
  self.contents.draw_text(508, 224, 80, 32, text5, 2)
  self.contents.draw_text(40, 351, 20, 20, "/")
  self.contents.font.size = 16
  self.contents.draw_text(46, 283, 150, 16, text6)
  self.contents.draw_text(46, 306, 250, 16, text7)
  self.contents.draw_text(46, 329, 250, 16, text8)
  self.contents.draw_text(76, 353, 250, 16, text9)
end
# ------------------------------
def get_tactics
  @tactic1 = tactic_name(@actor.ai_tactics[0])
  @tactic2 = tactic_name(@actor.ai_tactics[1])
  @tactic3 = tactic_name(@actor.ai_tactics[2])
  @tactic4 = tactic_name(@actor.ai_tactics[3])
end
# ------------------------------
def draw_lines
  self.contents.fill_rect(20, 30, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 176, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 270, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 290, 9, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(21, 291, 7, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(22, 292, 5, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(23, 293, 3, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(24, 294, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(36, 290, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(35, 291, 3, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(34, 292, 5, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(33, 293, 7, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(32, 294, 9, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 314, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(21, 313, 1, 3, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(22, 312, 1, 5, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(23, 311, 1, 7, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(24, 310, 1, 9, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(30, 310, 1, 9, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(31, 311, 1, 7, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(32, 312, 1, 5, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(33, 313, 1, 3, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(34, 314, 1, 1, Color.new(255, 255, 255, 255))
end
# --------------------------------
def tactic_name(value)
  case value
  when 1
    return "Attack as much as possible!"
  when 2
    return "Conserve FT until an opportune moment!"
  when 3
    return "Focus on performing triage!"
  when 4
    return "Don't do anything!"
  end
end
# ------------------------------
def update
  super
  if Input.trigger?(Input::UP)
    $game_system.se_play($data_system.cursor_se)
    @index -= 1
    if @index < 0
      @index = 5
    end
    update_cursor_rect
    return
  end
  if Input.trigger?(Input::DOWN)
    $game_system.se_play($data_system.cursor_se)
    @index += 1
    if @index > 5
      @index = 0
    end
    update_cursor_rect
    return
  end
end
# ------------------------------
def update_cursor_rect
  if @index < 0
    self.cursor_rect.empty
  end
  if @index == 0
    self.cursor_rect.set(16, 40, 400, 32)
  end
  if @index == 1
    self.cursor_rect.set(16, 72, 400, 32)
  end
  if @index == 2
    self.cursor_rect.set(16, 104, 400, 32)
  end
  if @index == 3
    self.cursor_rect.set(16, 136, 400, 32)
  end
  if @index == 4
    self.cursor_rect.set(16, 192, 400, 32)
  end
  if @index == 5
    self.cursor_rect.set(16, 224, 400, 32)
  end
end
# ------------------------------
end