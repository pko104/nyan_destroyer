require 'pry'
require 'gosu'
require_relative './lib/pig'
require_relative './lib/enemy'
require_relative './lib/bounding_box'
require_relative 'menu'
require_relative './lib/home'
require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 950)
    @state = :menu
    @summon_counter = 0
    @menu = Menu.new(self, 0, 0)


    @lane1 = [ ]
    @lane2 = [ ]
    @lane3 = [ ]
    @lane4 = [ ]
    @lane5 = [ ]
    @lane6 = [ ]
    @lane7 = [ ]
    @lane8 = [ ]
    @lane9 = [ ]
    @lane10 = [ ]
    @lane11 = [ ]
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
      @lane3.each { |enemy| enemy.draw }
      @lane4.each { |enemy| enemy.draw }
      @lane5.each { |enemy| enemy.draw }
      @lane6.each { |enemy| enemy.draw }
      @lane7.each { |enemy| enemy.draw }
      @lane8.each { |enemy| enemy.draw }
      @lane9.each { |enemy| enemy.draw }
      @lane10.each { |enemy| enemy.draw }
      @lane11.each { |enemy| enemy.draw }
    end
  end

  def update
    @lane1.each { |enemy| enemy.update }
    @lane2.each { |enemy| enemy.update }
    @lane3.each { |enemy| enemy.update }
    @lane4.each { |enemy| enemy.update }
    @lane5.each { |enemy| enemy.update }
    @lane6.each { |enemy| enemy.update }
    @lane7.each { |enemy| enemy.update }
    @lane8.each { |enemy| enemy.update }
    @lane9.each { |enemy| enemy.update }
    @lane10.each { |enemy| enemy.update }
    @lane11.each { |enemy| enemy.update }
    @summon_counter += 1
    summon_farmers

    pig_collided?
    player_won?
  end

  def player_won?
    if @grid.home.bounds.intersects?(@pig.bounds)
      @beep.play
      @state = :menu
      reset
    end
  end

  def pig_collided?
    [@lane1, @lane2, @lane3, @lane4, @lane5, @lane6, @lane7, @lane8, @lane9, @lane10, @lane11].each do |lane|
      lane.each do |enemy|
       if enemy.bounds.intersects?(@pig.bounds)
         @state = :menu
         reset
       end
      end
    end
  end

  def summon_farmers
    if (@summon_counter % 180 == 0) || (@summon_counter % 60 == 0)
      @lane2 << Enemy.new(self, 950, 700, -6)
    elsif (@summon_counter % 120 == 0) || (@summon_counter % 80 == 0)
      @lane3 << Enemy.new(self, 50, 650, 8)
    elsif (@summon_counter % 110 == 0) || (@summon_counter % 75 == 0)
      @lane4 << Enemy.new(self, 950, 600, -6)
    elsif (@summon_counter % 90 == 0) || (@summon_counter % 60 == 0)
      @lane1 << Enemy.new(self, 50, 750, 8)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane5 << Enemy.new(self, 50, 350, 10)
    end

    if (@summon_counter % 120 == 0) || (@summon_counter % 80 == 0)
      @lane6 << Enemy.new(self, 950, 500, -7)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane7 << Enemy.new(self, 50, 450, 9)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane8 << Enemy.new(self, 950, 300, -8)
    end

    if (@summon_counter % 40 == 0) || (@summon_counter % 80 == 0)
      @lane9 << Enemy.new(self, 950, 250, -12)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 30 == 0)
      @lane10 << Enemy.new(self, 50, 200, 14)
    end

    if (@summon_counter % 30 == 0) || (@summon_counter % 80 == 0)
      @lane11 << Enemy.new(self, 50, 400, 11)
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
    if id == Gosu::KbUp
      unless @pig.y <= 0
        @pig.y -= @pig.pig_speed
      end
    end
    if id == Gosu::KbDown
      unless @pig.y >= (1000 - @pig.pig_image.height)
        @pig.y += @pig.pig_speed
      end
    end
    if id == Gosu::KbLeft
      unless @pig.x <= 0
        @pig.x -= @pig.pig_speed
      end
    end
    if id == Gosu::KbRight
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
