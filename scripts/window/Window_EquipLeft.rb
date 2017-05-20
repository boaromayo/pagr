class Window_EquipLeft < Window_Base
# -----------------------
  attr_accessor :mode
  attr_accessor :changes
# -----------------------
  def initialize(actor)
    super(0, 64, 272, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.z += 100
    actor_num = actor.id
    filename = "Graphics/Face/face" + actor_num.to_s + ".png"
    @actor = actor
    @mode = 0
    @changes = [0, 0, 0, 0, 0, 0, 0, 0]
    @elem_text = ""
    @stat_text = ""
    @viewport = Viewport.new(8, 80, 96, 96)
    @viewport.z = 975
    @face = Sprite.new(@viewport)
    @face.bitmap = Bitmap.new(filename)
    @face.opacity = 255
    @face.visible = true
    if @actor.dead?
      @face.tone = Tone.new(0, 0, 0, 255)
    end
    refresh
  end
# -----------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 100, 0)
    draw_actor_level(@actor, 100, 32)
    draw_actor_parameter(@actor, 4, 128, 0)
    draw_actor_parameter(@actor, 4, 160, 1)
    draw_actor_parameter(@actor, 4, 192, 2)
    draw_actor_parameter(@actor, 4, 224, 3)
    draw_actor_parameter(@actor, 4, 256, 4)
    draw_actor_parameter(@actor, 4, 288, 5)
    draw_actor_parameter(@actor, 4, 320, 6)
    draw_actor_parameter(@actor, 4, 352, 7)
    self.contents.draw_text(12, 288, 220, 32, @elem_text)
    self.contents.draw_text(12, 352, 220, 32, @stat_text)
    if @new_atk != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 139)
      if @changes[0] == 0
        self.contents.font.color = normal_color
      elsif @changes[0] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 128, 36, 32, @new_atk.to_s, 2)
    end
    if @new_pdef != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 171)
      if @changes[1] == 0
        self.contents.font.color = normal_color
      elsif @changes[1] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 160, 36, 32, @new_pdef.to_s, 2)
    end
    if @new_mdef != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 203)
      if @changes[2] == 0
        self.contents.font.color = normal_color
      elsif @changes[2] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 192, 36, 32, @new_mdef.to_s, 2)
    end
    if @new_str != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 235)
      if @changes[3] == 0
        self.contents.font.color = normal_color
      elsif @changes[3] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 224, 36, 32, @new_str.to_s, 2)
    end
     if @new_dex != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 267)
      if @changes[4] == 0
        self.contents.font.color = normal_color
      elsif @changes[4] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 256, 36, 32, @new_dex.to_s, 2)
    end
      if @new_agi != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 299)
      if @changes[5] == 0
        self.contents.font.color = normal_color
      elsif @changes[5] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 288, 36, 32, @new_agi.to_s, 2)
    end
      if @new_int != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 331)
      if @changes[6] == 0
        self.contents.font.color = normal_color
      elsif @changes[6] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 320, 36, 32, @new_int.to_s, 2)
    end
      if @new_eva != nil
      self.contents.font.color = system_color
      draw_arrow_thingy(172, 363)
      if @changes[6] == 0
        self.contents.font.color = normal_color
      elsif @changes[6] == -1
        self.contents.font.color = down_color
      else
        self.contents.font.color = up_color
      end
      self.contents.draw_text(200, 352, 36, 32, @new_eva.to_s, 2)
    end
  end
# -----------------------
 def set_new_parameters(new_atk, new_pdef, new_mdef, new_str, new_dex,
    new_agi, new_int, new_eva, elem_text, stat_text)
    flag = false
    if new_atk != @new_atk || new_pdef != @new_pdef || new_mdef != @new_mdef
      flag = true
    end
    if new_str != @new_str || new_dex != @new_dex || new_agi != @new_agi
      flag = true
    end
     if new_eva != @new_eva || elem_text != @elem_text || stat_text != @stat_text
      flag = true
    end
      @new_atk = new_atk
      @new_pdef = new_pdef
      @new_mdef = new_mdef
      @new_str = new_str
      @new_dex = new_dex
      @new_agi = new_agi
      @new_int = new_int
      @new_eva = new_eva
      @elem_text = elem_text
      @stat_text = stat_text
      if flag
        refresh
      end
    end
# -----------------------
 def draw_actor_parameter(actor, x, y, type)
    case type
    when 0
      parameter_name = "Attack"
      parameter_value = actor.atk
    when 1
      parameter_name = "Defense"
      parameter_value = actor.pdef
    when 2
      parameter_name = "S. Defense"
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
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 112, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 120, y, 36, 32, parameter_value.to_s, 2)
  end
# -----------------------
def draw_arrow_thingy(x, y)
  self.contents.fill_rect(x, y, 1, 9, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(x+1, y+1, 1, 7, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(x+2, y+2, 1, 5, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(x+3, y+3, 1, 3, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(x+4, y+4, 1, 1, Color.new(255, 255, 255, 255))
end
# -----------------------
def dispose
    super
    @face.dispose
  end
# -----------------------
end
