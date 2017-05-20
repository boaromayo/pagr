class Window_BattleHelp < Window_Base
# --------------------------------
def initialize
  super(0, 284, 640, 51)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.back_opacity = 255
end
# --------------------------------
def set_text(text, align = 0)
  if text != @text or align != @align
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.contents.font.color = normal_color
    self.contents.draw_text(4, -7, self.width - 40, 32, text, align)
    @text = text
    @align = align
    @actor = nil
  end
  self.visible = true
end
# --------------------------------
end
