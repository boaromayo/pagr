class Window_Escape < Window_Base
# --------------------------------
def initialize
  super(440, 256, 192, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  self.z = 5000
  refresh
end
# --------------------------------
def refresh
  if $scene.is_a?(Scene_Battle)
    @escape_progress = $scene.escape_progress
    if @escape_progress > 10000
      @escape_progress = 10000
    end
    if @escape_progress == 0
      self.contents.clear
      self.visible = false
      return
    else
      self.visible = true
      self.contents.clear
      c = Color.new(0, 0, 0, 64)
      self.contents.fill_rect(0, 0, width - 32, height - 32, c)
    end
    self.contents.font.name = "Arial"
    self.contents.font.size = 16
    self.contents.draw_text(8, 4, 200, 16, "Escape")
    if @escape_progress == -1
      self.contents.font.size = 10
      self.contents.draw_text(8, 20, 200, 10, "Cannot Escape", 1)
    end
    draw_escape_bar(8, 20, 144)
  end
end
# --------------------------------
def draw_escape_bar(x, y, length)
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 128))
  gradient_red_start = 255
  gradient_red_end = 255
  gradient_green_start = 144
  gradient_green_end = 0
  gradient_blue_start = 74
  gradient_blue_end = 0
  draw_bar_percent = @escape_progress / 100
  for x_coord in 1..length
    current_percent_done = x_coord * 100 / length
    difference = gradient_red_end - gradient_red_start
    red = gradient_red_start + difference * x_coord / length
    difference = gradient_green_end - gradient_green_start
    green = gradient_green_start + difference * x_coord / length
    difference = gradient_blue_end - gradient_blue_start
    blue = gradient_blue_start + difference * x_coord / length
    if current_percent_done <= draw_bar_percent
      rect = Rect.new(x + x_coord-1, y, 1, 3)
      self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
    end
  end
end
# --------------------------------
end
