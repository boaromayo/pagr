class Window_BattleEffect < Window_Base
  #------------------------------
  attr_accessor :effect
  attr_accessor :passive_time
  #--------------------------------------------------------------------------
  # Initialize the Object.
  #--------------------------------------------------------------------------
  def initialize
    super(184, 4, 272, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 255
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.opacity = 0
    self.z = 1050
    @dummy_window = Window_Base.new(184, 10, 272, 52)
    @dummy_window.z = 1000
    @dummy_window.opacity = 255
    @dummy_window.visible = false
    @effect = ""
    @passive_time = -1
    refresh
  end
  #----------------------------------
  def effect=(effect)
    @effect = effect
    refresh
  end
  #--------------------------------------------------------------------------
  # Refresh.
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, self.width - 32, 32, @effect, 1)
  end
  # -------------
  def dispose
    super
    @dummy_window.dispose
  end
  #--------------
  def kill_dummy
    @dummy_window.visible = false
  end
  #--------------------------------------------------------------------------
  # Frame Update.
  #--------------------------------------------------------------------------
  def update
    super
    if self.visible
      @dummy_window.visible = true
    else
      @dummy_window.visible = false
    end
    if @passive_time > 0
      @passive_time -= 1
    end
    if @passive_time == 0
      @passive_time = -1
      self.visible = false
      @dummy_window.visible = false
    end
  end
end
