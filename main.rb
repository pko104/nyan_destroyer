require 'gosu'
require_relative './lib/pig'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)

    # pig starting location
    @pig = Pig.new(self, 100, 600)
  end

  def draw
    @pig.draw
  end

  def update

  end
end

Game.new.show
