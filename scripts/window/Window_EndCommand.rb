class Window_EndCommand < Window_Selectable
# --------------------------
def initialize
  super(80, 256, 480, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.back_opacity = 160
  @commands = ["Yes", "No"]
  @item_max = 2
  @column_max = 2
  draw_item(0)
  draw_item(1)
  self.active = true
  self.visible = true
  self.index = 1
  self.opacity = 0
end
# --------------------------
def draw_item(index)
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  rect = Rect.new(84 + index * 160 + 4, 0, 128 - 10, 32)
  self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
  self.contents.draw_text(rect, @commands[index], 1)
end
# --------------------------
def update_cursor_rect
  self.cursor_rect.set(84 + index * 160, 0, 128, 32)
end
# --------------------------
end
