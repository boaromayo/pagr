class Window_Surprise < Window_Base
#-------------------------------
  def initialize(type, crush, time, powerful)
    @type = type
    @crush = crush
    @time = time
    @powerful_enemy = powerful
    @count = -1
    if @type.abs == 3 or @type == -4
      @time = 125
    end
    super(0, 0, 240, 280)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 500
    self.opacity = 0
    setup_location
    refresh
    self.visible = true
  end
# -------------------------------
  def setup_location
    if @type < 0
      self.x = -20
      self.y = 15
    end
    if @type > 0
      self.x = 420
      self.y = 15
    end
  end
# -------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Monotype Corsiva"
    self.contents.font.size = 36
    line = Rect.new(0, 36, 208, 1)
    self.contents.fill_rect(line, normal_color)
    case @type
    when -4
      self.contents.draw_text(4, 0, 202, 36, "Powerful Enemy", 2)
      maxhp_up = @powerful_enemy[0]
      str_up = @powerful_enemy[1]
      dex_up = @powerful_enemy[2]
      agi_up = @powerful_enemy[3]
      int_up = @powerful_enemy[4]
      ftr_up = @powerful_enemy[5]
      exr_up = @powerful_enemy[6]
      draw_y = 35
      if maxhp_up > 0
        string = "Max HP + " + maxhp_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if str_up > 0
        string = "Strength + " + str_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if dex_up > 0
        string = "Dexterity + " + dex_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if agi_up > 0
        string = "Agility + " + agi_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if int_up > 0
        string = "Intelligence + " + int_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if ftr_up > 0
        string = "FTR + " + ftr_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
        draw_y += 32
      end
      if exr_up > 0
        string = "EXR + " + exr_up.to_s + "%"
        self.contents.draw_text(4, draw_y, 202, 36, string, 2)
      end
    when -3
      self.contents.draw_text(4, 0, 202, 36, "Support Crush", 2)
      for i in 0..@crush.size - 1
        self.contents.draw_text(4, 35 + i * 32, 202, 36, @crush[i], 2)
      end
    when -2
      self.contents.draw_text(4, 0, 202, 36, "Initiative", 2)
      self.contents.draw_text(4, 34, 202, 36, "Enemy", 2)
    when -1
      self.contents.draw_text(4, 0, 202, 36, "Tactical Ambush", 2)
      self.contents.draw_text(4, 34, 202, 36, "Enemy", 2)
    when 1
      self.contents.draw_text(4, 0, 202, 36, "Tactical Ambush")
      self.contents.draw_text(4, 34, 202, 36, "Party")
    when 2
       self.contents.draw_text(4, 0, 202, 36, "Initiative")
      self.contents.draw_text(4, 34, 202, 36, "Party")
    when 3
      self.contents.draw_text(4, 0, 202, 36, "Support Crush")
      for i in 0..@crush.size - 1
        self.contents.draw_text(4, 35 + i * 32, 202, 36, @crush[i])
      end
    end
  end
# -------------------------------
  def update
    super
    if @time > 0
      @count += 1
    end
    if @count == @time
      self.visible = false
    end
  end
end
