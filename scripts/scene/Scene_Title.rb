#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    if $BTEST
      battle_test
      return
    end
    $data_actors        = load_data("Data/Actors.rxdata")
    $data_classes       = load_data("Data/Classes.rxdata")
    $data_skills        = load_data("Data/Skills.rxdata")
    $data_items         = load_data("Data/Items.rxdata")
    $data_weapons       = load_data("Data/Weapons.rxdata")
    $data_armors        = load_data("Data/Armors.rxdata")
    $data_enemies       = load_data("Data/Enemies.rxdata")
    $data_troops        = load_data("Data/Troops.rxdata")
    $data_states        = load_data("Data/States.rxdata")
    $data_animations    = load_data("Data/Animations.rxdata")
    $data_tilesets      = load_data("Data/Tilesets.rxdata")
    $data_common_events = load_data("Data/CommonEvents.rxdata")
    $data_system        = load_data("Data/System.rxdata")
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title($data_system.title_name)
    if microcosm_unlocked?
      s1 = "New Game"
      s2 = "Continue"
      s3 = "Microcosm"
      s4 = "End Game"
      @command_window = Window_Command.new(192, [s1, s2, s3, s4])
    else
      s1 = "New Game"
      s2 = "Continue"
      s3 = "End Game"
      @command_window = Window_Command.new(192, [s1, s2, s3])
    end
    @command_window.back_opacity = 160
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 288
    @continue_enabled = false
    for i in 0..98
      if $game_system.fatal.include?(i+1)
        next
      end
      f = "Save#{i+1}.rxdata"
      if FileTest.exist?(f)
        @continue_enabled = true
      end
    end
    if @continue_enabled
      @command_window.index = 1
    else
      @command_window.disable_item(1)
    end
    $game_system.bgm_play($data_system.title_bgm)
    Audio.me_stop
    Audio.bgs_stop
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @command_window.dispose
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @command_window.update
    if Input.trigger?(Input::C)
      case @command_window.index
      when 0
        command_new_game
      when 1
        command_continue
      when 2
        if microcosm_unlocked?
          command_microcosm
        else
          command_shutdown
        end
      when 3
        command_shutdown
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド : ニューゲーム
  #--------------------------------------------------------------------------
  def command_new_game
    $game_system.se_play($data_system.decision_se)
    Audio.bgm_stop
    Graphics.frame_count = 0
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    $game_extras        = Game_Extras.new
    $game_schizo        = Game_Schizo.new
    $game_lawsystem     = Game_LawSystem.new
    $game_itembag       = Game_ItemBag.new
    $game_mapeffects    = Game_MapEffects.new
    $game_initializer   = Game_Initializer.new
    $game_initializer.new_game_setup
    $game_party.setup_starting_members
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    $game_map.autoplay
    $game_map.update
    $game_system.microcosm_tag = false
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● コマンド : コンティニュー
  #--------------------------------------------------------------------------
  def command_continue
    unless @continue_enabled
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    $game_system.se_play($data_system.decision_se)
    $scene = Scene_Load.new
  end
  #--------------------------------------------------------------------------
  # ● コマンド : シャットダウン
  #--------------------------------------------------------------------------
  def command_shutdown
    $game_system.se_play($data_system.decision_se)
    Audio.bgm_fade(800)
    Audio.bgs_fade(800)
    Audio.me_fade(800)
    $scene = nil
  end
  # -----------------------
  def command_microcosm
    $game_system.se_play($data_system.decision_se)
    $scene = Scene_Microcosm.new
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト
  #--------------------------------------------------------------------------
  def battle_test
    $data_actors        = load_data("Data/BT_Actors.rxdata")
    $data_classes       = load_data("Data/BT_Classes.rxdata")
    $data_skills        = load_data("Data/BT_Skills.rxdata")
    $data_items         = load_data("Data/BT_Items.rxdata")
    $data_weapons       = load_data("Data/BT_Weapons.rxdata")
    $data_armors        = load_data("Data/BT_Armors.rxdata")
    $data_enemies       = load_data("Data/BT_Enemies.rxdata")
    $data_troops        = load_data("Data/BT_Troops.rxdata")
    $data_states        = load_data("Data/BT_States.rxdata")
    $data_animations    = load_data("Data/BT_Animations.rxdata")
    $data_tilesets      = load_data("Data/BT_Tilesets.rxdata")
    $data_common_events = load_data("Data/BT_CommonEvents.rxdata")
    $data_system        = load_data("Data/BT_System.rxdata")
    Graphics.frame_count = 0
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    $game_party.setup_battle_test_members
    $game_temp.battle_troop_id = $data_system.test_troop_id
    $game_temp.battle_can_escape = true
    $game_map.battleback_name = $data_system.battleback_name
    $game_system.se_play($data_system.battle_start_se)
    $game_system.bgm_play($game_system.battle_bgm)
    $scene = Scene_Battle.new
  end
  # ---------------------
  def microcosm_unlocked?
    result = false
    del = []
    jade = true
    if FileTest.exist?("g.txt")
      jade = false
    end
    for i in 1..99
      if $game_system.fatal.include?(i)
        next
      end
      name = "Save" + i.to_s + ".rxdata"
      if FileTest.exist?(name)
        f = File.open(name, "rb")
        blah = Marshal.load(f)
        blah= Marshal.load(f)
        sys = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        blah = Marshal.load(f)
        @extras = Marshal.load(f)
        if @extras.extras_unlocked?
          result = true
        end
        print(sys.version.to_s)
        print(jade.to_s)
        if sys.version < 3 and jade
          $game_system.fatal.push(i)
          del.push(i)
        end
      end
    end
    if del.size > 0
      cheepoo = "s in scripting, "
      lino_en_kuldes = "save files from dif"
      kika = "Due to change"
      paula = "ferent versions are n"
      eugene = ""
      gunter = "ot compatible.\nThe old saves w"
      rita = "ere automatically deleted."
      cray_trading_company = kika + cheepoo + eugene + lino_en_kuldes
      obel_kingdom = paula + gunter + rita
      tal = cray_trading_company + obel_kingdom
      print(tal)
      f = File.new("g.txt", "w")
      f.puts("Flags file: 0110110110")
    end
    return result
  end
end
