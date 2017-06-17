class Window_LawInfo < Window_Base
#-----------------------------
def initialize
  super(0, 304, 640, 176)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.opacity = 0
  show_data(0)
end
#-----------------------------
def show_data(index)
  self.contents.clear
  self.contents.font.name = "Times New Roman"
  self.contents.font.size = 24
  self.contents.draw_text(4, 2, 120, 32, "Information")
  self.contents.fill_rect(4, 30, 600, 1, Color.new(255, 255, 255))
  self.contents.font.size = 20
  string1 = ""
  string2 = ""
  string3 = ""
  string4 = ""
  string5 = ""
  citation = ""
  if index == -1
    return
  end
  if index == 1
    string1 = "A Jacardi citizen overheard individuals who were apparently"
    string2 = "Specterragon maintenance workers complain of deliberate"
    string3 = "indifference to unsafe concentrations of carbon monoxide"
    string4 = "in some work areas.  It may have some relevance to"
    string5 = "Metzger's claim."
  end
  if index == 2
    string1 = "An individual investigating Specterragon's environmental"
    string2 = "regulatory compliance speculates that coolant is"
    string3 = "ventilating into the rockbed substratum due to negligence"
    string4 = "on Specterragon's part.  He further believes that documentary"
    string5 = "evidence of this exists within the corporate facility."
  end
  if index == 3
    string1 = ""
    string2 = ""
    string3 = ""
  end
  if index == 4
    string1 = ""
    string2 = ""
    string3 = ""
  end
  if index == 101
    string1 = "It's a graph of particulate matter concentrations in the"
    string2 = "sub-basement of Specterragon Heavy Industries informally"
    string3 = "known as the Guantlet of Noisome Toxins.  Levels were"
    string4 = "consistently above those that would trigger a mandatory"
    string5 = "evacuation under Ehlison environmental regulations."
  end
  if index == 202
    string1 = ""
    string2 = ""
    string3 = ""
    string4 = ""
    string5 = ""
    citation = ""
  end
  self.contents.draw_text(4, 32, 608, 20, string1)
  self.contents.draw_text(4, 52, 608, 20, string2)
  self.contents.draw_text(4, 72, 608, 20, string3)
  self.contents.draw_text(4, 92, 608, 20, string4)
  self.contents.draw_text(4, 112, 608, 20, string5)
  self.contents.font.size = 24
  self.contents.draw_text(250, 2, 350, 32, citation, 2)
end
#-----------------------------
end