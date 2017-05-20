class Window_MonsterData < Window_Base
  # ---------------------------
  def initialize
    @count = -1
    if $game_temp.in_battle == false
      lines = 1
      @count = 0
    else
      lines = $game_troop.enemies.size
    end
    lines += 2
    super(208, 0, 432, lines * 32)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 255
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    refresh
  end
  # ---------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = normal_color
    if @count >= 0
      self.contents.draw_text(4, 0, 200, 32, "No data to display.")
      self.contents.draw_text(4, 32, 400, 32, 
      "Monster data window was called outside of battle.")
      return
    end
    self.contents.fill_rect(0, 32, 400, 1, normal_color)
    y = 32
    self.contents.draw_text(4, 0, 72, 32, "Name")
    self.contents.draw_text(194, 0, 28, 32, "HP")
    self.contents.draw_text(334, 0, 28, 32, "FT")
    for enemy in $game_troop.enemies
      self.contents.font.color = normal_color
      name = enemy.name
      hp = enemy.hp
      max_hp = enemy.maxhp
      ft = enemy.fatigue
      if hp == 0 && enemy.hidden == false
        self.contents.font.color = knockout_color
      end
      if enemy.hidden == true
        self.contents.font.color = disabled_color
      end
      self.contents.draw_text(4, y, 150, 32, name)
      self.contents.font.color = normal_color
      if enemy.hidden == true
        self.contents.font.color = disabled_color
      end
      if hp <= max_hp / 4 && enemy.hidden == false
        self.contents.font.color = crisis_color
      end
      if hp == 0 && enemy.hidden == false
        self.contents.font.color = knockout_color
      end
      self.contents.draw_text(132, y, 72, 32, hp.to_s, 2)
      self.contents.font.color = normal_color
      if enemy.hidden == true
        self.contents.font.color = disabled_color
      end
      self.contents.draw_text(204, y, 6, 32, "/")
      self.contents.font.color = normal_color
      if enemy.hidden == true
        self.contents.font.color = disabled_color
      end
      self.contents.draw_text(210, y, 72, 32, max_hp.to_s, 2)
      if enemy.hidden == true
        self.contents.font.color = disabled_color
      end
      if ft <= -50 && enemy.hidden == false
        self.contents.font.color = crisis_color
      end
      if ft <= -100 && enemy.hidden == false
        self.contents.font.color = knockout_color
      end
      self.contents.draw_text(296, y, 48, 32, ft.to_s, 2)
      self.contents.font.color = normal_color
      y += 32
    end
  end
  # ---------------------------
  def update
    super
    if $game_temp.in_battle == false
      @count += 1
    end
    if @count == 100
      dispose
    end
   end
  end

