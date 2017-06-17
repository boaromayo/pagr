class Window_TutorialFrame < Window_Base
# ----------------------------
def initialize
  super(256, 0, 384, 480)
  self.contents = Bitmap.new(width - 32, height - 32)
  refresh
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
end
# ----------------------------
end
