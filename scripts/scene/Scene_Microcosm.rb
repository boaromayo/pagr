class Scene_Microcosm
# ---------------------------
  def main
    $game_system = Game_System.new
    Audio.bgm_play("Audio/BGM/solace.mid")
    @num_commands = determine_microcosm_commands
    @num_commands.push(5)
    @available_music = []
    @available_battles = []
    @available_minigames = []
    @available_monster_info = []
    @available_backgrounds = []
    determine_available_bonuses
    @minigame_commands = determine_minigame_commands
    if @minigame_commands.size == 0
      @minigame_commands = ["Dummy"]
    end
    @current_background_index = 0
    @can_change_bg = false
    @volume = 100
    @pitch = 100
    @last_monsterinfo_index = -1
    @monsterinfo_index = -1
    @music = "Audio/BGM/solace.mid"
    commands = []
    if @num_commands.include?(1)
      commands.push("Listen to CDs")
    end
    if @num_commands.include?(2)
      commands.push("Play Battle DVDs")
    end
    if @num_commands.include?(3)
      commands.push("Play Minigames")
    end
    if @num_commands.include?(4)
      commands.push("View Monster Information")
    end
    commands.push("Leave Microcosm")
    @bg_vp = Viewport.new(0, 0, 640, 480)
    @info1_vp = Viewport.new(195, 15, 250, 24)
    @info2_vp = Viewport.new(500, 450, 117, 16)
    @bg_sprite = Sprite.new(@bg_vp)
    @info1_sprite = Sprite.new(@info1_vp)
    @info2_sprite = Sprite.new(@info2_vp)
    @info1_sprite.bitmap = Bitmap.new("Graphics/Stuff/micro-01.png")
    if @available_backgrounds.size >= 2
      @info2_sprite.bitmap = Bitmap.new("Graphics/Stuff/micro-02.png")
    else
      @info2_sprite.bitmap = Bitmap.new("Graphics/Stuff/micro-03.png")
    end
    @bg_sprite.bitmap = Bitmap.new("Graphics/Stuff/micro-04.png")
    @main_window = Window_Command.new(256, commands)
    @cd_window = Window_CD.new(@available_music)
    @music_window = Window_Music.new(0, "...")
    @music_info_window = Window_MusicInfo.new
    @battle_window = Window_BattleDVD.new(@available_battles)
    @minigame_window = Window_Command.new(256, @minigame_commands)
    @monsterselect_window = Window_MonsterSelect.new(@available_monster_info)
    @monsterinfo_window = Window_MonsterInfo.new
    @main_window.x = 192
    @main_window.y = (480 - @main_window.height) / 2
    @minigame_window.x = 192
    @minigame_window.y = (480 - @minigame_window.height) / 2
    @main_window.active = true
    @cd_window.active = false
    @music_window.active = false
    @battle_window.active = false
    @minigame_window.active = false
    @monsterselect_window.active = false
    @main_window.visible = true
    @cd_window.visible = false
    @music_window.visible = false
    @music_info_window.visible = false
    @battle_window.visible = false
    @minigame_window.visible = false
    @monsterselect_window.visible = false
    @monsterinfo_window.visible = false
    @bg_vp.z = 2500
    @info1_vp.z = 2510
    @info2_vp.z = 2510
    @main_window.z = 2600
    @cd_window.z = 2600
    @battle_window.z = 2600
    @minigame_window.z = 2600
    @monsterselect_window.z = 2600
    @monsterinfo_window.z = 2600
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
    @bg_sprite.dispose
    @info1_sprite.dispose
    @info2_sprite.dispose
    @main_window.dispose
    @cd_window.dispose
    @music_window.dispose
    @music_info_window.dispose
    @battle_window.dispose
    @minigame_window.dispose
    @monsterselect_window.dispose
    @monsterinfo_window.dispose
  end
