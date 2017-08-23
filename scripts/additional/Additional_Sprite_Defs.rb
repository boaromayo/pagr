class RPG::Sprite
# ---------------------
def animation_set_sprites(sprites, cell_data, position)
  for i in 0..15
    sprite = sprites[i]
    pattern = cell_data[i, 0]
    if sprite == nil or pattern == nil or pattern == -1
      sprite.visible = false if sprite != nil
        next
      end
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
      if position == 3
        if self.viewport != nil
          sprite.x = self.viewport.rect.width / 2
          if self.viewport.rect.height == 320
            sprite.y = self.viewport.rect.height - 160
          else
            sprite.y = self.viewport.rect.height - 320
          end
        else
          sprite.x = 320
          sprite.y = 240
        end
      else
        sprite.x = self.x - self.ox + self.src_rect.width / 2
        sprite.y = self.y - self.oy + self.src_rect.height / 2
        sprite.y -= self.src_rect.height / 4 if position == 0
        sprite.y += self.src_rect.height / 4 if position == 2
      end
      sprite.x += cell_data[i, 1]
      sprite.y += cell_data[i, 2]
      sprite.z = 2000
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.angle = cell_data[i, 4]
      sprite.mirror = (cell_data[i, 5] == 1)
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
# ---------------------
end