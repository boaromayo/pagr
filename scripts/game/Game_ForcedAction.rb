class Game_ForcedAction
  # -----------------------
  attr_accessor :type
  attr_accessor :target
  attr_accessor :nonfatiguing
  attr_accessor :add_a
  attr_accessor :add_b
  # -----------------------
  def initialize(type, target, nonfatiguing, add_a = -1, add_b = -1)
    @type = type
    @target = target
    @nonfatiguing = nonfatiguing
    @add_a = add_a
    @add_b = add_b
  end
end