# ----------------------------
  def update
    @main_window.update
    @cd_window.update
    @music_window.update
    @music_info_window.update
    @battle_window.update
    @minigame_window.update
    @monsterselect_window.update
    @monsterinfo_window.update
    if @main_window.active
      @can_change_bg = true
      update_main
      return
    end
    if @cd_window.active
      update_cd
      return
    end
    if @music_window.active
      update_music
      return
    end
    if @battle_window.active
      update_battle
      return
    end
    if @minigame_window.active
      update_minigame
      return
    end
    if @monsterselect_window.active
      update_monster
      @monsterinfo_index = @monsterselect_window.index
      if @monsterinfo_index != @last_monsterinfo_index
        value = @available_monster_info[@monsterselect_window.index]
        @monsterinfo_window.refresh(value)
        @last_monsterinfo_index = @monsterselect_window.index
      end
      return
    end
  end
# ----------------------------
def update_main
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Title.new
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    selected_command = @num_commands[@main_window.index]
    case selected_command
    when 1
      @main_window.active = false
      @main_window.visible = false
      @cd_window.active = true
      @cd_window.visible = true
      @can_change_bg = false
    when 2
      @main_window.active = false
      @main_window.visible = false
      @battle_window.active = true
      @battle_window.visible = true
      @can_change_bg = false
    when 3
      @main_window.active = false
      @main_window.visible = false
      @minigame_window.active = true
      @minigame_window.visible = true
      @can_change_bg = false
    when 4
      @main_window.active = false
      @main_window.visible = false
      @monsterselect_window.active = true
      @monsterselect_window.visible = true
      @monsterinfo_window.visible = true
      @can_change_bg = false
    when 5
      $scene = Scene_Title.new
    end
  end
end
# ----------------------------
def update_cd
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @cd_window.active = false
    @cd_window.visible = false
    @main_window.active = true
    @main_window.visible = true
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    @music_info_window.visible = true
    @music_info_window.refresh(@volume, @pitch)
    case @available_music[@cd_window.index]
    when 1
      track1 = "Invidious Aggressors"
      track2 = "Tacit Ackknowledgement of Superiority"
      track3 = "Ensconced in Paranoia's Temple"
      track4 = "Flawless Beatdown"
      @list = [track1, track2, track3, track4]
    when 2
      track1 = "Subterrainean Panopoly"
      track2 = "Vexing Metropolis"
      track3 = "Simple Town, Complex Logistics"
      track4 = "Serenity Suddenly Negated"
      track5 = "Death Isn't Psychosomatic"
      @list = [track1, track2, track3, track4, track5]
    end
    @music_window.dispose
    @music_window = Window_Music.new((116 + @cd_window.index * 32), @list)
    @music_window.index = 0
    @cd_window.active = false
    @music_window.active = true
    @music_window.visible = true
  end
end
# ----------------------------
def update_music
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @music_window.active = false
    @music_window.visible = false
    @music_info_window.visible = false
    @cd_window.active = true
  end
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    case @music_window.track_list[@music_window.index]
    when "Invidious Aggressors"
      @music = "Audio/BGM/fight1.mid"
    when "Tacit Ackknowledgement of Superiority"
      @music = "Audio/BGM/fight2.mid"
    when "Ensconced in Paranoia's Temple"
      @music = "Audio/BGM/fight3.mid"
    when "Flawless Beatdown"
      @music = "Audio/BGM/victory.mid"
    when "Subterrainean Panopoly"
      @music = "Audio/BGM/town1.mid"
    when "Vexing Metropolis"
      @music = "Audio/BGM/town2.mid"
    when "Simple Town, Complex Logistics"
      @music = "Audio/BGM/town3.mid"
    when "Serenity Suddenly Negated"
      @music = "Audio/BGM/crisis.mid"
    when "Death Isn't Psychosomatic"
      @music = "Audio/BGM/standoff.mid"
    end
    Audio.bgm_play(@music, @volume, @pitch)
  end
   if Input.trigger?(Input::LEFT)
    $game_system.se_play($data_system.cursor_se)
    if @volume > 0
      @volume -= 10
      Audio.bgm_play(@music, @volume, @pitch)
      @music_info_window.refresh(@volume, @pitch)
    end
  end
  if Input.trigger?(Input::RIGHT)
    $game_system.se_play($data_system.cursor_se)
    if @volume < 100
      @volume += 10
      Audio.bgm_play(@music, @volume, @pitch)
      @music_info_window.refresh(@volume, @pitch)
    end
  end
  if Input.trigger?(Input::X)
    $game_system.se_play($data_system.cursor_se)
    if @pitch > 50
      @pitch -= 10
      Audio.bgm_play(@music, @volume, @pitch)
      @music_info_window.refresh(@volume, @pitch)
    end
  end
  if Input.trigger?(Input::Y)
    $game_system.se_play($data_system.cursor_se)
    if @pitch < 150
      @pitch += 10
      Audio.bgm_play(@music, @volume, @pitch)
      @music_info_window.refresh(@volume, @pitch)
    end
  end
  if Input.trigger?(Input::Z)
    $game_system.se_play($data_system.decision_se)
    @volume = 100
    @pitch = 100
    Audio.bgm_play(@music, @volume, @pitch)
    @music_info_window.refresh(@volume, @pitch)
  end
