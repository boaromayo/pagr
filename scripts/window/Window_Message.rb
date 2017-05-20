#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Selectable
# ------------------------------------
  def initialize
    super(64, 304, 512, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = false
    self.z = 9998
    @update_text = true
    @fade_in = false
    @fade_out = false
    @contents_showing = false
    @cursor_width = 0
    @lineheight = 32
    @speed = 1
    @speed_frames = 1
    @pause_frames = -1
    @choice_move = false
    @instant_show = false
    @endmessageclose = false
    self.active = false
    self.index = -1
  end
# ------------------------------------
  def dispose
    terminate_message
    super
    $game_temp.message_window_showing = false
    if @input_number_window != nil
      @input_number_window.dispose
    end
  end
# ------------------------------------
  def terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    self.contents.clear
    @speed = 1
    @speed_frames = 1
    @pause_frames = -1
    @instant_show = false
    @update_text = true
    @lineheight = 32
    @contents_showing = false
    @endmessageclose = false
    if $game_temp.message_proc != nil
      $game_temp.message_proc.call
    end
    $game_temp.message_text = nil
    $game_temp.message_proc = nil
    $game_temp.choice_start = 99
    $game_temp.choice_max = 0
    $game_temp.choice_cancel_type = 0
    $game_temp.choice_proc = nil
    $game_temp.num_input_start = 99
    $game_temp.num_input_variable_id = 0
    $game_temp.num_input_digits_max = 0
    if @gold_window != nil
      @gold_window.dispose
      @gold_window = nil
    end
    if @namewin != nil
      @namewin.dispose
      @namewin = nil
    end
    if @tetrawin != nil
      @tetrawin.dispose
      @tetrawin = nil
    end
  end
# ------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    self.contents.font.color = normal_color
    @x = 0
    @y = 0
    @cursor_width = 0
    if $game_temp.choice_start == 0
      @x = 8
    end
    if $game_temp.message_text != nil
      @text = $game_temp.message_text
      begin
        last_text = @text.clone
        @text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until @text == last_text
      @text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      @text.gsub!(/\\\\/) { "\000" }
      @text.gsub!(/\\[Cc]\[([0123456789ABCDEFx]+)\]/) { "\001[#{$1}]" }
      @text.gsub!(/\\[Gg]/) { "\002" }
      @text.gsub!(/\\[Ii]\[([0-9]+)\]/) { "\003[#{$1}]" }
      @text.gsub!(/\\[Ff]\[([0-9]+)\]/) { "\004[#{$1}]" }
      @text.gsub!(/\\[Ww]\[([0-9]+)\]/) { "\014[#{$1}]" }
      @text.gsub!(/\\[Mm]\[([0-9]+)\]/) { "\015[#{$1}]" }
      @text.gsub!(/\\[Ee]/) { "\016" }
      @text.gsub!(/\\[Qq]/) { "\017" }
      @text.gsub!(/\\[Kk]\[([0-9]+)\]/) { "\022[#{$1}]" }
      @text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\023[#{$1}]" }
      @text.gsub!(/\\[Tt]\[([0-9]+)\]/) { "\024[#{$1}]" }
      @text.gsub!(/\\[Pp]\[([0-9]+)\]/) { "\025[#{$1}]" }
      @text.gsub!(/\\[Xx]\[([0-9A-Za-z'"!@$%^&*().,? ]+)\]/) { "\027[#{$1}]" }
      @text.gsub!(/\\[Bb]/) { "\026" }
      @text.gsub!(/\\[Zz]\[([0-9]+)\]/) { "\030[#{$1}]" }
    end
  end
# ------------------------------------
  def reset_window
    if $game_temp.in_battle
      self.y = 16
    else
      case $game_system.message_position
      when 0
        self.y = 16
      when 1
        self.y = 160
      when 2
        self.y = 304
      end
    end
    if $game_system.message_frame == 0
      self.opacity = 255
    else
      self.opacity = 0
    end
    self.back_opacity = 160
  end
# ------------------------------------
  def update_text
    if @text != nil
      while ((c = @text.slice!(/./m)) != nil)
        if c == "\000"
          c = "\\"
        end
        if c == "\001"
          @text.sub!(/\[([0123456789ABCDEFx]+)\]/, "")
          temp_color = $1
          color = temp_color.to_i
          leading_x = temp_color.to_s.slice!(/./m)
          if leading_x == "x"
            self.contents.font.color = hex_color(temp_color)
            next
          end
          if color >= 0 and color <= 7
            self.contents.font.color = text_color(color)
          end
          next
        end
        if c == "\002"
          if @gold_window == nil
            @gold_window = Window_Gold.new(404, self.y - 34)
            if $game_temp.in_battle
              @gold_window.y = 192
            end
          end
          next
        end
          if c == "\003"
          @text.sub!(/\[([0-9]+)\]/, "")
          item_sub = $1.to_i
          c = $data_items[item_sub].name
          l = self.contents.text_size(c).width
          draw_item_name($data_items[item_sub], @x, @y * 32)
          @x = @x + l + 24
          next
        end
         if c == "\004"
          @text.sub!(/\[([0-9]+)\]/, "")
          fontize = $1.to_i
          case fontize
            when 1 
              self.contents.font.name = "Arial"
            when 2 
              self.contents.font.name = "High Tower Text"
            when 3 
              self.contents.font.name = "Tw Cen MT"
            when 4 
              self.contents.font.name = "Tahoma"
            when 5
              self.contents.font.name = "MS PGothic"
          end
          next
        end
        if c == "\014"
          @text.sub!(/\[([0-9]+)\]/, "")
          w_sub = $1.to_i
          c = $data_weapons[w_sub].name
          l = self.contents.text_size(c).width
          bitmap = RPG::Cache.icon($data_weapons[w_sub].icon_name)
          self.contents.blt(@x+4, @y * 32+ 4, bitmap, Rect.new(0, 0, 24, 24))
          @x += 28
          self.contents.draw_text(@x+4, 30 * @y, l+32, @lineheight, c)
          @x = @x + l
          next
        end
        if c == "\015"
          @text.sub!(/\[([0-9]+)\]/, "")
          a_sub = $1.to_i
          c = $data_armors[a_sub].name
          l = self.contents.text_size(c).width
          bitmap = RPG::Cache.icon($data_armors[a_sub].icon_name)
          self.contents.blt(@x+4, @y * 32+ 4, bitmap, Rect.new(0, 0, 24, 24))
          @x += 28
          self.contents.draw_text(@x+4, 30 * @y, l+32, @lineheight, c)
          @x = @x + l
          next
        end
        if c == "\016"
          @endmessageclose = true
          next
        end
        if c == "\017"
          @tetrawin = Window_TetraRemain.new(456, self.y - 32)
          @tetrawin.visible = true
          next
        end
        if c == "\022"
          @text.sub!(/\[([0-9]+)\]/, "")
          skill_sub = $1.to_i
          c = $data_skills[skill_sub].name
          l = self.contents.text_size(c).width
          bitmap = RPG::Cache.icon($data_skills[skill_sub].icon_name)
          self.contents.blt(@x+4, @y * 32+ 4, bitmap, Rect.new(0, 0, 24, 24))
          @x += 28
          self.contents.draw_text(@x+4, 30 * @y, l+32, @lineheight, c)
          @x = @x + l
          next
        end
        if c == "\023"
          @text.sub!(/\[([0-9]+)\]/, "")
          bigness = $1.to_i
          self.contents.font.size = bigness
          next
        end
        if c == "\024"
          @text.sub!(/\[([0-9]+)\]/, "")
          @speed = $1.to_i
          @speed_frames = @speed
          next
        end
        if c == "\025"
          @text.sub!(/\[([0-9]+)\]/, "")
          @pause_frames = $1.to_i
          next
        end
        if c == "\026"
          if @instant_show == true
            @instant_show = false
          else
            @instant_show = true
          end
          next
        end
        if c == "\027"
          @text.sub!(/\[([0-9A-Za-z"'!@$%^&*().,? ]+)\]/, "")
          @namewin = Window_SpeakerName.new($1.to_s, 85, self.y - 24)
          @namewin.visible = true
          if $game_temp.choice_start < 99
            $game_temp.choice_start -= 1
            @choice_move = false
          end
          next
        end
        if c == "\030"
          @text.sub!(/\[([0-9]+)\]/, "")
          icon_num = $1.to_i
          shift = 0
          case icon_num
          when 1
            filename = "talk01"
            shift = 28
          when 2
            filename = "talk02"
            shift = 16
          when 3
            filename = "jewel01"
            shift = 28
          when 4
            filename = "jewel02"
            shift = 28
          when 5
            filename = "jewel03"
            shift = 28
          when 6
            filename = "jewel04"
            shift = 28
          when 7
            filename = "label01"
            shift = 24
          when 8
            filename = "label02"
            shift = 24
          when 9
            filename = "label03"
            shift = 24
          when 10
            filename = "label04"
            shift = 24
          when 11
            filename = "label05"
            shift = 24
          when 12
            filename = "label06"
            shift = 24
          when 13
            filename = "talk03"
            shift = 24
          when 14
            filename = "talk04"
            shift = 24
          when 15
            filename = "cmd01"
            shift = 24
          when 16
            filename = "cmd02"
            shift = 24
          when 17
            filename = "talk05"
            shift = 24
          when 18
            filename = "talk07"
            shift = 24
          when 19
            filename = "talk08"
            shift = 24
          when 20
            filename = "talk09"
            shift = 24
          when 21
            filename = "talk10"
            shift = 24
          when 22
            filename = "talk11"
            shift = 24
          when 23
            filename = "talk12"
            shift = 24
          when 24
            filename = "talk06"
            shift = 24
          when 25
            filename = "misc09"
            shift = 24
          when 26
            filename = "cmd03"
            shift = 24
          end
          icon = RPG::Cache.icon(filename)
          self.contents.blt(@x+4, @y * 30 + 4, icon, Rect.new(0, 0, 24, 24))
          @x += shift
          next
        end
        if c == "\n"
          if @y >= $game_temp.choice_start
            @cursor_width = [@cursor_width, @x].max
          end
          if @choice_move
            @y += 1
          else
            @choice_move = true
          end
          @x = 0
          if @y >= $game_temp.choice_start
            @x = 8
          end
          next
        end
        self.contents.draw_text(4 + @x, 30 * @y, 40, @lineheight, c)
        @x += self.contents.text_size(c).width
        return
      end
    end
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
      self.active = true
      self.index = 0
    end
    if $game_temp.num_input_variable_id > 0
      if @input_number_window != nil
        @input_number_window.dispose
      end
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.x = self.x + 8
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
    @update_text = false
  end
# ------------------------------------
  def update
    super
    if $game_system.map_message_type == 2
      @instant_show = true
    end
    if $game_temp.choice_start == 99
      @choice_move = true
    end
    if @fade_in
      self.contents_opacity = 255
      if @input_number_window != nil
        @input_number_window.contents_opacity = 255
      end
      if self.contents_opacity == 255
        @fade_in = false
      end
    end
    if @input_number_window != nil
      @input_number_window.update
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] =
          @input_number_window.number
        $game_map.need_refresh = true
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
      end
      return
    end
    if @contents_showing
      if @update_text
        if @pause_frames > 0
          @pause_frames -= 1
          return
        end
        if $game_system.map_message_type == 0
          @speed_frames -= 2
        end
        if $game_system.map_message_type == 1
          @speed_frames -= 1
        end
        if @speed_frames == -1
          @speed_frames = @speed
          update_text
          update_text
        end
        if @speed_frames == 0 || @instant_show
          @speed_frames = @speed
          update_text
          if @instant_show
            while @instant_show && @update_text
              update_text
            end
          end
          return
        else
          return
        end
      end
      if $game_temp.choice_max == 0
        self.pause = true
      end
      if @endmessageclose && self.pause
        terminate_message
      end
      if self.pause == true && Input.dir4 != 0
        terminate_message
      end
      if Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
          $game_system.se_play($data_system.cancel_se)
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          terminate_message
        end
        terminate_message if self.pause == true
      end
      if Input.trigger?(Input::C)
        if $game_temp.choice_max > 0
          $game_system.se_play($data_system.decision_se)
          $game_temp.choice_proc.call(self.index)
        end
        terminate_message
      end
      return
    end
    if @fade_out == false and $game_temp.message_text != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      reset_window
      refresh
      Graphics.frame_reset
      self.visible = true
      self.contents_opacity = 0
      if @input_number_window != nil
        @input_number_window.contents_opacity = 0
      end
      @fade_in = true
      return
    end
    if self.visible
      @fade_out = true
      self.opacity = 0
      if self.opacity == 0
        self.visible = false
        @fade_out = false
        $game_temp.message_window_showing = false
      end
      return
    end
  end
# ------------------------------------
  def update_cursor_rect
    if @index >= 0
      n = $game_temp.choice_start + @index
      self.cursor_rect.set(8, n * 30, @cursor_width, 32)
    else
      self.cursor_rect.empty
    end
  end
end

