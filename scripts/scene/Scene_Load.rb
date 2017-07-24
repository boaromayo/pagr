#==============================================================================
# ■ Scene_Load
#------------------------------------------------------------------------------
# 　ロード画面の処理を行うクラスです。
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    $game_temp = Game_Temp.new
    $game_temp.last_file_index = 0
    latest_time = Time.at(0)
    for i in 0..98
      filename = make_filename(i)
      if FileTest.exist?(filename)
        file = File.open(filename, "r")
        if file.mtime > latest_time
          latest_time = file.mtime
          $game_temp.last_file_index = i
        end
        file.close
      end
    end
    super("Synchronize with which temporal stream record?")
  end
  #--------------------------------------------------------------------------
  # ● 決定時の処理
  #--------------------------------------------------------------------------
  def on_decision(filename)
    unless FileTest.exist?(filename)
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    $game_system.se_play($data_system.load_se)
    file = File.open(filename, "rb")
    read_save_data(file)
    file.close
    $game_system.bgm_play($game_system.playing_bgm)
    $game_system.bgs_play($game_system.playing_bgs)
    $game_map.update
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● キャンセル時の処理
  #--------------------------------------------------------------------------
  def on_cancel
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Title.new
  end
  #--------------------------------------------------------------------------
  # ● セーブデータの読み込み
  #     file : 読み込み用ファイルオブジェクト (オープン済み)
  #--------------------------------------------------------------------------
  def read_save_data(file)
    characters = Marshal.load(file)
    Graphics.frame_count = Marshal.load(file)
    $game_system        = Marshal.load(file)
    $game_switches      = Marshal.load(file)
    $game_variables     = Marshal.load(file)
    $game_self_switches = Marshal.load(file)
    $game_screen        = Marshal.load(file)
    $game_actors        = Marshal.load(file)
    $game_party         = Marshal.load(file)
    $game_troop         = Marshal.load(file)
    $game_map           = Marshal.load(file)
    $game_player        = Marshal.load(file)
    $game_extras        = Marshal.load(file)
    $game_schizo        = Marshal.load(file)
    $game_lawsystem     = Marshal.load(file)
    $game_itembag       = Marshal.load(file)
    $game_mapeffects    = Game_MapEffects.new
    $game_initializer = Game_Initializer.new
    $game_initializer.load_game_setup
    $game_schizo.reset
    $game_system.microcosm_tag = false
    if $game_system.magic_number != $data_system.magic_number
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    $game_party.refresh
  end
end