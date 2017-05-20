class Window_MonsterName < Window_Base
  #--------------------------------------------------------------------------
  # Initialize the Object.
  #--------------------------------------------------------------------------
  def initialize
    super(0, 320, 236, 160)
    self.z = 1100
    refresh
  end
  #--------------------------------------------------------------------------
  # Refresh.
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @monsters = 0
    for i in $game_troop.enemies
      if i.exist?
        @monsters += 1
      end
    end
    if @monsters <= 4
      self.contents = Bitmap.new(width - 32, height - 32)
    else
      self.contents = Bitmap.new(width - 32, @monsters * 32)
    end
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.back_opacity = 255
    display_y = 0
    self.contents.font.size = 24
     for i in $game_troop.enemies
      if i.exist?
        name = i.name
        self.contents.font.size = 24
        self.contents.draw_text(4, display_y, 236, 32, name)
        display_y += 32
      end      
    end
  end
  #--------------------------------------------------------------------------
  # Frame Update.
  #--------------------------------------------------------------------------
  def update
    super
    if Input.trigger?(Input::R) && self.oy < (@monsters - 4) * 32
      self.oy += 32
    end
    if Input.trigger?(Input::L) && self.oy > 0
      self.oy -= 32
    end
    if self.oy > (@monsters - 4) * 32
      self.oy = (@monsters - 4) * 32
    end
    if @monsters <= 4
      self.oy = 0
    end
  end
end
