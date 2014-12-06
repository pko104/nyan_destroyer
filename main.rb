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
    @pig = Pig.new(self, 500, 950)
    @state = :running
    @summon_counter = 0

    @lane1 = [ ]
    @lane2 = [ ]
    @lane3 = [ ]
    @lane4 = [ ]
  end

  def draw
    if @state == :running
      @grid.draw
      @pig.draw
      @lane1.each { |enemy| enemy.draw }
      @lane2.each { |enemy| enemy.draw }
      @lane3.each { |enemy| enemy.draw }
      @lane4.each { |enemy| enemy.draw }
    end
  end

  def update
    @lane1.each { |enemy| enemy.update }
    @lane2.each { |enemy| enemy.update }
    @lane3.each { |enemy| enemy.update }
    @lane4.each { |enemy| enemy.update }
    @summon_counter += 1
    summon_farmers

    pig_collided?
  end

  def pig_collided?
    [@lane1, @lane2, @lane3, @lane4].each do |lane|
      lane.each do |enemy|
        @state = :lost if enemy.bounds.intersects?(@pig.bounds)
      end
    end
  end

  def summon_farmers
    if (@summon_counter % 180 == 0) || (@summon_counter % 200 == 0)
      @lane2 << Enemy.new(self, 950, 700, -5)
    elsif (@summon_counter % 120 == 0) || (@summon_counter % 200 == 0)
      @lane3 << Enemy.new(self, 50, 650, 7)
    elsif (@summon_counter % 110 == 0) || (@summon_counter % 180 == 0)
      @lane4 << Enemy.new(self, 950, 600, -5)
    elsif (@summon_counter % 210 == 0) || (@summon_counter % 100 == 0)
      @lane1 << Enemy.new(self, 50, 750, 7)
    end

  end

  def button_down(id)
    if id == Gosu::KbW
      unless @pig.y <= 0
        @pig.y -= @pig.pig_speed
      end
    end
    if id == Gosu::KbS
      unless @pig.y >= (1000 - @pig.pig_image.height)
        @pig.y += @pig.pig_speed
      end
    end
    if id == Gosu::KbA
      unless @pig.x <= 0
        @pig.x -= @pig.pig_speed
      end
    end
    if id == Gosu::KbD
      unless @pig.x >= (1000 - @pig.pig_image.width)
        @pig.x += @pig.pig_speed
      end
    end
  end

  def button_up(id)
    if id == Gosu::KbW
      @pig.move_up = false
    end
    if id == Gosu::KbS
      @pig.move_down = false
    end
    if id == Gosu::KbA
      @pig.move_left = false
    end
    if id == Gosu::KbD
      @pig.move_right = false
    end
  end

end
Game.new.show
