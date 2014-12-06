require 'pry'
require 'gosu'
require_relative './lib/pig'
require_relative './lib/enemy'
require_relative './lib/bounding_box'
require_relative 'menu'
require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 900)
    @state = :menu
    @summon_counter = 0

    @menu = Menu.new(self, 0, 0)

    @lane1 = [ Enemy.new(self, 1000, 500, -5) ]
    @lane2 = [ Enemy.new(self, 0, 450, 5)]
  end

  def draw
    if @state == :menu
      @menu.draw
    end

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
    @summon_counter += 1
    summon_farmers

    pig_collided?
  end

  def pig_collided?
    [@lane1, @lane2].each do |lane|
      lane.each do |enemy|
       if enemy.bounds.intersects?(@pig.bounds)
         @state = :menu
         reset
       end
      end
    end
  end

  def summon_farmers
    if @summon_counter % 180 == 0
      @lane2 << Enemy.new(self, 1000, 500, -5)
    end
  end

  def reset
    @pig = Pig.new(self, 500, 900)
    @state = :menu
    @summon_counter = 0

    @menu = Menu.new(self, 0, 0)

    @lane1 = [ Enemy.new(self, 1000, 500, -5) ]
    @lane2 = [ Enemy.new(self, 0, 450, 5)]
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
    if id == Gosu::KbSpace
      @state = :running
    end

  end
end

Game.new.show
