class Window_CD < Window_Selectable
# ----------------------------
def initialize(data)
  @data = data
  height = @data.size * 32 + 32
  super(100, 100, 400, height)
  @item_max = data.size
  @row_max = data.size
  @column_max = 1
  self.contents = Bitmap.new(width - 32, height - 32)
  self.index = 0
  refresh
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  draw_y = 0
  cd_img = Bitmap.new("Graphics/stuff/micro-30.png")
  disc1 = "Phylomortician\'s Shaping Symphony"
  disc2 = "Civilization and Strife"
  for cd in 0..@data.size - 1
    self.contents.blt(2, draw_y + 2, cd_img, Rect.new(0, 0, 28, 28))
    case @data[cd]
    when 1
      self.contents.draw_text(32, draw_y, 336, 32, disc1)
    when 2
      self.contents.draw_text(32, draw_y, 336, 32, disc2)
    when 3
      self.contents.draw_text(32, draw_y, 336, 32, "OMG CD NAME 3")
    end
    draw_y += 32
  end
end
# ----------------------------
end
