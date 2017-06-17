class Window_BattleAI < Window_Selectable
# --------------------------------
def initialize
  super(130, 320, 440, 160)
  @actor = $game_actors[1]
  @item_max = 4
  @tactic1 = ""
  @tactic2 = ""
  @tactic3 = ""
  @tactic4 = ""
  self.index = 0
  self.z = 3000
  self.back_opacity = 255
  self.contents = Bitmap.new(width - 32, height - 32)
  get_tactics
  refresh
end
# --------------------------------
def set_actor(actor_id)
  @actor = $game_actors[actor_id]
  t = @actor.current_tactic
  if t == @actor.ai_tactics[0]
    self.index = 0
  end
  if t == @actor.ai_tactics[1]
    self.index = 1
  end
  if t == @actor.ai_tactics[2]
    self.index = 2
  end
  if t == @actor.ai_tactics[3]
    self.index = 3
  end
  get_tactics
  refresh
end
# --------------------------------
def refresh
  if @actor.ai_tactics.size == 0
    self.contents.clear
    return
  end
  ptr_graphic = Bitmap.new("Graphics/Stuff/ai02.png")
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  self.contents.draw_text(20, 0, 392, 32, @tactic1)
  self.contents.draw_text(20, 32, 392, 32, @tactic2)
  self.contents.draw_text(20, 64, 392, 32, @tactic3)
  self.contents.draw_text(20, 96, 392, 32, @tactic4)
  if @actor.current_tactic == @actor.ai_tactics[0]
     self.contents.blt(4, 7, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if @actor.current_tactic == @actor.ai_tactics[1]
    self.contents.blt(4, 39, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if @actor.current_tactic == @actor.ai_tactics[2]
    self.contents.blt(4, 71, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
  if @actor.current_tactic == @actor.ai_tactics[3]
    self.contents.blt(4, 103, ptr_graphic, Rect.new(0, 0, 16, 16))
  end
end
# --------------------------------
def get_tactics
  if @actor.ai_tactics.size == 0
    return
  end
  @tactic1 = tactic_name(@actor.ai_tactics[0])
  @tactic2 = tactic_name(@actor.ai_tactics[1])
  @tactic3 = tactic_name(@actor.ai_tactics[2])
  @tactic4 = tactic_name(@actor.ai_tactics[3])
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
# --------------------------------
end
