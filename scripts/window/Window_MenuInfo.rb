class Window_MenuInfo < Window_Base
# -----------------------
def initialize
  super(0, 0, 192, 160)
  self.contents = Bitmap.new(width - 32, height - 32)
  @icon1 = RPG::Cache.icon("jewel01")
  @icon2 = RPG::Cache.icon("jewel02")
  @icon3 = RPG::Cache.icon("jewel03")
  @icon4 = RPG::Cache.icon("jewel04")
  refresh
end
# -----------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  self.contents.font.color = system_color
  self.contents.draw_text(4, 0, 60, 32, "Time:")
  self.contents.draw_text(4, 32, 60, 32, "Steps:")
  self.contents.draw_text(4, 64, 60, 32, "Yk:")
  @total_sec = Graphics.frame_count / Graphics.frame_rate
  hour = @total_sec / 60 / 60
  min = @total_sec / 60 % 60
  sec = @total_sec % 60
  text = sprintf("%02d:%02d:%02d", hour, min, sec)
  self.contents.font.color = normal_color
  self.contents.draw_text(4, 0, 156, 32, text, 2)
  self.contents.draw_text(4, 32, 156, 32, $game_party.steps.to_s, 2)
  self.contents.draw_text(4, 64, 156, 32, $game_party.gold.to_s, 2)
  self.contents.blt(4, 100, @icon1, Rect.new(0, 0, 24, 24))
  self.contents.blt(44, 100, @icon2, Rect.new(0, 0, 24, 24))
  self.contents.blt(84, 100, @icon3, Rect.new(0, 0, 24, 24))
  self.contents.blt(124, 100, @icon4, Rect.new(0, 0, 24, 24))
  self.contents.font.size = 12
  self.contents.draw_text(32, 100, 12, 32, $game_system.item_remain.to_s)
  self.contents.draw_text(70, 100, 12, 32, $game_system.shaping_remain.to_s)
  self.contents.draw_text(110, 100, 12, 32, $game_system.ability_remain.to_s)
  self.contents.draw_text(150, 100, 12, 32, $game_system.omni_remain.to_s)
end
# -----------------------
def update
  super
  if Graphics.frame_count / Graphics.frame_rate != @total_sec
    refresh
  end
end
# -----------------------
end
