class Scene_Law
# ---------------------
def main
  @c = []
  @d = []
  @l = []
  @f = []
  @w = []
  @fact_ids = []
  @document_ids = []
  @caselaw_ids = []
  @witness_ids = []
  @text_colors = []
  $game_lawsystem.setup_display
  $game_lawsystem.clear_pending
  @main_window = Window_Law.new
  get_commands
  @command_window = Window_Command.new(240, @c)
  @command_window.x = 16
  @command_window.y = 0
  @display_window = Window_LawDisplay.new
  @display_window.visible = false
  @info_window = Window_LawInfo.new
  @info_window.show_data(-1)
  @act_param1 = 0
  @act_param2 = 0
  @act_param3 = 0
  t1 = "Case elements have changed.  Are you"
  t2 = "sure you want to reorganize your case?"
  @events_window = Window_Base.new(120, 160, 414, 96)
  @events_window.contents = Bitmap.new(382, 64)
  @events_window.contents.font.name = "Arial"
  @events_window.contents.font.size = 24
  @events_window.z = 2000
  @events_window.visible = false
  @prepare_action_window = Window_Base.new(120, 160, 414, 96)
  @prepare_action_window.contents = Bitmap.new(382, 64)
  @prepare_action_window.contents.font.name = "Arial"
  @prepare_action_window.contents.font.size = 24
  @prepare_action_window.z = 2000
  @prepare_action_window.visible = false
  @prepare_action_window.contents.draw_text(4, 0, 382, 32, t1)
  @prepare_action_window.contents.draw_text(4, 32, 382, 32, t2)
  @other_action_window = Window_Base.new(120, 160, 414, 96)
  @other_action_window.contents = Bitmap.new(382, 64)
  @other_action_window.contents.font.name = "Arial"
  @other_action_window.contents.font.size = 24
  @other_action_window.z = 2000
  @other_action_window.visible = false
  @yes_no_window = Window_Command.new(100, ["Yes", "No"])
  @yes_no_window.x = 270
  @yes_no_window.y = 256
  @yes_no_window.z = 2000
  @yes_no_window.visible = false
  @end_after_confirm = false
  @first_fusion_chosen = false
  @events_complete = false
  disable_question_marks
  @last_info_index = 0
  @command_window.active = true
  $game_lawsystem.update_evaluation
  $game_lawsystem.new_skills
  $game_lawsystem.highest_eval = $game_lawsystem.evaluation
  @main_window.refresh
  get_facts
  get_documents
  get_caselaw
  get_witnesses
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
  @main_window.dispose
  @command_window.dispose
  @display_window.dispose
  @info_window.dispose
  @prepare_action_window.dispose
  @yes_no_window.dispose
end
# ---------------------
def update
  if not @events_complete
    check_events
  end
  if @display_window.index != @last_info_index
    update_information
    @last_info_index = @display_window.index
  end
  @main_window.update
  @command_window.update
  @display_window.update
  @info_window.update
  @prepare_action_window.update
  @yes_no_window.update
  $game_system.menu_encounters
  if @events_window.visible
    update_event
    return
  end
  if @command_window.active
    update_command
    return
  end
  if @display_window.active
    update_display
    return
  end
  if @yes_no_window.active
    update_confirm
    return
  end
end
# ---------------------
def update_event
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    @command_window.active = true
    @events_window.visible = false
  end
