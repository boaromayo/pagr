module RPG
class Sprite < ::Sprite
# --------------------------------
 def damage(value, critical)
      damage_type = 1
      f = 32
      dispose_damage
      if value[0] == 95
        value.slice!(0)
        damage_type = 2
        value = value.to_i
      end
      if value[0] == 33
        value.slice!(0)
        damage_type = 3
        value = value.to_i
      end
      if value[0] == 94
        value.slice!(0)
        damage_type = 4
        value = value.to_i
      end
      if value[0] == 91
        damage_type = 5
      end
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
        f = 40
      else
        damage_string = value.to_s
      end
      bitmap = Bitmap.new(160, 60)
      bitmap.font.name = "High Tower Text"
      bitmap.font.size = f
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(-1, 12+1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12+1, 160, 36, damage_string, 1)
      if value.is_a?(Numeric) and value < 0
        case damage_type
          when 1
          bitmap.font.color.set(176, 255, 144)
          when 2
          bitmap.font.color.set(0, 255, 255)
          when 3
          bitmap.font.color.set(197, 35, 255)
          when 4
          bitmap.font.color.set(0, 188, 188)
          when 5
          bitmap.font.color.set(132, 156, 0)
        end
      else
         case damage_type
          when 1
          bitmap.font.color.set(255, 255, 255)
          when 2
          bitmap.font.color.set(255, 255, 0)
          when 3
          bitmap.font.color.set(255, 128, 0)
          when 4
          bitmap.font.color.set(255, 0, 185)
          when 5
          bitmap.font.color.set(132, 156, 0)
        end
      end
      bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
      @_damage_sprite = ::Sprite.new(self.viewport)
      @_damage_sprite.bitmap = bitmap
      @_damage_sprite.ox = 80
      @_damage_sprite.oy = 20
      @_damage_sprite.x = self.x
      @_damage_sprite.y = self.y - self.oy / 2
      @_damage_sprite.z = 3000
      @_damage_duration = 40
    end
  end
end
