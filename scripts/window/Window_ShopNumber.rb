#==============================================================================
# ■ Window_ShopNumber
#------------------------------------------------------------------------------
# 　ショップ画面で、購入または売却するアイテムの個数を入力するウィンドウです。
#==============================================================================

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(mode)
    super(0, 128, 368, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
    @mode = mode
  end
  #--------------------------------------------------------------------------
  # ● アイテム、最大個数、価格の設定
  #--------------------------------------------------------------------------
  def set(item, max, price)
    @item = item
    @max = max
    @price = price
    @number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 入力された個数の設定
  #--------------------------------------------------------------------------
  def number
    return @number
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.contents.font.color = normal_color
    if @mode == 1
      self.contents.draw_text(4, 0, 300, 32, "Buy how many?")
      self.contents.draw_text(4, 160, 240, 32, "Total Price:")
    end
    if @mode == 2
      self.contents.draw_text(4, 0, 300, 32, "Sell how many?")
      self.contents.draw_text(4, 160, 240, 32, "Total Compensation:")
    end
    draw_item_name(@item, 4, 96)
    self.contents.font.color = normal_color
    self.contents.draw_text(272, 96, 32, 32, "x")
    self.contents.draw_text(308, 96, 24, 32, @number.to_s, 2)
    self.cursor_rect.set(304, 96, 32, 32)
    currency = $data_system.words.gold
    cx = contents.text_size(currency).width
    total_price = @price * @number
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 160, 328-cx-2, 32, total_price.to_s, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(332-cx, 160, cx, 32, currency, 2)
    self.contents.font.color = normal_color
    self.contents.font.size = 16
    self.contents.draw_text(16, 292, 40, 32, "-1")
    self.contents.draw_text(60, 292, 40, 32, "+1")
    self.contents.draw_text(104, 292, 40, 32, "-10")
    self.contents.draw_text(148, 292, 40, 32, "+10")
    self.contents.draw_text(212, 292, 64, 32, "One")
    self.contents.draw_text(280, 292, 72, 32, "Maximum")
    icon_rect = Rect.new(0, 0, 24, 24)
    l_button = RPG::Cache.icon("talk04")
    self.contents.blt(180, 296, l_button, icon_rect)
    r_button = RPG::Cache.icon("talk03")
    self.contents.blt(248, 296, r_button, icon_rect)
    rect_art(4, 304)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if self.active
      if Input.repeat?(Input::RIGHT) and @number < @max
        $game_system.se_play($data_system.cursor_se)
        @number += 1
        refresh
      end
      if Input.repeat?(Input::LEFT) and @number > 1
        $game_system.se_play($data_system.cursor_se)
        @number -= 1
        refresh
      end
      if Input.repeat?(Input::UP) and @number < @max
        $game_system.se_play($data_system.cursor_se)
        @number = [@number + 10, @max].min
        refresh
      end
      if Input.repeat?(Input::DOWN) and @number > 1
        $game_system.se_play($data_system.cursor_se)
        @number = [@number - 10, 1].max
        refresh
      end
      if Input.repeat?(Input::L)
        $game_system.se_play($data_system.cursor_se)
        @number = 1
        refresh
      end
      if Input.repeat?(Input::R)
        $game_system.se_play($data_system.cursor_se)
        @number = @max
        refresh
      end
    end
  end
  # -----------------------------------
  def rect_art(x, y)
    white = Color.new(255, 255, 255, 255)
    self.contents.fill_rect(x, y+4, 1, 1, white)
    self.contents.fill_rect(x+1, y+3, 1, 3, white)
    self.contents.fill_rect(x+2, y+2, 1, 5, white)
    self.contents.fill_rect(x+3, y+1, 1, 7, white)
    self.contents.fill_rect(x+4, y, 1, 9, white)
    self.contents.fill_rect(x+42, y, 1, 9, white)
    self.contents.fill_rect(x+43, y+1, 1, 7, white)
    self.contents.fill_rect(x+44, y+2, 1, 5, white)
    self.contents.fill_rect(x+45, y+3, 1, 3, white)
    self.contents.fill_rect(x+46, y+4, 1, 1, white)
    self.contents.fill_rect(x+84, y+2, 9, 1, white)
    self.contents.fill_rect(x+85, y+3, 7, 1, white)
    self.contents.fill_rect(x+86, y+4, 5, 1, white)
    self.contents.fill_rect(x+87, y+5, 3, 1, white)
    self.contents.fill_rect(x+88, y+6, 1, 1, white)
    self.contents.fill_rect(x+126, y+6, 9, 1, white)
    self.contents.fill_rect(x+127, y+5, 7, 1, white)
    self.contents.fill_rect(x+128, y+4, 5, 1, white)
    self.contents.fill_rect(x+129, y+3, 3, 1, white)
    self.contents.fill_rect(x+130, y+2, 1, 1, white)
  end
  # -----------------------------------
end
