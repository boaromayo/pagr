#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中のすべてのウィンドウのスーパークラスです。
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super()
    @windowskin_name = $game_system.windowskin_name
    self.windowskin = RPG::Cache.windowskin(@windowskin_name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.z = 100
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if self.contents != nil
      self.contents.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 文字色取得
  #     n : 文字色番号 (0～7)
  #--------------------------------------------------------------------------
  def text_color(n)
    case n
    when 0
      return Color.new(255, 255, 255, 255)
    when 1
      return Color.new(128, 128, 255, 255)
    when 2
      return Color.new(255, 128, 128, 255)
    when 3
      return Color.new(128, 255, 128, 255)
    when 4
      return Color.new(128, 255, 255, 255)
    when 5
      return Color.new(255, 128, 255, 255)
    when 6
      return Color.new(255, 255, 128, 255)
    when 7
      return Color.new(192, 192, 192, 255)
    when 8
      return Color.new(0, 255, 0, 255)
    else
      normal_color
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常文字色の取得
  #--------------------------------------------------------------------------
  def normal_color
    return Color.new(255, 255, 255, 255)
  end
  #--------------------------------------------------------------------------
  # ● 無効文字色の取得
  #--------------------------------------------------------------------------
  def disabled_color
    return Color.new(155, 155, 155, 255)
  end
  #--------------------------------------------------------------------------
  # ● システム文字色の取得
  #--------------------------------------------------------------------------
  def system_color
    return Color.new(192, 224, 255, 255)
  end
  #--------------------------------------------------------------------------
  # ● ピンチ文字色の取得
  #--------------------------------------------------------------------------
  def crisis_color
    return Color.new(255, 255, 64, 255)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能文字色の取得
  #--------------------------------------------------------------------------
  def knockout_color
    return Color.new(255, 64, 0)
  end
  # --------------------------------
  def up_color
    return Color.new(74, 210, 74)
  end
  # --------------------------------
  def down_color
    return Color.new(170, 170, 170)
  end
  # --------------------------------
  def hex_color(string)
    red = 0
    green = 0
    blue = 0
    if string.size != 6
      print("Hex strings must be six characters long.")
      print("White text will be used.")
      return Color.new(255, 255, 255, 255)
    end
    for i in 1..6
      s = string.slice!(/./m)
      if s == "x"
        print("Hex color string may not contain the \"x\" character.")
        print("White text will be used.")
        return Color.new(255, 255, 255, 255)
      end
      value = hex_convert(s)
      if value == -1
        print("Error converting hex value.")
        print("White text will be used.")
        return Color.new(255, 255, 255, 255)
      end
      case i
      when 1
        red += value * 16
      when 2
        red += value
      when 3
        green += value * 16
      when 4
        green += value
      when 5
        blue += value * 16
      when 6
        blue += value
      end
    end
    return Color.new(red, green, blue, 255)
  end
  # --------------------------------
  def hex_convert(character)
    case character
     when "0"
       return 0
    when "1"
       return 1
    when "2"
       return 2
    when "3"
       return 3
    when "4"
       return 4
    when "5"
       return 5
    when "6"
       return 6
    when "7"
       return 7
    when "8"
       return 8
    when "9"
       return 9
    when "A"
       return 10
    when "B"
       return 11
    when "C"
       return 12
    when "D"
       return 13
    when "E"
       return 14
    when "F"
       return 15
     end
    return -1
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if $game_system.windowskin_name != @windowskin_name
      @windowskin_name = $game_system.windowskin_name
      self.windowskin = RPG::Cache.windowskin(@windowskin_name)
    end
  end
  #--------------------------------------------------------------------------
  # ● グラフィックの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_graphic(actor, x, y)
    bitmap = RPG::Cache.character(actor.character_name, actor.character_hue)
    cw = bitmap.width / 4
    ch = bitmap.height / 4
    src_rect = Rect.new(0, 0, cw, ch)
    self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end
  #--------------------------------------------------------------------------
  # ● 名前の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y)
    if actor.fatigue <= -100
      self.contents.font.color = disabled_color
    else
      self.contents.font.color = normal_color
    end
    if $game_temp.in_battle
      self.contents.draw_text(x, y, 96, 32, actor.name)
    else
      self.contents.draw_text(x, y, 120, 32, actor.name)
    end
  end
  #--------------------------------------------------------------------------
  # ● クラスの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y)
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, 236, 32, actor.class_name)
  end
  #--------------------------------------------------------------------------
  # ● レベルの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, "Lv")
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 32, y, 24, 32, actor.level.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # ● ステートの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 描画先の幅
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y)
    if actor.states.size == 0
      return
    end
    x_offset = 0
    for i in actor.states
      if $data_states[i].icon == ""
        next
      end
      if x_offset >= 104
        next
      end
      icon = $data_states[i].icon
      self.contents.blt(x + x_offset, y + 4, icon, Rect.new(0, 0, 24, 24))
      x_offset += 18
    end
  end
  #--------------------------------------------------------------------------
  # ● EXP の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_exp(actor, x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 24, 32, "Exp")
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 24, y, 84, 32, actor.exp_s, 2)
    self.contents.draw_text(x + 108, y, 12, 32, "/", 1)
    self.contents.draw_text(x + 120, y, 84, 32, actor.next_exp_s, 2)
  end
  #--------------------------------------------------------------------------
  # ● HP の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 描画先の幅
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 144)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.hp)
    if width - 32 >= 108
      hp_x = x + width - 108
      flag = true
    elsif width - 32 >= 48
      hp_x = x + width - 48
      flag = false
    end
    if !$game_temp.in_battle
      hp_x += 60
    end
    self.contents.font.color = actor.hp == 0 ? knockout_color :
      actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
    self.contents.draw_text(hp_x, y, 48, 32, actor.hp.to_s, 2)
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(hp_x + 48, y, 12, 32, "/", 1)
      self.contents.draw_text(hp_x + 60, y, 48, 32, actor.maxhp.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● SP の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 描画先の幅
  #--------------------------------------------------------------------------
  def draw_actor_fatigue(actor, x, y)
    if actor.fatigue <= -100
      offset = x + 20
    else
      offset = x + 12
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.sp)
    self.contents.font.color = actor.fatigue <= -100 ? knockout_color :
      actor.fatigue >= -99 && actor.fatigue <= -50 ? crisis_color : 
      normal_color
    if actor.fatigue <= -100
      self.contents.draw_text(offset, y, 184, 32, actor.fatigue.to_s, 2)
    else
      self.contents.draw_text(offset, y, 192, 32, actor.fatigue.to_s, 2)
    end
  end
  # ------------------------
  def draw_actor_fatigue_bar(actor, x, y, length)
    self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
    draw_bar_percent = actor.fatigue.abs
    if actor.fatigue > 0
      gradient_red_start = 0
      gradient_red_end = 117
      gradient_green_start = 218
      gradient_green_end = 77
      gradient_blue_start = 255
      gradient_blue_end = 255
      for x_coord in 1..length
        current_percent_done = x_coord * 100 / length
        difference = gradient_red_end - gradient_red_start
        red = gradient_red_start + difference * x_coord / length
        difference = gradient_green_end - gradient_green_start
        green = gradient_green_start + difference * x_coord / length
        difference = gradient_blue_end - gradient_blue_start
        blue = gradient_blue_start + difference * x_coord / length
        if current_percent_done <= draw_bar_percent
          rect = Rect.new(x + x_coord-1, y, 1, 3)
          self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
        end
      end
    end
    if actor.fatigue < 0
      gradient_red_start = 255
      gradient_red_end = 255
      gradient_green_start = 144
      gradient_green_end = 0
      gradient_blue_start = 74
      gradient_blue_end = 0
      for x_coord in 1..length
        current_percent_done = x_coord * 100 / length
        difference = gradient_red_end - gradient_red_start
        red = gradient_red_start + difference * x_coord / length
        difference = gradient_green_end - gradient_green_start
        green = gradient_green_start + difference * x_coord / length
        difference = gradient_blue_end - gradient_blue_start
        blue = gradient_blue_start + difference * x_coord / length
        if current_percent_done <= draw_bar_percent
          rect = Rect.new(x + x_coord-1, y, 1, 3)
          self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
        end
      end
    end
  end
  # ------------------------
  def draw_actor_hp_bar(actor, x, y, length)
    self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
    gradient_red_start = 0
    gradient_red_end = 0
    gradient_green_start = 212
    gradient_green_end = 165
    gradient_blue_start = 140
    gradient_blue_end = 0
    draw_bar_percent = actor.hp * 100 / actor.maxhp
    if actor.hp == 0
      draw_bar_percent = -1
    end
    for x_coord in 1..length
      current_percent_done = x_coord * 100 / length
      difference = gradient_red_end - gradient_red_start
      red = gradient_red_start + difference * x_coord / length
      difference = gradient_green_end - gradient_green_start
      green = gradient_green_start + difference * x_coord / length
      difference = gradient_blue_end - gradient_blue_start
      blue = gradient_blue_start + difference * x_coord / length
      if current_percent_done <= draw_bar_percent
        rect = Rect.new(x + x_coord-1, y, 1, 3)
      self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
      end
    end
  end
  # ------------------------
  def draw_actor_exp_bar(actor, x, y, length)
    self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
    gradient_red_start = 255
    gradient_red_end = 152
    gradient_green_start = 255
    gradient_green_end = 152
    gradient_blue_start = 0
    gradient_blue_end = 0
    exp_need = actor.exp_list[actor.level + 1] - actor.exp_list[actor.level]
    exp_rest = actor.exp_list[actor.level + 1] - actor.exp
    exp_progress = exp_need - exp_rest
    draw_bar_percent = exp_progress * 100 / exp_need
    if exp_progress == 0
      draw_bar_percent = -1
    end
    for x_coord in 1..length
      current_percent_done = x_coord * 100 / length
      difference = gradient_red_end - gradient_red_start
      red = gradient_red_start + difference * x_coord / length
      difference = gradient_green_end - gradient_green_start
      green = gradient_green_start + difference * x_coord / length
      difference = gradient_blue_end - gradient_blue_start
      blue = gradient_blue_start + difference * x_coord / length
      if current_percent_done <= draw_bar_percent
        rect = Rect.new(x + x_coord-1, y, 1, 3)
      self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
      end
    end
  end
  # ------------------------
  def draw_actor_delay_bar(actor, x, y, length)
    self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
    gradient_red_start = 214
    gradient_red_end = 151
    gradient_green_start = 156
    gradient_green_end = 34
    gradient_blue_start = 255
    gradient_blue_end = 255
    current_delay = 0
    total_delay = 1
    if actor.current_action.action_delay > 0
      current_delay = actor.current_action.action_delay
      total_delay = actor.current_action.total_delay
    end
    draw_bar_percent = current_delay * 100 / total_delay
    for x_coord in 1..length
      current_percent_done = x_coord * 100 / length
      difference = gradient_red_end - gradient_red_start
      red = gradient_red_start + difference * x_coord / length
      difference = gradient_green_end - gradient_green_start
      green = gradient_green_start + difference * x_coord / length
      difference = gradient_blue_end - gradient_blue_start
      blue = gradient_blue_start + difference * x_coord / length
      if current_percent_done <= draw_bar_percent
        rect = Rect.new(x + x_coord-1, y, 1, 3)
        self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
      end
    end
  end
  # ------------------------
  def draw_actor_exertion(actor, x, y)
    offset = x + 28
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, "EX")
    self.contents.font.color = normal_color
    self.contents.draw_text(offset, y, 60, 32, actor.exertion.to_s + "%", 2)
  end
  #--------------------------------------------------------------------------
  # ● パラメータの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     type  : パラメータの種類 (0～6)
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type)
    case type
    when 0
      parameter_name = "Attack Power"
      parameter_value = actor.atk
    when 1
      parameter_name = "Defense Power"
      parameter_value = actor.pdef
    when 2
      parameter_name = "Shaping Defense"
      parameter_value = actor.mdef
    when 3
      parameter_name = "Strength"
      parameter_value = actor.str
    when 4
      parameter_name = "Dexterity"
      parameter_value = actor.dex
    when 5
      parameter_name = "Agility"
      parameter_value = actor.agi
    when 6
      parameter_name = "Intelligence"
      parameter_value = actor.int
    when 7
      parameter_name = "Evasion"
      parameter_value = actor.eva
    when 8
      parameter_name = "Energy"
      parameter_value = actor.energy.to_s + "%"
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 160, 32, parameter_name)
    self.contents.font.color = normal_color
    if type < 8
      self.contents.draw_text(x + 168, y, 36, 32, parameter_value.to_s, 2)
    else
      self.contents.draw_text(x + 144, y, 60, 32, parameter_value.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム名の描画
  #     item : アイテム
  #     x    : 描画先 X 座標
  #     y    : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y)
    if item == nil
      return
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name)
  end
end
