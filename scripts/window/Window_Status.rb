class Window_Status < Window_Base
# -----------------------
def initialize(actor)
  super(0, 0, 640, 480)
  self.contents = Bitmap.new(width - 32, height - 32)
  @actor = actor
  actor_num = @actor.id
  filename = "Graphics/Face/face" + actor_num.to_s + ".png"
  @viewport = Viewport.new(8, 16, 96, 96)
  @viewport.z = 975
  @face = Sprite.new(@viewport)
  @face.bitmap = Bitmap.new(filename)
  @face.opacity = 255
  @face.visible = true
  bc = @actor.battle_commands
  @battlecommand_window = Window_Command.new(160, bc)
  @battlecommand_window.x = 352
  @battlecommand_window.y = 192
  @battlecommand_window.z = 2000
  @battlecommand_window.index = -1
  @battlecommand_window.opacity = 255
  @battlecommand_window.visible = true
  if @actor.dead?
    @face.tone = Tone.new(0, 0, 0, 255)
  end
  refresh(0)
end
# -----------------------
def dispose
  super
  @face.dispose
  @battlecommand_window.dispose
end
# -----------------------
def refresh(type)
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  x_button = RPG::Cache.icon("talk06")
  draw_actor_name(@actor, 8, 96)
  draw_actor_hp(@actor, 96, 0, 144)
  draw_actor_fatigue(@actor, 96, 32)
  draw_actor_exp(@actor, 96, 64)
  draw_actor_state(@actor, 96, 100)
  draw_actor_hp_bar(@actor, 96, 28, 204)
  draw_actor_fatigue_bar(@actor, 96, 60, 204)
  draw_actor_exp_bar(@actor, 96, 92, 204)
  if type == 0
    @battlecommand_window.visible = true
    draw_stat("Level", @actor.level, 24, 133)
    draw_stat("Energy", @actor.energy, 180, 133, true)
    draw_stat("Attack", @actor.atk, 24, 181)
    draw_stat("Defense", @actor.pdef, 180, 181)
    draw_stat("Shaping Defense", @actor.mdef, 24, 229)
    draw_stat("Evasion", @actor.eva, 180, 229)
    draw_stat("Strength", @actor.str, 24, 277)
    draw_stat("Dexterity", @actor.dex, 180, 277)
    draw_stat("Agility", @actor.agi, 24, 325)
    draw_stat("Intelligence", @actor.int, 180, 325)
    draw_stat("FTR", Integer(@actor.ftr * 100), 24, 373, true)
    draw_stat("EXR", Integer(@actor.exr * 100), 180, 373, true)
    draw_item_name($data_weapons[@actor.weapon_id], 336, 0)
    draw_item_name($data_armors[@actor.armor1_id], 336, 32)
    draw_item_name($data_armors[@actor.armor2_id], 336, 64)
    draw_item_name($data_armors[@actor.armor3_id], 336, 96)
    draw_item_name($data_armors[@actor.armor4_id], 336, 128)
    if @actor.weapon_id == 0
      self.contents.draw_text(336, 0, 128, 32, "-Empty-")
    end
    if @actor.armor1_id == 0
      self.contents.draw_text(336, 32, 128, 32, "-Empty-")
    end
    if @actor.armor2_id == 0
      self.contents.draw_text(336, 64, 128, 32, "-Empty-")
    end
    if @actor.armor3_id == 0
      self.contents.draw_text(336, 96, 128, 32, "-Empty-")
    end
    if @actor.armor4_id == 0
      self.contents.draw_text(336, 128, 128, 32, "-Empty-")
    end
    self.contents.blt(400, 426, x_button, Rect.new(0, 0, 24, 24))
    self.contents.font.size = 20
    self.contents.draw_text(428, 431, 250, 16, ": Elemental/Status Resist")
  end
  if type == 1
    @battlecommand_window.visible = false
    c = Color.new(255, 255, 255, 255)
    self.contents.draw_text(8, 128, 200, 32, "Elemental Resistance")
    self.contents.fill_rect(8, 156, 288, 1, c)
    self.contents.fill_rect(8, 156, 1, 264, c)
    self.contents.fill_rect(8, 420, 288, 1, c)
    self.contents.fill_rect(296, 156, 1, 264, c)
    self.contents.draw_text(316, 32, 160, 32, "Status Resistance")
    self.contents.fill_rect(316, 60, 288, 1, c)
    self.contents.fill_rect(316, 60, 1, 360, c)
    self.contents.fill_rect(316, 420, 288, 1, c)
    self.contents.fill_rect(604, 60, 1, 360, c)
    self.contents.blt(480, 426, x_button, Rect.new(0, 0, 24, 24))
    self.contents.font.size = 20
    self.contents.draw_text(508, 431, 250, 16, ": Main Status")
    self.contents.font.size = 24
    draw_elem_res
    draw_status_res
  end
end
# -----------------------
def draw_stat(string, value, x, y, percent = false)
  v = value.to_s
  if percent
    v += " %"
  end
  self.contents.font.size = 16
  c = Color.new(255, 255, 255, 255)
  self.contents.draw_text(x, y, 120, 16, string)
  self.contents.fill_rect(x, y+16, 120, 1, c)
  self.contents.font.size = 24
  self.contents.draw_text(x, y+14, 120, 32, v, 2)
end
# -----------------------
def draw_elem_res
  draw_y = 164
  for i in 1..10
    elem_name = $data_system.elements[i]
    rank = 100 - @actor.element_rate(i, false)
    rank = rank.to_s
    rank += "%"
    self.contents.draw_text(16, draw_y, 150, 32, elem_name)
    self.contents.draw_text(230, draw_y, 60, 32, rank, 2)
    draw_y += 24
  end
end
# -----------------------
def draw_status_res
  draw_y = 68
  for i in 1..14
    status_name = $data_states[i].name
    rank = $data_classes[@actor.class_id].state_ranks[i]
    case rank
    when 1
      rank = "0%"
    when 2
      rank = "20%"
    when 3
      rank = "40%"
    when 4
      rank = "60%"
    when 5
      rank = "80%"
    when 6
      rank = "100%"
    end
    self.contents.draw_text(324, draw_y, 150, 32, status_name)
    self.contents.draw_text(538, draw_y, 60, 32, rank, 2)
    draw_y += 24
  end
end
# -----------------------
end