end
# ---------------------
def update_command
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @yes_no_window.y = 256
    if check_prepare_action
      @command_window.active = false
      @prepare_action_window.visible = true
      @yes_no_window.visible = true
      @yes_no_window.active = true
      @yes_no_window.index = 1
      @end_after_confirm = true
    else
      $game_lawsystem.last_eval = $game_lawsystem.evaluation
      $scene = Scene_Menu.new(3)
    end
    return
  end
  if Input.trigger?(Input::C)
    case @command_window.index
    when 0
      $game_system.se_play($data_system.decision_se)
      colors(1)
      update_information
      @command_window.active = false
      @display_window.fusion_mode = false
      @display_window.data = @f
      @main_window.display_header(1)
      @display_window.visible = true
      @display_window.active = true
      return
    when 1
      if $game_lawsystem.skill_level < 2
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(2)
        update_information
        @command_window.active = false
        @display_window.fusion_mode = false
        @display_window.data = @d
        @main_window.display_header(2)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 2
      if $game_lawsystem.skill_level < 2
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(4)
        update_information
        @display_window.fusion_mode = false
        @command_window.active = false
        if @fact_ids[0] == -1 && @document_ids[0] == -1
          @display_window.data = @f
        elsif @fact_ids[0] != -1 && @document_ids[0] == -1
          @display_window.data = @f
        elsif @fact_ids[0] == -1 && @document_ids[0] != -1
          @display_window.data = @d
        else
          @display_window.data = @f + @d
        end
        @main_window.display_header(5)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 3
      if $game_lawsystem.skill_level < 2
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(3)
        update_information
        @command_window.active = false
        @display_window.fusion_mode = false
        @display_window.data = @l
        @main_window.display_header(3)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 4
      if $game_lawsystem.skill_level < 2
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(4)
        @display_window.fusion_mode = false
        @command_window.active = false
        if @fact_ids[0] == -1 && @document_ids[0] == -1
          @display_window.data = @f
        elsif @fact_ids[0] != -1 && @document_ids[0] == -1
          @display_window.data = @f
        elsif @fact_ids[0] == -1 && @document_ids[0] != -1
          @display_window.data = @d
        else
          @display_window.data = @f + @d
        end
        @main_window.display_header(5)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 5
      if $game_lawsystem.skill_level < 3
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(5)
        update_information
        @command_window.active = false
        @display_window.fusion_mode = false
        @display_window.data = @w
        @main_window.display_header(4)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 6
      if $game_lawsystem.skill_level < 3
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(5)
        update_information
        @command_window.active = false
        @display_window.fusion_mode = false
        @display_window.data = @w
        @main_window.display_header(4)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 7
      if $game_lawsystem.skill_level < 4
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        colors(1)
        update_information
        @command_window.active = false
        @display_window.fusion_mode = true
        @display_window.data = @f
        @main_window.display_header(1)
        @display_window.visible = true
        @display_window.active = true
        return
      end
    when 8
    $game_system.se_play($data_system.decision_se)
    @yes_no_window.y = 256
    if check_prepare_action
      @command_window.active = false
      @prepare_action_window.visible = true
      @yes_no_window.visible = true
      @yes_no_window.active = true
      @yes_no_window.index = 1
      @end_after_confirm = true
    else
      $game_lawsystem.last_eval = $game_lawsystem.evaluation
      $scene = Scene_Menu.new(3)
    end
    return
    end
  end
