#==============================================================================
# ■ Interpreter (分割定義 6)
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_System クラ
# スや Game_Event クラスの内部で使用されます。
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # ● バトルの処理
  #--------------------------------------------------------------------------
  def command_301
    $scene.transition_time = 40
    if $data_troops[@parameters[0]] != nil
      $game_temp.battle_abort = true
      $game_temp.battle_calling = true
      $game_temp.battle_troop_id = @parameters[0]
      $game_temp.battle_can_escape = @parameters[1]
      $game_temp.battle_can_lose = @parameters[2]
      current_indent = @list[@index].indent
      $game_temp.battle_proc = Proc.new { |n| @branch[current_indent] = n }
    end
    @index += 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● 勝った場合
  #--------------------------------------------------------------------------
  def command_601
    if @branch[@list[@index].indent] == 0
      @branch.delete(@list[@index].indent)
      return true
    end
    return command_skip
  end
  #--------------------------------------------------------------------------
  # ● 逃げた場合
  #--------------------------------------------------------------------------
  def command_602
    if @branch[@list[@index].indent] == 1
      @branch.delete(@list[@index].indent)
      return true
    end
    return command_skip
  end
  #--------------------------------------------------------------------------
  # ● 負けた場合
  #--------------------------------------------------------------------------
  def command_603
    if @branch[@list[@index].indent] == 2
      @branch.delete(@list[@index].indent)
      return true
    end
    return command_skip
  end
  #--------------------------------------------------------------------------
  # ● ショップの処理
  #--------------------------------------------------------------------------
  def command_302
    $game_temp.battle_abort = true
    $game_temp.shop_calling = true
    $game_temp.shop_goods = [@parameters]
    loop do
      @index += 1
      if @list[@index].code == 605
        $game_temp.shop_goods.push(@list[@index].parameters)
      else
        return false
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 名前入力の処理
  #--------------------------------------------------------------------------
  def command_303
    if $data_actors[@parameters[0]] != nil
      $game_temp.battle_abort = true
      $game_temp.password_calling = true
      $game_temp.pass_actor_id = @parameters[0]
      $game_temp.pass_max_char = @parameters[1]
    end
    @index += 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● HP の増減
  #--------------------------------------------------------------------------
  def command_311
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_actor(@parameters[0]) do |actor|
      if actor.hp > 0
        if @parameters[4] == false and actor.hp + value <= 0
          actor.hp = 1
        else
          actor.hp += value
        end
      end
    end
    $game_temp.gameover = $game_party.all_dead?
    return true
  end
  #--------------------------------------------------------------------------
  # ● SP の増減
  #--------------------------------------------------------------------------
  def command_312
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_actor(@parameters[0]) do |actor|
      actor.fatigue += value
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● ステートの変更
  #--------------------------------------------------------------------------
  def command_313
    iterate_actor(@parameters[0]) do |actor|
      if @parameters[1] == 0
        actor.add_state(@parameters[2])
      else
        actor.remove_state(@parameters[2])
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  def command_314
    iterate_actor(@parameters[0]) do |actor|
      actor.recover_all
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● EXP の増減
  #--------------------------------------------------------------------------
  def command_315
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_actor(@parameters[0]) do |actor|
      actor.exp += value
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● レベルの増減
  #--------------------------------------------------------------------------
  def command_316
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    iterate_actor(@parameters[0]) do |actor|
      actor.level += value
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● パラメータの増減
  #--------------------------------------------------------------------------
  def command_317
    value = operate_value(@parameters[2], @parameters[3], @parameters[4])
    actor = $game_actors[@parameters[0]]
    if actor != nil
      case @parameters[1]
      when 0
        actor.maxhp += value
      when 1
        actor.exertion += value
      when 2
        actor.str += value
      when 3
        actor.dex += value
      when 4
        actor.agi += value
      when 5
        actor.int += value
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● スキルの増減
  #--------------------------------------------------------------------------
  def command_318
    actor = $game_actors[@parameters[0]]
    if actor != nil
      if @parameters[1] == 0
        actor.learn_skill(@parameters[2])
      else
        actor.forget_skill(@parameters[2])
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更
  #--------------------------------------------------------------------------
  def command_319
    actor = $game_actors[@parameters[0]]
    if actor != nil
      actor.equip(@parameters[1], @parameters[2])
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクターの名前変更
  #--------------------------------------------------------------------------
  def command_320
    actor = $game_actors[@parameters[0]]
    if actor != nil
      actor.name = @parameters[1]
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクターのクラス変更
  #--------------------------------------------------------------------------
  def command_321
    actor = $game_actors[@parameters[0]]
    if actor != nil
      actor.class_id = @parameters[1]
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクターのグラフィック変更
  #--------------------------------------------------------------------------
  def command_322
    actor = $game_actors[@parameters[0]]
    if actor != nil
      actor.set_graphic(@parameters[1], @parameters[2],
        @parameters[3], @parameters[4])
    end
    $game_player.refresh
    return true
  end
end
