class Window_TetraRemain < Window_Base
# -------------------------
  def initialize(x, y)
    super(x, y, 100, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.z = 10010
    self.opacity = 0
    @dummy_window = Window_Base.new(x, y+8, 100, 44)
    @dummy_window.contents = Bitmap.new(68, 12)
    @dummy_window.opacity = 255
    @dummy_window.back_opacity = 255
    @dummy_window.z = 10000
    @dummy_window.visible = true
    @tetra_fn = "Graphics/icons/jewel04.png"
    @tetra_vp = Viewport.new(x+12, y+16, 24, 24)
    @tetra_vp.z = 10010
    @tetra_sprite = Sprite.new(@tetra_vp)
    @tetra_sprite.bitmap = Bitmap.new(@tetra_fn)
    refresh
  end
# -------------------------
  def dispose
    @dummy_window.dispose
    @tetra_sprite.dispose
    super
  end
# -------------------------
  def refresh
    number = $game_system.omni_remain
    self.contents.clear
    self.contents.draw_text(26, -2, 12, 32, "x")
    self.contents.draw_text(44, -2, 24, 32, number.to_s, 2)
  end
end
