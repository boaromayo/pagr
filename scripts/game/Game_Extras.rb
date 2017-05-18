class Game_Extras
# -----------------------
attr_accessor :music_cds
attr_accessor :battle_dvds
attr_accessor :minigames
attr_accessor :monster_info
attr_accessor :backgrounds
# -----------------------
def initialize
  @music_cds = []
  @battle_dvds = []
  @monster_info = []
  @minigames = []
  @backgrounds = [0]
end
# -----------------------
def extras_unlocked?
  result = false
  if @music_cds.size > 0
    result = true
  end
  if @battle_dvds.size > 0
    result = true
  end
  if @monster_info.size > 0
    result = true
  end
  if @minigames.size > 0
    result = true
  end
  if @backgrounds.size > 1
    result = true
  end
  return result
end
# -----------------------
def types_unlocked
  types = []
  if @music_cds.size > 0
    types.push(1)
  end
  if @battle_dvds.size > 0
    types.push(2)
  end
  if @minigames.size > 0
    types.push(3)
  end
  if @monster_info.size > 0
    types.push(4)
  end
  return types
end
# -----------------------
end
