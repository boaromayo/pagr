#==============================================================================
# ■ Window_ShopStatus
#------------------------------------------------------------------------------
# 　ショップ画面で、アイテムの所持数やアクターの装備を表示するウィンドウです。
#==============================================================================

class Window_ShopStatus < Window_Base
  # ---------------------------------------
  def initialize
    super(368, 128, 272, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    @item = nil
    @sprite1 = nil
    @sprite2 = nil
    @sprite3 = nil
    @sprite4 = nil
    @walk = [false, false, false, false]
    @count = 0
    @word_size = 64
    @num_size = 48
    @change = 0
    @position = 0
    @start_x = 0
    @start_y = 0
    refresh
  end
  # ---------------------------------------
  def refresh
    self.contents.clear
    if @sprite1 != nil
      @sprite1.dispose
      @sprite1 = nil
    end
    if @sprite2 != nil
      @sprite2.dispose
      @sprite2 = nil
    end
    if @sprite3 != nil
      @sprite3.dispose
      @sprite3 = nil
    end
    if @sprite4 != nil
      @sprite4.dispose
      @sprite4 = nil
    end
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    if @item == nil
      return
    end
    case @item
    when RPG::Item
      number = $game_party.item_number(@item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(@item.id)
    when RPG::Armor
      number = $game_party.armor_number(@item.id)
    end
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 200, 32, "Possessed:")
    self.contents.font.color = normal_color
    self.contents.draw_text(204, 0, 32, 32, number.to_s, 2)
    if @item.is_a?(RPG::Item)
      @walk = [false, false, false, false]
      return
    end
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if @item.is_a?(RPG::Weapon)
        item1 = $data_weapons[actor.weapon_id]
      elsif @item.kind == 0
        item1 = $data_armors[actor.armor1_id]
      elsif @item.kind == 1
        item1 = $data_armors[actor.armor2_id]
      elsif @item.kind == 2
        item1 = $data_armors[actor.armor3_id]
      else
        item1 = $data_armors[actor.armor4_id]
      end
      if not actor.equippable?(@item)
        @walk[i] = false
        draw_actor_graphic(actor, 380, 194 + 64 * i, i, 0)
        self.contents.font.name = "Arial"
        self.contents.font.size = 24
        self.contents.font.color = normal_color
        self.contents.draw_text(48, 56 + 72 * i, 150, 32, "Cannot Equip")
      end
      if actor.equippable?(@item)
        @walk[i] = true
        draw_actor_graphic(actor, 380, 194 + 64 * i, i, 1)
        @change = 0
        @position = 0
        @start_x = 0
        @start_y = 0
        atk1 = 0
        atk2 = 0
        eva1 = 0
        eva2 = 0
        str1 = 0
        str2 = 0
        dex1 = 0
        dex2 = 0
        agi1 = 0
        agi2 = 0
        int1 = 0
        int2 = 0
        pdf1 = 0
        pdf2 = 0
        mdf1 = 0
        mdf2 = 0
        eva1 = 0
        eva2 = 0
        ftr1 = 0
        ftr2 = 0
        exr1 = 0
        exr2 = 0
        str1 = item1 != nil ? item1.str_plus : 0
        str2 = @item != nil ? @item.str_plus : 0
        dex1 = item1 != nil ? item1.dex_plus : 0
        dex2 = @item != nil ? @item.dex_plus : 0
        agi1 = item1 != nil ? item1.agi_plus : 0
        agi2 = @item != nil ? @item.agi_plus : 0
        int1 = item1 != nil ? item1.int_plus : 0
        int2 = @item != nil ? @item.int_plus : 0
        pdf1 = item1 != nil ? item1.pdef : 0
        pdf2 = @item != nil ? @item.pdef : 0
        mdf1 = item1 != nil ? item1.mdef : 0
        mdf2 = @item != nil ? @item.mdef : 0
        atk1 = item1 != nil ? item1.atk : 0
        atk2 = @item != nil ? @item.atk : 0
        eva1 = item1 != nil ? item1.eva : 0
        eva2 = @item != nil ? @item.eva : 0
        ftr1 = item1 != nil ? item1.ftr_plus : 0
        ftr2 = @item != nil ? @item.ftr_plus : 0
        exr1 = item1 != nil ? item1.exr_plus : 0
        exr2 = @item != nil ? @item.exr_plus : 0
        str_change = str2 - str1
        dex_change = dex2 - dex1
        agi_change = agi2 - agi1
        int_change = int2 - int1
        pdf_change = pdf2 - pdf1
        mdf_change = mdf2 - mdf1
        atk_change = atk2 - atk1
        eva_change = eva2 - eva1
        ftr_change = ftr2 - ftr1
        exr_change = exr2 - exr1
        if str_change != 0
          @change += 1
        end
        if dex_change != 0
          @change += 1
        end
        if agi_change != 0
          @change += 1
        end
        if int_change != 0
          @change += 1
        end
        if pdf_change != 0
          @change += 1
        end
        if mdf_change != 0
          @change += 1
        end
        if atk_change != 0
          @change += 1
        end
        if eva_change != 0
          @change += 1
        end
        if ftr_change != 0
          @change += 1
        end
        if exr_change != 0
          @change += 1
        end
        determine_draw_font_size
        determine_word_size
        if item1 == nil
          name1 = ""
        else
          name1 = item1.name
        end
        if @item == nil
          name2 = ""
        else
          name2 = @item.name
        end
        if str_change == 0 && dex_change == 0 && agi_change == 0 && 
        pdf_change == 0 && mdf_change == 0 && atk_change == 0 &&
        eva_change == 0 && ftr_change == 0 && exr_change == 0 &&
        name1 != name2
          self.contents.draw_text(48, 56 + 72 * i, 150, 32, "No Change")
        end
        if name1 == name2
          self.contents.draw_text(48, 56 + 72 * i, 200, 32, "Currently Equipped")
        end
        self.contents.font.color = normal_color
        if atk_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("ATK", atk_change)
        end
        if pdf_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("DEF", pdf_change)
        end
        if mdf_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("SDF", mdf_change)
        end
        if str_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("STR", str_change)
        end
        if dex_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("DEX", dex_change)
        end
        if agi_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("AGI", agi_change)
        end
        if int_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("INT", int_change)
        end
        if eva_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("EVA", eva_change)
        end
        if ftr_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("FTR", ftr_change)
        end
        if exr_change != 0
          @position += 1
          determine_draw_coords(i)
          draw_change("EXR", exr_change)
        end
      end
    end
  end
  # ---------------------------------------
  def item=(item)
    if @item != item
      @item = item
      refresh
    end
  end
  # ---------------------------------------
  def draw_actor_graphic(actor, x, y, id, tone_id)
    if id == 0
      @v1 = Viewport.new(380, 174, 48, 64)
      @v1.z = 9998
      @sprite1 = Sprite.new(@v1)
      @sprite1.bitmap = RPG::Cache.character(actor.character_name, 
      actor.character_hue)
      if tone_id == 0
        @sprite1.tone = Tone.new(0, 0, 0, 255)
      else
        @sprite1.tone = Tone.new(0, 0, 0, 0)
      end
      @sprite1.visible = true
    end
     if id == 1
      @v2 = Viewport.new(380, 244, 48, 64)
      @v2.z = 9999
      @sprite2 = Sprite.new(@v2)
      @sprite2.bitmap = RPG::Cache.character(actor.character_name, 
      actor.character_hue)
      if tone_id == 0
        @sprite2.tone = Tone.new(0, 0, 0, 255)
      else
        @sprite2.tone = Tone.new(0, 0, 0, 0)
      end
      @sprite2.visible = true
    end
     if id == 2
      @v3 = Viewport.new(380, 316, 48, 64)
      @v3.z = 9999
      @sprite3 = Sprite.new(@v3)
      @sprite3.bitmap = RPG::Cache.character(actor.character_name, 
      actor.character_hue)
      if tone_id == 0
        @sprite3.tone = Tone.new(0, 0, 0, 255)
      else
        @sprite3.tone = Tone.new(0, 0, 0, 0)
      end
      @sprite3.visible = true
    end
    if id == 3
      @v4 = Viewport.new(380, 388, 48, 64)
      @v4.z = 9999
      @sprite4 = Sprite.new(@v4)
      @sprite4.bitmap = RPG::Cache.character(actor.character_name, 
      actor.character_hue)
      if tone_id == 0
        @sprite4.tone = Tone.new(0, 0, 0, 255)
      else
        @sprite4.tone = Tone.new(0, 0, 0, 0)
      end
      @sprite4.visible = true
    end
  end
  # ---------------------------------------
  def update
    super
    @count += 1
    for i in 0..@walk.size
        if @walk[i] == false
        case i
          when 0
            if @sprite1 != nil
            @sprite1.ox = 0
            end
          when 1
            if @sprite2 != nil
            @sprite2.ox = 0
            end
          when 2
            if @sprite3 != nil
            @sprite3.ox = 0
            end
          when 3
            if @sprite4 != nil
            @sprite4.ox = 0
            end
          end
        end
      end
    if @count == 0
      for i in 0..@walk.size
        if @walk[i] == true
        case i
        when 0
          if @sprite1 != nil
          @sprite1.ox = 0
          end
        when 1
          if @sprite2 != nil
          @sprite2.ox = 0
          end
        when 2
          if @sprite3 != nil
          @sprite3.ox = 0
          end
        when 3
          if @sprite4 != nil
          @sprite4.ox = 0
            end
          end
        end
      end
    end
    if @count == 8
      for i in 0..@walk.size
        if @walk[i] == true
        case i
        when 0
          if @sprite1 != nil
          @sprite1.ox = 48
          end
        when 1
          if @sprite2 != nil
          @sprite2.ox = 48
          end
        when 2
          if @sprite3 != nil
          @sprite3.ox = 48
          end
        when 3
          if @sprite4 != nil
          @sprite4.ox = 48
            end
          end
        end
      end
    end
    if @count == 16
      for i in 0..@walk.size
        if @walk[i] == true
          case i
        when 0
          if @sprite1 != nil
          @sprite1.ox = 144
          end
        when 1
          if @sprite2 != nil
          @sprite2.ox = 144
          end
        when 2
          if @sprite3 != nil
          @sprite3.ox = 144
          end
        when 3
          if @sprite4 != nil
          @sprite4.ox = 144
            end
          end
        end
      end
    end
    if @count == 24
      @count = -1
    end
  end
  # ---------------------------------------
  def determine_draw_coords(i)
    if @change == 1
      @start_x = 48
      @start_y = 52 + 64 * i
    end
    if @change == 2
      @start_x = 48
      if @position == 1
        @start_y = 48 + 72 * i
      end
      if @position == 2
        @start_y = 72 + 72 * i
      end
    end
    if @change == 3
      @start_x = 48
      if @position == 1
        @start_y = 48 + 72 * i
      end
      if @position == 2
        @start_y = 64 + 72 * i
      end
      if @position == 3
        @start_y = 80 + 72 * i
      end
    end
    if @change >= 4
      if @change <= 6
        if @position / 4 == 0
          @start_x = 48
        else
          @start_x = 148
        end
        @start_y = 48 + 72 * i
        if @position <= 3
          @start_y += (@position - 1) * 16
        end
        if @position >= 4
          @start_y += (@position - 4) * 16
        end
      end
    end
    if @change == 7 or @change == 8
      if @position / 5 == 0
        @start_x = 48
      else
        @start_x = 128
      end
      @start_y = 48 + 72 * i
      if @position <= 4
        @start_y += (@position - 1) * 12
      end
      if @position >= 5
        @start_y += (@position - 5) * 12
      end
    end
    if @change == 9 or @change == 10
      if @position / 6 == 0
        @start_x = 48
      else
        @start_x = 128
      end
      @start_y = 48 + 72 * i
      if @position <= 5
        @start_y += (@position - 1) * 12
      end
      if @position >= 6
        @start_y += (@position - 6) * 12
      end
    end
  end
  # ---------------------------------------
  def determine_word_size
    if @change <= 2
      @word_size = 44
      @num_size = 32
    end
    if @change >= 3
      if @change <= 6
        @word_size = 44
        @num_size = 24
      end
    end
    if @change >= 7
      @word_size = 24
      @num_size = 16
    end
  end
  # ---------------------------------------
  def determine_draw_font_size
    if @change <= 2
      self.contents.font.size = 24
    end
    if @change >= 3
      if @change <= 6
        self.contents.font.size = 16
      end
    end
    if @change >= 7
      self.contents.font.size = 12
    end
  end
  # ---------------------------------------
  def draw_change(stat, change)
    c = change.to_s
    draw_sign = @start_x + @word_size + 4
    draw_value = @start_x + @word_size + 24
    height = self.contents.font.size
    self.contents.font.color = normal_color
    self.contents.draw_text(@start_x, @start_y, @word_size, height, stat)
    if change < 0
      self.contents.font.color = down_color
      self.contents.draw_text(draw_sign, @start_y, 12, height, "-")
      c = change.abs.to_s
    end
    if change > 0
      self.contents.font.color = up_color
      self.contents.draw_text(draw_sign, @start_y, 12, height, "+")
    end
    self.contents.draw_text(draw_value, @start_y, @num_size, height, c)
  end
  # ---------------------------------------
  def clear
    @item = nil
  end
  # ---------------------------------------
end
