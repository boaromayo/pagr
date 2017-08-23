module RPG
  class State
    attr_accessor :icon
    def fear
      return @name == "Fear"
    end
    def disease
      return @name == "Disease"
    end
    def sluggish
      return @name == "Sluggish"
    end
    def plague
      return @name == "Plague"
    end
    def fear
      return @name == "Fear"
    end
  end
end