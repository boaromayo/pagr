class Window_MapDump < Window_Base
# --------------------------------
def initialize
  super(0, 0, 676, 512)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  self.z = 1000000
  self.visible = true
  @local_map_ok = [36, 37, 38, 81, 85]
  @terrain_tag_markup_ok = [37, 38]
  refresh
end
# --------------------------------
def refresh
  id = $game_map.map_id
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 12
  c = Color.new(0, 0, 0, 255)
  draw_x = 0
  draw_y = 0
  if @local_map_ok.include?(id)
    for row in 0..$game_map.height + 50
      for column in 0..$game_map.width + 50
        unless $game_map.passable?(row, column, 2)
          draw_t7(draw_x, draw_y)
        end
        if @terrain_tag_markup_ok.include?(id)
          case $game_map.terrain_tag(row, column)
          when 1
            draw_t1(draw_x, draw_y)
          when 2
            draw_t2(draw_x, draw_y)
          when 3
            draw_t3(draw_x, draw_y)
          when 4
            draw_t4(draw_x, draw_y)
          when 5
            draw_t5(draw_x, draw_y)
          when 7
            draw_t7(draw_x, draw_y)
          end
        end
        draw_y += 4
      end
      draw_y = 0
      draw_x += 4
    end
  else
    self.contents.font.size = 16
    self.contents.draw_text(40, 60, 100, 16, "No Map Data", 1)
    self.contents.draw_text(40, 76, 100, 16, "Available", 1)
  end
end
# --------------------------------
def draw_t7(x, y)
  c = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(x, y, 4, 4, c)
end
# --------------------------------
def draw_t1(x, y)
  c = Color.new(0, 0, 0, 64)
  self.contents.fill_rect(x, y, 4, 4, c)
  c = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(x, y, 1, 1, c)
  self.contents.fill_rect(x, y+1, 2, 1, c)
  self.contents.fill_rect(x+1, y+2, 2, 1, c)
  self.contents.fill_rect(x+2, y+3, 2, 1, c)
end
# --------------------------------
def draw_t2(x, y)
  c = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(x+3, y, 1, 1, c)
  self.contents.fill_rect(x+2, y+1, 2, 1, c)
  self.contents.fill_rect(x+1, y+2, 2, 1, c)
  self.contents.fill_rect(x, y+3, 2, 1, c)
end
# --------------------------------
def draw_t3(x, y)
  c = Color.new(0, 0, 255, 255)
  self.contents.fill_rect(x, y, 4, 4, c)
end
# --------------------------------
def draw_t5(x, y)
  c = Color.new(133, 133, 133, 255)
  self.contents.fill_rect(x, y, 4, 4, c)
end
# --------------------------------
def draw_t4(x, y)
  c = Color.new(255, 255, 255, 255)
  self.contents.fill_rect(x, y, 4, 1, c)
  self.contents.fill_rect(x, y+3, 4, 1, c)
  self.contents.fill_rect(x, y, 1, 4, c)
  self.contents.fill_rect(x+3, y, 1, 4, c)
  c = Color.new(255, 0, 0, 255)
  self.contents.fill_rect(x+1, y+1, 2, 2, c)
end
# --------------------------------
end