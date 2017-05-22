class Window_Music < Window_Selectable
# ----------------------------
attr_reader :track_list
# ----------------------------
def initialize(y, track_list)
  @track_list = track_list
  height = @track_list.size * 32 + 32
  super(132, y, 400, height)
  @item_max = @track_list.size
  @row_max = @track_list.size
  @column_max = 1
  self.contents = Bitmap.new(width - 32, height - 32)
  self.z = 2650
  refresh
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  draw_y = 0
  note_img = Bitmap.new("Graphics/stuff/micro-31.png")
  for music in 0..@track_list.size - 1
    self.contents.blt(2, draw_y + 2, note_img, Rect.new(0, 0, 28, 28))
    self.contents.draw_text(32, draw_y, 336, 32, @track_list[music].to_s)
    draw_y += 32
  end
end
# ----------------------------
end
