class Spriteset_Map
  # ------------------
  def initialize
    @scroll_point_x = 0
    @scroll_point_y = 0
    @scroll_frames_x = 0
    @scroll_frames_y = 0
    @scroll_speed_x = $game_system.autoscroll_x_speed
    @scroll_speed_y = $game_system.autoscroll_y_speed
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 200
    @viewport3.z = 5000
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
    for i in 0..6
      autotile_name = $game_map.autotile_names[i]
      @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
    end
    @tilemap.map_data = $game_map.data
    @tilemap.priorities = $game_map.priorities
    @panorama1 = Plane.new(@viewport1)
    @panorama1.z = -1000
    @fog = Plane.new(@viewport1)
    @fog.z = 3000
    @character_sprites = []
    @lawaction_sprite = Sprite.new
    @lawaction_sprite.bitmap = Bitmap.new("Graphics/Stuff/law01.png")
    @lawaction_sprite.x = 410
    @lawaction_sprite.y = 440
    @lawaction_sprite.visible = false
    for i in $game_map.events.keys.sort
      sprite = Sprite_Character.new(@viewport1, $game_map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @weather = RPG::Weather.new(@viewport1)
    @picture_sprites = []
    for i in 1..50
      @picture_sprites.push(Sprite_Picture.new(@viewport2,
        $game_screen.pictures[i]))
    end
    @timer_sprite = Sprite_Timer.new
    update
  end
  # ------------------
  def dispose
    @tilemap.tileset.dispose
    for i in 0..6
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    @panorama1.dispose
    @fog.dispose
    for sprite in @character_sprites
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
  end
  # ------------------
  def update
    if $game_map.new_tileset == true
      @tilemap.tileset = RPG::Cache.tileset($game_map.tileset_name)
      @tilemap.priorities = $game_map.priorities
      for i in 0..6
        autotile_name = $game_map.autotile_names[i]
        @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
      end
      $game_map.new_tileset = false
    end
    if $game_system.autoscroll_x_speed != @scroll_speed_x
      @scroll_speed_x = $game_system.autoscroll_x_speed
    end
    if $game_system.autoscroll_y_speed != @scroll_speed_y
      @scroll_speed_y = $game_system.autoscroll_y_speed
    end
    if @panorama_name != $game_map.panorama_name or
       @panorama_hue != $game_map.panorama_hue
      @panorama_name = $game_map.panorama_name
      @panorama_hue = $game_map.panorama_hue
      if @panorama1.bitmap != nil
        @panorama1.bitmap.dispose
        @panorama1.bitmap = nil
      end
      if @panorama1_name != ""
        @panorama1.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
      end
      Graphics.frame_reset
    end
    scroll
    if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue
      @fog_name = $game_map.fog_name
      @fog_hue = $game_map.fog_hue
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
      end
      Graphics.frame_reset
    end
    @tilemap.ox = $game_map.display_x / 4
    @tilemap.oy = $game_map.display_y / 4
    @tilemap.update
    if $game_system.autoscroll_x_speed == 0
      if $game_system.autoscroll_y_speed == 0
        if $game_system.panorama_fix == false
          @panorama1.ox = $game_map.display_x / 8
          @panorama1.oy = $game_map.display_y / 8
        else
          @panorama1.ox = 0
          @panorama1.oy = 0
        end
      end
    end
    a = $game_system.autoscroll_x_speed != 0
    b = $game_system.autoscroll_y_speed != 0
    if a or b
      @panorama1.ox = @scroll_point_x
      @panorama1.oy = @scroll_point_y
    end
    @fog.zoom_x = $game_map.fog_zoom / 100.0
    @fog.zoom_y = $game_map.fog_zoom / 100.0
    @fog.opacity = $game_map.fog_opacity
    @fog.blend_type = $game_map.fog_blend_type
    @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
    @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy
    @fog.tone = $game_map.fog_tone
    for sprite in @character_sprites
      sprite.update
    end
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.ox = $game_map.display_x / 4
    @weather.oy = $game_map.display_y / 4
    @weather.update
    for sprite in @picture_sprites
      sprite.update
    end
    if $game_lawsystem.complete_sprite_frames >= 0
      v = $game_lawsystem.complete_sprite_frames / 10
      if v % 2 == 0
        @lawaction_sprite.visible = true
      else
        @lawaction_sprite.visible = false
      end
      $game_lawsystem.complete_sprite_frames -= 1
      if $game_lawsystem.complete_sprite_frames == 0
        @lawaction_sprite.visible = false
        $game_lawsystem.complete_sprite_frames = -1
      end
    end
    @timer_sprite.update
    @viewport1.tone = $game_screen.tone
    @viewport1.ox = $game_screen.shake
    @viewport3.color = $game_screen.flash_color
    @viewport1.update
    @viewport3.update
  end
  # ----------------------
  def scroll
    w = @panorama1.bitmap.width
    h = @panorama1.bitmap.height
    @scroll_frames_x += @scroll_speed_x
    @scroll_frames_y += @scroll_speed_y
    while @scroll_frames_x >= 8
      @scroll_frames_x -= 8
      @scroll_point_x += 1
    end
    while @scroll_frames_x <= -8
      @scroll_frames_x += 8
      @scroll_point_x -= 1
    end
    while @scroll_frames_y >= 8
      @scroll_frames_y -= 8
      @scroll_point_y += 1
    end
    while @scroll_frames_y <= -8
      @scroll_frames_y += 8
      @scroll_point_y -= 1
    end
    if @scroll_point_x > w
      @scroll_point_x -= w
    end
    if @scroll_point_x < -w
      @scroll_point_x += w
    end
    if @scroll_point_y > h
      @scroll_point_y -= h
    end
    if @scroll_point_y < -h
      @scroll_point_y += h
    end
  end
end
