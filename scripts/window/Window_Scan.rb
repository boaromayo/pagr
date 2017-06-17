class Window_Scan < Window_Base
# ------------------------------
attr_reader :remove
# ------------------------------
def initialize(target)
  super(-32, 12, 736, 288)
  @target = target
  @count = 0
  @remove = false
  self.contents = Bitmap.new(704, 256)
  self.opacity = 0
  refresh
end
# ------------------------------
def refresh
  self.contents.clear
  self.contents.fill_rect(0, 0, 704, 256, Color.new(0, 0, 0, 160))
  id = @target.id
  @s = Sprite.new
  if @target.is_a?(Game_Actor)
    if @target.id == 8
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero07.png")
    elsif @target.id == 9
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero08.png")
    elsif @target.id == 10
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero09.png")
    elsif @target.id == 11
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero10.png")
    elsif @target.id == 12
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero12.png")
    else
      @s.bitmap = Bitmap.new("Graphics/Battlers/hero01.png")
    end
  end
  if @target.is_a?(Game_Enemy)
    if @target.id <= 9
      @s.bitmap = Bitmap.new("Graphics/Battlers/monst00" + id.to_s + ".png")
    elsif @target.id <= 99
      @s.bitmap = Bitmap.new("Graphics/Battlers/monst0" + id.to_s + ".png")
    else
      @s.bitmap = Bitmap.new("Graphics/Battlers/monst" + id.to_s + ".png")
    end
  end
  if @target.is_a?(Game_Actor)
    p = 100
  end
  if @target.is_a?(Game_Enemy)
    p = $game_system.scan_percentages[id]
  end
  name = @target.name
  hp = @target.hp
  maxhp = @target.maxhp
  ft = @target.fatigue
  ex = @target.exertion
  str = @target.str
  dex = @target.dex
  agi = @target.agi
  int = @target.int
  atk = @target.atk
  pdef = @target.pdef
  mdef = @target.mdef
  eva = @target.eva
  ftr = @target.ftr * 100
  if @target.is_a?(Game_Enemy)
    ftr -= 20
    if $game_system.difficulty == 1
      ftr -= 50
    end
    if $game_system.difficulty == 2
      ftr -= 100
    end
  end
  ftr = Integer(ftr)
  exr = Integer(@target.exr * 100)
  elem_def_phys = 100 - @target.element_rate(1, false)
  elem_def_fire = 100 - @target.element_rate(2, false)
  elem_def_water = 100 - @target.element_rate(3, false)
  elem_def_ice = 100 - @target.element_rate(4, false)
  elem_def_wind = 100 - @target.element_rate(5, false)
  elem_def_earth = 100 - @target.element_rate(6, false)
  elem_def_force = 100 - @target.element_rate(7, false)
  elem_def_vac = 100 - @target.element_rate(8, false)
  elem_def_sonic = 100 - @target.element_rate(9, false)
  elem_def_psych = 100 - @target.element_rate(10, false)
  if @target.is_a?(Game_Actor)
    status_def_death = ($game_actors[@target.id].state_ranks[1] - 1) * 20
    status_def_poison = ($game_actors[@target.id].state_ranks[2] - 1) * 20
    status_def_para = ($game_actors[@target.id].state_ranks[3] - 1) * 20
    status_def_stun = ($game_actors[@target.id].state_ranks[4] - 1) * 20
    status_def_insane = ($game_actors[@target.id].state_ranks[5] - 1) * 20
    status_def_puppet = ($game_actors[@target.id].state_ranks[6] - 1) * 20
    status_def_desynch = ($game_actors[@target.id].state_ranks[7] - 1) * 20
    status_def_disease = ($game_actors[@target.id].state_ranks[8] - 1) * 20
    status_def_fear = ($game_actors[@target.id].state_ranks[9] - 1) * 20
    status_def_unsteady = ($game_actors[@target.id].state_ranks[10] - 1) * 20
    status_def_sluggish = ($game_actors[@target.id].state_ranks[11] - 1) * 20
    status_def_plague = ($game_actors[@target.id].state_ranks[12] - 1) * 20
  end
  if @target.is_a?(Game_Enemy)
    status_def_death = ($data_enemies[@target.id].state_ranks[1] - 1) * 20
    status_def_poison = ($data_enemies[@target.id].state_ranks[2] - 1) * 20
    status_def_para = ($data_enemies[@target.id].state_ranks[3] - 1) * 20
    status_def_stun = ($data_enemies[@target.id].state_ranks[4] - 1) * 20
    status_def_insane = ($data_enemies[@target.id].state_ranks[5] - 1) * 20
    status_def_puppet = ($data_enemies[@target.id].state_ranks[6] - 1) * 20
    status_def_desynch = ($data_enemies[@target.id].state_ranks[7] - 1) * 20
    status_def_disease = ($data_enemies[@target.id].state_ranks[8] - 1) * 20
    status_def_fear = ($data_enemies[@target.id].state_ranks[9] - 1) * 20
    status_def_unsteady = ($data_enemies[@target.id].state_ranks[10] - 1) * 20
    status_def_sluggish = ($data_enemies[@target.id].state_ranks[11] - 1) * 20
    status_def_plague = ($data_enemies[@target.id].state_ranks[12] - 1) * 20
  end
  @s.x = 100 - (@s.bitmap.width / 2)
  @s.y = 160 - (@s.bitmap.height / 2)
  @s.z = 2500
  self.contents.font.name = "Arial"
  self.contents.font.size = 16
  self.contents.font.color = normal_color
  name_x = 100 - (self.contents.text_size(name).width / 2)
  name_y = @s.y + @s.bitmap.height
  self.contents.draw_text(name_x, name_y, 150, 16, name)
  self.contents.draw_text(224, 9, 32, 16, "HP:")
  if rand(100) < p
    self.contents.draw_text(244, 9, 96, 16, hp.to_s + "/" + maxhp.to_s, 2)
  else
    self.contents.draw_text(244, 9, 96, 16, "???/???", 2)
  end
  self.contents.draw_text(224, 27, 32, 16, "FT:")
  if rand(100) < p
    self.contents.draw_text(244, 27, 96, 16, ft.to_s, 2)
  else
    self.contents.draw_text(244, 27, 96, 16, "???", 2)
  end
  self.contents.draw_text(224, 45, 32, 16, "EX:")
  if rand(100) < p
    self.contents.draw_text(244, 45, 96, 16, ex.to_s + "%", 2)
  else
    self.contents.draw_text(244, 45, 96, 16, "???%", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 69, 72, 16, "Strength:")
  if rand(100) < p
    if str > @target.base_str
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if str < @target.base_str
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 69, 96, 16, str.to_s, 2)
  else
    self.contents.draw_text(244, 69, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 87, 72, 16, "Dexterity:")
  if rand(100) < p
    if dex > @target.base_dex
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if dex < @target.base_dex
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 87, 96, 16, dex.to_s, 2)
  else
    self.contents.draw_text(244, 87, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 105, 72, 16, "Agility:")
  if rand(100) < p
    if agi > @target.base_agi
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if agi < @target.base_agi
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 105, 96, 16, agi.to_s, 2)
  else
    self.contents.draw_text(244, 105, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 123, 72, 16, "Intelligence:")
  if rand(100) < p
    if int > @target.base_int
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if int < @target.base_int
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 123, 96, 16, int.to_s, 2)
  else
    self.contents.draw_text(244, 123, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 141, 72, 16, "Attack:")
  if rand(100) < p
    if atk > @target.base_atk
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if atk < @target.base_atk
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 141, 96, 16, atk.to_s, 2)
  else
    self.contents.draw_text(244, 141, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 159, 72, 16, "Defense:")
  if rand(100) < p
    if pdef > @target.base_pdef
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if pdef < @target.base_pdef
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 159, 96, 16, pdef.to_s, 2)
  else
    self.contents.draw_text(244, 159, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 177, 72, 16, "S. Defense:")
  if rand(100) < p
    if mdef > @target.base_mdef
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if mdef < @target.base_mdef
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 177, 96, 16, mdef.to_s, 2)
  else
    self.contents.draw_text(244, 177, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 195, 72, 16, "Evasion:")
  if rand(100) < p
    if eva > @target.base_eva
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if eva < @target.base_eva
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 195, 96, 16, eva.to_s + "%", 2)
  else
    self.contents.draw_text(244, 195, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 213, 72, 16, "FTR:")
  if rand(100) < p
    if ftr > 100
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if ftr < 100
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 213, 96, 16, ftr.to_s + "%", 2)
  else
    self.contents.draw_text(244, 213, 96, 16, "???", 2)
  end
  self.contents.font.color = normal_color
  self.contents.draw_text(224, 231, 72, 16, "EXR:")
  if rand(100) < p
    if exr > 100
      self.contents.font.color = Color.new(0, 200, 0)
    end
    if exr < 100
      self.contents.font.color = Color.new(255, 0, 0)
    end
    self.contents.draw_text(244, 231, 96, 16, exr.to_s + "%", 2)
  else
    self.contents.draw_text(244, 231, 96, 16, "???", 2)
  end
  self.contents.fill_rect(370, 25, 236, 1, normal_color)
  self.contents.draw_text(370, 9, 200, 16, "Elemental Resistance")
  self.contents.draw_text(370, 27, 80, 16, "Physical:")
  if rand(100) < p
    self.contents.draw_text(436, 27, 40, 16, elem_def_phys.to_s + "%", 2)
  else
    self.contents.draw_text(436, 27, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 43, 80, 16, "Fire:")
  if rand(100) < p
    self.contents.draw_text(436, 43, 40, 16, elem_def_fire.to_s + "%", 2)
  else
    self.contents.draw_text(436, 43, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 59, 80, 16, "Water:")
  if rand(100) < p
    self.contents.draw_text(436, 59, 40, 16, elem_def_water.to_s + "%", 2)
  else
    self.contents.draw_text(436, 59, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 75, 80, 16, "Ice:")
  if rand(100) < p
    self.contents.draw_text(436, 75, 40, 16, elem_def_ice.to_s + "%", 2)
  else
    self.contents.draw_text(436, 75, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 91, 80, 16, "Wind:")
  if rand(100) < p
    self.contents.draw_text(436, 91, 40, 16, elem_def_wind.to_s + "%", 2)
  else
    self.contents.draw_text(436, 91, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 27, 80, 16, "Earth:")
  if rand(100) < p
    self.contents.draw_text(566, 27, 40, 16, elem_def_earth.to_s + "%", 2)
  else
    self.contents.draw_text(566, 27, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 43, 80, 16, "Force:")
  if rand(100) < p
    self.contents.draw_text(566, 43, 40, 16, elem_def_force.to_s + "%", 2)
  else
    self.contents.draw_text(566, 43, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 59, 80, 16, "Vacuum:")
  if rand(100) < p
    self.contents.draw_text(566, 59, 40, 16, elem_def_vac.to_s + "%", 2)
  else
    self.contents.draw_text(566, 59, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 75, 80, 16, "Sonic:")
  if rand(100) < p
    self.contents.draw_text(566, 75, 40, 16, elem_def_sonic.to_s + "%", 2)
  else
    self.contents.draw_text(566, 75, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 91, 80, 16, "Psychological:")
  if rand(100) < p
    self.contents.draw_text(566, 91, 40, 16, elem_def_psych.to_s + "%", 2)
  else
    self.contents.draw_text(566, 91, 40, 16, "???%", 2)
  end
  self.contents.fill_rect(370, 139, 236, 1, normal_color)
  self.contents.draw_text(370, 123, 200, 16, "Status Resistance")
  self.contents.draw_text(370, 141, 80, 16, "Death:")
  if rand(100) < p
    self.contents.draw_text(436, 141, 40, 16, status_def_death.to_s + "%", 2)
  else
    self.contents.draw_text(436, 141, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 157, 80, 16, "Poison:")
  if rand(100) < p
    self.contents.draw_text(436, 157, 40, 16, status_def_poison.to_s + "%", 2)
  else
    self.contents.draw_text(436, 157, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 173, 80, 16, "Paralysis:")
  if rand(100) < p
    self.contents.draw_text(436, 173, 40, 16, status_def_para.to_s + "%", 2)
  else
    self.contents.draw_text(436, 173, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 189, 80, 16, "Stun:")
  if rand(100) < p
    self.contents.draw_text(436, 189, 40, 16, status_def_stun.to_s + "%", 2)
  else
    self.contents.draw_text(436, 189, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 205, 80, 16, "Insane:")
  if rand(100) < p
    self.contents.draw_text(436, 205, 40, 16, status_def_insane.to_s + "%", 2)
  else
    self.contents.draw_text(436, 205, 40, 16, "???%", 2)
  end
  self.contents.draw_text(370, 221, 80, 16, "Puppet:")
  if rand(100) < p
    self.contents.draw_text(436, 221, 40, 16, status_def_puppet.to_s + "%", 2)
  else
    self.contents.draw_text(436, 221, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 141, 80, 16, "Desynch:")
  if rand(100) < p
    self.contents.draw_text(566, 141, 40, 16, status_def_desynch.to_s + "%", 2)
  else
    self.contents.draw_text(566, 141, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 157, 80, 16, "Disease:")
  if rand(100) < p
    self.contents.draw_text(566, 157, 40, 16, status_def_disease.to_s + "%", 2)
  else
    self.contents.draw_text(566, 157, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 173, 80, 16, "Fear:")
  if rand(100) < p
    self.contents.draw_text(566, 173, 40, 16, status_def_fear.to_s + "%", 2)
  else
    self.contents.draw_text(566, 173, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 189, 80, 16, "Unsteady:")
  if rand(100) < p
    self.contents.draw_text(566, 189, 40, 16, status_def_unsteady.to_s + "%", 2)
  else
    self.contents.draw_text(566, 189, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 205, 80, 16, "Sluggish:")
  if rand(100) < p
    self.contents.draw_text(566, 205, 40, 16, status_def_sluggish.to_s + "%", 2)
  else
    self.contents.draw_text(566, 205, 40, 16, "???%", 2)
  end
  self.contents.draw_text(500, 221, 80, 16, "Plague:")
  if rand(100) < p
    self.contents.draw_text(566, 221, 40, 16, status_def_plague.to_s + "%", 2)
  else
    self.contents.draw_text(566, 221, 40, 16, "???%", 2)
  end
end
# ------------------------------
def draw_lines
  self.contents.fill_rect(20, 30, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 176, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 270, 568, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 290, 9, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(21, 291, 7, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(22, 292, 5, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(23, 293, 3, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(24, 294, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(36, 290, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(35, 291, 3, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(34, 292, 5, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(33, 293, 7, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(32, 294, 9, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 314, 1, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(21, 313, 1, 3, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(22, 312, 1, 5, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(23, 311, 1, 7, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(24, 310, 1, 9, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(30, 310, 1, 9, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(31, 311, 1, 7, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(32, 312, 1, 5, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(33, 313, 1, 3, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(34, 314, 1, 1, Color.new(255, 255, 255, 255))
end
# ------------------------------
def update
  super
  @count += 1
  if @count >= 120
    @remove = true
  end
  if Input.trigger?(Input::C)
    @remove = true
  end
end
# ------------------------------
end