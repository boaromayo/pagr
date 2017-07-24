#==============================================================================
# ■ Scene_Skill
#------------------------------------------------------------------------------
# 　スキル画面の処理を行うクラスです。
#==============================================================================

class Scene_Skill
  #--------------------------------
  attr_accessor :mode
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_index : アクターインデックス
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, equip_index = 0)
    @actor_index = actor_index
    @mode = 0
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    alert_text = "You must equip at least one battle command."
    @actor = $game_party.actors[@actor_index]
    @help_window = Window_Help.new
    @status_window = Window_SkillStatus.new(@actor)
    @skill_window = Window_Skill.new(@actor)
    @skill_window.help_window = @help_window
    @target_window = Window_Target.new
    @target_window.visible = false
    @target_window.active = false
    @target_window.set_sprites
    @vector_window = Window_Vector.new(@actor)
    @vector_window.visible = false
    @vector_window.z = 3000
    @alert_window = Window_Base.new(120, 208, 400, 64)
    @alert_window.contents = Bitmap.new(368, 32)
    @alert_window.contents.font.name = "Arial"
    @alert_window.contents.font.size = 24
    @alert_window.contents.draw_text(4, 0, 368, 32, alert_text)
    @alert_window.visible = false
    @alert_window.z = 9999
    @alert_delay = -1
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @help_window.dispose
    @status_window.dispose
    @skill_window.dispose
    @target_window.dispose
    @vector_window.dispose
    @alert_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    $game_system.menu_encounters
    @help_window.update
    @status_window.update
    @skill_window.update
    @target_window.update
    @vector_window.update
    if @skill_window.active
      update_skill
      return
    end
    if @target_window.active
      update_target
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (スキルウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_skill
    if @alert_delay > 0
      @alert_delay -= 1
      return
    end
    if @alert_delay == 0
      @alert_window.visible = false
      @alert_delay = -1
    end
    if Input.trigger?(Input::B)
      if @actor.battle_commands.size == 0
        $game_system.se_play($data_system.buzzer_se)
        @alert_window.visible = true
        @alert_delay = 60
      else
        $game_system.se_play($data_system.cancel_se)
        $scene = Scene_Menu.new(1)
      end
      return
    end
    if Input.trigger?(Input::C)
      @skill = @skill_window.skill
      if @mode == 0
        if @skill == nil or not @actor.skill_can_use?(@skill.id)
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        if @skill.scope >= 3
          @skill_window.active = false
          @target_window.visible = true
          @target_window.active = true
          @target_window.set_sprites
          if @skill.scope == 4 || @skill.scope == 6
            @target_window.index = -1
          elsif @skill.scope == 7
            @target_window.index = @actor_index - 10
          else
            @target_window.index = 0
          end
        else
          if @skill.common_event_id > 0
            $game_temp.common_event_id = @skill.common_event_id
            $game_system.se_play(@skill.menu_se)
            @actor.fatigue -= @skill.sp_cost / 2
            @actor.energy -= @skill.drain
            @status_window.refresh
            @skill_window.refresh
            @target_window.refresh
            $scene = Scene_Map.new
            return
          end
        end
        return
      end
      if @mode == 1
        if @skill == nil
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        if @actor.battle_commands.size == 8
          if not @actor.battle_commands.include?(@skill.name)
            $game_system.se_play($data_system.buzzer_se)
            return
          end
        end
        if @actor.battle_commands.include?(@skill.name)
          $game_system.se_play($data_system.equip_se)
          @actor.battle_commands.delete(@skill.name)
          @skill_window.refresh
          return
        end
        if not @actor.battle_commands.include?(@skill.name)
          $game_system.se_play($data_system.equip_se)
          @actor.battle_commands.push(@skill.name)
          @skill_window.refresh
          return
        end
      end
      if @mode == 2
        if @skill_window.skill != nil
          if @actor.equipped_auto_abilities.include?(@skill.id)
            $game_system.se_play($data_system.equip_se)
            @actor.equipped_auto_abilities.delete(@skill.id)
            @skill_window.refresh
            @vector_window.refresh
          else
            if @actor.current_acumen < @skill.sp_cost
              $game_system.se_play($data_system.buzzer_se)
            else
              $game_system.se_play($data_system.equip_se)
              @actor.equipped_auto_abilities.push(@skill.id)
              @skill_window.refresh
              @vector_window.refresh
            end
          end
        else
          $game_system.se_play($data_system.buzzer_se)
        end
        return
      end
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @mode += 1
      @mode %= 3
      if @mode == 2
        @vector_window.visible = true
      else
        @vector_window.visible = false
      end
      @status_window.refresh
      @skill_window.refresh
      @skill_window.index = 0
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @mode -= 1
      @mode %= 3
      if @mode == 2
        @vector_window.visible = true
      else
        @vector_window.visible = false
      end
      @status_window.refresh
      @skill_window.refresh
      @skill_window.index = 0
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ターゲットウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_target
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      @skill_window.active = true
      @target_window.visible = false
      @target_window.active = false
      @target_window.set_sprites
      return
    end
    if Input.trigger?(Input::C)
      unless @actor.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      if @target_window.index == -1
        used = false
        for i in $game_party.actors
          used |= i.skill_effect(@actor, @skill)
        end
      end
      if @target_window.index <= -2
        target = $game_party.actors[@target_window.index + 10]
        used = target.skill_effect(@actor, @skill)
      end
      if @target_window.index >= 0
        target = $game_party.actors[@target_window.index]
        used = target.skill_effect(@actor, @skill)
      end
      if used
        $game_system.se_play(@skill.menu_se)
        @actor.fatigue -= @skill.sp_cost / 2
        @actor.energy -= @skill.drain
        @status_window.refresh
        @skill_window.refresh
        @target_window.refresh
        unless @actor.skill_can_use?(@skill.id)
          @skill_window.active = true
          @target_window.visible = false
          @target_window.active = false
          @target_window.set_sprites
        end
        if $game_party.all_dead?
          $scene = Scene_Gameover.new
          return
        end
        if @skill.common_event_id > 0
          $game_temp.common_event_id = @skill.common_event_id
          $scene = Scene_Map.new
          return
        end
      end
      unless used
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
end