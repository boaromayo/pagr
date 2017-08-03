#==============================================================================
# ■ Interpreter (分割定義 1)
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_System クラ
# スや Game_Event クラスの内部で使用されます。
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     depth : ネストの深さ
  #     main  : メインフラグ
  #--------------------------------------------------------------------------
  def initialize(depth = 0, main = false)
    @depth = depth
    @main = main
    @longchoice = 0
    @speaker_name_present = false
    if depth > 100
      print("Common Event call stack limit exceeded")
      exit
    end
    clear
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @map_id = 0                       # 起動時のマップ ID
    @event_id = 0                     # イベント ID
    @message_waiting = false          # メッセージ終了待機中
    @move_route_waiting = false       # 移動完了待機中
    @button_input_variable_id = 0     # ボタン入力 変数 ID
    @wait_count = 0                   # ウェイトカウント
    @child_interpreter = nil          # 子インタプリタ
    @branch = {}                      # 分岐データ
  end
  #--------------------------------------------------------------------------
  # ● イベントのセットアップ
  #     list     : 実行内容
  #     event_id : イベント ID
  #--------------------------------------------------------------------------
  def setup(list, event_id)
    clear
    @map_id = $game_map.map_id
    @event_id = event_id
    @list = list
    @index = 0
    @branch.clear
  end
  #--------------------------------------------------------------------------
  # ● 実行中判定
  #--------------------------------------------------------------------------
  def running?
    return @list != nil
  end
  #--------------------------------------------------------------------------
  # ● 起動中イベントのセットアップ
  #--------------------------------------------------------------------------
  def setup_starting_event
    if $game_map.need_refresh
      $game_map.refresh
    end
    if $game_temp.common_event_id > 0
      setup($data_common_events[$game_temp.common_event_id].list, 0)
      $game_temp.common_event_id = 0
      return
    end
    for event in $game_map.events.values
      if event.starting
        if event.trigger < 3
          event.clear_starting
          event.lock
        end
        setup(event.list, event.id)
        return
      end
    end
    for common_event in $data_common_events.compact
      if common_event.trigger == 1 and
         $game_switches[common_event.switch_id] == true
        setup(common_event.list, 0)
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @loop_count = 0
    loop do
      @loop_count += 1
      if @loop_count > 100
        Graphics.update
        @loop_count = 0
      end
      if $game_map.map_id != @map_id
        @event_id = 0
      end
      if @child_interpreter != nil
        @child_interpreter.update
        unless @child_interpreter.running?
          @child_interpreter = nil
        end
        if @child_interpreter != nil
          return
        end
      end
      if @message_waiting
        if not $game_temp.in_battle
          unless $game_temp.interpreter_continue == 1
            return
          end
        end
      end
      if $game_temp.in_battle
        if $game_temp.num_input_variable_id > 0
          return
        end
      end
      if $game_temp.in_battle
        if $game_temp.battle_choices != []
          return
        end
      end
      if @move_route_waiting
        if $game_player.move_route_forcing
          return
        end
        for event in $game_map.events.values
          if event.move_route_forcing
            return
          end
        end
        @move_route_waiting = false
      end
      if @button_input_variable_id > 0
        input_button
        return
      end
      if @wait_count > 0
        @wait_count -= 1
        return
      end
      if $game_temp.battle_calling or
         $game_temp.shop_calling or
         $game_temp.password_calling or
         $game_temp.menu_calling or
         $game_temp.save_calling or
         $game_temp.gameover
        return
      end
      if @list == nil
        if @main
          setup_starting_event
        end
        if @list == nil
          return
        end
      end
      if execute_command == false
        return
      end
      @index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● ボタン入力
  #--------------------------------------------------------------------------
  def input_button
    n = 0
    for i in 1..18
      if Input.trigger?(i)
        n = i
      end
    end
    if n > 0
      $game_variables[@button_input_variable_id] = n
      $game_map.need_refresh = true
      @button_input_variable_id = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択肢のセットアップ
  #--------------------------------------------------------------------------
  def setup_choices(parameters)
    $game_temp.choice_max = parameters[0].size
    if $game_temp.in_battle
      for i in 0..parameters[0].size - 1
        $game_temp.battle_choices[i] = parameters[0][i]
      end
    else
      for text in parameters[0]
        $game_temp.message_text += text + "\n"
      end
    end
    $game_temp.choice_cancel_type = parameters[1]
    current_indent = @list[@index].indent
    $game_temp.choice_proc = Proc.new { |n| @branch[current_indent] = n }
  end
  #--------------------------------------------------------------------------
  # ● アクター用イテレータ (パーティ全体を考慮)
  #     parameter : 1 以上なら ID、0 なら全体
  #--------------------------------------------------------------------------
  def iterate_actor(parameter)
    if parameter == 0
      for actor in $game_party.actors
        yield actor
      end
    else
      actor = $game_actors[parameter]
      yield actor if actor != nil
    end
  end
  #--------------------------------------------------------------------------
  # ● エネミー用イテレータ (トループ全体を考慮)
  #     parameter : 0 以上ならインデックス、-1 なら全体
  #--------------------------------------------------------------------------
  def iterate_enemy(parameter)
    if parameter == -1
      for enemy in $game_troop.enemies
        yield enemy
      end
    else
      enemy = $game_troop.enemies[parameter]
      yield enemy if enemy != nil
    end
  end
  #--------------------------------------------------------------------------
  # ● バトラー用イテレータ (トループ全体、パーティ全体を考慮)
  #     parameter1 : 0 ならエネミー、1 ならアクター
  #     parameter2 : 0 以上ならインデックス、-1 なら全体
  #--------------------------------------------------------------------------
  def iterate_battler(parameter1, parameter2)
    if parameter1 == 0
      iterate_enemy(parameter2) do |enemy|
        yield enemy
      end
    else
      if parameter2 == -1
        for actor in $game_party.actors
          yield actor
        end
      else
        actor = $game_party.actors[parameter2]
        yield actor if actor != nil
      end
    end
  end
end
