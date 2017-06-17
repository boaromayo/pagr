class Window_TutorialFooter < Window_Base
# ----------------------------
attr_accessor :tutorial
# ----------------------------
def initialize
  super(256, 416, 384, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  @tutorial = 0
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = false
  self.opacity = 0
  refresh
end
# ----------------------------
def dispose
  self.contents.clear
  @scroll_sprite.dispose
end
# ----------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  case @tutorial
  when 1
    show_tut1
  when 2
    show_tut2
  when 3
    show_tut3
  when 4
    show_tut4
  when 5
    show_tut5
  when 6
    show_tut6
  when 7
    show_tut7
  when 8
    show_tut8
  end
end
# ----------------------------
def tutorial=(value)
  @tutorial = value
  refresh
end
# ----------------------------
def show_tut1
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut2
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut3
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut4
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut5
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut6
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut7
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def show_tut8
  draw_footer_line
  @scroll_sprite.dispose
  @scroll_fn = "Graphics/stuff/scroll1.png"
  @scroll_sprite = Sprite.new
  @scroll_sprite.x = 520
  @scroll_sprite.y = 440
  @scroll_sprite.z = 1500
  @scroll_sprite.bitmap = Bitmap.new(@scroll_fn)
  @scroll_sprite.visible = true
end
# ----------------------------
def draw_footer_line
  rect = Rect.new(4, 0, 352, 1)
  self.contents.fill_rect(rect, normal_color)
end
# ----------------------------
end
