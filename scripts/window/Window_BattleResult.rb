#==============================================================================
# ■ Window_BattleResult
#------------------------------------------------------------------------------
# 　バトル終了時に、獲得した EXP やゴールドなどを表示するウィンドウです。
#==============================================================================

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     exp       : EXP
  #     gold      : ゴールド
  #     treasures : トレジャー
  #--------------------------------------------------------------------------
  def initialize(type, value)
    @type = type
    @value = value
    super(20, 3, 600, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.y = 10
    self.z = 1100
    self.opacity = 0
    self.visible = true
    @dummy_window = Window_Base.new(20, 10, 600, 51)
    @dummy_window.z = 1000
    @dummy_window.opacity = 255
    @dummy_window.visible = false
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def dispose
    super
    @dummy_window.dispose
    if @sprite1 != nil
      @sprite1.dispose
    end
    if @sprite2 != nil
      @sprite2.dispose
    end
    if @sprite3 != nil
      @sprite3.dispose
    end
     if @sprite4 != nil
      @sprite4.dispose
    end
  end
  # ----------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    string = ""
    @dummy_window.visible = true
    case @type
      when 1
      string = @value.to_s + " Experience Points."
      when 2
      string = @value.to_s + " Yk."
      when 3
      item = $data_skills[@value].name
      string = "Nepthe learned " + item + "."
      when 4
      item = $data_items[@value].name
      string = item + " was discovered among the corpses."
      when 5
      item = $data_weapons[@value].name
      string = item + " was discovered among the corpses."
      when 6
      item = $data_armors[@value].name
      string = item + " was discovered among the corpses."
      when 7
      int1 = @value[0]
      int2 = @value[1]
      int3 = @value[2]
      int4 = @value[3]
      sprite1_filename = "Graphics/icons/jewel01.png"
      sprite2_filename = "Graphics/icons/jewel02.png"
      sprite3_filename = "Graphics/icons/jewel03.png"
      sprite4_filename = "Graphics/icons/jewel04.png"
      string = "Succor Interfaces:"
      sprite_x = 220
      text_x = 216
      if int1 > 0
        @vp1 = Viewport.new(sprite_x, 24, 24, 24)
        @vp1.z = 5000
        @sprite1 = Sprite.new(@vp1)
        @sprite1.bitmap = Bitmap.new(sprite1_filename)
        self.contents.draw_text(text_x, -7, 12, 32, "x")
        self.contents.draw_text(text_x + 12, -7, 12, 32, int1.to_s)
        sprite_x += 72
        text_x += 72
      end
      if int2 > 0
        @vp2 = Viewport.new(sprite_x, 24, 24, 24)
        @vp2.z = 5000
        @sprite2 = Sprite.new(@vp2)
        @sprite2.bitmap = Bitmap.new(sprite2_filename)
        self.contents.draw_text(text_x, -7, 12, 32, "x")
        self.contents.draw_text(text_x + 12, -7, 12, 32, int2.to_s)
        sprite_x += 72
        text_x += 72
      end
      if int3 > 0
        @vp3 = Viewport.new(sprite_x, 24, 24, 24)
        @vp3.z = 5000
        @sprite3 = Sprite.new(@vp3)
        @sprite3.bitmap = Bitmap.new(sprite3_filename)
        self.contents.draw_text(text_x, -7, 12, 32, "x")
        self.contents.draw_text(text_x + 12, -7, 12, 32, int3.to_s)
        sprite_x += 72
        text_x += 72
      end
      if int4 > 0
        @vp4 = Viewport.new(sprite_x, 24, 24, 24)
        @vp4.z = 5000
        @sprite4 = Sprite.new(@vp4)
        @sprite4.bitmap = Bitmap.new(sprite4_filename)
        self.contents.draw_text(text_x, -7, 12, 32, "x")
        self.contents.draw_text(text_x + 12, -7, 12, 32, int4.to_s)
      end
      when 8
      actor = $game_actors[@value].name
      string = actor + "'s level increased!"
      when 9
      string = "Nepthe learned a new Schizoconditional."
    end
    self.contents.draw_text(4, -7, 568, 32, string)
    y = 32
  end
end
