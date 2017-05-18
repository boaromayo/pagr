class Game_ItemBag
# -----------------------
def initialize
  @itembags = []
  @itembags[0] = []
  for i in 1..10
    @itembags[i] = []
  end
  @itembags[0][0] = -1
  for i in 1..10
    @itembags[i][0] = -1
  end
end
# -----------------------
def create(id)
  @itembags[id][0] = $game_party.gold
  for weapon in $data_weapons
    number = weapon.id
    @itembags[id][number] = $game_party.weapon_number(number)
  end
  for armor in $data_armors
    number = armor.id
    @itembags[id][number + 1000] = $game_party.armor_number(number)
  end
  for item in $data_items
    number = item.id
    @itembags[id][number + 2000] = $game_party.item_number(number)
  end
  @itembags[id][3000] = $game_system.item_remain
  @itembags[id][3001] = $game_system.shaping_remain
  @itembags[id][3002] = $game_system.ability_remain
  @itembags[id][3003] = $game_system.omni_remain
  $game_party.lose_gold(9999999)
  for weapon in 1..$data_weapons.size - 1
    $game_party.lose_weapon(weapon, 99)
  end
  for armor in 1..$data_armors.size - 1
    $game_party.lose_armor(armor, 99)
  end
  for item in 1..$data_items.size - 1
    $game_party.lose_item(item, 99)
  end
  $game_system.item_remain = 0
  $game_system.shaping_remain = 0
  $game_system.ability_remain = 0
  $game_system.omni_remain = 0
end
# -----------------------
def replace(id, delete_bag = true)
  if @itembags[id][0] == -1
    print("Warning: This item bag does not exist.")
    return
  end
  $game_party.lose_gold(9999999)
  $game_party.gain_gold(@itembags[id][0])
  for weapon in 1..$data_weapons.size - 1
    $game_party.lose_weapon(weapon, 99)
  end
  for armor in 1..$data_armors.size - 1
    $game_party.lose_armor(armor, 99)
  end
  for item in 1..$data_items.size - 1
    $game_party.lose_item(item, 99)
  end
  for weapon in 1..$data_weapons.size - 1
    $game_party.gain_weapon(weapon, @itembags[id][weapon])
  end
  for armor in 1..$data_armors.size - 1
    $game_party.gain_armor(armor, @itembags[id][armor + 1000])
  end
  for item in 1..$data_items.size - 1
    $game_party.gain_item(item, @itembags[id][item + 2000])
  end
  $game_system.item_remain = @itembags[id][3000]
  $game_system.shaping_remain = @itembags[id][3001]
  $game_system.ability_remain = @itembags[id][3002]
  $game_system.omni_remain = @itembags[id][3003]
  if delete_bag
    delete(id)
  end
end
# -----------------------
def merge(id1, id2)
  if id2 != -1 && @itembags[id1][0] == -1 && @itembags[id2][0] == -1
    print("Warning: Neither item bag to be merged exists.")
    return
  end
  if @itembags[id1][0] == -1
    print("Warning: The first item bag to be merged does not exist")
    return
  end
  if id2 != -1
    if @itembags[id2][0] == -1
      print("Warning: The second item bag to be merged does not exist")
      return
    end
  end
  if id2 == -1
    $game_party.gain_gold(@itembags[id1][0])
    for weapon in 1..$data_weapons.size - 1
      $game_party.gain_weapon(weapon, @itembags[id1][weapon])
    end
    for armor in 1..$data_armors.size - 1
      $game_party.gain_armor(armor, @itembags[id1][armor + 1000])
    end
    for item in 1..$data_items.size - 1
      $game_party.gain_item(item, @itembags[id1][item + 2000])
    end
    $game_system.item_remain = @itembags[id1][3000]
    $game_system.shaping_remain = @itembags[id1][3001]
    $game_system.ability_remain = @itembags[id1][3002]
    $game_system.omni_remain = @itembags[id1][3003]
    delete(id1)
  end
  if id2 != -1
    @itembags[id1][0] += @itembags[id2][0]
    for weapon in 1..$data_weapons.size - 1
      @itembags[id1][weapon] += @itembags[id2][weapon]
    end
    for armor in 1..$data_armors.size - 1
      @itembags[id1][armor + 1000] += @itembags[id2][armor + 1000]
    end
    for item in 1..$data_items.size - 1
      @itembags[id1][item + 2000] += @itembags[id2][item + 2000]
    end
    @itembags[id1][3000] += @itembags[id2][3000]
    @itembags[id1][3001] += @itembags[id2][3001]
    @itembags[id1][3002] += @itembags[id2][3002]
    @itembags[id1][3003] += @itembags[id2][3003]
    delete(id2)
  end
end
# -----------------------
def merge_all(mode)
  if mode != 1 && mode != 2
    print("Merge All: Invalid mode.")
    return
  end
  flag = true
  for i in 1..10
    if @itembags[i][0] != -1
      flag = false
    end
  end
  if flag
    print("Warning: No item bags to merge.")
    return
  end
  if mode == 1
    for i in 1..10
      if @itembags[i][0] == -1
        next
      end
      $game_party.gain_gold(@itembags[i][0])
      for weapon in 1..$data_weapons.size - 1
        $game_party.gain_weapon(weapon, @itembags[i][weapon])
      end
      for armor in 1..$data_armors.size - 1
        $game_party.gain_armor(armor, @itembags[i][armor + 1000])
      end
      for item in 1..$data_items.size - 1
        $game_party.gain_item(item, @itembags[i][item + 2000])
      end
      $game_system.item_remain += @itembags[i][3000]
      $game_system.shaping_remain += @itembags[i][3001]
      $game_system.ability_remain += @itembags[i][3002]
      $game_system.omni_remain += @itembags[i][3003]
      delete(i)
    end
  end
  if mode == 2
    if @itembags[1][0] == -1
      @itembags[1][0] = 0
    end
    for i in 2..10
      if @itembags[i][0] == -1
        next
      end
      @itembags[id1][0] += @itembags[id2][0]
      for weapon in 1..$data_weapons.size - 1
        @itembags[1][weapon] += @itembags[i][weapon]
      end
      for armor in 1..$data_armors.size - 1
        @itembags[1][armor + 1000] += @itembags[i][armor + 1000]
      end
      for item in 1..$data_items.size - 1
        @itembags[1][item + 2000] += @itembags[i][item + 2000]
      end
      @itembags[1][3000] += @itembags[i][3000]
      @itembags[1][3001] += @itembags[i][3001]
      @itembags[1][3002] += @itembags[i][3002]
      @itembags[1][3003] += @itembags[i][3003]
      delete(i)
    end
  end
end

# -----------------------
def copy(source_id, destination_id)
  @itembags[destination_id][0] = @itembags[source_id][0]
  for i in 0..3003
    @itembags[destination_id][i] = @itembags[source_id][i]
  end
end
# -----------------------
def delete(id)
  for i in 0..3003
    @itembags[id][i] = 0
  end
  @itembags[id][0] = -1
end
# -----------------------
end
