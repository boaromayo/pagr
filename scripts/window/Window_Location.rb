class Window_Location < Window_Base
  #------------------------------
  attr_accessor :location
  #--------------------------------------------------------------------------
  # Initialize the Object.
  #--------------------------------------------------------------------------
  def initialize
    super(144, 4, 352, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 255
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.opacity = 0
    self.z = 1050
    @dummy_window = Window_Base.new(144, 10, 352, 52)
    @dummy_window.z = 1000
    @dummy_window.opacity = 255
    @dummy_window.visible = false
    @location = ""
    @frames = -1
    refresh
  end
  #----------------------------------
  def location=(location)
    if location != ""
      @location = location
      @frames = 120
      @dummy_window.visible = true
      self.visible = true
      refresh
    else
      @location = ""
      @dummy_window.visible = false
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # Refresh.
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, self.width - 32, 32, @location, 1)
  end
  # -------------
  def dispose
    super
    @dummy_window.dispose
  end
  #--------------------------------------------------------------------------
  # Frame Update.
  #--------------------------------------------------------------------------
  def update
    super
    if @frames > 0
      @frames -= 1
    end
    if @frames == 0
      @frames = -1
      self.visible = false
      @dummy_window.visible = false
    end
  end
end
