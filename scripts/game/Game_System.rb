#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# 　システム周りのデータを扱うクラスです。BGM などの管理も行います。このクラス
# のインスタンスは $game_system で参照されます。
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :map_interpreter
  attr_reader   :battle_interpreter
  attr_accessor :timer
  attr_accessor :timer_working
  attr_accessor :save_disabled
  attr_accessor :menu_disabled
  attr_accessor :encounter_disabled
  attr_accessor :message_position
  attr_accessor :message_frame
  attr_accessor :save_count
  attr_accessor :magic_number
  attr_accessor :difficulty
  attr_accessor :map_message_type
  attr_accessor :battle_message_speed
  attr_accessor :battle_frame_update
  attr_accessor :cursor_memory
  attr_accessor :cursor_memory_position
  attr_accessor :author_comments
  attr_accessor :window_style
  attr_accessor :victory_bgm
  attr_accessor :current_location
  attr_accessor :current_ap_weapon
  attr_accessor :current_ap_armor
  attr_accessor :item_remain
  attr_accessor :shaping_remain
  attr_accessor :ability_remain
  attr_accessor :omni_remain
  attr_accessor :map_bgm_in_battle
  attr_accessor :unlimited_menu_access
  attr_accessor :battle_difficulty
  attr_accessor :tutorials
  attr_accessor :new_tutorials
  attr_accessor :microcosm_tag
  attr_accessor :autoscroll_x_speed
  attr_accessor :autoscroll_y_speed
  attr_accessor :steal_se
  attr_accessor :bush_height
  attr_accessor :suppress_battle_start_se
  attr_accessor :panorama_fix
  attr_accessor :fatal
  attr_accessor :defeated_enemies
  attr_accessor :summon_monster_id
  attr_accessor :discount
  attr_accessor :scan_percentages
  attr_accessor :timer_halted
  attr_reader   :version
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @version = 3
    @map_interpreter = Interpreter.new(0, true)
    @battle_interpreter = Interpreter.new(0, false)
    @timer = 0
    @timer_working = false
    @save_disabled = false
    @menu_disabled = false
    @encounter_disabled = false
    @map_bgm_in_battle = false
    @microcosm_tag = false
    @suppress_battle_start_se = false
    @panorama_fix = false
    @discount = false
    @timer_halted = false
    @unlimited_menu_access = 0
    @message_position = 2
    @message_frame = 0
    @save_count = 0
    @magic_number = 0
    @victory_bgm = "Audio/BGM/victory.mid"
    @steal_se = "Audio/SE/steal.wav"
    @current_location = ""
    @current_ap_weapon = []
    @current_ap_armor = []
    @difficulty = 0
    @map_message_type = 0
    @battle_message_speed = 200
    @battle_frame_update = 2
    @cursor_memory = 0
    @cursor_memory_position = -1
    @author_comments = 0
    @window_style = 1
    @item_remain = 0
    @shaping_remain = 0
    @ability_remain = 0
    @omni_remain = 0
    @battle_difficulty_level = 0
    @autoscroll_x_speed = 0
    @autoscroll_y_speed = 0
    @bush_height = 24
    @tutorials = []
    @new_tutorials = []
    @fatal = []
    @defeated_enemies = []
    @scan_percentages = []
    for i in 0..$data_weapons.size - 1
      @current_ap_weapon[i] = 0
    end
    for i in 0..$data_armors.size - 1
      @current_ap_armor[i] = 0
    end
    for i in 0..$data_enemies.size - 1
      @scan_percentages[i] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● BGM の演奏
  #     bgm : 演奏する BGM
  #--------------------------------------------------------------------------
  def bgm_play(bgm)
    @playing_bgm = bgm
    if bgm != nil and bgm.name != ""
      Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch)
    else
      Audio.bgm_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● BGM の停止
  #--------------------------------------------------------------------------
  def bgm_stop
    Audio.bgm_stop
  end
  #--------------------------------------------------------------------------
  # ● BGM のフェードアウト
  #     time : フェードアウト時間 (秒)
  #--------------------------------------------------------------------------
  def bgm_fade(time)
    @playing_bgm = nil
    Audio.bgm_fade(time * 1000)
  end
  #--------------------------------------------------------------------------
  # ● BGM の記憶
  #--------------------------------------------------------------------------
  def bgm_memorize
    @memorized_bgm = @playing_bgm
  end
  #--------------------------------------------------------------------------
  # ● BGM の復帰
  #--------------------------------------------------------------------------
  def bgm_restore
    bgm_play(@memorized_bgm)
  end
  #--------------------------------------------------------------------------
  # ● BGS の演奏
  #     bgs : 演奏する BGS
  #--------------------------------------------------------------------------
  def bgs_play(bgs)
    @playing_bgs = bgs
    if bgs != nil and bgs.name != ""
      Audio.bgs_play("Audio/BGS/" + bgs.name, bgs.volume, bgs.pitch)
    else
      Audio.bgs_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● BGS のフェードアウト
  #     time : フェードアウト時間 (秒)
  #--------------------------------------------------------------------------
  def bgs_fade(time)
    @playing_bgs = nil
    Audio.bgs_fade(time * 1000)
  end
  #--------------------------------------------------------------------------
  # ● BGS の記憶
  #--------------------------------------------------------------------------
  def bgs_memorize
    @memorized_bgs = @playing_bgs
  end
  #--------------------------------------------------------------------------
  # ● BGS の復帰
  #--------------------------------------------------------------------------
  def bgs_restore
    bgs_play(@memorized_bgs)
  end
  #--------------------------------------------------------------------------
  # ● ME の演奏
  #     me : 演奏する ME
  #--------------------------------------------------------------------------
  def me_play(me)
    if me != nil and me.name != ""
      Audio.me_play("Audio/ME/" + me.name, me.volume, me.pitch)
    else
      Audio.me_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● SE の演奏
  #     se : 演奏する SE
  #--------------------------------------------------------------------------
  def se_play(se)
    if se != nil and se.name != ""
      Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
    end
  end
  #--------------------------------------------------------------------------
  # ● SE の停止
  #--------------------------------------------------------------------------
  def se_stop
    Audio.se_stop
  end
  #--------------------------------------------------------------------------
  # ● 演奏中 BGM の取得
  #--------------------------------------------------------------------------
  def playing_bgm
    return @playing_bgm
  end
  #--------------------------------------------------------------------------
  # ● 演奏中 BGS の取得
  #--------------------------------------------------------------------------
  def playing_bgs
    return @playing_bgs
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウスキン ファイル名の取得
  #--------------------------------------------------------------------------
  def windowskin_name
    if @windowskin_name == nil
      return $data_system.windowskin_name
    else
      return @windowskin_name
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウスキン ファイル名の設定
  #     windowskin_name : 新しいウィンドウスキン ファイル名
  #--------------------------------------------------------------------------
  def windowskin_name=(windowskin_name)
    @windowskin_name = windowskin_name
  end
  #--------------------------------------------------------------------------
  # ● バトル BGM の取得
  #--------------------------------------------------------------------------
  def battle_bgm
    if @battle_bgm == nil
      return $data_system.battle_bgm
    else
      return @battle_bgm
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル BGM の設定
  #     battle_bgm : 新しいバトル BGM
  #--------------------------------------------------------------------------
  def battle_bgm=(battle_bgm)
    @battle_bgm = battle_bgm
  end
  #--------------------------------------------------------------------------
  # ● バトル終了 BGM の取得
  #--------------------------------------------------------------------------
  def battle_end_me
    if @battle_end_me == nil
      return $data_system.battle_end_me
    else
      return @battle_end_me
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル終了 BGM の設定
  #     battle_end_me : 新しいバトル終了 BGM
  #--------------------------------------------------------------------------
  def battle_end_me=(battle_end_me)
    @battle_end_me = battle_end_me
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if @timer_working and @timer > 0
      unless @timer_halted
        @timer -= 1
      end
    end
  end
  # ----------------------------
  def menu_encounters
    if $game_map.encounter_step == 0
      return
    end
    dice = rand($game_map.encounter_step * 5)
    if dice == 0
      if $game_system.difficulty > 0
        if $game_map.encounter_list != [] || $game_map.enum_encounter_list != []
          unless $game_system.map_interpreter.running? or 
            $game_system.encounter_disabled
            if $game_map.encounter_list != []
              n = rand($game_map.encounter_list.size)
              troop_id = $game_map.encounter_list[n]
            else
              n = rand($game_map.enum_encounter_list.size)
              troop_id = $game_map.enum_encounter_list[n]
            end
            if $data_troops[troop_id] != nil
              $game_temp.battle_troop_id = troop_id
              $game_temp.battle_can_escape = true
              $game_temp.battle_can_lose = false
              $game_temp.battle_proc = nil
              $game_temp.menu_calling = false
              $game_temp.menu_beep = false
              $game_player.make_encounter_count
              $game_temp.map_bgm = $game_system.playing_bgm
              $game_system.bgm_stop
              $game_system.se_play($data_system.battle_start_se)
              $game_system.bgm_play($game_system.battle_bgm)
              $game_player.straighten
              $scene = Scene_Battle.new
            end
          end
        end
      end
    end
  end
  # ----------------------------
  def frand(value)
    negative = false
    remain = value
    if value < 0.0
      negative = true
      remain = value * -1
    end
    total = 0
    while remain >= 1.0
      total += rand(0)
      remain -= 1
    end
    if remain > 0.0
      total += rand(0) * remain
    end
    if negative
      total *= -1
    end
    return total
  end
  # ----------------------------
end
