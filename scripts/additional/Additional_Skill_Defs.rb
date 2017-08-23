module RPG
  class Skill
    attr_accessor :delay
    attr_accessor :drain
    attr_accessor :synapse
    attr_accessor :ft_power
    attr_accessor :ex_power
    attr_accessor :hp_absorb_percent
    attr_accessor :ft_absorb_percent
    attr_accessor :ex_absorb_percent
    def shaping_ability?
      return @occasion != 3
    end
    def auto_ability?
      return @occasion == 3 && @sp_cost >= 1
    end
    def command_ability?
      return @occasion == 3 && @sp_cost == 0
    end
  end
end