#==============================================================================
# ■ Window_SaveFile
#------------------------------------------------------------------------------
# 　セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :filename                 # ファイル名
  attr_reader   :selected                 # 選択状態
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     file_index : セーブファイルのインデックス (0～3)
  #     filename   : ファイル名
  #--------------------------------------------------------------------------
  def initialize(file_index, filename, position)
    y = 64 + position * 104
    super(0, y, 640, 104)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    @position = position
    @viewports = []
    @faces = []
    @file_index = file_index
    @filename = "Save#{@file_index + 1}.rxdata"
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      file = File.open(@filename, "r")
      @useless = Marshal.load(file)
      @frame_count = Marshal.load(file)
      @system = Marshal.load(file)
      @useless = Marshal.load(file)
      @useless = Marshal.load(file)
      @useless = Marshal.load(file)
      @useless = Marshal.load(file)
      @useless = Marshal.load(file)
      @party = Marshal.load(file)
      @total_sec = @frame_count / Graphics.frame_rate
      file.close
    end
    refresh
    @selected = false
  end
  # ------------------
  def dispose
    super
    show = true
    if $game_system.fatal.include?(@file_index + 1)
      show = false
    end
    if @file_exist and show
      if @party.actors.size > 0
        for i in 0..@party.actors.size - 1
          @faces[i].dispose
          @viewports[i].dispose
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = normal_color
    name = "Record #{@file_index + 1}"
    self.contents.draw_text(4, 0, 600, 32, name)
    @name_width = contents.text_size(name).width
    show = true
    if $game_system.fatal.include?(@file_index + 1)
      show = false
    end
    if @file_exist and show
      if @party.actors.size > 0
        for i in 0...@party.actors.size
          actor_num = @party.actors[i].id
          filename = "Graphics/Face/face" + actor_num.to_s + ".png"
          x_coord = 296 + 80 * i
          y_coord = 80 + @position * 104
          @viewports[i] = Viewport.new(x_coord, y_coord, 96, 96)
          @viewports[i].z = 975
          @faces[i] = Sprite.new(@viewports[i])
          @faces[i].bitmap = Bitmap.new(filename)
          @faces[i].opacity = 255
          @faces[i].zoom_x = 0.75
          @faces[i].zoom_y = 0.75
          @faces[i].visible = true
          if @party.actors[i].dead?
            @faces[@position * 4 + i].tone = Tone.new(0, 0, 0, 255)
          end
        end
      end
      if @party.actors.size > 0
        name = @party.actors[0].name
        location = @system.current_location
        self.contents.draw_text(4, 40, 124, 32, name)
        self.contents.draw_text(96, 0, 172, 32, location, 2)
      end
      hour = @total_sec / 60 / 60
      min = @total_sec / 60 % 60
      sec = @total_sec % 60
      time_string = sprintf("%02d:%02d:%02d", hour, min, sec)
      self.contents.font.color = normal_color
      self.contents.draw_text(104, 40, 164, 32, time_string, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択状態の設定
  #     selected : 新しい選択状態 (true=選択 false=非選択)
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # ● カーソルの矩形更新
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @selected
      self.cursor_rect.set(0, 0, @name_width + 8, 32)
    else
      self.cursor_rect.empty
    end
  end
end
