class Window_MusicInfo < Window_Base
# ----------------------------
def initialize
  super(132, 320, 400, 104)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.z = 2650
  refresh(0, 50)
end
# ----------------------------
def refresh(volume, pitch)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  self.contents.draw_text(4, 0, 100, 32, "Volume")
  self.contents.draw_text(4, 32, 100, 32, "Pitch")
  white = Color.new(255, 255, 255, 255)
  @box_draw_x = 90
  @box_draw_y = 11
  boxes_to_draw = volume / 10
  while boxes_to_draw > 0
    draw_filled_box
    @box_draw_x += 16
    boxes_to_draw -= 1
  end
  boxes_to_draw = 10 - volume / 10
  while boxes_to_draw > 0
    draw_unfilled_box
    @box_draw_x += 16
    boxes_to_draw -= 1
  end
  boxes_to_draw = (pitch - 50) / 10
  @box_draw_x = 90
  @box_draw_y = 43
  while boxes_to_draw > 0
    draw_filled_box
    @box_draw_x += 16
    boxes_to_draw -= 1
  end
  boxes_to_draw = 10 - (pitch - 50) / 10
  while boxes_to_draw > 0
    draw_unfilled_box
    @box_draw_x += 16
    boxes_to_draw -= 1
  end
  self.contents.font.size = 12
  self.contents.draw_text(84, 24, 20, 12, "0%")
  self.contents.draw_text(154, 24, 20, 12, "50%")
  self.contents.draw_text(236, 24, 28, 12, "100%")
  self.contents.draw_text(84, 56, 20, 12, "50%")
  self.contents.draw_text(152, 56, 28, 12, "100%")
  self.contents.draw_text(236, 56, 28, 12, "150%")
  self.contents.draw_text(300, 9, 75, 12, "Change Volume")
  self.contents.draw_text(280, 27, 100, 12, "X/Y Change Pitch")
  self.contents.draw_text(280, 45, 100, 12, "Z Restore Defaults")
  self.contents.fill_rect(283, 10, 1, 9, white)
  self.contents.fill_rect(282, 11, 1, 7, white)
  self.contents.fill_rect(281, 12, 1, 5, white)
  self.contents.fill_rect(280, 13, 1, 3, white)
  self.contents.fill_rect(279, 14, 1, 1, white)
  self.contents.fill_rect(288, 10, 1, 9, white)
  self.contents.fill_rect(289, 11, 1, 7, white)
  self.contents.fill_rect(290, 12, 1, 5, white)
  self.contents.fill_rect(291, 13, 1, 3, white)
  self.contents.fill_rect(292, 14, 1, 1, white)
end
# ----------------------------
def draw_unfilled_box
  white = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(@box_draw_x, @box_draw_y, 12, 1, white)
  self.contents.fill_rect(@box_draw_x, @box_draw_y, 1, 12, white)
  self.contents.fill_rect(@box_draw_x + 11, @box_draw_y, 1, 12, white)
  self.contents.fill_rect(@box_draw_x, @box_draw_y + 11, 12, 1, white)
end
# ----------------------------
def draw_filled_box
  white = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(@box_draw_x, @box_draw_y, 12, 12, white)
end
# ----------------------------
end
