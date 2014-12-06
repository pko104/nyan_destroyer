require 'gosu'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
  end

  def draw
      put "test"
  end

  def update

  end
end

Game.new.show
