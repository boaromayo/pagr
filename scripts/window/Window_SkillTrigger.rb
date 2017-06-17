class Window_SkillTrigger < Window_Base
#-------------------------------
def initialize(skill_id_array)
  @skill_id_array = skill_id_array
  @count = -1
  @time = 125
  super(0, 0, 288, 280)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.x = 372
  self.y = 15
  self.z = 500
  self.opacity = 0
  refresh
  self.visible = true
end
# -------------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Monotype Corsiva"
  self.contents.font.size = 36
  a = @skill_id_array
  line = Rect.new(0, 36, 256, 1)
  self.contents.fill_rect(line, normal_color)
  if a.size == 1
    self.contents.draw_text(4, 0, 250, 36, "Auto Ability Triggered!")
  end
  if a.size >= 2
    self.contents.draw_text(4, 0, 250, 36, "Auto Abilities Triggered!")
  end
  draw_y = 0
  for value in a
    name = $data_skills[value].name
    self.contents.draw_text(4, 35 + draw_y, 250, 36, name)
    draw_y += 32
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
  end
end
# -------------------------------
end
