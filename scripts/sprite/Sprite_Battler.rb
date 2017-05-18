#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #     battler  : バトラー (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @damage_delay = -1
    @frame = 0
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @frame += 1
    if @damage_delay > 0
      @damage_delay -= 1
    end
    if @damage_delay == 0
      @battler.damage_pop = true
    end
    if @battler == nil
      self.bitmap = nil
      loop_animation(nil)
      return
    end
    t1 = Tone.new(255, 255, 255, 0)
    t2 = Tone.new(-175, -175, -175, 0)
    t3 = Tone.new(0, 0, 0, 0)
    if @battler.is_a?(Game_Actor)
      if @battler.battler_hue == 360
        self.mirror = true
      end
    end
    if @battler.invincible_frames >= 0 && Graphics.frame_count % 3 == 0
      self.tone = t1
    elsif @battler.isolate
      self.tone = t2
    else
      self.tone = t3
    end
    if @battler.untargetable_frames >= 0
      unless @battler.dead? or @battler.hidden
        self.opacity = 128
      else
        self.opacity = 255
      end
    end
    if @battler.is_a?(Game_Enemy) and @battler.flying
      if @battler.flying_displacement_increasing
        @battler.flying_displacement += 1
        if @battler.flying_displacement == 50
          @battler.flying_displacement_increasing = false
        end
      else
        @battler.flying_displacement -= 1
        if @battler.flying_displacement == -50
          @battler.flying_displacement_increasing = true
        end
      end
    end
    if @battler.battler_name != @battler_name or
       @battler.battler_hue != @battler_hue
      @battler_name = @battler.battler_name
      @battler_hue = @battler.battler_hue
      self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
      @width = bitmap.width
      @height = bitmap.height
      self.ox = @width / 2
      self.oy = @height
      if @battler.dead? or @battler.hidden
        self.opacity = 0
      end
    end
    if @battler.damage == nil and
       @battler.state_animation_id(@frame) != @state_animation_id
      @state_animation_id = @battler.state_animation_id(@frame)
      loop_animation($data_animations[@state_animation_id])
    end
    if @battler.blink
      blink_on
    else
      blink_off
    end
    unless @battler_visible
      if not @battler.hidden and not @battler.dead? and
         (@battler.damage == nil or @battler.damage_pop)
        appear
        @battler_visible = true
      end
    end
    if @battler_visible
      if @battler.hidden
        escape
        @battler_visible = false
      end
      if @battler.white_flash
        whiten
        @battler.white_flash = false
      end
      if @battler.animation_id != 0
        animation = $data_animations[@battler.animation_id]
        animation(animation, @battler.animation_hit)
        @battler.animation_id = 0
      end
      if @battler.damage_pop
        first_damage = 0
        if @battler.hp_shield_damage != nil
          if @battler.hp_shield_damage != "[0]"
            @battler.damage = nil
          end
          first_damage = 5
          dmg = @battler.hp_shield_damage
          @battler.hp_shield_damage = nil
        else
          if @battler.damage != nil && @battler.damage != ""
            first_damage = 1
            dmg = @battler.damage
            @battler.damage = nil
          elsif @battler.fatigue_damage != nil
            first_damage = 2
            dmg = "_" + @battler.fatigue_damage.to_s
            @battler.fatigue_damage = nil
          elsif @battler.exertion_damage != nil
            first_damage = 3
            dmg = "!" + @battler.exertion_damage.to_s
            @battler.exertion_damage = nil
          elsif @battler.energy_damage != nil
            first_damage = 4
            dmg = "^" + @battler.energy_damage.to_s
            @battler.energy_damage = nil
          else
            first_damage = 0
          end
        end
        if first_damage > 0
          damage(dmg, @battler.critical)
        end
        if @battler.damage == ""
          @battler.damage = nil
        end
        a = @battler.damage != nil
        b = @battler.fatigue_damage != nil
        c = @battler.exertion_damage != nil
        d = @battler.energy_damage != nil
        e = @battler.hp_shield_damage != nil
        if a || b || c || d || e
          @damage_delay = 40
        else
          @damage_delay = -1
        end
        if @battler.damage == nil
          if @battler.fatigue_damage == nil
            if @battler.exertion_damage == nil
              if @battler_hp_shield_damage == nil
                if @battler_energy_damage == nil
                  if @battler.new_states.size > 0
                    @battler.damage = @battler.new_states.shift
                    @battler.damage += "!"
                    @damage_delay = 40
                  end
                end
              end
            end
          end
        end
        @battler.critical = false
        @battler.damage_pop = false
      end
      if @battler.damage == nil and @battler.dead?
        if @battler.is_a?(Game_Enemy)
          $game_system.se_play($data_system.enemy_collapse_se)
        else
          $game_system.se_play($data_system.actor_collapse_se)
        end
        collapse
        @battler_visible = false
      end
    end
    self.x = @battler.screen_x
    self.y = @battler.screen_y
    self.z = @battler.screen_z
  end
end
