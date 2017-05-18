#==============================================================================
# ■ Game_Character (分割定義 2)
#------------------------------------------------------------------------------
# 　キャラクターを扱うクラスです。このクラスは Game_Player クラスと Game_Event
# クラスのスーパークラスとして使用されます。
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if jumping?
      update_jump
    elsif moving?
      update_move
    else
      update_stop
    end
    if @anime_count > 18 - @move_speed * 2
      if not @step_anime and @stop_count > 0
        @pattern = @original_pattern
      else
        @pattern = (@pattern + 1) % 4
      end
      @anime_count = 0
    end
    if @wait_count > 0
      @wait_count -= 1
      return
    end
    if @move_route_forcing
      move_type_custom
      return
    end
    if @starting or lock?
      return
    end
    if @stop_count > (40 - @move_frequency * 2) * (6 - @move_frequency)
      case @move_type
      when 1
        move_type_random
      when 2
        move_type_toward_player
      when 3
        move_type_custom
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ジャンプ)
  #--------------------------------------------------------------------------
  def update_jump
    @jump_count -= 1
    @real_x = (@real_x * @jump_count + @x * 128) / (@jump_count + 1)
    @real_y = (@real_y * @jump_count + @y * 128) / (@jump_count + 1)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (移動)
  #--------------------------------------------------------------------------
  def update_move
    distance = 2 ** @move_speed
    case @move_speed
    when 1
      distance = 4
    when 2
      distance = 8
    when 3
      distance = 16
    when 4
      distance = 24
    when 5
      distance = 32
    when 6
      distance = 48
    end
    if @y * 128 > @real_y
      @real_y = [@real_y + distance, @y * 128].min
    end
    if @x * 128 < @real_x
      @real_x = [@real_x - distance, @x * 128].max
    end
    if @x * 128 > @real_x
      @real_x = [@real_x + distance, @x * 128].min
    end
    if @y * 128 < @real_y
      @real_y = [@real_y - distance, @y * 128].max
    end
    if @walk_anime
      @anime_count += 1.5
    elsif @step_anime
      @anime_count += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (停止)
  #--------------------------------------------------------------------------
  def update_stop
    if @step_anime
      @anime_count += 1
    elsif @pattern != @original_pattern
      @anime_count += 1.5
    end
    unless @starting or lock?
      @stop_count += 1
    end
     if @character_name == "jump01"
      @stop_count += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動タイプ : ランダム
  #--------------------------------------------------------------------------
  def move_type_random
    # 乱数 0～5 で分岐
    case rand(6)
    when 0..3  # ランダム
      move_random
    when 4  # 一歩前進
      move_forward
    when 5  # 一時停止
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動タイプ : 近づく
  #--------------------------------------------------------------------------
  def move_type_toward_player
    # プレイヤーの座標との差を求める
    sx = @x - $game_player.x
    sy = @y - $game_player.y
    # 差の絶対値を求める
    abs_sx = sx > 0 ? sx : -sx
    abs_sy = sy > 0 ? sy : -sy
    # 縦横あわせて 20 タイル以上離れている場合
    if sx + sy >= 20
      # ランダム
      move_random
      return
    end
    # 乱数 0～5 で分岐
    case rand(6)
    when 0..3  # プレイヤーに近づく
      move_toward_player
    when 4  # ランダム
      move_random
    when 5  # 一歩前進
      move_forward
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動タイプ : カスタム
  #--------------------------------------------------------------------------
  def move_type_custom
    # 停止中でなければ中断
    if jumping? or moving?
      return
    end
    # 移動コマンドのリストの最後に到達するまでループ
    while @move_route_index < @move_route.list.size
      # 移動コマンドを取得
      command = @move_route.list[@move_route_index]
      # コマンドコード 0 番 (リストの最後) の場合
      if command.code == 0
        # オプション [動作を繰り返す] が ON の場合
        if @move_route.repeat
          # 移動ルートのインデックスを最初に戻す
          @move_route_index = 0
        end
        # オプション [動作を繰り返す] が OFF の場合
        unless @move_route.repeat
          # 移動ルート強制中の場合
          if @move_route_forcing and not @move_route.repeat
            # 移動ルートの強制を解除
            @move_route_forcing = false
            # オリジナルの移動ルートを復帰
            @move_route = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          # 停止カウントをクリア
          @stop_count = 0
        end
        return
      end
      # 移動系コマンド (下に移動～ジャンプ) の場合
      if command.code <= 14
        # コマンドコードで分岐
        case command.code
        when 1  # 下に移動
          move_down
        when 2  # 左に移動
          move_left
        when 3  # 右に移動
          move_right
        when 4  # 上に移動
          move_up
        when 5  # 左下に移動
          move_lower_left
        when 6  # 右下に移動
          move_lower_right
        when 7  # 左上に移動
          move_upper_left
        when 8  # 右上に移動
          move_upper_right
        when 9  # ランダムに移動
          move_random
        when 10  # プレイヤーに近づく
          move_toward_player
        when 11  # プレイヤーから遠ざかる
          move_away_from_player
        when 12  # 一歩前進
          move_forward
        when 13  # 一歩後退
          move_backward
        when 14  # ジャンプ
          jump(command.parameters[0], command.parameters[1])
        end
        # オプション [移動できない場合は無視] が OFF で、移動失敗の場合
        if not @move_route.skippable and not moving? and not jumping?
          return
        end
        @move_route_index += 1
        return
      end
      # ウェイトの場合
      if command.code == 15
        # ウェイトカウントを設定
        @wait_count = command.parameters[0] * 2 - 1
        @move_route_index += 1
        return
      end
      # 向き変更系のコマンドの場合
      if command.code >= 16 and command.code <= 26
        # コマンドコードで分岐
        case command.code
        when 16  # 下を向く
          turn_down
        when 17  # 左を向く
          turn_left
        when 18  # 右を向く
          turn_right
        when 19  # 上を向く
          turn_up
        when 20  # 右に 90 度回転
          turn_right_90
        when 21  # 左に 90 度回転
          turn_left_90
        when 22  # 180 度回転
          turn_180
        when 23  # 右か左に 90 度回転
          turn_right_or_left_90
        when 24  # ランダムに方向転換
          turn_random
        when 25  # プレイヤーの方を向く
          turn_toward_player
        when 26  # プレイヤーの逆を向く
          turn_away_from_player
        end
        @move_route_index += 1
        return
      end
      # その他のコマンドの場合
      if command.code >= 27
        # コマンドコードで分岐
        case command.code
        when 27  # スイッチ ON
          $game_switches[command.parameters[0]] = true
          $game_map.need_refresh = true
        when 28  # スイッチ OFF
          $game_switches[command.parameters[0]] = false
          $game_map.need_refresh = true
        when 29  # 移動速度の変更
          @move_speed = command.parameters[0]
        when 30  # 移動頻度の変更
          @move_frequency = command.parameters[0]
        when 31  # 移動時アニメ ON
          @walk_anime = true
        when 32  # 移動時アニメ OFF
          @walk_anime = false
        when 33  # 停止時アニメ ON
          @step_anime = true
        when 34  # 停止時アニメ OFF
          @step_anime = false
        when 35  # 向き固定 ON
          @direction_fix = true
        when 36  # 向き固定 OFF
          @direction_fix = false
        when 37  # すり抜け ON
          @through = true
        when 38  # すり抜け OFF
          @through = false
        when 39  # 最前面に表示 ON
          @always_on_top = true
        when 40  # 最前面に表示 OFF
          @always_on_top = false
        when 41  # グラフィック変更
          @tile_id = 0
          @character_name = command.parameters[0]
          @character_hue = command.parameters[1]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
        when 42  # 不透明度の変更
          @opacity = command.parameters[0]
        when 43  # 合成方法の変更
          @blend_type = command.parameters[0]
        when 44  # SE の演奏
          $game_system.se_play(command.parameters[0])
        when 45  # スクリプト
          result = eval(command.parameters[0])
        end
        @move_route_index += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  def increase_steps
    @stop_count = 0
  end
end