end
# ---------------------
def update_display
  if Input.trigger?(Input::B)
    if @first_fusion_picked
      @first_fusion_picked = false
      @act_param3 = 0
      $game_system.se_play($data_system.cancel_se)
      @display_window.refresh
    else
      $game_system.se_play($data_system.cancel_se)
      @main_window.refresh
      @info_window.show_data(-1)
      @display_window.visible = false
      @display_window.active = false
      @command_window.active = true
    end
    return
  end
  if Input.trigger?(Input::C)
    case @command_window.index
    when 0
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @fact_ids[0] == -1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        if @fact_ids[@display_window.index] >= 0
          $game_system.se_play($data_system.decision_se)
          $game_lawsystem.toggle_fact(@fact_ids[@display_window.index])
          colors(1)
          @display_window.refresh
          return
        end
      end
    when 1
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @document_ids[0] == -1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        if @document_ids[@display_window.index] >= 0
          $game_system.se_play($data_system.decision_se)
          $game_lawsystem.toggle_document(@document_ids[@display_window.index])
          colors(2)
          @display_window.refresh
          return
        end
      end
    when 2
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @fact_ids[0] == -1 && @document_ids[0] == -1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        @act_param1 = 1
        $game_system.se_play($data_system.decision_se)
        if @display_window.index <= @fact_ids.size - 1
          @act_param2 = @fact_ids[@display_window.index]
        else
          @act_param2 = @document_ids[@display_window.index - @fact_ids.size]
        end
        @act_param3 = 0
        verify_action(1)
      end
    when 3
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @caselaw_ids[0] == -1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        $game_system.se_play($data_system.decision_se)
        if @caselaw_ids[@display_window.index] >= 0
          $game_system.se_play($data_system.decision_se)
          $game_lawsystem.toggle_caselaw(@caselaw_ids[@display_window.index])
          colors(3)
          @display_window.refresh
          return
        end
      end
    when 4
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @fact_ids[0] == -1 && @document_ids[0] == -1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        @act_param1 = 2
        $game_system.se_play($data_system.decision_se)
        if @display_window.index <= @fact_ids.size - 1
          @act_param2 = @fact_ids[@display_window.index]
        else
          @act_param2 = @document_ids[@display_window.index - @fact_ids.size]
        end
        @act_param3 = 0
        verify_action(2)
      end
      when 5
        $game_system.se_play($data_system.buzzer_se)
      when 6
        if $game_lawsystem.action_pending?
          $game_system.se_play($data_system.buzzer_se)
          return
        elsif @witness_ids[0] == -1
          $game_system.se_play($data_system.buzzer_se)
          return
        else
          @act_param1 = 3
          @act_param3 = 0
          $game_system.se_play($data_system.decision_se)
          @act_param2 = @witness_ids[@display_window.index]
          verify_action(3)
        end
      when 7
      if $game_lawsystem.action_pending?
        $game_system.se_play($data_system.buzzer_se)
        return
      elsif @fact_ids.size <= 1
        $game_system.se_play($data_system.buzzer_se)
        return
      else
        if @first_fusion_picked
          if @display_window.index == @fusion_index
            $game_system.se_play($data_system.buzzer_se)
          else
            @act_param1 = 4
            $game_system.se_play($data_system.decision_se)
            @act_param3 = @fact_ids[@display_window.index]
            verify_action(4)
          end
        else
          $game_system.se_play($data_system.decision_se)
          @act_param2 = @fact_ids[@display_window.index]
          @display_window.draw_fusion_cursor
          @fusion_index = @display_window.index
          @first_fusion_picked = true
        end
      end
    end
  end
end
# ---------------------
def update_confirm
  if Input.trigger?(Input::B)
    $game_system.se_play($data_system.cancel_se)
    @yes_no_window.active = false
    @yes_no_window.visible = false
    if @end_after_confirm
      @prepare_action_window.visible = false
      @end_after_confirm = false
      @command_window.active = true
    else
      @other_action_window.visible = false
      @display_window.active = true
    end
    return
  end
  if Input.trigger?(Input::C)
    case @yes_no_window.index
    when 0
    if @end_after_confirm
      $game_system.se_play($data_system.decision_se)
      $game_lawsystem.setup_configure_action
      $scene = Scene_Menu.new(3)
    else
      $game_system.se_play($data_system.decision_se)
      $game_lawsystem.set(@act_param1, @act_param2, @act_param3)
      @other_action_window.visible = false
      @display_window.visible = false
      @display_window.active = false
      @yes_no_window.visible = false
      @yes_no_window.active = false
      @command_window.active = true
      @main_window.refresh
      $game_lawsystem.clear_pending
    end
    when 1
    $game_system.se_play($data_system.decision_se)
    @yes_no_window.active = false
    @yes_no_window.visible = false
    if @end_after_confirm
      @prepare_action_window.visible = false
      @end_after_confirm = false
      @command_window.active = true
    else
      @other_action_window.visible = false
      @display_window.active = true
    end
    return
    end
  end
