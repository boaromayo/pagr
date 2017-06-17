class Window_SchizoCombo < Window_Base
#-------------------------------
attr_accessor :synapse_count
attr_accessor :effect_list
#-------------------------------
def initialize
  @synapse_count = 0
  @effect_list = []
  @count = -1
  @time = -1
  super(0, 0, 240, 280)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.z = 500
  self.opacity = 0
  setup_location
  refresh
  self.visible = false
end
# -------------------------------
def setup_location
  self.x = 420
  self.y = 15
end
# -------------------------------
def set(count, effects)
  @synapse_count = count
  @effect_list = effects
  @count = 0
  @time = 125
  refresh
end
# -------------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Monotype Corsiva"
  self.contents.font.size = 36
  self.visible = true
  line = Rect.new(0, 36, 208, 1)
  self.contents.fill_rect(line, normal_color)
  self.contents.draw_text(4, 0, 202, 36, "Schizo Combo!")
  synapse_string = @synapse_count.to_s + " Synapse"
  self.contents.draw_text(4, 34, 202, 36, synapse_string)
  y_plus = 32
  for effect in @effect_list
    case effect
    when 1
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "FT Cost Half")
    when 2
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "FT Cost Zero")
    when 3
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "EX Cost Half")
    when 4
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "EX Cost Zero")
    when 5
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Target All")
    when 6
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Double Effect")
    when 7
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Quad Effect")
    when 8
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Doubleshape")
    when 9
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "FT Recovery")
    when 10
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "FT Damage")
    when 11
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "HP Max")
    when 12
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "FT Max")
    when 13
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Chain Combo")
    when 14
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Barrage")
    when 15
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Action Potential")
    when 16
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Status Strike")
    when 17
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Mortifera Ad Infinitum")
    when 18
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Organalle Symphony")
    when 19
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Megacomorbidity")
    when 20
      self.contents.draw_text(4, 35 + y_plus, 202, 36, "Deify")
    end
    y_plus += 32
  end
end
# -------------------------------
  def update
    super
    if @time > 0
      @count += 1
    end
    if @count == @time
      self.visible = false
      @time = -1
    end
  end
end
