class Window_VessMain < Window_Selectable
#-----------------------------
  def initialize
    super(0, 64, 640, 320)
    @column_max = 2
    refresh
    self.index = 0
  end
#-----------------------------
  def item
    return @data[self.index]
  end
#-----------------------------
  def refresh
    actor = $game_actors[8]
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    for i in 1...$data_weapons.size
      if $data_weapons[i].ap_needed >= 0
        eqp = actor.weapon_id == i
        have = $game_party.weapon_number(i) >= 1
        ap = $game_system.current_ap_weapon[i] > 0
        if have or ap or eqp
          @data.push($data_weapons[i])
        end
      end
    end
    for i in 1...$data_armors.size
      if $data_armors[i].ap_needed >= 0
        eqp = false
        eqp |= actor.armor1_id == i
        eqp |= actor.armor2_id == i
        eqp |= actor.armor3_id == i
        eqp |= actor.armor4_id == i
        have = $game_party.armor_number(i) >= 1
        ap = $game_system.current_ap_armor[i] > 0
        if have or ap or eqp
          @data.push($data_armors[i])
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
#-----------------------------
  def draw_item(index)
    item = @data[index]
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.font.color = normal_color
    self.contents.font.size = 24
    if @data[index].is_a?(RPG::Weapon)
      ap = $game_system.current_ap_weapon[@data[index].id]
      ap_need = $data_weapons[@data[index].id].ap_needed
      if ap > 900000
        self.contents.font.color = disabled_color
      end
    end
    if @data[index].is_a?(RPG::Armor)
      ap = $game_system.current_ap_armor[@data[index].id]
      ap_need = $data_armors[@data[index].id].ap_needed
      if ap > 900000
        self.contents.font.color = disabled_color
      end
    end
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    draw_item_ap_bar(x + 28, y + 29, 255, index)
    self.contents.font.color = normal_color
    self.contents.font.size = 14
    ap_string = ap.to_s + "/" + ap_need.to_s
    if ap < 900000
      self.contents.draw_text(x + 210, y + 21, 100, 14, ap_string, 1)
    else
      self.contents.draw_text(x + 210, y + 21, 100, 14, "Learned", 1)
    end
  end
#-----------------------------
  def draw_item_ap_bar(x, y, length, index)
    self.contents.fill_rect(x, y, length, 3, Color.new(0, 0, 0, 96))
    gradient1_red_start = 255
    gradient1_red_end = 255
    gradient1_green_start = 159
    gradient1_green_end = 0
    gradient1_blue_start = 255
    gradient1_blue_end = 0
    gradient2_red_start = 90
    gradient2_red_end = 0
    gradient2_green_start = 226
    gradient2_green_end = 146
    gradient2_blue_start = 82
    gradient2_blue_end = 42
    if @data[index].is_a?(RPG::Weapon)
      current = $game_system.current_ap_weapon[@data[index].id]
      need = $data_weapons[@data[index].id].ap_needed
    end
    if @data[index].is_a?(RPG::Armor)
      current = $game_system.current_ap_armor[@data[index].id]
      need = $data_armors[@data[index].id].ap_needed
    end
    if current > 900000
      current -= 900000
    end
    draw_bar_percent = current * 100 / need
    if current == 0
      draw_bar_percent = -1
    end
    if draw_bar_percent > 200
      draw_bar_percent = 200
    end
    for x_coord in 1..length
      current_percent_done = x_coord * 100 / length
      if draw_bar_percent - current_percent_done > 100
        difference = gradient2_red_end - gradient2_red_start
        red = gradient2_red_start + difference * x_coord / length
        difference = gradient2_green_end - gradient2_green_start
        green = gradient2_green_start + difference * x_coord / length
        difference = gradient2_blue_end - gradient2_blue_start
        blue = gradient2_blue_start + difference * x_coord / length
      else
        difference = gradient1_red_end - gradient1_red_start
        red = gradient1_red_start + difference * x_coord / length
        difference = gradient1_green_end - gradient1_green_start
        green = gradient1_green_start + difference * x_coord / length
        difference = gradient1_blue_end - gradient1_blue_start
        blue = gradient1_blue_start + difference * x_coord / length
      end
      if current_percent_done <= draw_bar_percent
        if current_percent_done < 100
          rect = Rect.new(x + x_coord-1, y, 1, 3)
          self.contents.fill_rect(rect, Color.new(red, green, blue, 255))
        end
      end
    end
  end
#-----------------------------
end