end
# ---------------------
def get_commands
  @c[0] = "Facts"
  @c[1] = "???"
  @c[2] = "???"
  @c[3] = "???"
  @c[4] = "???"
  @c[5] = "???"
  @c[6] = "???"
  @c[7] = "???"
  @c[8] = "Done"
  if $game_lawsystem.skill_level >= 2
    @c[1] = "Documents"
  end
  if $game_lawsystem.skill_level >= 2
    @c[2] = "Demand"
  end
  if $game_lawsystem.skill_level >= 2
    @c[3] = "Case Law"
  end
  if $game_lawsystem.skill_level >= 2
    @c[4] = "Research"
  end
  if $game_lawsystem.skill_level >= 3
    @c[5] = "Witnesses"
  end
  if $game_lawsystem.skill_level >= 3
    @c[6] = "Depose"
  end
  if $game_lawsystem.skill_level >= 4
    @c[7] = "Fusion"
  end
end
# ---------------------
def get_facts
  if $game_lawsystem.facts.include?(1)
    @f.push("Allegations of Unsafe Conditions")
    @fact_ids.push(1)
  end
  if $game_lawsystem.facts.include?(2)
    @f.push("Noisome Toxins Connected to Metzger's Claim")
    @fact_ids.push(2)
  end
  if $game_lawsystem.facts.include?(3)
    @f.push("Fact3")
    @fact_ids.push(3)
  end
  if $game_lawsystem.facts.include?(4)
    @f.push("Fact4")
    @fact_ids.push(4)
  end
  if $game_lawsystem.facts == []
    @f = ["None"]
    @fact_ids.push(-1)
  end
end
# ---------------------
def get_documents
  if $game_lawsystem.documents.include?(1)
    @d.push("Specterragon Environmental Analysis")
    @document_ids.push(1)
  end
  if $game_lawsystem.documents.include?(2)
    @d.push("Dummy")
  end
  if $game_lawsystem.documents == []
    @d = ["None"]
    @document_ids.push(-1)
  end
end
# ---------------------
def get_caselaw
  if $game_lawsystem.caselaw.include?(1)
    @l.push("Gideon v. Wainright")
    @caselaw_ids.push(1)
  end
  if $game_lawsystem.caselaw.include?(2)
    @l.push("Georgia v. Harrison Co.")
    @caselaw_ids.push(2)
  end
  if $game_lawsystem.caselaw == []
    @l = ["None"]
    @caselaw_ids.push(-1)
  end
end
# ---------------------
def get_witnesses
  if $game_lawsystem.witnesses.include?(1)
    @w.push("Bob")
    @witness_ids.push(1)
  end
  if $game_lawsystem.witnesses.include?(2)
    @w.push("John")
    @witness_ids.push(2)
  end
  if $game_lawsystem.witnesses == []
    @w = ["None"]
    @witness_ids.push(-1)
  end
end
# ---------------------
def disable_question_marks
  if $game_lawsystem.skill_level < 2
    @command_window.disable_item(1)
    @command_window.disable_item(2)
    @command_window.disable_item(3)
    @command_window.disable_item(4)
  end
  if $game_lawsystem.skill_level < 3
    @command_window.disable_item(5)
    @command_window.disable_item(6)
  end
  if $game_lawsystem.skill_level < 4
    @command_window.disable_item(7)
  end
