class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 128, 640, 352)
    @actor = actor
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 320
      self.z = 1020
      self.height = 160
      self.back_opacity = 255
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルの取得
  #--------------------------------------------------------------------------
  def skill
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    if $game_temp.in_battle
      for i in 0...@actor.skills.size
        skill = $data_skills[@actor.skills[i]]
        a = skill != nil
        b = skill.shaping_ability?
        c = skill.occasion == 0
        d = skill.occasion == 1
        if a and b and c or d
          @data.push(skill)
        end
      end
    else
      for i in 0...@actor.skills.size
        skill = $data_skills[@actor.skills[i]]
        if $scene.mode == 0
          if skill != nil && skill.shaping_ability?
            @data.push(skill)
          end
        end
        if $scene.mode == 1
          if skill != nil && skill.command_ability?
            @data.push(skill)
          end
        end
        if $scene.mode == 2
          if skill != nil && skill.auto_ability?
            @data.push(skill)
          end
        end
      end
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      self.contents.font.name = "Arial"
      self.contents.font.size = 24
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if $game_temp.in_battle
      if @actor.skill_can_use?(skill.id)
        self.contents.font.color = normal_color
      else
        self.contents.font.color = disabled_color
      end
    else
      if $scene.mode == 0
        if @actor.skill_can_use?(skill.id)
          self.contents.font.color = normal_color
        else
          self.contents.font.color = disabled_color
        end
      end
      if $scene.mode == 1
        if @actor.battle_commands.include?(skill.name)
          self.contents.font.color = normal_color
        else
          self.contents.font.color = disabled_color
        end
      end
      if $scene.mode == 2
        if @actor.equipped_auto_abilities.include?(skill.id)
          self.contents.font.color = normal_color
        else
          self.contents.font.color = disabled_color
        end
      end
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    if $game_temp.in_battle
      if @actor.extract_effect
        s = (skill.sp_cost / 2).to_s + "/0"
      else
        s = skill.sp_cost.to_s + "/" + skill.drain.to_s
      end
      self.contents.draw_text(x + 232, y, 48, 32, s, 2)
    else
      if $scene.mode == 0
        s = (skill.sp_cost / 2).to_s + "/" + skill.drain.to_s
        self.contents.draw_text(x + 232, y, 48, 32, s)
      end
      if $scene.mode == 2
        s = skill.sp_cost.to_s
        self.contents.draw_text(x + 264, y, 48, 32, s)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.skill == nil ? "" : self.skill.description)
  end
end
