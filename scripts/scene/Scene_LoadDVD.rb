class Scene_LoadDVD < Scene_File
  #-------------------------------
  def initialize(troop_id)
    @troop_id = troop_id
    $game_temp = Game_Temp.new
    $game_temp.last_file_index = 0
    latest_time = Time.at(0)
    for i in 0..3
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
    super("Use which party to fight this battle?")
  end
  #-------------------------------
  def on_decision(filename)
    unless FileTest.exist?(filename)
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    file = File.open(filename, "rb")
    read_save_data(file)
    file.close
    set_battle_background
    set_battle_bgm
    $game_temp.battle_dvd_mode = true
    $game_temp.battle_can_escape = false
    $game_temp.battle_can_lose = false
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0)
    $game_screen.weather(0, 0, 0)
    $game_system.battle_difficulty = 0
    $game_system.se_play($data_system.battle_start_se)
    $scene = Scene_Battle.new
  end
  #-------------------------------
  def on_cancel
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Microcosm.new
  end
  #-------------------------------
  def read_save_data(file)
    characters = Marshal.load(file)
    blah                = Marshal.load(file)
    $game_system        = Marshal.load(file)
    $game_switches      = Marshal.load(file)
    $game_variables     = Marshal.load(file)
    blah                = Marshal.load(file)
    $game_screen        = Marshal.load(file)
    $game_actors        = Marshal.load(file)
    $game_party         = Marshal.load(file)
    blah                = Marshal.load(file)
    $game_map           = Marshal.load(file)
    $game_player        = Marshal.load(file)
    $game_extras        = Marshal.load(file)
    $game_schizo        = Marshal.load(file)
    $game_lawsystem     = Marshal.load(file)
    blah                = Marshal.load(file)
    $game_mapeffects    = Game_MapEffects.new
    $game_initializer = Game_Initializer.new
    $game_initializer.load_game_setup
    $game_schizo.reset
    Graphics.frame_count = 0
    $game_map.setup(1)
    $game_troop = Game_Troop.new
    $game_temp.battle_troop_id = @troop_id
    $game_system.microcosm_tag = true
    if $game_system.magic_number != $data_system.magic_number
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    $game_party.refresh
  end
  #-------------------------------
  def set_battle_background
    case @troop_id
    when 14
      $game_map.battleback_name = ""
      $game_temp.battleback_name = "cave03"
    end
  end
  #-------------------------------
  def set_battle_bgm
    case @troop_id
    when 14
      Audio.bgm_play("Audio/BGM/fight4.mid", 100, 100)
    end
  end
end
