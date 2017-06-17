class Window_Law < Window_Base
# ------------------------------
def initialize
  super(0, 0, 640, 480)
  self.contents = Bitmap.new(608, 448)
  refresh
end
# ------------------------------
def refresh
  lv = $game_lawsystem.skill_level.to_s
  act = $game_lawsystem.resolving_action
  ev = $game_lawsystem.evaluation.to_s + "%"
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  self.contents.draw_text(260, 0, 150, 16, "Legal Skill LV" + lv)
  self.contents.draw_text(506, 0, 90, 16, $game_lawsystem.skill_string, 2)
  self.contents.draw_text(260, 24, 150, 16, "Case Evaluation:")
  self.contents.draw_text(506, 24, 90, 16, ev, 2)
  self.contents.draw_text(260, 47, 120, 16, "Resolving Action:")
  self.contents.draw_text(346, 47, 250, 16, $game_lawsystem.resolving_action, 2)
  draw_skill_bar(260, 17, 340)
  draw_eval_bar(260, 41, 340)
  draw_action_bar(260, 64, 340)
end
# ------------------------------
def draw_skill_bar(x, y, length)
  gradient_red_start = 0
  gradient_red_end = 0
  gradient_green_start = 210
  gradient_green_end = 255
  gradient_blue_start = 197
  gradient_blue_end = 230
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
  draw_bar_percent = $game_lawsystem.skill_progress_percent
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
# ------------------------------
def draw_action_bar(x, y, length)
  gradient_red_start = 0
  gradient_red_end = 0
  gradient_green_start = 210
  gradient_green_end = 255
  gradient_blue_start = 197
  gradient_blue_end = 230
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
  app = $game_lawsystem.action_progress_percent
  if app == 0
    app = -1
  end
  draw_bar_percent = app
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
# ------------------------------
def draw_eval_bar(x, y, length)
  gradient_red_start = 0
  gradient_red_end = 0
  gradient_green_start = 210
  gradient_green_end = 255
  gradient_blue_start = 197
  gradient_blue_end = 230
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
  ev = $game_lawsystem.evaluation
  if ev == 0
    ev = -1
  end
  draw_bar_percent = ev
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
# ------------------------------
def display_header(header_type)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  case header_type
  when 1
    self.contents.draw_text(260, 0, 100, 16, "Facts")
  when 2
    self.contents.draw_text(260, 0, 100, 16, "Documents")
  when 3
    self.contents.draw_text(260, 0, 100, 16, "Case Law")
  when 4
    self.contents.draw_text(260, 0, 100, 16, "Witnesses")
  when 5
    self.contents.draw_text(260, 0, 160, 16, "Facts/Documents")
  end
end
# ------------------------------
end