#==============================================================================
# ■ Arrow_Base
#------------------------------------------------------------------------------
# 　バトル画面で使用するアローカーソル表示用のスプライトです。このクラスは
# Arrow_Enemy クラスと Arrow_Actor クラスのスーパークラスとして使用されます。
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :index
  attr_reader   :help_window
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = RPG::Cache.windowskin($game_system.windowskin_name)
    self.ox = 40
    self.oy = 40
    self.z = 2500
    @blink_count = 0
    @index = 0
    @help_window = nil
    update
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置の設定
  #     index : 新しいカーソル位置
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの設定
  #     help_window : 新しいヘルプウィンドウ
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    if @help_window != nil
      if self.is_a?(Arrow_Actor)
        update_help
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @blink_count = (@blink_count + 1) % 8
    if @blink_count < 4
      self.src_rect.set(128, 96, 32, 32)
    else
      self.src_rect.set(160, 96, 32, 32)
    end
    if @help_window != nil
      if self.is_a?(Arrow_Actor)
        update_help
      end
    end
  end
end
