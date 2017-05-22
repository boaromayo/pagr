class Window_ConfigInfo < Window_Base
#-----------------------------
def initialize
  super(0, 352, 640, 128)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  show_data(-1)
end
#-----------------------------
def show_data(index)
  self.contents.clear
  if index == -1
    return
  end
  if index == 0
    string1 = "Message Speed"
    string2 = "Determines how quickly messages appear onsceen."
    string3 = "Choose \"Instant\" to show text instantly."
  end
  if index == 1
    string1 = "Battle Message Speed"
    string2 = "This number determines how quickly messages shown in battle"
    string3 = "advance.  Lower numbers represent faster speeds."
  end
  if index == 2
    string1 = "Battle Status Update"
    string2 = "Select the interval at which battle status windows update."
    string3 = "Higher numbers will reduce lag, but appear choppy."
  end
  if index == 3
    string1 = "Cursor Memory"
    string2 = "Select \"Initialize\" to make the cursor appear at the top of"
    string3 = "the menu or \"Memorize\" to memorize the cursor position."
  end
  if index == 4
    string1 = "Author Comment Display"
    string2 = "Choose whether or not to show RPG Advocate's comments"
    string3 = "during the game."
  end
  if index == 5
    string1 = "Window Style"
    string2 = "Select a background style for the game windows."
    string3 = ""
  end
  self.contents.draw_text(4, 0, 400, 32, string1)
  self.contents.draw_text(4, 32, 608, 32, string2)
  self.contents.draw_text(4, 64, 608, 32, string3)
end
#-----------------------------
end
