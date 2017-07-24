class Scene_TileMatch
# ---------------------
def main
  @bg_sprite = Sprite.new
  @bg_sprite.bitmap = Bitmap.new("Graphics/Stuff/mg.png")
  @bg_sprite.z = 500
  @cursor_sprite = Sprite.new
  @cursor_sprite.bitmap = Bitmap.new("Graphics/Stuff/t99.png")
  @cursor_sprite.z = 10000
  @match_temp = []
  @match_flag = false
  @mode = 1
  @cursor_position = 11
  @score = 0
  @life = 10
  @powerup_x = 0
  @powerup_y = 0
  @powerup_z = 0
  @last_swap = [0, 0, 0, 0]
  set_initial_positions
  update_cursor
  Graphics.transition
  loop do
    Graphics.update
    Input.update
    update
    if $scene != self
      break
    end
  end
  Graphics.freeze
end
# ---------------------
def update
  up_ok = false
  down_ok = false
  right_ok = false
  left_ok = false
  cp = @cursor_position
  if cp % 10 > 1
    up_ok = true
  end
  if cp % 10 < 8
    down_ok = true
  end
  if cp <= 79
    right_ok = true
  end
  if cp >= 20
    left_ok = true
  end
  if @mode == 1
    if Input.trigger?(Input::UP)
      if up_ok
        $game_system.se_play($data_system.cursor_se)
        @cursor_position -= 1
        update_cursor
      end
    end
    if Input.trigger?(Input::DOWN)
      if down_ok
        $game_system.se_play($data_system.cursor_se)
        @cursor_position += 1
        update_cursor
      end
    end
    if Input.trigger?(Input::RIGHT)
      if right_ok
        $game_system.se_play($data_system.cursor_se)
        @cursor_position += 10
        update_cursor
      end
    end
    if Input.trigger?(Input::LEFT)
      if left_ok
        $game_system.se_play($data_system.cursor_se)
        @cursor_position -= 10
        update_cursor
      end
    end
    if Input.trigger?(Input::C)
      if left_ok
        $game_system.se_play($data_system.decision_se)
        @mode = 2
      end
    end
  end
  if @mode == 2
    if Input.trigger?(Input::UP)
      if up_ok
        $game_system.se_play($data_system.cursor_se)
        x1 = (@cursor_position / 10) - 1
        y1 = (@cursor_position % 10) - 1
        x2 = (@cursor_position / 10) - 1
        y2 = (@cursor_position % 10) - 2
        swap(x1, y1, x2, y2)
        @mode = 1
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    if Input.trigger?(Input::DOWN)
      if down_ok
        $game_system.se_play($data_system.cursor_se)
        x1 = (@cursor_position / 10) - 1
        y1 = (@cursor_position % 10) - 1
        x2 = (@cursor_position / 10) - 1
        y2 = (@cursor_position % 10)
        swap(x1, y1, x2, y2)
        @mode = 1
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    if Input.trigger?(Input::RIGHT)
      if right_ok
        $game_system.se_play($data_system.cursor_se)
        x1 = (@cursor_position / 10) - 1
        y1 = (@cursor_position % 10) - 1
        x2 = (@cursor_position / 10) 
        y2 = (@cursor_position % 10) - 1
        swap(x1, y1, x2, y2)
        @mode = 1
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
    if Input.trigger?(Input::LEFT)
      if left_ok
        $game_system.se_play($data_system.cursor_se)
        x1 = (@cursor_position / 10) - 1
        y1 = (@cursor_position % 10) - 1
        x2 = (@cursor_position / 10) - 2
        y2 = (@cursor_position % 10) - 1
        swap(x1, y1, x2, y2)
        @mode = 1
      else
        $game_system.se_play($data_system.buzzer_se)
      end
    end
  end
end
# ---------------------
def set_initial_positions
  @tile_data = []
  for i in 0..7
    @tile_data[i] = []
  end
  for i in 0..7
    for j in 0..7
      @tile_data[i][j] = []
    end
  end
  for i in 0..7
    for j in 0..7
      @tile_data[i][j][0] = 0
      @tile_data[i][j][1] = 0
      @tile_data[i][j][2] = 0
    end
  end
  for i in 0..7
    for j in 0..7
      tid = rand(10)
      a = Sprite.new
      case tid
      when 0
        a.bitmap = Bitmap.new("Graphics/Stuff/t01.png")
        color = 1
        suit = 1
      when 1
        a.bitmap = Bitmap.new("Graphics/Stuff/t02.png")
        color = 2
        suit = 1
      when 2
        a.bitmap = Bitmap.new("Graphics/Stuff/t03.png")
        color = 3
        suit = 1
      when 3
        a.bitmap = Bitmap.new("Graphics/Stuff/t04.png")
        color = 4
        suit = 1
      when 4
        a.bitmap = Bitmap.new("Graphics/Stuff/t05.png")
        color = 5
        suit = 1
      when 5
        a.bitmap = Bitmap.new("Graphics/Stuff/t06.png")
        color = 1
        suit = 2
      when 6
        a.bitmap = Bitmap.new("Graphics/Stuff/t07.png")
        color = 2
        suit = 2
      when 7
        a.bitmap = Bitmap.new("Graphics/Stuff/t08.png")
        color = 3
        suit = 2
      when 8
        a.bitmap = Bitmap.new("Graphics/Stuff/t09.png")
        color = 4
        suit = 2
      when 9
        a.bitmap = Bitmap.new("Graphics/Stuff/t10.png")
        color = 5
        suit = 2
      end
      a.x = 250 + i * 28
      a.y = 150 + j * 28
      a.z = 9999
      @tile_data[i][j][0] = a
      @tile_data[i][j][1] = tid
      @tile_data[i][j][2] = color
      @tile_data[i][j][3] = suit
      @tile_data[i][j][4] = 0
    end
  end
