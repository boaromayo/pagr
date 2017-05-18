#==============================================================================
# ■ Sprite_Timer
#------------------------------------------------------------------------------
# 　タイマー表示用のスプライトです。$game_system を監視し、スプライトの状態を
# 自動的に変化させます。
#==============================================================================

class Sprite_Timer < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    self.bitmap = Bitmap.new(120, 48)
    self.bitmap.font.name = "Arial"
    self.bitmap.font.size = 32
    if $game_temp.in_battle
      self.x = 620 - self.bitmap.width
      self.y = 270
      self.z = 500
    else
      self.x = 320 - self.bitmap.width / 2
      self.y = 20
      self.z = 500
    end
    update
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = $game_system.timer_working
    self.bitmap.clear
    @total_sec = $game_system.timer / Graphics.frame_rate
    frac = $game_system.timer % Graphics.frame_rate
    sec_fraction = frac.to_f / Graphics.frame_rate.to_f
    sec_fraction *= 100
    min = @total_sec / 60
    sec = @total_sec % 60
    text = sprintf("%02d:%02d:%02d", min, sec, sec_fraction)
    if @total_sec >= 60
      self.bitmap.font.color.set(255, 255, 255)
    elsif @total_sec >= 15
      self.bitmap.font.color.set(255, 255, 0)
    else
      self.bitmap.font.color.set(255, 0, 0)
    end
    self.bitmap.draw_text(self.bitmap.rect, text, 1)
  end
end
