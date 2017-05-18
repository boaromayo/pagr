#==============================================================================
# ■ Game_Battler (分割定義 1)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  SHIELD_ANIMATION_ID = 202
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :battler_name
  attr_reader   :battler_hue
  attr_reader   :hp
  attr_reader   :sp
  attr_reader   :states
  attr_accessor :hidden
  attr_accessor :immortal
  attr_accessor :damage_pop
  attr_accessor :damage
  attr_accessor :critical
  attr_accessor :animation_id
  attr_accessor :animation_hit
  attr_accessor :white_flash
  attr_accessor :blink
  attr_accessor :fatigue
  attr_accessor :exertion
  attr_accessor :fatigue_delay
  attr_accessor :exertion_delay
  attr_accessor :fatigue_damage
  attr_accessor :exertion_damage
  attr_accessor :energy_damage
  attr_accessor :support_crush
  attr_accessor :forced_actions
  attr_accessor :no_overfatigue
  attr_accessor :item_used_times
  attr_accessor :hp_shield
  attr_accessor :hp_shield_max
  attr_accessor :hp_shield_damage
  attr_accessor :hp_shield_refresh_frames
  attr_accessor :untargetable_frames
  attr_accessor :invincible_frames
  attr_accessor :already_stolen
  attr_accessor :new_states
  attr_accessor :assimilate_data
  attr_accessor :recent_hp
  attr_accessor :recent_ft
  attr_accessor :recent_ex
  attr_accessor :recent_revive
  attr_accessor :damage_count
  attr_accessor :berserk_count
  attr_accessor :doom_count
  attr_accessor :venom_accelerant
  attr_accessor :show_guard
  attr_accessor :guts_flag
  attr_accessor :overkill_percent
  attr_accessor :death_attack
  attr_accessor :extra_charge
  attr_accessor :next_action_delay
  attr_accessor :delay_def_down
  attr_accessor :libel_level
  attr_accessor :spike_mult
  attr_accessor :charge_up
  attr_accessor :ex_cost_up
  attr_accessor :extract_effect
  attr_accessor :state_grabber
  attr_accessor :ft_limit
  attr_accessor :pe_maxhp_up
  attr_accessor :pe_str_up
  attr_accessor :pe_dex_up
  attr_accessor :pe_agi_up
  attr_accessor :pe_int_up
  attr_accessor :pe_ftr_up
  attr_accessor :pe_exr_up
  attr_accessor :bleed
  attr_accessor :bleed_last_hp
  attr_accessor :sealed_actions
  attr_accessor :last_dmg
  attr_accessor :ex_inverse
  attr_accessor :element_guard_percent
  attr_accessor :critical_guard
  attr_accessor :hibernation_level
  attr_accessor :counter_misses
  attr_accessor :factor_changes
  attr_accessor :action_priority
  attr_accessor :galvanized
  attr_accessor :villify
  attr_accessor :attack_add_state
  attr_accessor :show_hp_bar
  attr_accessor :reflect_chance
  attr_accessor :itemfocus_item
  attr_accessor :leukocite
  attr_accessor :shaping_magnet
  attr_accessor :auto_item_delay
  attr_accessor :combo_level
  attr_accessor :combo_hp
  attr_accessor :isolate
  attr_accessor :guard_once
  attr_accessor :stunner
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @hp = 0
    @sp = 0
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @pe_maxhp_up = 0
    @pe_str_up = 0
    @pe_dex_up = 0
    @pe_agi_up = 0
    @pe_int_up = 0
    @pe_ftr_up = 0
    @pe_exr_up = 0
    @next_action_delay = 0
    @hp_shield = -1
    @hp_shield_max = -1
    @hp_shield_refresh_frames = -1
    @animation_id = 0
    @bleed_last_hp = 0
    @hibernation_level = 0
    @combo_level = 0
    @combo_hp = 0
    @action_priority = 1
    @hidden = false
    @immortal = false
    @damage_pop = false
    @damage = nil
    @fatigue_damage = nil
    @exertion_damage = nil
    @energy_damage = nil
    @hp_shield_damage = nil
    @critical = false
    @animation_hit = false
    @white_flash = false
    @blink = false
    @support_crush = false
    @already_stolen = false
    @show_guard = false
    @guts_flag = false
    @death_attack = false
    @extra_charge = false
    @charge_up = false
    @extract_effect = false
    @state_grabber = false
    @bleeding = false
    @ex_inverse = false
    @critical_guard = false
    @counter_misses = false
    @galvanized = false
    @attack_add_state = false
    @show_hp_bar = false
    @shaping_magnet = false
    @isolate = false
    @delay_def_down = false
    @guard_once = false
    @stunner = false
    @villify = -1
    @untargetable_frames = -1
    @invincible_frames = -1
    @auto_item_delay = -1
    @fatigue_delay = 0
    @exertion_delay = 0
    @item_used_times = 0
    @ft_limit = 100
    @recent_hp = -1
    @recent_ft = -1
    @recent_ex = -1
    @recent_revive = -1
    @berserk_count = -1
    @doom_count = -1
    @venom_accelerant = -1
    @damage_count = 0
    @overkill_percent = 0
    @libel_level = 0
    @ex_cost_up = 0
    @reflect_chance = 0
    @itemfocus_item = 0
    @leukocite = 0
    @last_dmg = -1
    @spike_mult = 0.0
    @current_action = Game_BattleAction.new
    @forced_actions = []
    @new_states = []
    @assimilate_data = []
    @sealed_actions = []
    @factor_changes = [0, 0, 0, 0]
    set_assimilate
    @element_guard_percent = []
    for i in 0..$data_system.elements.size - 1
      @element_guard_percent[i] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 999999].min
    pe_modifier = base_maxhp * @pe_maxhp_up / 100
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n += pe_modifier
    n = [[Integer(n), 1].max, 999999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 腕力の取得
  #--------------------------------------------------------------------------
  def str
    base_value = [[base_str + @str_plus, 1].max, 999].min
    pe_modifier = base_str * @pe_str_up / 100
    original = base_value
    for i in @states
      base_value *= $data_states[i].str_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 6
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 3
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    total = original + status_modifier + fatigue_modifier + pe_modifier
    result = [[Integer(total), 1].max, 999].min
    return result
  end
  #--------------------------------------------------------------------------
  # ● 器用さの取得
  #--------------------------------------------------------------------------
  def dex
    base_value = [[base_dex + @dex_plus, 1].max, 999].min
    pe_modifier = base_dex * @pe_dex_up / 100
    auto_modifier = 0
    if self.is_a?(Game_Actor) 
      if self.equipped_auto_abilities.include?(58)
        auto_modifier += base_dex / 10
      end
    end
    original = base_value
    for i in @states
      base_value *= $data_states[i].dex_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 8
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 4
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    total = original + status_modifier + fatigue_modifier + pe_modifier
    total += auto_modifier
    result = [[Integer(total), 1].max, 999].min
    return result
  end
  #--------------------------------------------------------------------------
  # ● 素早さの取得
  #--------------------------------------------------------------------------
  def agi
    base_value = [[base_agi + @agi_plus, 1].max, 999].min
    pe_modifier = base_agi * @pe_agi_up / 100
    original = base_value
    for i in @states
      base_value *= $data_states[i].agi_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 8
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 4
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    total = original + status_modifier + fatigue_modifier
    result = [[Integer(total), 1].max, 999].min
    return result
  end
  #--------------------------------------------------------------------------
  # ● 魔力の取得
  #--------------------------------------------------------------------------
  def int
    base_value = [[base_int + @int_plus, 1].max, 999].min
    pe_modifier = base_int * @pe_int_up / 100
    original = base_value
    for i in @states
      base_value *= $data_states[i].int_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 6
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 3
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    if @berserk_count > 0
      berserk_multiplier = 1.25
    else
      berserk_multiplier = 1
    end
    total = original + status_modifier + fatigue_modifier + pe_modifier
    total *= berserk_multiplier
    result = [[Integer(total), 1].max, 999].min
    return result
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の設定
  #     maxhp : 新しい MaxHP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -9999].max, 9999].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● 腕力の設定
  #     str : 新しい腕力
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 器用さの設定
  #     dex : 新しい器用さ
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 素早さの設定
  #     agi : 新しい素早さ
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 魔力の設定
  #     int : 新しい魔力
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  def hit
    n = 95
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の取得
  #--------------------------------------------------------------------------
  def atk
    base_value = base_atk
    original = base_value
    for i in @states
      base_value *= $data_states[i].atk_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 4
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 2
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    if @berserk_count > 0
      berserk_multiplier = 1.25
    else
      berserk_multiplier = 1
    end
    total = original + status_modifier + fatigue_modifier
    total *= berserk_multiplier
    return Integer(total)
  end
  #--------------------------------------------------------------------------
  # ● 物理防御の取得
  #--------------------------------------------------------------------------
  def pdef
    base_value = base_pdef
    original = base_value
    for i in @states
      base_value *= $data_states[i].pdef_rate / 100.0
    end
    status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 4
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 2
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    hibernate_modifier = original * Integer(self.hibernation_level) / 100
    delay_modifier = 0
    if @delay_def_down && @current_action.action_delay > 0
      delay_modifier = original * 3
      delay_modifier /= 4
    end
    sm = status_modifier
    fm = fatigue_modifier
    hm = hibernate_modifier
    dm = delay_modifier
    total = original + sm + fm + hm - dm
    return Integer(total)
  end
  #--------------------------------------------------------------------------
  # ● 魔法防御の取得
  #--------------------------------------------------------------------------
  def mdef
    base_value = base_mdef
    original = base_value
    for i in @states
      base_value *= $data_states[i].mdef_rate / 100.0
    end
     status_modifier = base_value - original
    if @fatigue > 0
      fatigue_percent = @fatigue / 4
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue < 0
      fatigue_percent = @fatigue / 2
      fatigue_modifier = original * fatigue_percent / 100.0
    end
    if @fatigue == 0
      fatigue_modifier = 0
    end
    delay_modifier = 0
    if @delay_def_down && @current_action.action_delay > 0
      delay_modifier = original * 3
      delay_modifier /= 4
    end
    total = original + status_modifier + fatigue_modifier - delay_modifier
    return Integer(total)
  end
  #--------------------------------------------------------------------------
  # ● 回避修正の取得
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ● HP の変更
  #     hp : 新しい HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
    add_death_attack
    for i in 1...$data_states.size
      if $data_states[i].zero_hp
        if self.dead?
          add_state(i)
        else
          remove_state(i)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● SP の変更
  #     sp : 新しい SP
  #--------------------------------------------------------------------------
  def fatigue=(fatigue)
    @fatigue = [fatigue, @ft_limit].min
    @fatigue = [@fatigue, -999].max
  end
  #------------------------
  def exertion=(exertion)
    @exertion = [exertion, 1000].min
    @exertion = [@exertion, 0].max
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    if @fatigue < 0
      @fatigue = 0
    end
    @exertion = 0
    @energy = 100
    for i in @states.clone
      remove_state(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● カレントアクションの取得
  #--------------------------------------------------------------------------
  def current_action
    return @current_action
  end
  #--------------------------------------------------------------------------
  # ● アクションスピードの決定
  #--------------------------------------------------------------------------
  def make_action_speed
    @current_action.speed = agi + rand(10 + agi / 4)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能判定
  #--------------------------------------------------------------------------
  def dead?
    if @hp > 0
      return false
    end
    if @immortal
      return false
    end
    if @berserk_count > 0
      return false
    end
    if @death_attack
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 存在判定
  #--------------------------------------------------------------------------
  def exist?
    if @hidden
      return false
    end
    if @hp > 0
      return true
    end
    if @immortal
      return true
    end
    if @berserk_count > 0
      return true
    end
  end
  #--------------------------------------------------------------------------
  # ● HP 0 判定
  #--------------------------------------------------------------------------
  def hp0?
    return (not @hidden and @hp == 0)
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  def inputable?
    return (not @hidden and restriction <= 1)
  end
  #--------------------------------------------------------------------------
  # ● 行動可能判定
  #--------------------------------------------------------------------------
  def movable?
    return (not @hidden and restriction < 4)
  end
  #--------------------------------------------------------------------------
  # ● 防御中判定
  #--------------------------------------------------------------------------
  def guarding?
    if @current_action.passive == 1
      return true
    end
    if @current_action.passive == 3
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 休止中判定
  #--------------------------------------------------------------------------
  def resting?
    return (@current_action.kind == 0 and @current_action.basic == 3)
  end
  #---------------------------
  def afraid?
    for i in @states
      if $data_states[i].fear
        return true
      end
    end
  return false
  end
  #---------------------------
  def diseased?
    for i in @states
      if $data_states[i].disease
        return true
      end
    end
  return false
  end
  #---------------------------
  def sluggish?
    for i in @states
      if $data_states[i].sluggish
        return true
      end
    end
  return false
  end
  #---------------------------
  def plague?
    for i in @states
      if $data_states[i].plague
        return true
      end
    end
  return false
  end
  #---------------------------
  def fainted?
    if @fatigue <= -100
      return true
    else
      return false
    end
  end
   #---------------------------
  def waiting?
    if @current_action.action_delay > 0
      return true
    else
      return false
    end
  end
end
