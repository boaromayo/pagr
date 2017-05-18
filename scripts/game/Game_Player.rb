#==============================================================================
# ■ Game_Player
#------------------------------------------------------------------------------
# 　プレイヤーを扱うクラスです。イベントの起動判定や、マップのスクロールなどの
# 機能を持っています。このクラスのインスタンスは $game_player で参照されます。
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  CENTER_X = (320 - 16) * 4
  CENTER_Y = (240 - 16) * 4
  #--------------------------------------------------------------------------
  # ● 通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #     d : 方向 (0,2,4,6,8)  ※ 0 = 全方向通行不可の場合を判定 (ジャンプ用)
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    unless $game_map.valid?(new_x, new_y)
      return false
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 画面中央に来るようにマップの表示位置を設定
  #--------------------------------------------------------------------------
  def center(x, y)
    max_x = ($game_map.width - 20) * 128
    max_y = ($game_map.height - 15) * 128
    $game_map.display_x = [0, [x * 128 - CENTER_X, max_x].min].max
    $game_map.display_y = [0, [y * 128 - CENTER_Y, max_y].min].max
  end
  #--------------------------------------------------------------------------
  # ● 指定位置に移動
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def moveto(x, y)
    super
    center(x, y)
    make_encounter_count
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  def increase_steps
    super
    $game_lawsystem.advance_time(1)
    unless @move_route_forcing
      $game_party.increase_steps
      map_ft_ex_recovery
      if $game_party.steps % 5 == 0
        $game_party.check_map_slip_damage
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● エンカウント カウント取得
  #--------------------------------------------------------------------------
  def encounter_count
    return @encounter_count
  end
  #--------------------------------------------------------------------------
  # ● エンカウント カウント作成
  #--------------------------------------------------------------------------
  def make_encounter_count
    if $game_map.map_id != 0
      n = $game_map.encounter_step
      min_count = $game_map.encounter_step / 2
      @encounter_count = rand(n) + min_count + 1
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if $game_party.actors.size == 0
      @character_name = ""
      @character_hue = 0
      return
    end
    actor = $game_party.actors[0]
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @opacity = 255
    @blend_type = 0
  end
  #--------------------------------------------------------------------------
  # ● 同位置のイベント起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    result = false
    if $game_system.map_interpreter.running?
      return result
    end
    for event in $game_map.events.values
      if event.x == @x and event.y == @y and triggers.include?(event.trigger)
        if not event.jumping? and event.over_trigger?
          event.start
          result = true
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 正面のイベント起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    if $game_system.map_interpreter.running?
      return result
    end
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    for event in $game_map.events.values
      if event.x == new_x and event.y == new_y and
         triggers.include?(event.trigger)
        if not event.jumping? and not event.over_trigger?
          event.start
          result = true
        end
      end
    end
    if result == false
      if $game_map.counter?(new_x, new_y)
        new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
        new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
        for event in $game_map.events.values
          if event.x == new_x and event.y == new_y and
             triggers.include?(event.trigger)
            if not event.jumping? and not event.over_trigger?
              event.start
              result = true
            end
          end
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 接触イベントの起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    result = false
    if $game_system.map_interpreter.running?
      return result
    end
    for event in $game_map.events.values
      if event.x == x and event.y == y and [1,2].include?(event.trigger)
        if not event.jumping? and not event.over_trigger?
          event.start
          result = true
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    last_moving = moving?
    unless moving? or $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing
      case Input.dir4
      when 2
        move_down
      when 4
        move_left
      when 6
        move_right
      when 8
        move_up
      end
    end
    last_real_x = @real_x
    last_real_y = @real_y
    super
    if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
      $game_map.scroll_down(@real_y - last_real_y)
    end
    if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
      $game_map.scroll_left(last_real_x - @real_x)
    end
    if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
      $game_map.scroll_right(@real_x - last_real_x)
    end
    if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
      $game_map.scroll_up(last_real_y - @real_y)
    end
    unless moving?
      if last_moving
        result = check_event_trigger_here([1,2])
        if result == false
          if @encounter_count > 0
            @encounter_count -= 1
          end
        end
      end
      if Input.trigger?(Input::C)
        check_event_trigger_here([0])
        check_event_trigger_there([0,1,2])
      end
    end
  end
# ------------------------
def map_ft_ex_recovery
  restore = 0
  if $game_party.actors.size == 0
    return
  end
  for i in 0..$game_party.actors.size - 1
    actor = $game_party.actors[i]
    if actor.dead?
      next
    end
    if actor.fatigue >= 75 && actor.fatigue <= 99
      restore = 0
    end
    if actor.fatigue >= 50 && actor.fatigue <= 74
      restore = 0
    end
    if actor.fatigue >= 25 && actor.fatigue <= 49
      restore = 0
    end
    if actor.fatigue >= 0 && actor.fatigue <= 24
      restore = 0
    end
    if actor.fatigue >= -25 && actor.fatigue <= -1
      restore = 24
    end
    if actor.fatigue >= -50 && actor.fatigue <= -26
      restore = 32
    end
    if actor.fatigue >= -75 && actor.fatigue <= -51
      restore = 40
    end
    if actor.fatigue >= -99 && actor.fatigue <= -76
      restore = 50
    end
    if actor.fatigue <= -100
      restore = 20
    end
    restore = restore.to_f
    restore *= state_fatigue_recovery_modifier(actor)
    restore /= 100.0
    restore *= energy_fatigue_recovery_modifier(actor)
    restore /= 100.0
    restore = restore.round
    actor.fatigue_delay += restore
  end
  while actor.fatigue_delay >= 100
    actor.fatigue_delay -= 100
    actor.fatigue += 1
  end
  while actor.fatigue_delay <= -100
    actor.fatigue_delay += 100
    actor.fatigue -= 1
  end
  for i in 0..$game_party.actors.size - 1
    actor = $game_party.actors[i]
    if actor.dead?
      next
    end
  end
  for i in 0..$game_party.actors.size - 1
    actor = $game_party.actors[i]
    actor.exertion = 0
    if actor.fatigue_delay >= 100
      actor.fatigue_delay -= 100
      actor.fatigue += 1
    end
  end
end
# ------------------------
def state_fatigue_recovery_modifier(actor)
  if actor.states.size == 0
    return 100
  end
  value = 0
  for i in actor.states
    value += $data_states[i].maxsp_rate
  end
  value /= actor.states.size
end
# -----------------------
def energy_fatigue_recovery_modifier(actor)
  if actor.energy < 0
    return 0
  else
    return actor.energy
  end
end
# ------------------------
end
