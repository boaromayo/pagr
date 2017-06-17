class Window_LocalMap < Window_Base
# --------------------------------
attr_accessor :draw_visual_cones
# --------------------------------
def initialize
  super(400, 308, 224, 176)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  self.z = 5000
  self.visible = false
  @local_map_ok = [37, 81]
  @terrain_tag_markup_ok = [37]
  @draw_visual_cones = false
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
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 12
  c = Color.new(0, 0, 0, 64)
  self.contents.fill_rect(0, 8, width - 32, height - 32, c)
  self.contents.draw_text(6, 2, 50, 12, "Local Map")
  draw_x = 16
  draw_y = 16
  if @local_map_ok.include?(id)
    for row in @x..@x+39
      for column in @y..@y+29
        unless $game_map.passable?(row, column, 2)
          draw_obstacle(draw_x, draw_y)
        end
        if @terrain_tag_markup_ok.include?(id)
          case $game_map.terrain_tag(row, column)
          when 1
            draw_down(draw_x, draw_y)
          when 2
            draw_up(draw_x, draw_y)
          when 3
            draw_water(draw_x, draw_y)
          when 4
            draw_blocker(draw_x, draw_y)
          when 7
            draw_obstacle(draw_x, draw_y)
          end
        end
        draw_y += 4
      end
      draw_y = 16
      draw_x += 4
    end
    draw_player_location
    draw_interesting_events
  else
    self.contents.font.size = 16
    self.contents.draw_text(40, 60, 100, 16, "No Map Data", 1)
    self.contents.draw_text(40, 76, 100, 16, "Available", 1)
  end
end
# --------------------------------
def draw_obstacle(x, y)
  c = Color.new(255, 255, 255, 128)
  self.contents.fill_rect(x, y, 4, 4, c)
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
                if @draw_visual_cones
                  visual_cone(event)
                end
              end
            end
          end
        end
      end
    end
  end
end
# --------------------------------
def draw_down(x, y)
  c = Color.new(0, 0, 0, 64)
  self.contents.fill_rect(x, y, 4, 4, c)
  c = Color.new(255, 255, 255, 192)
  self.contents.fill_rect(x, y, 1, 1, c)
  self.contents.fill_rect(x, y+1, 2, 1, c)
  self.contents.fill_rect(x+1, y+2, 2, 1, c)
  self.contents.fill_rect(x+2, y+3, 2, 1, c)
end
# --------------------------------
def draw_up(x, y)
  c = Color.new(255, 255, 255, 192)
  self.contents.fill_rect(x+3, y, 1, 1, c)
  self.contents.fill_rect(x+2, y+1, 2, 1, c)
  self.contents.fill_rect(x+1, y+2, 2, 1, c)
  self.contents.fill_rect(x, y+3, 2, 1, c)
end
# --------------------------------
def draw_water(x, y)
  c = Color.new(0, 0, 255, 192)
  self.contents.fill_rect(x, y, 4, 4, c)
end
# --------------------------------
def draw_blocker(x, y)
  c = Color.new(255, 255, 255, 192)
  self.contents.fill_rect(x, y, 4, 1, c)
  self.contents.fill_rect(x, y+3, 4, 1, c)
  self.contents.fill_rect(x, y, 1, 4, c)
  self.contents.fill_rect(x+3, y, 1, 4, c)
  c = Color.new(255, 0, 0, 255)
  self.contents.fill_rect(x+1, y+1, 2, 2, c)
end
# --------------------------------
def visual_cone(event)
  relative_x = event.x - @x
  relative_y = event.y - @y
  draw_x = (relative_x * 4) + 18
  draw_y = (relative_y * 4) + 18
  c = Color.new(255, 255, 0, 192)
  case event.direction
    when 2
      self.contents.fill_rect(draw_x-1, draw_y+1, 2, 1, c)
      self.contents.fill_rect(draw_x-2, draw_y+2, 4, 1, c)
      self.contents.fill_rect(draw_x-3, draw_y+3, 6, 1, c)
      self.contents.fill_rect(draw_x-4, draw_y+4, 8, 6, c)
      self.contents.fill_rect(draw_x-3, draw_y+10, 6, 1, c)
      self.contents.fill_rect(draw_x-2, draw_y+11, 4, 1, c)
      self.contents.fill_rect(draw_x-1, draw_y+12, 2, 1, c)
    when 4
      x = 1
    when 6
      x = 1
    when 8
      self.contents.fill_rect(draw_x-1, draw_y-2, 2, 1, c)
      self.contents.fill_rect(draw_x-2, draw_y-3, 4, 1, c)
      self.contents.fill_rect(draw_x-3, draw_y-4, 6, 1, c)
      self.contents.fill_rect(draw_x-4, draw_y-10, 8, 6, c)
      self.contents.fill_rect(draw_x-3, draw_y-11, 6, 1, c)
      self.contents.fill_rect(draw_x-2, draw_y-12, 4, 1, c)
      self.contents.fill_rect(draw_x-1, draw_y-13, 2, 1, c)
  end
end
# --------------------------------
end