end
# ---------------------
def colors(type)
  @text_colors = []
  counter = 0
  if type == 1
    for value in @fact_ids
      if $game_lawsystem.action_facts.include?(value)
        @text_colors[counter] = 1
        counter += 1
      elsif $game_lawsystem.action_facts.include?(value * -1)
        @text_colors[counter] = 2
        counter += 1
      elsif $game_lawsystem.pending_set_facts.include?(value)
        @text_colors[counter] = 3
        counter += 1
      else
        @text_colors[counter] = 0
        counter += 1
      end
    end
  end
  if type == 2
    for value in @document_ids
       if $game_lawsystem.action_documents.include?(value)
        @text_colors[counter] = 1
        counter += 1
      elsif $game_lawsystem.action_documents.include?(value * -1)
        @text_colors[counter] = 2
        counter += 1
      elsif $game_lawsystem.pending_set_documents.include?(value)
        @text_colors[counter] = 3
        counter += 1
      else
        @text_colors[counter] = 0
        counter += 1
      end
    end
  end
  if type == 3
    for value in @caselaw_ids
      if $game_lawsystem.action_caselaw.include?(value)
        @text_colors[counter] = 1
        counter += 1
      elsif $game_lawsystem.action_caselaw.include?(value * -1)
        @text_colors[counter] = 2
        counter += 1
      elsif $game_lawsystem.pending_set_caselaw.include?(value)
        @text_colors[counter] = 3
        counter += 1
      else
        @text_colors[counter] = 0
        counter += 1
      end
    end
  end
  if type == 4
    for value in @fact_ids
      if $game_lawsystem.action_facts.include?(value)
        @text_colors[counter] = 1
        counter += 1
      elsif $game_lawsystem.action_facts.include?(value * -1)
        @text_colors[counter] = 2
        counter += 1
      elsif $game_lawsystem.pending_set_facts.include?(value)
        @text_colors[counter] = 3
        counter += 1
      else
        @text_colors[counter] = 0
        counter += 1
      end
    end
      for value in @document_ids
      if $game_lawsystem.action_documents.include?(value)
        @text_colors[counter] = 1
        counter += 1
      elsif $game_lawsystem.action_documents.include?(value * -1)
        @text_colors[counter] = 2
        counter += 1
      elsif $game_lawsystem.pending_set_documents.include?(value)
        @text_colors[counter] = 3
        counter += 1
      else
        @text_colors[counter] = 0
        counter += 1
      end
    end
  end
  if type == 5
    for value in @witness_ids
      @text_colors[counter] = 0
      counter += 1
    end
  end
  @display_window.colors = @text_colors
end
# ---------------------
def check_prepare_action
  if $game_lawsystem.difference?
    return true
  end
  return false
end
# ---------------------
def update_information
  case @command_window.index
  when 0
    v = @fact_ids[@display_window.index]
    @info_window.show_data(v)
  when 1
    v = @document_ids[@display_window.index]
    @info_window.show_data(v + 100)
  when 2
    if @display_window.index <= @fact_ids.size - 1
      v = @fact_ids[@display_window.index]
      @info_window.show_data(v)
    else
      v = @document_ids[@display_window.index - @fact_ids.size]
      @info_window.show_data(v + 100)
    end
  when 3
    v = @caselaw_ids[@display_window.index]
    @info_window.show_data(v + 200)
  when 4
    if @display_window.index <= @fact_ids.size - 1
      v = @fact_ids[@display_window.index]
      @info_window.show_data(v)
    else
      v = @document_ids[@display_window.index - @fact_ids.size]
      @info_window.show_data(v + 100)
    end
  when 5
    v = @witness_ids[@display_window.index]
    @info_window.show_data(v + 300)
  when 6
    v = @witness_ids[@display_window.index]
    @info_window.show_data(v + 300)
  when 7
    v = @fact_ids[@display_window.index]
    @info_window.show_data(v)
  when 8
    addition = 0
    @info_window.show_data(-1)
  end
