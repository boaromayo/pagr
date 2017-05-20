#==============================================================================
# ■ Window_Target
#------------------------------------------------------------------------------
# 　アイテム画面とスキル画面で、使用対象のアクターを選択するウィンドウです。
#==============================================================================

class Window_Target < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 640, 256)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z += 10
    @viewports = []
    @faces = []
    for i in 0..$game_party.actors.size - 1
      actor_num = $game_party.actors[i].id
      filename = "Graphics/Face/face" + actor_num.to_s + ".png"
      if i % 2 == 0
        x_pos = 8
      else
        x_pos = 322
      end
      if i < 2
        y_pos = 80
      else
        y_pos = 196
      end
      @viewports[i] = Viewport.new(x_pos, y_pos, 96, 96)
      @viewports[i].z = 975
      @faces[i] = Sprite.new(@viewports[i])
      @faces[i].bitmap = Bitmap.new(filename)
      @faces[i].opacity = 255
      @faces[i].visible = true
      if $game_party.actors[i].dead?
        @faces[i].tone = Tone.new(0, 0, 0, 255)
      end
    end
    @column_max = 2
    @item_max = $game_party.actors.size
    refresh
  end
  # ----------------------------
  def set_sprites
    if self.visible
      for sprite in @faces
        sprite.opacity = 255
      end
      for i in 0..$game_party.actors.size - 1
        if $game_party.actors[i].dead?
          @faces[i].tone = Tone.new(0, 0, 0, 255)
        else
          @faces[i].tone = Tone.new(0, 0, 0, 0)
        end
      end
    else
      for sprite in @faces
        sprite.opacity = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    for i in 0...$game_party.actors.size
      if i % 2 == 0
        x = 100
      else
        x = 414
      end
      if i < 2
        y = 0
      else
        y = 116
      end
      actor = $game_party.actors[i]
      draw_actor_name(actor, x, y)
      draw_actor_state(actor, x + 80, y)
      hp = $game_party.actors[i].hp.to_s
      max = $game_party.actors[i].maxhp.to_s
      ft = $game_party.actors[i].fatigue.to_s
      en = $game_party.actors[i].energy.to_s + "%"
      self.contents.font.color = system_color
      self.contents.draw_text(x, y + 32, 32, 32, "HP")
      self.contents.font.color = normal_color
      if $game_party.actors[i].hp <= $game_party.actors[i].maxhp / 4
        self.contents.font.color = crisis_color
      end
      if $game_party.actors[i].hp == 0
        self.contents.font.color = knockout_color
      end
      self.contents.draw_text(x + 40, y + 32, 64, 32, hp, 2)
      self.contents.font.color = normal_color
      self.contents.draw_text(x + 104, y + 32, 12, 32, "/")
      self.contents.draw_text(x + 116, y + 32, 64, 32, max, 2)
      if $scene.is_a?(Scene_Skill)
        self.contents.font.color = system_color
        self.contents.draw_text(x, y + 64, 32, 32, "FT")
        self.contents.font.color = normal_color
        if $game_party.actors[i].fatigue <= -50
          self.contents.font.color = crisis_color
        end
        if $game_party.actors[i].fatigue <= -100
          self.contents.font.color = knockout_color
        end
        self.contents.draw_text(x + 10, y + 64, 64, 32, ft, 2)
        self.contents.font.color = system_color
        self.contents.draw_text(x + 80, y + 64, 32, 32, "EN")
        self.contents.font.color = normal_color
        if $game_party.actors[i].energy <= 50
          self.contents.font.color = crisis_color
        end
        if $game_party.actors[i].energy == 0
          self.contents.font.color = knockout_color
        end
        self.contents.draw_text(x + 115, y + 64, 64, 32, en, 2)
      else
        self.contents.font.color = system_color
        self.contents.draw_text(x, y + 64, 32, 32, "FT")
        self.contents.font.color = normal_color
        if $game_party.actors[i].fatigue <= -50
          self.contents.font.color = crisis_color
        end
        if $game_party.actors[i].fatigue <= -100
          self.contents.font.color = knockout_color
        end
        self.contents.draw_text(x + 40, y + 64, 140, 32, ft, 2)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの矩形更新
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index <= -2
      self.cursor_rect.set(0, (@index + 10) * 116, self.width - 32, 96)
    elsif @index == -1
      self.cursor_rect.set(0, 0, self.width - 32, self.height - 32)
    elsif @index == 0
      self.cursor_rect.set(0, 0, 302, 96)
    elsif @index == 1
      self.cursor_rect.set(304, 0, 302, 96)
    elsif @index == 2
      self.cursor_rect.set(0, 116, 302, 96)
    elsif @index == 3
      self.cursor_rect.set(304, 116, 302, 96)
    end
  end
  # -----------------------
  def dispose
    super
    for i in 0..$game_party.actors.size - 1
      @faces[i].dispose
      @viewports[i].dispose
    end
  end
end
