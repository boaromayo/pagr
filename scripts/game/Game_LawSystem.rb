class Game_LawSystem
# -----------------------
attr_accessor :lawskill
attr_accessor :facts
attr_accessor :caselaw
attr_accessor :documents
attr_accessor :witnesses
attr_accessor :set_facts
attr_accessor :set_documents
attr_accessor :set_caselaw
attr_accessor :available_depositions
attr_accessor :completed_depositions
attr_accessor :complete_sprite_frames
attr_accessor :last_eval
attr_accessor :highest_eval
attr_accessor :new_events
attr_accessor :unlocked
attr_reader   :pending_set_facts
attr_reader   :pending_set_documents
attr_reader   :pending_set_caselaw
attr_reader   :action_facts
attr_reader   :action_documents
attr_reader   :action_caselaw
attr_reader   :current_time
attr_reader   :total_time
attr_reader   :evaluation
# -----------------------
def initialize
  @pending_action_id = [0, 0, 0]
  @lawskill = 15
  @facts = []
  @documents = []
  @caselaw = []
  @witnesses = []
  @set_facts = []
  @set_documents = []
  @set_caselaw = []
  @action_facts = []
  @action_documents = []
  @action_caselaw = []
  @pending_set_facts = []
  @pending_set_documents = []
  @pending_set_caselaw = []
  @available_depositions = []
  @completed_depositions = []
  @new_facts = []
  @new_documents = []
  @new_caselaw = []
  @new_witnesses = []
  @new_events = []
  @complete_sprite_frames = -1
  @current_time = 0
  @total_time = 0
  @evaluation = 10
  @last_eval = 10
  @highest_eval = 10
  @law_se = "Audio/SE/complete.mp3"
  @unlocked = false
end
# -----------------------
def skill_level
  if @lawskill >= 1000
    return 5
  end
  if @lawskill >= 600
    return 4
  end
  if @lawskill >= 300
    return 3
  end
  if @lawskill >= 100
    return 2
  end
  return 1
end
# -----------------------
def skill_progress_percent
  if skill_level == 1
    s = 0
    n = 100
  end
  if skill_level == 2
    s = 100
    n = 300
  end
  if skill_level == 3
    s = 300
    n = 600
  end
  if skill_level == 4
    s = 600
    n = 1000
  end
  if skill_level == 5
    s = 1
    n = 1
  end
  progress = @lawskill - s
  need = n - s
  if need == 0
    need = 1
  end
  percent = progress * 100 / need
  if percent == 0
    percent = -1
  end
  if @lawskill >= 1000
    percent = -1
  end
  return percent
end
# -----------------------
def action_progress_percent
  c = @current_time
  t = @total_time
  if t == 0
    t = 1
  end
  percent = c * 100 / t
  return percent
end
# -----------------------
def skill_string
  a = @lawskill.to_s
  if skill_level == 1
    b = "100"
  end
  if skill_level == 2
    b = "300"
  end
  if skill_level == 3
    b = "600"
  end
  if skill_level == 4
    b = "1000"
  end
  if @lawskill < 1000
    return a + "/" + b
  else
    return "MASTER!"
  end
end
# -----------------------
def resolving_action
  a = ""
  b = ""
  if @pending_action_id[0] == 0
    return "None"
  end
  if @pending_action_id[0] == 1
    a = "Demand: "
    if @pending_action_id[1] == 1
      b = "---"
    end
    return a + b
  end
  if @pending_action_id[0] == 2
    a = "Research: "
    if @pending_action_id[1] == 1
      b = "---"
    end
    return a + b
  end
  if @pending_action_id[0] == 3
    a = "Depose: "
    if @pending_action_id[1] == 1
      b = "---"
    end
    return a + b
  end
  if @pending_action_id[0] == 4
    a = "Fusion: "
    if @pending_action_id[1] == 1
      b = "---"
    end
    if @pending_action_id[2] == 1
      b = " and ---"
    end
    return a + b
  end
  if @pending_action_id[0] == 99
    a = "Prepare Case"
    b = ""
    return a + b
  end
end
# -----------------------
def action_pending?
  if @pending_action_id[0] != 0
    return true
  end
  return false
end
# -----------------------
def time_necessary
  return 1000
end
# -----------------------
def set(type, param1, param2)
  @pending_action_id[0] = type
  @pending_action_id[1] = param1
  @pending_action_id[2] = param2
  @current_time = 0
  @total_time = time_necessary
end
# -----------------------
def advance_time(type)
  if action_pending?
    if type == 1
      t = rand(10) + 1
      t *= skill_level
      @current_time += t
    end
    if type == 2
      t = rand(100) + 1
      t *= 10
      t *= skill_level
      @current_time += t
    end
    if type == 3
      t = rand(1000) + 1
      t *= 10
      t *= skill_level
      @current_time += t
    end
    if type == 4
      @current_time = @total_time
    end
    if @current_time >= @total_time
      resolve_law_action
    end
  end
