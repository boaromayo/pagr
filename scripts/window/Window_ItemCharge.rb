class Window_ItemCharge < Window_Base
# --------------------------------
def initialize
  super(0, 0, 132, 55)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.back_opacity = 255
  self.z = 5000
  refresh
end
# --------------------------------
def refresh
  charge = $game_temp.item_charge
  charge_string = charge.to_s + "%"
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  self.contents.draw_text(0, 0, 100, 16, "Charge")
  self.contents.draw_text(60, 0, 40, 16, charge_string, 2)
  draw_charge_bar(0, 16, 100, charge)
end
# --------------------------------
def draw_charge_bar(x, y, length, charge)
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
  gradient_red_start = 255
  gradient_red_end = 255
  gradient_green_start = 144
  gradient_green_end = 0
  gradient_blue_start = 74
  gradient_blue_end = 0
  draw_bar_percent = charge - 50
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
