class Window_MapEffects < Window_Base
# --------------------------------
def initialize
  super(0, 0, 284, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  self.z = 5000
  refresh
end
# --------------------------------
def refresh
  n = $game_mapeffects.number_running
  show_y = 4
  if n == 0
    self.contents.clear
    self.visible = false
    return
  else
    self.visible = true
    self.x = 0
    self.y = 444 - n * 32
    self.height = n * 32 + 40
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.clear
    c = Color.new(0, 0, 0, 64)
    self.contents.fill_rect(0, 0, width - 32, height - 32, c)
  end
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  for effect in $game_mapeffects.effects
    if effect.running?
      bitmap = effect.icon
      self.contents.blt(8, show_y + 4, bitmap, Rect.new(0, 0, 24, 24))
      self.contents.draw_text(40, show_y + 4, 200, 16, effect.name)
      dur_string = effect.get_duration_string
      self.contents.draw_text(176, show_y + 4, 64, 16, dur_string, 2)
      draw_duration_bar(40, show_y + 20, 200, effect)
      show_y += 32
    end
  end
end
# --------------------------------
def draw_duration_bar(x, y, length, effect)
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 128))
  gradient_red_start = 255
  gradient_red_end = 255
  gradient_green_start = 144
  gradient_green_end = 0
  gradient_blue_start = 74
  gradient_blue_end = 0
  draw_bar_percent = effect.duration * 100 / effect.max_duration
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
