class Window_BattleCommand < Window_Selectable
# -----------------------------
  attr_reader :commands
  attr_reader :disabled
# -----------------------------
  def initialize(actor, width)
    @actor = actor
    super(0, 0, width, 160)
    self.x = -9999
    self.z = 1100
    @column_max = 1
    @item_max = @actor.battle_commands.size
    @commands = @actor.battle_commands
    @disabled = []
    @looping = false
    if @commands == []
      name = actor.name
      print("Error: " + name + " must have at least one battle command.")
      exit
    end
    for i in 0..@commands.size - 1
      @disabled[i] = false
    end
    self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    self.index = 0
  end
# -----------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    for i in 0...@item_max
      draw_item(i, normal_color)
      @disabled[i] = false
    end
  end
# -----------------------------
  def draw_item(index, color)
    self.contents.font.color = color
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index])
  end
# -----------------------------
  def disable_item(index)
    draw_item(index, disabled_color)
    @disabled[index] = true
  end
end
