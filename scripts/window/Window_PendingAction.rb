class Window_PendingAction < Window_Base
#-------------------------------
def initialize
  super(-20, 45, 256, 160)
  self.contents = Bitmap.new(224, 128)
  self.z = 500
  self.opacity = 0
  refresh
end
# -------------------------------
def refresh
  a_img = Bitmap.new("Graphics/Stuff/pend01.png")
  b_img = Bitmap.new("Graphics/Stuff/pend02.png")
  c_img = Bitmap.new("Graphics/Stuff/pend03.png")
  d_img = Bitmap.new("Graphics/Stuff/pend04.png")
  e_img = Bitmap.new("Graphics/Stuff/pend05.png")
  f_img = Bitmap.new("Graphics/Stuff/pend06.png")
  g_img = Bitmap.new("Graphics/Stuff/pend07.png")
  h_img = Bitmap.new("Graphics/Stuff/pend08.png")
  y = 24
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 20
  if check
    self.contents.draw_text(28, 0, 120, 20, "Pending Actions")
    self.contents.fill_rect(-20, 20, 224, 1, normal_color)
  end
  for enemy in $game_troop.enemies
    if enemy.current_action.type >= 1
      if enemy == $game_troop.enemies[0]
        self.contents.blt(8, y + 3, a_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[1]
        self.contents.blt(8, y + 3, b_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[2]
        self.contents.blt(8, y + 3, c_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[3]
        self.contents.blt(8, y + 3, d_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[4]
        self.contents.blt(8, y + 3, e_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[5]
        self.contents.blt(8, y + 3, f_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[6]
        self.contents.blt(8, y + 3, g_img, Rect.new(0, 0, 12, 12))
      end
      if enemy == $game_troop.enemies[7]
        self.contents.blt(8, y + 3, h_img, Rect.new(0, 0, 12, 12))
      end
    end
    if enemy.current_action.type == 1
      self.contents.draw_text(28, y, 150, 20, "Attack")
      y += 16
    end
    if enemy.current_action.type == 2
      n = $data_skills[enemy.current_action.skill_id].name
      self.contents.draw_text(28, y, 224, 20, n)
      y += 16
    end
    if enemy.current_action.type == 4
      self.contents.draw_text(28, y, 150, 20, "Escape")
      y += 16
    end
  end
end
# -------------------------------
def check
  flag = false
  for enemy in $game_troop.enemies
    if enemy.current_action.type >= 1
      flag = true
    end
  end
  return flag
end
# -------------------------------
end