end
# ----------------------------
def update_battle
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @battle_window.active = false
    @battle_window.visible = false
    @main_window.active = true
    @main_window.visible = true
  end
   if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    case @available_battles[@battle_window.index]
    when 1
      $scene = Scene_LoadDVD.new(14)
    when 2
      print("2")
    when 3
      print("3")
    end
  end
end
# ----------------------------
def update_minigame
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @minigame_window.active = false
    @minigame_window.visible = false
    @main_window.active = true
    @main_window.visible = true
  end
   if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    case @minigame_commands[@minigame_window.index]
    when "Cliffside Escape"
      start_minigame(1)
    end
  end
end
# ----------------------------
def update_monster
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @monsterselect_window.active = false
    @monsterselect_window.visible = false
    @monsterinfo_window.visible = false
    @main_window.active = true
    @main_window.visible = true
  end
end
# ----------------------------
def determine_microcosm_commands
  available_commands = []
  for i in 1..4
    name = "Save" + i.to_s + ".rxdata"
    if FileTest.exist?(name)
      f = File.open(name, "rb")
      blah = Marshal.load(f)
      blah = Marshal.load(f)
      blah = Marshal.load(f)
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
      types = @extras.types_unlocked
      for i in 0..types.size - 1
        if not available_commands.include?(types[i])
          available_commands.push(types[i])
        end
      end
    end
  end
  temp_commands = []
  if available_commands.include?(1)
    temp_commands.push(1)
  end
  if available_commands.include?(2)
    temp_commands.push(2)
  end
  if available_commands.include?(3)
    temp_commands.push(3)
  end
  if available_commands.include?(4)
    temp_commands.push(4)
  end
  available_commands = temp_commands
  return available_commands
end
# ----------------------------
def determine_available_bonuses
  for i in 1..4
    name = "Save" + i.to_s + ".rxdata"
    if FileTest.exist?(name)
      f = File.open(name, "rb")
      blah = Marshal.load(f)
      blah = Marshal.load(f)
      blah = Marshal.load(f)
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
      for number in @extras.music_cds
        if not @available_music.include?(number)
          @available_music.push(number)
        end
      end
      for number in @extras.battle_dvds
        if not @available_battles.include?(number)
          @available_battles.push(number)
        end
      end
      for number in @extras.minigames
        if not @available_minigames.include?(number)
          @available_minigames.push(number)
        end
      end
      for number in @extras.monster_info
        if not @available_monster_info.include?(number)
          @available_monster_info.push(number)
        end
      end
      for number in @extras.backgrounds
        if not @available_backgrounds.include?(number)
          @available_backgrounds.push(number)
        end
      end
    end
  end
end
# ----------------------------
def determine_minigame_commands
  result = []
  for minigame in @available_minigames
    case minigame
    when 1
      result.push("Cliffside Escape")
    end
  end
  return result
end
# ----------------------------
def start_minigame(number)
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
  $game_schizo        = Game_Schizo.new
  $game_extras        = Game_Extras.new
  $game_itembag       = Game_ItemBag.new
  $game_mapeffects    = Game_MapEffects.new
  $game_initializer   = Game_Initializer.new
  $game_initializer.new_game_setup
  $game_party.add_actor(8)
  case number
  when 1
    $game_map.setup(54)
    $game_player.moveto(31, 9)
  end
  $game_player.refresh
  $game_map.autoplay
  $game_map.update
  $scene = Scene_Map.new
end
# ----------------------------
end