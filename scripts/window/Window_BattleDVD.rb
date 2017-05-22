class Window_BattleDVD < Window_Selectable
# ----------------------------
def initialize(data)
  @data = data
  height = @data.size * 32 + 48
  super(50, 100, 540, height)
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
  self.contents.font.size = 12
  self.contents.draw_text(90, 0, 48, 12, "Monster")
  self.contents.draw_text(350, 0, 48, 12, "Featured in")
  self.contents.font.size = 24
  draw_y = 16
  atonement = "Atonement"
  phylo = "Phylomortis"
  phylo2 = "Phylomortis II: ToD"
  phylo_ag = "Phylomortis: Avant-Garde"
  dvd_img = Bitmap.new("Graphics/stuff/micro-30.png")
  for dvd in 0..@data.size - 1
    self.contents.blt(2, draw_y + 2, dvd_img, Rect.new(0, 0, 28, 28))
    case @data[dvd]
    when 1
      self.contents.draw_text(32, draw_y, 214, 32, "Aquabomination")
      self.contents.draw_text(262, draw_y, 302, 32, phylo2)
    when 2
      self.contents.draw_text(32, draw_y, 336, 32, "MONSTER NAME 2")
      self.contents.draw_text(232, draw_y, 200, 32, "GAME NAME 2")
    when 3
      self.contents.draw_text(32, draw_y, 336, 32, "MONSTER NAME 3")
      self.contents.draw_text(232, draw_y, 200, 32, "GAME NAME 3")
    end
    draw_y += 32
  end
end
# ----------------------------
def update_cursor_rect
  if self.index < 0
    self.cursor_rect.empty
  end
  if self.index >= 0
    self.cursor_rect.set(0, self.index * 32 + 16, self.width - 32, 32)
  end
end
# ----------------------------
end
