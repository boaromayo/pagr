class Window_ShopBuy < Window_Selectable
# -----------------------
def initialize(shop_goods)
  super(0, 128, 368, 352)
  @shop_goods = shop_goods
  refresh
  self.index = 0
end
# -----------------------
def item
  return @data[self.index]
end
# -----------------------
def refresh
  if self.contents != nil
    self.contents.dispose
    self.contents = nil
  end
  @data = []
  for goods_item in @shop_goods
    case goods_item[0]
    when 0
      item = $data_items[goods_item[1]]
    when 1
      item = $data_weapons[goods_item[1]]
    when 2
      item = $data_armors[goods_item[1]]
    end
    if item != nil
      @data.push(item)
    end
  end
  @item_max = @data.size
  if @item_max > 0
    self.contents = Bitmap.new(width - 32, row_max * 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    for i in 0...@item_max
      draw_item(i)
    end
  end
end
# -----------------------
def draw_item(index)
  item = @data[index]
  case item
  when RPG::Item
    number = $game_party.item_number(item.id)
  when RPG::Weapon
    number = $game_party.weapon_number(item.id)
  when RPG::Armor
    number = $game_party.armor_number(item.id)
  end
  if item.price <= $game_party.gold and number < 99
    self.contents.font.color = normal_color
  else
    self.contents.font.color = disabled_color
  end
  x = 4
  y = index * 32
  rect = Rect.new(x, y, self.width - 32, 32)
  self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
  bitmap = RPG::Cache.icon(item.icon_name)
  opacity = self.contents.font.color == normal_color ? 255 : 128
  p = item.price
  if $game_system.discount
    p /= 10
    p *= 9
  end
  self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
  self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
  self.contents.draw_text(x + 240, y, 88, 32, p.to_s, 2)
end
# -----------------------
def update_help
  @help_window.set_text(self.item == nil ? "" : self.item.description)
end
# -----------------------
end
