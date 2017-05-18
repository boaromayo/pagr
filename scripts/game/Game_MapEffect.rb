class Game_MapEffect
# ---------------------
attr_reader :name
attr_reader :icon
attr_reader :duration
attr_reader :max_duration
# ---------------------
def initialize(name, icon, duration)
  @name = name
  @icon = RPG::Cache.icon(icon)
  @duration = 0
  @max_duration = duration
  @paused = false
end
# ---------------------
def start
  @real_duration = @max_duration * $game_mapeffects.multiplier
  @duration = @real_duration
  @paused = false
end
# ---------------------
def stop
  @duration = 0
  @paused = false
  $game_mapeffects.refresh_flag = true
end
# ---------------------
def pause
  if duration > 0
    @paused = true
    $game_mapeffects.refresh_flag = true
  end
end
# ---------------------
def unpause
  @paused = false
  $game_mapeffects.refresh_flag = true
end
# ---------------------
def running?
  if @paused
    return false
  end
  if @duration == 0
    return false
  end
  return true
end
# ---------------------
def decrement
  @duration -= 1
  if @duration == 0
    stop
  end
end
# ---------------------
def get_duration_string
  max = @real_duration / 40
  cur = @duration / 40
  string = cur.to_s + "/" + max.to_s
  if @real_duration > 1000000
    string = "∞/∞"
  end
  return string
end
# ---------------------
end
