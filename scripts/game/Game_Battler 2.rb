#==============================================================================
# ■ Game_Battler (分割定義 2)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● ステートの検査
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state?(state_id)
    return @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # ● ステートがフルかどうかの判定
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state_full?(state_id)
    unless self.state?(state_id)
      return false
    end
    if @states_turn[state_id] == -1
      return true
    end
    return @states_turn[state_id] == $data_states[state_id].hold_turn
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #     state_id : ステート ID
  #     force    : 強制付加フラグ (オートステートの処理で使用)
  #--------------------------------------------------------------------------
  def add_state(state_id, force = false)
    if $data_states[state_id] == nil
      return
    end
    unless force
      for i in @states
        if $data_states[i].minus_state_set.include?(state_id) and
           not $data_states[state_id].minus_state_set.include?(i)
          return
        end
      end
    end
    unless state?(state_id)
      @states.push(state_id)
      if $data_states[state_id].zero_hp
        @hp = 0
      end
      for i in 1...$data_states.size
        if $data_states[state_id].plus_state_set.include?(i)
          add_state(i)
        end
        if $data_states[state_id].minus_state_set.include?(i)
          remove_state(i)
        end
      end
      @states.sort! do |a, b|
        state_a = $data_states[a]
        state_b = $data_states[b]
        if state_a.rating > state_b.rating
          -1
        elsif state_a.rating < state_b.rating
          +1
        elsif state_a.restriction > state_b.restriction
          -1
        elsif state_a.restriction < state_b.restriction
          +1
        else
          a <=> b
        end
      end
    end
    if force
      @states_turn[state_id] = -1
    end
    unless  @states_turn[state_id] == -1
      @states_turn[state_id] = $data_states[state_id].hold_turn
    end
    unless movable?
      @current_action.clear
    end
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● ステートの解除
  #     state_id : ステート ID
  #     force    : 強制解除フラグ (オートステートの処理で使用)
  #--------------------------------------------------------------------------
  def remove_state(state_id, force = false)
    if state?(state_id)
      if @states_turn[state_id] == -1 and not force
        return
      end
      if @hp == 0 and $data_states[state_id].zero_hp
        zero_hp = false
        for i in @states
          if i != state_id and $data_states[i].zero_hp
            zero_hp = true
          end
        end
        if zero_hp == false
          @hp = 1
        end
      end
      @states.delete(state_id)
      @states_turn.delete(state_id)
    end
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● ステートのアニメーション ID 取得
  #--------------------------------------------------------------------------
  def state_animation_id(f_num)
    states = @states.clone
    for i in states
      if $data_states[i].animation_id == 0
        states.delete(i)
      end
    end
    if states.size == 0
      return 0
    end
    return $data_states[@states[f_num / 50 % @states.size]].animation_id
  end
  #--------------------------------------------------------------------------
  # ● 制約の取得
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    for i in @states
      if $data_states[i].restriction >= restriction_max
        restriction_max = $data_states[i].restriction
      end
    end
    return restriction_max
  end
  #--------------------------------------------------------------------------
  # ● ステート [EXP を獲得できない] 判定
  #--------------------------------------------------------------------------
  def cant_get_exp?
    for i in @states
      if $data_states[i].cant_get_exp
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [攻撃を回避できない] 判定
  #--------------------------------------------------------------------------
  def cant_evade?
    for i in @states
      if $data_states[i].cant_evade
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [スリップダメージ] 判定
  #--------------------------------------------------------------------------
  def slip_damage?
    for i in @states
      if $data_states[i].slip_damage
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● バトル用ステートの解除 (バトル終了時に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for i in @states.clone
      if $data_states[i].battle_only
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート自然解除 (ターンごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_auto
    for i in @states_turn.keys.clone
      if @states_turn[i] > 0
        @states_turn[i] -= 1
      elsif rand(100) < $data_states[i].auto_release_prob
        remove_state(i)
      else
        @states_turn[i] = $data_states[i].hold_turn
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート衝撃解除 (物理ダメージごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for i in @states.clone
      if rand(100) < $data_states[i].shock_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート変化 (+) の適用
  #     plus_state_set  : ステート変化 (+)
  #--------------------------------------------------------------------------
  def states_plus(plus_state_set)
    effective = false
    for i in plus_state_set
      if self.is_a?(Game_Actor)
        if $data_classes[self.class_id].state_ranks[i] < 5
          @show_guard = false
        end
      end
      if self.is_a?(Game_Enemy)
        if $data_enemies[self.id].state_ranks[i] < 5
          @show_guard = false
        end
      end
      unless self.state_guard?(i)
        effective |= self.state_full?(i) == false
        if $data_states[i].nonresistance
          @state_changed = true
          add_state(i)
          if $game_temp.in_battle
            @state_grabber = true
            if $data_states[i].id <= 14
              unless self.dead?
                @new_states.push($data_states[i].name)
              end
            end
          end
        elsif self.state_full?(i) == false
          if @attack_add_state
            tbl = [0,25,20,15,10,5,0][self.state_ranks[i]]
          else
            tbl = [0,100,80,60,40,20,0][self.state_ranks[i]]
          end
          if rand(100) < tbl
            @state_changed = true
            add_state(i)
            if $game_temp.in_battle
              @state_grabber = true
              if $data_states[i].id <= 14
                unless self.dead?
                  @new_states.push($data_states[i].name)
                end
              end
            end
          end
        end
      end
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # ● ステート変化 (-) の適用
  #     minus_state_set : ステート変化 (-)
  #--------------------------------------------------------------------------
  def states_minus(minus_state_set)
    effective = false
    for i in minus_state_set
      effective |= self.state?(i)
      @state_changed = true
      remove_state(i)
    end
    return effective
  end
end