end
# ---------------------
def swap(x1, y1, x2, y2)
  @last_swap = [x1, y1, x2, y2]
  sprite = @tile_data[x2][y2][0]
  t = @tile_data[x2][y2][1]
  c = @tile_data[x2][y2][2]
  s = @tile_data[x2][y2][3]
  m = @tile_data[x2][y2][4]
  @tile_data[x2][y2][0] = @tile_data[x1][y1][0]
  @tile_data[x2][y2][1] = @tile_data[x1][y1][1]
  @tile_data[x2][y2][2] = @tile_data[x1][y1][2]
  @tile_data[x2][y2][3] = @tile_data[x1][y1][3]
  @tile_data[x2][y2][4] = @tile_data[x1][y1][4]
  @tile_data[x1][y1][0] = sprite
  @tile_data[x1][y1][1] = t
  @tile_data[x1][y1][2] = c
  @tile_data[x1][y1][3] = s
  @tile_data[x1][y1][4] = m
end
# ---------------------
def unswap
  swap(@last_swap[0], @last_swap[1], @last_swap[2], @last_swap[3])
end
# ---------------------
def match
  match_marks = []
  for i in 0..7
    match_marks[i] = []
  end
  for i in 0..7
    for j in 0..7
      match_marks[i][j] = false
    end
  end
  for i in 0..7
    for j in 0..7
      x = i
      y = j
      count = 0
      total_color_match = 1
      total_suit_match = 1
      while x <= 7
        @match_temp[count] = [x, y]
        if @tile_data[x+1][y][2] == @tile_data[x][y][2]
          total_color_match += 1
        else
          total_color_match = 1
        end
        if @tile_data[x+1][y][3] == @tile_data[x][y][3]
          total_color_match += 1
        else
          total_suit_match = 1
        end
      count += 1
      x += 1
      end
      if total_color_match >= 3
        for value in @match_temp
          match_marks[value[0]][value[1]] = true
        end
      end
      if total_suit_match >= 3
        for value in @match_temp
          match_marks[value[0]][value[1]] = true
        end
      end
    end
  end
end
# ---------------------
def update_cursor
  x_pos = (@cursor_position / 10) - 1
  y_pos = (@cursor_position % 10) - 1
  @cursor_sprite.x = 250 + x_pos * 28
  @cursor_sprite.y = 150 + y_pos * 28
end
# ---------------------
def update_sprite_positions
  for i in 0..7
    for j in 0..7
      tid = @tile_data[i][j][1]
      a = Sprite.new
      case tid
      when 0
        a.bitmap = Bitmap.new("Graphics/Stuff/t01.png")
        color = 1
        suit = 1
      when 1
        a.bitmap = Bitmap.new("Graphics/Stuff/t02.png")
        color = 2
        suit = 1
      when 2
        a.bitmap = Bitmap.new("Graphics/Stuff/t03.png")
        color = 3
        suit = 1
      when 3
        a.bitmap = Bitmap.new("Graphics/Stuff/t04.png")
        color = 4
        suit = 1
      when 4
        a.bitmap = Bitmap.new("Graphics/Stuff/t05.png")
        color = 5
        suit = 1
      when 5
        a.bitmap = Bitmap.new("Graphics/Stuff/t06.png")
        color = 1
        suit = 2
      when 6
        a.bitmap = Bitmap.new("Graphics/Stuff/t07.png")
        color = 2
        suit = 2
      when 7
        a.bitmap = Bitmap.new("Graphics/Stuff/t08.png")
        color = 3
        suit = 2
      when 8
        a.bitmap = Bitmap.new("Graphics/Stuff/t09.png")
        color = 4
        suit = 2
      when 9
        a.bitmap = Bitmap.new("Graphics/Stuff/t10.png")
        color = 5
        suit = 2
      end
      a.x = 250 + i * 28
      a.y = 150 + j * 28
      a.z = 9999
      @tile_data[i][j][0] = a
      @tile_data[i][j][2] = color
      @tile_data[i][j][3] = suit
    end
  end
end
# ---------------------
def animate_swap
  x = 1
end
# ---------------------
def reset_match_temp
  for i in 0..7
    @match_temp[i] = [0, 0]
    @match_flag = false
  end
end
# ---------------------
end