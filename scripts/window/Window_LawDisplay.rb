class Window_LawDisplay < Window_Base
# ------------------------------
attr_accessor :data
attr_accessor :colors
attr_accessor :fusion_mode
attr_reader   :index
# ------------------------------
def initialize
  super(272, 32, 346, 288)
  @data = []
  @colors = []
  @item_max = 0
  @index = 0
  @fusion_mode = false
  self.contents = Bitmap.new(314, 32)
  refresh
end
# ------------------------------
def refresh
  y_value = 0
  self.contents.dispose
  if @data.size >= 2
    self.contents = Bitmap.new(314, @item_max * 32)
  else
    self.contents = Bitmap.new(314, 64)
  end
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  if @data.size > 0
    for i in 0..@data.size - 1
      draw_item(y_value, i)
      y_value += 16
    end
  end
end
# ------------------------------
def data=(array)
  @data = array
  @item_max = array.size
  @index = 0
  update_cursor_rect
  refresh
end
# ------------------------------
def draw_item(y, index)
  if @colors[index] == 0
    self.contents.font.color = normal_color
  end
  if @colors[index] == 1
    self.contents.font.color = Color.new(49, 255, 160)
  end
  if @colors[index] == 2
    self.contents.font.color = Color.new(255, 0, 136)
  end
  if @colors[index] == 3
    self.contents.font.color = crisis_color
  end
  if @fusion_mode
    self.contents.draw_text(16, y, 310, 16, @data[index])
  else
    self.contents.draw_text(4, y, 310, 16, @data[index])
  end
end
# ------------------------------
def update
  super
  if self.active && @item_max > 0
    if Input.trigger?(Input::UP)
      if @index == 0
        $game_system.se_play($data_system.buzzer_se)
      else
        @index -= 1
        $game_system.se_play($data_system.cursor_se)
        update_cursor_rect
      end
    end
    if Input.trigger?(Input::DOWN)
      if @index == @item_max - 1
        $game_system.se_play($data_system.buzzer_se)
      else
        @index += 1
        $game_system.se_play($data_system.cursor_se)
        update_cursor_rect
      end
    end
  end
end
# ------------------------------
def update_cursor_rect
  if @index < 0
    self.cursor_rect.empty
  else
    self.cursor_rect.set(0, @index * 16, 310, 16)
  end
end
# ------------------------------
def draw_fusion_cursor
  y = 4 + self.index * 16
  self.contents.fill_rect(4, y, 1, 9, Color.new(255, 255, 255))
  self.contents.fill_rect(5, y+1, 1, 7, Color.new(255, 255, 255))
  self.contents.fill_rect(6, y+2, 1, 5, Color.new(255, 255, 255))
  self.contents.fill_rect(7, y+3, 1, 3, Color.new(255, 255, 255))
  self.contents.fill_rect(8, y+4, 1, 1, Color.new(255, 255, 255))
end
# ------------------------------
end