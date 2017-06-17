class Window_NewLocalMap < Window_Base
# --------------------------------
def initialize
  super(400, 308, 224, 176)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  self.z = 5000
  self.visible = false
  @local_map_ok = [36, 37, 38, 81, 85]
  @source_img = ""
  m = $game_map.map_id
  if m < 100
    @source_img = "Graphics/Stuff/map0" + m.to_s + ".png"
  else
    @source_img = "Graphics/Stuff/map" + m.to_s + ".png"
  end
  refresh
end
# --------------------------------
def refresh
  if $game_mapeffects.query(0)
    self.visible = true
  else
    self.visible = false
    return
  end
  id = $game_map.map_id
  @x = [($game_map.display_x / 128) - 10, 0].max
  @y = [($game_map.display_y / 128) - 8, 0].max
  @map_rect = Rect.new(@x * 4, @y * 4, @x * 4 + 160, @y * 4 + 120)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 12
  c = Color.new(0, 0, 0, 64)
  self.contents.fill_rect(0, 8, width - 32, height - 32, c)
  self.contents.draw_text(6, 2, 50, 12, "Local Map")
  if @local_map_ok.include?(id)
    self.contents.blt(16, 16, Bitmap.new(@source_img), @map_rect, 192)
    draw_player_location
    draw_interesting_events
  else
    self.contents.font.size = 16
    self.contents.draw_text(40, 60, 100, 16, "No Map Data", 1)
    self.contents.draw_text(40, 76, 100, 16, "Available", 1)
  end
end
# --------------------------------
def draw_player_location
  relative_x = $game_player.x - @x
  relative_y = $game_player.y - @y
  draw_x = (relative_x * 4) + 16
  draw_y = (relative_y * 4) + 16
  c = Color.new(255, 0, 0, 255)
  self.contents.fill_rect(draw_x+1, draw_y, 1, 1, c)
  self.contents.fill_rect(draw_x, draw_y+1, 3, 1, c)
  self.contents.fill_rect(draw_x+1, draw_y+2, 1, 1, c)
end
# --------------------------------
def draw_interesting_events
  for event in $game_map.events.values
    if event.character_name != ""
      if event.list.size > 0
        relative_x = event.x - @x
        relative_y = event.y - @y
        draw_x = (relative_x * 4) + 16
        draw_y = (relative_y * 4) + 16
        c = Color.new(0, 190, 0, 255)
        if draw_x >= 16
          if draw_x <= 176
            if draw_y >= 16
              if draw_y <= 136
                self.contents.fill_rect(draw_x+1, draw_y, 1, 1, c)
                self.contents.fill_rect(draw_x, draw_y+1, 3, 1, c)
                self.contents.fill_rect(draw_x+1, draw_y+2, 1, 1, c)
              end
            end
          end
        end
      end
    end
  end
end
# --------------------------------
end
