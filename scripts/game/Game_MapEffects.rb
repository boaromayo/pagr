class Game_MapEffects
# ---------------------
attr_accessor :effects
attr_accessor :refresh_flag
attr_accessor :double
attr_accessor :multiplier
# ---------------------
def initialize
  @effects = []
  @multiplier = 1
  @refresh_flag = false
  @double = false
  setup
end
# ---------------------
def setup
  @effects[0] = Game_MapEffect.new("Cartesian Psychoplane", "skill07", 1200)
  @effects[1] = Game_MapEffect.new("Anamalous Cognition", "skill01", 2400)
end
# ---------------------
def start(effect_id)
  @effects[effect_id].start
  @multiplier = 1
end
# ---------------------
def stop(effect_id)
  @effects[effect_id].stop
end
# ---------------------
def pause(effect_id)
  @effects[effect_id].pause
end
# ---------------------
def unpause(effect_id)
  @effects[effect_id].unpause
end
# ---------------------
def query(effect_id)
  return @effects[effect_id].running?
end
# ---------------------
def stop_all
  for effect in @effects
    effect.stop
  end
end
# ---------------------
def pause_all
  for effect in @effects
    effect.pause
  end
end
# ---------------------
def unpause_all
  for effect in @effects
    effect.unpause
  end
end
# ---------------------
def decrement_all
  for effect in @effects
    effect.decrement
  end
end
# ---------------------
def number_running
  result = 0
  for effect in @effects
    if effect.running?
      result += 1
    end
  end
  return result
end
# ---------------------
def kill_infinite
  for effect in @effects
    if effect.duration >= 100000
      effect.stop
    end
  end
end
# ---------------------
end
