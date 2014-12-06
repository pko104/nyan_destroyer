require 'pry'
require 'gosu'

require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
  end

  def draw
    @grid.draw
  end

  def update

  end
end
Game.new.show
