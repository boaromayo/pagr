#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　トループを扱うクラスです。このクラスのインスタンスは $game_troop で参照さ
# れます。
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @enemies = []
  end
  #--------------------------------------------------------------------------
  # ● エネミーの取得
  #--------------------------------------------------------------------------
  def enemies
    return @enemies
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     troop_id : トループ ID
  #--------------------------------------------------------------------------
  def setup(troop_id)
    @enemies = []
    error1 = "Error: Minimum size for random groups "
    error2 = "must not exceed maxmimum size."
    error3 = error1 + error2
    error4 = "Error: There must be at least as many "
    error5 = "monsters in the monster group as "
    error6 = "the maximum number of monsters that can "
    error7 = "appear in the random monster group."
    error8 = error4 + error5 + error6 + error7
    error9 = "Error: Number of monsters to use in "
    error10 = "random generation is greater than "
    error11 = "the size of the monster group."
    error12 = error9 + error10 + error11
    troop = $data_troops[troop_id]
    first = troop.name[0]
    second = troop.name[1]
    third = troop.name[2]
    if first >= 49 && first <= 56
      if second >= 49 && second <= 56
        if third >= 49 && third <= 56
          min = first - 48
          max = second - 48
          used = third - 48
          difference = second - first
          if min > max
            print(error3)
            exit
          end
          if max > troop.members.size
            print(error8)
            exit
          end
          if used > troop.members.size
            print(error12)
            exit
          end
        if difference != 0
        #  troop_size = rand(difference + 1) + min
          dice = rand(100)
          s = min
          count = 0
          done = false
          while not done
            if troop.frequency_distribution == []
              print("Warning: No frequency distribution set.")
              troop_size = s
              done = true
            elsif dice < troop.frequency_distribution[count]
              troop_size = s
              done = true
            else
              dice -= troop.frequency_distribution[count]
              count += 1
              s += 1
            end
          end
        else
          troop_size = min
        end
        for i in 0..troop_size - 1
           enemy_number = rand(used)
           @enemies.push(Game_Enemy.new(troop_id, enemy_number, i))
        end
           return
        end
      end
    end
    for i in 0...troop.members.size
      enemy = $data_enemies[troop.members[i].enemy_id]
      if enemy != nil
        @enemies.push(Game_Enemy.new(troop_id, i))
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象エネミーのランダムな決定
  #     hp0 : HP 0 のエネミーに限る
  #--------------------------------------------------------------------------
  def random_target_enemy(hp0 = false)
    roulette = []
    for enemy in @enemies
      if (not hp0 and enemy.exist?) or (hp0 and enemy.hp0?)
        roulette.push(enemy)
      end
    end
    if roulette.size == 0
      return nil
    end
    return roulette[rand(roulette.size)]
  end
  #--------------------------------------------------------------------------
  # ● Targets multiple monsters.
  #     hp0 : Whether the monster has HP 0.
  #--------------------------------------------------------------------------
  def multi_random_target_enemy(hp0 = false)
    max_targets = 0
    num_targets = 0
    selected_targets = []
    if hp0
      for monster in $game_troop.enemies
        if monster.hp == 0
          max_targets += 1
        end
      end
    else
      for monster in $game_troop.enemies
        if monster.hp > 0
          max_targets += 1
        end
      end
    end
    if max_targets == 0
      return nil
    end
    targz = rand(max_targets) + 1
    max_targets = targz
    while num_targets < max_targets
      t = $game_troop.enemies[rand($game_troop.enemies.size)]
      if selected_targets.include?(t)
        next
      end
      if hp0
        if t.hp == 0
          selected_targets.push(t)
          num_targets += 1
        end
      else
        if t.hp > 0
          selected_targets.push(t)
          num_targets += 1
        end
      end
    end
    return selected_targets
  end
  #--------------------------------------------------------------------------
  # ● 対象エネミーのランダムな決定 (HP 0)
  #--------------------------------------------------------------------------
  def random_target_enemy_hp0
    return random_target_enemy(true)
  end
  #--------------------------------------------------------------------------
  # ● 対象エネミーのスムーズな決定
  #     enemy_index : エネミーインデックス
  #--------------------------------------------------------------------------
  def smooth_target_enemy(enemy_index)
    enemy = @enemies[enemy_index]
    if enemy != nil and enemy.exist?
      return enemy
    end
    for enemy in @enemies
      if enemy.exist?
        return enemy
      end
    end
  end
end
