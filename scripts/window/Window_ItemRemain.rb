class Window_ItemRemain < Window_Base
#-------------------------------
  def initialize
    @item = 1
    super(352, 320, 288, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 1000
    refresh
  end
# -------------------------------
  def item=(number)
    @item = number
    refresh
  end
# -------------------------------
  def refresh
    item = $data_items[@item]
    text = item.name
    text += ": "
    amount = $game_party.item_number(@item)
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.contents.draw_text(4, 0, 224, 32, text)
    self.contents.draw_text(228, 0, 28, 32, amount.to_s, 2)
  end
# -------------------------------
end
