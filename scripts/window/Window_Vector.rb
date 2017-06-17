class Window_Vector < Window_Base
# -----------------------
def initialize(actor)
  super(416, 104, 200, 48)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  @actor = actor
  refresh
end
# -----------------------
def refresh
  max = @actor.acumen.to_s
  free = @actor.current_acumen.to_s
  self.contents.clear
  self.contents.draw_text(4, -8, 100, 32, "Acumen Vectors: ")
  self.contents.draw_text(112, -8, 32, 32, free, 2)
  self.contents.draw_text(144, -8, 8, 32, "/")
  self.contents.draw_text(136, -8, 32, 32, max, 2)
end
# -----------------------
end