#==============================================================================
# ■ Window_BattleSkillSupplementary
#------------------------------------------------------------------------------
# 　スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#==============================================================================

class Window_BattleSkillSupplementary < Window_Base
  #--------------------------------
  def initialize(actor)
    @actor = actor
    super(404, 246, 236, 51)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 255
    self.z = 5000
    refresh
  end
  #--------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    draw_actor_name(@actor, 4, -8)
    draw_actor_fatigue_bar(@actor, 4, 16, 200)
    draw_actor_exertion(@actor, 116, -8)
    w = self.contents.text_size(@actor.name).width
    self.contents.font.size = 14
    en = @actor.energy.to_s + "%"
    z = self.contents.text_size(en).width
    unless @actor.summon_actor
      self.contents.draw_text(w+6, 1, 10, 16, "(")
      self.contents.draw_text(w+10, 2, 30, 16, en)
      self.contents.draw_text(w+z+10, 1, 20, 16, ")")
    end
  end
end
