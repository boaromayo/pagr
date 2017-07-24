#==============================================================================
# ■ Scene_Save
#------------------------------------------------------------------------------
# 　セーブ画面の処理を行うクラスです。
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super("Archive temporal stream in which record?")
    @confirm_window = Window_Base.new(120, 188, 400, 64)
    @confirm_window.contents = Bitmap.new(368, 32)
    string = "Really overwrite archived time stream?"
    @confirm_window.contents.font.name = "Arial"
    @confirm_window.contents.font.size = 24
    @confirm_window.contents.draw_text(4, 0, 368, 32, string)
    @yes_no_window = Window_Command.new(100, ["Yes", "No"])
    @confirm_window.visible = false
    @confirm_window.z = 1500
    @yes_no_window.visible = false
    @yes_no_window.active = false
    @yes_no_window.index = 1
    @yes_no_window.x = 270
    @yes_no_window.y = 252
    @yes_no_window.z = 1500
    @mode = 0
  end
  def kill
    @confirm_window.dispose
    @yes_no_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 決定時の処理
  #--------------------------------------------------------------------------
  def on_decision(filename)
    if FileTest.exist?(filename)
      @confirm_window.visible = true
      @yes_no_window.visible = true
      @yes_no_window.active = true
      @mode = 1
    else
      $game_system.se_play($data_system.save_se)
      file = File.open(filename, "wb")
      write_save_data(file)
      file.close
      if $game_temp.save_calling
        $game_temp.save_calling = false
        kill
        $scene = Scene_Map.new
      return
    end
    kill
    $scene = Scene_Menu.new(7)
    end
  end
  #--------------------------------------------------------------------------
  # ● キャンセル時の処理
  #--------------------------------------------------------------------------
  def update
    if @mode == 0
      if Input.repeat?(Input::C)
        $game_system.se_play($data_system.decision_se)
      end
      super
    else
      @help_window.update
      @yes_no_window.update
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        if @yes_no_window.index == 0
          filename = make_filename(@file_index)
          $game_system.se_play($data_system.save_se)
          file = File.open(filename, "wb")
          write_save_data(file)
          file.close
          if $game_temp.save_calling
            $game_temp.save_calling = false
          end
          kill
          $scene = Scene_Map.new
          return
        else
          @confirm_window.visible = false
          @yes_no_window.visible = false
          @yes_no_window.active = false
          @yes_no_window.index = 1
          @mode = 0
        end
      end
      if Input.trigger?(Input::B)
        @confirm_window.visible = false
        @yes_no_window.visible = false
        @yes_no_window.active = false
        @yes_no_window.index = 1
        @mode = 0
      return
    end
  end
end
  #--------------------------------------------------------------------------
  # ● キャンセル時の処理
  #--------------------------------------------------------------------------
  def on_cancel
    $game_system.se_play($data_system.cancel_se)
    if $game_temp.save_calling
      $game_temp.save_calling = false
      kill
      $scene = Scene_Map.new
      return
    end
    kill
    $scene = Scene_Menu.new(7)
  end
  #--------------------------------------------------------------------------
  # ● セーブデータの書き込み
  #     file : 書き込み用ファイルオブジェクト (オープン済み)
  #--------------------------------------------------------------------------
  def write_save_data(file)
    characters = []
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      characters.push([actor.character_name, actor.character_hue])
    end
    Marshal.dump(characters, file)
    Marshal.dump(Graphics.frame_count, file)
    $game_system.save_count += 1
    $game_system.magic_number = $data_system.magic_number
    Marshal.dump($game_system, file)
    Marshal.dump($game_switches, file)
    Marshal.dump($game_variables, file)
    Marshal.dump($game_self_switches, file)
    Marshal.dump($game_screen, file)
    Marshal.dump($game_actors, file)
    Marshal.dump($game_party, file)
    Marshal.dump($game_troop, file)
    Marshal.dump($game_map, file)
    Marshal.dump($game_player, file)
    Marshal.dump($game_extras, file)
    Marshal.dump($game_schizo, file)
    Marshal.dump($game_lawsystem, file)
    Marshal.dump($game_itembag, file)
  end
end