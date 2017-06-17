class Window_Mutilate < Window_Base
# --------------------------------
attr_accessor :damage
attr_accessor :status
# --------------------------------
def initialize
  super(0, 0, 150, 70)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.back_opacity = 255
  self.z = 5000
  @damage = 120
  @status = 4
  refresh
end
# --------------------------------
def refresh
  dmg_string = @damage.to_s
  case @status
  when 0
    status_string = "None"
  when 1
    status_string = "Poison"
  when 2
    status_string = "Disease"
  when 3
    status_string = "Sluggish"
  when 4
    status_string = "Stupify"
  end
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  self.contents.draw_text(0, 0, 64, 16, "Damage:")
  self.contents.draw_text(70, 0, 48, 16, dmg_string, 2)
  self.contents.draw_text(0, 20, 64, 16, "Status:")
  self.contents.draw_text(54, 20, 64, 16, status_string, 2)
end
# --------------------------------
def damage=(damage)
  @damage = damage
  @damage = [@damage, 1].max
  @damage = [@damage, 9999].min
  refresh
end
# --------------------------------
def status=(status)
  @status = status
  @status = @status % 5
  refresh
end
# --------------------------------
end
