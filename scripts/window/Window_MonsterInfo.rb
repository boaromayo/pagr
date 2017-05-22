class Window_MonsterInfo < Window_Base
# ----------------------------
def initialize
  super(0, 0, 384, 480)
  self.contents = Bitmap.new(width - 32, height - 32)
  refresh(1)
end
# ----------------------------
def refresh(id)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  enemy = $data_enemies[id]
  name = enemy.name
  filename = "Graphics/Battlers/" + enemy.battler_name
  sprite = Bitmap.new(filename)
  hp = enemy.maxhp.to_s
  str = enemy.str.to_s
  dex = enemy.dex.to_s
  agi = enemy.agi.to_s
  int = enemy.int.to_s
  atk = enemy.atk.to_s
  pdf = enemy.pdef.to_s
  mdf = enemy.mdef.to_s
  eva = enemy.eva.to_s
  exp = enemy.exp.to_s
  gold = enemy.gold.to_s
  prob = enemy.treasure_prob.to_s + "%"
  text_table = ["null", "WEAK", "WEAK", "---", "RES", "NULL", "ABS"]
  phys_res = text_table[enemy.element_ranks[1]]
  fire_res = text_table[enemy.element_ranks[2]]
  water_res = text_table[enemy.element_ranks[3]]
  ice_res = text_table[enemy.element_ranks[4]]
  wind_res = text_table[enemy.element_ranks[5]]
  earth_res = text_table[enemy.element_ranks[6]]
  force_res = text_table[enemy.element_ranks[7]]
  vaccuum_res = text_table[enemy.element_ranks[8]]
  sonic_res = text_table[enemy.element_ranks[9]]
  psych_res = text_table[enemy.element_ranks[10]]
  icon = nil
  resist_state = enemy.state_ranks
  if enemy.item_id != 0
    item_name =  $data_items[enemy.item_id].name
    item_icon =  $data_items[enemy.item_id].icon_name
  elsif enemy.weapon_id != 0
    item_name =  $data_weapons[enemy.item_id].name
    item_icon =  $data_weapons[enemy.item_id].icon_name
  elsif enemy.armor_id != 0
    item_name =  $data_armors[enemy.item_id].name
    item_icon =  $data_armors[enemy.item_id].icon_name
  else
    item_name = "------------------"
    item_icon = nil
  end
  if item_name == "------------------"
    prob = "0%"
  end
  if hp == "999999"
    hp = "∞"
  end
  x = 90 - sprite.width / 2
  y = 128 - sprite.height / 2
  if item_icon != nil
    icon = "Graphics/Icons/" + item_icon
    icon_bmp = Bitmap.new(icon)
  end
  if icon != nil
    self.contents.blt(56, 388, icon_bmp, Rect.new(0, 0, 24, 24))
  end
  phys_icon = Bitmap.new("Graphics/Stuff/micro-40.png")
  fire_icon = Bitmap.new("Graphics/Stuff/micro-41.png")
  water_icon = Bitmap.new("Graphics/Stuff/micro-42.png")
  ice_icon =  Bitmap.new("Graphics/Stuff/micro-43.png")
  wind_icon =  Bitmap.new("Graphics/Stuff/micro-44.png")
  earth_icon =  Bitmap.new("Graphics/Stuff/micro-45.png")
  force_icon =  Bitmap.new("Graphics/Stuff/micro-46.png")
  vaccuum_icon =  Bitmap.new("Graphics/Stuff/micro-47.png")
  sonic_icon =  Bitmap.new("Graphics/Stuff/micro-48.png")
  psych_icon =  Bitmap.new("Graphics/Stuff/micro-49.png")
  self.contents.fill_rect(184, 32, 200, 1, Color.new(255, 255, 255, 255))
  self.contents.blt(x, y, sprite, Rect.new(0, 0, 320, 320))
  self.contents.blt(16, 260, phys_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(56, 260, fire_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(96, 260, water_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(136, 260, ice_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(16, 300, wind_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(56, 300, earth_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(96, 300, force_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(136, 300, vaccuum_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(36, 340, sonic_icon, Rect.new(0, 0, 24, 24))
  self.contents.blt(116, 340, psych_icon, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(184, 0, 200, 32, enemy.name)
  self.contents.draw_text(184, 32, 100, 32, "HP:")
  self.contents.draw_text(184, 64, 100, 32, "Strength:")
  self.contents.draw_text(184, 96, 100, 32, "Dexterity:")
  self.contents.draw_text(184, 128, 100, 32, "Agility:")
  self.contents.draw_text(184, 160, 100, 32, "Intelligence:")
  self.contents.draw_text(184, 192, 100, 32, "Attack:")
  self.contents.draw_text(184, 224, 100, 32, "Defense:")
  self.contents.draw_text(184, 256, 100, 32, "S. Defense:")
  self.contents.draw_text(184, 288, 100, 32, "Evasion:")
  self.contents.draw_text(184, 320, 100, 32, "EXP:")
  self.contents.draw_text(184, 352, 100, 32, "Yk:")
  self.contents.draw_text(4, 384, 48, 32, "Item:")
  self.contents.draw_text(284, 32, 68, 32, hp, 2)
  self.contents.draw_text(284, 64, 68, 32, str, 2)
  self.contents.draw_text(284, 96, 68, 32, dex, 2)
  self.contents.draw_text(284, 128, 68, 32, agi, 2)
  self.contents.draw_text(284, 160, 68, 32, int, 2)
  self.contents.draw_text(284, 192, 68, 32, atk, 2)
  self.contents.draw_text(284, 224, 68, 32, pdf, 2)
  self.contents.draw_text(284, 256, 68, 32, mdf, 2)
  self.contents.draw_text(284, 288, 68, 32, eva, 2)
  self.contents.draw_text(284, 320, 68, 32, exp, 2)
  self.contents.draw_text(284, 352, 68, 32, gold, 2)
  self.contents.draw_text(84, 384, 196, 32, item_name)
  self.contents.draw_text(284, 384, 68, 32, prob, 2)
  self.contents.font.size = 12
  self.contents.draw_text(16, 284, 28, 12, phys_res, 1)
  self.contents.draw_text(56, 284, 28, 12, fire_res, 1)
  self.contents.draw_text(96, 284, 28, 12, water_res, 1)
  self.contents.draw_text(136, 284, 28, 12, ice_res, 1)
  self.contents.draw_text(16, 324, 28, 12, wind_res, 1)
  self.contents.draw_text(56, 324, 28, 12, earth_res, 1)
  self.contents.draw_text(96, 324, 28, 12, force_res, 1)
  self.contents.draw_text(136, 324, 28, 12, vaccuum_res, 1)
  self.contents.draw_text(36, 364, 28, 12, sonic_res, 1)
  self.contents.draw_text(116, 364, 28, 12, psych_res, 1)
  string1 = "X: Status Resistance"
  string2 = "X: Elemental Resistance"
  string3 = "* Stats based on Normal difficulty."
  self.contents.draw_text(4, 416, 200, 32, string1)
  self.contents.draw_text(208, 416, 200, 32, string3)
end
# ----------------------------
end
