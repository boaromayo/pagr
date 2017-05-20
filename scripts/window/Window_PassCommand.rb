class Window_PassCommand < Window_Command
# -------------------------------
def refresh
  self.contents.clear
  for i in 0...@item_max
    draw_item(i, normal_color)
  end
end
# -------------------------------
def draw_item(index, color)
  self.contents.font.color = color
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
  self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
  self.contents.draw_text(rect, @commands[index])
end
# -------------------------------
end

