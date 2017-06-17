class Window_ItemFocus < Window_Base
# ------------------------------
attr_accessor :help_window
# ------------------------------
def initialize(actor)
  super(160, 340, 288, 55)
  self.contents = Bitmap.new(256, 23)
  @actor = actor
  @item = actor.itemfocus_item
  @help_window = Window_BattleHelp.new
  self.z = 3050
  @help_window.z = 3100
  update_help
  refresh
end
# ------------------------------
def dispose
  super
  @help_window.dispose
end
# ------------------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  name = $data_items[@item].name
  amount = "x" + $game_party.item_number(@item).to_s
  icon = RPG::Cache.icon($data_items[@item].icon_name)
  self.contents.blt(0, -1, icon, Rect.new(0, 0, 24, 24))
  if not $game_party.item_can_use?(@item, true)
    self.contents.font.color = disabled_color
  end
  self.contents.draw_text(28, -5, 200, 32, name)
  self.contents.draw_text(224, -5, 32, 32, amount, 2)
end
# ------------------------------
def update_help
  if @item == 0
    t = ""
  else
    t = $data_items[@item].description
  end
  @help_window.set_text(t)
end
# ------------------------------
end
