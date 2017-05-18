class Arrow_ActorSelect < Arrow_Base
#-------------------------------
def initialize(viewport)
  super(viewport)
  @index = -1
  move_right
end
#-------------------------------
def actor
  return $game_party.actors[@index]
end
#-------------------------------
def update
  if $game_party.all_dead?
    return
  end
  super
  if Input.repeat?(Input::RIGHT)
    move_right
  end
  if Input.repeat?(Input::LEFT)
    move_left
  end
  if self.actor != nil && !self.actor.dead?
    self.x = self.actor.screen_x
    self.y = self.actor.screen_y
  end
end
#-------------------------------
def move_right
  if @index >= 0
    $game_system.se_play($data_system.cursor_se)
  end
  @index += 1
  @index %= $game_party.actors.size
  while self.actor == nil || self.actor.dead?
    @index += 1
    @index %= $game_party.actors.size
  end
end
#-------------------------------
def move_left
  $game_system.se_play($data_system.cursor_se)
  @index += $game_party.actors.size - 1
  @index %= $game_party.actors.size
  while self.actor == nil || self.actor.dead?
    @index += $game_party.actors.size - 1
    @index %= $game_party.actors.size
  end
end
#-------------------------------
end
