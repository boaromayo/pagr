class Window_ConfigCommand < Window_Selectable
# ------------------------------
  def initialize(width, commands)
    super(0, 0, width, commands.size * 51 + 32)
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 51)
    refresh
    self.index = 0
  end
# ------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    for i in 0...@item_max
      draw_item(i, normal_color)
    end
  end
# ------------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(4, 51 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index])
  end
# ------------------------------
  def update_cursor_rect
    if self.index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, self.index * 51, width - 32, 32)
    end
  end
end
