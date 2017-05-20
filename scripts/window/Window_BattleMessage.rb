class Window_BattleMessage < Window_Base
  #--------------------------
  attr_accessor :running
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     exp       : EXP
  #     gold      : ゴールド
  #     treasures : トレジャー
  #--------------------------------------------------------------------------
  def initialize
    @lines = $game_temp.battle_message_text
    @count = 0
    @running = true
    @frames = 0
    @remove_wait = -1
    super(20, 3, 600, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    self.z = 1100
    self.visible = false
    @dummy_window = Window_Base.new(20, 10, 600, 51)
    @dummy_window.z = 1000
    @dummy_window.opacity = 255
    @dummy_window.visible = false
    self.back_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    text = @lines[@count]
    self.contents.draw_text(4, 0, 568, 32, text)
    @dummy_window.visible = true
    self.visible = true
    if $game_temp.battle_message_text = [""]
      @dummy_window.visible = false
    end
    @count += 1
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def complete?
   return @count >= @lines.size || @lines[0] == ""
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def dispose
    super
    @dummy_window.dispose
  end
  # ---------------------
  def update
    if self.visible
      @dummy_window.visible = true
    else
      @dummy_window.visible = false
    end
    if @running == false
      return
    end
    super
    if complete?
      @running = false
      $game_temp.battle_message_text = []
      normal = $game_system.battle_message_speed / 2
      quick = 50
      if $game_temp.fast_messages_in_tutorial
        $game_temp.remove_battle_message = quick
      else
        $game_temp.remove_battle_message = normal
      end
    end
    @frames += 1
    normal = $game_system.battle_message_speed
    quick = 100
    if $game_temp.fast_messages_in_tutorial
      if @frames == quick
        self.visible = false
        @dummy_window.visible = false
      end
    else
      if @frames == normal
        self.visible = false
        @dummy_window.visible = false
      end
    end
    normal = $game_system.battle_message_speed + 20
    quick = 120
    if $game_temp.fast_messages_in_tutorial
      if @frames == quick
        @frames = 0
        refresh
      end
    else
      if @frames == normal
        @frames = 0
        refresh
      end
    end
  end
end
