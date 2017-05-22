class Window_MonsterSelect < Window_Selectable
# ----------------------------
def initialize(data)
  @data = data
  super(384, 0, 256, 480)
  @item_max = data.size
  self.contents = Bitmap.new(width - 32, @item_max * 32 + 32)
  self.index = 0
  refresh
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  draw_y = 0
  for number in @data
    monster_name = $data_enemies[number].name
    self.contents.draw_text(4, draw_y, 168, 32, monster_name)
    draw_y += 32
  end
end
# ----------------------------
end
