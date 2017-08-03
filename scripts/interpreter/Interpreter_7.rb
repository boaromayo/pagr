#==============================================================================
# ■ Interpreter (分割定義 7)
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_System クラ
# スや Game_Event クラスの内部で使用されます。
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # ● エネミーの HP 増減
  #--------------------------------------------------------------------------
  def command_331
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_enemy(@parameters[0]) do |enemy|
      if enemy.hp > 0
        if @parameters[4] == false and enemy.hp + value <= 0
          enemy.hp = 1
        else
          enemy.hp += value
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● エネミーの SP 増減
  #--------------------------------------------------------------------------
  def command_332
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_enemy(@parameters[0]) do |enemy|
      enemy.fatigue += value
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● エネミーのステート変更
  #--------------------------------------------------------------------------
  def command_333
    iterate_enemy(@parameters[0]) do |enemy|
      if $data_states[@parameters[2]].zero_hp
        enemy.immortal = false
      end
      if @parameters[1] == 0
        enemy.add_state(@parameters[2])
      else
        enemy.remove_state(@parameters[2])
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● エネミーの全回復
  #--------------------------------------------------------------------------
  def command_334
    iterate_enemy(@parameters[0]) do |enemy|
      enemy.recover_all
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● エネミーの出現
  #--------------------------------------------------------------------------
  def command_335
    enemy = $game_troop.enemies[@parameters[0]]
    if enemy != nil
      enemy.hidden = false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● エネミーの変身
  #--------------------------------------------------------------------------
  def command_336
    enemy = $game_troop.enemies[@parameters[0]]
    if enemy != nil
      enemy.transform(@parameters[1])
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの表示
  #--------------------------------------------------------------------------
  def command_337
    iterate_battler(@parameters[0], @parameters[1]) do |battler|
      if battler.exist?
        battler.animation_id = @parameters[2]
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● ダメージの処理
  #--------------------------------------------------------------------------
  def command_338
    value = operate_value(0, @parameters[2], @parameters[3])
    iterate_battler(@parameters[0], @parameters[1]) do |battler|
      if battler.exist?
        battler.hp -= value
        if $game_temp.in_battle
          battler.damage = value
          battler.damage_pop = true
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクションの強制
  #--------------------------------------------------------------------------
  def command_339
    unless $game_temp.in_battle
      return true
    end
    s = -1
    @index += 1
    iterate_battler(@parameters[0], @parameters[1]) do |battler|
      if battler.exist?
        battler.current_action.clear
        if @parameters[2] == 0
          case @parameters[3]
          when 0
            t = 1
          when 1
            p = 1
            battler.current_action.passive = 1
          when 2
            t = 4
          when 3
            battler.current_action.clear
          end
        end
        if @parameters[2] == 1
           t = 2
           s = @parameters[3]
        end
        x = @parameters[4]
        if @parameters[5] == 0
          n = false
        else
          n = true
        end
        battler.forced_actions.push(Game_ForcedAction.new(t, x, n, s, -1))
        $game_temp.forcing_battler.push(battler)
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● バトルの中断
  #--------------------------------------------------------------------------
  def command_340
    $game_temp.battle_abort = true
    @index += 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面の呼び出し
  #--------------------------------------------------------------------------
  def command_351
    $game_temp.battle_abort = true
    $game_temp.menu_calling = true
    @index += 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● セーブ画面の呼び出し
  #--------------------------------------------------------------------------
  def command_352
    $game_temp.battle_abort = true
    $game_temp.save_calling = true
    @index += 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバー
  #--------------------------------------------------------------------------
  def command_353
    $game_temp.gameover = true
    return false
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面に戻す
  #--------------------------------------------------------------------------
  def command_354
    $game_temp.to_title = true
    return false
  end
  #--------------------------------------------------------------------------
  # ● スクリプト
  #--------------------------------------------------------------------------
  def command_355
    script = @list[@index].parameters[0] + "\n"
    loop do
      if @list[@index+1].code == 655
        script += @list[@index+1].parameters[0] + "\n"
      else
        break
      end
      @index += 1
    end
    result = eval(script)
    if result == false
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● Wait for Battle Message Text to Complete
  #--------------------------------------------------------------------------
  def command_701
    if $game_temp.in_battle
      if $game_temp.battle_message_text != []
        return false
      end
    else
      return true
    end
  end
end
