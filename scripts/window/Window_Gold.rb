class Window_Gold < Window_Base
#-------------------------
def initialize(x, y)
  super(x, y, 144, 100)
  self.contents = Bitmap.new(width - 32, height - 32)
  @dummy_window = Window_Base.new(x, y+10, 144, 44)
  @dummy_window.contents = Bitmap.new(112, 12)
  @dummy_window.opacity = 255
  @dummy_window.back_opacity = 255
  @dummy_window.contents_opacity = 255
  @dummy_window.z = 11500
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  self.opacity = 0
  self.back_opacity = 0
  self.z = 12000
  refresh
end
#-------------------------
def dispose
  super
  @dummy_window.dispose
end
#-------------------------
def refresh
  gold = $game_party.gold.to_s
  currency = "Yk"
  string = gold + currency
  self.contents.clear
  self.contents.font.color = normal_color
  self.contents.draw_text(-16, 0, 126, 32, string, 2)
end
#-------------------------
end

