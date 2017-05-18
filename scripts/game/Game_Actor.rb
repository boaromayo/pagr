#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス ($game_actors)
# の内部で使用され、Game_Party クラス ($game_party) からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :name                     # 名前
  attr_reader   :character_name           # キャラクター ファイル名
  attr_reader   :character_hue            # キャラクター 色相
  attr_reader   :class_id                 # クラス ID
  attr_reader   :weapon_id                # 武器 ID
  attr_reader   :armor1_id                # 盾 ID
  attr_reader   :armor2_id                # 頭防具 ID
  attr_reader   :armor3_id                # 体防具 ID
  attr_reader   :armor4_id                # 装飾品 ID
  attr_reader   :level                    # レベル
  attr_reader   :exp                      # EXP
  attr_reader   :skills                   # スキル
  attr_accessor :battle_commands
  attr_accessor :disabled_battle_commands
  attr_accessor :exp_list
  attr_accessor :energy
  attr_accessor :ai_tactics
  attr_accessor :current_tactic
  attr_accessor :ai_ft_limit
  attr_accessor :ai_ex_limit
  attr_accessor :battler_name
  attr_accessor :battler_hue
  attr_accessor :summon_actor
  attr_accessor :equipped_auto_abilities
  attr_accessor :acumen_vectors_up
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    @hp = maxhp
    @states = []
    @ai_tactics = []
    @equipped_auto_abilities = []
    @states_turn = {}
    @current_tactic = 0
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @fatigue = 0
    @exertion = 0
    @ai_ft_limit = -50
    @ai_ex_limit = 0
    @fatigue_delay = 0
    @exertion_delay = 0
    @acumen_vectors_up = 0
    @energy = 100
    @no_overfatigue = false
    @summon_actor = false
    @battle_commands = ["Attack", "Skill", "Defend", "Item"]
    @disabled_battle_commands = [0, 0, 0, 0]
    for i in 1..@level
      for j in $data_classes[@class_id].learnings
        if j.level == i
          learn_skill(j.skill_id)
        end
      end
    end
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id])
  end
  #--------------------------------------------------------------------------
  # ● アクター ID 取得
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # ● インデックス取得
  #--------------------------------------------------------------------------
  def index
    return $game_party.actors.index(self)
  end
  #--------------------------------------------------------------------------
  # ● EXP 計算
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    fname = "Data\\actor" + actor.id.to_s + "exp.rxdata"
    if FileTest.exist?(fname)
      get_exp_list_from_file(fname)
      if @exp_file_error
        @exp_list = Array.new(101)
      else
        return
      end
    end
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..100
      if i > actor.final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 属性補正値の取得
  #     element_id : 属性 ID
  #--------------------------------------------------------------------------
  def element_rate(element_id, assimilate)
    table = [0,150,125,100,50,0,-100]
    result = table[$data_classes[@class_id].element_ranks[element_id]]
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil and armor.guard_element_set.include?(element_id)
        result /= 2
      end
    end
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    result -= self.element_guard_percent[element_id]
    count = @assimilate_data[element_id]
    while result > 0 && count > 0
      result -= 10
      count -= 1
      if result < 0
        result = 0
      end
    end
    if assimilate
      update_assimilate(element_id)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● ステート有効度の取得
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_classes[@class_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # ● ステート防御判定
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil
        if armor.guard_state_set.include?(state_id)
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  def element_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.element_set : []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (+) 取得
  #--------------------------------------------------------------------------
  def plus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.plus_state_set : []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (-) 取得
  #--------------------------------------------------------------------------
  def minus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.minus_state_set : []
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 9999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 9999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxHP の取得
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_actors[@actor_id].parameters[0, @level]
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxSP の取得
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_actors[@actor_id].parameters[1, @level]
  end
  #--------------------------------------------------------------------------
  # ● 基本腕力の取得
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.str_plus : 0
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    n += armor4 != nil ? armor4.str_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本器用さの取得
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.dex_plus : 0
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    n += armor4 != nil ? armor4.dex_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本素早さの取得
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.agi_plus : 0
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    n += armor4 != nil ? armor4.agi_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本魔力の取得
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    n += armor4 != nil ? armor4.int_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本攻撃力の取得
  #--------------------------------------------------------------------------
  def base_atk
    if self.summon_actor
      monster = $data_enemies[$game_system.summon_monster_id]
      return monster.atk
    end
    n = 0
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.atk : 0
    n += armor1 != nil ? armor1.atk : 0
    n += armor2 != nil ? armor2.atk : 0
    n += armor3 != nil ? armor3.atk : 0
    n += armor4 != nil ? armor4.atk : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本物理防御の取得
  #--------------------------------------------------------------------------
  def base_pdef
    if self.summon_actor
      monster = $data_enemies[$game_system.summon_monster_id]
      return monster.pdef
    end
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5
  end
  #--------------------------------------------------------------------------
  # ● 基本魔法防御の取得
  #--------------------------------------------------------------------------
  def base_mdef
    if self.summon_actor
      monster = $data_enemies[$game_system.summon_monster_id]
      return monster.mdef
    end
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    mdef1 = weapon != nil ? weapon.mdef : 0
    mdef2 = armor1 != nil ? armor1.mdef : 0
    mdef3 = armor2 != nil ? armor2.mdef : 0
    mdef4 = armor3 != nil ? armor3.mdef : 0
    mdef5 = armor4 != nil ? armor4.mdef : 0
    return mdef1 + mdef2 + mdef3 + mdef4 + mdef5
  end
  #--------------------------------------------------------------------------
  # ● 基本回避修正の取得
  #--------------------------------------------------------------------------
  def base_eva
    if self.summon_actor
      monster = $data_enemies[$game_system.summon_monster_id]
      return monster.eva
    end
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    eva1 = weapon != nil ? weapon.eva : 0
    eva2 = armor1 != nil ? armor1.eva : 0
    eva3 = armor2 != nil ? armor2.eva : 0
    eva4 = armor3 != nil ? armor3.eva : 0
    eva5 = armor4 != nil ? armor4.eva : 0
    return eva1 + eva2 + eva3 + eva4 + eva5
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 攻撃側アニメーション ID の取得
  #--------------------------------------------------------------------------
  def animation1_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation1_id : 0
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 対象側アニメーション ID の取得
  #--------------------------------------------------------------------------
  def animation2_id
    if self.summon_actor
      monster = $data_enemies[$game_system.summon_monster_id]
      return monster.animation2_id
    end
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation2_id : 0
  end
  #--------------------------------------------------------------------------
  # ● クラス名の取得
  #--------------------------------------------------------------------------
  def class_name
    return $data_classes[@class_id].name
  end
  #--------------------------------------------------------------------------
  # ● EXP の文字列取得
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp.to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルの EXP の文字列取得
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1].to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルまでの EXP の文字列取得
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
      (@exp_list[@level+1] - @exp).to_s : "-------"
  end
  #--------------------------------------------------------------------------
  # ● オートステートの更新
  #     old_armor : 外した防具
  #     new_armor : 装備した防具
  #--------------------------------------------------------------------------
  def update_auto_state(old_armor, new_armor)
    if old_armor != nil and old_armor.auto_state_id != 0
      remove_state(old_armor.auto_state_id, true)
    end
    if new_armor != nil and new_armor.auto_state_id != 0
      add_state(new_armor.auto_state_id, true)
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備固定判定
  #     equip_type : 装備タイプ
  #--------------------------------------------------------------------------
  def equip_fix?(equip_type)
    case equip_type
    when 0
      return $data_actors[@actor_id].weapon_fix
    when 1
      return $data_actors[@actor_id].armor1_fix
    when 2
      return $data_actors[@actor_id].armor2_fix
    when 3
      return $data_actors[@actor_id].armor3_fix
    when 4
      return $data_actors[@actor_id].armor4_fix
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更
  #     equip_type : 装備タイプ
  #     id    : 武器 or 防具 ID  (0 なら装備解除)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id, 1)
        @weapon_id = id
        $game_party.lose_weapon(id, 1)
      end
    when 1
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 2
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 3
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 4
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.gain_armor(@armor4_id, 1)
        @armor4_id = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備可能判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def equippable?(item)
    if item.is_a?(RPG::Weapon)
      if $data_classes[@class_id].weapon_set.include?(item.id)
        return true
      end
    end
    if item.is_a?(RPG::Armor)
      if $data_classes[@class_id].armor_set.include?(item.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● EXP の変更
  #     exp : 新しい EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [[exp, 9999999].min, 0].max
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      for j in $data_classes[@class_id].learnings
        if j.level == @level
          learn_skill(j.skill_id)
        end
      end
    end
    while @exp < @exp_list[@level]
      @level -= 1
    end
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● レベルの変更
  #     level : 新しいレベル
  #--------------------------------------------------------------------------
  def level=(level)
    level = [[level, $data_actors[@actor_id].final_level].min, 1].max
    self.exp = @exp_list[level]
  end
  #--------------------------------------------------------------------------
  # ● スキルを覚える
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    if skill_id > 0 and not skill_learn?(skill_id)
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルを忘れる
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # ● スキルの習得済み判定
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_learn?(skill_id)
    return @skills.include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if not skill_learn?(skill_id)
      return false
    end
    if self.energy < $data_skills[skill_id].drain
      return false
    end
    return super
  end
  #--------------------------------------------------------------------------
  # ● 名前の変更
  #     name : 新しい名前
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # ● クラス ID の変更
  #     class_id : 新しいクラス ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      unless equippable?($data_weapons[@weapon_id])
        equip(0, 0)
      end
      unless equippable?($data_armors[@armor1_id])
        equip(1, 0)
      end
      unless equippable?($data_armors[@armor2_id])
        equip(2, 0)
      end
      unless equippable?($data_armors[@armor3_id])
        equip(3, 0)
      end
      unless equippable?($data_armors[@armor4_id])
        equip(4, 0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● グラフィックの変更
  #     character_name : 新しいキャラクター ファイル名
  #     character_hue  : 新しいキャラクター 色相
  #     battler_name   : 新しいバトラー ファイル名
  #     battler_hue    : 新しいバトラー 色相
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_hue, battler_name, battler_hue)
    @character_name = character_name
    @character_hue = character_hue
    @battler_name = battler_name
    @battler_hue = battler_hue
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 X 座標の取得
  #--------------------------------------------------------------------------
  def screen_x
    if self.index != nil
      if self.summon_actor
         return 420
      else
        setup_battle_coords
      end
      return @battle_coords_x
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Y 座標の取得
  #--------------------------------------------------------------------------
  def screen_y
     if self.summon_actor
         return 240
      else
        setup_battle_coords
      end
    return @battle_coords_y
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Z 座標の取得
  #--------------------------------------------------------------------------
  def screen_z
    if self.index != nil
      return 4 - self.index
    else
      return 0
    end
  end
  # ---------------------------------
  def setup_battle_coords
    if $game_party.actors.size == 1
      @battle_coords_x = 480
      @battle_coords_y = 200
    end
    if $game_party.actors.size == 2
      @battle_coords_x = self.index * 40 + 460
      @battle_coords_y = self.index * 20 + 190
    end
    if $game_party.actors.size == 3
      @battle_coords_x = self.index * 40 + 440
      @battle_coords_y = self.index * 20 + 180
    end
    if $game_party.actors.size == 4
      @battle_coords_x = self.index * 40 + 420
      @battle_coords_y = self.index * 20 + 170
    end
    case $game_temp.battleback_name
    when "waste01"
      if $game_party.actors.size == 1
        @battle_coords_x = 480
        @battle_coords_y = 220
      end
      if $game_party.actors.size == 2
        @battle_coords_x = self.index * 40 + 460
        @battle_coords_y = self.index * 20 + 210
      end
      if $game_party.actors.size == 3
        @battle_coords_x = self.index * 40 + 440
        @battle_coords_y = self.index * 20 + 200
      end
      if $game_party.actors.size == 4
        @battle_coords_x = self.index * 40 + 420
        @battle_coords_y = self.index * 20 + 190
      end
     when "desert01"
      if $game_party.actors.size == 1
        @battle_coords_x = 480
        @battle_coords_y = 220
      end
      if $game_party.actors.size == 2
        @battle_coords_x = self.index * 40 + 460
        @battle_coords_y = self.index * 20 + 210
      end
      if $game_party.actors.size == 3
        @battle_coords_x = self.index * 40 + 440
        @battle_coords_y = self.index * 20 + 200
      end
      if $game_party.actors.size == 4
        @battle_coords_x = self.index * 40 + 420
        @battle_coords_y = self.index * 20 + 190
      end
     when "forest01"
      if $game_party.actors.size == 1
        @battle_coords_x = 480
        @battle_coords_y = 220
      end
      if $game_party.actors.size == 2
        @battle_coords_x = self.index * 40 + 460
        @battle_coords_y = self.index * 20 + 210
      end
      if $game_party.actors.size == 3
        @battle_coords_x = self.index * 40 + 440
        @battle_coords_y = self.index * 20 + 200
      end
      if $game_party.actors.size == 4
        @battle_coords_x = self.index * 40 + 420
        @battle_coords_y = self.index * 20 + 190
      end
    end
  end
  # -----------------------------
def get_exp_list_from_file(filename)
    begin
      if @exp_file_error
        return
      end
      f = File.open(filename)
      list = f.readlines
      list = correct_malformed_input(list)
      if @exp_file_error
        return
      end
      for i in 0..list.size - 1
        list[i] = list[i].to_i
      end
      list = correct_erroneous_data(list)
      for i in list.size..100
        list[i] = 0
      end
      list.unshift(0)
      @exp_list = list
      rescue StandardError
        s1 = "Unrecoverable error while reading " + @name + "'s EXP list.\n"
        s2 = "Experience curve declared in the database will be used instead."
        print(s1 + s2)
        @exp_file_error = true
        retry
      ensure
        if f != nil
          f.close
        end
      end
  end
# -----------------------------
def correct_malformed_input(list)
    lines_to_delete = []
    if list.size == 0
      s1 = "Warning: " + @name + "'s experience requirement file is empty.  "
      s2 = "Experience curve declared in the database will be used instead."
      print(s1 + s2)
      @exp_file_error = true
      return
    end
    for i in 0..list.size - 1
      delflag = false
      for j in 0..list[i].size - 1
        if list[i][j] != 10 && list[i][j] != 32 && 
          !(list[i][j] >= 48 && list[i][j] <= 57)
          delflag = true
        end
      end
      if list[i].size == 1 && list[i][0] == 10
        delflag = true
      end
      if delflag
        lines_to_delete.push(list[i])
      end
    end
    if lines_to_delete != []
      for i in 0..lines_to_delete.size - 1
        list.delete(lines_to_delete[i])
      end
    end
    for i in 0..list.size - 1
      while list[i].include?(32)
        list[i].slice!(0)
      end
    end
  return list
end
# -----------------------------
def correct_erroneous_data(list)
  warnings = ""
  wrong_exp = false
  if list[0] != 0
    list[0] = 0
    s1 = "Warning: " + @name + "'s experience requirement for level 1 "
    s2 = "must be zero.  Automatically correcting error.\n"
    warnings += s1 + s2
  end
  if list.size < $data_actors[@actor_id].final_level
    if list.size >= 2
      value = list[list.size - 1] - list[list.size - 2]
      for i in list.size..$data_actors[@actor_id].final_level - 1
        list[i] = list[i-1] + value
      end
    else
      list = []
      for i in 0..$data_actors[@actor_id].final_level - 1
        list[i] = i
      end
    end
      s1 = "Warning: Fewer levels than " + @name + "'s maximum level have "
      s2 = "been declared.  Creating temporary substitute values.\n"
      warnings += s1 + s2
  end
  if list.size > $data_actors[@actor_id].final_level
      new_list = []
      for i in 0..$data_actors[@actor_id].final_level - 1
        new_list[i] = list[i]
      end
      list = new_list
      s1 = "Warning: More levels than " + @name + "'s maximum level have "
      s2 = "been declared.  Ignoring excess declarations.\n"
      warnings += s1 + s2
    end
    for i in 1..list.size - 1
      if list[i] <= list[i-1]
        if i == list.size - 1 && list.size != 2
          diff = list[i-1] - list[i-2]
          list[i] = list[i-1] + diff
        elsif i == list.size - 1 && list.size == 2
          list[i] = 10
        else
          if list[i+1] > list[i-1]
            diff = list[i+1] - list[i-1]
            list[i] = list[i-1] + diff / 2
          else
            list[i] = list[i-1] + 10
          end
       end
       wrong_exp = true
    end
  end
  wrong_exp = false
  if wrong_exp
    s1 = "Warning: One or more experience requirements for " + @name + " "
    s2 = "is less than or equal to the previous level's requirement.  "
    s3 = "Creating temporary substitute values."
    warnings += s1 + s2 + s3
  end
  if warnings != ""
    print(warnings)
  end
  return list
end
# -----------------------
def setup_ai_action(enemy_initiative)
  if @ai_tactics.size > 0
    if self.fatigue >= @ai_ft_limit
      if self.exertion <= @ai_ex_limit
        unless self.restriction > 1
          unless enemy_initiative
            self.current_action.ai_action(self, @current_tactic)
          end
        end
      end
    end
  end
end
# -----------------------
def acumen
  eqp_vectors = 0
  if @armor1_id > 0
    eqp_vectors += $data_armors[@armor1_id].vector_plus
  end
  if @armor2_id > 0
    eqp_vectors += $data_armors[@armor2_id].vector_plus
  end
  if @armor3_id > 0
    eqp_vectors += $data_armors[@armor3_id].vector_plus
  end
  if @armor4_id > 0
    eqp_vectors += $data_armors[@armor4_id].vector_plus
  end
  return @level / 5 + @acumen_vectors_up + eqp_vectors
end
# -----------------------
def current_acumen
  value = acumen
  for i in 1..$data_skills.size - 1
    if $data_skills[i].occasion == 3
      if equipped_auto_abilities.include?($data_skills[i].id)
        value -= $data_skills[i].sp_cost
      end
    end
  end
  return value
end
# -----------------------
end
