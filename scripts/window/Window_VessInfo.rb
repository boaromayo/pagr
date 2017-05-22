class Window_VessInfo < Window_Base
#-----------------------------
def initialize
  super(0, 384, 640, 96)
  self.contents = Bitmap.new(width - 32, height - 32)
  self.contents.font.name = "Arial"
  self.contents.font.size = 24
  show_data(0, 0)
end
#-----------------------------
def show_data(type, id)
  self.contents.clear
  if type == 0
    return
  end
  draw_flag = false
  if type == 1
    skill_name = ""
    current_value = ""
    current_ap = $game_system.current_ap_weapon[id]
    total_ap = $data_weapons[id].ap_needed
    if $data_weapons[id].associated_skill > 0
      skill = $data_skills[$data_weapons[id].associated_skill]
      skill_name = skill.name
      information = skill.description
      bitmap = RPG::Cache.icon(skill.icon_name)
      draw_flag = true
    end
    if $data_weapons[id].associated_stat >= 1
      points = $data_weapons[id].associated_value
      if current_ap < total_ap
        points_added = current_ap * points / total_ap
      end
      if current_ap == total_ap
        points_added = points
      end 
      if current_ap > total_ap
        points_added = points + (current_ap / 4 * points / total_ap)
      end
      if current_ap < 900000
        current_value = " (" + points_added.to_s + ")"
      end
    end
    if $data_weapons[id].associated_stat == 1
      points = $data_weapons[id].associated_value
      skill_name = "Strength+" + points.to_s + current_value
      information = "Raises Strength by " + points.to_s + "."
    end
    if $data_weapons[id].associated_stat == 2
      points = $data_weapons[id].associated_value
      skill_name = "Dexterity+" + points.to_s + current_value
      information = "Raises Dexterity by " + points.to_s + "."
    end
    if $data_weapons[id].associated_stat == 3
      points = $data_weapons[id].associated_value
      skill_name = "Agility+" + points.to_s + current_value
      information = "Raises Agility by " + points.to_s + "."
    end
    if $data_weapons[id].associated_stat == 4
      points = $data_weapons[id].associated_value
      skill_name = "Intelligence+" + points.to_s + current_value
      information = "Raises Intelligence by " + points.to_s + "."
    end
    if $data_weapons[id].associated_stat == 5
      points = $data_weapons[id].associated_value
      skill_name = "HP+" + points.to_s + current_value
      information = "Raises HP by " + points.to_s + "."
    end
    if $data_weapons[id].associated_stat == 6
      points = $data_weapons[id].associated_value
      skill_name = "Acumen Vectors+" + points.to_s + current_value
      if points == 1
        information = "Adds " + points.to_s + "Acumen Vector."
      end
      if points >= 2
        information = "Adds " + points.to_s + "Acumen Vectors."
      end
    end
    if draw_flag
      self.contents.blt(4, 0, bitmap, Rect.new(0, 0, 24, 24), opacity)
      self.contents.draw_text(32, 0, 212, 32, skill_name, 0)
    else
      self.contents.draw_text(4, 0, 212, 32, skill_name, 0)
    end
    if $game_system.current_ap_weapon[id] < 900000
      self.contents.draw_text(480, 0, 60, 32, current_ap.to_s, 2)
      self.contents.draw_text(540, 0, 8, 32, "/")
      self.contents.draw_text(548, 0, 60, 32, total_ap.to_s, 2)
    else
      self.contents.draw_text(516, 0, 112, 32, "Learned")
    end
    self.contents.draw_text(0, 32, 600, 32, information)
  end
  if type == 2
    skill_name = ""
    current_value = ""
    current_ap = $game_system.current_ap_armor[id]
    total_ap = $data_armors[id].ap_needed
    if $data_armors[id].associated_skill > 0
      skill = $data_skills[$data_armors[id].associated_skill]
      skill_name = skill.name
      information = skill.description
      bitmap = RPG::Cache.icon(skill.icon_name)
      draw_flag = true
    end
    if $data_armors[id].associated_stat >= 1
      points = $data_armors[id].associated_value
      if current_ap < total_ap
        points_added = current_ap * points / total_ap
      end
      if current_ap == total_ap
        points_added = points
      end 
      if current_ap > total_ap
        points_added = points + (current_ap / 4 * points / total_ap)
      end
      if current_ap < 900000
        current_value = " (" + points_added.to_s + ")"
      end
    end
    if $data_armors[id].associated_stat == 1
      points = $data_armors[id].associated_value
      skill_name = "Strength+" + points.to_s + current_value
      information = "Raises Strength by " + points.to_s + "."
    end
    if $data_armors[id].associated_stat == 2
      points = $data_armors[id].associated_value
      skill_name = "Dexterity+" + points.to_s + current_value
      information = "Raises Dexterity by " + points.to_s + "."
    end
    if $data_armors[id].associated_stat == 3
      points = $data_armors[id].associated_value
      skill_name = "Agility+" + points.to_s + current_value
      information = "Raises Agility by " + points.to_s + "."
    end
    if $data_armors[id].associated_stat == 4
      points = $data_armors[id].associated_value
      skill_name = "Intelligence+" + points.to_s + current_value
      information = "Raises Intelligence by " + points.to_s + "."
    end
    if $data_armors[id].associated_stat == 5
      points = $data_armors[id].associated_value
      skill_name = "HP+" + points.to_s + current_value
      information = "Raises HP by " + points.to_s + "."
    end
    if $data_armors[id].associated_stat == 6
      points = $data_armors[id].associated_value
      skill_name = "Acumen Vectors+" + points.to_s + current_value
      if points == 1
        information = "Adds " + points.to_s + " Acumen Vector."
      end
      if points >= 2
        information = "Adds " + points.to_s + " Acumen Vectors."
      end
    end
    if draw_flag
      self.contents.blt(4, 0, bitmap, Rect.new(0, 0, 24, 24), opacity)
      self.contents.draw_text(32, 0, 212, 32, skill_name, 0)
    else
      self.contents.draw_text(4, 0, 212, 32, skill_name, 0)
    end
    if $game_system.current_ap_armor[id] < 900000
      self.contents.draw_text(480, 0, 60, 32, current_ap.to_s, 2)
      self.contents.draw_text(540, 0, 8, 32, "/")
      self.contents.draw_text(548, 0, 60, 32, total_ap.to_s, 2)
    else
      self.contents.draw_text(516, 0, 112, 32, "Learned")
    end
    self.contents.draw_text(0, 32, 500, 32, information)
  end
end
#-----------------------------
end