end
# -----------------------
def resolve_law_action
  finalize_configure_action
  action_results
  @action_facts = []
  @action_caselaw = []
  @action_documents = []
  @current_time = 0
  @total_time = 0
  @pending_action_id = [0, 0, 0]
  Audio.se_play(@law_se, 100, 100)
  @complete_sprite_frames = 200
end
# -----------------------
def toggle_fact(id)
  if @pending_set_facts.include?(id)
    @pending_set_facts.delete(id)
    return
  else
    @pending_set_facts.push(id)
    return
  end
end
# -----------------------
def toggle_document(id)
  if @pending_set_documents.include?(id)
    @pending_set_documents.delete(id)
    return
  else
    @pending_set_documents.push(id)
    return
  end
end
# -----------------------
def toggle_caselaw(id)
  if @pending_set_caselaw.include?(id)
    @pending_set_caselaw.delete(id)
    return
  else
    @pending_set_caselaw.push(id)
    return
  end
end
# -----------------------
def difference?
  for value in @pending_set_facts
    if not @set_facts.include?(value)
      return true
    end
  end
  for value in @pending_set_documents
    if not @set_documents.include?(value)
      return true
    end
  end
  for value in @pending_set_caselaw
    if not @set_caselaw.include?(value)
      return true
    end
  end
  for value in @set_facts
    if not @pending_set_facts.include?(value)
      return true
    end
  end
  for value in @set_documents
    if not @pending_set_documents.include?(value)
      return true
    end
  end
  for value in @set_caselaw
    if not @pending_set_caselaw.include?(value)
      return true
    end
  end
  return false
end
# -----------------------
def setup_configure_action
  for value in @pending_set_facts
    if not @set_facts.include?(value)
      @action_facts.push(value)
    end
  end
  for value in @pending_set_documents
    if not @set_documents.include?(value)
      @action_documents.push(value)
    end
  end
  for value in @pending_set_caselaw
    if not @set_caselaw.include?(value)
      @action_caselaw.push(value)
    end
  end
  for value in @set_facts
    if not @pending_set_facts.include?(value)
      v = value * -1
      @action_facts.push(v)
    end
  end
  for value in @set_documents
    if not @pending_set_documents.include?(value)
      v = value * -1
      @action_documents.push(v)
    end
  end
  for value in @set_caselaw
    if not @pending_set_caselaw.include?(value)
      v = value * -1
      @action_caselaw.push(v)
    end
  end
  set(99, 0, 0)
end
# -----------------------
def finalize_configure_action
  for value in @action_facts
    if value < 0
      @set_facts.delete(value.abs)
    else
      @set_facts.push(value)
    end
  end
  for value in @action_documents
    if value < 0
      @set_documents.delete(value.abs)
    else
      @set_documents.push(value)
    end
  end
  for value in @action_caselaw
    if value < 0
      @set_caselaw.delete(value.abs)
    else
      @set_caselaw.push(value)
    end
  end
end
# -----------------------
def setup_display
  @pending_set_facts = []
  @pending_set_documents = []
  @pending_set_caselaw = []
  for value in @set_facts
    @pending_set_facts.push(value)
  end
  for value in @set_documents
    @pending_set_documents.push(value)
  end
  for value in @set_caselaw
    @pending_set_caselaw.push(value)
  end
end
# -----------------------
def clear_pending
  @pending_set_facts = []
  @pending_set_documents = []
  @pending_set_caselaw = []
  for value in @set_facts
    @pending_set_facts.push(value)
  end
  for value in @set_documents
    @pending_set_documents.push(value)
  end
  for value in @set_caselaw
    @pending_set_caselaw.push(value)
  end
end
# -----------------------
def new_skills
  if @evaluation > @highest_eval
    x = 1
  end
  if @lawskill >= 35 
    if not $game_actors[10].skill_learn?(120)
      $game_actors[10].learn_skill(120)
      @new_events.push("Rhiaz learned Item-Focus!")
    end
  end
  if @new_documents.include?(1)
    $game_actors[10].learn_skill(20)
    @new_events.push("Rhiaz learned ----")
  end
  @new_facts = []
  @new_documents = []
  @new_caselaw = []
  @new_witnesses = []
  @highest_eval = @evaluation
end
# -----------------------
def action_results
  if @pending_action_id[0] == 1
    if @pending_action_id[1] == 1
      @documents.push(1)
      @new_documents.push(1)
      @new_events.push("Defense disclosed a new document!")
    end
  end
  @pending_action_id[0] = 0
  @pending_action_id[1] = 0
  @pending_action_id[2] = 0
end
# -----------------------
def update_evaluation
  e = 0
  if @set_facts.include?(1)
    e += 1
  end
  @evaluation = e
end
# -----------------------
end
