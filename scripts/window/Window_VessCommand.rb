class Window_VessCommand < Window_Selectable
#-----------------------------
  def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    @commands = ["Synthesize", "Bifurcate", "Exit"]
    @item_max = 3
    @column_max = 3
    draw_item(0, normal_color)
    draw_item(1, normal_color)
    draw_item(2, normal_color)
    self.active = false
    self.index = 0
  end
#-----------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(index * 160 + 4, 0, 128 - 10, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index], 1)
  end
#-----------------------------
  def update_cursor_rect
    self.cursor_rect.set(index * 160, 0, 128, 32)
  end
end
