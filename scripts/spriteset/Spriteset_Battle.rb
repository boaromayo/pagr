#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :viewport1
  attr_reader   :viewport2
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites
  attr_accessor :battleback_sprite
  attr_accessor :countdown_sprites
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @viewport1 = Viewport.new(0, 0, 640, 320)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport4 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 101
    @viewport3.z = 9999
    @viewport4.z = 5000
    @battleback_sprite = Sprite.new(@viewport1)
    @hp_sprites = []
    @enemy_sprites = []
    @combo_sprites = []
    for enemy in $game_troop.enemies.reverse
      @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
    end
    @combo_delay = -1
    @combo_sprites[0] = ""
    @combo_sprites[1] = ""
    for i in 2..10
      if i <= 9
        s = "0" + i.to_s
      end
      if i == 10
        s = "10"
      end
      @combo_sprites[i] = Sprite.new
      @combo_sprites[i].bitmap = Bitmap.new("Graphics/Stuff/combo" + s)
      @combo_sprites[i].x = 420
      @combo_sprites[i].y = 40
      @combo_sprites[i].visible = false
    end
    for i in 0..$game_troop.enemies.size - 1
      base_img = Bitmap.new("Graphics/Stuff/scan01.png")
      monster_img = RPG::Cache.battler($game_troop.enemies[i].battler_name, 0)
      w = monster_img.width
      h = monster_img.height
      @hp_sprites[i] = Sprite.new
      @hp_sprites[i].bitmap = base_img
      @hp_sprites[i].x = $game_troop.enemies[i].screen_x - 30
      @hp_sprites[i].y = $game_troop.enemies[i].screen_y - h - 15
      @hp_sprites[i].z = 2999
      @hp_sprites[i].visible = false
    end
    @actor_sprites = []
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @actor_sprites.push(Sprite_Battler.new(@viewport2))
    @countdown_sprites = []
    for i in 0..3
      @countdown_sprites.push(Sprite.new(@viewport2))
      if $game_party.actors[i] != nil
        @countdown_sprites[i].x = $game_party.actors[i].screen_x - 12
        @countdown_sprites[i].y = $game_party.actors[i].screen_y - 75
      else
        @countdown_sprites[i].x = 0
        @countdown_sprites[i].y = 0
      end
      @countdown_sprites[i].z = 200
      @countdown_sprites[i].bitmap = Bitmap.new(48,48)
      @countdown_sprites[i].bitmap.font.name = "Tw Cen MT"
      @countdown_sprites[i].bitmap.font.size = 28
    end
    @weather = RPG::Weather.new(@viewport1)
    @picture_sprites = []
    for i in 51..100
      @picture_sprites.push(Sprite_Picture.new(@viewport3,
        $game_screen.pictures[i]))
    end
    @timer_sprite = Sprite_Timer.new
    update
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if @battleback_sprite.bitmap != nil
      @battleback_sprite.bitmap.dispose
    end
    @battleback_sprite.dispose
    for sprite in @enemy_sprites + @actor_sprites
      sprite.dispose
    end
    for sprite in @hp_sprites
      sprite.dispose
    end
    @weather.dispose
    for sprite in @picture_sprites
      sprite.dispose
    end
    @timer_sprite.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
    @viewport4.dispose
  end
  #--------------------------------------------------------------------------
  # ● エフェクト表示中判定
  #--------------------------------------------------------------------------
  def effect?(battlers)
    for sprite in @enemy_sprites + @actor_sprites
      if battlers.include?(sprite.battler)
        return true if sprite.effect?
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if @combo_delay >= 0
      @combo_delay -= 1
      if @combo_delay == 0
        remove_combo
      end
    end
    @actor_sprites[0].battler = $game_party.actors[0]
    @actor_sprites[1].battler = $game_party.actors[1]
    @actor_sprites[2].battler = $game_party.actors[2]
    @actor_sprites[3].battler = $game_party.actors[3]
    if @battleback_name != $game_temp.battleback_name
      @battleback_name = $game_temp.battleback_name
      if @battleback_sprite.bitmap != nil
        @battleback_sprite.bitmap.dispose
      end
      @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
      @battleback_sprite.src_rect.set(0, 0, 640, 320)
    end
    for sprite in @enemy_sprites + @actor_sprites
      sprite.update
    end
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.update
    for sprite in @picture_sprites
      sprite.update
    end
    @timer_sprite.update
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    @viewport4.color = $game_screen.flash_color
    @viewport1.update
    @viewport2.update
    @viewport4.update
  end
  # ----------------------------------
  def pause_effect
    @battleback_sprite.tone = Tone.new(-20, -20, -20, 0)
    @actor_sprites[0].tone = Tone.new(-20, -20, -20, 0)
    @actor_sprites[1].tone = Tone.new(-20, -20, -20, 0)
    @actor_sprites[2].tone = Tone.new(-20, -20, -20, 0)
    @actor_sprites[3].tone = Tone.new(-20, -20, -20, 0)
    for i in 0..@enemy_sprites.size - 1
      @enemy_sprites[i].tone = Tone.new(-20, -20, -20, 0)
    end
    for i in 0..49
      @picture_sprites[i].tone = Tone.new(-20, -20, -20, 0)
    end
  end
  # ----------------------------------
  def unpause_effect
    @battleback_sprite.tone = Tone.new(0, 0, 0, 0)
    @actor_sprites[0].tone = Tone.new(0, 0, 0, 0)
    @actor_sprites[1].tone = Tone.new(0, 0, 0, 0)
    @actor_sprites[2].tone = Tone.new(0, 0, 0, 0)
    @actor_sprites[3].tone = Tone.new(0, 0, 0, 0)
    for i in 0..@enemy_sprites.size - 1
      @enemy_sprites[i].tone = Tone.new(0, 0, 0, 0)
    end
    for i in 0..49
      @picture_sprites[i].tone = Tone.new(0, 0, 0, 0)
    end
  end
  # ----------------------------------
  def hp_bars
    green = Color.new(0, 200, 0, 255)
    for i in 0..$game_troop.enemies.size - 1
      t = $game_troop.enemies[i]
      if t.show_hp_bar and t.exist?
        base_img = Bitmap.new("Graphics/Stuff/scan01.png")
        @hp_sprites[i].visible = true
        h = $game_troop.enemies[i].hp
        m = $game_troop.enemies[i].maxhp
        length = h * 100 / m
        @hp_sprites[i].bitmap.clear
        @hp_sprites[i].bitmap = base_img
        @hp_sprites[i].bitmap.fill_rect(14, 3, length, 6, green)
      else
        @hp_sprites[i].visible = false
      end
    end
  end
  # ----------------------------------
  def show_combo_sprite(level)
    @combo_sprites[level].visible = true
    @combo_delay = 125
  end
  # ----------------------------------
  def remove_combo
    @combo_delay = -1
    for i in 2..10
      @combo_sprites[i].visible = false
    end
  end
  # ----------------------------------
end
