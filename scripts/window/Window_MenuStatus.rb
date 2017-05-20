#==============================================================================
# ■ Window_MenuStatus
#------------------------------------------------------------------------------
# 　メニュー画面でパーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 448, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    @viewports = []
    @faces = []
    for i in 0..$game_party.actors.size - 1
      actor_num = $game_party.actors[i].id
      filename = "Graphics/Face/face" + actor_num.to_s + ".png"
      @viewports[i] = Viewport.new(8, 16 + i * 116, 96, 96)
      @viewports[i].z = 975
      @faces[i] = Sprite.new(@viewports[i])
      @faces[i].bitmap = Bitmap.new(filename)
      @faces[i].opacity = 255
      @faces[i].visible = true
      if $game_party.actors[i].dead?
        @faces[i].tone = Tone.new(0, 0, 0, 255)
      end
    end
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    ai_graphic = Bitmap.new("Graphics/Stuff/ai01.png")
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 96
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_name(actor, x, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x, y + 68)
      draw_actor_hp(actor, x + 112, y)
      draw_actor_hp_bar(actor, x + 112, y + 28, 204)
      draw_actor_fatigue(actor, x + 112, y + 32)
      draw_actor_fatigue_bar(actor, x + 112, y + 60, 204)
      draw_actor_exp(actor, x + 112, y + 64)
      draw_actor_exp_bar(actor, x + 112, y + 92, 204)
      if actor.ai_tactics.size > 0
        self.contents.blt(x + 72, y + 7, ai_graphic, Rect.new(0, 0, 16, 16))
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの矩形更新
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index < 0
      self.cursor_rect.empty
    else
      self.cursor_rect.set(0, @index * 116, self.width - 32, 96)
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの矩形更新
  #--------------------------------------------------------------------------
  def dispose
    super
    for i in 0..$game_party.actors.size - 1
      @faces[i].dispose
      @viewports[i].dispose
    end
  end
end
