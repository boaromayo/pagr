#==============================================================================
# ■ Game_Character (分割定義 1)
#------------------------------------------------------------------------------
# 　キャラクターを扱うクラスです。このクラスは Game_Player クラスと Game_Event
# クラスのスーパークラスとして使用されます。
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :id                       # ID
  attr_reader   :x                        # マップ X 座標 (論理座標)
  attr_reader   :y                        # マップ Y 座標 (論理座標)
  attr_reader   :real_x                   # マップ X 座標 (実座標 * 128)
  attr_reader   :real_y                   # マップ Y 座標 (実座標 * 128)
  attr_reader   :tile_id                  # タイル ID  (0 なら無効)
  attr_reader   :character_name           # キャラクター ファイル名
  attr_reader   :character_hue            # キャラクター 色相
  attr_reader   :opacity                  # 不透明度
  attr_reader   :blend_type               # 合成方法
  attr_reader   :direction                # 向き
  attr_reader   :pattern                  # パターン
  attr_reader   :move_route_forcing       # 移動ルート強制フラグ
  attr_reader   :through                  # すり抜け
  attr_accessor :animation_id             # アニメーション ID
  attr_accessor :transparent              # 透明状態
  attr_accessor :move_speed
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @id = 0
    @x = 0
    @y = 0
    @real_x = 0
    @real_y = 0
    @tile_id = 0
    @character_name = ""
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
    @direction = 2
    @pattern = 0
    @move_route_forcing = false
    @through = false
    @animation_id = 0
    @transparent = false
    @original_direction = 2
    @original_pattern = 0
    @move_type = 0
    @move_speed = 4
    @move_frequency = 6
    @move_route = nil
    @move_route_index = 0
    @original_move_route = nil
    @original_move_route_index = 0
    @walk_anime = true
    @step_anime = false
    @direction_fix = false
    @always_on_top = false
    @anime_count = 0
    @stop_count = 0
    @jump_count = 0
    @jump_peak = 0
    @wait_count = 0
    @locked = false
    @prelock_direction = 0
  end
  #--------------------------------------------------------------------------
  # ● 移動中判定
  #--------------------------------------------------------------------------
  def moving?
    return (@real_x != @x * 128 or @real_y != @y * 128)
  end
  #--------------------------------------------------------------------------
  # ● ジャンプ中判定
  #--------------------------------------------------------------------------
  def jumping?
    return @jump_count > 0
  end
  #--------------------------------------------------------------------------
  # ● 姿勢の矯正
  #--------------------------------------------------------------------------
  def straighten
    if @walk_anime or @step_anime
      @pattern = 0
    end
    @anime_count = 0
    @prelock_direction = 0
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの強制
  #     move_route : 新しい移動ルート
  #--------------------------------------------------------------------------
  def force_move_route(move_route)
    if @original_move_route == nil
      @original_move_route = @move_route
      @original_move_route_index = @move_route_index
    end
    @move_route = move_route
    @move_route_index = 0
    @move_route_forcing = true
    @prelock_direction = 0
    @wait_count = 0
    move_type_custom
  end
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
    if @through
      return true
    end
    unless $game_map.passable?(x, y, d, self)
      return false
    end
    unless $game_map.passable?(new_x, new_y, 10 - d)
      return false
    end
    for event in $game_map.events.values
      if event.x == new_x and event.y == new_y
        unless event.through
          if self != $game_player
            return false
          end
          if event.character_name != ""
            return false
          end
        end
      end
    end
    if $game_player.x == new_x and $game_player.y == new_y
      unless $game_player.through
        if @character_name != ""
          return false
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● ロック
  #--------------------------------------------------------------------------
  def lock
    if @locked
      return
    end
    @prelock_direction = @direction
    turn_toward_player
    @locked = true
  end
  #--------------------------------------------------------------------------
  # ● ロック中判定
  #--------------------------------------------------------------------------
  def lock?
    return @locked
  end
  #--------------------------------------------------------------------------
  # ● ロック解除
  #--------------------------------------------------------------------------
  def unlock
    unless @locked
      return
    end
    @locked = false
    unless @direction_fix
      if @prelock_direction != 0
        @direction = @prelock_direction
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 指定位置に移動
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def moveto(x, y)
    @x = x % $game_map.width
    @y = y % $game_map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
  end
  #--------------------------------------------------------------------------
  # ● 画面 X 座標の取得
  #--------------------------------------------------------------------------
  def screen_x
    return (@real_x - $game_map.display_x + 3) / 4 + 16
  end
  #--------------------------------------------------------------------------
  # ● 画面 Y 座標の取得
  #--------------------------------------------------------------------------
  def screen_y
    y = (@real_y - $game_map.display_y + 3) / 4 + 32
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    return y - (@jump_peak * @jump_peak - n * n) / 2
  end
  #--------------------------------------------------------------------------
  # ● 画面 Z 座標の取得
  #     height : キャラクターの高さ
  #--------------------------------------------------------------------------
  def screen_z(height = 0)
    if @always_on_top
      return 999
    end
    z = (@real_y - $game_map.display_y + 3) / 4 + 32
    if @tile_id > 0
      return z + $game_map.priorities[@tile_id] * 32
    else
      return z + ((height > 32) ? 31 : 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● 茂み深さの取得
  #--------------------------------------------------------------------------
  def bush_depth
    if @tile_id > 0 or @always_on_top
      return 0
    end
    if @jump_count == 0 and $game_map.bush?(@x, @y)
      return $game_system.bush_height
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 地形タグの取得
  #--------------------------------------------------------------------------
  def terrain_tag
    return $game_map.terrain_tag(@x, @y)
  end
end
