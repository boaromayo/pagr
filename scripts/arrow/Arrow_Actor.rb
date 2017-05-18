#==============================================================================
# ■ Arrow_Actor
#------------------------------------------------------------------------------
# 　アクターを選択させるためのアローカーソルです。このクラスは Arrow_Base クラ
# スを継承します。
#==============================================================================

class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  # ● カーソルが指しているアクターの取得
  #--------------------------------------------------------------------------
  def actor
    return $game_party.actors[@index]
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if @blink_count <= 3
      self.tone = Tone.new(0, 0, 0, 0)
    else
      self.tone = Tone.new(255, 0, 0, 0)
    end
    super
    if Input.repeat?(Input::RIGHT)
      $game_system.se_play($data_system.cursor_se)
      @index += 1
      @index %= $game_party.actors.size
    end
    if Input.repeat?(Input::LEFT)
      $game_system.se_play($data_system.cursor_se)
      @index += $game_party.actors.size - 1
      @index %= $game_party.actors.size
    end
    if self.actor != nil
      self.x = self.actor.screen_x
      self.y = self.actor.screen_y
    end
  end
end
