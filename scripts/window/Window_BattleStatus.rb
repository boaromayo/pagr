#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面でパーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_BattleStatus < Window_Base
  #-------------------------------------
  attr_accessor :highlight_index
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(236, 320, 404, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    ai_graphic = Bitmap.new("Graphics/Stuff/ai01.png")
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      actor_y = i * 32
      draw_actor_name(actor, 4, actor_y)
      self.contents.font.color = normal_color
      draw_actor_hp(actor, 100, actor_y, 144)
      draw_actor_fatigue_bar(actor, 4, actor_y + 28, 238)
      draw_actor_exertion(actor, 272, actor_y)
      draw_actor_delay_bar(actor, 272, actor_y + 28, 100)
      if actor.ai_tactics.size > 0
        self.contents.blt(78, actor_y + 7, ai_graphic, Rect.new(0, 0, 16, 16))
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if $game_temp.battle_main_phase
      self.contents_opacity = 255
    end
  end
end
