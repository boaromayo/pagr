#==============================================================================
# ■ Window_SkillStatus
#------------------------------------------------------------------------------
# 　スキル画面で、スキル使用者のステータスを表示するウィンドウです。
#==============================================================================

class Window_SkillStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 64, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    draw_actor_name(@actor, 80, 0)
    self.contents.font.color = system_color
    self.contents.draw_text(180, 0, 32, 32, "HP")
    hp_percent = @actor.hp * 100 / @actor.maxhp
    if hp_percent == 0 and @actor.hp > 0
      hp_percent = 1
    end
    if hp_percent > 25
      self.contents.font.color = normal_color
    elsif hp_percent > 0
      self.contents.font.color = crisis_color
    else
      self.contents.font.color = knockout_color
    end
    self.contents.draw_text(216, 0, 48, 32, @actor.hp.to_s, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(264, 0, 12, 32, "/")
    self.contents.draw_text(274, 0, 48, 32, @actor.maxhp.to_s, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(336, 0, 32, 32, "FT")
    if @actor.fatigue > -50
      self.contents.font.color = normal_color
    elsif @actor.fatigue > -100
      self.contents.font.color = crisis_color
    else
      self.contents.font.color = knockout_color
    end
    self.contents.font.color = normal_color
    self.contents.draw_text(360, 0, 48, 32, @actor.fatigue.to_s, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(416, 0, 32, 32, "EN")
    self.contents.font.color = normal_color
    en_string = @actor.energy.to_s + "%"
    self.contents.draw_text(456, 0, 64, 32, en_string, 2)
    draw_left_arrow_info
    draw_right_arrow_info
  end
  # -----------------------------
  def draw_left_arrow_info
    self.contents.fill_rect(12, 11, 1, 9, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(11, 12, 1, 7, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(10, 13, 1, 5, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(9, 14, 1, 3, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(8, 15, 1, 1, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(4, 9, 1, 13, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(26, 9, 1, 13, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(4, 9, 22, 1, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(4, 21, 22, 1, Color.new(255, 255, 255, 255))
    self.contents.font.name = "Arial"
    self.contents.font.size = 12
    self.contents.draw_text(17, 10, 8, 12, "L")
    if $scene.mode == 0
      self.contents.font.size = 10
      self.contents.draw_text(31, 5, 50, 12, "AUTO")
      self.contents.draw_text(31, 15, 50, 12, "ABILITIES")
    end
    if $scene.mode == 1
      self.contents.font.size = 10
      self.contents.draw_text(30, 5, 50, 12, "SHAPING")
      self.contents.draw_text(30, 15, 50, 12, "ABILITIES")
    end
    if $scene.mode == 2
      self.contents.font.size = 10
      self.contents.draw_text(30, 5, 50, 12, "COMMAND")
      self.contents.draw_text(30, 15, 50, 12, "ABILITIES")
    end
  end
  # -----------------------------
   def draw_right_arrow_info
    self.contents.fill_rect(596, 11, 1, 9, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(597, 12, 1, 7, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(598, 13, 1, 5, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(599, 14, 1, 3, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(600, 15, 1, 1, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(604, 9, 1, 13, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(582, 9, 1, 13, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(582, 9, 22, 1, Color.new(255, 255, 255, 255))
    self.contents.fill_rect(582, 21, 22, 1, Color.new(255, 255, 255, 255))
    self.contents.font.name = "Arial"
    self.contents.font.size = 12
    self.contents.draw_text(587, 10, 8, 12, "R")
    if $scene.mode == 0
      self.contents.font.size = 10
      self.contents.draw_text(535, 5, 50, 12, "COMMAND")
      self.contents.draw_text(542, 15, 50, 12, "ABILITIES")
    end
    if $scene.mode == 1
      self.contents.font.size = 10
      self.contents.draw_text(556, 5, 50, 12, "AUTO")
      self.contents.draw_text(542, 15, 50, 12, "ABILITIES")
    end
    if $scene.mode == 2
      self.contents.font.size = 10
      self.contents.draw_text(543, 5, 50, 12, "SHAPING")
      self.contents.draw_text(542, 15, 50, 12, "ABILITIES")
    end
  end
end
