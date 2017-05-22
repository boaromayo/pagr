class Window_SpeakerName < Window_Base
#-------------------------
def initialize(name, x, y)
  @name = name
  @tester = Window_Base.new(0, 0, 640, 480)
  @tester.contents = Bitmap.new(@tester.width - 32, @tester.height - 32)
  @tester.contents.font.name = "Arial"
  @tester.contents.font.size = 24
  @width = @tester.contents.text_size(@name).width
  w = @width + 40
  h = 64
  @dummy_window = Window_Base.new(x, y, w, 44)
  @dummy_window.contents = Bitmap.new(@width + 8, 12)
  @dummy_window.opacity = 255
  @dummy_window.back_opacity = 255
  @dummy_window.contents_opacity = 255
  @dummy_window.z = 11500
  @tester.dispose
  super(x, y - 10, w, h)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  self.opacity = 0
  self.back_opacity = 0
  self.z = 12000
  leader
  refresh
end
#-------------------------
def leader
  if @name == "Leader"
    @name = $game_party.actors[0].name
  end
end
#-------------------------
def dispose
  super
  @dummy_window.dispose
end
#-------------------------
def refresh
  self.contents.clear
  self.contents.font.color = normal_color
  self.contents.draw_text(4, 0, @width, 32, @name)
end
#-------------------------
end

