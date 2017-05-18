#==============================================================================
# ■ Game_BattleAction
#------------------------------------------------------------------------------
# 　アクション (戦闘中の行動) を扱うクラスです。このクラスは Game_Battler クラ
# スの内部で使用されます。
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :speed
  attr_accessor :type
  attr_accessor :passive
  attr_accessor :setup
  attr_accessor :forcing_type
  attr_accessor :forcing_skill_id
  attr_accessor :skill_id
  attr_accessor :change_tactic
  attr_accessor :action_delay
  attr_accessor :total_delay
  attr_accessor :item_id
  attr_accessor :target_index
  attr_accessor :forcing
  attr_accessor :no_fatigue_cost
  attr_accessor :counter
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @forcing_type = 0
    @forcing_skill_id = 0
    clear
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @speed = 0
    @type = 0
    @passive = 0
    @setup = 0
    @skill_id = 0
    @change_tactic = 0
    @action_delay = 0
    @total_delay = 0
    @item_id = 0
    @target_index = -1
    @forcing = false
    @no_fatigue_cost = false
    @counter = false
  end
  #--------------------------------------------------------------------------
  # ● 味方単体用判定
  #--------------------------------------------------------------------------
  def for_one_friend?
    if @type == 2 and [3, 5].include?($data_skills[@skill_id].scope)
      return true
    end
    if @type == 3 and [3, 5].include?($data_items[@item_id].scope)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 味方単体用 (HP 0) 判定
  #--------------------------------------------------------------------------
  def for_one_friend_hp0?
    if @type == 2 and [5].include?($data_skills[@skill_id].scope)
      return true
    end
    if @type == 3 and [5].include?($data_items[@item_id].scope)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ランダムターゲット (アクター用)
  #--------------------------------------------------------------------------
  def decide_random_target_for_actor
    if for_one_friend_hp0?
      battler = $game_party.random_target_actor_hp0
    elsif for_one_friend?
      battler = $game_party.random_target_actor
    else
      battler = $game_troop.random_target_enemy
    end
    if battler != nil
      @target_index = battler.index
    else
      clear
    end
  end
  #--------------------------------------------------------------------------
  # ● ランダムターゲット (エネミー用)
  #--------------------------------------------------------------------------
  def decide_random_target_for_enemy
    if for_one_friend_hp0?
      battler = $game_troop.random_target_enemy_hp0
    elsif for_one_friend?
      battler = $game_troop.random_target_enemy
    else
      battler = $game_party.random_target_actor
    end
    if battler != nil
      if battler == $game_party.actors[0]
        @target_index = 0
      end
      if battler == $game_party.actors[1]
        @target_index = 1
      end
      if battler == $game_party.actors[2]
        @target_index = 2
      end
      if battler == $game_party.actors[3]
        @target_index = 3
      end
      if battler == $game_troop.enemies[0]
        @target_index = 0
      end
      if battler == $game_troop.enemies[1]
        @target_index = 1
      end
      if battler == $game_troop.enemies[2]
        @target_index = 2
      end
      if battler == $game_troop.enemies[3]
        @target_index = 3
      end
      if battler == $game_troop.enemies[4]
        @target_index = 4
      end
      if battler == $game_troop.enemies[5]
        @target_index = 5
      end
      if battler == $game_troop.enemies[6]
        @target_index = 6
      end
      if battler == $game_troop.enemies[7]
        @target_index = 7
      end
    else
      clear
    end
  end
  #--------------------------------------------------------------------------
  # ● ラストターゲット (アクター用)
  #--------------------------------------------------------------------------
  def decide_last_target_for_actor
    if @target_index == -1
      battler = nil
    elsif for_one_friend?
      battler = $game_party.actors[@target_index]
      if battler.dead?
        battler = $game_party.smooth_target_actor(battler.index)
      end
      if battler.hidden
        battler = $game_party.smooth_target_actor(battler.index)
      end
    else
      battler = $game_troop.enemies[@target_index]
      if battler.dead?
        battler = $game_troop.smooth_target_enemy(battler.index)
      end
      if battler.hidden
        battler = $game_troop.smooth_target_enemy(battler.index)
      end
    end
    if battler == nil or not battler.exist?
      clear
    end
  end
  #--------------------------------------------------------------------------
  # ● ラストターゲット (エネミー用)
  #--------------------------------------------------------------------------
  def decide_last_target_for_enemy
    if @target_index == -1
      battler = nil
    elsif for_one_friend?
      battler = $game_troop.enemies[@target_index]
    else
      battler = $game_party.actors[@target_index]
    end
    if battler == nil or not battler.exist?
      clear
    end
  end
  # --------------------
  def pending?
    return @type != 0
  end
  # --------------------
  def ready_action
    if @setup > 0
      @type = @setup
      @setup = 0
    end
  end
  # --------------------
  def ai_action(battler, tactic_id)
    action_ok = false
    atk_prob = -1
    heal_prob = -1
    heal_percent = 0
    for actor in $game_party.actors
      p = actor.hp * 100 / actor.maxhp
      heal_percent += p
    end
    heal_percent /= $game_party.actors.size
    heal_modifier = 100 - heal_percent
    if tactic_id == 1
      atk_prob = 100
      heal_prob = heal_percent * 20
    end
    if tactic_id == 2
      atk_prob = 500
      heal_prob = heal_percent * 30
    end
    if tactic_id == 3
      atk_prob = 500
      heal_prob = 200
    end
    if tactic_id == 4
      atk_prob = -1
      heal_prob = -1
    end
    if atk_prob > 0
      unless action_ok
        r = rand(atk_prob)
        if battler.afraid?
          r = -1
        end
        if r == 0
          @setup = 1
          action_ok = true
        end
      end
    end
    if heal_prob > 0
      unless action_ok
        r = rand(heal_prob)
        if r == 0
          @setup = 2
          @skill_id = 75
          battler.current_action.decide_random_target_for_actor
          action_ok = true
        end
      end
    end
  end
  # --------------------
  def ready_forced_action(battler)
    if battler.forced_actions.size > 0
      a = battler.forced_actions.shift
      @type = a.type
      @forcing = true
      @no_fatigue_cost = a.nonfatiguing
      if @type == 1
        if a.add_a == 1
          @counter = true
        end
      end
      if @type == 2
        @skill_id = a.add_a
      end
      if @type == 3
        @item_id = a.add_a
        if a.add_b == 1
          $game_party.gain_item(a.add_a, 1)
        end
        if a.add_b == 2
          $game_temp.filch_item = true
        end
      end
      if a.target <= -11
        @target_index = a.target
      end
      if a.target == -2
        if battler.is_a?(Game_Enemy)
          battler.current_action.decide_last_target_for_enemy
        else
          battler.current_action.decide_last_target_for_actor
        end
      end
      if a.target == -1
        if battler.is_a?(Game_Enemy)
          battler.current_action.decide_random_target_for_enemy
        else
          battler.current_action.decide_random_target_for_actor
        end
      end
      if a.target >= 0
        @target_index = a.target
      end
    end
  end
end
