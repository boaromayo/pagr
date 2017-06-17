class Window_Schizoconditionals < Window_Selectable
# ---------------------
attr_reader :commands
# ---------------------
def initialize(width, commands)
  super(0, 0, width, 288)
  @item_max = commands.size
  @commands = commands
  @column_max = 1
  self.contents = Bitmap.new(width - 32, @item_max * 32)
  refresh
  self.index = 0
end
# ---------------------
def refresh
  self.contents.clear
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  for i in 0...@item_max
    draw_item(i, normal_color)
  end
end
# ---------------------
def draw_item(index, color)
  self.contents.font.color = color
  rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
  self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
  self.contents.draw_text(rect, @commands[index])
end
# ---------------------
def descriptions
  s1 = ""
  s2 = ""
  s3 = ""
  case @commands[self.index]
  when "HP less than 25%"
    s1 = "Nepthe's HP is less than 25% of"
    s2 = "maximum."
    s3 = ""
  when "FT less than 0"
    s1 = "Nepthe has less than 0 FT."
    s2 = ""
    s3 = ""
  when "EX 50%"
    s1 = "Nepthe's EX is at least 50%."
    s2 = ""
    s3 = ""
  when "EX 150%"
    s1 = "Nepthe's EX is at least 150%."
    s2 = ""
    s3 = ""
  when "Faint Flag"
    s1 = "Nepthe has fainted at least once"
    s2 = "this battle.  Synapses depend on"
    s3 = "lowest FT.  Flag is cleared on use."
  when "Status Ailment Present"
    s1 = "Nepthe has at least one status"
    s2 = "ailment."
    s3 = ""
  when "Four Ailments Present"
    s1 = "Nepthe has at least four status"
    s2 = "ailments."
    s3 = ""
  when "Recent HP Recovery"
    s1 = "Nepthe has recovered HP from a"
    s2 = "skill or item within the last twenty"
    s3 = "seconds."
  when "Recent FT Recovery"
    s1 = "Nepthe has recovered FT from a"
    s2 = "skill or item within the last twenty"
    s3 = "seconds."
  when "Recent EX Recovery"
    s1 = "Nepthe has recovered EX from a"
    s2 = "skill or item within the last twenty"
    s3 = "seconds."
  when "Revived Recently"
    s1 = "Nepthe has been revived from death"
    s2 = "recently."
    s3 = ""
  when "System Shock"
    s1 = "Nepthe has taken damage greater than"
    s2 = "or equal to 1/3 his maximum HP this"
    s3 = "battle.  Flag resets on use."
  when "Idle"
    s1 = "Nepthe has taken no action for the last"
    s2 = "thirty seconds.  Has no effect when"
    s3 = "using a passive Command Ability."
  when "Last Resort"
    s1 = "All other party members besides"
    s2 = "Nepthe are dead."
    s3 = ""
  when "Crowd"
    s1 = "At least four monsters are present in"
    s2 = "the current battle.  Synapses increase"
    s3 = "with larger numbers of monsters."
  when "No Damage"
    s1 = "Nepthe has taken no damage within the"
    s2 = "last thirty seconds."
    s3 = ""
  end
  return [s1, s2, s3]
end
# ---------------------
end
