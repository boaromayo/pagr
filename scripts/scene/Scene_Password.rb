class Scene_Password
  # -------------------------
  def main
    @actor = $game_actors[$game_temp.pass_actor_id]
    @bg_sprite = Sprite.new
    @bg_sprite.bitmap = RPG::Cache.panorama($game_temp.password_sprite, 0)
    @bg_sprite.z = 500
    @edit_window = Window_PassEdit.new(@actor, $game_temp.pass_max_char)
    @edit_window.z = 999
    @input_window = Window_EnterPassword.new
    @input_window.z = 999
    @header_window = Window_Base.new(0, 0, 640, 64)
    @header_window.contents = Bitmap.new(608, 32)
    @header_window.contents.font.name = "Arial"
    @header_window.contents.font.size = 24
    @header_window.z = 999
    t = $game_temp.password_header
    @header_window.contents.draw_text(4, 0, 600, 32, t)
    @header_window.visible = true
    @alert_window = Window_Base.new(188, 208, 264, 64)
    @alert_window.contents = Bitmap.new(228, 32)
    @alert_window.contents.font.name = "Arial"
    @alert_window.contents.font.size = 24
    alert = "You must enter a password."
    @alert_window.contents.draw_text(0, 0, 228, 32, alert)
    @alert_window.z = 1001
    @alert_window.visible = false
    c1 = "English"
    c2 = "Space"
    c3 = "Backspace"
    c4 = "Default"
    c5 = "Done"
    commands = [c1, c2, c3, c4, c5]
    @command_window = Window_PassCommand.new(160, commands)
    @input_window.active = false
    @input_window.visible = true
    @command_window.index = 0
    @command_window.visible = true
    @command_window.active = true
    @command_window.x = 0
    @command_window.y = 128
    @command_window.z = 1000
    @alert_count = 0
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
    @bg_sprite.dispose
    @edit_window.dispose
    @input_window.dispose
    @command_window.dispose
    @header_window.dispose
    @alert_window.dispose
  end
  # -------------------------
  def update
    @edit_window.update
    @input_window.update
    @command_window.update
    @alert_window.update
    if @alert_window.visible == true && @alert_count > 0
      @alert_count -= 1
      if @alert_count <= 0
        @command_window.active = true
        @alert_window.visible = false
      end
    return
    end
    if @input_window.active == false
      @command_window.active = true
    end
    if @command_window.active == false
      @input_window.active = true
    end
    if Input.repeat?(Input::B) && @input_window.active == true
      if @edit_window.index == 0
        return
      else
      $game_system.se_play($data_system.cancel_se)
      @edit_window.back
      end
    end
    if Input.repeat?(Input::B) && @command_window.active == true
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    if Input.trigger?(Input::C)
      if @command_window.active == true
        case @command_window.index
        when 0
        $game_system.se_play($data_system.decision_se)
        @input_window.refresh
        @command_window.active = false
        @input_window.active = true
        @input_window.index = 0
        return
        when 1
        if @edit_window.index < $game_temp.pass_max_char
          $game_system.se_play($data_system.decision_se)
          @edit_window.add(" ")
        else
          $game_system.se_play($data_system.buzzer_se)
        end
        return
        when 2
        $game_system.se_play($data_system.decision_se)
        @edit_window.back
        return
        when 3
        $game_system.se_play($data_system.decision_se)
        @edit_window.restore_default
        return
        when 4
        if @edit_window.name == ""
          $game_system.se_play($data_system.buzzer_se)
          @alert_window.visible = true
          @command_window.active = false
          @alert_count = 60
          return
        end
          $game_system.se_play($data_system.decision_se)
          @actor.name = @edit_window.name
          $game_system.se_play($data_system.decision_se)
          $scene = Scene_Map.new
          return
        end
       end
      if @edit_window.index == $game_temp.pass_max_char && 
        @input_window.active == true
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      if @input_window.character == "" && @input_window.active == true
        $game_system.se_play($data_system.buzzer_se)
        return
      end
     if @input_window.character != nil && @input_window.active == true &&
        @edit_window.index <= $game_temp.pass_max_char
      $game_system.se_play($data_system.decision_se)
      @edit_window.add(@input_window.character)
      end
      return
    end
  end
end

