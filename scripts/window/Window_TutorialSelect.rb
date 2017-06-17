class Window_TutorialSelect < Window_Selectable
# ----------------------------
def initialize
  super(0, 0, 256, 480)
  self.contents = Bitmap.new(width - 32, height - 32)
  refresh
end
# ----------------------------
def refresh
  self.contents.dispose
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  new_pic = Bitmap.new("Graphics/Stuff/new-tut.png")
  @item_max = $game_system.tutorials.size
  value = 0
  for tutorial in $game_system.tutorials
    if $game_system.new_tutorials.include?(tutorial)
      new_tut = true
    else
      new_tut = false
    end
    if tutorial == 1
      self.contents.draw_text(4, value, 208, 32, "Succor Interfaces")
    end
    if tutorial == 2
      self.contents.draw_text(4, value, 208, 32, "Command Abilities")
    end
    if tutorial == 3
      self.contents.draw_text(4, value, 208, 32, "VESS System")
    end
    if tutorial == 4
      self.contents.draw_text(4, value, 208, 32, "Status Effects")
    end
    if tutorial == 5
      self.contents.draw_text(4, value, 208, 32, "Battle System")
    end
    if tutorial == 6
      self.contents.draw_text(4, value, 208, 32, "F. Cognition System")
    end
    if tutorial == 7
      self.contents.draw_text(4, value, 208, 32, "Auto-Abilities")
    end
    if tutorial == 8
      self.contents.draw_text(4, value, 208, 32, "SADS System")
    end
    if new_tut
      self.contents.blt(180, value + 10, new_pic, Rect.new(0, 0, 40, 16))
    end
    value += 32
  end
end
# ----------------------------
end
