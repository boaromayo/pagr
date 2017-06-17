class Window_Schizo < Window_Base
# ---------------------
def initialize
  super(0, 0, 640, 480)
  self.contents = Bitmap.new(width - 32, height - 32)
  @actor = $game_actors[9]
  conditionals = setup_conditionals
  @conditional_window = Window_Schizoconditionals.new(300, conditionals)
  @conditional_window.x = 16
  @conditional_window.y = 192
  @conditional_window.opacity = 0
  @conditional_window.active = true
  refresh
end
# ---------------------
def dispose
  super
  @conditional_window.dispose
end
# ---------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 20
  self.contents.draw_text(16, 170, 140, 20, "Schizoconditionals")
  self.contents.draw_text(290, 170, 140, 20, "Synapse Range")
  self.contents.draw_text(430, 170, 178, 20, "Increased Probability")
  self.contents.draw_text(230, 42, 100, 20, "Description")
  draw_description
  draw_neurotransmitter_data(1)
  draw_neurotransmitter_data(2)
  draw_neurotransmitter_data(3)
  draw_neurotransmitter_data(4)
  draw_line
  draw_combo_data
  draw_ranges
  draw_bonus_text
end
# ---------------------
def setup_conditionals
  array = []
  for i in 0..$game_schizo.names.size - 1
    if $game_schizo.conditionals.include?(i)
      array.push($game_schizo.names[i])
    end
  end
  if array.size == 0
    array.push("None")
  end
  return array
end
# ---------------------
def update
  super
  if @conditional_window.active
    @conditional_window.update
  end
end
# ---------------------
def draw_ranges
  self.contents.font.size = 24
  y = 192
  for i in 0..20
    if $game_schizo.conditionals.include?(i)
      min_syn = $game_schizo.synapses_min[i]
      max_syn = $game_schizo.synapses_max[i]
      range_string = min_syn.to_s + "-" + max_syn.to_s
      self.contents.draw_text(312, y, 80, 32, range_string, 1)
      y += 32
    end
  end
end
# ---------------------
def draw_line
  self.contents.fill_rect(16, 188, 576, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(230, 60, 362, 1, Color.new(255, 255, 255, 255))
end
# ---------------------
def draw_neurotransmitter_data(type)
  x = 16
  y = (32 * type) - 12
  length = 192
  self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
  case type
  when 1
    number = $game_schizo.seretonin
    total = $game_schizo.search_requirements(1)
    current = $game_schizo.seretonin - $game_schizo.second_highest(1)
    name = "Seretonin"
  when 2
    number = $game_schizo.dopamine
    total = $game_schizo.search_requirements(2)
    current = $game_schizo.dopamine - $game_schizo.second_highest(2)
    name = "Dopamine"
  when 3
    number = $game_schizo.norepinephrine
    total = $game_schizo.search_requirements(3)
    current = $game_schizo.norepinephrine - $game_schizo.second_highest(3)
    name = "Norepinephrine"
  when 4
    number = $game_schizo.aspartate
    total = $game_schizo.search_requirements(4)
    current = $game_schizo.aspartate - $game_schizo.second_highest(4)
    name = "Aspartate"
  end
  self.contents.font.size = 16
  self.contents.draw_text(x, y - 18, 120, 20, name)
  if total == 0
    ap_string = "MASTER!"
  else
    ap_string = number.to_s + "/" + total.to_s
  end
  self.contents.draw_text(x+130, y - 18, 60, 20, ap_string, 2)
  gradient_red_start = 214
  gradient_red_end = 151
  gradient_green_start = 156
  gradient_green_end = 34
  gradient_blue_start = 255
  gradient_blue_end = 255
  draw_bar_percent = current * 100 / (total - $game_schizo.second_highest(type))
  if current == 0 or total == 0
    draw_bar_percent = -1
  end
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
# ---------------------
def draw_combo_data
  self.contents.font.size = 24
  combo_string = "Max Combo:"
  syn_string = "Max Synapse:"
  combo = $game_schizo.max_combo.to_s
  syn = $game_schizo.max_synapse.to_s
  self.contents.draw_text(230, 0, 180, 32, combo_string)
  self.contents.draw_text(410, 0, 180, 32, syn_string)
  self.contents.draw_text(200, 0, 180, 32, combo, 2)
  self.contents.draw_text(410, 0, 180, 32, syn, 2)
end
# ---------------------
def draw_description
  self.contents.font.size = 24
  text1 = @conditional_window.descriptions[0]
  text2 = @conditional_window.descriptions[1]
  text3 = @conditional_window.descriptions[2]
  self.contents.draw_text(230, 62, 400, 32, text1)
  self.contents.draw_text(230, 90, 400, 32, text2)
  self.contents.draw_text(230, 118, 400, 32, text3)
end
# ---------------------
def draw_bonus_text
  y = 192
  i = 0
  for command in @conditional_window.commands
    if @conditional_window.top_row > i
      i += 1
      next
    end
    case command
    when "HP less than 25%"
      self.contents.draw_text(412, y, 178, 32, "-", 1)
    when "FT less than 0"
      self.contents.draw_text(430, y, 178, 32, "FT Cost Down")
    when "EX 50%"
      self.contents.draw_text(430, y, 178, 32, "EX Cost Down")
    when "EX 150%"
      self.contents.draw_text(430, y, 178, 32, "EX Cost Down")
    when "Faint Flag"
      self.contents.draw_text(412, y, 178, 32, "-", 1)
    when "Status Ailment Present"
      self.contents.draw_text(430, y, 178, 32, "Status Strike")
    when "Four Ailments Present"
      self.contents.draw_text(430, y, 178, 32, "Status Strike")
    when "Recent HP Recovery"
      self.contents.draw_text(430, y, 178, 32, "HP Recovery")
    when "Recent FT Recovery"
      self.contents.draw_text(430, y, 178, 32, "FT Recovery")
    when "Recent EX Recovery"
      self.contents.draw_text(430, y, 178, 32, "EX Cost Down")
    when "Revived Recently"
      self.contents.draw_text(430, y, 178, 32, "-", 1)
    when "System Shock"
      self.contents.draw_text(430, y, 178, 32, "Doubleshape")
    when "Idle"
      self.contents.draw_text(430, y, 178, 32, "Chain Combo")
    when "Last Resort"
      self.contents.draw_text(430, y, 178, 32, "Effect Bonus")
    when "Crowd"
      self.contents.draw_text(430, y, 178, 32, "Group Target")
    when "No Damage"
      self.contents.draw_text(412, y, 178, 32, "-", 1)
    end
    i += 1
    y += 32
  end
end
# ---------------------
end
