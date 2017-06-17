class Window_TutorialHeader < Window_Base
# ----------------------------
attr_accessor :tutorial
# ----------------------------
def initialize
  super(256, 0, 384, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  @tutorial = 0
  self.opacity = 0
  refresh
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  case @tutorial
  when 1
    show_tut1
  when 2
    show_tut2
  when 3
    show_tut3
  when 4
    show_tut4
  when 5
    show_tut5
  when 6
    show_tut6
  when 7
    show_tut7
  when 8
    show_tut8
  end
end
# ----------------------------
def tutorial=(value)
  @tutorial = value
  refresh
end
# ----------------------------
def show_tut1
  self.contents.draw_text(4, 0, 348, 32, "Succor Interfaces", 2)
  draw_header_line
end
# ----------------------------
def show_tut2
  self.contents.draw_text(4, 0, 348, 32, "Command Abilities", 2)
  draw_header_line
end
# ----------------------------
def show_tut3
  self.contents.draw_text(4, 0, 348, 32, "VESS System", 2)
  draw_header_line
end
# ----------------------------
def show_tut4
  self.contents.draw_text(4, 0, 348, 32, "Status Effects", 2)
  draw_header_line
end
# ----------------------------
def show_tut5
  self.contents.draw_text(4, 0, 348, 32, "Battle System", 2)
  draw_header_line
end
# ----------------------------
def show_tut6
  self.contents.draw_text(4, 0, 348, 32, "Fractured Cognition System", 2)
  draw_header_line
end
# ----------------------------
def show_tut7
  self.contents.draw_text(4, 0, 348, 32, "Auto-Abilities", 2)
  draw_header_line
end
# ----------------------------
def show_tut8
  self.contents.draw_text(4, 0, 348, 32, "SADS System", 2)
  draw_header_line
end
# ----------------------------
def draw_header_line
  rect = Rect.new(4, 30, 352, 1)
  self.contents.fill_rect(rect, normal_color)
end
# ----------------------------
end
