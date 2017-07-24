#==============================================================================
# ■ Scene_Status
#------------------------------------------------------------------------------
# 　ステータス画面の処理を行うクラスです。
#==============================================================================

class Scene_Status
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_index : アクターインデックス
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, equip_index = 0)
    @actor_index = actor_index
    @mode = 0
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    @actor = $game_party.actors[@actor_index]
    @status_window = Window_Status.new(@actor)
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @status_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    $game_system.menu_encounters
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new(4)
      return
    end
    if Input.trigger?(Input::X)
      $game_system.se_play($data_system.cursor_se)
      if @mode == 0
        @mode = 1
        @status_window.refresh(1)
        return
      end
      if @mode == 1
        @mode = 0
        @status_window.refresh(0)
        return
      end
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Status.new(@actor_index)
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Status.new(@actor_index)
      return
    end
  end
end