end
# ---------------------
def verify_action(type)
  t1 = ""
  t2 = ""
  @other_action_window.contents.clear
  if type == 1
    t1 = "Are you sure you want to demand documents pertaining to "
    if @display_window.index <= @fact_ids.size - 1
      t2 = @f[@display_window.index] + "?"
    else
      t2 = @d[@display_window.index] + "?"
    end
  end
  if type == 2
    t1 = "Are you sure you want to research case law that will support "
    if @display_window.index <= @fact_ids.size - 1
      t2 = @f[@display_window.index] + "?"
    else
      t2 = @d[@display_window.index] + "?"
    end
  end
  if type == 3
    t1 = "Are you sure you want to depose "
    t2 = @w[@display_window.index] + "?"
  end
  if type == 4
    t1 = "Are you sure you want to fuse "
    t2 = @f[@fusion_index] + " and " + @f[@display_window.index] + "?"
  end
  text = t1 + t2
  current_word = ""
  length = 0
  number = 0
  x = 4
  y = 0
  lines = ["", "", "", ""]
  @other_action_window = Window_Base.new(120, 160, 414, 160)
  @other_action_window.contents = Bitmap.new(382, 128)
  @other_action_window.contents.font.name = "Arial"
  @other_action_window.contents.font.size = 24
  for i in 0..text.length - 1
    letter = text[i, 1]
    current_word += letter
    w = @other_action_window.contents.text_size(letter).width
    @other_action_window.contents.draw_text(x, y, w+2, 32, letter)
    x += w
    if x >= 360
      x = 4
      y += 32
      number += 1
    end
    if letter == " " || i == text.length - 1
      lines[number] += current_word
      current_word = ""
    end
  end
  if lines[0] != ""
    @other_action_window.dispose
    @other_action_window = Window_Base.new(120, 160, 414, 64)
    @other_action_window.contents = Bitmap.new(382, 32)
    @other_action_window.contents.clear
    @other_action_window.contents.font.name = "Arial"
    @other_action_window.contents.font.size = 24
    @other_action_window.contents.draw_text(4, 0, 382, 32, lines[0])
  end
  if lines[1] != ""
    @other_action_window.dispose
    @other_action_window = Window_Base.new(120, 160, 414, 96)
    @other_action_window.contents = Bitmap.new(382, 64)
    @other_action_window.contents.clear
    @other_action_window.contents.font.name = "Arial"
    @other_action_window.contents.font.size = 24
    @other_action_window.contents.draw_text(4, 0, 382, 32, lines[0])
    @other_action_window.contents.draw_text(4, 32, 382, 32, lines[1])
  end
  if lines[2] != ""
    @other_action_window.dispose
    @other_action_window = Window_Base.new(120, 160, 414, 128)
    @other_action_window.contents = Bitmap.new(382, 96)
    @other_action_window.contents.clear
    @other_action_window.contents.font.name = "Arial"
    @other_action_window.contents.font.size = 24
    @other_action_window.contents.draw_text(4, 0, 382, 32, lines[0])
    @other_action_window.contents.draw_text(4, 32, 382, 32, lines[1])
    @other_action_window.contents.draw_text(4, 64, 382, 32, lines[2])
  end
  if lines[3] != ""
    @other_action_window.dispose
    @other_action_window = Window_Base.new(120, 160, 414, 160)
    @other_action_window.contents = Bitmap.new(382, 128)
    @other_action_window.contents.clear
    @other_action_window.contents.font.name = "Arial"
    @other_action_window.contents.font.size = 24
    @other_action_window.contents.draw_text(4, 0, 382, 32, lines[0])
    @other_action_window.contents.draw_text(4, 32, 382, 32, lines[1])
    @other_action_window.contents.draw_text(4, 64, 382, 32, lines[2])
    @other_action_window.contents.draw_text(4, 96, 382, 32, lines[3])
  end
  v = 480 - @other_action_window.height - @yes_no_window.height
  v /= 2
  @other_action_window.y = v
  @other_action_window.z = 2000
  @other_action_window.visible = true
  @display_window.active = false
  @yes_no_window.y = v + @other_action_window.height
  @yes_no_window.index = 1
  @yes_no_window.visible = true
  @yes_no_window.active = true
end
# ---------------------
def check_events
  s = $game_lawsystem.new_events.size
  if s > 0
    @events_window = Window_Base.new(120, 160, 414, 32 + s * 32)
    @events_window.contents = Bitmap.new(382, @events_window.height - 32)
    @events_window.contents.font.name = "Arial"
    @events_window.contents.font.size = 24
    @events_window.z = 2000
    y = 0
    for i in 0..$game_lawsystem.new_events.size - 1
      t = $game_lawsystem.new_events[i]
      @events_window.contents.draw_text(4, y, 382, 32, t)
      y += 32
    end
    $game_lawsystem.new_events = []
    @events_window.visible = true
    @command_window.active = false
  end
  @events_complete = true
end
# ---------------------
end
