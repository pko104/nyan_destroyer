require 'pry'
require 'gosu'
require_relative './lib/pig'

require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 100, 600)
  end

  def draw
    @grid.draw
    @pig.draw
  end

  def update

  end
end
Game.new.show
