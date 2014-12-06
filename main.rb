require 'gosu'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
  end

end

Game.new.show
