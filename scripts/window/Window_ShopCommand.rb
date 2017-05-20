class Window_ShopCommand < Window_Selectable
# -----------------------
def initialize
  super(0, 64, 480, 64)
  self.contents = Bitmap.new(width - 32, height - 32)
  @item_max = 3
  @column_max = 3
  @commands = ["Buy", "Sell", "Exit"]
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  refresh
  self.index = 0
end
# -----------------------
def refresh
  self.contents.clear
  if $game_temp.shop_type == 0
    for i in 0...@item_max
    draw_item(i)
    end
  end
  if $game_temp.shop_type == 1
    self.contents.draw_text(4, 0, 324, 32, "You can only buy at this shop.")
    self.index = -1
    update_cursor_rect
  end
  if $game_temp.shop_type == 2
    self.contents.draw_text(4, 0, 324, 32, "You can only sell at this shop.")
    self.index = -1
    update_cursor_rect
  end
end
# -----------------------
def draw_item(index)
  x = 4 + index * 160
  self.contents.draw_text(x, 0, 128, 32, @commands[index])
end
# -----------------------
def update_cursor_rect
  if $game_temp.shop_type == 0
    super
  end
  if $game_temp.shop_type == 1 || $game_temp.shop_type == 2
    self.cursor_rect.empty
  end
end
# -----------------------
end
