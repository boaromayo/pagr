#==============================================================================
# ■ Game_Party
#------------------------------------------------------------------------------
# 　パーティを扱うクラスです。ゴールドやアイテムなどの情報が含まれます。このク
# ラスのインスタンスは $game_party で参照されます。
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :actors                   # アクター
  attr_reader   :gold                     # ゴールド
  attr_reader   :steps                    # 歩数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @actors = []
    @gold = 0
    @steps = 0
    @items = {}
    @weapons = {}
    @armors = {}
  end
  #--------------------------------------------------------------------------
  # ● 初期パーティのセットアップ
  #--------------------------------------------------------------------------
  def setup_starting_members
    @actors = []
    for i in $data_system.party_members
      @actors.push($game_actors[i])
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト用パーティのセットアップ
  #--------------------------------------------------------------------------
  def setup_battle_test_members
    @actors = []
    for battler in $data_system.test_battlers
      actor = $game_actors[battler.actor_id]
      actor.level = battler.level
      gain_weapon(battler.weapon_id, 1)
      gain_armor(battler.armor1_id, 1)
      gain_armor(battler.armor2_id, 1)
      gain_armor(battler.armor3_id, 1)
      gain_armor(battler.armor4_id, 1)
      actor.equip(0, battler.weapon_id)
      actor.equip(1, battler.armor1_id)
      actor.equip(2, battler.armor2_id)
      actor.equip(3, battler.armor3_id)
      actor.equip(4, battler.armor4_id)
      actor.recover_all
      @actors.push(actor)
    end
    @items = {}
    for i in 1...$data_items.size
      if $data_items[i].name != ""
        occasion = $data_items[i].occasion
        if occasion == 0 or occasion == 1
          @items[i] = 99
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーのリフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    new_actors = []
    for i in 0...@actors.size
      if $data_actors[@actors[i].id] != nil
        new_actors.push($game_actors[@actors[i].id])
      end
    end
    @actors = new_actors
  end
  #--------------------------------------------------------------------------
  # ● 最大レベルの取得
  #--------------------------------------------------------------------------
  def max_level
    if @actors.size == 0
      return 0
    end
    level = 0
    for actor in @actors
      if level < actor.level
        level = actor.level
      end
    end
    return level
  end
  #--------------------------------------------------------------------------
  # ● アクターを加える
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    actor = $game_actors[actor_id]
    if @actors.size < 4 and not @actors.include?(actor)
      @actors.push(actor)
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターを外す
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    @actors.delete($game_actors[actor_id])
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの増加 (減少)
  #     n : 金額
  #--------------------------------------------------------------------------
  def gain_gold(n)
    @gold = [[@gold + n, 0].max, 9999999].min
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの減少
  #     n : 金額
  #--------------------------------------------------------------------------
  def lose_gold(n)
    gain_gold(-n)
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  def increase_steps
    @steps = [@steps + 1, 9999999].min
  end
  #--------------------------------------------------------------------------
  # ● アイテムの所持数取得
  #     item_id : アイテム ID
  #--------------------------------------------------------------------------
  def item_number(item_id)
    return @items.include?(item_id) ? @items[item_id] : 0
  end
  #--------------------------------------------------------------------------
  # ● 武器の所持数取得
  #     weapon_id : 武器 ID
  #--------------------------------------------------------------------------
  def weapon_number(weapon_id)
    return @weapons.include?(weapon_id) ? @weapons[weapon_id] : 0
  end
  #--------------------------------------------------------------------------
  # ● 防具の所持数取得
  #     armor_id : 防具 ID
  #--------------------------------------------------------------------------
  def armor_number(armor_id)
    return @armors.include?(armor_id) ? @armors[armor_id] : 0
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増加 (減少)
  #     item_id : アイテム ID
  #     n       : 個数
  #--------------------------------------------------------------------------
  def gain_item(item_id, n)
    if item_id > 0
      @items[item_id] = [[item_number(item_id) + n, 0].max, 99].min
    end
  end
  #--------------------------------------------------------------------------
  # ● 武器の増加 (減少)
  #     weapon_id : 武器 ID
  #     n         : 個数
  #--------------------------------------------------------------------------
  def gain_weapon(weapon_id, n)
    if weapon_id > 0
      @weapons[weapon_id] = [[weapon_number(weapon_id) + n, 0].max, 99].min
    end
  end
  #--------------------------------------------------------------------------
  # ● 防具の増加 (減少)
  #     armor_id : 防具 ID
  #     n        : 個数
  #--------------------------------------------------------------------------
  def gain_armor(armor_id, n)
    if armor_id > 0
      @armors[armor_id] = [[armor_number(armor_id) + n, 0].max, 99].min
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの減少
  #     item_id : アイテム ID
  #     n       : 個数
  #--------------------------------------------------------------------------
  def lose_item(item_id, n)
    gain_item(item_id, -n)
  end
  #--------------------------------------------------------------------------
  # ● 武器の減少
  #     weapon_id : 武器 ID
  #     n         : 個数
  #--------------------------------------------------------------------------
  def lose_weapon(weapon_id, n)
    gain_weapon(weapon_id, -n)
  end
  #--------------------------------------------------------------------------
  # ● 防具の減少
  #     armor_id : 防具 ID
  #     n        : 個数
  #--------------------------------------------------------------------------
  def lose_armor(armor_id, n)
    gain_armor(armor_id, -n)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの使用可能判定
  #     item_id : アイテム ID
  #--------------------------------------------------------------------------
  def item_can_use?(item_id, check_crush = false)
    crush = true
    if item_number(item_id) == 0
      return false
    end
    occasion = $data_items[item_id].occasion
    if $game_temp.in_battle
      if check_crush
        crush = $scene.item_support_crush_eval(item_id)
      end
      return (occasion == 0 or occasion == 1) && crush
    end
    return (occasion == 0 or occasion == 2)
  end
  #--------------------------------------------------------------------------
  # ● 全員のアクションクリア
  #--------------------------------------------------------------------------
  def clear_actions
    for actor in @actors
      actor.current_action.clear
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  def inputable?
    for actor in @actors
      if actor.inputable?
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 全滅判定
  #--------------------------------------------------------------------------
  def all_dead?
    if $game_party.actors.size == 0
      return false
    end
    for actor in @actors
      if actor.immortal
        return false
      end
      if actor.hp > 0
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● スリップダメージチェック (マップ用)
  #--------------------------------------------------------------------------
  def check_map_slip_damage
    for actor in @actors
      if actor.hp > 0 and actor.slip_damage?
        actor.hp -= [actor.maxhp / 50, 1].max
        if actor.hp == 0
          $game_system.se_play($data_system.actor_collapse_se)
        end
        $scene.transition_time = 8
        Graphics.freeze
        $game_screen.start_flash(Color.new(0,170,0,255), 5)
        $game_temp.transition_processing = true
        $game_temp.transition_name = "damage"
        $game_temp.gameover = $game_party.all_dead?
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象アクターのランダムな決定
  #     hp0 : HP 0 のアクターに限る
  #--------------------------------------------------------------------------
  def random_target_actor(hp0 = false)
    roulette = []
    for actor in @actors
      if (not hp0 and actor.exist?) or (hp0 and actor.hp0?)
        roulette.push(actor)
      end
    end
    if roulette.size == 0
      return nil
    end
    return roulette[rand(roulette.size)]
  end
  #--------------------------------------------------------------------------
  # ● Targets multiple random actors
  #     hp0 : if the actor's HP needs to be 0.
  #--------------------------------------------------------------------------
  def multi_random_target_actor(hp0 = false)
    max_targets = 0
    num_targets = 0
    selected_targets = []
    if hp0
      for actor in $game_party.actors
        if actor.hp == 0
          max_targets += 1
        end
      end
    else
      for actor in $game_party.actors
        if actor.hp > 0
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
      t = $game_party.actors[rand($game_party.actors.size)]
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
  # ● 対象アクターのランダムな決定 (HP 0)
  #--------------------------------------------------------------------------
  def random_target_actor_hp0
    return random_target_actor(true)
  end
  #--------------------------------------------------------------------------
  # ● 対象アクターのスムーズな決定
  #     actor_index : アクターインデックス
  #--------------------------------------------------------------------------
  def smooth_target_actor(actor_index)
    actor = @actors[actor_index]
    if actor != nil and actor.exist?
      return actor
    end
    for actor in @actors
      if actor.exist?
        return actor
      end
    end
  end
  # -----------------------
  def count_dead
    result = 0
    for actor in @actors
      if actor.hp == 0
        result += 1
      end
    end
    return result
  end
  # -----------------------
end
