#==============================================================================
# ■ Scene_Gameover
#------------------------------------------------------------------------------
# 　ゲームオーバー画面の処理を行うクラスです。
#==============================================================================

class Scene_Gameover
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.gameover($data_system.gameover_name)
    @frame_count = 0
    @actor = $game_party.actors[0]
    if @actor == nil
      $game_party.add_actor(8)
      @actor = $game_party.actors[0]
    end
    @text1 = "You were defeated..."
    @text2 = "The Psychopolitical Drama"
    @text3 = "will go on without " + @actor.name
    @text4 = "and his companions."
    @text_window = Window_Base.new(0, 0, 640, 480)
    @text_window.contents = Bitmap.new(608, 448)
    @text_window.contents.font.name = "Monotype Corsiva"
    @text_window.contents.font.size = 36
    @text_window.opacity = 0
    @text_window.contents_opacity = 0
    @text_window.z = 4000
    @text_window.contents.draw_text(344, 178, 608, 48, @text1)
    $game_system.bgm_play(nil)
    $game_system.bgs_play(nil)
    $game_system.me_play($data_system.gameover_me)
    Graphics.transition(60)
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @text_window.dispose
    @sprite.bitmap.dispose
    @sprite.dispose
    Graphics.transition(40)
    Graphics.freeze
    if $BTEST
      $scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @frame_count += 1
    animate
    if Input.trigger?(Input::C) && @frame_count > 180
      $scene = Scene_Title.new
    end
  end
  # -------------------
  def animate
    if @frame_count > 0
      if @frame_count <= 32
        @text_window.contents_opacity += 8
        if @text_window.contents_opacity > 255
          @text_window.contents_opacity = 255
        end
      end
    end
    if @frame_count > 92
      if @frame_count <= 124
        @text_window.contents_opacity -= 8
        if @text_window.contents_opacity < 0
          @text_window.contents_opacity = 0
        end
      end
    end
    if @frame_count == 125
      @text_window.contents.clear
      @text_window.contents.font.name = "Monotype Corsiva"
      @text_window.contents.font.size = 36
      @text_window.contents.draw_text(320, 138, 608, 48, @text2)
      @text_window.contents.draw_text(320, 182, 608, 48, @text3)
      @text_window.contents.draw_text(320, 226, 608, 48, @text4)
    end
    if @frame_count > 125
      if @frame_count <= 157
        @text_window.contents_opacity += 8
        if @text_window.contents_opacity > 255
          @text_window.contents_opacity = 255
        end
      end
    end
  end
end
