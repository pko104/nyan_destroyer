require 'pry'
require 'gosu'
require_relative './lib/pig'
require_relative './lib/enemy'
require_relative './lib/bounding_box'

require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 900, 300)
    @state = :running

    @lane1 = [ Enemy.new(self, 500, 500, -5) ]
    @lane2 = [ Enemy.new(self, 500, 300, 5) ]
  end

  def draw
    if @state == :running
      @grid.draw
      @pig.draw
      @lane1.each { |enemy| enemy.draw }
      @lane2.each { |enemy| enemy.draw }
    end
  end

  def update
    @lane1.each { |enemy| enemy.update }
    @lane2.each { |enemy| enemy.update }
    pig_collided?
  end

  def pig_collided?
    [@lane1, @lane2].each do |lane|
      lane.each do |enemy|
        @state = :lost if enemy.bounds.intersects?(@pig.bounds)  
      end
    end
  end

end
Game.new.show
